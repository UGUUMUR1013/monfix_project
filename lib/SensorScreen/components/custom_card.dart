import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;

import '../../model/Relay.dart';

class CustomCard extends StatefulWidget {
  const CustomCard(
      {Key? key,
      required this.size,
      required this.icon,
      required this.title,
      required this.statusOn,
      required this.statusOff})
      : super(key: key);

  final Size size;
  final Icon icon;
  final String title;
  final String statusOn;
  final String statusOff;

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Alignment> _animation;
  bool isChecked = true;
  int lampOn = 0;
  int boilerOn = 0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
    );

    _animation = Tween<Alignment>(
            begin: Alignment.bottomCenter, end: Alignment.topCenter)
        .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
        reverseCurve: Curves.easeInBack,
      ),
    );
    super.initState();
  }

  Future<Relay> fetchRelay() async {
    final url = Uri.parse(
        'https://thingspeak.com/channels/1956752/feeds.json?results=1');

    final url1Get = Uri.parse('https://e-erdenet.mn/heater/get.php');
    final response = await http.get(url1Get);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<Relay> relList = [];
      var tempJsonData = jsonDecode(response.body);
      print('Json: ${tempJsonData['feeds']}');
      for (int i = 0; i < tempJsonData['feeds'].length; i++) {
        Relay home = Relay.fromJson(tempJsonData['feeds'][i]);
        relList.add(home);
      }
      print(relList[0].rel1);

      return relList[0];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<void> sendSwitchingData({required String type}) async {
    Response response;
    final url1 = 'https://e-erdenet.mn/heater/index.php?';
    final url1think =
        'https://api.thingspeak.com/update?api_key=AY73H8DOG38DSPNU';

    Relay relay = await fetchRelay();
    int tempVar = 0;
    if (type == 'Гэрэл удирдлага') {
      if (isChecked) {
        tempVar = 1;
      } else {
        tempVar = 0;
      }
      print('Lamp: $tempVar Boiler: $isChecked type: $type');
      response = await http
          .get(Uri.parse('$url1&field1=$tempVar&field2=${relay.rel2}'));
      print(Uri.parse('$url1&field1=$tempVar&field2=${relay.rel2}'));
      while (response.statusCode != 200) {
        response = await http
            .get(Uri.parse('$url1&field1=$tempVar&field2=${relay.rel2}'));
        print(Uri.parse('$url1&field1=$tempVar&field2=${relay.rel2}'));
        print('body: ${response.statusCode}');
      }
    } else if (type == 'Бойлер') {
      if (isChecked) {
        tempVar = 1;
      } else {
        tempVar = 0;
      }
      response = await http
          .get(Uri.parse('$url1&field1=${relay.rel1}&field2=$tempVar'));
      print(Uri.parse('$url1&field1=${relay.rel1}&field2=$tempVar'));
      print('body: ${response.body}');
    }

    //print('Lamp: $tempVar Boiler: $boilerOn type: $type');

    // if (response.statusCode == 200) {
    // } else {
    //   throw Exception('Failed to load album');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: widget.size.width * 0.35,
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
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.icon,
                widget.title != "LEAKS"
                    ? AnimatedBuilder(
                        animation: _animationController,
                        builder: (animation, child) {
                          return GestureDetector(
                            onTap: () async {
                              setState(() {
                                if (_animationController.isCompleted) {
                                  _animationController.animateTo(20);
                                } else {
                                  _animationController.animateTo(0);
                                }
                                isChecked = !isChecked;
                              });
                              await sendSwitchingData(type: widget.title);
                            },
                            child: Container(
                              height: 40,
                              width: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade50,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 8,
                                    offset: Offset(3, 3),
                                  ),
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    offset: Offset(-3, -3),
                                  ),
                                ],
                              ),
                              child: Align(
                                alignment: _animation.value,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 1),
                                  decoration: BoxDecoration(
                                    color: isChecked
                                        ? Colors.grey.shade300
                                        : kGreenColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Container(),
              ],
            ),
            SizedBox(height: 10),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: kBlueColor,
              ),
            ),
            Text(
              isChecked ? widget.statusOff : widget.statusOn,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isChecked ? Colors.grey.withOpacity(0.6) : kGreenColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
