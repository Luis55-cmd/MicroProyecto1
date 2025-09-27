import 'package:flutter/material.dart';
import 'package:ahorcado/logica/parte.dart';

class Ahorcado1 extends StatelessWidget {
  const Ahorcado1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Juego del ahorcado',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: ColumnaBody(),
    );
  }
}

class ColumnaBody extends StatelessWidget {
  const ColumnaBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [Adivina(), Letras()]);
  }
}

String _textodefault = '_ ';

class Adivina extends StatelessWidget {
  const Adivina({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Adivina la palabra siguiente', style: TextStyle(fontSize: 21)),
      ],
    );
  }
}

class Letras extends StatelessWidget {
  const Letras({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        Text(
          _textodefault *
              lista[random1]
                  .length, //AQUI SE PONE LA LONGITUD DE LA PALABRA ALEATORIA
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 100),
        ),
      ],
    );
  }
}

//ESTE WIDGET NO SIRVE AUN
class Juego extends StatelessWidget {
  const Juego({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //AQUI SE PONEN 2 COLUMNAS 1- PARA EL AHORCADO Y 2- PARA EL TECLADO
      ],
    );
  }
}
