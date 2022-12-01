import 'dart:math';

import 'package:battle_words/src/common/extensions/primitives.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RangeNum extension on num primitive', () {
    final num testNum = 3;
    test("Extension RangeNum's 3.isBetweenInclusive(2, 5) returns true", () {
      final matchBool = true;
      final actualBool = testNum.isBetweenInclusive(2, 5);

      expect(actualBool, matchBool);
    });

    test("Extension RangeNum's 3.isBetweenInclusive(3,3) returns true", () {
      final matchBool = true;
      final actualBool = testNum.isBetweenInclusive(3, 3);

      expect(actualBool, matchBool);
    });

    test("Extension RangeNum's 3.isBetweenInclusive(4, 6) returns false", () {
      final matchBool = false;
      final actualBool = testNum.isBetweenInclusive(4, 6);

      expect(actualBool, matchBool);
    });

    group("RangeInt extension on int primitive", () {
      final testInt = 3;

      test("RangeInt's 3.isBetweenInclusive(2, 3) returns true", () {
        final matchBool = true;
        final actualBool = testInt.isBetweenInclusive(2, 3);

        expect(actualBool, matchBool);
      });

      test("RangeInt's 3.isBetweenInclusive(3, 5) returns true", () {
        final matchBool = true;
        final actualBool = testInt.isBetweenInclusive(3, 5);

        expect(actualBool, matchBool);
      });

      test("RangeInt's 3.isBetweenInclusive(5, 7) returns false", () {
        final matchBool = false;
        final actualBool = testInt.isBetweenInclusive(5, 7);

        expect(actualBool, matchBool);
      });

      test("RangeInt's 3.isBetweenInclusive(1,2) returns false", () {
        final matchBool = false;
        final actualBool = testInt.isBetweenInclusive(1, 2);

        expect(actualBool, matchBool);
      });
    });
  });
}
