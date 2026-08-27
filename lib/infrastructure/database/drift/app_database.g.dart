// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedCatalogProductsTable extends CachedCatalogProducts
    with TableInfo<$CachedCatalogProductsTable, CachedCatalogProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedCatalogProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceUrlMeta =
      const VerificationMeta('sourceUrl');
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
      'source_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serviceAreasJsonMeta =
      const VerificationMeta('serviceAreasJson');
  @override
  late final GeneratedColumn<String> serviceAreasJson = GeneratedColumn<String>(
      'service_areas_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _publishedAtMeta =
      const VerificationMeta('publishedAt');
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
      'published_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        imageUrl,
        price,
        currency,
        sourceUrl,
        serviceAreasJson,
        publishedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_catalog_products';
  @override
  VerificationContext validateIntegrity(
      Insertable<CachedCatalogProduct> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('source_url')) {
      context.handle(_sourceUrlMeta,
          sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta));
    } else if (isInserting) {
      context.missing(_sourceUrlMeta);
    }
    if (data.containsKey('service_areas_json')) {
      context.handle(
          _serviceAreasJsonMeta,
          serviceAreasJson.isAcceptableOrUnknown(
              data['service_areas_json']!, _serviceAreasJsonMeta));
    } else if (isInserting) {
      context.missing(_serviceAreasJsonMeta);
    }
    if (data.containsKey('published_at')) {
      context.handle(
          _publishedAtMeta,
          publishedAt.isAcceptableOrUnknown(
              data['published_at']!, _publishedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedCatalogProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedCatalogProduct(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price']),
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency']),
      sourceUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_url'])!,
      serviceAreasJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}service_areas_json'])!,
      publishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}published_at']),
    );
  }

  @override
  $CachedCatalogProductsTable createAlias(String alias) {
    return $CachedCatalogProductsTable(attachedDatabase, alias);
  }
}

