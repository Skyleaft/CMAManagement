import 'package:cma_management/Menu/Views/dataBarang.dart';
import 'package:cma_management/Menu/Views/dataCustomer.dart';
import 'package:cma_management/Menu/Views/dataPembelian.dart';
import 'package:cma_management/Menu/Views/dataPenjualan.dart';
import 'package:cma_management/Menu/Views/dataProduk.dart';
import 'package:cma_management/Menu/Views/dataSuplier.dart';
import 'package:cma_management/Menu/Views/dataUsaha.dart';
import 'package:cma_management/Menu/component/meals_list_view.dart';
import 'package:cma_management/Menu/component/mediterranean_diet_view.dart';
import 'package:cma_management/Menu/component/tile_card.dart';
import 'package:cma_management/Menu/component/title_view.dart';
import 'package:cma_management/component/barChart.dart';
import 'package:cma_management/Menu/component/header.dart';
import 'package:cma_management/component/barChartJumlah.dart';
import 'package:cma_management/component/historyTable.dart';
import 'package:cma_management/component/infoCard.dart';
import 'package:cma_management/component/paymentDetailList.dart';
import 'package:cma_management/config/responsive.dart';
import 'package:cma_management/config/size_config.dart';
import 'package:cma_management/model/BarPembelian.dart';
import 'package:cma_management/model/BarPenjualan.dart';
import 'package:cma_management/model/Barang.dart';
import 'package:cma_management/model/Customer.dart';
import 'package:cma_management/model/DashbordData.dart';
import 'package:cma_management/model/DetailPembelian.dart';
import 'package:cma_management/model/Pembelian.dart';
import 'package:cma_management/model/Penjualan.dart';
import 'package:cma_management/model/Produk.dart';
import 'package:cma_management/model/Stok.dart';
import 'package:cma_management/model/Suplier.dart';
import 'package:cma_management/model/Usaha.dart';
import 'package:cma_management/services/barang_services.dart';
import 'package:cma_management/services/customer_services.dart';
import 'package:cma_management/services/dashboard_services.dart';
import 'package:cma_management/services/pembelian_services.dart';
import 'package:cma_management/services/penjualan_services.dart';
import 'package:cma_management/services/produk_services.dart';
import 'package:cma_management/services/stok_services.dart';
import 'package:cma_management/services/suplier_services.dart';
import 'package:cma_management/services/usaha_services.dart';
import 'package:cma_management/styles/colors.dart';
import 'package:cma_management/styles/styles.dart';
import 'package:cma_management/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:money_formatter/money_formatter.dart';
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
  late DashboardData dashboardData = DashboardData();
  late MoneyFormatter? pengeluaran = null;
  late MoneyFormatter? pendapatan = null;
  List<BarPenjualan?>? barPenjualan;
  List<BarPembelian?>? barPembelian;

  List<Widget> listViews = <Widget>[];

  Future<void> initData() async {
    if (this.mounted) {
      final _data = await DashboardService().getDashboards();
      setState(() {
        dashboardData = _data;
        pengeluaran = new MoneyFormatter(
            amount: double.parse(dashboardData.pengeluaran!.toString()),
            settings: MoneyFormatterSettings(
              symbol: 'Rp.',
              thousandSeparator: '.',
              decimalSeparator: ',',
              symbolAndNumberSeparator: ' ',
              fractionDigits: 0,
            ));
        pendapatan = new MoneyFormatter(
            amount: double.parse(dashboardData.pendapatan!.toString()),
            settings: MoneyFormatterSettings(
              symbol: 'Rp.',
              thousandSeparator: '.',
              decimalSeparator: ',',
              symbolAndNumberSeparator: ' ',
              fractionDigits: 0,
            ));
      });
    }
  }

  Future<void> getBarData() async {
    final _barPenjualan = await DashboardService().getBarPenjualan();
    final _barPembelian = await DashboardService().getBarPembelian();
    barPenjualan = _barPenjualan;
    barPembelian = _barPembelian;
    // setState(() {
    //   barPenjualan = _barPenjualan;
    //   barPembelian = _barPembelian;
    // });
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(milliseconds: 100));
    final _data = await DashboardService().getDashboards();
    setState(() {
      dashboardData = _data;
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
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          runSpacing: 24,
          spacing: 12,
          children: [
            TileCard(
              titleTxt: "Total Usaha",
              subTxt: '${dashboardData.usahaCount}',
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
              subTxt: '${dashboardData.produkCount}',
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
              subTxt: '${dashboardData.suplierCount}',
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
              subTxt: '${dashboardData.customerCount}',
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
              subTxt: '${dashboardData.barangCount}',
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
              titleTxt: "Stok",
              subTxt: '${dashboardData.stockCount}',
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
              subTxt: '${dashboardData.pembelianCount}',
              color: Colors.deepOrange.shade500,
              icon: Icons.shopping_cart,
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
              subTxt: '${dashboardData.penjualanCount}',
              color: Colors.deepOrange.shade400,
              icon: Icons.shopping_cart,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / count) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DataPenjualan()),
                )
              },
            ),
          ]),
    );
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
          Card(
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Pengeluaran",
                        style: CMATheme.title,
                      ),
                      Icon(
                        Icons.arrow_upward,
                        size: 48,
                      ),
                      Text(pengeluaran?.output.symbolOnLeft ?? "0",
                          style: TextStyle(fontSize: 17, color: Colors.red))
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 80,
                    width: 2,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        "Pendapatan",
                        style: CMATheme.title,
                      ),
                      Icon(
                        Icons.arrow_downward,
                        size: 48,
                      ),
                      Text(pendapatan?.output.symbolOnLeft ?? "0",
                          style: TextStyle(fontSize: 17, color: Colors.green))
                    ],
                  ),
                ],
              ),
            ),
          ),
          TitleView(
            titleTxt: 'Grafik Pembelian & Penjualan',
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
            child: FutureBuilder(
                future: getBarData(),
                builder: (context, snapshot) {
                  if (barPenjualan != null && barPembelian != null) {
                    return BarChartCopmponent(
                      barPenjualan: barPenjualan,
                      barPembelian: barPembelian,
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
          TitleView(
            titleTxt: 'Grafik Total Transaksi',
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
            child: FutureBuilder(
                future: getBarData(),
                builder: (context, snapshot) {
                  if (barPenjualan != null && barPembelian != null) {
                    return BarChartJumlahCopmponent(
                      barPenjualan: barPenjualan,
                      barPembelian: barPembelian,
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
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
