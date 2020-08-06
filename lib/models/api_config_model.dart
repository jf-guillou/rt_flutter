import 'dart:convert';

class APIConfig {
  String host;
  String path = '';
  String _authBasic;
  String _authToken;

  APIConfig();

  bool isUsable() {
    return host != null && canAuth();
  }

  bool canAuth() {
    return _authBasic != null || _authToken != null;
  }

  void setUrl(String url) {
    if (url.startsWith("http://")) {
      throw "Non-https urls are unsupported";
    }

    // Cleanup https://
    if (url.startsWith("https://")) {
      url = url.replaceFirst("https://", "");
    }

    if (url.contains("/")) {
      var parts = url.split("/");
      host = parts.removeAt(0);
      // Remove trailing "/"
      parts.remove("");
      path = parts.join("/");
    } else {
      host = url;
    }
  }

  void setCredentials(String username, String password) {
    _authBasic = base64.encode(utf8.encode("$username:$password"));
    _authToken = null;
  }

  void setAuthToken(String token) {
    _authToken = token;
    _authBasic = null;
  }

  String authorizationHeader() {
    if (!canAuth()) {
      throw "APIConfig is missing either username & password or auth token";
    }

    return _authToken != null ? "token $_authToken" : "basic $_authBasic";
  }
}
