import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:task_project/settings/color_resource.dart';

class Widgets {
  Widget customAppBar({
    required BuildContext context,
    bool? isVisibleIcon,
    bool? isVisibleText,
    required Function() logoutFunction,
    required Function() backFunction,
    String? labelText,
  }) {
    return Container(
      decoration: const BoxDecoration(color: ColorResource.color2E3B5F),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    isVisibleIcon == true
                        ? GestureDetector(
                            onTap: () => backFunction(),
                            child: const Icon(Icons.arrow_back_ios,
                                color: ColorResource.colorFFFFFF))
                        : const SizedBox(),
                    const Spacer(),
                    isVisibleText == true
                        ? GestureDetector(
                            onTap: () => logoutFunction(),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                    height:
                                        MediaQuery.of(context).size.height / 11,
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    decoration: const BoxDecoration(
                                        color: Colors.transparent)),
                                const Positioned(
                                    right: -1,
                                    top: -1,
                                    child: MyArc(diameter: 150)),
                                const Positioned(
                                    right: 15,
                                    top: 20,
                                    child: Text('Logout',
                                        style: TextStyle(
                                            fontFamily: 'Roboto-Regular',
                                            color: ColorResource.colorFFFFFF)))
                              ],
                            ),
                          )
                        : GestureDetector(
                            onTap: () => logoutFunction,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                    height:
                                        MediaQuery.of(context).size.height / 11,
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    decoration: const BoxDecoration(
                                        color: Colors.transparent)),
                                const Positioned(
                                    right: -1,
                                    top: -1,
                                    child: MyArc(diameter: 150)),
                                // const Positioned(
                                //     right: 15,
                                //     top: 20,
                                //     child: Text('Logout',
                                //         style: TextStyle(
                                //             fontFamily: 'Roboto-Regular',
                                //             color: ColorResource.colorFFFFFF)))
                              ],
                            ),
                          )
                  ],
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height / 11,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.0),
                          topRight: Radius.circular(35.0)),
                      color: ColorResource.color000000))
            ],
          ),
          Positioned(
              top: 50.0,
              left: 110.0,
              child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 2.5,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(labelText!,
                        style: const TextStyle(
                            color: ColorResource.colorFFFFFF,
                            fontSize: 30,
                            fontFamily: 'Roboto-Regular')),
                  )))
        ],
      ),
    );
  }

  labelTextLine(String? values) {
    return Text(values!,
        style: const TextStyle(
            color: ColorResource.colorFFFFFF,
            fontSize: 20,
            fontFamily: 'Roboto-Regular'));
  }

  editingTextFormField(TextEditingController controllerValues) {
    return TextFormField(
      controller: controllerValues,
      cursorColor: ColorResource.colorFFFFFF,
      style: const TextStyle(color: ColorResource.colorFFFFFF),
      decoration: InputDecoration(
          errorStyle: const TextStyle(fontSize: 11.0),
          isDense: true,
          fillColor: ColorResource.color2E3B5F,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none)),
    );
  }
}

Widget customButton(
    {Function()? btnFunction,
    String? labelText,
    required BuildContext context}) {
  return ConstrainedBox(
    constraints: BoxConstraints.tightFor(
        width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.height / 15),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: ColorResource.color3E3E3E,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0))),
      child: Text(labelText!,
          style: const TextStyle(
              color: ColorResource.colorFFFFFF,
              fontSize: 25,
              fontFamily: 'Roboto-Regular')),
      onPressed: () => btnFunction,
    ),
  );
}

cardView(BuildContext context, String? value1, String? value2, String? value3) {
  return Card(
      color: ColorResource.color121212,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              direction: Axis.vertical,
              children: [
                Text(value1!,
                    style: const TextStyle(
                        color: ColorResource.colorFFFFFF,
                        fontSize: 15,
                        fontFamily: 'Roboto-Regular')),
                Text('IP  ${value2!}',
                    style: const TextStyle(
                        color: ColorResource.colorFFFFFF,
                        fontSize: 15,
                        fontFamily: 'Roboto-Regular'))
              ],
            ),
            Container(
                height: MediaQuery.of(context).size.height / 7,
                width: MediaQuery.of(context).size.width / 4.3,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: ColorResource.colorFFFFFF),
                child: QrImage(
                    data: value3!, version: QrVersions.auto, size: 200.0))
          ],
        ),
      ));
}

class MyArc extends StatelessWidget {
  final double diameter;

  const MyArc({Key? key, this.diameter = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: MyPainter(), size: Size(diameter, diameter));
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = ColorResource.color3d3a6a;
    canvas.drawCircle(const Offset(110, 15), 60, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
