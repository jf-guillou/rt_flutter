import 'package:test/test.dart';
import 'package:rt_flutter/models/api_config_model.dart';

void main() {
  test('APIConfig should properly base64 encode auth credentials', () {
    const username = "Aladdin";
    const password = "open sesame";
    var c = APIConfig();
    c.setCredentials(username, password);
    expect(
        c.authorizationHeader(), equals("basic QWxhZGRpbjpvcGVuIHNlc2FtZQ=="));
  });

  test('APIConfig should properly store auth token', () {
    const token = "dcd98b7102dd2f0e8b11d0f600bfb0c093";
    var c = APIConfig();
    c.setAuthToken(token);
    expect(c.authorizationHeader(), equals("token $token"));
  });
}
