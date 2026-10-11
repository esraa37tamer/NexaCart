import 'package:realm/realm.dart';
part 'realm_models.realm.dart';

@RealmModel()
class _SessionRecord {
  @PrimaryKey()
  late String id;
  late String userId;
  late String email;
  late String fullName;
}

@RealmModel()
class _CartItemRecord {
  @PrimaryKey()
  late int productId;
  late String title;
  late String thumbnail;
  late double price;
  late int quantity;
}

@RealmModel()
class _OrderRecord {
  @PrimaryKey()
  late String id;
  late int createdAt;
  late double total;
  late String itemsJson;
  late String status;
}
