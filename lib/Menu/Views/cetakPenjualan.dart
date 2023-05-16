import 'dart:io';
import 'dart:typed_data';

import 'package:cma_management/model/DetailPenjualan.dart';
import 'package:cma_management/model/FakturPenjualan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../../model/Penjualan.dart';
import '../../utils/MoneyFormat.dart';

String? _bgShape;

class CetakPenjualan extends StatelessWidget {
  final Penjualan dataPenjualan;
  final FakturPenjualan fakturPenjualan;

  const CetakPenjualan(
      {Key? key, required this.dataPenjualan, required this.fakturPenjualan})
      : super(key: key);

  Future<void> cetak() async {
    final output = await getTemporaryDirectory();
    final file = File(
        "${output.path}/${dataPenjualan.customer!.nama_customer}-${dataPenjualan.no_faktur.substring(dataPenjualan.no_faktur.length - 4)}.pdf");

    await file
        .writeAsBytes(await buildPdf(PdfPageFormat.a4.landscape))
        .then((value) => OpenFile.open(value.path));
  }

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    _bgShape = await rootBundle.loadString('assets/BGInvoce.svg');
    // Create a PDF document.
    final doc = pw.Document();

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentHeader(context),
          _contentTable(context),
          pw.SizedBox(height: 20),
          _contentFooter(context),
          pw.SizedBox(height: 20),
          _termsAndConditions(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        color: PdfColors.deepOrange,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(2)),
                      color: PdfColors.deepOrangeAccent,
                    ),
                    padding: const pw.EdgeInsets.only(
                        left: 40, top: 10, bottom: 10, right: 20),
                    alignment: pw.Alignment.centerLeft,
                    height: 80,
                    child: pw.DefaultTextStyle(
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 12,
                      ),
                      child: pw.GridView(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 6,
                        children: [
                          pw.Text('Invoice #'),
                          pw.Text(dataPenjualan.no_faktur),
                          pw.Text('Tanggal:'),
                          pw.Text(DateFormat('dd-MM-yyyy')
                              .format(dataPenjualan.tanggal)),
                          pw.Text('Jatuh Tempo:'),
                          pw.Text(DateFormat('dd-MM-yyyy')
                              .format(dataPenjualan.jatuh_tempo)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    padding: const pw.EdgeInsets.only(bottom: 8, left: 30),
                    height: 72,
                    child: pw.PdfLogo(),
                  ),
                  pw.Container(
                    color: PdfColors.deepOrange,
                    padding: pw.EdgeInsets.only(top: 3),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Container(
          height: 20,
          width: 100,
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.pdf417(),
            data: 'Invoice# ${dataPenjualan.no_faktur}',
            drawText: false,
          ),
        ),
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.white,
          ),
        ),
      ],
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.SvgImage(svg: _bgShape!),
      ),
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    String totalFormated =
        MoneyFormat().rupiah(double.parse(fakturPenjualan.total.toString()));
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 20),
            height: 70,
            child: pw.FittedBox(
              child: pw.Text(
                'Total: ${totalFormated}',
                style: pw.TextStyle(
                  color: PdfColors.deepOrange,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Row(
            children: [
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 10, right: 10),
                height: 70,
                child: pw.Text(
                  'Invoice to:',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Container(
                  height: 70,
                  child: pw.RichText(
                      text: pw.TextSpan(
                          text: '${dataPenjualan.customer?.nama_customer}\n',
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                          children: [
                        const pw.TextSpan(
                          text: '\n',
                          style: pw.TextStyle(
                            fontSize: 5,
                          ),
                        ),
                        pw.TextSpan(
                          text: dataPenjualan.customer?.alamat,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 10,
                          ),
                        ),
                      ])),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'No',
      'Nama Barang',
      'Harga',
      'Quantity',
      'Mtr',
      'Total'
    ];
    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: PdfColors.deepOrange,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        color: PdfColors.black,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: PdfColors.black,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.deepOrange100,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        dataPenjualan.detailPenjualan!.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => dataPenjualan.detailPenjualan![row]!.getIndex(col, row + 1),
        ),
      ),
    );
  }

  pw.Widget _contentFooter(pw.Context context) {
    String totalFormated =
        MoneyFormat().rupiah(double.parse(fakturPenjualan.total.toString()));
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Thank you for your business',
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 20, bottom: 8),
                child: pw.Text(
                  'Payment Info:',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                "Cybercode Media Alternatif, Jl. HMS Mintareja Sarjana Hukum Jl. Ruko Town Place No.A-25, Baros, Cimahi Tengah, Cimahi City, West Java 40521, Indonesia",
                style: const pw.TextStyle(
                  fontSize: 8,
                  lineSpacing: 5,
                  color: PdfColors.black,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.black,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Sub Total:'),
                    pw.Text(totalFormated),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Tax:'),
                    pw.Text('0%'),
                  ],
                ),
                pw.Divider(color: PdfColors.deepOrangeAccent),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total:'),
                      pw.Text(totalFormated),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _termsAndConditions(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                      top: pw.BorderSide(color: PdfColors.deepOrangeAccent)),
                ),
                padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
                child: pw.Text(
                  'Terms & Conditions',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                pw.LoremText().paragraph(40),
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(
                  fontSize: 6,
                  lineSpacing: 2,
                  color: PdfColors.black,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.SizedBox(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TextButton(
          onPressed: () {
            cetak();
          },
          child: Text("Cetak"),
        ),
      ),
    );
  }
}
