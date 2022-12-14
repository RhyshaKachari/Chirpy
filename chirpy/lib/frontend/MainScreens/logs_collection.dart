import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:loading_overlay/loading_overlay.dart';

class LogsCollection extends StatefulWidget {
  const LogsCollection({Key? key}) : super(key: key);

  @override
  _LogsCollectionState createState() => _LogsCollectionState();
}

class _LogsCollectionState extends State<LogsCollection> {
  bool _isLoading = false;

  final List<String> _callingConnection = [
    'Rhysha',
    'Yatharth',
    'Rahul',
    'Aryaman',
    'Prateek',
    'Advit'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(239, 46, 38, 78),
        body: LoadingOverlay(
          color: const Color.fromRGBO(0, 0, 0, 0.5),
          progressIndicator: const CircularProgressIndicator(
            backgroundColor: Colors.black87,
          ),
          isLoading: this._isLoading,
          child: Container(
            margin: const EdgeInsets.all(12.0),
            width: double.maxFinite,
            height: double.maxFinite,
            child: ListView.builder(
              itemCount: this._callingConnection.length,
              itemBuilder: (upperContext, index) =>
                  _everyConnectionHistory(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _everyConnectionHistory(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundColor: const Color.fromARGB(239, 46, 38, 78),
            backgroundImage: ExactAssetImage('assets/images/google.png'),
            // getProperImageProviderForConnectionsCollection(
            //    _userName),
          ),
          Text(
            this._callingConnection[index],
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          IconButton(
            icon: Icon(
              Icons.call,
              size: 30.0,
              color: Colors.green,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
