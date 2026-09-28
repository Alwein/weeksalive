import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';

void main() {
  const delay = Duration(milliseconds: 50);

  Future<void> pumpColumn(WidgetTester tester) {
    return tester.pumpWidget(
      const MaterialApp(
        home: OnboardingStaggeredColumn(
          delay: delay,
          children: [Text('hello')],
        ),
      ),
    );
  }

  testWidgets('starts the stagger after the delay', (tester) async {
    await pumpColumn(tester);

    expect(find.byType(AnimationLimiter), findsNothing);

    await tester.pump(delay);

    expect(find.byType(AnimationLimiter), findsOneWidget);
    expect(find.text('hello'), findsOneWidget);
  });

  testWidgets('does not setState after the column is disposed', (tester) async {
    await pumpColumn(tester);
    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

    await tester.pump(delay);

    expect(tester.takeException(), isNull);
  });
}
