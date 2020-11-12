import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:splitlegal/models/docusign.dart';

class DocusignService {
  String _integrationKey = "3458ade7-2045-4e73-a95e-cf9d5c28ef14";
  String _authUrl = "https://account-d.docusign.com/oauth/auth";

  // Obtain access token for captive user
  Future<String> getUserInfoUri() async {
    Dio dio = new Dio();
    try {
      Response response = await dio.get(
          'https://us-central1-splitlegal.cloudfunctions.net/createDocusignRecipientViewUrl');
      print(response);
      return response.data["url"];
    } catch (e) {
      print(e);
    }
  }

// Create envelope with captive recipient
// Generate recipient view url
// Handle post signing events with return url and http request params
}
