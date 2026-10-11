// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'realm_models.dart';
// ignore_for_file: type=lint

class SessionRecord extends _SessionRecord with RealmEntity, RealmObjectBase, RealmObject {
  SessionRecord(String id, String userId, String email, String fullName) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'fullName', fullName);
  }
  SessionRecord._();
  @override String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override set id(String value) => RealmObjectBase.set(this, 'id', value);
  @override String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override set userId(String value) => RealmObjectBase.set(this, 'userId', value);
  @override String get email => RealmObjectBase.get<String>(this, 'email') as String;
  @override set email(String value) => RealmObjectBase.set(this, 'email', value);
  @override String get fullName => RealmObjectBase.get<String>(this, 'fullName') as String;
  @override set fullName(String value) => RealmObjectBase.set(this, 'fullName', value);
  @override Stream<RealmObjectChanges<SessionRecord>> get changes => RealmObjectBase.getChanges<SessionRecord>(this);
  @override Stream<RealmObjectChanges<SessionRecord>> changesFor([List<String>? keyPaths]) => RealmObjectBase.getChangesFor<SessionRecord>(this, keyPaths);
  @override SessionRecord freeze() => RealmObjectBase.freezeObject<SessionRecord>(this);
  EJsonValue toEJson() => <String, dynamic>{'id': id.toEJson(), 'userId': userId.toEJson(), 'email': email.toEJson(), 'fullName': fullName.toEJson()};
  static EJsonValue _toEJson(SessionRecord value) => value.toEJson();
  static SessionRecord _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id, 'userId': EJsonValue userId, 'email': EJsonValue email, 'fullName': EJsonValue fullName} => SessionRecord(fromEJson(id), fromEJson(userId), fromEJson(email), fromEJson(fullName)),
      _ => raiseInvalidEJson(ejson),
    };
  }
  static final schema = () {
    RealmObjectBase.registerFactory(SessionRecord._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, SessionRecord, 'SessionRecord', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('email', RealmPropertyType.string),
      SchemaProperty('fullName', RealmPropertyType.string),
    ]);
  }();
  @override SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class CartItemRecord extends _CartItemRecord with RealmEntity, RealmObjectBase, RealmObject {
  CartItemRecord(int productId, String title, String thumbnail, double price, int quantity) {
    RealmObjectBase.set(this, 'productId', productId);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'thumbnail', thumbnail);
    RealmObjectBase.set(this, 'price', price);
    RealmObjectBase.set(this, 'quantity', quantity);
  }
  CartItemRecord._();
  @override int get productId => RealmObjectBase.get<int>(this, 'productId') as int;
  @override set productId(int value) => RealmObjectBase.set(this, 'productId', value);
  @override String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override set title(String value) => RealmObjectBase.set(this, 'title', value);
  @override String get thumbnail => RealmObjectBase.get<String>(this, 'thumbnail') as String;
  @override set thumbnail(String value) => RealmObjectBase.set(this, 'thumbnail', value);
  @override double get price => RealmObjectBase.get<double>(this, 'price') as double;
  @override set price(double value) => RealmObjectBase.set(this, 'price', value);
  @override int get quantity => RealmObjectBase.get<int>(this, 'quantity') as int;
  @override set quantity(int value) => RealmObjectBase.set(this, 'quantity', value);
  @override Stream<RealmObjectChanges<CartItemRecord>> get changes => RealmObjectBase.getChanges<CartItemRecord>(this);
  @override Stream<RealmObjectChanges<CartItemRecord>> changesFor([List<String>? keyPaths]) => RealmObjectBase.getChangesFor<CartItemRecord>(this, keyPaths);
  @override CartItemRecord freeze() => RealmObjectBase.freezeObject<CartItemRecord>(this);
  EJsonValue toEJson() => <String, dynamic>{'productId': productId.toEJson(), 'title': title.toEJson(), 'thumbnail': thumbnail.toEJson(), 'price': price.toEJson(), 'quantity': quantity.toEJson()};
  static EJsonValue _toEJson(CartItemRecord value) => value.toEJson();
  static CartItemRecord _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'productId': EJsonValue productId, 'title': EJsonValue title, 'thumbnail': EJsonValue thumbnail, 'price': EJsonValue price, 'quantity': EJsonValue quantity} => CartItemRecord(fromEJson(productId), fromEJson(title), fromEJson(thumbnail), fromEJson(price), fromEJson(quantity)),
      _ => raiseInvalidEJson(ejson),
    };
  }
  static final schema = () {
    RealmObjectBase.registerFactory(CartItemRecord._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, CartItemRecord, 'CartItemRecord', [
      SchemaProperty('productId', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('thumbnail', RealmPropertyType.string),
      SchemaProperty('price', RealmPropertyType.double),
      SchemaProperty('quantity', RealmPropertyType.int),
    ]);
  }();
  @override SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class OrderRecord extends _OrderRecord with RealmEntity, RealmObjectBase, RealmObject {
  OrderRecord(String id, int createdAt, double total, String itemsJson, String status) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'total', total);
    RealmObjectBase.set(this, 'itemsJson', itemsJson);
    RealmObjectBase.set(this, 'status', status);
  }
  OrderRecord._();
  @override String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override set id(String value) => RealmObjectBase.set(this, 'id', value);
  @override int get createdAt => RealmObjectBase.get<int>(this, 'createdAt') as int;
  @override set createdAt(int value) => RealmObjectBase.set(this, 'createdAt', value);
  @override double get total => RealmObjectBase.get<double>(this, 'total') as double;
  @override set total(double value) => RealmObjectBase.set(this, 'total', value);
  @override String get itemsJson => RealmObjectBase.get<String>(this, 'itemsJson') as String;
  @override set itemsJson(String value) => RealmObjectBase.set(this, 'itemsJson', value);
  @override String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override set status(String value) => RealmObjectBase.set(this, 'status', value);
  @override Stream<RealmObjectChanges<OrderRecord>> get changes => RealmObjectBase.getChanges<OrderRecord>(this);
  @override Stream<RealmObjectChanges<OrderRecord>> changesFor([List<String>? keyPaths]) => RealmObjectBase.getChangesFor<OrderRecord>(this, keyPaths);
  @override OrderRecord freeze() => RealmObjectBase.freezeObject<OrderRecord>(this);
  EJsonValue toEJson() => <String, dynamic>{'id': id.toEJson(), 'createdAt': createdAt.toEJson(), 'total': total.toEJson(), 'itemsJson': itemsJson.toEJson(), 'status': status.toEJson()};
  static EJsonValue _toEJson(OrderRecord value) => value.toEJson();
  static OrderRecord _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id, 'createdAt': EJsonValue createdAt, 'total': EJsonValue total, 'itemsJson': EJsonValue itemsJson, 'status': EJsonValue status} => OrderRecord(fromEJson(id), fromEJson(createdAt), fromEJson(total), fromEJson(itemsJson), fromEJson(status)),
      _ => raiseInvalidEJson(ejson),
    };
  }
  static final schema = () {
    RealmObjectBase.registerFactory(OrderRecord._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, OrderRecord, 'OrderRecord', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('createdAt', RealmPropertyType.int),
      SchemaProperty('total', RealmPropertyType.double),
      SchemaProperty('itemsJson', RealmPropertyType.string),
      SchemaProperty('status', RealmPropertyType.string),
    ]);
  }();
  @override SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
