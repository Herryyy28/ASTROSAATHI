import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? token;
  final bool isAnonymous;
  final DateTime? createdAt;

  const AuthUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.token,
    this.isAnonymous = false,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'token': token,
        'isAnonymous': isAnonymous,
        'createdAt': createdAt?.toIso8601String(),
      };

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      token: json['token'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  AuthUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? token,
    bool? isAnonymous,
    DateTime? createdAt,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      token: token ?? this.token,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@immutable
class AuthResult {
  final bool success;
  final AuthUser? user;
  final String? token;
  final String? message;
  final String? errorCode;

  const AuthResult({
    required this.success,
    this.user,
    this.token,
    this.message,
    this.errorCode,
  });

  factory AuthResult.success(AuthUser user, {String? token, String? message}) {
    return AuthResult(
      success: true,
      user: user,
      token: token ?? user.token,
      message: message ?? 'Authentication successful',
    );
  }

  factory AuthResult.failure(String message, {String? errorCode}) {
    return AuthResult(
      success: false,
      message: message,
      errorCode: errorCode,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'user': user?.toJson(),
        'token': token,
        'message': message,
        'errorCode': errorCode,
      };

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      success: json['success'] as bool? ?? false,
      user: json['user'] != null
          ? AuthUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      token: json['token'] as String?,
      message: json['message'] as String?,
      errorCode: json['errorCode'] as String?,
    );
  }
}
