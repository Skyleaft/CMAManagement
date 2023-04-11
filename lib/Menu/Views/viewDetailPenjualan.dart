import 'package:cma_management/Menu/Views/dataPenjualan.dart';
import 'package:cma_management/model/Barang.dart';
import 'package:cma_management/model/DetailPenjualan.dart';
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
  PenjualanService service = new PenjualanService();
  DetailPenjualanService detailPenjualanService = new DetailPenjualanService();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  int? totalItem;

  late List<Barang> _barangList;
  late Barang selectedBarang = _barangList.first;
  var barangController = TextEditingController();

//dialog form
  Widget _dialogForm(bool isUpdate, [DetailPenjualan? _detpenjualan]) {
    DateTime tanggal = DateTime.now();
    var qtyController = TextEditingController();
    var panjangController = TextEditingController();
    var hargaController = TextEditingController();
    qtyController.text = '0';
    if (isUpdate) {
      qtyController.text = '${_detpenjualan!.qty}';
      panjangController.text = '${_detpenjualan.panjang}';
      hargaController.text = '${_detpenjualan.harga_jual}';
      //fakturController.text = _penjualan!.faktur;
    }
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Dialog(
        //title: isUpdate ? const Text('Ubah Data') : const Text('Penjualan Baru'),
        insetPadding: const EdgeInsets.all(15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                      color: Color(int.parse(selectedBarang.speksifikasi!
                          .where((e) =>
                              e?.mspekID ==
                              "9fe65b33-762d-440e-b053-842feea58c20")
                          .first!
                          .value)),
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(width: 20),
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
                    Expanded(
                      child: TextButton(
                        onPressed: () => {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _dialogListBarang(setState);
                            },
                          )
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
                    hintText: "Harga Jual",
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
                        if (value != null && value != "") {
                          int currentp = int.parse(value);
                          int qty = (currentp / 100).floor();
                          qtyController.text = qty.toString();
                        } else {
                          qtyController.text = '0';
                        }
                      },
                    );
                  },
                  decoration: new InputDecoration(
                    hintText: "Panjang/100M",
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
                  readOnly: true,
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
                            // final penjualanToUpdate = Penjualan(
                            //     id: _penjualan!.id,
                            //     tanggal: tanggal,
                            //     created_at: _penjualan.created_at,
                            //     updated_at:
                            //         DateTime.now().toIso8601String() + 'Z',
                            //     deleted_at: _penjualan.deleted_at);
                            // service.updatePenjualan(
                            //     penjualanToUpdate.id.value, penjualanToUpdate);
                          } else {
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
                              int curentPanjang = currentStok.panjang;
                              curentPanjang -=
                                  int.parse(panjangController.text);
                              int currentQty = currentStok.jumlah;
                              currentQty = (curentPanjang / 100).floor();
                              dev.log('currentstok ada ${currentQty}');

                              Stok newStok = Stok(
                                  id: currentStok.id,
                                  barangID: selectedBarang.id,
                                  panjang: curentPanjang,
                                  jumlah: currentQty,
                                  updated_at: DateTime.now());
                              await StokService()
                                  .updateStok(newStok.id.value, newStok);
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

  Widget _dialogListBarang(StateSetter setState) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: "Search")),
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
                      return Expanded(
                        child: ListView.builder(
                          itemCount: _barangList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            var result = _barangList[index];
                            return Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: InkWell(
                                onTap: () async {
                                  if (result.stok == null) {
                                    print("Habis");
                                    Navigator.pop(context);
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Message'),
                                        content:
                                            const Text('Stok Barang Habis'),
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
                                      barangController.text =
                                          result.nama_barang;
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
                                          color: Color(int.parse(result
                                              .speksifikasi!
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
                                    Text(
                                      '${result.stok?.jumlah ?? 0}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(width: 8),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                }
              },
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
              int curentPanjang = currentStok!.panjang;
              curentPanjang -= _detailBeli.panjang!;
              int currentQty = (curentPanjang / 100).floor();
              Stok stokToUpdate = Stok(
                id: currentStok.id,
                barangID: _detailBeli.barangID,
                panjang: curentPanjang,
                jumlah: currentQty,
              );
              StokService().updateStok(currentStok.id.value, stokToUpdate);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${detail.barang?.nama_barang}',
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16),
                      ),
                      Text('qty :${detail.qty}'),
                      Text('Harga Beli : ${fmf.output.symbolOnLeft}'),
                    ],
                  ),
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
    if (widget.dataPenjualan.detailPenjualan == null) {
      totalItem = 0;
    } else {
      totalItem = widget.dataPenjualan.detailPenjualan!.length;
    }

    super.initState();
  }

  SampleItem? selectedMenu;
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return _dialogForm(false);
              },
            ),
          },
          label: const Text('Tambah Barang'),
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
