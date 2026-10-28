import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/home/widgets/day_resume_bottom_sheet/day_resume_bottom_sheet.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/day/day_state.dart';
import 'package:weeksalive/presentation/widgets/image_carousel_page.dart';

import '../../../../helpers/localized_app.dart';

late Map<String, dynamic> _english;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    _english = readEnglishTranslations();
  });

  testWidgets(
    'swiping left and right changes the visible day and stops at today',
    (tester) async {
      final today = normalizeDay(DateTime.now());
      final yesterday = DateTime(today.year, today.month, today.day - 1);
      final dayBefore = DateTime(today.year, today.month, today.day - 2);
      final tomorrow = DateTime(today.year, today.month, today.day + 1);
      final recorded = [dayBefore, yesterday, today];
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.initial().copyWith(
          dayState: DayState(
            entries: {
              for (final date in recorded)
                date: DayEntry(
                  date: date,
                  leaveATrace: LeaveATrace(text: _marker(date)),
                ),
            },
          ),
        ),
      );

      await _pumpHost(tester, store, yesterday);

      await tester.tap(find.text('open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(DayResumeBottomSheet), findsOneWidget);
      expect(_dayIsVisible(tester, yesterday), isTrue);
      expect(_dayIsVisible(tester, today), isFalse);

      await tester.drag(
        find.byType(DayResumeBottomSheet),
        const Offset(-420, 0),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(DayResumeBottomSheet), findsOneWidget);
      expect(_dayIsVisible(tester, today), isTrue);
      expect(_dayIsVisible(tester, yesterday), isFalse);

      await tester.drag(
        find.byType(DayResumeBottomSheet),
        const Offset(-420, 0),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(_dayIsVisible(tester, today), isTrue);
      expect(find.text('"${_marker(tomorrow)}"'), findsNothing);

      await tester.drag(
        find.byType(DayResumeBottomSheet),
        const Offset(420, 0),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(_dayIsVisible(tester, yesterday), isTrue);
      expect(_dayIsVisible(tester, today), isFalse);
    },
  );

  testWidgets(
    'photos overflowing above the sheet show whole and open the carousel from anywhere on them',
    (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final directory = Directory.systemTemp.createTempSync('day_resume_photos');
      addTearDown(() => directory.deleteSync(recursive: true));
      final png = await tester.runAsync(_squarePng);
      final imagePaths = [
        for (var i = 0; i < 2; i++) (File('${directory.path}/$i.png')..writeAsBytesSync(png!)).path,
      ];

      final today = normalizeDay(DateTime.now());
      final yesterday = DateTime(today.year, today.month, today.day - 1);
      final dayBefore = DateTime(today.year, today.month, today.day - 2);
      // Neighbours are built off-screen; an entry keeps them off the empty
      // state, whose Rive animation cannot load in tests.
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.initial().copyWith(
          dayState: DayState(
            entries: {
              for (final date in [dayBefore, today]) date: DayEntry(date: date),
              yesterday: DayEntry(
                date: yesterday,
                leaveATrace: LeaveATrace(imagePaths: imagePaths),
              ),
            },
          ),
        ),
      );

      await _pumpHost(tester, store, yesterday);
      await tester.tap(find.text('open'));
      await tester.pump();

      // Photo frames read and decode their file through real I/O before taking
      // a size, one step per turn of the real event loop.
      final photos = find.byWidgetPredicate((widget) => widget is Image && widget.image is FileImage);
      for (var i = 0; i < 20 && photos.evaluate().length < 2; i++) {
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
        await tester.pump();
      }
      // Let the delayed rise animation start, then finish.
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(seconds: 1));
      expect(photos, findsNWidgets(2));
      final sheetTop = tester.getTopLeft(find.byType(DayResumeBottomSheet)).dy;

      // Every corner of every frame, tilt included, stays inside the clip that
      // lets the photos sink into the sheet.
      final clip = tester.getRect(find.ancestor(of: photos.first, matching: find.byType(ClipRect)).first).inflate(0.5);
      for (var i = 0; i < 2; i++) {
        final frame = tester.renderObject<RenderBox>(
          find.ancestor(of: photos.at(i), matching: find.byType(Container)).first,
        );
        for (final corner in [
          Offset.zero,
          frame.size.topRight(Offset.zero),
          frame.size.bottomLeft(Offset.zero),
          frame.size.bottomRight(Offset.zero),
        ]) {
          final point = frame.localToGlobal(corner);
          expect(clip.contains(point), isTrue, reason: 'photo $i corner $point is clipped by $clip');
        }
      }

      // The outer top corner of each photo: above the sheet and away from the
      // centre of the preview.
      for (final (index, corner) in [(0, const Offset(0.15, 0.15)), (1, const Offset(0.85, 0.15))]) {
        final photo = tester.renderObject<RenderBox>(photos.at(index));
        final target = photo.localToGlobal(
          Offset(photo.size.width * corner.dx, photo.size.height * corner.dy),
        );
        expect(target.dy, lessThan(sheetTop));

        await tester.tapAt(target);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Still open, under the full-screen carousel.
        expect(find.byType(DayResumeBottomSheet, skipOffstage: false), findsOneWidget);
        final carousel = find.byType(ImageCarouselPage);
        expect(carousel, findsOneWidget);
        expect(tester.widget<ImageCarouselPage>(carousel).initialIndex, index);

        Navigator.of(tester.element(carousel)).pop();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
      }
    },
  );

  testWidgets(
    'deleting a day asks first, then removes it once the sheet has closed',
    (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final today = normalizeDay(DateTime.now());
      final yesterday = DateTime(today.year, today.month, today.day - 1);
      final dayBefore = DateTime(today.year, today.month, today.day - 2);
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.initial().copyWith(
          dayState: DayState(
            entries: {
              for (final date in [dayBefore, yesterday, today])
                date: DayEntry(
                  date: date,
                  leaveATrace: LeaveATrace(text: _marker(date)),
                ),
            },
          ),
        ),
      );

      await _pumpHost(tester, store, yesterday);
      await tester.tap(find.text('open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.text('Delete this day').hitTestable());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Delete this day?'), findsOneWidget);

      await tester.tap(find.text('Keep it'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Delete this day?'), findsNothing);
      expect(find.byType(DayResumeBottomSheet), findsOneWidget);
      expect(store.state.dayState.entryFor(yesterday), isNotNull);

      await tester.tap(find.text('Delete this day').hitTestable());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('Delete'));
      await tester.pump();

      // Still there while the sheet slides away.
      expect(store.state.dayState.entryFor(yesterday), isNotNull);

      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(DayResumeBottomSheet), findsNothing);
      expect(store.state.dayState.entryFor(yesterday), isNull);
      expect(store.state.dayState.entryFor(dayBefore), isNotNull);
      expect(store.state.dayState.entryFor(today), isNotNull);
    },
  );
}

Future<void> _pumpHost(
  WidgetTester tester,
  Store<AppState> store,
  DateTime date,
) async {
  await tester.pumpWidget(
    localizedApp(
      english: _english,
      store: store,
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () => DayResumeBottomSheet.show(
                context,
                date: date,
              ),
              child: const Text('open'),
            );
          },
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

Future<Uint8List> _squarePng() async {
  final recorder = ui.PictureRecorder();
  Canvas(recorder).drawPaint(Paint()..color = const Color(0xFFE53935));
  final image = await recorder.endRecording().toImage(8, 8);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

String _marker(DateTime date) => '${date.year}-${date.month}-${date.day}';

bool _dayIsVisible(WidgetTester tester, DateTime date) {
  final finder = find.text('"${_marker(date)}"');
  if (finder.evaluate().isEmpty) return false;
  final sheet = tester.getRect(find.byType(DayResumeBottomSheet));
  return sheet.overlaps(tester.getRect(finder));
}
