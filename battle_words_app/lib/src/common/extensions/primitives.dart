extension RangeNum on num {
  bool isBetweenInclusive(num from, num to) {
    return from <= this && this <= to;
  }
}

extension RangeInt on int {
  bool isBetweenInclusive(num from, num to) {
    return from <= this && this <= to;
  }
}
