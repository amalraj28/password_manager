import 'dart:math';

List<String> _generateAlphabets() {
  List<String> alphabets = [];
  for (int i = 65; i <= 90; i++) {
    alphabets.add(String.fromCharCode(i));
  }
  for (int i = 97; i <= 122; i++) {
    alphabets.add(String.fromCharCode(i));
  }
  return alphabets;
}

String generatePassword({length = const [15, 22]}) {
  List<String> symbols = [
    '!',
    '@',
    '#',
    '\$',
    '%',
    '^',
    '&',
    '*',
    '(',
    ')',
    '-',
    '_',
    '=',
    '+',
    '[',
    ']',
    '/',
  ];
  List<String> numbers =
      List.generate(10, (index) => '$index', growable: false);
  List<String> alphabets = _generateAlphabets();
  int minSymbol = 3, maxSymbol = 5;
  int minAlphabets = 8, maxAlphabets = 10;
  int minNumbers = 4, maxNumbers = 7;

  var random = Random();
  int symbolCount = random.nextInt(maxSymbol - minSymbol + 1) + minSymbol;
  int alphabetCount =
      random.nextInt(maxAlphabets - minAlphabets + 1) + minAlphabets;
  int numbersCount = random.nextInt(maxNumbers - minNumbers + 1) + minNumbers;

  symbols.shuffle();
  alphabets.shuffle();
  numbers.shuffle();

  List<String> finalPassword = symbols.sublist(0, symbolCount);
  finalPassword.addAll(alphabets.sublist(0, alphabetCount));
  finalPassword.addAll(numbers.sublist(0, numbersCount));
  finalPassword.shuffle();

  return finalPassword.join();
}
