import 'dart:convert';
import 'package:cma_management/model/Usaha.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataUsaha extends StatefulWidget {
  const DataUsaha({Key? key}) : super(key: key);

  @override
  _DataUsahaState createState() => _DataUsahaState();
}

class _DataUsahaState extends State<DataUsaha> {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  late List<Usaha> futureUsaha;

  Future<Usaha> fetchUsaha() async {
    final response =
        await http.get(Uri.parse('https://faktur.cybercode.id/api/usaha'));

    if (response.statusCode == 200) {
      return Usaha.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Usaha');
    }
  }

  Future<List<Usaha>?> getUsahas() async {
    final response =
        await http.get(Uri.parse('https://faktur.cybercode.id/api/usaha'));
    if (response.statusCode == 200) {
      return usahaFromJson(response.body);
    } else {
      return null;
    }
  }

  Widget _buildListView(List<Usaha> usahas) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Usaha usaha = usahas[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      usaha.nama_usaha,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Text('${usaha.keterangan}'),
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
        itemCount: usahas.length,
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
        title: Text("Data Usaha"),
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
                    hintText: "Masukan Nama Usaha",
                    labelText: "Nama Usaha",
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
              Text('List Usaha'),

              FutureBuilder(
                future: getUsahas(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          "Something wrong with message: ${snapshot.error.toString()}"),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    List<Usaha>? usahas = snapshot.data;
                    return _buildListView(usahas!);
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
