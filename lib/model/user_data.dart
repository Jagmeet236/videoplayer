import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  final String uid;
  final String username;
  final String email;
  final List<String> videoUrls;
  const UserData({
    required this.uid,
    required this.username,
    required this.email,
    required this.videoUrls,
  });

  factory UserData.fromDoc(DocumentSnapshot userDoc) {
    final userData = userDoc.data() as Map<String, dynamic>?;

    return UserData(
      uid: userDoc.id,
      username: userData!['name'],
      email: userData['email'],
      videoUrls: userData['videoUrls'] != null
          ? List<String>.from(userData['videoUrls'])
          : [],
    );
  }

  factory UserData.initialUser() {
    return const UserData(
      uid: '',
      username: '',
      email: '',
      videoUrls: [''],
    );
  }

  @override
  List<Object> get props => [uid, username, email, videoUrls];

  @override
  String toString() {
    return 'UserData(uid: $uid, username: $username, email: $email, videoUrls: $videoUrls)';
  }

  UserData copyWith({
    String? uid,
    String? username,
    String? email,
    List<String>? videoUrls,
  }) {
    return UserData(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      videoUrls: videoUrls ?? this.videoUrls,
    );
  }
}
