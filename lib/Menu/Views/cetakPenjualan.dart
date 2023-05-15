import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file_plus/open_file_plus.dart';

class CetakPenjualan extends StatelessWidget {
  const CetakPenjualan({Key? key}) : super(key: key);

  Future<void> cetak() async {
    final pdf = pw.Document();
    String svgRaw = '''
<svg viewBox="0 0 50 50" xmlns="http://www.w3.org/2000/svg">
  <ellipse style="fill: grey; stroke: black;" cx="25" cy="25" rx="20" ry="20"></ellipse>
</svg>
''';

    final svgImage = pw.SvgImage(svg: svgRaw);
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World"),
          ); // Center
        }));

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);
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
      )),
    );
  }
}
