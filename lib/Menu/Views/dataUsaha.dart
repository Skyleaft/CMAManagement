import 'package:flutter/material.dart';

class DataUsaha extends StatefulWidget {
  const DataUsaha({Key? key}) : super(key: key);

  @override
  _DataUsahaState createState() => _DataUsahaState();
}

class _DataUsahaState extends State<DataUsaha> {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

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
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: entries.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 50,
                      color: Colors.amber[colorCodes[index]],
                      child: Center(child: Text('Entry ${entries[index]}')),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
