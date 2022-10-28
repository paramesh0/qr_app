import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:task_project/base/base.dart';
import 'package:task_project/bloc/plugin_screen/plugin_bloc.dart';
import 'package:task_project/model/albums_list.dart';
import 'package:task_project/router.dart';
import 'package:task_project/settings/color_resource.dart';
import 'package:task_project/widgets/widget_utils.dart';
import 'dart:math';

class PluginScreen extends StatefulWidget {
  const PluginScreen({Key? key}) : super(key: key);

  @override
  _PluginScreenState createState() => _PluginScreenState();
}

class _PluginScreenState extends State<PluginScreen> {
  late PluginBloc bloc;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpNumberController = TextEditingController();
  String? randomNUmber;
  String? ipValues;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Uint8List? imageInUnit8ListValue;
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<PluginBloc>(context);
    createRandomNUmber();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: bloc,
      listener: (BuildContext context, BaseState state) async {
        if (state is SuccessState) {
          if (state.successResponse is String) {
            toQrImageData(randomNUmber!);
          }
          if (state.successResponse is IPValues) {
            final IPValues iPResponse = state.successResponse;
            ipValues = iPResponse.ip;
          }
        }
      },
      child: BlocBuilder(
        bloc: bloc,
        builder: (BuildContext context, BaseState state) {
          if (state is LoadingState) {
            return loadingWidget();
          }
          return SafeArea(
            child: Scaffold(
              backgroundColor: ColorResource.color000000,
              body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraint) {
                  return GestureDetector(
                    onTap: () {
                      final FocusScopeNode currentFocus =
                          FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Widgets().customAppBar(
                              context: context,
                              isVisibleIcon: false,
                              isVisibleText: true,
                              backFunction: () {
                                null;
                              },
                              logoutFunction: () {
                                signOut();
                              },
                              labelText: 'plugin'),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 25, right: 25),
                            child: Stack(
                              children: [
                                Container(
                                    height: MediaQuery.of(context).size.height /
                                        2.2,
                                    width: double.infinity,
                                    color: Colors.transparent),
                                Positioned(
                                    bottom: 10,
                                    left: 25,
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.3,
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/image_1.png'),
                                              fit: BoxFit.fill),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ))),
                                const Positioned(
                                    bottom: 105,
                                    left: 55,
                                    child: Text('Generate Number',
                                        style: TextStyle(
                                            color: ColorResource.colorFFFFFF,
                                            fontSize: 30,
                                            fontFamily: 'Roboto-Regular'))),
                                Positioned(
                                    bottom: 40,
                                    left: 125,
                                    child: Text(randomNUmber!,
                                        style: const TextStyle(
                                            color: ColorResource.colorFFFFFF,
                                            fontSize: 30,
                                            fontFamily: 'Roboto-Regular'))),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: QrImage(
                                          data: randomNUmber!,
                                          version: QrVersions.auto,
                                          size: 200.0)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              bottomNavigationBar: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: MediaQuery.of(context).size.width / 1,
                    height: MediaQuery.of(context).size.height / 15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: ColorResource.color3E3E3E,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0))),
                  child: const Text('Save',
                      style: TextStyle(
                          color: ColorResource.colorFFFFFF,
                          fontSize: 25,
                          fontFamily: 'Roboto-Regular')),
                  onPressed: () async {
                    await collectionReference.add({
                      'IP': ipValues,
                      'generateNUmber': randomNUmber,
                      'date': bloc.date,
                      'time': bloc.time
                    });

                    await Navigator.pushNamed(context, AppRoutes.listScreen);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  createRandomNUmber() {
    var rng = Random();
    var code = rng.nextInt(90000) + 10000;
    randomNUmber = code.toString();
  }

  loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(
        backgroundColor: ColorResource.color121212,
        valueColor: AlwaysStoppedAnimation(Colors.white),
        strokeWidth: 5,
      ),
    );
  }

  signOut() {
    _auth.signOut().then((value) async =>
        await Navigator.pushNamed(context, AppRoutes.landingScreen));
  }

  Future<Uint8List> toQrImageData(String text) async {
    try {
      final image = await QrPainter(
        data: text,
        version: QrVersions.auto,
        gapless: false,
        color: ColorResource.color000000,
        emptyColor: ColorResource.colorFFFFFF,
      ).toImage(300);
      final a = await image.toByteData(format: ImageByteFormat.png);
      imageInUnit8ListValue = a!.buffer.asUint8List();
      return a.buffer.asUint8List();
    } catch (e) {
      throw e;
    }
  }

/*getImageFile() async {
    Uint8List? imageInUnit8List = imageInUnit8ListValue ;
     var tempDir = await getTemporaryDirectory();
    File file = tempDir.path as File;
    file.writeAsBytesSync(imageInUnit8List);
  }*/

}
