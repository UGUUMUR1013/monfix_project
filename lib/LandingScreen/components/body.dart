import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monfix_project/LandingScreen/components/control_button.dart';
import 'package:monfix_project/LandingScreen/components/default_button.dart';
import 'package:monfix_project/SensorScreen/Sensor_screen.dart';
// import 'package:smart_home/LandingScreen/components/control_button.dart';
// import 'package:smart_home/LandingScreen/components/default_button.dart';
// import 'package:smart_home/SensorScreen/sensor_screen.dart';

import '../../constants.dart';

class LandingScreenBody extends StatefulWidget {
  @override
  _LandingScreenBodyState createState() => _LandingScreenBodyState();
}

class _LandingScreenBodyState extends State<LandingScreenBody> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height: size.height * 0.1),
          Center(
            child: Text(
              'Амар аппликейшн\n"Алсаас гэрээ удирд"',
              // 'What do you think you\'ll\nmostly use?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 25,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.05),
          Center(
            child: Text(
              'Та хэрэгсэлээ сонгон удирдах хэсэг рүү шилжилнэ үү.',
              textAlign: TextAlign.center,
              style: TextStyle(color: kDarkGreyColor, fontSize: 18),
            ),
          ),
          SizedBox(height: size.height * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ControlButton(
                size: size,
                title: 'Том өрөө',
                icon: Icons.home_outlined,
              ),
              ControlButton(
                size: size,
                title: 'WiFi\n ',
                icon: Icons.wifi_tethering_rounded,
              ),
              ControlButton(
                size: size,
                title: 'Гэрэл\nудиодлага',
                icon: Icons.lightbulb_outline,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ControlButton(
                size: size,
                title: 'Бойлуур\nудирдлага',
                icon: Icons.opacity,
              ),
              ControlButton(
                size: size,
                title: 'Гал зуух ',
                icon: Icons.local_fire_department,
              ),
              ControlButton(
                size: size,
                title: 'Хүлэмж\n',
                icon: Icons.cabin_outlined,
              ),
            ],
          ),
          SizedBox(height: size.height * 0.05),
          DefaultButton(
            size: size,
            title: "Үргэлжлүүлэх",
            press: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SensorScreen(),
                ),
              );
            },
          ),
          SizedBox(height: size.height * 0.05),
        ],
      ),
    );
  }
}
