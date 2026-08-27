// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserSettingsTable extends UserSettings
    with TableInfo<$UserSettingsTable, UserSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ThemeMode, int> themeMode =
      GeneratedColumn<int>(
        'theme_mode',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: Constant(AppConfig.defaultThemeMode.index),
      ).withConverter<ThemeMode>($UserSettingsTable.$converterthemeMode);
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(AppConfig.defaultLocale.languageCode),
  );
  @override
  List<GeneratedColumn> get $columns => [id, themeMode, languageCode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: $UserSettingsTable.$converterthemeMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}theme_mode'],
        )!,
      ),
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ThemeMode, int, int> $converterthemeMode =
      const EnumIndexConverter<ThemeMode>(ThemeMode.values);
}

class UserSetting extends DataClass implements Insertable<UserSetting> {
  final int id;
  final ThemeMode themeMode;
  final String languageCode;
  const UserSetting({
    required this.id,
    required this.themeMode,
    required this.languageCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['theme_mode'] = Variable<int>(
        $UserSettingsTable.$converterthemeMode.toSql(themeMode),
      );
    }
    map['language_code'] = Variable<String>(languageCode);
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      languageCode: Value(languageCode),
    );
  }

  factory UserSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSetting(
      id: serializer.fromJson<int>(json['id']),
      themeMode: $UserSettingsTable.$converterthemeMode.fromJson(
        serializer.fromJson<int>(json['themeMode']),
      ),
      languageCode: serializer.fromJson<String>(json['languageCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<int>(
        $UserSettingsTable.$converterthemeMode.toJson(themeMode),
      ),
      'languageCode': serializer.toJson<String>(languageCode),
    };
  }

  UserSetting copyWith({int? id, ThemeMode? themeMode, String? languageCode}) =>
      UserSetting(
        id: id ?? this.id,
        themeMode: themeMode ?? this.themeMode,
        languageCode: languageCode ?? this.languageCode,
      );
  UserSetting copyWithCompanion(UserSettingsCompanion data) {
    return UserSetting(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSetting(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('languageCode: $languageCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, themeMode, languageCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSetting &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.languageCode == this.languageCode);
}

class UserSettingsCompanion extends UpdateCompanion<UserSetting> {
  final Value<int> id;
  final Value<ThemeMode> themeMode;
  final Value<String> languageCode;
  const UserSettingsCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.languageCode = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.languageCode = const Value.absent(),
  });
  static Insertable<UserSetting> custom({
    Expression<int>? id,
    Expression<int>? themeMode,
    Expression<String>? languageCode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (languageCode != null) 'language_code': languageCode,
    });
  }

  UserSettingsCompanion copyWith({
    Value<int>? id,
    Value<ThemeMode>? themeMode,
    Value<String>? languageCode,
  }) {
    return UserSettingsCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<int>(
        $UserSettingsTable.$converterthemeMode.toSql(themeMode.value),
      );
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('languageCode: $languageCode')
          ..write(')'))
        .toString();
  }
}

class $CachedCatalogProductsTable extends CachedCatalogProducts
    with TableInfo<$CachedCatalogProductsTable, CachedCatalogProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedCatalogProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceAreasJsonMeta = const VerificationMeta(
    'serviceAreasJson',
  );
  @override
  late final GeneratedColumn<String> serviceAreasJson = GeneratedColumn<String>(
    'service_areas_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
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
    publishedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_catalog_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedCatalogProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceUrlMeta);
    }
    if (data.containsKey('service_areas_json')) {
      context.handle(
        _serviceAreasJsonMeta,
        serviceAreasJson.isAcceptableOrUnknown(
          data['service_areas_json']!,
          _serviceAreasJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceAreasJsonMeta);
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedCatalogProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedCatalogProduct(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      ),
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      )!,
      serviceAreasJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_areas_json'],
      )!,
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      ),
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
  const CachedCatalogProduct({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.price,
    this.currency,
    required this.sourceUrl,
    required this.serviceAreasJson,
    this.publishedAt,
  });
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
      price: price == null && nullToAbsent
          ? const Value.absent()
          : Value(price),
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

  factory CachedCatalogProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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

  CachedCatalogProduct copyWith({
    String? id,
    String? name,
    String? description,
    Value<String?> imageUrl = const Value.absent(),
    Value<double?> price = const Value.absent(),
    Value<String?> currency = const Value.absent(),
    String? sourceUrl,
    String? serviceAreasJson,
    Value<DateTime?> publishedAt = const Value.absent(),
  }) => CachedCatalogProduct(
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
      description: data.description.present
          ? data.description.value
          : this.description,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      price: data.price.present ? data.price.value : this.price,
      currency: data.currency.present ? data.currency.value : this.currency,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      serviceAreasJson: data.serviceAreasJson.present
          ? data.serviceAreasJson.value
          : this.serviceAreasJson,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
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
  int get hashCode => Object.hash(
    id,
    name,
    description,
    imageUrl,
    price,
    currency,
    sourceUrl,
    serviceAreasJson,
    publishedAt,
  );
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
  }) : id = Value(id),
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

  CachedCatalogProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String?>? imageUrl,
    Value<double?>? price,
    Value<String?>? currency,
    Value<String>? sourceUrl,
    Value<String>? serviceAreasJson,
    Value<DateTime?>? publishedAt,
    Value<int>? rowid,
  }) {
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  late final $CachedCatalogProductsTable cachedCatalogProducts =
      $CachedCatalogProductsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userSettings,
    cachedCatalogProducts,
  ];
}

