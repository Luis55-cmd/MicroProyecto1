import 'package:shared_preferences/shared_preferences.dart';

class HighscoreManager {
  static const _KEY_GAMES_PLAYED = 'gamesPlayed';
  static const _KEY_GAMES_WON = 'gamesWon';
  static const _KEY_GAMES_LOST = 'gamesLost';

  int gamesPlayed = 0;
  int gamesWon = 0;
  int gamesLost = 0;

  // Carga las puntuaciones desde el almacenamiento local
  Future<void> loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    gamesPlayed = prefs.getInt(_KEY_GAMES_PLAYED) ?? 0;
    gamesWon = prefs.getInt(_KEY_GAMES_WON) ?? 0;
    gamesLost = prefs.getInt(_KEY_GAMES_LOST) ?? 0;
  }

  // Guarda las puntuaciones en el almacenamiento local
  Future<void> saveScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_KEY_GAMES_PLAYED, gamesPlayed);
    await prefs.setInt(_KEY_GAMES_WON, gamesWon);
    await prefs.setInt(_KEY_GAMES_LOST, gamesLost);
  }

  // Incrementa el contador de partidas y guarda
  Future<void> recordGame(bool won) async {
    gamesPlayed++;
    if (won) {
      gamesWon++;
    } else {
      gamesLost++;
    }
    await saveScores();
  }

  // Función opcional para reiniciar las puntuaciones
  Future<void> resetScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_KEY_GAMES_PLAYED);
    await prefs.remove(_KEY_GAMES_WON);
    await prefs.remove(_KEY_GAMES_LOST);
    gamesPlayed = 0;
    gamesWon = 0;
    gamesLost = 0;
  }
}
