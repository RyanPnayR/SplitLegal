import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

class DocusignUserInfo {
  String sub;
  String name;
  String given_name;
  String family_name;
  String email;
  DateTime created;
  List<DocusignAccount> accounts;

  DocusignUserInfo({
    this.sub,
    this.name,
    this.given_name,
    this.family_name,
    this.email,
    this.created,
    this.accounts,
  });

  DocusignUserInfo copyWith({
    String sub,
    String name,
    String given_name,
    String family_name,
    String email,
    DateTime created,
    List<DocusignAccount> accounts,
  }) {
    return DocusignUserInfo(
      sub: sub ?? this.sub,
      name: name ?? this.name,
      given_name: given_name ?? this.given_name,
      family_name: family_name ?? this.family_name,
      email: email ?? this.email,
      created: created ?? this.created,
      accounts: accounts ?? this.accounts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sub': sub,
      'name': name,
      'given_name': given_name,
      'family_name': family_name,
      'email': email,
      'created': created?.millisecondsSinceEpoch,
      'accounts': accounts?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory DocusignUserInfo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DocusignUserInfo(
      sub: map['sub'],
      name: map['name'],
      given_name: map['given_name'],
      family_name: map['family_name'],
      email: map['email'],
      created: DateTime.fromMillisecondsSinceEpoch(map['created']),
      accounts: List<DocusignAccount>.from(
          map['accounts']?.map((x) => DocusignAccount.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory DocusignUserInfo.fromJson(String source) =>
      DocusignUserInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DocusignUserInfo(sub: $sub, name: $name, given_name: $given_name, family_name: $family_name, email: $email, created: $created, accounts: $accounts)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is DocusignUserInfo &&
        o.sub == sub &&
        o.name == name &&
        o.given_name == given_name &&
        o.family_name == family_name &&
        o.email == email &&
        o.created == created &&
        listEquals(o.accounts, accounts);
  }

  @override
  int get hashCode {
    return sub.hashCode ^
        name.hashCode ^
        given_name.hashCode ^
        family_name.hashCode ^
        email.hashCode ^
        created.hashCode ^
        accounts.hashCode;
  }
}

class DocusignAccount {
  String account_id;
  String account_name;
  String base_uri;
  bool is_default;

  DocusignAccount({
    this.account_id,
    this.account_name,
    this.base_uri,
    this.is_default,
  });

  DocusignAccount copyWith({
    String account_id,
    String account_name,
    String base_uri,
    bool is_default,
  }) {
    return DocusignAccount(
      account_id: account_id ?? this.account_id,
      account_name: account_name ?? this.account_name,
      base_uri: base_uri ?? this.base_uri,
      is_default: is_default ?? this.is_default,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'account_id': account_id,
      'account_name': account_name,
      'base_uri': base_uri,
      'is_default': is_default,
    };
  }

  factory DocusignAccount.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DocusignAccount(
      account_id: map['account_id'],
      account_name: map['account_name'],
      base_uri: map['base_uri'],
      is_default: map['is_default'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DocusignAccount.fromJson(String source) =>
      DocusignAccount.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DocusignAccount(account_id: $account_id, account_name: $account_name, base_uri: $base_uri, is_default: $is_default)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DocusignAccount &&
        o.account_id == account_id &&
        o.account_name == account_name &&
        o.base_uri == base_uri &&
        o.is_default == is_default;
  }

  @override
  int get hashCode {
    return account_id.hashCode ^
        account_name.hashCode ^
        base_uri.hashCode ^
        is_default.hashCode;
  }
}
