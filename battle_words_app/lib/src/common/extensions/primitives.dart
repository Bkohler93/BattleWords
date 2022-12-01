extension RangeNum on num {
  bool isBetweenInclusive(num from, num to) {
    return from <= this && this <= to;
  }
}

extension RangeInt on int {
  bool isBetweenInclusive(int from, int to) {
    return from <= this && this <= to;
  }
}
