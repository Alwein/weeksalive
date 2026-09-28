import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/presentation/home/widgets/day_resume_bottom_sheet/day_resume_session.dart';

void main() {
  const width = 300.0;
  final today = DateTime(2026, 6, 15);
  final earliest = DateTime(2026, 6, 1);

  Future<DayResumeSession> pumpSession(
    WidgetTester tester, {
    required DateTime date,
    DateTime? earliestDate,
    bool useDefaultEarliest = true,
  }) async {
    final session = DayResumeSession(
      date: date,
      earliestDate: useDefaultEarliest ? (earliestDate ?? earliest) : null,
      now: () => today,
    );
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      session.dispose();
    });
    await tester.pumpWidget(_SessionHost(session: session));
    session.updateWidth(width);
    return session;
  }

  Future<void> swipe(
    DayResumeSession session,
    WidgetTester tester, {
    required double delta,
    double velocity = 0,
  }) async {
    session.onDragStart();
    session.onDragUpdate(delta);
    session.onDragEnd(velocity);
    await tester.pumpAndSettle();
  }

  test('moves by calendar days across a daylight-saving change', () {
    final session = DayResumeSession(
      date: DateTime(2026, 3, 28),
      earliestDate: DateTime(2026, 1, 1),
      now: () => DateTime(2026, 4, 2),
    );
    addTearDown(session.dispose);

    expect(session.nextDate, DateTime(2026, 3, 29));
    expect(session.previousDate, DateTime(2026, 3, 27));
  });

  testWidgets('swiping left opens the next day', (tester) async {
    final session = await pumpSession(tester, date: DateTime(2026, 6, 10));

    await swipe(session, tester, delta: -120);

    expect(session.date, DateTime(2026, 6, 11));
    expect(session.offset, 0);
  });

  testWidgets('swiping right opens the previous day', (tester) async {
    final session = await pumpSession(tester, date: DateTime(2026, 6, 10));

    await swipe(session, tester, delta: 120);

    expect(session.date, DateTime(2026, 6, 9));
    expect(session.offset, 0);
  });

  testWidgets('a short drag snaps back to the same day', (tester) async {
    final session = await pumpSession(tester, date: DateTime(2026, 6, 10));

    await swipe(session, tester, delta: -40);

    expect(session.date, DateTime(2026, 6, 10));
    expect(session.offset, 0);
  });

  testWidgets('a fling opens the next day without a long drag', (tester) async {
    final session = await pumpSession(tester, date: DateTime(2026, 6, 10));

    await swipe(session, tester, delta: -10, velocity: -2000);

    expect(session.date, DateTime(2026, 6, 11));
  });

  testWidgets('cannot swipe past today', (tester) async {
    final session = await pumpSession(tester, date: today);

    await swipe(session, tester, delta: -200, velocity: -4000);

    expect(session.date, today);
    expect(session.offset, 0);
    expect(session.nextDate, isNull);
  });

  testWidgets('cannot swipe before the earliest day', (tester) async {
    final session = await pumpSession(tester, date: earliest);

    await swipe(session, tester, delta: 200, velocity: 4000);

    expect(session.date, earliest);
    expect(session.offset, 0);
    expect(session.previousDate, isNull);
  });

  testWidgets('can keep swiping into the past when no earliest day is set', (
    tester,
  ) async {
    final session = await pumpSession(
      tester,
      date: earliest,
      useDefaultEarliest: false,
    );

    await swipe(session, tester, delta: 120);

    expect(session.date, DateTime(2026, 5, 31));
  });

  testWidgets('each swipe moves only one day', (tester) async {
    final session = await pumpSession(tester, date: DateTime(2026, 6, 10));

    await swipe(session, tester, delta: -280);
    await swipe(session, tester, delta: -280);

    expect(session.date, DateTime(2026, 6, 12));
  });

  testWidgets('a swipe during the settle animation moves one more day', (
    tester,
  ) async {
    final session = await pumpSession(tester, date: DateTime(2026, 6, 10));

    session.onDragStart();
    session.onDragUpdate(-60);
    session.onDragEnd(-2000);
    await tester.pump(const Duration(milliseconds: 60));
    expect(session.offset, isNot(0));

    await swipe(session, tester, delta: -20, velocity: -2000);

    expect(session.date, DateTime(2026, 6, 12));
    expect(session.offset, 0);
  });

  testWidgets('rapid flicks each advance one day', (tester) async {
    final session = await pumpSession(tester, date: DateTime(2026, 6, 10));

    for (var i = 0; i < 4; i++) {
      session.onDragStart();
      session.onDragUpdate(-30);
      session.onDragEnd(-1500);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));
    }
    await tester.pumpAndSettle();

    expect(session.date, DateTime(2026, 6, 14));
    expect(session.offset, 0);
  });

  testWidgets('the day changes once the neighbour passes the middle', (
    tester,
  ) async {
    final session = await pumpSession(tester, date: DateTime(2026, 6, 10));

    session.onDragStart();
    session.onDragUpdate(-width * 0.6);

    expect(session.date, DateTime(2026, 6, 11));
    expect(session.offset, closeTo(width * 0.4, 0.01));

    session.onDragEnd(0);
    await tester.pumpAndSettle();
    expect(session.date, DateTime(2026, 6, 11));
  });

  testWidgets('reversing before release returns to the nearest day', (
    tester,
  ) async {
    final session = await pumpSession(tester, date: DateTime(2026, 6, 10));

    session.onDragStart();
    session.onDragUpdate(-100);
    session.onDragUpdate(80);
    session.onDragEnd(1000);
    await tester.pumpAndSettle();

    expect(session.date, DateTime(2026, 6, 10));
  });

  testWidgets('touching a settling page and releasing lands on a day', (
    tester,
  ) async {
    final session = await pumpSession(tester, date: DateTime(2026, 6, 10));

    session.onDragStart();
    session.onDragUpdate(-100);
    session.onDragEnd(0);
    await tester.pump(const Duration(milliseconds: 30));
    session.onDragStart();
    session.onDragCancel();
    await tester.pumpAndSettle();

    expect(session.offset, 0);
    expect(
      session.date,
      anyOf(DateTime(2026, 6, 10), DateTime(2026, 6, 11)),
    );
  });
}

class _SessionHost extends StatefulWidget {
  const _SessionHost({required this.session});

  final DayResumeSession session;

  @override
  State<_SessionHost> createState() => _SessionHostState();
}

class _SessionHostState extends State<_SessionHost>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.session.attach(this);
  }

  @override
  void dispose() {
    widget.session.detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