typedef $$UserSettingsTableCreateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<int> id,
      Value<ThemeMode> themeMode,
      Value<String> languageCode,
    });
typedef $$UserSettingsTableUpdateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<int> id,
      Value<ThemeMode> themeMode,
      Value<String> languageCode,
    });

class $$UserSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ThemeMode, ThemeMode, int> get themeMode =>
      $composableBuilder(
        column: $table.themeMode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ThemeMode, int> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );
}

class $$UserSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTable,
          UserSetting,
          $$UserSettingsTableFilterComposer,
          $$UserSettingsTableOrderingComposer,
          $$UserSettingsTableAnnotationComposer,
          $$UserSettingsTableCreateCompanionBuilder,
          $$UserSettingsTableUpdateCompanionBuilder,
          (
            UserSetting,
            BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>,
          ),
          UserSetting,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableManager(_$AppDatabase db, $UserSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<ThemeMode> themeMode = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
              }) => UserSettingsCompanion(
                id: id,
                themeMode: themeMode,
                languageCode: languageCode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<ThemeMode> themeMode = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
              }) => UserSettingsCompanion.insert(
                id: id,
                themeMode: themeMode,
                languageCode: languageCode,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTable,
      UserSetting,
      $$UserSettingsTableFilterComposer,
      $$UserSettingsTableOrderingComposer,
      $$UserSettingsTableAnnotationComposer,
      $$UserSettingsTableCreateCompanionBuilder,
      $$UserSettingsTableUpdateCompanionBuilder,
      (
        UserSetting,
        BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>,
      ),
      UserSetting,
      PrefetchHooks Function()
    >;
typedef $$CachedCatalogProductsTableCreateCompanionBuilder =
    CachedCatalogProductsCompanion Function({
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
typedef $$CachedCatalogProductsTableUpdateCompanionBuilder =
    CachedCatalogProductsCompanion Function({
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
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceAreasJson => $composableBuilder(
    column: $table.serviceAreasJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );
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
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceAreasJson => $composableBuilder(
    column: $table.serviceAreasJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );
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
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get serviceAreasJson => $composableBuilder(
    column: $table.serviceAreasJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );
}

class $$CachedCatalogProductsTableTableManager
    extends
        RootTableManager<
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
            BaseReferences<
              _$AppDatabase,
              $CachedCatalogProductsTable,
              CachedCatalogProduct
            >,
          ),
          CachedCatalogProduct,
          PrefetchHooks Function()
        > {
  $$CachedCatalogProductsTableTableManager(
    _$AppDatabase db,
    $CachedCatalogProductsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedCatalogProductsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CachedCatalogProductsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedCatalogProductsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
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
              }) => CachedCatalogProductsCompanion(
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
          createCompanionCallback:
              ({
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
              }) => CachedCatalogProductsCompanion.insert(
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
        ),
      );
}

typedef $$CachedCatalogProductsTableProcessedTableManager =
    ProcessedTableManager<
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
        BaseReferences<
          _$AppDatabase,
          $CachedCatalogProductsTable,
          CachedCatalogProduct
        >,
      ),
      CachedCatalogProduct,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db, _db.userSettings);
  $$CachedCatalogProductsTableTableManager get cachedCatalogProducts =>
      $$CachedCatalogProductsTableTableManager(_db, _db.cachedCatalogProducts);
}
