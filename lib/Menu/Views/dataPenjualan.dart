import 'package:cma_management/Menu/Views/viewDetailPenjualan.dart';
import 'package:cma_management/model/Customer.dart';
import 'package:cma_management/model/DetailPenjualan.dart';
import 'package:cma_management/model/Penjualan.dart';
import 'package:cma_management/model/Stok.dart';
import 'package:cma_management/model/Customer.dart';
import 'package:cma_management/model/Usaha.dart';
import 'package:cma_management/services/customer_services.dart';
import 'package:cma_management/services/penjualan_services.dart';
import 'package:cma_management/services/stok_services.dart';
import 'package:cma_management/services/suplier_services.dart';
import 'package:cma_management/styles/colors.dart';
import 'package:cma_management/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'dart:developer' as dev;

import 'package:money_formatter/money_formatter.dart';

class DataPenjualan extends StatefulWidget {
  const DataPenjualan({Key? key}) : super(key: key);

  @override
  _DataPenjualanState createState() => _DataPenjualanState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _DataPenjualanState extends State<DataPenjualan> {
  late List<Penjualan> _penjualanList;
  late Future<void> futurePenjualan;
  PenjualanService service = new PenjualanService();
  late Penjualan? latestPenjualan;
  final _formKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<List<Customer>> customers = CustomerService().getCustomers();
//dialog form
  Widget _dialogForm(bool isUpdate, [Penjualan? _penjualan]) {
    final no_fakturController = TextEditingController();
    DateTime jatuhTempo = DateTime.now();
    var jatuhTempoController = TextEditingController();
    jatuhTempoController.text = DateFormat.yMMMEd().format(jatuhTempo);
    DateTime tanggal = DateTime.now();
    var tanggalController = TextEditingController();
    tanggalController.text = DateFormat.yMMMEd().format(tanggal);
    Customer? currentCustomer;

    //generate faktur
    String newFaktur = '';
    if (latestPenjualan == null) {
      newFaktur = 'CMA/J${DateFormat('yyM').format(DateTime.now())}/0001';
    } else {
      List<String> fakturSplit = latestPenjualan!.no_faktur.split('/');
      int currentNumber = int.parse(fakturSplit.last) + 1;

      if (currentNumber < 10) {
        newFaktur =
            'CMA/J${DateFormat('yyM').format(DateTime.now())}/000${currentNumber}';
      } else if (currentNumber < 100) {
        newFaktur =
            'CMA/J${DateFormat('yyM').format(DateTime.now())}/00${currentNumber}';
      } else if (currentNumber < 1000) {
        newFaktur =
            'CMA/J${DateFormat('yyM').format(DateTime.now())}/0${currentNumber}';
      } else {
        newFaktur =
            'CMA/J${DateFormat('yyM').format(DateTime.now())}/${currentNumber}';
      }
    }

    no_fakturController.text = newFaktur;

    if (isUpdate) {
      no_fakturController.text = _penjualan!.no_faktur;
      jatuhTempo = _penjualan.jatuh_tempo;
      jatuhTempoController.text = _penjualan.jatuh_tempo.toString();
    }

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Dialog(
        insetPadding: EdgeInsets.all(15),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                PrimaryText(
                  text: "${isUpdate ? 'Ubah Data' : 'Penjualan Baru'}",
                  size: 22,
                  fontWeight: FontWeight.w800,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("Customer : "),
                    FutureBuilder(
                      future: customers,
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
                              List<Customer>? _customer = snapshot.data;
                              if (isUpdate) {
                                currentCustomer = _customer!
                                    .where((element) =>
                                        element.id == _penjualan?.customerID)
                                    .first;
                              }
                              return DropdownButton<Customer>(
                                value: currentCustomer ??= _customer!.first,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                // Array list of items
                                items: _customer
                                    ?.map<DropdownMenuItem<Customer>>(
                                        (Customer items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items.nama_customer),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (Customer? newValue) {
                                  setState(() {
                                    currentCustomer = newValue;
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
                  controller: no_fakturController,
                  decoration: new InputDecoration(
                      hintText: "Masukan Nomor Faktur",
                      labelText: "Faktur Penjualan",
                      icon: Icon(Icons.people)),
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: tanggalController,
                        decoration: new InputDecoration(
                            labelText: "Tanggal Pembelian",
                            icon: Icon(Icons.date_range)),
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
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2019, 1, 1),
                              maxTime: DateTime.now().add(Duration(days: 365)),
                              onChanged: (date) {
                            tanggalController.text =
                                DateFormat.yMMMEd().format(tanggal);
                            tanggal = date;
                          }, onConfirm: (date) {
                            tanggalController.text =
                                DateFormat.yMMMEd().format(tanggal);
                            tanggal = date;
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.id);
                        },
                        child: Text(
                          'Pilih Tanggal',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: jatuhTempoController,
                        decoration: new InputDecoration(
                            labelText: "Jatuh Tempo Pembayaran",
                            icon: Icon(Icons.date_range)),
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
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: tanggal,
                              maxTime: DateTime.now().add(Duration(days: 365)),
                              onChanged: (date) {
                            jatuhTempoController.text =
                                DateFormat.yMMMEd().format(jatuhTempo);
                            jatuhTempo = date;
                          }, onConfirm: (date) {
                            jatuhTempoController.text =
                                DateFormat.yMMMEd().format(jatuhTempo);
                            jatuhTempo = date;
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.id);
                        },
                        child: Text(
                          'Pilih Tanggal',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
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
                            final penjualanToUpdate = Penjualan(
                                id: _penjualan!.id,
                                no_faktur: no_fakturController.text,
                                jatuh_tempo: jatuhTempo,
                                tanggal: tanggal,
                                customerID: currentCustomer!.id,
                                created_at: _penjualan.created_at,
                                updated_at:
                                    DateTime.now().toIso8601String() + 'Z',
                                deleted_at: _penjualan.deleted_at);
                            service.updatePenjualan(
                                penjualanToUpdate.id.value, penjualanToUpdate);
                          } else {
                            final penjualan = Penjualan(
                                id: Guid.generate(),
                                no_faktur: no_fakturController.text,
                                jatuh_tempo: jatuhTempo,
                                tanggal: tanggal,
                                customerID: currentCustomer!.id,
                                created_at:
                                    DateTime.now().toIso8601String() + 'Z',
                                updated_at: null,
                                deleted_at: null);
                            service
                                .createPenjualan(penjualan)
                                .then((value) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            viewDetailPenjualan(
                                          dataPenjualan: value,
                                        ),
                                      ),
                                    ).then((_) {
                                      _refreshData();
                                    }));
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

  Widget _deleteDialog(Penjualan _penjualan) {
    return AlertDialog(
      title: const Text('Delete Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text('Yakin Mau Hapus Penjualan ${_penjualan.no_faktur}?')],
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
            // await StokService().deleteStokbyPenjualan(_penjualan.id.value);
            service.deletePenjualan(_penjualan.id.toString());
            _refreshData();
            Navigator.pop(context);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }

  Widget _buildListView(List<Penjualan> penjualans) {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: penjualans.length,
          itemBuilder: (context, index) {
            Penjualan _penjualan = penjualans[index];
            List<DetailPenjualan?>? det = _penjualan.detailPenjualan;
            double totalPenjualan = 0;

            if (det!.length > 0) {
              int subTotal = 0;
              for (int i = 0; i < det.length; i++) {
                subTotal = det[i]!.harga_jual * det[i]!.panjang!;
                totalPenjualan += subTotal.toDouble();
              }
              // int? totalHarga = det
              //     .map((e) => e?.harga_jual)
              //     .reduce((value, current) => value! + current!);
              // int? totalqty = det
              //     .map((e) => e?.qty)
              //     .reduce((value, current) => value! + current!);
              // totalPenjualan = totalHarga!.toDouble() * totalqty!.toDouble();
            }

            MoneyFormatter fmf = MoneyFormatter(
                amount: totalPenjualan,
                settings: MoneyFormatterSettings(
                  symbol: 'Rp.',
                  thousandSeparator: '.',
                  decimalSeparator: ',',
                  symbolAndNumberSeparator: ' ',
                  fractionDigits: 0,
                ));

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _penjualan.no_faktur,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                                '${DateFormat("dd-MM-yyyy").format(_penjualan.jatuh_tempo)}'),
                            Text('${_penjualan.customer?.nama_customer}'),
                            Text('${det.length.toString()} item'),
                          ],
                        ),
                        Text(
                          '${fmf.output.symbolOnLeft}',
                          style: TextStyle(color: Colors.green, fontSize: 18),
                        ),
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
                                return _deleteDialog(_penjualan);
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
                                return _dialogForm(true, _penjualan);
                              },
                            )
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                        TextButton(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => viewDetailPenjualan(
                                  dataPenjualan: _penjualan,
                                ),
                              ),
                            ).then((_) {
                              _refreshData();
                            })
                          },
                          child: Text(
                            "Detail",
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
    final List<Penjualan> _penjualan = await service.getPenjualans();
    final _latest = await service.getLatestPenjualan();
    setState(() {
      latestPenjualan = _latest;
      _penjualanList = _penjualan;
    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(milliseconds: 100));
    final List<Penjualan> _penjualan = await service.getPenjualans();
    final _latest = await service.getLatestPenjualan();
    setState(() {
      latestPenjualan = _latest!;
      _penjualanList = _penjualan;
    });
  }

  @override
  void initState() {
    super.initState();
    futurePenjualan = _initData();
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
                  'Penjualan',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            FutureBuilder(
              future: futurePenjualan,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    {
                      return Center(
                        child: Text("Penjualan Masih Kosong"),
                      );
                    }
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  case ConnectionState.done:
                    {
                      return _buildListView(_penjualanList);
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
  PenjualanService service = new PenjualanService();
  List<Penjualan> penjualanList = <Penjualan>[];
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
    penjualanList = await service.getPenjualans();
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
    List<Penjualan> matchQuery = [];
    if (query.length < 2) return Container();

    initData();
    for (var data in penjualanList) {
      if (data.no_faktur.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(data);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.no_faktur),
        );
      },
    );
  }
}
