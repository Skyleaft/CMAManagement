import 'package:cma_management/model/Logs.dart';
import 'package:cma_management/model/Produk.dart';
import 'package:cma_management/model/Usaha.dart';
import 'package:cma_management/services/logs_services.dart';
import 'package:cma_management/services/produk_services.dart';
import 'package:cma_management/services/usaha_services.dart';
import 'package:cma_management/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

class DataProduk extends StatefulWidget {
  const DataProduk({Key? key}) : super(key: key);

  @override
  _DataProdukState createState() => _DataProdukState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _DataProdukState extends State<DataProduk> {
  late List<Produk> _produkList;
  late Future<void> futureProduk;
  ProdukService service = new ProdukService();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Usaha? currentUsaha;
  late Future<List<Usaha>> usahas;
  UsahaService usaha_service = new UsahaService();

//dialog form
  Widget _dialogForm(bool isUpdate, [Produk? _produk]) {
    final namaController = TextEditingController();
    final keteranganController = TextEditingController();

    if (isUpdate) {
      namaController.text = _produk!.nama_produk;
      keteranganController.text = '${_produk.keterangan!}';
    }

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return AlertDialog(
        title: isUpdate ? const Text('Ubah Data') : const Text('Produk Baru'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder(
                future: usahas,
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
                        List<Usaha>? _usaha = snapshot.data;
                        return DropdownButton<Usaha>(
                          value: currentUsaha ?? _usaha![0],
                          icon: const Icon(Icons.keyboard_arrow_down),
                          // Array list of items
                          items: _usaha
                              ?.map<DropdownMenuItem<Usaha>>((Usaha items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items.nama_usaha),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (Usaha? newValue) {
                            setState(() {
                              currentUsaha = newValue;
                            });
                          },
                        );
                      }
                  }
                },
              ),
              TextFormField(
                controller: namaController,
                decoration: new InputDecoration(
                    hintText: "Masukan Nama Produk",
                    labelText: "Nama Produk",
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
                  final produkToUpdate = Produk(
                      id: _produk!.id,
                      usahaID: currentUsaha!.id,
                      nama_produk: namaController.text,
                      keterangan: keteranganController.text,
                      created_at: _produk.created_at,
                      updated_at: DateTime.now().toIso8601String() + 'Z',
                      deleted_at: _produk.deleted_at);
                  service.updateProduk(produkToUpdate.id.value, produkToUpdate);
                } else {
                  final produk = Produk(
                      id: Guid.generate(),
                      usahaID: currentUsaha!.id,
                      nama_produk: namaController.text,
                      keterangan: keteranganController.text,
                      created_at: DateTime.now().toIso8601String() + 'Z',
                      updated_at: null,
                      deleted_at: null);
                  service.createProduk(produk);
                  var log = Logs(
                      id: Guid.generate(),
                      namaLog:
                          'User Admin Menambahkan Produk ${produk.nama_produk}',
                      userID: Guid('a0547ef6-9b97-4d7c-be79-47fc632bffed'),
                      column: 'Produk',
                      action: 'Create',
                      timestamp: DateTime.now());
                  LogsService().createLog(log);
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

  Widget _deleteDialog(Produk _produk) {
    return AlertDialog(
      title: const Text('Delete Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text('Yakin Mau Hapus Produk ${_produk.nama_produk}?')],
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
            service.deleteProduk(_produk.id.toString());
            _refreshData();
            Navigator.pop(context);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }

  Widget _buildListView(List<Produk> produks) {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: produks.length,
          itemBuilder: (context, index) {
            Produk produk = produks[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                          onPressed: () => {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _deleteDialog(produk);
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
                                return _dialogForm(true, produk);
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
    final List<Produk> _produk = await service.getProduks();
    _produkList = _produk;
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(milliseconds: 100));
    final List<Produk> _produk = await service.getProduks();
    setState(() {
      _produkList = _produk;
    });
  }

  @override
  void initState() {
    super.initState();
    usahas = usaha_service.getUsahas();
    futureProduk = _initData();
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
      resizeToAvoidBottomInset: true,
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
                  'Produk',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            FutureBuilder(
              future: futureProduk,
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
                      return _buildListView(_produkList);
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
  ProdukService service = new ProdukService();
  List<Produk> produkList = <Produk>[];
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
    produkList = await service.getProduks();
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
    List<Produk> matchQuery = [];
    if (query.length < 2) return Container();

    initData();
    for (var data in produkList) {
      if (data.nama_produk.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(data);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.nama_produk),
        );
      },
    );
  }
}
