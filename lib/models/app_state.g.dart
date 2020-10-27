// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
    json['first_name'] as String,
    json['last_name'] as String,
    json['phoneNumber'] as String,
  );
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'phoneNumber': instance.phoneNumber,
    };
