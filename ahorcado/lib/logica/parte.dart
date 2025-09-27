import 'dart:math';
//aqui esta la parte de la logica

Random random = Random();
int random1 = random.nextInt(lista.length);

var matrix = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
];

int contadorerrores = 0;

var lista = [
  'PERRO',
  'GATO',
  'TECLADO',
  'AVION',
  'KIWI',
  'PUERTO',
  'PORTERO',
  'NUBE',
  'GUITARRA',
  'VELOCIDAD',
  'MISTERIO',
  'TELEFONO',
  'OXIGENO',
  'CASCADA',
  'IMAN',
  'MARIPOSA',
  'PISCINA',
  'JARDIN',
  'ESPEJO',
  'COHETE',
  'BIBLIOTECA',
  'SILENCIO',
  'CHOCOLATE',
  'UNIVERSO',
  'BRUJULA',
  'SANDWICH',
];

void checkLetra(String letra) {
  if (lista[random1].contains(letra)) {
    String palabra = lista[random1];
    for (var i = 0; i < palabra.length; i++) {
      int newnum = 2 * i;
      cambio(newnum, letra);
    }
  } else {
    contadorerrores--;
  }
}

String cambio(int j, String l) {
  String c = textomod.replaceRange(j, j + 1, l);
  return c;
}

String prueba(int contadorerrores) {
  String hola = contadorerrores.toString();
  return hola;
}
