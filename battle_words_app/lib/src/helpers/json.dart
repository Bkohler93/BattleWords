/// Flutter's jsonDecode requires double quotes ("") to be wrapped around the words in a json string. Go requires single quotes ('') to be wrapped around words in a slice. This method replaces single quotes from a Go json string with double quotes in order for jsonDecode() to function correctly.
String fixGoJson(String goStr) {
  return goStr.replaceAll("'", '"');
}
