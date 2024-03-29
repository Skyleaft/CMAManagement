import 'package:cma_management/Menu/Views/cetakPenjualan.dart';
import 'package:cma_management/Menu/Views/dataPenjualan.dart';
import 'package:cma_management/model/Barang.dart';
import 'package:cma_management/model/DetailPenjualan.dart';
import 'package:cma_management/model/FakturPenjualan.dart';
import 'package:cma_management/model/Penjualan.dart';
import 'package:cma_management/model/Stok.dart';
import 'package:cma_management/model/Suplier.dart';
import 'package:cma_management/services/barang_services.dart';
import 'package:cma_management/services/detailpenjualan_services.dart';
import 'package:cma_management/services/penjualan_services.dart';
import 'package:cma_management/services/stok_services.dart';
import 'package:cma_management/services/suplier_services.dart';
import 'package:cma_management/styles/colors.dart';
import 'package:cma_management/styles/styles.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:money_formatter/money_formatter.dart';
import 'dart:developer' as dev;

class viewDetailPenjualan extends StatefulWidget {
  const viewDetailPenjualan({Key? key, required this.dataPenjualan})
      : super(key: key);
  final Penjualan dataPenjualan;

  @override
  _viewDetailPenjualanState createState() => _viewDetailPenjualanState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _viewDetailPenjualanState extends State<viewDetailPenjualan> {
  late List<Penjualan?>? _penjualanList;
  late List<DetailPenjualan?>? _detailPenjualanList;
  late Future<void> futurePenjualan;
  late Future<void> futureBarangList;
  PenjualanService service = new PenjualanService();
  DetailPenjualanService detailPenjualanService = new DetailPenjualanService();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  int? totalItem;

  late List<Barang> _barangList;
  late Barang selectedBarang = _barangList.first;
  var barangController = TextEditingController();
  Color selectedBarangColor = Colors.deepOrange;

//dialog form
  Widget _dialogForm(bool isUpdate, [DetailPenjualan? _detpenjualan]) {
    DateTime tanggal = DateTime.now();
    var qtyController = TextEditingController();
    var panjangController = TextEditingController();
    var hargaController = TextEditingController();
    var keteranganController = TextEditingController();
    if (isUpdate) {
      qtyController.text = '${_detpenjualan!.qty}';
      panjangController.text = '${_detpenjualan.panjang}';
      hargaController.text = '${_detpenjualan.harga_jual}';
      //fakturController.text = _penjualan!.faktur;
    }
    bool isLoading = false;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Dialog(
        //title: isUpdate ? const Text('Ubah Data') : const Text('Penjualan Baru'),
        insetPadding: const EdgeInsets.all(15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          height: 550,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 10),
                PrimaryText(
                  text: "${isUpdate ? 'Ubah Data' : 'Tambah Barang'}",
                  size: 22,
                  fontWeight: FontWeight.w800,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      color: selectedBarangColor,
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: barangController,
                        decoration: new InputDecoration(
                          labelText: "Nama Barang",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      child: TextButton(
                        onPressed: () => {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _dialogListBarang(setState);
                            },
                          ).then((_) {
                            setState(() => {
                                  selectedBarangColor = Color(int.parse(
                                      selectedBarang.speksifikasi!
                                          .where((e) =>
                                              e?.mspekID ==
                                              "9fe65b33-762d-440e-b053-842feea58c20")
                                          .first!
                                          .value))
                                });
                          }),
                        },
                        child: const Text(
                          'Pilih Barang',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: hargaController,
                  decoration: new InputDecoration(
                    hintText: "Harga Jual /Meter",
                    labelText: "Harga",
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                        locale: 'id', decimalDigits: 0, symbol: 'Rp. '),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: panjangController,
                  maxLength: 7,
                  onChanged: (value) {
                    setState(
                      () {
                        // if (value != null && value != "") {
                        //   int currentp = int.parse(value);
                        //   int qty = (currentp / 100).floor();
                        //   qtyController.text = qty.toString();
                        // } else {
                        //   qtyController.text = '0';
                        // }
                      },
                    );
                  },
                  decoration: new InputDecoration(
                    hintText: "Panjang /Meter",
                    labelText: "Jumlah Panjang",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a jumlah';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: qtyController,
                  maxLength: 7,
                  decoration: new InputDecoration(
                    hintText: "Jumlah",
                    labelText: "Qty",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a jumlah';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: keteranganController,
                  decoration: new InputDecoration(
                    hintText: "Keterangan",
                    labelText: "Keterangan",
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (!isLoading) {
                            setState(() => {isLoading = true});
                            if (_formKey.currentState!.validate()) {
                              final detPenjualan = DetailPenjualan(
                                id: Guid.generate(),
                                barangID: selectedBarang.id,
                                penjualanID: widget.dataPenjualan.id,
                                harga_jual: int.parse(hargaController.text
                                    .replaceAll(RegExp(r'[^0-9]'), '')),
                                panjang: int.parse(panjangController.text),
                                qty: int.parse(qtyController.text),
                              );
                              detailPenjualanService
                                  .createDetailPenjualan(detPenjualan);
                              Stok? currentStok = await StokService()
                                  .getStokByBarang(selectedBarang.id.value);
                              if (currentStok == null) {
                                Stok newStok = Stok(
                                    id: Guid.generate(),
                                    barangID: selectedBarang.id,
                                    panjang: int.parse(panjangController.text),
                                    jumlah: int.parse(qtyController.text),
                                    created_at: DateTime.now());
                                await StokService().createStok(newStok);
                              } else {
                                int curentPanjang =
                                    int.parse(panjangController.text);
                                int currentQty = int.parse(qtyController.text);

                                Stok newStok = Stok(
                                    id: currentStok.id,
                                    barangID: selectedBarang.id,
                                    panjang: curentPanjang,
                                    jumlah: currentQty,
                                    updated_at: DateTime.now());
                                await StokService().minStok(newStok);
                              }
                              await Future.delayed(Duration(milliseconds: 500));

                              _formKey.currentState!.save();
                              _refreshData();
                              Navigator.pop(context);
                              setState(() => {isLoading = false});
                            }
                          }
                        },
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Save')),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _dialogListBarang(StateSetter setState) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Search"),
                onChanged: (value) {
                  setState(() {
                    filterSearchResults(value.toLowerCase());
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _barangList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    var result = _barangList[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: InkWell(
                        onTap: () async {
                          if (result.stok == null) {
                            print("Habis");
                            Navigator.pop(context);
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Message'),
                                content: const Text('Stok Barang Habis'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            setState(() {
                              Navigator.pop(context);
                              barangController.text = result.nama_barang;
                              selectedBarang = result;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 15,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Color(int.parse(result.speksifikasi!
                                      .where((e) =>
                                          e?.mspekID ==
                                          "9fe65b33-762d-440e-b053-842feea58c20")
                                      .first!
                                      .value))),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${result.nama_barang}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Expanded(
                                child: SizedBox(
                              width: 20,
                            )),
                            SizedBox(width: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _deleteDialog(DetailPenjualan _detailBeli) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return AlertDialog(
        title: const Text('Delete Barang'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Yakin Mau Hapus Barang ${_detailBeli.barang!.nama_barang}?')
          ],
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
              Stok? currentStok = await StokService()
                  .getStokByBarang(_detailBeli.barangID.value);
              // int curentPanjang = currentStok!.panjang;
              // curentPanjang -= _detailBeli.panjang!;
              // int currentQty = (curentPanjang / 100).floor();
              // Stok stokToUpdate = Stok(
              //   id: currentStok.id,
              //   barangID: _detailBeli.barangID,
              //   panjang: curentPanjang,
              //   jumlah: currentQty,
              // );
              // StokService().updateStok(currentStok.id.value, stokToUpdate);
              StokService().minStok(currentStok!);
              detailPenjualanService
                  .deleteDetailPenjualan(_detailBeli.id.toString());
              _refreshData();
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      );
    });
  }

  Widget _buildListView(List<DetailPenjualan?>? detPenjualans) {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: detPenjualans!.length,
          itemBuilder: (context, index) {
            DetailPenjualan detail = detPenjualans[index]!;
            MoneyFormatter fmf = new MoneyFormatter(
                amount: double.parse(detail.harga_jual.toString()),
                settings: MoneyFormatterSettings(
                  symbol: 'Rp.',
                  thousandSeparator: '.',
                  decimalSeparator: ',',
                  symbolAndNumberSeparator: ' ',
                  fractionDigits: 0,
                ));
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Color(int.parse(detail.barang!.speksifikasi!
                          .where((e) =>
                              e?.mspekID ==
                              "9fe65b33-762d-440e-b053-842feea58c20")
                          .first!
                          .value)),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${detail.barang?.nama_barang}',
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16),
                      ),
                      Text('Qty :${detail.qty}'),
                      Text('Meter :${detail.panjang} m.'),
                      Text('Harga Beli : ${fmf.output.symbolOnLeft}'),
                    ],
                  ),
                  Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () => {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _deleteDialog(detail);
                            },
                          )
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _initData() async {
    final List<DetailPenjualan> _detail = await detailPenjualanService
        .getByPenjualan(widget.dataPenjualan.id.value);
    _detailPenjualanList = _detail;
  }

  Future<void> _initBarangList() async {
    final List<Barang> barangList = await BarangService().getBarangs();
    _barangList = barangList;
  }

  Future<List<Barang>> _getBarangs() async {
    final List<Barang> data = await BarangService().getBarangs();
    return data;
  }

  Future<void> filterSearchResults(String query) async {
    final data = _barangList;
    setState(() {
      _barangList = data
          .where((item) => item.nama_barang.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final List<DetailPenjualan> _detail = await detailPenjualanService
        .getByPenjualan(widget.dataPenjualan.id.value);
    _detailPenjualanList = _detail;

    setState(() {
      _detailPenjualanList = _detail;
      totalItem = _detail.length;
    });
  }

  @override
  void initState() {
    futurePenjualan = _initData();
    futureBarangList = _initBarangList();
    if (widget.dataPenjualan.detailPenjualan == null) {
      totalItem = 0;
    } else {
      totalItem = widget.dataPenjualan.detailPenjualan!.length;
    }

    super.initState();
  }

  SampleItem? selectedMenu;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      FakturPenjualan? _faktur;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.iconGray),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: true,
        floatingActionButton: SpeedDial(
          icon: Icons.menu,
          activeIcon: Icons.close,
          spacing: 3,
          openCloseDial: isDialOpen,
          childPadding: const EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          elevation: 8.0,
          animationCurve: Curves.elasticInOut,
          children: [
            SpeedDialChild(
                child: const Icon(Icons.print),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                label: 'Cetak',
                onTap: () async => {
                      _faktur = await PenjualanService()
                          .getFakturPenjualan(widget.dataPenjualan.id.value)
                          .then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CetakPenjualan(
                                          dataPenjualan: widget.dataPenjualan,
                                          fakturPenjualan: value!,
                                        )),
                              ))
                    }),
            SpeedDialChild(
              child: const Icon(Icons.add),
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              label: 'Tambah Barang',
              onTap: () => {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _dialogForm(false);
                  },
                ),
              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.white,
                width: double.infinity,
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      Text(
                        'No.Faktur : ${widget.dataPenjualan.no_faktur}',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Jumlah penjualan : ${totalItem}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
              FutureBuilder(
                future: BarangService().getBarangs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    case ConnectionState.done:
                      {
                        _barangList = snapshot.data!;
                        return SizedBox();
                      }
                  }
                },
              ),
              FutureBuilder(
                future: futurePenjualan,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    case ConnectionState.done:
                      {
                        return _buildListView(_detailPenjualanList);
                      }
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
