// https://stackoverflow.com/questions/68576018/how-to-get-file-name-from-the-url-of-the-file-present-in-firebase-storage-in-flu

String getFileName(String url) {
  RegExp regExp = new RegExp(r'.+(\/|%2F)(.+)\?.+');
  //This Regex won't work if you remove ?alt...token
  var matches = regExp.allMatches(url);

  var match = matches.elementAt(0);
  print("${Uri.decodeFull(match.group(2)!)}");
  return Uri.decodeFull(match.group(2)!);
}
