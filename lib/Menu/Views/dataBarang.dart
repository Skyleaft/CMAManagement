import 'package:cma_management/model/Barang.dart';
import 'package:cma_management/model/Logs.dart';
import 'package:cma_management/model/Produk.dart';
import 'package:cma_management/model/Speksifikasi.dart';
import 'package:cma_management/model/Suplier.dart';
import 'package:cma_management/model/Usaha.dart';
import 'package:cma_management/services/barang_services.dart';
import 'package:cma_management/services/logs_services.dart';
import 'package:cma_management/services/produk_services.dart';
import 'package:cma_management/services/speksifikasi_services.dart';
import 'package:cma_management/services/suplier_services.dart';
import 'package:cma_management/services/usaha_services.dart';
import 'package:cma_management/styles/colors.dart';
import 'package:cma_management/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
  late Future<void> futureSpek;
  BarangService service = new BarangService();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  List<Speksifikasi> _speksifikasi = <Speksifikasi>[];
  UsahaService usaha_service = new UsahaService();
  ProdukService produk_service = new ProdukService();
  SuplierService suplierService = new SuplierService();
  SpeksifikasiService speksifikasiService = new SpeksifikasiService();

  Future<List<Usaha>> usahas = UsahaService().getUsahas();
  Future<List<Produk>> produks = ProdukService().getProduks();
  Future<List<Suplier>> supliers = SuplierService().getSupliers();

  Widget _colorPickerForm(StateSetter setState) {
    void changeColor(Color color) {
      setState(() => pickerColor = color);
    }

    return AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          enableAlpha: false,
          pickerColor: pickerColor,
          onColorChanged: changeColor,
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Got it'),
          onPressed: () {
            setState(() => currentColor = pickerColor);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

//dialog form
  Widget _dialogForm(bool isUpdate, [Barang? _barang]) {
    final namaController = TextEditingController();
    final keteranganController = TextEditingController();
    Produk? currentProduk;
    Usaha? currentUsaha;
    Suplier? currentSuplier;

    if (isUpdate) {
      namaController.text = _barang!.nama_barang;
      currentColor = Color(int.parse(_barang.speksifikasi!
          .where((element) =>
              element!.mspekID == "9fe65b33-762d-440e-b053-842feea58c20")
          .first!
          .value));
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
              Row(
                children: [
                  Text("Produk : "),
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
                            var result = _produk
                                ?.where((item) =>
                                    item.usahaID ==
                                    Guid(
                                        'e44c46b9-fe04-4b14-a27a-f07824034079'))
                                .toList();
                            return DropdownButton<Produk?>(
                              value: currentProduk ??= result![0],
                              icon: const Icon(Icons.keyboard_arrow_down),
                              // Array list of items
                              items: result?.map<DropdownMenuItem<Produk>>(
                                  (Produk items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items.nama_produk),
                                );
                              }).toList(),
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
                ],
              ),
              TextFormField(
                controller: namaController,
                maxLength: 50,
                decoration: new InputDecoration(
                    hintText: "Masukan Warna",
                    labelText: "Nama Warna",
                    icon: Icon(Icons.people)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: currentColor),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                TextButton(
                  child: Row(
                    children: [Icon(Icons.palette), Text('Pick')],
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _colorPickerForm(setState);
                      },
                    );
                  },
                ),
              ]),
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
                      nama_barang: namaController.text,
                      created_at: _barang.created_at,
                      updated_at: DateTime.now(),
                      deleted_at: _barang.deleted_at);
                  service.updateBarang(barangToUpdate.id.value, barangToUpdate);
                } else {
                  var currentID = Guid.generate();

                  final spek1 = Speksifikasi(
                    id: Guid.generate(),
                    mspekID: Guid('a86e834a-383f-42e0-9083-08798cf4a395'),
                    barangID: currentID,
                    value: namaController.text,
                  );
                  speksifikasiService.createSpeksifikasi(spek1);
                  final spek2 = Speksifikasi(
                      id: Guid.generate(),
                      mspekID: Guid('9fe65b33-762d-440e-b053-842feea58c20'),
                      barangID: currentID,
                      value: currentColor.value.toString());
                  speksifikasiService.createSpeksifikasi(spek2);
                  List<Speksifikasi> listSpek = <Speksifikasi>[];
                  listSpek.add(spek1);
                  listSpek.add(spek2);
                  final barang = Barang(
                      id: currentID,
                      produkID: currentProduk!.id,
                      nama_barang:
                          '${currentProduk?.nama_produk} ${namaController.text}',
                      speksifikasi: listSpek,
                      created_at: DateTime.now(),
                      updated_at: null,
                      deleted_at: null);
                  service.createBarang(barang);
                  var log = Logs(
                      id: Guid.generate(),
                      namaLog:
                          'User Admin Menambahkan Barang ${barang.nama_barang}',
                      userID: Guid('a0547ef6-9b97-4d7c-be79-47fc632bffed'),
                      column: 'Barang',
                      action: 'Create',
                      timestamp: barang.created_at!);
                  LogsService().createLog(log);
                }

                await Future.delayed(Duration(milliseconds: 100));
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

  Widget _buildCardBarang(Barang _barang) {
    var bgCol = _barang.speksifikasi
        ?.where((element) =>
            element?.mspekID == Guid('9fe65b33-762d-440e-b053-842feea58c20'))
        .first!;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _barang.nama_barang,
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Stok: ${_barang.stok == null ? 0 : _barang.stok!.jumlah}"),
                    Text(
                        "Meter: ${_barang.stok == null ? 0 : _barang.stok!.panjang}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.red, minimumSize: Size(5, 5)),
                      onPressed: () => {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _deleteDialog(_barang);
                          },
                        )
                      },
                      child: Icon(Icons.delete),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: CMATheme.grey,
                          minimumSize: Size(5, 5)),
                      onPressed: () => {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _dialogForm(true, _barang);
                          },
                        )
                      },
                      child: Icon(Icons.edit),
                    ),
                  ],
                )
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(int.parse(bgCol!.value)),
              ),
            )
          ],
        ),
      ),
    );
    ;
  }

  Widget _buildListView(List<Barang> barangs) {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: GridView.builder(
          padding: EdgeInsets.all(10),
          itemBuilder: (context, index) => _buildCardBarang(barangs[index]),
          itemCount: barangs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: (MediaQuery.of(context).size.height * 0.0016)),
        ),
      ),
    );
  }

  Future<void> _initData() async {
    final List<Barang> _barang = await service.getBarangs();
    _barangList = _barang;
  }

  Future<void> initSpek() async {
    await Future.delayed(Duration(milliseconds: 100));
    _speksifikasi = await speksifikasiService.getSpeksifikasis();
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
    // usahas = usaha_service.getUsahas();
    // produks = produk_service.getProduks();
    // supliers = suplierService.getSupliers();
    futureBarang = _initData();
    futureSpek = initSpek();
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
