// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) {
  return Activity(
    name: json['name'] as String,
    category: json['category'] as String,
    status: json['status'] as String,
    title: json['title'] as String,
    type: json['type'] as String,
    skippable: json['skippable'] as bool,
    rejectionReason: json['rejectionReason'] as String,
    id: json['id'] as String,
    milestone: json['milestone'] == null
        ? null
        : MilestoneTransition.fromJson(
            json['milestone'] as Map<String, dynamic>),
    deleted: json['deleted'] as bool,
    deletedReason: json['deletedReason'] as String,
    deletedAt: json['deletedAt'] == null
        ? null
        : DateTime.parse(json['deletedAt'] as String),
    templateId: json['templateId'] as String,
  );
}

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'name': instance.name,
      'category': instance.category,
      'status': instance.status,
      'title': instance.title,
      'type': instance.type,
      'skippable': instance.skippable,
      'rejectionReason': instance.rejectionReason,
      'id': instance.id,
      'milestone': instance.milestone,
      'deleted': instance.deleted,
      'deletedReason': instance.deletedReason,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'templateId': instance.templateId,
    };

MilestoneTransition _$MilestoneTransitionFromJson(Map<String, dynamic> json) {
  return MilestoneTransition(
    fromMilestoneId: json['fromMilestoneId'] as String,
    fromMilestone: json['fromMilestone'] as String,
    toMilestoneId: json['toMilestoneId'] as String,
    toMilestone: json['toMilestone'] as String,
    completed: json['completed'] as bool,
  );
}

Map<String, dynamic> _$MilestoneTransitionToJson(
        MilestoneTransition instance) =>
    <String, dynamic>{
      'fromMilestoneId': instance.fromMilestoneId,
      'fromMilestone': instance.fromMilestone,
      'toMilestoneId': instance.toMilestoneId,
      'toMilestone': instance.toMilestone,
      'completed': instance.completed,
    };

UserFilingRequest _$UserFilingRequestFromJson(Map<String, dynamic> json) {
  return UserFilingRequest(
    location: json['location'] as String,
    requestType: json['requestType'] as String,
    comments: json['comments'] as String,
    milestones: (json['milestones'] as List)
        ?.map((e) => e == null
            ? null
            : MilestoneTransition.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    userId: json['userId'] as String,
    tasks: (json['tasks'] as List)
        ?.map((e) =>
            e == null ? null : Activity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserFilingRequestToJson(UserFilingRequest instance) =>
    <String, dynamic>{
      'location': instance.location,
      'requestType': instance.requestType,
      'comments': instance.comments,
      'userId': instance.userId,
      'milestones': instance.milestones,
      'tasks': instance.tasks,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
    json['id'] as String,
    json['first_name'] as String,
    json['last_name'] as String,
    json['phoneNumber'] as String,
    (json['requests'] as List)
        ?.map((e) => e == null
            ? null
            : UserFilingRequest.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['email'] as String,
  );
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'requests': instance.requests,
    };
