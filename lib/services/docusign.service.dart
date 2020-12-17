import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:splitlegal/models/app_state.dart';

class DocusignService {
  String _integrationKey = "3458ade7-2045-4e73-a95e-cf9d5c28ef14";
  String _authUrl = "https://account-d.docusign.com/oauth/auth";

  // Obtain access token for captive user
  Future<dynamic> getUserInfoUri(
      auth.User user, Activity task, UserData userData) async {
    Dio dio = new Dio();
    try {
      Response response = await dio.post(
          'https://us-central1-splitlegal.cloudfunctions.net/createDocusignRecipientViewUrl',
          data: {
            "roleName": "Signer1",
            "email": user.email,
            "name": user.displayName != null
                ? user.displayName
                : userData.first_name + userData.last_name,
            "clientUserId": user.uid,
            "templateId": task.templateId,
            "envelopeId": task.activityData['envelopeId']
          });
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
