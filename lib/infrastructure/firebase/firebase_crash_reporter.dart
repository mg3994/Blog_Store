import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/src/foundation/assertions.dart';

import '../../core/monitoring/crash_reporter.dart';

final class FirebaseCrashReporter implements CrashReporter {
  FirebaseCrashReporter(this._crashlytics);

  final FirebaseCrashlytics _crashlytics;

  @override
  /// Submits a Crashlytics report of a caught error.
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) => _crashlytics.recordError(
    exception,
    stack,
    reason: reason,
    information: information,
    printDetails: printDetails,
    fatal: fatal,
  );

  @override
  Future<void> recordFlutterError(
    FlutterErrorDetails flutterErrorDetails, {
    bool fatal = false,
  }) => _crashlytics.recordFlutterError(flutterErrorDetails, fatal: fatal);

  @override
  Future<void> recordFlutterFatalError(
    FlutterErrorDetails flutterErrorDetails,
  ) => _crashlytics.recordFlutterError(flutterErrorDetails);
}
