import 'dart:convert';

import 'package:connect2id_test/main_service.dart';
import 'package:connect2id_test/token_generation_page.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class AuthenticationPage extends StatefulWidget {
  AuthenticationPage({Key? key, required this.sid}) : super(key: key);

  final String sid;

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  MainService _mainService = MainService();
  String _subUrl = '';
  String _sid = '';

  String _result = '';

  @override
  void initState() {
    _sid = widget.sid;
    _subUrl = _subUrl = '/authz-sessions/rest/v3/$_sid?type=response';
    super.initState();
  }

  void _createRequest() async {
    var url = Uri.parse(_mainService.url + _subUrl);
    var token = _mainService.token;
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('PUT', url);
    request.body = json.encode({
      "sub": "alice123"
    });
    request.headers.addAll(headers);

    request.send().then((result) async {

    http.Response.fromStream(result).then((response) {
      if (response.statusCode == 200) {
        print('response.body ' + response.body);

        Map<String, dynamic> jsonBody = jsonDecode(response.body);
        setState(() {
          _result = response.body;
        });

      }
      return response.body;
    });
    }).catchError((err) => print('error : '+err.toString()))
        .whenComplete(()
    {});

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
              TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.amberAccent)),
                  onPressed: _createRequest, child: Text('Authorisierung')),
              SizedBox(height: 32,),
              Text(
                _result,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: (_result != ''),
        child: FloatingActionButton(
          onPressed: _nextPage,
          tooltip: 'NextPage',
          child: Icon(Icons.arrow_forward),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _nextPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => TokenGenerationPage(sid: _sid)));
  }
}
