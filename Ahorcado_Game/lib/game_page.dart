import 'package:flutter/material.dart';
import 'game_logic.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late GameLogic _gameLogic;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _gameLogic = GameLogic();
  }

  void _handleLetterPress(String letter) {
    if (_gameLogic.isGameOver) return;

    setState(() {
      _gameLogic.tryLetter(letter);
    });
  }

  void _resetGame() {
    setState(() {
      _gameLogic.resetGame();
    });
  }

  //Widget para el Dibujo del Ahorcado
  Widget _buildHangman() {
    String hangmanDesign;
    switch (_gameLogic.incorrectGuesses) {
      case 0:
        hangmanDesign = '🌳\n\n\n\n';
        break;
      case 1:
        hangmanDesign = '🤕\n\n\n\n';
        break;
      case 2:
        hangmanDesign = '🤕\n 👕\n\n\n';
        break;
      case 3:
        hangmanDesign = '🤕\n/👕\n\n\n';
        break;
      case 4:
        hangmanDesign = '🤕\n/👕\\\n\n\n';
        break;
      case 5:
        hangmanDesign = '🤕\n/👕\\\n/ \n\n';
        break;
      case 6:
        hangmanDesign = '💀\n/👕\\\n/ \\\n\n';
        break;
      default:
        hangmanDesign = '🌳\n\n\n\n';
    }

    return Center(
      child: Container(
        width: 150,
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
              'Intentos: ${_gameLogic.remainingAttempts}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  //Widget del Teclado
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
          padding: const EdgeInsets.all(2.0),
          child: ElevatedButton(
            onPressed: isGuessed || _gameLogic.isGameOver
                ? null
                : () => _handleLetterPress(letter),
            style: ElevatedButton.styleFrom(
              backgroundColor: isGuessed
                  ? (isCorrect ? Colors.green[300] : Colors.red[300])
                  : Colors.blueGrey[50],
              foregroundColor: Colors.black,
              minimumSize: const Size(30, 30),
              padding: EdgeInsets.zero,
            ),
            child: Text(letter, style: const TextStyle(fontSize: 16)),
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
    return Column(children: rows);
  }

  Widget puntajes() {
    return Container(
      color: Colors.blueGrey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Icon(Icons.insert_chart_outlined),
              Text(
                "Puntaje: ${_gameLogic.correctGuesses - 2 * _gameLogic.incorrectGuesses}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Icon(Icons.refresh),
              Text(
                'Intentos: ${_gameLogic.countAttempts}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Icon(Icons.play_arrow),
              Text(
                'Partidas jugadas: ${_gameLogic.playedGames}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Icon(Icons.check),
              Text(
                'Letras adivinadas: ${_gameLogic.correctGuesses}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Icon(Icons.error_outline),
              Text(
                'Letras no adivinadas: ${_gameLogic.incorrectGuesses}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //Estructura Principal del Scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('El Ahorcado'),
        backgroundColor: Colors.blueGrey,
        actions: [
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
            _buildHangman(),
            // Palabra a Adivinar
            Center(
              child: Text(
                _gameLogic.maskedWord,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
              ),
            ),
            const SizedBox(height: 30),

            _buildKeyboard(),
            puntajes(),
          ],
        ),
      ),
    );
  }
}
