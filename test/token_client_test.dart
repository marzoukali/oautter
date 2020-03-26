import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:oautter/src/clients/token_client.dart';

void main() {

  test("Get password token", () async{
  //setup the test
  var authorityUrl = '';
  final tokenClient = TokenClient(authorityUrl);
  tokenClient.client = MockClient((request) async {
    final mapJson = {'access_token':'testtoken'};
    return Response(json.encode(mapJson),200);
  });
  
  final tokenResponse = await tokenClient.requestPasswordToken('','','','');
  expect(tokenResponse.accessToken, 'testtoken');
});

}