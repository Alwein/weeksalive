import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';

class GridMotifRepository {
  final SharedPreferences _preferences;

  GridMotifRepository({required SharedPreferences preferences}) : _preferences = preferences;

  static const String _selectedMotifKey = 'grid_motif_v1';

  Future<GridMotifId> getSelectedMotif() async {
    final value = _preferences.getString(_selectedMotifKey);
    if (value == null) return GridMotifId.dots;
    return GridMotifId.fromStorageKey(value) ?? GridMotifId.dots;
  }

  Future<void> setSelectedMotif(GridMotifId motifId) async {
    await _preferences.setString(_selectedMotifKey, motifId.storageKey);
  }
}
