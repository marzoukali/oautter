import 'dart:io';

abstract class AuthClient {

  final String authority;
  final HttpClient client = HttpClient();

  AuthClient(this.authority);

  void dispose() {
    client.close();
  }
}