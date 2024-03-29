import 'package:cma_management/Menu/Views/dataPembelian.dart';
import 'package:cma_management/model/Barang.dart';
import 'package:cma_management/model/DetailPembelian.dart';
import 'package:cma_management/model/Pembelian.dart';
import 'package:cma_management/model/Stok.dart';
import 'package:cma_management/model/Suplier.dart';
import 'package:cma_management/services/barang_services.dart';
import 'package:cma_management/services/detailpembelian_services.dart';
import 'package:cma_management/services/pembelian_services.dart';
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

class viewDetailPembelian extends StatefulWidget {
  const viewDetailPembelian({Key? key, required this.dataPembelian})
      : super(key: key);
  final Pembelian dataPembelian;

  @override
  _viewDetailPembelianState createState() => _viewDetailPembelianState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _viewDetailPembelianState extends State<viewDetailPembelian> {
  late List<Pembelian> _pembelianList;
  late List<DetailPembelian?>? _detailPembelianList;
  late Future<void> futurePembelian;
  late Future<void> futureBarangList;
  PembelianService service = new PembelianService();
  DetailPembelianService detailPembelianService = new DetailPembelianService();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  int? totalItem;

  List<Barang> _barangList = [];
  late Barang selectedBarang = _barangList.first;
  var barangController = TextEditingController();
  Color selectedBarangColor = Colors.deepOrange;

//dialog form
  Widget _dialogForm(bool isUpdate, [DetailPembelian? _detpembelian]) {
    DateTime tanggal = DateTime.now();
    var qtyController = TextEditingController();
    var panjangController = TextEditingController();
    var hargaController = TextEditingController();
    var keteranganController = TextEditingController();
    if (isUpdate) {
      qtyController.text = '${_detpembelian!.qty}';
      panjangController.text = '${_detpembelian!.panjang}';
      hargaController.text = '${_detpembelian!.harga_beli}';
      //fakturController.text = _pembelian!.faktur;
    }
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Dialog(
        //title: isUpdate ? const Text('Ubah Data') : const Text('Pembelian Baru'),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              return _dialogListBarang();
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
                    hintText: "Harga Beli /Meter",
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
                        //   int qty = (currentp / 100).ceil();
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
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          if (isUpdate) {
                            // final pembelianToUpdate = Pembelian(
                            //     id: _pembelian!.id,
                            //     tanggal: tanggal,
                            //     created_at: _pembelian.created_at,
                            //     updated_at:
                            //         DateTime.now().toIso8601String() + 'Z',
                            //     deleted_at: _pembelian.deleted_at);
                            // service.updatePembelian(
                            //     pembelianToUpdate.id.value, pembelianToUpdate);
                          } else {
                            final detPembelian = DetailPembelian(
                              id: Guid.generate(),
                              barangID: selectedBarang.id,
                              pembelianID: widget.dataPembelian.id,
                              harga_beli: int.parse(hargaController.text
                                  .replaceAll(RegExp(r'[^0-9]'), '')),
                              panjang: int.parse(panjangController.text),
                              qty: int.parse(qtyController.text),
                            );
                            detailPembelianService
                                .createDetailPembelian(detPembelian);
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
                              await StokService().addStok(newStok);
                              dev.log('stok ada ${newStok.jumlah}');
                            }
                          }

                          _refreshData();
                          Navigator.pop(context);
                        }
                      },
                      child:
                          isUpdate ? const Text('Update') : const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _dialogListBarang() {
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
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            Navigator.pop(context);
                            barangController.text = result.nama_barang;
                            selectedBarang = result;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 10,
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

  Widget _deleteDialog(DetailPembelian _detailBeli) {
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
              StokService().minStok(currentStok!);
              detailPembelianService
                  .deleteDetailPembelian(_detailBeli.id.toString());
              _refreshData();
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      );
    });
  }

  Widget _buildListView(List<DetailPembelian?>? detPembelians) {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 80.0),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: detPembelians!.length,
          itemBuilder: (context, index) {
            DetailPembelian detail = detPembelians[index]!;
            MoneyFormatter fmf = new MoneyFormatter(
                amount: double.parse(detail.harga_beli.toString()),
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
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                            minimumSize: Size(5, 5)),
                        onPressed: () => {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _deleteDialog(detail);
                            },
                          )
                        },
                        child: Icon(Icons.delete),
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
    final List<DetailPembelian> _detail = await detailPembelianService
        .getByPembelian(widget.dataPembelian.id.value);
    _detailPembelianList = _detail;
  }

  Future<void> _initBarangList() async {
    final List<Barang> barangList = await BarangService().getBarangs();
    _barangList = barangList;
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
    final List<DetailPembelian> _detail = await detailPembelianService
        .getByPembelian(widget.dataPembelian.id.value);
    _detailPembelianList = _detail;

    setState(() {
      _detailPembelianList = _detail;
      totalItem = _detail.length;
    });
  }

  @override
  void initState() {
    futurePembelian = _initData();
    futureBarangList = _initBarangList();
    if (widget.dataPembelian.detailPembelian == null) {
      totalItem = 0;
    } else {
      totalItem = widget.dataPembelian.detailPembelian!.length;
    }

    super.initState();
  }

  SampleItem? selectedMenu;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
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
              onTap: () => setState(() => {}),
              onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
            ),
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
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () => {
        //     showDialog(
        //       context: context,
        //       builder: (BuildContext context) {
        //         return _dialogForm(false);
        //       },
        //     ),
        //   },
        //   label: const Text('Tambah Barang'),
        //   icon: const Icon(Icons.add),
        //   backgroundColor: AppColors.primary,
        // ),
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
                        'No.Faktur : ${widget.dataPembelian.faktur}',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Jumlah pembelian : ${totalItem}',
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
                future: futurePembelian,
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
                        return _buildListView(_detailPembelianList);
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
