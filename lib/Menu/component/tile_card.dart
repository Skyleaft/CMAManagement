import 'package:cma_management/styles/themes.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class TileCard extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final VoidCallback? onTap;
  final IconData icon;
  final Color color;
  final AnimationController? animationController;
  final Animation<double>? animation;

  const TileCard(
      {Key? key,
      this.titleTxt: "",
      this.subTxt: "",
      this.onTap,
      this.icon: Icons.storage,
      this.color: Colors.grey,
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
                    color: color,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    elevation: 4,
                    shadowColor: Colors.deepOrange,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      onTap: onTap,
                      child: Container(
                        constraints:
                            BoxConstraints(minWidth: 110, maxWidth: 110),
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
