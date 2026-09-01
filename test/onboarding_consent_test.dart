import 'package:blogstore/app/router/router.dart';
import 'package:blogstore/features/settings/app_setting/presentation/bloc/app_setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Onboarding and Consent Route & State Unit Tests', () {
    test('OnboardingRoute and PrivacySettingRoute equality', () {
      expect(const OnboardingRoute(), equals(const OnboardingRoute()));
      expect(const PrivacySettingRoute(), equals(const PrivacySettingRoute()));
    });

    test('AppSettingState copyWith updates onboarding & consent flags', () {
      const state = AppSettingState(
        themeMode: ThemeMode.system,
        locale: Locale('en'),
        seedColor: Color(0xFF0000FF),
      );

      expect(state.hasCompletedOnboarding, isFalse);
      expect(state.hasGivenConsent, isFalse);

      final updatedState = state.copyWith(
        hasCompletedOnboarding: true,
        hasGivenConsent: true,
        analyticsStorageConsentGranted: true,
        adStorageConsentGranted: false,
      );

      expect(updatedState.hasCompletedOnboarding, isTrue);
      expect(updatedState.hasGivenConsent, isTrue);
      expect(updatedState.analyticsStorageConsentGranted, isTrue);
      expect(updatedState.adStorageConsentGranted, isFalse);
    });
  });
}