class CachedCatalogProduct extends DataClass
    implements Insertable<CachedCatalogProduct> {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final double? price;
  final String? currency;
  final String sourceUrl;
  final String serviceAreasJson;
  final DateTime? publishedAt;
  const CachedCatalogProduct(
      {required this.id,
      required this.name,
      required this.description,
      this.imageUrl,
      this.price,
      this.currency,
      required this.sourceUrl,
      required this.serviceAreasJson,
      this.publishedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    if (!nullToAbsent || currency != null) {
      map['currency'] = Variable<String>(currency);
    }
    map['source_url'] = Variable<String>(sourceUrl);
    map['service_areas_json'] = Variable<String>(serviceAreasJson);
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    return map;
  }

  CachedCatalogProductsCompanion toCompanion(bool nullToAbsent) {
    return CachedCatalogProductsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      price:
          price == null && nullToAbsent ? const Value.absent() : Value(price),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      sourceUrl: Value(sourceUrl),
      serviceAreasJson: Value(serviceAreasJson),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
    );
  }

  factory CachedCatalogProduct.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedCatalogProduct(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      price: serializer.fromJson<double?>(json['price']),
      currency: serializer.fromJson<String?>(json['currency']),
      sourceUrl: serializer.fromJson<String>(json['sourceUrl']),
      serviceAreasJson: serializer.fromJson<String>(json['serviceAreasJson']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'price': serializer.toJson<double?>(price),
      'currency': serializer.toJson<String?>(currency),
      'sourceUrl': serializer.toJson<String>(sourceUrl),
      'serviceAreasJson': serializer.toJson<String>(serviceAreasJson),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
    };
  }

  CachedCatalogProduct copyWith(
          {String? id,
          String? name,
          String? description,
          Value<String?> imageUrl = const Value.absent(),
          Value<double?> price = const Value.absent(),
          Value<String?> currency = const Value.absent(),
          String? sourceUrl,
          String? serviceAreasJson,
          Value<DateTime?> publishedAt = const Value.absent()}) =>
      CachedCatalogProduct(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        price: price.present ? price.value : this.price,
        currency: currency.present ? currency.value : this.currency,
        sourceUrl: sourceUrl ?? this.sourceUrl,
        serviceAreasJson: serviceAreasJson ?? this.serviceAreasJson,
        publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
      );
  CachedCatalogProduct copyWithCompanion(CachedCatalogProductsCompanion data) {
    return CachedCatalogProduct(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      price: data.price.present ? data.price.value : this.price,
      currency: data.currency.present ? data.currency.value : this.currency,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      serviceAreasJson: data.serviceAreasJson.present
          ? data.serviceAreasJson.value
          : this.serviceAreasJson,
      publishedAt:
          data.publishedAt.present ? data.publishedAt.value : this.publishedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedCatalogProduct(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('serviceAreasJson: $serviceAreasJson, ')
          ..write('publishedAt: $publishedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, imageUrl, price,
      currency, sourceUrl, serviceAreasJson, publishedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedCatalogProduct &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.imageUrl == this.imageUrl &&
          other.price == this.price &&
          other.currency == this.currency &&
          other.sourceUrl == this.sourceUrl &&
          other.serviceAreasJson == this.serviceAreasJson &&
          other.publishedAt == this.publishedAt);
}

class CachedCatalogProductsCompanion
    extends UpdateCompanion<CachedCatalogProduct> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String?> imageUrl;
  final Value<double?> price;
  final Value<String?> currency;
  final Value<String> sourceUrl;
  final Value<String> serviceAreasJson;
  final Value<DateTime?> publishedAt;
  final Value<int> rowid;
  const CachedCatalogProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.price = const Value.absent(),
    this.currency = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.serviceAreasJson = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedCatalogProductsCompanion.insert({
    required String id,
    required String name,
    required String description,
    this.imageUrl = const Value.absent(),
    this.price = const Value.absent(),
    this.currency = const Value.absent(),
    required String sourceUrl,
    required String serviceAreasJson,
    this.publishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        description = Value(description),
        sourceUrl = Value(sourceUrl),
        serviceAreasJson = Value(serviceAreasJson);
  static Insertable<CachedCatalogProduct> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? imageUrl,
    Expression<double>? price,
    Expression<String>? currency,
    Expression<String>? sourceUrl,
    Expression<String>? serviceAreasJson,
    Expression<DateTime>? publishedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (serviceAreasJson != null) 'service_areas_json': serviceAreasJson,
      if (publishedAt != null) 'published_at': publishedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedCatalogProductsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? description,
      Value<String?>? imageUrl,
      Value<double?>? price,
      Value<String?>? currency,
      Value<String>? sourceUrl,
      Value<String>? serviceAreasJson,
      Value<DateTime?>? publishedAt,
      Value<int>? rowid}) {
    return CachedCatalogProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      serviceAreasJson: serviceAreasJson ?? this.serviceAreasJson,
      publishedAt: publishedAt ?? this.publishedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (serviceAreasJson.present) {
      map['service_areas_json'] = Variable<String>(serviceAreasJson.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedCatalogProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('serviceAreasJson: $serviceAreasJson, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CartItemsTable extends CartItems
    with TableInfo<$CartItemsTable, CartItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns =>
      [id, productId, title, price, currency, imageUrl, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cart_items';
  @override
  VerificationContext validateIntegrity(Insertable<CartItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CartItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CartItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
    );
  }

  @override
  $CartItemsTable createAlias(String alias) {
    return $CartItemsTable(attachedDatabase, alias);
  }
}

class CartItem extends DataClass implements Insertable<CartItem> {
  final String id;
  final String productId;
  final String title;
  final double price;
  final String currency;
  final String? imageUrl;
  final int quantity;
  const CartItem(
      {required this.id,
      required this.productId,
      required this.title,
      required this.price,
      required this.currency,
      this.imageUrl,
      required this.quantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['title'] = Variable<String>(title);
    map['price'] = Variable<double>(price);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  CartItemsCompanion toCompanion(bool nullToAbsent) {
    return CartItemsCompanion(
      id: Value(id),
      productId: Value(productId),
      title: Value(title),
      price: Value(price),
      currency: Value(currency),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      quantity: Value(quantity),
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CartItem(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      title: serializer.fromJson<String>(json['title']),
      price: serializer.fromJson<double>(json['price']),
      currency: serializer.fromJson<String>(json['currency']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'title': serializer.toJson<String>(title),
      'price': serializer.toJson<double>(price),
      'currency': serializer.toJson<String>(currency),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  CartItem copyWith(
          {String? id,
          String? productId,
          String? title,
          double? price,
          String? currency,
          Value<String?> imageUrl = const Value.absent(),
          int? quantity}) =>
      CartItem(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        title: title ?? this.title,
        price: price ?? this.price,
        currency: currency ?? this.currency,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        quantity: quantity ?? this.quantity,
      );
  CartItem copyWithCompanion(CartItemsCompanion data) {
    return CartItem(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      title: data.title.present ? data.title.value : this.title,
      price: data.price.present ? data.price.value : this.price,
      currency: data.currency.present ? data.currency.value : this.currency,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CartItem(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('title: $title, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, title, price, currency, imageUrl, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartItem &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.title == this.title &&
          other.price == this.price &&
          other.currency == this.currency &&
          other.imageUrl == this.imageUrl &&
          other.quantity == this.quantity);
}

class CartItemsCompanion extends UpdateCompanion<CartItem> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> title;
  final Value<double> price;
  final Value<String> currency;
  final Value<String?> imageUrl;
  final Value<int> quantity;
  final Value<int> rowid;
  const CartItemsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.title = const Value.absent(),
    this.price = const Value.absent(),
    this.currency = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.quantity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CartItemsCompanion.insert({
    required String id,
    required String productId,
    required String title,
    required double price,
    required String currency,
    this.imageUrl = const Value.absent(),
    this.quantity = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        productId = Value(productId),
        title = Value(title),
        price = Value(price),
        currency = Value(currency);
  static Insertable<CartItem> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? title,
    Expression<double>? price,
    Expression<String>? currency,
    Expression<String>? imageUrl,
    Expression<int>? quantity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (title != null) 'title': title,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
      if (imageUrl != null) 'image_url': imageUrl,
      if (quantity != null) 'quantity': quantity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CartItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? productId,
      Value<String>? title,
      Value<double>? price,
      Value<String>? currency,
      Value<String?>? imageUrl,
      Value<int>? quantity,
      Value<int>? rowid}) {
    return CartItemsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartItemsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('title: $title, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('quantity: $quantity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WishlistItemsTable extends WishlistItems
    with TableInfo<$WishlistItemsTable, WishlistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WishlistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [productId, title, price, imageUrl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wishlist_items';
  @override
  VerificationContext validateIntegrity(Insertable<WishlistItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productId};
  @override
  WishlistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WishlistItem(
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price']),
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
    );
  }

  @override
  $WishlistItemsTable createAlias(String alias) {
    return $WishlistItemsTable(attachedDatabase, alias);
  }
}

class WishlistItem extends DataClass implements Insertable<WishlistItem> {
  final String productId;
  final String title;
  final double? price;
  final String? imageUrl;
  const WishlistItem(
      {required this.productId,
      required this.title,
      this.price,
      this.imageUrl});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<String>(productId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    return map;
  }

  WishlistItemsCompanion toCompanion(bool nullToAbsent) {
    return WishlistItemsCompanion(
      productId: Value(productId),
      title: Value(title),
      price:
          price == null && nullToAbsent ? const Value.absent() : Value(price),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
    );
  }

  factory WishlistItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WishlistItem(
      productId: serializer.fromJson<String>(json['productId']),
      title: serializer.fromJson<String>(json['title']),
      price: serializer.fromJson<double?>(json['price']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<String>(productId),
      'title': serializer.toJson<String>(title),
      'price': serializer.toJson<double?>(price),
      'imageUrl': serializer.toJson<String?>(imageUrl),
    };
  }

  WishlistItem copyWith(
          {String? productId,
          String? title,
          Value<double?> price = const Value.absent(),
          Value<String?> imageUrl = const Value.absent()}) =>
      WishlistItem(
        productId: productId ?? this.productId,
        title: title ?? this.title,
        price: price.present ? price.value : this.price,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
      );
  WishlistItem copyWithCompanion(WishlistItemsCompanion data) {
    return WishlistItem(
      productId: data.productId.present ? data.productId.value : this.productId,
      title: data.title.present ? data.title.value : this.title,
      price: data.price.present ? data.price.value : this.price,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WishlistItem(')
          ..write('productId: $productId, ')
          ..write('title: $title, ')
          ..write('price: $price, ')
          ..write('imageUrl: $imageUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(productId, title, price, imageUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WishlistItem &&
          other.productId == this.productId &&
          other.title == this.title &&
          other.price == this.price &&
          other.imageUrl == this.imageUrl);
}

class WishlistItemsCompanion extends UpdateCompanion<WishlistItem> {
  final Value<String> productId;
  final Value<String> title;
  final Value<double?> price;
  final Value<String?> imageUrl;
  final Value<int> rowid;
  const WishlistItemsCompanion({
    this.productId = const Value.absent(),
    this.title = const Value.absent(),
    this.price = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WishlistItemsCompanion.insert({
    required String productId,
    required String title,
    this.price = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : productId = Value(productId),
        title = Value(title);
  static Insertable<WishlistItem> custom({
    Expression<String>? productId,
    Expression<String>? title,
    Expression<double>? price,
    Expression<String>? imageUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (title != null) 'title': title,
      if (price != null) 'price': price,
      if (imageUrl != null) 'image_url': imageUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WishlistItemsCompanion copyWith(
      {Value<String>? productId,
      Value<String>? title,
      Value<double?>? price,
      Value<String?>? imageUrl,
      Value<int>? rowid}) {
    return WishlistItemsCompanion(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WishlistItemsCompanion(')
          ..write('productId: $productId, ')
          ..write('title: $title, ')
          ..write('price: $price, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedCatalogProductsTable cachedCatalogProducts =
      $CachedCatalogProductsTable(this);
  late final $CartItemsTable cartItems = $CartItemsTable(this);
  late final $WishlistItemsTable wishlistItems = $WishlistItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [cachedCatalogProducts, cartItems, wishlistItems];
}

typedef $$CachedCatalogProductsTableCreateCompanionBuilder
    = CachedCatalogProductsCompanion Function({
  required String id,
  required String name,
  required String description,
  Value<String?> imageUrl,
  Value<double?> price,
  Value<String?> currency,
  required String sourceUrl,
  required String serviceAreasJson,
  Value<DateTime?> publishedAt,
  Value<int> rowid,
});
typedef $$CachedCatalogProductsTableUpdateCompanionBuilder
    = CachedCatalogProductsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<String?> imageUrl,
  Value<double?> price,
  Value<String?> currency,
  Value<String> sourceUrl,
  Value<String> serviceAreasJson,
  Value<DateTime?> publishedAt,
  Value<int> rowid,
});

class $$CachedCatalogProductsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedCatalogProductsTable> {
  $$CachedCatalogProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceUrl => $composableBuilder(
      column: $table.sourceUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serviceAreasJson => $composableBuilder(
      column: $table.serviceAreasJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => ColumnFilters(column));
}

class $$CachedCatalogProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedCatalogProductsTable> {
  $$CachedCatalogProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
      column: $table.sourceUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serviceAreasJson => $composableBuilder(
      column: $table.serviceAreasJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => ColumnOrderings(column));
}

class $$CachedCatalogProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedCatalogProductsTable> {
  $$CachedCatalogProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get serviceAreasJson => $composableBuilder(
      column: $table.serviceAreasJson, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => column);
}

class $$CachedCatalogProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CachedCatalogProductsTable,
    CachedCatalogProduct,
    $$CachedCatalogProductsTableFilterComposer,
    $$CachedCatalogProductsTableOrderingComposer,
    $$CachedCatalogProductsTableAnnotationComposer,
    $$CachedCatalogProductsTableCreateCompanionBuilder,
    $$CachedCatalogProductsTableUpdateCompanionBuilder,
    (
      CachedCatalogProduct,
      BaseReferences<_$AppDatabase, $CachedCatalogProductsTable,
          CachedCatalogProduct>
    ),
    CachedCatalogProduct,
    PrefetchHooks Function()> {
  $$CachedCatalogProductsTableTableManager(
      _$AppDatabase db, $CachedCatalogProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedCatalogProductsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedCatalogProductsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedCatalogProductsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<double?> price = const Value.absent(),
            Value<String?> currency = const Value.absent(),
            Value<String> sourceUrl = const Value.absent(),
            Value<String> serviceAreasJson = const Value.absent(),
            Value<DateTime?> publishedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedCatalogProductsCompanion(
            id: id,
            name: name,
            description: description,
            imageUrl: imageUrl,
            price: price,
            currency: currency,
            sourceUrl: sourceUrl,
            serviceAreasJson: serviceAreasJson,
            publishedAt: publishedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String description,
            Value<String?> imageUrl = const Value.absent(),
            Value<double?> price = const Value.absent(),
            Value<String?> currency = const Value.absent(),
            required String sourceUrl,
            required String serviceAreasJson,
            Value<DateTime?> publishedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedCatalogProductsCompanion.insert(
            id: id,
            name: name,
            description: description,
            imageUrl: imageUrl,
            price: price,
            currency: currency,
            sourceUrl: sourceUrl,
            serviceAreasJson: serviceAreasJson,
            publishedAt: publishedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedCatalogProductsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $CachedCatalogProductsTable,
        CachedCatalogProduct,
        $$CachedCatalogProductsTableFilterComposer,
        $$CachedCatalogProductsTableOrderingComposer,
        $$CachedCatalogProductsTableAnnotationComposer,
        $$CachedCatalogProductsTableCreateCompanionBuilder,
        $$CachedCatalogProductsTableUpdateCompanionBuilder,
        (
          CachedCatalogProduct,
          BaseReferences<_$AppDatabase, $CachedCatalogProductsTable,
              CachedCatalogProduct>
        ),
        CachedCatalogProduct,
        PrefetchHooks Function()>;
typedef $$CartItemsTableCreateCompanionBuilder = CartItemsCompanion Function({
  required String id,
  required String productId,
  required String title,
  required double price,
  required String currency,
  Value<String?> imageUrl,
  Value<int> quantity,
  Value<int> rowid,
});
typedef $$CartItemsTableUpdateCompanionBuilder = CartItemsCompanion Function({
  Value<String> id,
  Value<String> productId,
  Value<String> title,
  Value<double> price,
  Value<String> currency,
  Value<String?> imageUrl,
  Value<int> quantity,
  Value<int> rowid,
});

class $$CartItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));
}

class $$CartItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));
}

class $$CartItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);
}

class $$CartItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CartItemsTable,
    CartItem,
    $$CartItemsTableFilterComposer,
    $$CartItemsTableOrderingComposer,
    $$CartItemsTableAnnotationComposer,
    $$CartItemsTableCreateCompanionBuilder,
    $$CartItemsTableUpdateCompanionBuilder,
    (CartItem, BaseReferences<_$AppDatabase, $CartItemsTable, CartItem>),
    CartItem,
    PrefetchHooks Function()> {
  $$CartItemsTableTableManager(_$AppDatabase db, $CartItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CartItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CartItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CartItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CartItemsCompanion(
            id: id,
            productId: productId,
            title: title,
            price: price,
            currency: currency,
            imageUrl: imageUrl,
            quantity: quantity,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String productId,
            required String title,
            required double price,
            required String currency,
            Value<String?> imageUrl = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CartItemsCompanion.insert(
            id: id,
            productId: productId,
            title: title,
            price: price,
            currency: currency,
            imageUrl: imageUrl,
            quantity: quantity,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CartItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CartItemsTable,
    CartItem,
    $$CartItemsTableFilterComposer,
    $$CartItemsTableOrderingComposer,
    $$CartItemsTableAnnotationComposer,
    $$CartItemsTableCreateCompanionBuilder,
    $$CartItemsTableUpdateCompanionBuilder,
    (CartItem, BaseReferences<_$AppDatabase, $CartItemsTable, CartItem>),
    CartItem,
    PrefetchHooks Function()>;
typedef $$WishlistItemsTableCreateCompanionBuilder = WishlistItemsCompanion
    Function({
  required String productId,
  required String title,
  Value<double?> price,
  Value<String?> imageUrl,
  Value<int> rowid,
});
typedef $$WishlistItemsTableUpdateCompanionBuilder = WishlistItemsCompanion
    Function({
  Value<String> productId,
  Value<String> title,
  Value<double?> price,
  Value<String?> imageUrl,
  Value<int> rowid,
});

class $$WishlistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));
}

class $$WishlistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));
}

class $$WishlistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);
}

class $$WishlistItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WishlistItemsTable,
    WishlistItem,
    $$WishlistItemsTableFilterComposer,
    $$WishlistItemsTableOrderingComposer,
    $$WishlistItemsTableAnnotationComposer,
    $$WishlistItemsTableCreateCompanionBuilder,
    $$WishlistItemsTableUpdateCompanionBuilder,
    (
      WishlistItem,
      BaseReferences<_$AppDatabase, $WishlistItemsTable, WishlistItem>
    ),
    WishlistItem,
    PrefetchHooks Function()> {
  $$WishlistItemsTableTableManager(_$AppDatabase db, $WishlistItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WishlistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WishlistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WishlistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> productId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double?> price = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WishlistItemsCompanion(
            productId: productId,
            title: title,
            price: price,
            imageUrl: imageUrl,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String productId,
            required String title,
            Value<double?> price = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WishlistItemsCompanion.insert(
            productId: productId,
            title: title,
            price: price,
            imageUrl: imageUrl,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WishlistItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WishlistItemsTable,
    WishlistItem,
    $$WishlistItemsTableFilterComposer,
    $$WishlistItemsTableOrderingComposer,
    $$WishlistItemsTableAnnotationComposer,
    $$WishlistItemsTableCreateCompanionBuilder,
    $$WishlistItemsTableUpdateCompanionBuilder,
    (
      WishlistItem,
      BaseReferences<_$AppDatabase, $WishlistItemsTable, WishlistItem>
    ),
    WishlistItem,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedCatalogProductsTableTableManager get cachedCatalogProducts =>
      $$CachedCatalogProductsTableTableManager(_db, _db.cachedCatalogProducts);
  $$CartItemsTableTableManager get cartItems =>
      $$CartItemsTableTableManager(_db, _db.cartItems);
  $$WishlistItemsTableTableManager get wishlistItems =>
      $$WishlistItemsTableTableManager(_db, _db.wishlistItems);
}
