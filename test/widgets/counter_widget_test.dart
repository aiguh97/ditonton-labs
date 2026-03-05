import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/presentation/widgets/counter_widget.dart';

void main() {
  testWidgets('CounterWidget increments and decrements', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: CounterWidget(initialValue: 5)),
        ),
      ),
    );

    final counterText = find.byKey(const Key('counterText'));
    final increment = find.byKey(const Key('incrementButton'));
    final decrement = find.byKey(const Key('decrementButton'));

    expect(counterText, findsOneWidget);
    expect(find.text('Count: 5'), findsOneWidget);

    await tester.tap(increment);
    await tester.pumpAndSettle();
    expect(find.text('Count: 6'), findsOneWidget);

    await tester.tap(decrement);
    await tester.pumpAndSettle();
    expect(find.text('Count: 5'), findsOneWidget);
  });
}
