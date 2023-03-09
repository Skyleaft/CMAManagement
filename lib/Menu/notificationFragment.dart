import 'package:cma_management/Menu/component/modalForm.dart';
import 'package:flutter/material.dart';

class NotificationFragment extends StatefulWidget {
  const NotificationFragment({Key? key}) : super(key: key);

  @override
  _NotificationFragmentState createState() => _NotificationFragmentState();
}

class _NotificationFragmentState extends State<NotificationFragment> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () => {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const FormDialog();
                },
              )
            },
            child: Text('test'),
          ),
        ),
      ],
    );
  }
}
