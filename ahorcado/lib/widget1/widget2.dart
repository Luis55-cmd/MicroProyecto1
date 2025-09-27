//Aqui se pone las columnas del ahorcado y la del teclado
//Aqui se pone las columnas del ahorcado y la del teclado
import 'package:ahorcado/logica/parte.dart';
import 'package:flutter/material.dart';

class Teclado extends StatefulWidget {
  const Teclado({super.key});

  @override
  State<Teclado> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Teclado> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                checkLetra('Q');
              },
              child: Text('Q'),
            ),
            ElevatedButton(
              onPressed: () {
                checkLetra('W');
              },
              child: Text('W'),
            ),
            ElevatedButton(onPressed: () => checkLetra('E'), child: Text('E')),
            ElevatedButton(
              onPressed: () {
                checkLetra('R');
              },
              child: Text('R'),
            ),
            ElevatedButton(onPressed: null, child: Text('T')),
            ElevatedButton(onPressed: null, child: Text('Y')),
            ElevatedButton(onPressed: null, child: Text('U')),
            ElevatedButton(onPressed: null, child: Text('I')),
            ElevatedButton(onPressed: null, child: Text('O')),
            ElevatedButton(onPressed: null, child: Text('P')),
          ],
        ),
        Row(
          children: [
            ElevatedButton(onPressed: null, child: Text('A')),
            ElevatedButton(onPressed: null, child: Text('S')),
            ElevatedButton(onPressed: null, child: Text('D')),
            ElevatedButton(onPressed: null, child: Text('F')),
            ElevatedButton(onPressed: null, child: Text('G')),
            ElevatedButton(onPressed: null, child: Text('H')),
            ElevatedButton(onPressed: null, child: Text('J')),
            ElevatedButton(onPressed: null, child: Text('K')),
            ElevatedButton(onPressed: null, child: Text('L')),
          ],
        ),
        Row(
          children: [
            ElevatedButton(onPressed: null, child: Text('Z')),
            ElevatedButton(onPressed: null, child: Text('X')),
            ElevatedButton(onPressed: null, child: Text('C')),
            ElevatedButton(onPressed: null, child: Text('V')),
            ElevatedButton(onPressed: null, child: Text('B')),
            ElevatedButton(onPressed: null, child: Text('N')),
            ElevatedButton(onPressed: null, child: Text('M')),
          ],
        ),
      ],
    );
  }
}

class Stickman extends StatefulWidget {
  const Stickman({super.key});

  @override
  State<Stickman> createState() => _StickmanState();
}

class _StickmanState extends State<Stickman> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [Text(prueba(contadorerrores), style: TextStyle(fontSize: 30))],
    );
  }
}
