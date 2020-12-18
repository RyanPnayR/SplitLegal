import 'dart:collection';

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

@JsonSerializable()
class Activity {
  String description;
  String category;
  String status;
  String title;
  String type;
  bool skippable;
  String rejectionReason;
  String id;
  MilestoneTransition milestone;
  String deleted;
  String deletedReason;
  DateTime deletedAt;
  String templateId;
  Map<String, dynamic> activityData;

  Activity({
    this.description,
    this.category,
    this.status,
    this.title,
    this.type,
    this.skippable,
    this.rejectionReason,
    this.id,
    this.milestone,
    this.deleted,
    this.deletedReason,
    this.deletedAt,
    this.templateId,
    this.activityData,
  }) {
    if (this.activityData == null) {
      this.activityData = new Map<String, dynamic>();
    }
  }
  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}

@JsonSerializable()
class MilestoneTransition {
  String fromMilestoneId;
  String fromMilestone;
  String toMilestoneId;
  String toMilestone;
  bool completed;

  MilestoneTransition({
    this.fromMilestoneId,
    this.fromMilestone,
    this.toMilestoneId,
    this.toMilestone,
    this.completed = false,
  });

  factory MilestoneTransition.fromJson(Map<String, dynamic> json) =>
      _$MilestoneTransitionFromJson(json);

  Map<String, dynamic> toJson() => _$MilestoneTransitionToJson(this);
}

@JsonSerializable()
class UserFilingRequest {
  String documentID;
  String location;
  String requestType;
  String comments;
  String userId;
  List<MilestoneTransition> milestones;
  List<Activity> tasks;
  UserFilingRequest(
      {this.documentID,
      this.location,
      this.requestType,
      this.comments,
      this.milestones,
      this.userId,
      this.tasks});

  factory UserFilingRequest.fromJson(Map<String, dynamic> json) =>
      _$UserFilingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserFilingRequestToJson(this);
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
  String id;
  String first_name;
  String last_name;
  String phoneNumber;
  String email;
  List<UserFilingRequest> requests;
  // List<SplitLegalTeamMember> team;

  UserData(
    this.id,
    this.first_name,
    this.last_name,
    this.phoneNumber,
    this.requests,
    this.email,
    // this.team,
  );

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

enum homeScreenPages { documents, settings, overview, tasks, team, docusign }

class AppState {
  // Your app will use this to know when to display loading spinners.
  bool isLoading;
  auth.User user;
  UserData userData;
  homeScreenPages currentPage;
  UserFilingRequest currentRequest;
  String docusignUrl = "";
  Activity selectedTask;

  // Constructor
  AppState(
      {this.isLoading = false,
      this.user,
      this.userData,
      this.currentPage = homeScreenPages.overview,
      this.currentRequest,
      this.selectedTask});

  // A constructor for when the app is loading.
  factory AppState.loading() => new AppState(isLoading: true);

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, user: ${user?.displayName ?? 'null'}}';
  }
}
