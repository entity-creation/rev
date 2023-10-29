String toTitleCase(String text) {
  if (text == "") {
    return "";
  } else {
    List<String> word = text.toLowerCase().split("");
    List<String> formatedWord = [];
    for (int i = 0; i < word.length; i++) {
      if (i == 0) {
        formatedWord.add(word[i].toUpperCase());
      } else {
        formatedWord.add(word[i]);
      }
    }
    return formatedWord.join();
  }
}
