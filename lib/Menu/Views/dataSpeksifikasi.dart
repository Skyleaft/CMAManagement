import 'dart:convert';
import 'package:cma_management/model/Speksifikasi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSpeksifikasi extends StatefulWidget {
  const DataSpeksifikasi({Key? key}) : super(key: key);

  @override
  _DataSpeksifikasiState createState() => _DataSpeksifikasiState();
}

class _DataSpeksifikasiState extends State<DataSpeksifikasi> {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  late List<Speksifikasi> futureSpeksifikasi;

  Future<Speksifikasi> fetchSpeksifikasi() async {
    final response = await http
        .get(Uri.parse('https://faktur.cybercode.id/api/speksifikasi'));

    if (response.statusCode == 200) {
      return Speksifikasi.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Speksifikasi');
    }
  }

  Future<List<Speksifikasi>?> getSpeksifikasis() async {
    final response = await http
        .get(Uri.parse('https://faktur.cybercode.id/api/speksifikasi'));
    if (response.statusCode == 200) {
      return speksifikasiFromJson(response.body);
    } else {
      return null;
    }
  }

  Widget _buildListView(List<Speksifikasi> speksifikasis) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Speksifikasi speksifikasi = speksifikasis[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      speksifikasi.value,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Text(speksifikasi.id_mspek.value),
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
        itemCount: speksifikasis.length,
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
        title: Text("Data Speksifikasi"),
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
                    hintText: "Masukan Nama Speksifikasi",
                    labelText: "Nama Speksifikasi",
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
              Text('List Speksifikasi'),

              FutureBuilder(
                future: getSpeksifikasis(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          "Something wrong with message: ${snapshot.error.toString()}"),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    List<Speksifikasi>? speksifikasis = snapshot.data;
                    return _buildListView(speksifikasis!);
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
