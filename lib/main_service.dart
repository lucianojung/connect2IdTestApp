class MainService {

  static final MainService _instance = MainService._internal();

  factory MainService() => _instance;

  String _bearerToken = 'ztucZS1ZyFKgh0tUEruUtiSTXhnexmd6';
  String _mainUrl = 'https://demo.c2id.com';

  MainService._internal() { }

  String get token => _bearerToken;
  String get url => _mainUrl;
}