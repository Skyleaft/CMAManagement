import 'package:cma_management/component/barChart.dart';
import 'package:cma_management/component/header.dart';
import 'package:cma_management/component/historyTable.dart';
import 'package:cma_management/component/infoCard.dart';
import 'package:cma_management/component/paymentDetailList.dart';
import 'package:cma_management/styles/colors.dart';
import 'package:cma_management/styles/styles.dart';
import 'package:flutter/material.dart';

import 'config/responsive.dart';
import 'config/size_config.dart';

class Dashboard extends StatelessWidget {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _drawerKey,
      body: SafeArea(
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
                            InfoCard(
                                icon: 'assets/credit-card.svg',
                                label: 'Transafer via \nCard number',
                                amount: '\$1200'),
                            InfoCard(
                                icon: 'assets/transfer.svg',
                                label: 'Transafer via \nOnline Banks',
                                amount: '\$150'),
                            InfoCard(
                                icon: 'assets/bank.svg',
                                label: 'Transafer \nSame Bank',
                                amount: '\$1500'),
                            InfoCard(
                                icon: 'assets/invoice.svg',
                                label: 'Transafer to \nOther Bank',
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
                                text: 'Balance',
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
                      if (!Responsive.isDesktop(context)) PaymentDetailList()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
