import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:json_annotation/json_annotation.dart';
part 'app_state.g.dart';

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
  factory UserForm.fromMap(String id, Map<dynamic, dynamic> json) {
    return UserForm(
        json['form_id'],
        json['name'],
        json['status'],
        id,
        new DateTime.fromMicrosecondsSinceEpoch(
            json['created_at'].microsecondsSinceEpoch),
        new DateTime.fromMicrosecondsSinceEpoch(
            json['updated_at'].microsecondsSinceEpoch));
  }
}

class Activity {
  String name;
  String category;
  String status;
  String title;
  String type;
  String skippable;
  String rejectionReason;
  String activtyDataId;
  MilestoneTransition milestone;
  bool deleted;
  String deletedReason;
  DateTime deletedAt;

  Activity({
    this.name,
    this.category,
    this.status,
    this.title,
    this.type,
    this.skippable,
    this.rejectionReason,
    this.activtyDataId,
    this.milestone,
    this.deleted,
    this.deletedReason,
    this.deletedAt,
  });
}

class MilestoneTransition {
  String fromMilestone;
  String toMilestone;
  String requestId;

  MilestoneTransition({
    this.fromMilestone,
    this.toMilestone,
    this.requestId,
  });
}

class UserFilingRequest {
  String location;
  String requestType;
  String comments;
  List<MilestoneTransition> milestones;

  UserFilingRequest({
    this.location,
    this.requestType,
    this.comments,
    this.milestones,
  });
}

class SplitLegalTeamMember {
  String firstName;
  String lastName;
  String email;

  SplitLegalTeamMember({
    this.firstName,
    this.lastName,
    this.email,
  });
}

@JsonSerializable()
class UserData {
  String first_name;
  String last_name;
  String phoneNumber;
  // List<SplitLegalTeamMember> team;
  // List<Request> requests;

  UserData(
    this.first_name,
    this.last_name,
    this.phoneNumber,
    // this.team,
    // this.requests,
  );
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

class AppState {
  // Your app will use this to know when to display loading spinners.
  bool isLoading;
  auth.User user;
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
