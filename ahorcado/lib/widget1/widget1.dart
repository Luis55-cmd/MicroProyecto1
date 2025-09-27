import 'package:flutter/material.dart';
import 'package:ahorcado/logica/parte.dart';
import 'package:ahorcado/widget1/widget2.dart';


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
String textomod = textodefault * lista[random1].length;

class Adivina extends StatelessWidget {
  const Adivina({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Padding(padding: EdgeInsetsGeometry.only(top: 100)),
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
          textomod, //AQUI SE PONE LA LONGITUD DE LA PALABRA ALEATORIA
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
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    return Row(
      children: [
        Padding(padding: EdgeInsetsGeometry.only(top: 200)),
        Stickman(),
        Teclado(),
      ],
    );
  }
}
