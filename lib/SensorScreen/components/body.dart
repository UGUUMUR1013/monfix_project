import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monfix_project/SensorScreen/components/custom_card.dart';
//import 'package:smart_home/SensorScreen/components/custom_card.dart';
import '../../constants.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../../model/Home.dart';

class SensorScreenBody extends StatefulWidget {
  @override
  _SensorScreenBodyState createState() => _SensorScreenBodyState();
}

class _SensorScreenBodyState extends State<SensorScreenBody> {
  String temp = '-';
  String humi = '-';
  late Timer _timer;

  @override
  void initState() {
    //loadData();
    startTimer();
    super.initState();
  }

  void startTimer() {
    const tenSec = Duration(seconds: 10);
    _timer = Timer.periodic(tenSec, (timer) async {
      List<Home> tempHome = await fetchHome();
      setState(() {
        temp = tempHome[0].temp;
        humi = tempHome[0].humi;
      });
    });
  }

  Future<List<Home>> fetchHome() async {
    final response = await http.get(Uri.parse(
        'https://thingspeak.com/channels/1956546/feeds.json?results=1'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<Home> homeList = [];
      var tempJsonData = jsonDecode(response.body);
      print('Json: ${tempJsonData['feeds']}');
      for (int i = 0; i < tempJsonData['feeds'].length; i++) {
        Home home = Home.fromJson(tempJsonData['feeds'][i]);
        homeList.add(home);
      }
      print(homeList[0].humi);

      return homeList;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.menu,
                    size: 30,
                    color: kDarkGreyColor,
                  ),
                  Text(
                    'Нүүр хуудас',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'Poppings',
                    ),
                  ),
                  Container(
                    height: size.height * 0.045,
                    width: size.width * 0.095,
                    decoration: BoxDecoration(
                      color: kBgColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.notifications_none,
                      color: kDarkGreyColor,
                    ),
                  )
                ],
              ),
              SizedBox(height: size.height * 0.03),
              Row(
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/images/profile_picture.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.05),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'арваннэгдүгээр 28, 2022',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Д.Батлут танд энэ\nөдрийн мэнд хүргэе.',
                        style: TextStyle(
                          color: kBlueColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          fontFamily: 'Poppings',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.05),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // crossAxisAlignment: CrossAxisAlignment,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$temp°',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 105, 102, 102),
                            ),
                          ),
                          Text(
                            'температур',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontFamily: 'Poppings',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$humi%',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 105, 102, 102),
                            ),
                          ),
                          Text(
                            'чийгшилийн хувь',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontFamily: 'Poppings',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomCard(
                    size: size,
                    icon: Icon(
                      Icons.home_outlined,
                      size: 55,
                      color: Colors.grey.shade400,
                    ),
                    title: "Том Өрөө",
                    statusOn: "Нээх",
                    statusOff: "Хаах",
                  ),
                  InkWell(
                    child: CustomCard(
                      size: size,
                      icon: Icon(
                        Icons.lightbulb_outline,
                        size: 55,
                        color: Colors.grey.shade400,
                      ),
                      title: "Гэрэл удирдлага",
                      statusOn: "Асаах",
                      statusOff: "Унтраах",
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.025),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomCard(
                    size: size,
                    icon: Icon(
                      //Icons.opacity,
                      Icons.local_fire_department,
                      size: 55,
                      color: Colors.grey.shade400,
                    ),
                    title: "Гал зуух",
                    statusOn: "DETECTED",
                    statusOff: "NOT DETECTED",
                  ),
                  CustomCard(
                    size: size,
                    icon: Icon(
                      // Icons.thermostat_outlined,
                      Icons.opacity_rounded,
                      size: 55,
                      color: Colors.grey.shade400,
                    ),
                    title: "Бойлер",
                    statusOn: "Залгах",
                    statusOff: "Салгах",
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.025),
              Container(
                height: 75,
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: kBgColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(3, 3),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 0,
                      offset: Offset(-3, -3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "нэмэх",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: kOrangeColor,
                            ),
                          ),
                          Text(
                            "шинэ төхөөрөмж",
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppings',
                            ),
                          )
                        ],
                      ),
                      Icon(
                        Icons.add,
                        size: 40,
                        color: kOrangeColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future loadData() async {
  //   String jsonString = await getJsonFromFirebaseRestAPI();
  //   setState(() {
  //     if (jsonString == "\"motion detected\"") {
  //       showDialog<String>(
  //         context: context,
  //         builder: (BuildContext context) => AlertDialog(
  //           title: const Text('Motion detection status:'),
  //           content: const Text('The motion has detected!'),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () => Navigator.pop(context, 'OK'),
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //   });
  // }
}

// Future<String> getJsonFromFirebaseRestAPI() async {
//   String url =
//       'https://iot-home-security-5265f-default-rtdb.firebaseio.com/status.json';
//   http.Response response = await http.get(Uri.parse(url));
//   return response.body;
// }
