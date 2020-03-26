import 'dart:convert';
import 'dart:io';
import 'package:oautter/src/models/token_response.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils.dart';
import 'base/auth_client.dart';
import 'package:http/http.dart' as http;

class TokenClient extends AuthClient {
  final String authority;

  TokenClient(this.authority) : super(authority);

  Future<TokenResponse> requestPasswordToken(
      String clientId, String clientSecret, String userName, String password,
      [String scope]) async {
    var url = '$authority/connect/token';

    var body = {
      'grant_type': 'password',
      'client_id': clientId,
      'client_secret': clientSecret,
      'username': userName,
      'password': password
    };

    if (scope != null) {
      body['scope'] = scope;
    }
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    var response = await http.post(url, body: body, headers: headers);

    var responseBody = response.body;
    var jsonResponse = jsonDecode(responseBody) as Map;

    return TokenResponse.fromJson(jsonResponse);
  }

  /// Authorize and Exachange code
  Future<TokenResponse> requestAuthorizationCodeToken(
      String code, String redirectUri,
      [String codeVerifie, Map<String, String> parameters]) async {
    var codeVerifier = Utils.createCryptoRandomString();
    var codeChallenge = Utils.convertTosha256(codeVerifier);
    var clientId = 'mda_mobile_native';
    var responseType = 'code';
    var state = '5ca75bd30';
    var redirectUrl = 'http://localhost:5003/callback.html';
    var scope = 'web_api';

    var authCodeWithPkce =
        '$authority/connect/authorize?client_id=$clientId&response_type=$responseType&state=$state&redirect_uri=$redirectUrl&scope=$scope&code_challenge_method=S256&code_challenge=$codeChallenge&acr_values=idp:Facebook';

    _launchURL(authCodeWithPkce);

    return null;
  }

  Future<TokenResponse> requestFacebookAuthorizationCodeToken() async {
    return requestAuthorizationCodeToken('', '');
  }

  Future<TokenResponse>
      requestFacebookAuthorizationCodeTokenUsingFacebookSDK() async {
    return null;
  }

  Future<bool> requestPhoneVerificationCode({String phoneNumber}) async {
    var url = '$authority/api/verify_phone_number';

    Map jsonMap = {'phoneNumber': phoneNumber};

    HttpClientRequest req = await client.postUrl(Uri.parse(url));
    req.headers.set('content-type', 'application/json');
    req.add(utf8.encode(json.encode(jsonMap)));
    var response = await req.close();

    if (response.statusCode == HttpStatus.accepted ||
        response.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }

  Future<TokenResponse> requestPhoneVerificationToken(
      {String clientId,
      String clientSecret,
      String scope,
      String verificationToken,
      String phoneNumber}) async {
    var url = '$authority/connect/token';

    var body = {
      'grant_type': 'phone_number_token',
      'client_id': clientId,
      'client_secret': clientSecret,
      'verification_token': verificationToken,
      'phone_number': phoneNumber
    };

    if (scope != null) {
      body['scope'] = scope;
    }
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    var response = await http.post(url, body: body, headers: headers);

    var responseBody = response.body;
    var jsonResponse = jsonDecode(responseBody) as Map;

    return TokenResponse.fromJson(jsonResponse);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}