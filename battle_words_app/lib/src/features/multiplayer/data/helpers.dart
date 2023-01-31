Map<String, dynamic> filterOutPhase(Map<String, dynamic> oldMap) {
  Map<String, dynamic> newMap = {};

  oldMap.forEach((key, value) {
    if (key != 'phase' && value != 'null') {
      newMap[key] = value;
    }
  });

  return newMap;
}
