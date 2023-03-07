import 'dart:convert';
import 'package:cma_management/model/Produk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataProduk extends StatefulWidget {
  const DataProduk({Key? key}) : super(key: key);

  @override
  _DataProdukState createState() => _DataProdukState();
}

class _DataProdukState extends State<DataProduk> {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  late List<Produk> futureProduk;

  Future<Produk> fetchProduk() async {
    final response =
        await http.get(Uri.parse('https://faktur.cybercode.id/api/produk'));

    if (response.statusCode == 200) {
      return Produk.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Produk');
    }
  }

  Future<List<Produk>?> getProduks() async {
    final response =
        await http.get(Uri.parse('https://faktur.cybercode.id/api/produk'));
    if (response.statusCode == 200) {
      return produkFromJson(response.body);
    } else {
      return null;
    }
  }

  Widget _buildListView(List<Produk> produks) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Produk produk = produks[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      produk.nama_produk,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Text('${produk.keterangan}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            // TODO: do something in here
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: do something in here
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: produks.length,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Data Produk"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                decoration: new InputDecoration(
                    hintText: "Masukan Nama Produk",
                    labelText: "Nama Produk",
                    icon: Icon(Icons.people)),
              ),
              TextFormField(
                decoration: new InputDecoration(
                    hintText: "Masukan Keterangan",
                    labelText: "Keterangan",
                    icon: Icon(Icons.people)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Save'),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text('List Produk'),

              FutureBuilder(
                future: getProduks(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          "Something wrong with message: ${snapshot.error.toString()}"),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    List<Produk>? produks = snapshot.data;
                    return _buildListView(produks!);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),

              // ListView.builder(
              //     padding: const EdgeInsets.all(8),
              //     itemCount: entries.length,
              //     scrollDirection: Axis.vertical,
              //     shrinkWrap: true,
              //     itemBuilder: (BuildContext context, int index) {
              //       return Container(
              //         height: 50,
              //         color: Colors.amber[colorCodes[index]],
              //         child: Center(child: Text('Entry ${entries[index]}')),
              //       );
              //     }),
            ],
          ),
        ),
      ),
    );
  }
}
