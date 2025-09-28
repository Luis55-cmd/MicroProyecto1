import 'package:flutter/material.dart';
import 'game_logic.dart';
import 'score_manager.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late GameLogic _gameLogic;
  final HighscoreManager _highscoreManager = HighscoreManager();

  @override
  void initState() {
    super.initState();
    _startGame();
    _highscoreManager.loadScores().then((_) {
      setState(() {});
    });
  }

  void _startGame() {
    _gameLogic = GameLogic();
  }

  void _handleLetterPress(String letter) {
    if (_gameLogic.isGameOver) return;

    setState(() {
      _gameLogic.tryLetter(letter);

      if (_gameLogic.isGameOver) {
        _highscoreManager.recordGame(_gameLogic.isGameWon).then((_) {
          _showGameResultDialog(_gameLogic.isGameWon);
        });
      }
    });
  }

  void _handleHint() {
    if (_gameLogic.isGameOver) return;

    setState(() {
      bool success = _gameLogic.getHint();

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _gameLogic.isGameWon
                  ? '¡Ya adivinaste la palabra!'
                  : 'Necesitas ${_gameLogic.hintPrice} puntos para una pista.',
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: _gameLogic.isGameWon ? Colors.green : Colors.red,
          ),
        );
      }

      if (_gameLogic.isGameWon) {
        _highscoreManager.recordGame(true).then((_) {
          _showGameResultDialog(true);
        });
      }
    });
  }

  void _resetGame() {
    setState(() {
      _gameLogic.resetGame();
    });
  }

  //WIDGET DE PUNTAJE ACTUAL
  Widget _buildScorePanel() {
    return Card(
      elevation: 4,
      color: Colors.deepOrange.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'PUNTAJE ACTUAL:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            Text(
              '${_gameLogic.currentScore} Pts',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //WIDGET DEL MUÑECO DEL AHORCADO
  Widget _buildHangman() {
    String hangmanDesign;
    switch (_gameLogic.incorrectGuesses) {
      case 0:
        hangmanDesign = '🌳\n\n\n\n';
        break;
      case 1:
        hangmanDesign = 'O\n\n\n\n';
        break;
      case 2:
        hangmanDesign = 'O\n|\n\n\n';
        break;
      case 3:
        hangmanDesign = 'O\n/|\n\n\n';
        break;
      case 4:
        hangmanDesign = 'O\n/|\\\n\n\n';
        break;
      case 5:
        hangmanDesign = 'O\n/|\\\n/ \n\n';
        break;
      case 6:
        hangmanDesign = '💀\n/|\\\n/ \\\n\n';
        break;
      default:
        hangmanDesign = '🌳\n\n\n\n';
    }

    return Center(
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey, width: 3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              hangmanDesign,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              '❌ Intentos Restantes: ${_gameLogic.remainingAttempts}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _gameLogic.remainingAttempts > 2
                    ? Colors.teal
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //WIDGET DE PISTAS
  Widget _buildHintPanel() {
    bool canGetHint =
        _gameLogic.currentScore >= _gameLogic.hintPrice &&
        !_gameLogic.isGameOver;

    return Card(
      elevation: 4,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '💡 Pista (Ayuda)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Costo: ${_gameLogic.hintPrice} Pts',
                  style: TextStyle(color: Colors.blue.shade700),
                ),
              ],
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.lightbulb_outline),
              label: const Text('REVELAR LETRA'),
              onPressed: canGetHint ? _handleHint : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //WIDGET DEL TECLADO
  Widget _buildKeyboard() {
    const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    List<Widget> rows = [];
    int start = 0;
    int end = 0;
    List<int> splits = [10, 9, 7];

    for (int count in splits) {
      end += count;
      String sub = alphabet.substring(start, end);

      List<Widget> letterButtons = sub.split('').map((letter) {
        bool isGuessed = _gameLogic.guessedLetters.contains(letter);
        bool isCorrect = isGuessed && _gameLogic.wordToGuess.contains(letter);

        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: ElevatedButton(
            onPressed: isGuessed || _gameLogic.isGameOver
                ? null
                : () => _handleLetterPress(letter),
            style: ElevatedButton.styleFrom(
              backgroundColor: isGuessed
                  ? (isCorrect ? Colors.green.shade600 : Colors.red.shade600)
                  : Colors.teal.shade50,
              foregroundColor: isGuessed ? Colors.white : Colors.black,
              minimumSize: const Size(40, 40),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(letter, style: const TextStyle(fontSize: 20)),
          ),
        );
      }).toList();

      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: letterButtons,
        ),
      );
      start = end;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      color: Colors.white,
      child: Column(children: rows),
    );
  }

  // WIDGET auxiliar para mostrar la info de letras
  Widget _buildLetterInfo({
    required String title,
    required String letters,
    required Color color,
  }) {
    Color baseColor = color;
    Color borderColor = Color.alphaBlend(
      Colors.black.withOpacity(0.3),
      baseColor,
    );

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: baseColor.value == Colors.green.value
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.alphaBlend(Colors.black.withOpacity(0.8), baseColor),
            ),
          ),
          const SizedBox(height: 5),
          Text(letters, style: const TextStyle(fontSize: 18, letterSpacing: 1)),
        ],
      ),
    );
  }

  //WIDGET auxiliar para las píldoras de puntuación del historial
  Widget _ScorePill({
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: color)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Color(color.value).withAlpha(25),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color, width: 1),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.alphaBlend(Colors.black.withOpacity(0.9), color),
            ),
          ),
        ),
      ],
    );
  }

  //WIDGET DE CONTENIDO DEL HISTORIAL
  Widget _buildHighscoresContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🏆 Histórico de Partidas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.teal,
          ),
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ScorePill(
              title: 'Jugadas',
              value: _highscoreManager.gamesPlayed.toString(),
              color: Colors.blueGrey,
            ),
            _ScorePill(
              title: 'Ganadas',
              value: _highscoreManager.gamesWon.toString(),
              color: Colors.green,
            ),
            _ScorePill(
              title: 'Perdidas',
              value: _highscoreManager.gamesLost.toString(),
              color: Colors.red,
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  //FUNCIÓN PARA MOSTRAR EL DIÁLOGO DEL HISTORIAL
  void _showHighscoresDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
          content: _buildHighscoresContent(),
          actions: <Widget>[
            TextButton(
              child: const Text('CERRAR', style: TextStyle(color: Colors.teal)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showGameResultDialog(bool won) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(won ? '🎉 ¡GANASTE! 🎉' : '😭 ¡PERDISTE! 😭'),
          content: Text(
            'La palabra era: ${_gameLogic.wordToGuess}\n'
            'Puntaje Final: ${_gameLogic.currentScore} Pts\n\n'
            'Intentos Totales: ${_gameLogic.attempts}',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Jugar de Nuevo',
                style: TextStyle(color: Colors.teal),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  //ESTRUCTURA PRINCIPAL DEL SCAFFOLD
  @override
  Widget build(BuildContext context) {
    Set<String> correctLetters = _gameLogic.guessedLetters
        .where((l) => _gameLogic.wordToGuess.contains(l))
        .toSet();
    Set<String> incorrectLetters = _gameLogic.guessedLetters
        .where((l) => !_gameLogic.wordToGuess.contains(l))
        .toSet();

    String correctLettersDisplay = correctLetters.join(', ');
    String incorrectLettersDisplay = incorrectLetters.join(', ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('El Ahorcado en Flutter'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: _showHighscoresDialog,
            tooltip: 'Ver Histórico',
          ),

          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: 'Nueva Partida',
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildScorePanel(),
            const SizedBox(height: 20),

            _buildHangman(),
            const SizedBox(height: 20),

            _buildHintPanel(),
            const SizedBox(height: 20),

            // Palabra a Adivinar
            Card(
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Text(
                    _gameLogic.maskedWord,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 10,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Estadísticas de letras
            _buildLetterInfo(
              title: 'Letras Correctas (${correctLetters.length})',
              letters: correctLettersDisplay.isNotEmpty
                  ? correctLettersDisplay
                  : 'Adivina la primera letra...',
              color: Colors.green,
            ),
            const SizedBox(height: 10),

            _buildLetterInfo(
              title: 'Letras Incorrectas (${incorrectLetters.length})',
              letters: incorrectLettersDisplay.isNotEmpty
                  ? incorrectLettersDisplay
                  : 'Ninguna',
              color: Colors.red,
            ),
            const SizedBox(height: 30),

            _buildKeyboard(),
          ],
        ),
      ),
    );
  }
}
