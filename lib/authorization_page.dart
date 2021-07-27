import 'dart:convert';

import 'package:connect2id_test/authentication_page.dart';
import 'package:connect2id_test/main_service.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class AuthorizationPage extends StatefulWidget {
  AuthorizationPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  MainService _mainService = MainService();
  String _subUrl = '/authz-sessions/rest/v3?type=auth';
  String _clientId = 'mxkbew7pavzog';

  String _result = '';
  String _sid = '';

  void _createRequest() async {
    var url = Uri.parse(_mainService.url + _subUrl);
    var token = _mainService.token;
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', url);
    request.body = json.encode({
      "query":
          "response_type=id_token&scope=openid%2020profile&client_id=$_clientId&state=af0ifjsldkj&redirect_uri=https://demo.c2id.com/oidc-client/cb"
    });
    request.headers.addAll(headers);

    request.send().then((result) async {

    http.Response.fromStream(result).then((response) {
      if (response.statusCode == 200) {
        print('response.body ' + response.body);

        Map<String, dynamic> jsonBody = jsonDecode(response.body);
        setState(() {
          _sid = jsonBody['sid'];
          _result = response.body;
        });

      }
      else {
        print(response.reasonPhrase);
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
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _mainService.url + _subUrl,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                'json body: \n' + json.encode({
                  "query":
                  "response_type=id_token&scope=openid%2020profile&client_id=$_clientId&state=af0ifjsldkj&redirect_uri=https://demo.c2id.com/oidc-client/cb"
                }),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 32,),
              TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.amberAccent)),
                  onPressed: _createRequest, child: Text('Authorisation session starten')),
              SizedBox(height: 32,),
              Text(
                _result,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              if(_result != '')
                Text(
                  'Session Id: $_sid',
                  style: Theme.of(context).textTheme.headline6,
                ),
            ],
          ),
        ),
      ),

      floatingActionButton: Visibility(
        visible: (_result != ''),
        child: FloatingActionButton(
          onPressed: _nextPage,
          tooltip: 'Next Step',
          child: Icon(Icons.arrow_forward),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _nextPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AuthenticationPage(sid: _sid)));
  }
}
