import 'dart:math';

int getAlphabetOrderNumberFromString(String string) {
  List stringList = [
    '-',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  ];
  print(stringList.length);
  double returnNumber = 0.0;
  String returnString = '';
  for (var char in string.split('').toList()) {
    if (stringList.contains(char.toLowerCase())) {
      returnString =
          returnString + stringList.indexOf(char.toLowerCase()).toString();
    } else {
      List numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      if (numbers.contains(char)) {
        returnString = returnString + int.parse(char).toString();
      } else {
        returnString = returnString + '0';
      }
    }
  }
  returnNumber = sqrt(sqrt(double.parse(returnString)));
  // returnNumber=double.parse(returnString);
  print(returnNumber);
  print(returnString);
  // BigInt bin = BigInt.parse(returnString,radix: 16);
  // print(bin);

  return returnNumber.round();
}
