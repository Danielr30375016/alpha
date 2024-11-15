import 'package:flutter/material.dart';

class Helper {
  static List<double> getWidthOfCard(BoxConstraints constraints) {
    int cardsWeb = 3;
    int cardsTablet = 2;
    int cardsMobile = 1;
    double spaceBetweenCards = 10;

    if (constraints.maxWidth > 1400) {
      return [(constraints.maxWidth / cardsWeb) - spaceBetweenCards, 420];
    } else if (constraints.maxWidth > 800) {
      return [(constraints.maxWidth / cardsTablet) - spaceBetweenCards, 370];
    } else {
      return [(constraints.maxWidth / cardsMobile) - spaceBetweenCards, 400];
    }
  }
}
