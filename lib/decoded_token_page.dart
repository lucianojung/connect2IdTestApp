import 'dart:convert';

import 'package:connect2id_test/main_service.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:jwt_decoder/jwt_decoder.dart';

class DecodedTokenPage extends StatefulWidget {
  DecodedTokenPage({Key? key, required this.token}) : super(key: key);

  final String token;

  @override
  _DecodedTokenPageState createState() => _DecodedTokenPageState();
}

class _DecodedTokenPageState extends State<DecodedTokenPage> {
  Map<String, dynamic> _decodedToken = {};

  @override
  void initState() {
    _decodedToken = JwtDecoder.decode(widget.token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect2Id TestApp'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Decoded Token: \n' + _decodedToken.toString(),
                style: Theme.of(context).textTheme.headline6!
                    .copyWith(color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _nextPage() {}
}
