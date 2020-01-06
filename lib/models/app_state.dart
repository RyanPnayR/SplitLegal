import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SplitLegalForm {
  String id;
  String displayName;
  bool enabled;
  String formUrl;
  String formstackId;
  int order;
  String form_info;
  SplitLegalForm(this.id, this.displayName, this.enabled, this.formUrl,
      this.formstackId, this.order, this.form_info);

  factory SplitLegalForm.fromMap(id, Map<String, dynamic> json) {
    return SplitLegalForm(
        id,
        json['display_name'],
        json['enabled'],
        json['form_url'],
        json['formstack_id'],
        json['order'],
        json['form_info']);
  }
}

class UserForm {
  String formId;
  String name;
  String status;
  String id;
  DateTime createdAt;
  DateTime updatedAt;

  UserForm(this.formId, this.name, this.status, this.id, this.createdAt,
      this.updatedAt);
  factory UserForm.fromMap(Map<dynamic, dynamic> json) {
    return UserForm(
        json['form_id'],
        json['name'],
        json['status'],
        json['id'],
        new DateTime.fromMicrosecondsSinceEpoch(
            json['created_at'].microsecondsSinceEpoch),
        new DateTime.fromMicrosecondsSinceEpoch(
            json['updated_at'].microsecondsSinceEpoch));
  }
}

class UserData {
  String firstName;
  String lastName;
  List<UserForm> forms;

  UserData(this.firstName, this.lastName, this.forms);
  factory UserData.fromMap(Map<String, dynamic> json, QuerySnapshot formData) {
    List<UserForm> forms = formData.documents.map((form) {
      return UserForm.fromMap(form.data);
    }).toList();
    return UserData(json['first_name'], json['last_name'], forms);
  }
}

class AppState {
  // Your app will use this to know when to display loading spinners.
  bool isLoading;
  FirebaseUser user;
  UserData userData;

  // Constructor
  AppState({
    this.isLoading = false,
    this.user,
    this.userData,
  });

  // A constructor for when the app is loading.
  factory AppState.loading() => new AppState(isLoading: true);

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, user: ${user?.displayName ?? 'null'}}';
  }
}
