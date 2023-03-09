import 'package:cma_management/model/Usaha.dart';
import 'package:cma_management/services/usaha_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

class DataUsaha extends StatefulWidget {
  const DataUsaha({Key? key}) : super(key: key);

  @override
  _DataUsahaState createState() => _DataUsahaState();
}

class _DataUsahaState extends State<DataUsaha> {
  late List<Usaha> _usahaList;
  late Future<void> futureUsaha;
  UsahaService service = new UsahaService();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

//dialog form
  Widget _dialogForm() {
    final namaController = TextEditingController();
    final keteranganController = TextEditingController();
    return AlertDialog(
      title: const Text('Usaha Baru'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: namaController,
              decoration: new InputDecoration(
                  hintText: "Masukan Nama Usaha",
                  labelText: "Nama Usaha",
                  icon: Icon(Icons.people)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: keteranganController,
              decoration: new InputDecoration(
                  hintText: "Masukan Keterangan",
                  labelText: "Keterangan",
                  icon: Icon(Icons.people)),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final usaha = Usaha(
                  id: Guid.generate(),
                  nama_usaha: namaController.text,
                  keterangan: keteranganController.text,
                  created_at: DateTime.now().toIso8601String() + 'Z',
                  updated_at: null,
                  deleted_at: null);

              service.createUsaha(usaha);
              _refreshData();
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _deleteDialog(Usaha _usaha) {
    return AlertDialog(
      title: const Text('Delete Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text('Yakin Mau Hapus Usaha ${_usaha.nama_usaha}?')],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _refreshData();
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            service.deleteUsaha(_usaha.id.toString());
            _refreshData();
            Navigator.pop(context);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }

  Widget _buildListView(List<Usaha> usahas) {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: usahas.length,
          itemBuilder: (context, index) {
            Usaha usaha = usahas[index];
            return Card(
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
                          onPressed: () => {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _deleteDialog(usaha);
                              },
                            )
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
            );
          },
        ),
      ),
    );
  }

  Future<void> _initData() async {
    final List<Usaha> _usaha = await service.getUsahas();
    _usahaList = _usaha;
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(milliseconds: 100));
    final List<Usaha> _usaha = await service.getUsahas();
    setState(() {
      _usahaList = _usaha;
    });
  }

  @override
  void initState() {
    super.initState();
    futureUsaha = _initData();
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
      resizeToAvoidBottomInset: true,
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () => {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _dialogForm();
                  },
                )
              },
              icon: Icon(
                // <-- Icon
                Icons.add,
                size: 24.0,
              ),
              label: Text('Usaha Baru'),
            ),
            SizedBox(
              height: 20,
            ),
            Text('List Usaha'),
            FutureBuilder(
              future: futureUsaha,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  case ConnectionState.done:
                    {
                      return _buildListView(_usahaList);
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
