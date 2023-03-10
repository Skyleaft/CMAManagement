import 'dart:math';

import 'package:cma_management/model/MSpek.dart';
import 'package:cma_management/services/mspek_services.dart';
import 'package:cma_management/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class DataMSpek extends StatefulWidget {
  const DataMSpek({Key? key}) : super(key: key);

  @override
  _DataMSpekState createState() => _DataMSpekState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

List<MSpek> globalMSpek = <MSpek>[];

class _DataMSpekState extends State<DataMSpek> {
  late List<MSpek> _mSpekList;
  late Future<void> futureMSpek;
  MSpekService service = new MSpekService();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

//dialog form
  Widget _dialogForm(bool isUpdate, [MSpek? _mSpek]) {
    final namaController = TextEditingController();
    final keteranganController = TextEditingController();

    if (isUpdate) {
      namaController.text = _mSpek!.nama_speksifikasi;
    }
    return AlertDialog(
      title: isUpdate ? const Text('Ubah Data') : const Text('MSpek Baru'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: namaController,
              decoration: new InputDecoration(
                  hintText: "Masukan Nama Speksifikasi",
                  labelText: "Nama spek",
                  icon: Icon(Icons.people)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
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
                final mSpekToUpdate = MSpek(
                    id: _mSpek!.id,
                    nama_speksifikasi: namaController.text,
                    created_at: _mSpek.created_at,
                    updated_at: DateTime.now().toIso8601String() + 'Z',
                    deleted_at: _mSpek.deleted_at);
                service.updateMSpek(mSpekToUpdate.id.value, mSpekToUpdate);
              } else {
                final mSpek = MSpek(
                    id: Guid.generate(),
                    nama_speksifikasi: namaController.text,
                    created_at: DateTime.now().toIso8601String() + 'Z',
                    updated_at: null,
                    deleted_at: null);
                service.createMSpek(mSpek);
              }

              _refreshData();
              Navigator.pop(context);
            }
          },
          child: isUpdate ? const Text('Update') : const Text('Save'),
        ),
      ],
    );
  }

  Widget _deleteDialog(MSpek _mSpek) {
    return AlertDialog(
      title: const Text('Delete Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text('Yakin Mau Hapus MSpek ${_mSpek.nama_speksifikasi}?')],
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
            service.deleteMSpek(_mSpek.id.toString());
            _refreshData();
            Navigator.pop(context);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }

  Widget _buildListView(List<MSpek> mSpeks) {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: mSpeks.length,
          itemBuilder: (context, index) {
            MSpek mSpek = mSpeks[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      mSpek.nama_speksifikasi,
                      style: TextStyle(color: Colors.black54, fontSize: 22),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () => {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _deleteDialog(mSpek);
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
                                return _dialogForm(true, mSpek);
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
    final List<MSpek> _mSpek = await service.getMSpeks();
    _mSpekList = _mSpek;
    globalMSpek = await service.getMSpeks();
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(milliseconds: 100));
    final List<MSpek> _mSpek = await service.getMSpeks();
    setState(() {
      _mSpekList = _mSpek;
    });
  }

  @override
  void initState() {
    super.initState();
    futureMSpek = _initData();
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
                  'Speksifikasi',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            FutureBuilder(
              future: futureMSpek,
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
                      return _buildListView(_mSpekList);
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

class customSearchDelegate extends SearchDelegate<MSpek?> {
  MSpekService service = new MSpekService();
  List<MSpek> mSpekList = <MSpek>[];
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
    mSpekList = await service.getMSpeks();
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
    List<MSpek> matchQuery = [];
    if (query.length < 2) return Container();

    initData();
    for (var data in mSpekList) {
      if (data.nama_speksifikasi.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(data);
      }
    }
    developer.log(matchQuery.length.toString());

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.nama_speksifikasi),
        );
      },
    );
  }
}
