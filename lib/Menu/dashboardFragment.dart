import 'package:cma_management/component/barChart.dart';
import 'package:cma_management/Menu/component/header.dart';
import 'package:cma_management/component/historyTable.dart';
import 'package:cma_management/component/infoCard.dart';
import 'package:cma_management/component/paymentDetailList.dart';
import 'package:cma_management/config/responsive.dart';
import 'package:cma_management/config/size_config.dart';
import 'package:cma_management/model/Produk.dart';
import 'package:cma_management/services/produk_services.dart';
import 'package:cma_management/styles/colors.dart';
import 'package:cma_management/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardFragment extends StatefulWidget {
  const DashboardFragment({Key? key}) : super(key: key);

  @override
  _DashboardFragmentState createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment> {
  ProdukService serviceProduk = new ProdukService();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late List<Produk> produks = <Produk>[];

  Future<void> initData() async {
    produks = await serviceProduk.getProduks();
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(milliseconds: 100));
    final List<Produk> _produk = await serviceProduk.getProduks();
    setState(() {
      produks = _produk;
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 10,
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),
                    FutureBuilder(
                      future: initData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return SizedBox(
                            width: SizeConfig.screenWidth,
                            child: Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                InfoCard(
                                    icon: 'assets/credit-card.svg',
                                    label: 'Jumlah Produk',
                                    amount: '${produks.length}'),
                                InfoCard(
                                    icon: 'assets/transfer.svg',
                                    label: 'Total Barang',
                                    amount: '\$150'),
                                InfoCard(
                                    icon: 'assets/invoice.svg',
                                    label: 'Total Transaksi \nPenjualan',
                                    amount: '\$1500'),
                                InfoCard(
                                    icon: 'assets/invoice.svg',
                                    label: 'Total Transaksi \nPembelian',
                                    amount: '\$1500'),
                              ],
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryText(
                              text: 'Pengeluaran Bulanan',
                              size: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondary,
                            ),
                            PrimaryText(
                                text: '\$1500',
                                size: 30,
                                fontWeight: FontWeight.w800),
                          ],
                        ),
                        PrimaryText(
                          text: 'Past 30 DAYS',
                          size: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondary,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 3,
                    ),
                    Container(
                      height: 180,
                      child: BarChartCopmponent(),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryText(
                            text: 'History',
                            size: 30,
                            fontWeight: FontWeight.w800),
                        PrimaryText(
                          text: 'Transaction of lat 6 month',
                          size: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondary,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 3,
                    ),
                    HistoryTable(),
                    if (!Responsive.isDesktop(context)) PaymentDetailList(),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
