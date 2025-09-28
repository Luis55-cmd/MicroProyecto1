import 'dart:math';

class GameLogic {
  final List<String> _wordList = [
    'FLUTTER',
    'DART',
    'WIDGET',
    'MOBILE',
    'CODIGO',
    'PROYECTO',
    'ESTADO',
    'APLICACION',
    'ALGORITMO',
    'VARIABLE',
    'FUNCION',
    'COMPILADOR',
    'DEPURAR',
    'SINTAXIS',
    'BUCLE',
    'FRAMEWORK',
    'SERVIDOR',
  ];

  //estas son las variables que se usan en el juego
  int _playedGames = 0;
  int _correctGuesses = 0;
  int _countAttempts = 0;
  late String _wordToGuess;
  Set<String> _guessedLetters = {};
  int _incorrectGuesses = 0;
  final int maxIncorrectGuesses = 6; // Intentos máximos

  String get wordToGuess => _wordToGuess;
  Set<String> get guessedLetters => _guessedLetters;
  int get incorrectGuesses => _incorrectGuesses;
  int get correctGuesses => _correctGuesses;
  int get countAttempts => _countAttempts;
  int get playedGames => _playedGames;
  int get remainingAttempts => maxIncorrectGuesses - _incorrectGuesses;

  GameLogic() {
    _wordToGuess = _getRandomWord();
  }

  String _getRandomWord() {
    final random = Random();
    return _wordList[random.nextInt(_wordList.length)];
  }

  void resetGame() {
    _wordToGuess = _getRandomWord();
    _guessedLetters = {};
    _incorrectGuesses = 0;
    _countAttempts = 0;
    _correctGuesses = 0;
    _playedGames++;
  }

  // Genera la palabra oculta, por ejemplo: 'F L _ T T E R'
  String get maskedWord {
    String masked = '';
    for (int i = 0; i < _wordToGuess.length; i++) {
      String letter = _wordToGuess[i];
      if (_guessedLetters.contains(letter)) {
        masked += '$letter ';
      } else {
        masked += '_ ';
      }
    }
    return masked.trim();
  }

  // Lógica principal para intentar una letra
  bool tryLetter(String letter) {
    String upperCaseLetter = letter.toUpperCase();
    _countAttempts++;
    if (_guessedLetters.contains(upperCaseLetter)) {
      return false; // Ya se intentó
    }

    _guessedLetters.add(upperCaseLetter);

    if (!_wordToGuess.contains(upperCaseLetter)) {
      _incorrectGuesses++;
      return false; // Intento incorrecto
    }
    _correctGuesses++;
    return true; // Intento correcto
  }

  bool get isGameOver => isGameWon || isGameLost;

  bool get isGameWon {
    for (int i = 0; i < _wordToGuess.length; i++) {
      if (!_guessedLetters.contains(_wordToGuess[i])) {
        return false;
      }
    }
    return true;
  }

  bool get isGameLost {
    return _incorrectGuesses >= maxIncorrectGuesses;
  }
}
