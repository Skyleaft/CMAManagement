import 'package:cma_management/component/barChart.dart';
import 'package:cma_management/Menu/component/header.dart';
import 'package:cma_management/component/historyTable.dart';
import 'package:cma_management/component/infoCard.dart';
import 'package:cma_management/component/paymentDetailList.dart';
import 'package:cma_management/config/responsive.dart';
import 'package:cma_management/config/size_config.dart';
import 'package:cma_management/model/Produk.dart';
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
  Future<List<Produk>?> getProduks() async {
    final response =
        await http.get(Uri.parse('https://faktur.cybercode.id/api/produk'));
    if (response.statusCode == 200) {
      return produkFromJson(response.body);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 10,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth,
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          FutureBuilder(
                            future: getProduks(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                      "Something wrong with message: ${snapshot.error.toString()}"),
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                List<Produk>? _produks = snapshot.data;

                                return InfoCard(
                                    icon: 'assets/credit-card.svg',
                                    label: 'Jumlah Produk',
                                    amount: '${_produks?.length}');
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
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
