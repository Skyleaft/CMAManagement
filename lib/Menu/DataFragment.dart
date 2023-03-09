import 'package:cma_management/Menu/Views/dataProduk.dart';
import 'package:cma_management/Menu/Views/dataUsaha.dart';
import 'package:cma_management/styles/styles.dart';
import 'package:flutter/material.dart';

class DataFragment extends StatefulWidget {
  const DataFragment({Key? key}) : super(key: key);

  @override
  _DataFragmentState createState() => _DataFragmentState();
}

class _DataFragmentState extends State<DataFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 80),
              child: PrimaryText(
                text: 'Master Data',
                size: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            GridView.count(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: EdgeInsets.all(20),
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DataUsaha()),
                      );
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_business,
                            size: 48.0,
                          ),
                          Text('Data Usaha'),
                        ]),
                  ),
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const DataSpeksifikasi()),
                      // );
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_business,
                            size: 48.0,
                          ),
                          Text('Data Speksifikasi'),
                        ]),
                  ),
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DataProduk()),
                      );
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_business,
                            size: 48.0,
                          ),
                          Text('Data Produk'),
                        ]),
                  ),
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_business,
                            size: 48.0,
                          ),
                          Text('Data Customer'),
                        ]),
                  ),
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_business,
                            size: 48.0,
                          ),
                          Text('Data Suplier'),
                        ]),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: PrimaryText(
                text: 'Transaksi',
                size: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            GridView.count(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: EdgeInsets.all(20),
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DataUsaha()),
                      );
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_business,
                            size: 48.0,
                          ),
                          Text('Barang'),
                        ]),
                  ),
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DataUsaha()),
                      );
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_business,
                            size: 48.0,
                          ),
                          Text('Pembelian'),
                        ]),
                  ),
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DataUsaha()),
                      );
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_business,
                            size: 48.0,
                          ),
                          Text('Penjualan'),
                        ]),
                  ),
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DataUsaha()),
                      );
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_business,
                            size: 48.0,
                          ),
                          Text('Pembayaran'),
                        ]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
