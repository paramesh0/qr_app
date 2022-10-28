import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_project/base/base.dart';
import 'package:task_project/bloc/login/login_bloc.dart';
import 'package:task_project/router.dart';

import 'package:task_project/settings/color_resource.dart';
import 'package:task_project/settings/preferences.dart';
import 'package:task_project/widgets/widget_utils.dart';

class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({Key? key}) : super(key: key);

  @override
  _AlbumsScreenState createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  late AlbumsBloc bloc;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpNumberController = TextEditingController();
  dynamic firebaseVerificationId;
  final FirebaseAuth auth = FirebaseAuth.instance;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<AlbumsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: bloc,
      listener: (BuildContext context, BaseState state) async {
        if (state is SuccessState) {
          if (state.successResponse is String) {
            setState(() {});
          }
        }
      },
      child: BlocBuilder(
        bloc: bloc,
        builder: (BuildContext context, BaseState state) {
          if (state is LoadingState) {}
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
                                isVisibleText: false,
                                backFunction: () {
                                  null;
                                },
                                logoutFunction: () {
                                  null;
                                },
                                labelText: 'LOGIN'),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 45.0, right: 45.0, top: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Widgets().labelTextLine('Phone Number'),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25),
                                  TextFormField(
                                      controller: phoneNumberController,
                                      cursorColor: ColorResource.colorFFFFFF,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.number,
                                      onEditingComplete: () {
                                        /*try{
                                          print('welcome');

                                        }catch(e){
                                          const snackBar = SnackBar(
                                            backgroundColor:ColorResource.color2E3B5F ,
                                            content: Text('Please enter valid number' ,style: TextStyle(
                                                color: ColorResource.colorFFFFFF)),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }*/
                                        phoneNumberVerification(
                                            phoneNumberController.text);
                                      },
                                      style: const TextStyle(
                                          color: ColorResource.colorFFFFFF),
                                      validator: (value) =>
                                          validateMobile(value!),
                                      decoration: InputDecoration(
                                          errorStyle: const TextStyle(
                                              fontSize: 11.0,
                                              color: ColorResource.colorFFFFFF),
                                          isDense: true,
                                          fillColor: ColorResource.color2E3B5F,
                                          filled: true,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide.none))),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25),
                                  Widgets().labelTextLine('OTP'),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25),
                                  TextFormField(
                                    controller: otpNumberController,
                                    cursorColor: ColorResource.colorFFFFFF,
                                    style: const TextStyle(
                                        color: ColorResource.colorFFFFFF),
                                    decoration: InputDecoration(
                                        errorStyle:
                                            const TextStyle(fontSize: 11.0),
                                        isDense: true,
                                        fillColor: ColorResource.color2E3B5F,
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide.none)),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5),
                                  /*customButton(
                                    labelText: 'LOGIN',
                                      context: context,
                                    btnFunction: ()   {
                                      print('---------welcome');
                                      // await Navigator.pushNamed(context, AppRoutes.landingScreen);
                                    },

                                  ),*/
                                  ConstrainedBox(
                                    constraints: BoxConstraints.tightFor(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                15),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: ColorResource.color3E3E3E,
                                          onPrimary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0))),
                                      child: const Text('LOGIN',
                                          style: TextStyle(
                                              color: ColorResource.colorFFFFFF,
                                              fontSize: 25,
                                              fontFamily: 'Roboto-Regular')),
                                      onPressed: () async {
                                        try {
                                          PhoneAuthCredential credential =
                                              PhoneAuthProvider.credential(
                                                  verificationId:
                                                      firebaseVerificationId,
                                                  smsCode:
                                                      otpNumberController.text);
                                          await auth
                                              .signInWithCredential(credential);

                                          var formatter =  DateFormat('yyyy-MM-dd');
                                        String  formattedDate = formatter.format(now);
                                          var formatterTime = DateFormat('hh:mm a');
                                          String actualTime = formatterTime.format(now);
                                          Map data={
                                            'Date':formattedDate,
                                            'Time':actualTime
                                          };
                                          await Navigator.pushNamed(
                                              context, AppRoutes.pluginScreen,arguments:data );
                                          Preferences.setLoginStatus(
                                              'LoginSuccess');
                                        } catch (e) {
                                          displaySnackBar(
                                              'Please enter valid OTP');
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )),
          );
        },
      ),
    );
  }

  displaySnackBar(String? values) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: ColorResource.color2E3B5F,
      content: Text(values!,
          style: const TextStyle(color: ColorResource.colorFFFFFF)),
    ));
  }

  String? validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  phoneNumberVerification(String? values) async {
    return await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${values!}',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // final res = await auth.signInWithCredential(credential);
      },
      verificationFailed: (authException) {
        displaySnackBar(authException.message!);
      },
      codeSent: (String verificationId, int? resendToken) {
        firebaseVerificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
