String capitalize(String input) {
  const List<String> lowercaseWords = [
    'a',
    'an',
    'and',
    'the',
    'but',
    'or',
    'nor',
    'at',
    'by',
    'for',
    'in',
    'of',
    'on',
    'to',
    'up',
    'with',
    'as',
    'is'
  ];

  RegExp regExp = RegExp(r'(\b[a-zA-Z]|(?<=-)[a-zA-Z])');

  String capitalized = input.replaceAllMapped(regExp, (Match match) {
    return match.group(0)!.toUpperCase();
  });

  return capitalized.split(" ").map(
    (e) {
      if (lowercaseWords.contains(e.toLowerCase())) {
        return e.toLowerCase();
      }
      return e;
    },
  ).join(" ");
}
