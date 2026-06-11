import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class ProfileProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  static const _kKey = 'alu_user';

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kKey);
    if (raw != null) {
      try {
        _user = _fromMap(jsonDecode(raw) as Map<String, dynamic>);
        notifyListeners();
      } catch (_) {}
    }
  }

  Future<void> _save() async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, jsonEncode(_toMap(_user!)));
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true; _error = null; notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    if (email.endsWith('@alustudent.com') || email.endsWith('@alusb.com')) {
      _user = UserModel(
        id: 'u1', fullName: 'Keza Uwase', email: email,
        campus: 'Kigali Campus', role: UserRole.student,
        interests: ['Student Leadership', 'Entrepreneurship'],
        communityIds: ['c1', 'c3', 'c5'],
      );
      await _save(); _isLoading = false; notifyListeners(); return true;
    }
    _error = 'Use your ALU email (@alustudent.com or @alusb.com)';
    _isLoading = false; notifyListeners(); return false;
  }

  Future<bool> register({
    required String fullName, required String email,
    required String password, required UserRole role, required String campus,
  }) async {
    _isLoading = true; _error = null; notifyListeners();
    await Future.delayed(const Duration(milliseconds: 900));
    if (!email.endsWith('@alustudent.com') && !email.endsWith('@alusb.com')) {
      _error = 'Please use your official ALU email address.';
      _isLoading = false; notifyListeners(); return false;
    }
    _user = UserModel(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName, email: email, campus: campus, role: role,
    );
    await _save(); _isLoading = false; notifyListeners(); return true;
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kKey);
    notifyListeners();
  }

  Future<void> toggleInterest(String i) async {
    if (_user == null) return;
    final list = List<String>.from(_user!.interests);
    list.contains(i) ? list.remove(i) : list.add(i);
    _user = _user!.copyWith(interests: list);
    await _save(); notifyListeners();
  }

  Future<void> toggleRsvp(String id) async {
    if (_user == null) return;
    final list = List<String>.from(_user!.rsvpedEventIds);
    list.contains(id) ? list.remove(id) : list.add(id);
    _user = _user!.copyWith(rsvpedEventIds: list);
    await _save(); notifyListeners();
  }

  Future<void> toggleSaved(String id) async {
    if (_user == null) return;
    final list = List<String>.from(_user!.savedEventIds);
    list.contains(id) ? list.remove(id) : list.add(id);
    _user = _user!.copyWith(savedEventIds: list);
    await _save(); notifyListeners();
  }

  Future<void> joinCommunity(String id) async {
    if (_user == null) return;
    final list = List<String>.from(_user!.communityIds);
    list.contains(id) ? list.remove(id) : list.add(id);
    _user = _user!.copyWith(communityIds: list);
    await _save(); notifyListeners();
  }

  void clearError() { _error = null; notifyListeners(); }

  Map<String, dynamic> _toMap(UserModel u) => {
    'id': u.id, 'fullName': u.fullName, 'email': u.email,
    'campus': u.campus, 'role': u.role.index, 'avatarUrl': u.avatarUrl,
    'interests': u.interests, 'rsvpedEventIds': u.rsvpedEventIds,
    'savedEventIds': u.savedEventIds, 'communityIds': u.communityIds,
  };

  UserModel _fromMap(Map<String, dynamic> m) => UserModel(
    id: m['id'], fullName: m['fullName'], email: m['email'],
    campus: m['campus'], role: UserRole.values[m['role']],
    avatarUrl: m['avatarUrl'],
    interests: List<String>.from(m['interests'] ?? []),
    rsvpedEventIds: List<String>.from(m['rsvpedEventIds'] ?? []),
    savedEventIds: List<String>.from(m['savedEventIds'] ?? []),
    communityIds: List<String>.from(m['communityIds'] ?? []),
  );
}
