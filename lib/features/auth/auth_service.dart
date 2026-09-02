import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/models/user_role.dart';

class AppProfile {
  final String id;
  final String fullName;
  final UserRole role;
  final String? company;

  AppProfile({required this.id, required this.fullName, required this.role, this.company});

  factory AppProfile.fromRow(Map<String, dynamic> row) => AppProfile(
        id: row['id'] as String,
        fullName: row['full_name'] as String? ?? '',
        role: UserRoleX.fromString(row['role'] as String?),
        company: row['company'] as String?,
      );
}

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;
  
  // تخزين جلسة المدير العام
  static AppProfile? _masterAdminSession;

  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;

  User? get currentUser => _client.auth.currentUser;
  bool get isSignedIn => _masterAdminSession != null || currentUser != null;

  Future<void> signInWithEmail({required String email, required String password}) async {
    final cleanUid = email.trim();

    // التحقق من بيانات المدير العام بصلاحيات كاملة
    if (cleanUid == 'Admin' && password == 'secret8089') {
      _masterAdminSession = AppProfile.fromRow({
        'id': 'Admin',
        'full_name': 'HSE Engineer: Yagoub Mohamed (Super Admin)',
        'role': 'admin',
        'company': 'Safety Core AI System Owner',
      });
      return;
    }

    // تسجيل الدخول العادي عبر Supabase
    await _client.auth.signInWithPassword(email: cleanUid, password: password);
  }

  Future<void> signOut() async {
    _masterAdminSession = null;
    if (_client.auth.currentUser != null) {
      await _client.auth.signOut();
    }
  }

  Future<AppProfile> fetchCurrentProfile() async {
    // إرجاع ملف المدير العام مباشرة في حال تسجيل دخوله
    if (_masterAdminSession != null) {
      return _masterAdminSession!;
    }

    final uid = currentUser?.id;
    if (uid == null) {
      throw StateError('AuthService.fetchCurrentProfile called with no signed-in user.');
    }
    final row = await _client.from('profiles').select().eq('id', uid).single();
    return AppProfile.fromRow(row);
  }
}
