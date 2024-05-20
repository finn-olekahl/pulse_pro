String enumToText(String input) {
  final RegExp exp = RegExp(r'(?<=[a-z])(?=[A-Z])');
  final List<String> words = input.split(exp);

  final String result = words.map((word) {
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');

  return result;
}