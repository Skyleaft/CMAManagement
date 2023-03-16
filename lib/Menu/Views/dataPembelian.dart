import 'package:cma_management/Menu/Views/viewDetailPembelian.dart';
import 'package:cma_management/model/Pembelian.dart';
import 'package:cma_management/model/Suplier.dart';
import 'package:cma_management/model/Usaha.dart';
import 'package:cma_management/services/pembelian_services.dart';
import 'package:cma_management/services/suplier_services.dart';
import 'package:cma_management/styles/colors.dart';
import 'package:cma_management/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class DataPembelian extends StatefulWidget {
  const DataPembelian({Key? key}) : super(key: key);

  @override
  _DataPembelianState createState() => _DataPembelianState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _DataPembelianState extends State<DataPembelian> {
  late List<Pembelian> _pembelianList;
  late Future<void> futurePembelian;
  PembelianService service = new PembelianService();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<List<Suplier>> supliers = SuplierService().getSupliers();
  Suplier? currentSuplier;

//dialog form
  Widget _dialogForm(bool isUpdate, [Pembelian? _pembelian]) {
    final fakturController = TextEditingController();
    DateTime tanggal = DateTime.now();
    var tanggalController = TextEditingController();
    tanggalController.text = DateFormat.yMMMEd().format(tanggal);

    if (isUpdate) {
      fakturController.text = _pembelian!.faktur;
    }

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Dialog(
        //title: isUpdate ? const Text('Ubah Data') : const Text('Pembelian Baru'),
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
                  text: "${isUpdate ? 'Ubah Data' : 'Pembelian Baru'}",
                  size: 22,
                  fontWeight: FontWeight.w800,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("Supplier : "),
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
                                items: _suplier?.map<DropdownMenuItem<Suplier>>(
                                    (Suplier items) {
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
                  ],
                ),
                TextFormField(
                  controller: fakturController,
                  decoration: new InputDecoration(
                      hintText: "Masukan Nomor Faktur",
                      labelText: "Faktur Pembelian",
                      icon: Icon(Icons.people)),
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
                              minTime: DateTime(2016, 1, 1),
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
                            final pembelianToUpdate = Pembelian(
                                id: _pembelian!.id,
                                faktur: fakturController.text,
                                tanggal: tanggal,
                                suplierID: currentSuplier!.id,
                                created_at: _pembelian.created_at,
                                updated_at:
                                    DateTime.now().toIso8601String() + 'Z',
                                deleted_at: _pembelian.deleted_at);
                            service.updatePembelian(
                                pembelianToUpdate.id.value, pembelianToUpdate);
                          } else {
                            final pembelian = Pembelian(
                                id: Guid.generate(),
                                faktur: fakturController.text,
                                tanggal: tanggal,
                                suplierID: currentSuplier!.id,
                                created_at:
                                    DateTime.now().toIso8601String() + 'Z',
                                updated_at: null,
                                deleted_at: null);
                            service.createPembelian(pembelian);
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

  Widget _deleteDialog(Pembelian _pembelian) {
    return AlertDialog(
      title: const Text('Delete Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text('Yakin Mau Hapus Pembelian ${_pembelian.faktur}?')],
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
            service.deletePembelian(_pembelian.id.toString());
            _refreshData();
            Navigator.pop(context);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }

  Widget _buildListView(List<Pembelian> pembelians) {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: pembelians.length,
          itemBuilder: (context, index) {
            Pembelian pembelian = pembelians[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      pembelian.faktur,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Text('${pembelian.tanggal}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () => {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _deleteDialog(pembelian);
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
                                return _dialogForm(true, pembelian);
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
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return _dialogForm(true, pembelian);
                            //   },
                            // )
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => viewDetailPembelian(
                                        dataPembelian: pembelian,
                                      )),
                            )
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
    final List<Pembelian> _pembelian = await service.getPembelians();
    _pembelianList = _pembelian;
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(milliseconds: 100));
    final List<Pembelian> _pembelian = await service.getPembelians();
    setState(() {
      _pembelianList = _pembelian;
    });
  }

  @override
  void initState() {
    super.initState();
    futurePembelian = _initData();
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
                  'Pembelian',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            FutureBuilder(
              future: futurePembelian,
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
                      return _buildListView(_pembelianList);
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
  PembelianService service = new PembelianService();
  List<Pembelian> pembelianList = <Pembelian>[];
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
    pembelianList = await service.getPembelians();
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
    List<Pembelian> matchQuery = [];
    if (query.length < 2) return Container();

    initData();
    for (var data in pembelianList) {
      if (data.faktur.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(data);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.faktur),
        );
      },
    );
  }
}
