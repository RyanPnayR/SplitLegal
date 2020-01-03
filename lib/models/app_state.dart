import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Form {
  String displayName;
  bool enabled;
  String formUrl;
  String formstackId;
  Form(this.displayName, this.enabled, this.formUrl, this.formstackId);

  factory Form.fromMap(Map<String, dynamic> json) {
    return Form(json['display_name'], json['enabled'], json['form_url'],
        json['formstack_id']);
  }
}

class UserForm {
  String formId;
  String name;
  String status;

  UserForm(this.formId, this.name, this.status);
  factory UserForm.fromMap(Map<String, dynamic> json) {
    return UserForm(json['name'], json['status'], json['form_id']);
  }
}

class UserData {
  String firstName;
  String lastName;
  List<UserForm> forms;

  UserData(this.firstName, this.lastName, this.forms);
  factory UserData.fromMap(Map<String, dynamic> json) {
    List<dynamic> formData = json['forms'];
    List<UserForm> forms = formData.map((form) {
      return UserForm.fromMap(form);
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
