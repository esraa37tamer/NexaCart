import 'package:realm/realm.dart';
import '../../../../core/storage/realm_models.dart';
import '../../domain/entities/app_user.dart';

class SessionLocalDataSource {
  SessionLocalDataSource(this.realm);
  final Realm realm;
  static const _sessionId = 'current';

  AppUser? read() {
    final record = realm.find<SessionRecord>(_sessionId);
    if (record == null) return null;
    return AppUser(id: record.userId, email: record.email, fullName: record.fullName);
  }

  void save(AppUser user) {
    realm.write(() {
      realm.add(SessionRecord(_sessionId, user.id, user.email, user.fullName), update: true);
    });
  }

  void clear() {
    final record = realm.find<SessionRecord>(_sessionId);
    if (record != null) realm.write(() => realm.delete(record));
  }
}
