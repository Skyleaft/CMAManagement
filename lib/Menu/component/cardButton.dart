import 'package:cma_management/styles/themes.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class CardButton extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final VoidCallback? onTap;
  final IconData icon;
  final AnimationController? animationController;
  final Animation<double>? animation;

  const CardButton(
      {Key? key,
      this.titleTxt: "",
      this.subTxt: "",
      this.onTap,
      this.icon: Icons.storage,
      this.animationController,
      this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Material(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    elevation: 6,
                    shadowColor: Colors.grey,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      onTap: onTap,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                        child: Column(children: [
                          Icon(
                            icon,
                            color: Colors.white,
                            size: 28,
                          ),
                          Text(
                            subTxt,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    titleTxt,
                    style: CMATheme.caption,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
