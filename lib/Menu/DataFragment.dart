import 'package:flutter/material.dart';

class DataFragment extends StatefulWidget {
  const DataFragment({Key? key}) : super(key: key);

  @override
  _DataFragmentState createState() => _DataFragmentState();
}

class _DataFragmentState extends State<DataFragment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "This is Data Screen",
            style: TextStyle(fontSize: 24),
          ),
        )
      ],
    );
  }
}
