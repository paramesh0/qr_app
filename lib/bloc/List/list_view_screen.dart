import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_project/base/base.dart';
import 'package:task_project/bloc/List/list_screen_bloc.dart';
import 'package:task_project/router.dart';
import 'package:task_project/settings/color_resource.dart';
import 'package:task_project/widgets/widget_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen>
    with SingleTickerProviderStateMixin {
  late ListBloc bloc;
  TabController? tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime now = DateTime.now();
  String? today;
  String? yesterdayValues;
  DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ListBloc>(context);
    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    var formatter = DateFormat('yyyy-MM-dd');
    today = formatter.format(now);
    yesterdayValues = formatter.format(yesterday);
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Widgets().customAppBar(
                              context: context,
                              isVisibleIcon: true,
                              isVisibleText: true,
                              backFunction: () {
                                Navigator.pop(context);
                              },
                              logoutFunction: () {
                                signOut();
                              },
                              labelText: 'Last Login'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.3,
                            height: MediaQuery.of(context).size.height / 24.3,
                            child: TabBar(
                              labelColor: ColorResource.colorFFFFFF,
                              indicatorColor: ColorResource.colorFFFFFF,
                              unselectedLabelColor: Colors.white54,
                              controller: tabController,
                              indicatorSize: TabBarIndicatorSize.label,
                              isScrollable: true,
                              labelStyle: const TextStyle(
                                  color: ColorResource.colorFFFFFF,
                                  fontSize: 15,
                                  fontFamily: 'Roboto-Regular'),
                              tabs: const [
                                Text('Today'),
                                Text('Yesterday'),
                                Text('Last Login'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 1.5,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TabBarView(
                                controller: tabController,
                                children: [
                                  todayListView(),
                                  yesterdayListView(),
                                  pastListView(),
                                ],
                              ),
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
                  onPressed: () async {},
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  todayListView() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where("date", isEqualTo: today)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? const Center(
                  child: Text('PLease Wait',
                      style: TextStyle(
                          color: ColorResource.colorFFFFFF,
                          fontSize: 15,
                          fontFamily: 'Roboto-Regular')),
                )
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 6,
                      width: double.infinity,
                      child: cardView(
                          context,
                          snapshot.data!.docs[index].get('time'),
                          snapshot.data!.docs[index].get('IP'),
                          snapshot.data!.docs[index].get('generateNUmber')),
                    );
                  },
                );
        });
  }

  yesterdayListView() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where("date", isEqualTo: yesterdayValues)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? const Center(
                  child: Text(
                    'PLease Wait',
                    style: TextStyle(
                        color: ColorResource.colorFFFFFF,
                        fontSize: 15,
                        fontFamily: 'Roboto-Regular'),
                  ),
                )
              : (snapshot.data!.docs.isNotEmpty
                  ? ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 6,
                          width: double.infinity,
                          child: cardView(
                              context,
                              snapshot.data!.docs[index].get('time'),
                              snapshot.data!.docs[index].get('IP'),
                              snapshot.data!.docs[index].get('generateNUmber')),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No more data',
                        style: TextStyle(
                            color: ColorResource.colorFFFFFF,
                            fontSize: 15,
                            fontFamily: 'Roboto-Regular'),
                      ),
                    ));
        });
  }

  pastListView() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where("date", isLessThan: yesterdayValues)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? const Center(
                  child: Text('PLease Wait',
                      style: TextStyle(
                          color: ColorResource.colorFFFFFF,
                          fontSize: 15,
                          fontFamily: 'Roboto-Regular')),
                )
              : (snapshot.data!.docs.isNotEmpty
                  ? ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 6,
                          width: double.infinity,
                          child: cardView(
                              context,
                              snapshot.data!.docs[index].get('time'),
                              snapshot.data!.docs[index].get('IP'),
                              snapshot.data!.docs[index].get('generateNUmber')),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No more data',
                          style: TextStyle(
                              color: ColorResource.colorFFFFFF,
                              fontSize: 15,
                              fontFamily: 'Roboto-Regular')),
                    ));
        });
  }

  signOut() async {
    _auth.signOut().then((value) async =>
        await Navigator.pushNamed(context, AppRoutes.landingScreen));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
