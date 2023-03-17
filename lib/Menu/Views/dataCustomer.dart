import 'package:cma_management/model/Customer.dart';
import 'package:cma_management/model/Usaha.dart';
import 'package:cma_management/services/customer_services.dart';
import 'package:cma_management/styles/colors.dart';
import 'package:cma_management/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class DataCustomer extends StatefulWidget {
  const DataCustomer({Key? key}) : super(key: key);

  @override
  _DataCustomerState createState() => _DataCustomerState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _DataCustomerState extends State<DataCustomer> {
  late List<Customer> _customerList;
  late Future<void> futureCustomer;
  CustomerService service = new CustomerService();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

//dialog form
  Widget _dialogForm(bool isUpdate, [Customer? _customer]) {
    final namaController = TextEditingController();
    final alamatController = TextEditingController();
    final notelpController = TextEditingController();
    String nohp = '';

    if (isUpdate) {
      namaController.text = _customer!.nama_customer;
      alamatController.text = '${_customer.alamat!}';
      notelpController.text = '${_customer.no_telp!}';
    }

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Dialog(
        //title: isUpdate ? const Text('Ubah Data') : const Text('Customer Baru'),
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
                  text: "${isUpdate ? 'Ubah Data' : 'Customer Baru'}",
                  size: 22,
                  fontWeight: FontWeight.w800,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: namaController,
                  decoration: new InputDecoration(
                      hintText: "Masukan Nama Customer",
                      labelText: "Nama Customer",
                      icon: Icon(Icons.people),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: alamatController,
                  decoration: new InputDecoration(
                      hintText: "Masukan Alamat",
                      labelText: "Alamat",
                      icon: Icon(Icons.people),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
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
                            final customerToUpdate = Customer(
                                id: _customer!.id,
                                nama_customer: namaController.text,
                                alamat: alamatController.text,
                                no_telp: notelpController.text,
                                created_at: _customer.created_at,
                                updated_at:
                                    DateTime.now().toIso8601String() + 'Z',
                                deleted_at: _customer.deleted_at);
                            service.updateCustomer(
                                customerToUpdate.id.value, customerToUpdate);
                          } else {
                            final customer = Customer(
                                id: Guid.generate(),
                                nama_customer: namaController.text,
                                alamat: alamatController.text,
                                no_telp: notelpController.text,
                                created_at:
                                    DateTime.now().toIso8601String() + 'Z',
                                updated_at: null,
                                deleted_at: null);
                            service.createCustomer(customer);
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

  Widget _deleteDialog(Customer _customer) {
    return AlertDialog(
      title: const Text('Delete Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Yakin Mau Hapus Customer ${_customer.nama_customer}?')
        ],
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
            service.deleteCustomer(_customer.id.toString());
            _refreshData();
            Navigator.pop(context);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }

  Widget _buildListView(List<Customer> customers) {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: customers.length,
          itemBuilder: (context, index) {
            Customer customer = customers[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      customer.nama_customer,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Text('${customer.alamat}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () => {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _deleteDialog(customer);
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
                                return _dialogForm(true, customer);
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
    final List<Customer> _customer = await service.getCustomers();
    _customerList = _customer;
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(milliseconds: 100));
    final List<Customer> _customer = await service.getCustomers();
    setState(() {
      _customerList = _customer;
    });
  }

  @override
  void initState() {
    super.initState();
    futureCustomer = _initData();
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
                  'Customer',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            FutureBuilder(
              future: futureCustomer,
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
                      return _buildListView(_customerList);
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
  CustomerService service = new CustomerService();
  List<Customer> customerList = <Customer>[];
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
    customerList = await service.getCustomers();
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
    List<Customer> matchQuery = [];
    if (query.length < 2) return Container();

    initData();
    for (var data in customerList) {
      if (data.nama_customer.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(data);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.nama_customer),
        );
      },
    );
  }
}
