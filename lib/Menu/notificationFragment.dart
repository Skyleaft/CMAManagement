import 'dart:convert';

import 'package:cma_management/Menu/component/modalForm.dart';
import 'package:cma_management/firebase_options.dart';
import 'package:cma_management/main.dart';
import 'package:cma_management/styles/themes.dart';
import 'package:cma_management/utils/noti.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationFragment extends StatefulWidget {
  const NotificationFragment({Key? key, this.animationController})
      : super(key: key);
  final AnimationController? animationController;

  @override
  _NotificationFragmentState createState() => _NotificationFragmentState();
}

int _messageCount = 0;

String myKey =
    "AAAAscugRWg:APA91bEZ80gVbiGpX-cSvHtXIRk2Ebxa3lSNF0gkRz9O7djU3_LFgpTLXvFfFkmH97XbO-vQqO0hKmkjRvICwoOsCSlEw4aJqeaosFzH56Zq5j23oBa-HuiRvGd2JsqpPExcnWfA-TpY";
String constructFCMPayload(String? token) {
  _messageCount++;
  return jsonEncode({
    'notification': {
      'title': 'Hello FlutterFire!',
      'body': 'This notification (#$_messageCount) was created via FCM!',
    },
    "to": token
  });
}

class _NotificationFragmentState extends State<NotificationFragment> {
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  Animation<double>? topBarAnimation;

  @override
  void initState() {
    widget.animationController?.forward();
    topBarAnimation = Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController!,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        getAppBarUI(),
        SizedBox(
          height: 200,
        ),
        TextButton(
            onPressed: () async {
              var mes = new RemoteMessage(
                  notification:
                      RemoteNotification(title: "coba", body: "baksodaksd"));
              //createNotification(mes);
              try {
                var response = await http.post(
                  Uri.parse('https://fcm.googleapis.com/fcm/send'),
                  headers: <String, String>{
                    'Content-Type': 'application/json',
                    'Authorization': 'key=' + myKey,
                  },
                  body: constructFCMPayload(mToken),
                );
                print('res ${response.statusCode}');
                print('res ${response.body}');
                // print('FCM request for device sent!');
                if (response.statusCode == 200) {
                } else {
                  throw Exception('Failed to send ${response.body}');
                }
              } catch (e) {
                print(e);
              }
            },
            child: Text("Test")),
      ],
    ));
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: CMATheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: CMATheme.grey.withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Log',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: CMATheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: CMATheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: CMATheme.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
