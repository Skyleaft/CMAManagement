import 'package:cma_management/Menu/Views/dataBarang.dart';
import 'package:cma_management/Menu/Views/dataCustomer.dart';
import 'package:cma_management/Menu/Views/dataMSpek.dart';
import 'package:cma_management/Menu/Views/dataPembelian.dart';
import 'package:cma_management/Menu/Views/dataPenjualan.dart';
import 'package:cma_management/Menu/Views/dataProduk.dart';
import 'package:cma_management/Menu/Views/dataSuplier.dart';
import 'package:cma_management/Menu/Views/dataUsaha.dart';
import 'package:cma_management/Menu/component/cardButton.dart';
import 'package:cma_management/Menu/component/title_view.dart';
import 'package:cma_management/styles/colors.dart';
import 'package:cma_management/styles/styles.dart';
import 'package:cma_management/styles/themes.dart';
import 'package:flutter/material.dart';

class DataFragment extends StatefulWidget {
  const DataFragment({Key? key, this.animationController}) : super(key: key);
  final AnimationController? animationController;

  @override
  _DataFragmentState createState() => _DataFragmentState();
}

class _DataFragmentState extends State<DataFragment> {
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
          Content(),
        ],
      ),
    );
  }

  Widget SettingsManager() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Wrap(
        alignment: WrapAlignment.start,
        direction: Axis.horizontal,
        spacing: 16,
        runSpacing: 22,
        children: [
          CardButton(
            titleTxt: "Account Manager",
            icon: Icons.account_box_rounded,
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DataBarang()),
              ),
            },
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController!,
                    curve: Interval((1 / 3) * 2, 1.0,
                        curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController,
          ),
          CardButton(
            titleTxt: "Setting",
            icon: Icons.settings,
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DataBarang()),
              ),
            },
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController!,
                    curve: Interval((1 / 3) * 2, 1.0,
                        curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController,
          ),
        ],
      ),
    );
  }

  Widget Transaksi() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          spacing: 16,
          runSpacing: 22,
          children: [
            CardButton(
              titleTxt: "Barang",
              icon: Icons.inventory,
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DataBarang()),
                ),
              },
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / 4) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
            CardButton(
              titleTxt: "Pembelian",
              icon: Icons.receipt,
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DataPembelian()),
                ),
              },
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / 4) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
            CardButton(
              titleTxt: "Penjualan",
              icon: Icons.receipt,
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DataPenjualan()),
                ),
              },
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / 4) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
            CardButton(
              titleTxt: "Pembayaran",
              icon: Icons.receipt,
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DataPembelian()),
                ),
              },
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / 4) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
          ]),
    );
  }

  Widget MasterData() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Wrap(
        alignment: WrapAlignment.start,
        direction: Axis.horizontal,
        spacing: 16,
        runSpacing: 22,
        children: [
          CardButton(
            titleTxt: "Usaha",
            icon: Icons.store_mall_directory,
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DataUsaha()),
              ),
            },
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController!,
                    curve: Interval((1 / 6) * 2, 1.0,
                        curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController,
          ),
          CardButton(
            titleTxt: "Speksifikasi",
            icon: Icons.tune,
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DataMSpek()),
              ),
            },
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController!,
                    curve: Interval((1 / 6) * 2, 1.0,
                        curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController,
          ),
          CardButton(
            titleTxt: "Produk",
            icon: Icons.conveyor_belt,
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DataProduk()),
              ),
            },
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController!,
                    curve: Interval((1 / 6) * 2, 1.0,
                        curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController,
          ),
          CardButton(
            titleTxt: "Customer",
            icon: Icons.diversity_1,
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DataCustomer()),
              ),
            },
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController!,
                    curve: Interval((1 / 6) * 2, 1.0,
                        curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController,
          ),
          CardButton(
            titleTxt: "Suplier",
            icon: Icons.local_shipping,
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DataSuplier()),
              ),
            },
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController!,
                    curve: Interval((1 / 6) * 2, 1.0,
                        curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController,
          ),
        ],
      ),
    );
  }

  Widget Content() {
    return Expanded(
      child: ListView(
        controller: scrollController,
        padding: EdgeInsets.only(
          bottom: 100 + MediaQuery.of(context).padding.bottom,
        ),
        children: [
          TitleView(
            titleTxt: 'Master Data',
            subTxt: 'Details',
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController!,
                    curve: Interval((1 / 9) * 0, 1.0,
                        curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController!,
          ),
          MasterData(),
          TitleView(
            titleTxt: 'Transaksi',
            subTxt: 'Details',
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController!,
                    curve: Interval((1 / 9) * 0, 1.0,
                        curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController!,
          ),
          Transaksi(),
          TitleView(
            titleTxt: 'App Setting',
            subTxt: 'Details',
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController!,
                    curve: Interval((1 / 9) * 0, 1.0,
                        curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController!,
          ),
          SettingsManager(),
        ],
      ),
    );
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
                                  'Data Management',
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
