import 'dart:convert';
import 'package:oautter/src/models/token_response.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils.dart';
import 'package:http/http.dart' show Client;

class TokenClient {
  Client client = Client();
  final String authority;

  TokenClient(this.authority);

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
    var response = await client.post(url, body: body, headers: headers);

    var responseBody = response.body;
    var jsonResponse = jsonDecode(responseBody) as Map;

    return TokenResponse.fromJson(jsonResponse);
  }

  /// Authorize and Exachange code
  Future<TokenResponse> requestAuthorizationCodeToken(
      String clientId,
      String responseType,
      String state,
      String redirectUri,
      String scope,
      String acrValues,
      [String codeVerifie,
      Map<String, String> parameters]) async {
    var codeVerifier = Utils.createCryptoRandomString();
    var codeChallenge = Utils.convertTosha256(codeVerifier);

    var authCodeWithPkce =
        '$authority/connect/authorize?client_id=$clientId&response_type=$responseType&state=$state&redirect_uri=$redirectUri&scope=$scope&code_challenge_method=S256&code_challenge=$codeChallenge&acr_values=$acrValues';

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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}
