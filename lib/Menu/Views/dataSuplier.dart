import 'package:cma_management/model/Logs.dart';
import 'package:cma_management/model/Suplier.dart';
import 'package:cma_management/model/Usaha.dart';
import 'package:cma_management/services/logs_services.dart';
import 'package:cma_management/services/suplier_services.dart';
import 'package:cma_management/styles/colors.dart';
import 'package:cma_management/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';

class DataSuplier extends StatefulWidget {
  const DataSuplier({Key? key}) : super(key: key);

  @override
  _DataSuplierState createState() => _DataSuplierState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _DataSuplierState extends State<DataSuplier> {
  late List<Suplier> _suplierList;
  late Future<void> futureSuplier;
  SuplierService service = new SuplierService();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

//dialog form
  Widget _dialogForm(bool isUpdate, [Suplier? _suplier]) {
    final namaController = TextEditingController();
    final alamatController = TextEditingController();
    final notelpController = TextEditingController();
    String nohp = '';

    if (isUpdate) {
      namaController.text = _suplier!.nama_suplier;
      alamatController.text = '${_suplier.alamat!}';
      notelpController.text = '${_suplier.no_telp!}';
    }

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Dialog(
        //title: isUpdate ? const Text('Ubah Data') : const Text('Suplier Baru'),
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
                  text: "${isUpdate ? 'Ubah Data' : 'Suplier Baru'}",
                  size: 22,
                  fontWeight: FontWeight.w800,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: namaController,
                  decoration: new InputDecoration(
                      hintText: "Masukan Nama Suplier",
                      labelText: "Nama Suplier",
                      icon: Icon(Icons.people),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 1,
                      ))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: alamatController,
                  decoration: new InputDecoration(
                    hintText: "Masukan Alamat",
                    labelText: "Alamat",
                    icon: Icon(Icons.people),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 1,
                    )),
                  ),
                ),
                SizedBox(height: 10),
                IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'No.HP',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  disableLengthCheck: true,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(13),
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  initialValue: nohp,
                  controller: notelpController,
                  initialCountryCode: 'ID',
                  onChanged: (phone) {
                    nohp = phone.completeNumber;
                  },
                ),
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
                            final suplierToUpdate = Suplier(
                                id: _suplier!.id,
                                nama_suplier: namaController.text,
                                alamat: alamatController.text,
                                no_telp: notelpController.text,
                                created_at: _suplier.created_at,
                                updated_at:
                                    DateTime.now().toIso8601String() + 'Z',
                                deleted_at: _suplier.deleted_at);
                            service.updateSuplier(
                                suplierToUpdate.id.value, suplierToUpdate);
                          } else {
                            final suplier = Suplier(
                                id: Guid.generate(),
                                nama_suplier: namaController.text,
                                alamat: alamatController.text,
                                no_telp: notelpController.text,
                                created_at:
                                    DateTime.now().toIso8601String() + 'Z',
                                updated_at: null,
                                deleted_at: null);
                            service.createSuplier(suplier);
                            var log = Logs(
                                id: Guid.generate(),
                                namaLog:
                                    'User Admin Menambahkan Suplier ${suplier.nama_suplier}',
                                userID: Guid(
                                    'a0547ef6-9b97-4d7c-be79-47fc632bffed'),
                                column: 'Suplier',
                                action: 'Create',
                                timestamp: DateTime.now());
                            LogsService().createLog(log);
                          }

                          _refreshData();
                          Navigator.pop(context);
                        }
                      },
                      child:
                          isUpdate ? const Text('Update') : const Text('Save'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _deleteDialog(Suplier _suplier) {
    return AlertDialog(
      title: const Text('Delete Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text('Yakin Mau Hapus Suplier ${_suplier.nama_suplier}?')],
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
            service.deleteSuplier(_suplier.id.toString());
            _refreshData();
            Navigator.pop(context);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }

  Widget _buildListView(List<Suplier> supliers) {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: supliers.length,
          itemBuilder: (context, index) {
            Suplier suplier = supliers[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      suplier.nama_suplier,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Text('${suplier.alamat}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () => {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _deleteDialog(suplier);
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
                                return _dialogForm(true, suplier);
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
    final List<Suplier> _suplier = await service.getSupliers();
    _suplierList = _suplier;
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(milliseconds: 100));
    final List<Suplier> _suplier = await service.getSupliers();
    setState(() {
      _suplierList = _suplier;
    });
  }

  @override
  void initState() {
    super.initState();
    futureSuplier = _initData();
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
                  'Suplier',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            FutureBuilder(
              future: futureSuplier,
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
                      return _buildListView(_suplierList);
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
  SuplierService service = new SuplierService();
  List<Suplier> suplierList = <Suplier>[];
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
    suplierList = await service.getSupliers();
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
    List<Suplier> matchQuery = [];
    if (query.length < 2) return Container();

    initData();
    for (var data in suplierList) {
      if (data.nama_suplier.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(data);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.nama_suplier),
        );
      },
    );
  }
}
