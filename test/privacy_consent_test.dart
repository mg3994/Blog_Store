import 'package:blogstore/features/settings/privacy_setting/privacy_setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('Privacy Setting UI Components', () {
    testWidgets('AnalyticsConsentHeader renders header text and privacy link',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnalyticsConsentHeader(),
          ),
        ),
      );

      expect(find.text('We use cookies & data'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('privacy policy'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('AnalyticsConsentPreferences renders consent switches',
        (WidgetTester tester) async {
      bool analytics = true;
      bool ad = true;
      bool personalization = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnalyticsConsentPreferences(
                  analyticsConsent: analytics,
                  advertisingConsent: ad,
                  personalizationConsent: personalization,
                  onAnalyticsChanged: (val) => setState(() => analytics = val),
                  onAdvertisingChanged: (val) => setState(() => ad = val),
                  onPersonalizationChanged: (val) =>
                      setState(() => personalization = val),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Necessary'), findsOneWidget);
      expect(find.text('Analytics'), findsOneWidget);
      expect(find.text('Advertising'), findsOneWidget);
      expect(find.text('Personalization'), findsOneWidget);
    });

    testWidgets('AnalyticsConsentActions renders initial actions and settings mode',
        (WidgetTester tester) async {
      bool showSettings = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnalyticsConsentActions(
                  showSettingsSelection: showSettings,
                  onAcceptAll: () {},
                  onAcceptSelected: () {},
                  onOpenSettings: () => setState(() => showSettings = true),
                  onBackFromSettings: () => setState(() => showSettings = false),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Accept all'), findsOneWidget);

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Accept'), findsOneWidget);
    });
  });
}
