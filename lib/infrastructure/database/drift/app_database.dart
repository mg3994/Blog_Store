import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class CachedCatalogProducts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get imageUrl => text().nullable()();
  RealColumn get price => real().nullable()();
  TextColumn get currency => text().nullable()();
  TextColumn get sourceUrl => text()();
  TextColumn get serviceAreasJson => text()();
  DateTimeColumn get publishedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CartItems extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text()();
  TextColumn get title => text()();
  RealColumn get price => real()();
  TextColumn get currency => text()();
  TextColumn get imageUrl => text().nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class WishlistItems extends Table {
  TextColumn get productId => text()();
  TextColumn get title => text()();
  RealColumn get price => real().nullable()();
  TextColumn get imageUrl => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {productId};
}

@DriftDatabase(tables: [CachedCatalogProducts, CartItems, WishlistItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'blogstore'));

  @override
  int get schemaVersion => 1;
}
