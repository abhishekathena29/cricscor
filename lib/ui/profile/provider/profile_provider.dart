import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserProfile {
  final String id;
  final String email;
  final String username;
  final String userType; // player or scorer
  final String? city;
  final String? role;
  final String? battingStyle;
  final String? bowlingStyle;
  final String? experience;
  final String? bio;
  final bool? availableForHire;

  UserProfile({
    required this.id,
    required this.email,
    required this.username,
    required this.userType,
    this.city,
    this.role,
    this.battingStyle,
    this.bowlingStyle,
    this.experience,
    this.bio,
    this.availableForHire,
  });

  factory UserProfile.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserProfile(
      id: doc.id,
      email: (data['email'] as String?) ?? '',
      username: (data['username'] as String?) ?? '',
      userType: (data['userType'] as String?) ?? 'player',
      city: data['city'] as String?,
      role: data['role'] as String?,
      battingStyle: data['battingStyle'] as String?,
      bowlingStyle: data['bowlingStyle'] as String?,
      experience: data['experience'] as String?,
      bio: data['bio'] as String?,
      availableForHire: data['availableForHire'] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'userType': userType,
      if (city != null) 'city': city,
      if (role != null) 'role': role,
      if (battingStyle != null) 'battingStyle': battingStyle,
      if (bowlingStyle != null) 'bowlingStyle': bowlingStyle,
      if (experience != null) 'experience': experience,
      if (bio != null) 'bio': bio,
      if (availableForHire != null) 'availableForHire': availableForHire,
    };
  }
}

class ProfileProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _saving = false;
  String? _error;

  bool get saving => _saving;
  String? get error => _error;

  Stream<UserProfile?> watchProfile() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(null);
    return _firestore.collection('users').doc(uid).snapshots().map(
          (doc) => doc.exists ? UserProfile.fromDoc(doc) : null,
        );
  }

  Future<UserProfile?> fetchProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    final doc =
        await _firestore.collection('users').doc(uid).get(const GetOptions());
    if (!doc.exists) return null;
    return UserProfile.fromDoc(doc);
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    _saving = true;
    notifyListeners();
    try {
      await _firestore.collection('users').doc(uid).set(
            data,
            SetOptions(merge: true),
          );
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _saving = false;
      notifyListeners();
    }
  }
}
