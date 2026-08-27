import 'package:flutter/material.dart';

import 'app/app.dart';
import 'injection/dependency_injection.dart';

void main() {
  final dependencies = Dependencies.create();
  runApp(BlogStoreApp(getProducts: dependencies.getCatalogProducts));
}
