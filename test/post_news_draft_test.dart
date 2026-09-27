import 'package:eduvora/core/models/news_item.dart';
import 'package:eduvora/core/services/local_store.dart';
import 'package:eduvora/features/news/presentation/screens/post_news_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _wrap(Widget child) => MaterialApp(home: child);

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await LocalStore.init();
  });

  testWidgets(
    'typing into the post form survives a full reload (the app being '
    'reclaimed while the owner copies the next detail from elsewhere)',
    (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const PostNewsScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Title'),
        'MTN Foundation Scholarship 2026',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Details'),
        'Undergraduate scholarship, apply before',
      );
      await tester.pump();

      // Simulate the whole app reloading from scratch, as a reclaimed
      // mobile-browser tab would: build a fresh PostNewsScreen, backed by
      // the same persisted store, with nothing carried over in memory.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(_wrap(const PostNewsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('MTN Foundation Scholarship 2026'), findsOneWidget);
      expect(
        find.text('Undergraduate scholarship, apply before'),
        findsOneWidget,
      );
      expect(find.text('Picked up where you left off.'), findsOneWidget);
    },
  );

  testWidgets(
    'a saved draft is picked back up, and removing it leaves a clean form '
    '(the state used once a post actually succeeds)',
    (WidgetTester tester) async {
      await LocalStore.instance.writeMap(
        StoreKeys.postNewsDraft,
        <String, dynamic>{
          'title': 'Old draft',
          'summary': 'Should be gone once removed',
          'source': 'Eduvora',
          'link': '',
          'category': NewsCategory.scholarship.name,
          'featured': false,
        },
      );

      await tester.pumpWidget(_wrap(const PostNewsScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Old draft'), findsOneWidget);

      await LocalStore.instance.remove(StoreKeys.postNewsDraft);
      expect(LocalStore.instance.readMap(StoreKeys.postNewsDraft), isNull);

      // A fresh screen after the draft key is gone starts blank, exactly as
      // it does right after a successful post clears it.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(_wrap(const PostNewsScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Old draft'), findsNothing);
    },
  );
}
