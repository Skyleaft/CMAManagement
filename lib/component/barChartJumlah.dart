import 'dart:ffi';

import 'package:cma_management/config/responsive.dart';
import 'package:cma_management/model/BarPembelian.dart';
import 'package:cma_management/model/BarPenjualan.dart';
import 'package:cma_management/styles/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

double? avgMontly = 0;
double? min = 0;
double? max = 0;

class BarChartJumlahCopmponent extends StatelessWidget {
  final List<BarPenjualan?>? barPenjualan;
  final List<BarPembelian?>? barPembelian;

  const BarChartJumlahCopmponent(
      {Key? key, required this.barPenjualan, required this.barPembelian})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    avgMontly = barPenjualan?.map((m) => m!.totalTransaksi!).average;
    min = barPenjualan!.map((m) => m!.totalTransaksi!).min.toDouble();
    List<int> maxTerbesar = <int>[];
    maxTerbesar.add(barPenjualan!.map((m) => m!.totalTransaksi!).max);
    maxTerbesar.add(barPembelian!.map((m) => m!.totalTransaksi!).max);
    max = maxTerbesar.max.toDouble();
    return LineChart(
      sampleData1,
      swapAnimationDuration: Duration(milliseconds: 150), // Optional
      swapAnimationCurve: Curves.linear, // Optional
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 1,
        maxX: 5,
        maxY: formatDouble(max!.toInt()),
        minY: formatDouble(min!.toInt()),
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white.withOpacity(0.8),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];
  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    String tanggal = DateFormat('MMM').format(DateTime(2023, value.toInt()));
    Widget text = Text(tanggal, style: style);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = '';

    if (value == min) {
      text = '${min!.toInt()}';
    } else if (value == avgMontly!.ceil()) {
      text = '${avgMontly!.toInt()}';
    } else if (value == formatDouble(max!.toInt())) {
      text = '${max!.toInt()}';
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom:
              BorderSide(color: AppColors.primary.withOpacity(0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  double formatDouble(int value) {
    return value.toDouble();
  }

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: Colors.green,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(barPenjualan![4]!.perbulan!.month.toDouble(),
              formatDouble(barPenjualan![4]!.totalTransaksi!)),
          FlSpot(barPenjualan![3]!.perbulan!.month.toDouble(),
              formatDouble(barPenjualan![3]!.totalTransaksi!)),
          FlSpot(barPenjualan![2]!.perbulan!.month.toDouble(),
              formatDouble(barPenjualan![2]!.totalTransaksi!)),
          FlSpot(barPenjualan![1]!.perbulan!.month.toDouble(),
              formatDouble(barPenjualan![1]!.totalTransaksi!)),
          FlSpot(barPenjualan![0]!.perbulan!.month.toDouble(),
              formatDouble(barPenjualan![0]!.totalTransaksi!)),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: Colors.pink,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(
          show: false,
          color: Colors.pink.withOpacity(0),
        ),
        spots: [
          barPembelian!.length < 5
              ? FlSpot.nullSpot
              : FlSpot(barPembelian![4]!.perbulan!.month.toDouble(),
                  formatDouble(barPembelian![4]!.totalTransaksi!)),
          FlSpot(barPembelian![3]!.perbulan!.month.toDouble(),
              formatDouble(barPembelian![3]!.totalTransaksi!)),
          FlSpot(barPembelian![2]!.perbulan!.month.toDouble(),
              formatDouble(barPembelian![2]!.totalTransaksi!)),
          FlSpot(barPembelian![1]!.perbulan!.month.toDouble(),
              formatDouble(barPembelian![1]!.totalTransaksi!)),
          FlSpot(barPembelian![0]!.perbulan!.month.toDouble(),
              formatDouble(barPembelian![0]!.totalTransaksi!)),
        ],
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );
  FlGridData get gridData => FlGridData(show: false);
}
