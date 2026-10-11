import 'package:realm/realm.dart';
import 'realm_models.dart';

class RealmDatabase {
  RealmDatabase()
      : sessionRealm = Realm(
          Configuration.local(
            [SessionRecord.schema],
            schemaVersion: 1,
            path: '${Configuration.defaultStoragePath}/nexacart_session.realm',
          ),
        );

  final Realm sessionRealm;
  final Map<String, Realm> _userRealms = {};

  Realm forUser(String userId) {
    final safe = userId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    return _userRealms.putIfAbsent(
      safe,
      () => Realm(
        Configuration.local(
          [CartItemRecord.schema, OrderRecord.schema],
          schemaVersion: 1,
          path: '${Configuration.defaultStoragePath}/nexacart_user_$safe.realm',
        ),
      ),
    );
  }

  void close() {
    sessionRealm.close();
    for (final realm in _userRealms.values) {
      realm.close();
    }
  }
}
