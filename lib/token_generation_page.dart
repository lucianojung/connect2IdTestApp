import 'dart:convert';

import 'package:connect2id_test/main_service.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class TokenGenerationPage extends StatefulWidget {
  TokenGenerationPage({Key? key, required this.sid}) : super(key: key);

  final String sid;

  @override
  _TokenGenerationPageState createState() => _TokenGenerationPageState();
}

class _TokenGenerationPageState extends State<TokenGenerationPage> {
  MainService _mainService = MainService();
  String _subUrl = '';
  String _sid = '';
  String _jwtToken = '';

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
      "scope": [
        "openid",
        "profile",
        "email",
        "app:admin"
      ],
      "claims": [
        "name",
        "email",
        "email_verified"
      ],
      "preset_claims": {
        "id_token": {
          "nickname": "SEIN Teammitglied",
          "adress": {
            "street": "Am Heuhaufen",
            "number": "11",
            "plz": "64293",
            "city": "Darmstadt"
          }
        }
      }
    });
    request.headers.addAll(headers);

    request.send().then((result) async {

    http.Response.fromStream(result).then((response) {
      if (response.statusCode == 200) {
        print('response.body ' + response.body);

        Map<String, dynamic> jsonBody = jsonDecode(response.body);
        setState(() {
          _result = response.body;
          String uri = jsonBody['parameters']['uri'];
          RegExp re = RegExp(r'id_token[^&]*');
          RegExpMatch? match = re.firstMatch(uri.toString());
          _jwtToken = uri.substring(match!.start, match.end);
          print(_jwtToken);
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
              Text(
                _mainService.url + _subUrl,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                'json body: \n' + json.encode({
                  "scope": [
                    "openid",
                    "profile",
                    "email",
                    "app:admin"
                  ],
                  "claims": [
                    "name",
                    "email",
                    "email_verified"
                  ],
                  "preset_claims": {
                    "id_token": {
                      "nickname": "SEIN Teammitglied",
                      "adress": {
                        "street": "Am Heuhaufen",
                        "number": "11",
                        "plz": "64293",
                        "city": "Darmstadt"
                      }
                    }
                  }
                }),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 32,),
              TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.amberAccent)),
                  onPressed: _createRequest, child: Text('Token generieren')),
              SizedBox(height: 32,),
              Text(
                _result,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 32,),
              Text(
                '$_jwtToken',
                style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _nextPage() {}
}
