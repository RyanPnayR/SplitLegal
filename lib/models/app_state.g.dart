// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MilestoneTransition _$MilestoneTransitionFromJson(Map<String, dynamic> json) {
  return MilestoneTransition(
    fromMilestone: json['fromMilestone'] as String,
    toMilestone: json['toMilestone'] as String,
  );
}

Map<String, dynamic> _$MilestoneTransitionToJson(
        MilestoneTransition instance) =>
    <String, dynamic>{
      'fromMilestone': instance.fromMilestone,
      'toMilestone': instance.toMilestone,
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
  );
}

Map<String, dynamic> _$UserFilingRequestToJson(UserFilingRequest instance) =>
    <String, dynamic>{
      'location': instance.location,
      'requestType': instance.requestType,
      'comments': instance.comments,
      'userId': instance.userId,
      'milestones': instance.milestones,
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
  );
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'phoneNumber': instance.phoneNumber,
      'requests': instance.requests,
    };
