import 'package:cma_management/model/Barang.dart';
import 'package:cma_management/model/Produk.dart';
import 'package:cma_management/model/Suplier.dart';
import 'package:cma_management/model/Usaha.dart';
import 'package:cma_management/services/barang_services.dart';
import 'package:cma_management/services/produk_services.dart';
import 'package:cma_management/services/suplier_services.dart';
import 'package:cma_management/services/usaha_services.dart';
import 'package:cma_management/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

class DataBarang extends StatefulWidget {
  const DataBarang({Key? key}) : super(key: key);

  @override
  _DataBarangState createState() => _DataBarangState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _DataBarangState extends State<DataBarang> {
  late List<Barang> _barangList;
  late Future<void> futureBarang;
  BarangService service = new BarangService();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Usaha? currentUsaha;
  Produk? currentProduk;
  Suplier? currentSuplier;
  late Future<List<Usaha>> usahas;
  late Future<List<Produk>> produks;
  late Future<List<Suplier>> supliers;
  UsahaService usaha_service = new UsahaService();
  ProdukService produk_service = new ProdukService();
  SuplierService suplierService = new SuplierService();

//dialog form
  Widget _dialogForm(bool isUpdate, [Barang? _barang]) {
    final namaController = TextEditingController();
    final keteranganController = TextEditingController();

    if (isUpdate) {
      namaController.text = _barang!.nama_barang;
    }

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return AlertDialog(
        title: isUpdate ? const Text('Ubah Data') : const Text('Barang Baru'),
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
              FutureBuilder(
                future: produks,
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
                        List<Produk>? _produk = snapshot.data;
                        return DropdownButton<Produk>(
                          value: currentProduk ?? _produk![0],
                          icon: const Icon(Icons.keyboard_arrow_down),
                          // Array list of items
                          items: _produk
                              ?.map<DropdownMenuItem<Produk>>((Produk items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items.nama_produk),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (Produk? newValue) {
                            setState(() {
                              currentProduk = newValue;
                            });
                          },
                        );
                      }
                  }
                },
              ),
              FutureBuilder(
                future: supliers,
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
                        List<Suplier>? _suplier = snapshot.data;
                        return DropdownButton<Suplier>(
                          value: currentSuplier ?? _suplier![0],
                          icon: const Icon(Icons.keyboard_arrow_down),
                          // Array list of items
                          items: _suplier
                              ?.map<DropdownMenuItem<Suplier>>((Suplier items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items.nama_suplier),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (Suplier? newValue) {
                            setState(() {
                              currentSuplier = newValue;
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
                    hintText: "Masukan Nama Barang",
                    labelText: "Nama Barang",
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
                  final barangToUpdate = Barang(
                      id: _barang!.id,
                      produkID: currentProduk!.id,
                      suplierID: currentSuplier!.id,
                      nama_barang: namaController.text,
                      created_at: _barang.created_at,
                      updated_at: DateTime.now().toIso8601String() + 'Z',
                      deleted_at: _barang.deleted_at);
                  service.updateBarang(barangToUpdate.id.value, barangToUpdate);
                } else {
                  final barang = Barang(
                      id: Guid.generate(),
                      produkID: currentProduk!.id,
                      suplierID: currentSuplier!.id,
                      nama_barang: namaController.text,
                      created_at: DateTime.now().toIso8601String() + 'Z',
                      updated_at: null,
                      deleted_at: null);
                  service.createBarang(barang);
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

  Widget _deleteDialog(Barang _barang) {
    return AlertDialog(
      title: const Text('Delete Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text('Yakin Mau Hapus Barang ${_barang.nama_barang}?')],
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
            service.deleteBarang(_barang.id.toString());
            _refreshData();
            Navigator.pop(context);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }

  Widget _buildListView(List<Barang> barangs) {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: barangs.length,
          itemBuilder: (context, index) {
            Barang barang = barangs[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      barang.nama_barang,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () => {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _deleteDialog(barang);
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
                                return _dialogForm(true, barang);
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
    final List<Barang> _barang = await service.getBarangs();
    _barangList = _barang;
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(milliseconds: 100));
    final List<Barang> _barang = await service.getBarangs();
    setState(() {
      _barangList = _barang;
    });
  }

  @override
  void initState() {
    super.initState();
    usahas = usaha_service.getUsahas();
    produks = produk_service.getProduks();
    supliers = suplierService.getSupliers();
    futureBarang = _initData();
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
                  'Barang',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            FutureBuilder(
              future: futureBarang,
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
                      return _buildListView(_barangList);
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
  BarangService service = new BarangService();
  List<Barang> barangList = <Barang>[];
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
    barangList = await service.getBarangs();
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
    List<Barang> matchQuery = [];
    if (query.length < 2) return Container();

    initData();
    for (var data in barangList) {
      if (data.nama_barang.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(data);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.nama_barang),
        );
      },
    );
  }
}
