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

  //Estas son las variables que se usan en el juego
  late String _wordToGuess;
  Set<String> _guessedLetters = {};
  int _incorrectGuesses = 0;
  final int maxIncorrectGuesses = 6; // Intentos máximos
  int _currentScore = 0;
  final int hintCost = 20; // Costo de la pista

  String get wordToGuess => _wordToGuess;
  Set<String> get guessedLetters => _guessedLetters;
  int get incorrectGuesses => _incorrectGuesses;
  int get remainingAttempts => maxIncorrectGuesses - _incorrectGuesses;
  int get currentScore => _currentScore;
  int get hintPrice => hintCost;

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
    _currentScore = 0;
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

    if (_guessedLetters.contains(upperCaseLetter)) {
      return false;
    }

    _guessedLetters.add(upperCaseLetter);

    if (!_wordToGuess.contains(upperCaseLetter)) {
      _incorrectGuesses++;
      _currentScore -= 5;
      if (_currentScore < 0) _currentScore = 0;
      return false;
    }

    int revealedCount = _wordToGuess
        .split('')
        .where((l) => l == upperCaseLetter)
        .length;
    _currentScore += 10 * revealedCount;

    return true;
  }

  //Método para obtener una pista
  bool getHint() {
    if (_currentScore < hintCost) {
      return false;
    }

    List<String> unrevealedLetters = _wordToGuess
        .split('')
        .where((letter) => !_guessedLetters.contains(letter))
        .toSet()
        .toList();

    if (unrevealedLetters.isEmpty) {
      return false;
    }

    // Selecciona una letra al azar para revelar
    final random = Random();
    String letterToReveal =
        unrevealedLetters[random.nextInt(unrevealedLetters.length)];

    _guessedLetters.add(letterToReveal);
    _currentScore -= hintCost;

    return true;
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

  bool get isGameLost => _incorrectGuesses >= maxIncorrectGuesses;
}
