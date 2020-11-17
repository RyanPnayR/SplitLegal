import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:splitlegal/models/app_state.dart';

class DocusignService {
  String _integrationKey = "3458ade7-2045-4e73-a95e-cf9d5c28ef14";
  String _authUrl = "https://account-d.docusign.com/oauth/auth";

  // Obtain access token for captive user
  Future<String> getUserInfoUri(auth.User user, Activity activity) async {
    Dio dio = new Dio();
    try {
      Response response = await dio.post(
          'https://us-central1-splitlegal.cloudfunctions.net/createDocusignRecipientViewUrl',
          data: {
            "roleName": "Signer1",
            "email": user.email,
            "name": user.displayName,
            "clientUserId": user.uid,
            "templateId": activity.templateId
          });
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
