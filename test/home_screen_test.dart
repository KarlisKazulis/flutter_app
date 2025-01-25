//Some simple tests that check if the search bar is visible or if the grid is initially empty
//both tests pass
import 'package:flutter_test/flutter_test.dart';
import 'package:gif_search_app/windows/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('HomeScreen shows search bar', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('HomeScreen displays an empty grid initially',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });
}
