import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/data/grid_motif/grid_motif_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GridMotifRepository', () {
    test('defaults to dots when unset', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repository = GridMotifRepository(preferences: prefs);

      expect(await repository.getSelectedMotif(), GridMotifId.dots);
    });

    test('persists selected motif', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repository = GridMotifRepository(preferences: prefs);

      await repository.setSelectedMotif(GridMotifId.squares);
      expect(await repository.getSelectedMotif(), GridMotifId.squares);
    });
  });
}
