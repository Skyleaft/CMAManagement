import 'package:cma_management/Menu/Views/dataBarang.dart';
import 'package:cma_management/Menu/Views/dataCustomer.dart';
import 'package:cma_management/Menu/Views/dataPembelian.dart';
import 'package:cma_management/Menu/Views/dataProduk.dart';
import 'package:cma_management/Menu/Views/dataSuplier.dart';
import 'package:cma_management/Menu/Views/dataUsaha.dart';
import 'package:cma_management/Menu/component/meals_list_view.dart';
import 'package:cma_management/Menu/component/mediterranean_diet_view.dart';
import 'package:cma_management/Menu/component/tile_card.dart';
import 'package:cma_management/Menu/component/title_view.dart';
import 'package:cma_management/component/barChart.dart';
import 'package:cma_management/Menu/component/header.dart';
import 'package:cma_management/component/historyTable.dart';
import 'package:cma_management/component/infoCard.dart';
import 'package:cma_management/component/paymentDetailList.dart';
import 'package:cma_management/config/responsive.dart';
import 'package:cma_management/config/size_config.dart';
import 'package:cma_management/model/Barang.dart';
import 'package:cma_management/model/Customer.dart';
import 'package:cma_management/model/DetailPembelian.dart';
import 'package:cma_management/model/Pembelian.dart';
import 'package:cma_management/model/Produk.dart';
import 'package:cma_management/model/Suplier.dart';
import 'package:cma_management/model/Usaha.dart';
import 'package:cma_management/services/barang_services.dart';
import 'package:cma_management/services/customer_services.dart';
import 'package:cma_management/services/pembelian_services.dart';
import 'package:cma_management/services/produk_services.dart';
import 'package:cma_management/services/suplier_services.dart';
import 'package:cma_management/services/usaha_services.dart';
import 'package:cma_management/styles/colors.dart';
import 'package:cma_management/styles/styles.dart';
import 'package:cma_management/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

import 'package:shimmer/shimmer.dart';

class DashboardFragment extends StatefulWidget {
  const DashboardFragment({Key? key, this.animationController})
      : super(key: key);
  final AnimationController? animationController;

  @override
  _DashboardFragmentState createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment> {
  ProdukService serviceProduk = new ProdukService();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Animation<double>? topBarAnimation;
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  late List<Usaha> usahas = <Usaha>[];
  late List<Produk> produks = <Produk>[];
  late List<Barang> barangs = <Barang>[];
  late List<Pembelian> pembelians = <Pembelian>[];
  late List<Customer> customers = <Customer>[];
  late List<Suplier> supliers = <Suplier>[];

  List<Widget> listViews = <Widget>[];

  Future<void> initData() async {
    final _produk = await serviceProduk.getProduks();
    final _barangs = await BarangService().getBarangs();
    final _pembelians = await PembelianService().getPembelians();
    final _customers = await CustomerService().getCustomers();
    final _supliers = await SuplierService().getSupliers();
    final _usahas = await UsahaService().getUsahas();
    setState(() {
      produks = _produk;
      barangs = _barangs;
      pembelians = _pembelians;
      customers = _customers;
      supliers = _supliers;
      usahas = _usahas;
    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(milliseconds: 100));
    final _produk = await serviceProduk.getProduks();
    final _barangs = await BarangService().getBarangs();
    final _pembelians = await PembelianService().getPembelians();
    final _customers = await CustomerService().getCustomers();
    final _supliers = await SuplierService().getSupliers();
    final _usahas = await UsahaService().getUsahas();
    setState(() {
      produks = _produk;
      barangs = _barangs;
      pembelians = _pembelians;
      customers = _customers;
      supliers = _supliers;
      usahas = _usahas;
    });
  }

  @override
  void initState() {
    widget.animationController?.forward();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    initData();
    addAllListData();

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

  void addAllListData() {
    const int count = 9;
    listViews.add(
      TitleView(
        titleTxt: 'Monitoring Data',
        subTxt: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      MediterranesnDietView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      TitleView(
        titleTxt: 'Meals today',
        subTxt: 'Customize',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    listViews.add(
      MealsListView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Body measurement',
        subTxt: 'Today',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      MediterranesnDietView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Water',
        subTxt: 'Aqua SmartBottle',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 6, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
  }

  Widget loadMonitoringData(bool isLoaded) {
    int count = 8;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Wrap(
          direction: Axis.horizontal,
          runSpacing: 24,
          spacing: 12,
          children: [
            TileCard(
              titleTxt: "Total Usaha",
              subTxt: '${usahas.length.toString()}',
              color: Colors.deepOrange.shade400,
              icon: Icons.store_mall_directory,
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DataUsaha()),
                )
              },
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / count) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
            TileCard(
              titleTxt: "Total Produk",
              subTxt: '${produks.length.toString()}',
              icon: Icons.inventory,
              color: Colors.deepOrange.shade500,
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DataProduk()),
                )
              },
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / count) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
            TileCard(
              titleTxt: "Total Suplier",
              subTxt: '${supliers.length.toString()}',
              color: Colors.deepOrange.shade600,
              icon: Icons.local_shipping,
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DataSuplier()),
                )
              },
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / count) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
            TileCard(
              titleTxt: "Total Customer",
              subTxt: '${customers.length.toString()}',
              icon: Icons.diversity_1,
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DataCustomer()),
                )
              },
              color: Colors.deepOrange.shade700,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / count) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
            TileCard(
              titleTxt: "Total Barang",
              subTxt: '${barangs.length.toString()}',
              color: Colors.deepOrange.shade600,
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DataBarang()),
                )
              },
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / count) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
            TileCard(
              titleTxt: "Total Pembelian",
              subTxt: '${pembelians.length.toString()}',
              color: Colors.deepOrange.shade500,
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DataPembelian()),
                )
              },
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / count) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
            TileCard(
              titleTxt: "Total Penjualan",
              subTxt: "0",
              color: Colors.deepOrange.shade400,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / count) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
          ]),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    await initData();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        getAppBarUI(),
        Expanded(child: getMainListViewUI()),
      ]),
    );
  }

  Widget getMainListViewUI() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        padding: EdgeInsets.only(
          bottom: 100 + MediaQuery.of(context).padding.bottom,
        ),
        scrollDirection: Axis.vertical,
        children: [
          TitleView(
            titleTxt: 'Monitoring Data',
            subTxt: 'Details',
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController!,
                    curve: Interval((1 / 9) * 0, 1.0,
                        curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController!,
          ),
          loadMonitoringData(true),
          TitleView(
            titleTxt: 'Pengeluaran Tiap Bulanan',
            subTxt: 'Details',
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController!,
                    curve: Interval((1 / 9) * 0, 1.0,
                        curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController!,
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical! * 3,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 28),
            height: 180,
            child: BarChartCopmponent(),
          ),
          TitleView(
            titleTxt: 'Pendapatan Tiap Bulanan',
            subTxt: 'Details',
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController!,
                    curve: Interval((1 / 9) * 0, 1.0,
                        curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController!,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 28),
            height: 180,
            child: BarChartCopmponent(),
          ),
          TitleView(
            titleTxt: 'Log History',
            subTxt: 'Bulan Ini',
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController!,
                    curve: Interval((1 / 9) * 0, 1.0,
                        curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController!,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: HistoryTable()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: PaymentDetailList(),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical! * 6,
          ),
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
                                  'CMA',
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
