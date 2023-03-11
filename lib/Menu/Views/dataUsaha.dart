import 'dart:math';

import 'package:cma_management/model/Usaha.dart';
import 'package:cma_management/services/usaha_services.dart';
import 'package:cma_management/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class DataUsaha extends StatefulWidget {
  const DataUsaha({Key? key}) : super(key: key);

  @override
  _DataUsahaState createState() => _DataUsahaState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

List<Usaha> globalUsaha = <Usaha>[];

class _DataUsahaState extends State<DataUsaha> {
  late List<Usaha> _usahaList;
  late Future<void> futureUsaha;
  UsahaService service = new UsahaService();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

//dialog form
  Widget _dialogForm(bool isUpdate, [Usaha? _usaha]) {
    final namaController = TextEditingController();
    final keteranganController = TextEditingController();

    if (isUpdate) {
      namaController.text = _usaha!.nama_usaha;
      keteranganController.text = _usaha.keterangan!;
    }
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return AlertDialog(
        title: isUpdate ? const Text('Ubah Data') : const Text('Usaha Baru'),
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
                if (isUpdate) {
                  final usahaToUpdate = Usaha(
                      id: _usaha!.id,
                      nama_usaha: namaController.text,
                      keterangan: keteranganController.text,
                      created_at: _usaha.created_at,
                      updated_at: DateTime.now().toIso8601String() + 'Z',
                      deleted_at: _usaha.deleted_at);
                  service.updateUsaha(usahaToUpdate.id.value, usahaToUpdate);
                } else {
                  final usaha = Usaha(
                      id: Guid.generate(),
                      nama_usaha: namaController.text,
                      keterangan: keteranganController.text,
                      created_at: DateTime.now().toIso8601String() + 'Z',
                      updated_at: null,
                      deleted_at: null);
                  service.createUsaha(usaha);
                }

                _refreshData();
                Navigator.pop(context);
              }
            },
            child: isUpdate ? const Text('Update') : const Text('Save'),
          ),
        ],
      );
    });
  }

  Widget _deleteDialog(Usaha _usaha) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
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
    });
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
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                          onPressed: () => {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _dialogForm(true, usaha);
                              },
                            )
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(color: AppColors.primary),
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
    globalUsaha = await service.getUsahas();
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

  SampleItem? selectedMenu;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.iconGray),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.sort, color: AppColors.iconGray),
            initialValue: selectedMenu,
            onSelected: (SampleItem item) {
              setState(() {
                selectedMenu = item;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
              const PopupMenuItem<SampleItem>(
                value: SampleItem.itemOne,
                child: Text('Item 1'),
              ),
              const PopupMenuItem<SampleItem>(
                value: SampleItem.itemTwo,
                child: Text('Item 2'),
              ),
              const PopupMenuItem<SampleItem>(
                value: SampleItem.itemThree,
                child: Text('Item 3'),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.search, color: AppColors.iconGray),
            onPressed: () {
              showSearch(
                context: context,
                delegate: customSearchDelegate(),
              );
            },
          ),
          SizedBox(
            width: 20,
          )
        ],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return _dialogForm(false);
            },
          ),
        },
        label: const Text('Baru'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Usaha',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
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

class customSearchDelegate extends SearchDelegate<Usaha?> {
  UsahaService service = new UsahaService();
  List<Usaha> usahaList = <Usaha>[];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  Future<void> initData() async {
    usahaList = await service.getUsahas();
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildMatchingSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildMatchingSuggestions(context);
  }

  Widget buildMatchingSuggestions(BuildContext context) {
    List<Usaha> matchQuery = [];
    if (query.length < 2) return Container();

    initData();
    for (var data in usahaList) {
      if (data.nama_usaha.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(data);
      }
    }
    developer.log(matchQuery.length.toString());

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.nama_usaha),
        );
      },
    );
  }
}
