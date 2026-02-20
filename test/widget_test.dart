import 'package:flutter_test/flutter_test.dart';

import 'package:movie_list/main.dart';
import 'package:movie_list/screens/home_page.dart';

void main() {
  testWidgets('App opens Movie List home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // App shell should render without relying on the old counter template.
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Movie List'), findsOneWidget);
  });
}
