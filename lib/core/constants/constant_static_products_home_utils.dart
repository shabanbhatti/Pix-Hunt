import 'package:flutter/cupertino.dart';
import 'package:pix_hunt_project/l10n/app_localizations.dart';

abstract class ConstantStaticProductsHomeUtils {
  static List<({String title, String imgPath})> product1(BuildContext context) {
    var lng = AppLocalizations.of(context);
    return [
      (title: lng?.nature ?? '', imgPath: 'nature.jpg'),
      (title: lng?.flowers ?? '', imgPath: 'flowers.jpg'),
      (title: lng?.forests ?? '', imgPath: 'forests.jpg'),
      (title: lng?.oceans ?? '', imgPath: 'oceans.jpg'),
      (title: lng?.rivers ?? '', imgPath: 'rivers.jpg'),
    ];
  }

  static List<({String title, String imgPath})> product2(BuildContext context) {
    var lng = AppLocalizations.of(context);
    return [
      (title: lng?.mountains ?? '', imgPath: 'mountains.jpg'),
      (title: lng?.deserts ?? '', imgPath: 'desert.jpg'),
      (title: lng?.night ?? '', imgPath: 'moon.jpg'),
      (title: lng?.waterfall ?? '', imgPath: 'waterfall.jpg'),
    ];
  }

  static List<({String title, String imgPath})> product3(BuildContext context) {
    var lng = AppLocalizations.of(context);
    return [
      (title: lng?.universe ?? '', imgPath: 'universe.jpg'),
      (title: lng?.city ?? '', imgPath: 'city.jpg'),
      (title: lng?.village ?? '', imgPath: 'village.jpeg'),
      (title: lng?.wildlife ?? '', imgPath: 'wild_life.jpg'),
    ];
  }

  static List<({String title, String imgPath})> product4(BuildContext context) {
    var lng = AppLocalizations.of(context);
    return [
      (title: lng?.mosque ?? '', imgPath: 'mosque.jpg'),
      (title: lng?.synagogue ?? '', imgPath: 'synagogue.jpg'),
      (title: lng?.church ?? '', imgPath: 'church.jpg'),
    ];
  }

  static List<({String title, String imgPath})> product5(BuildContext context) {
    var lng = AppLocalizations.of(context);
    return [
      (title: lng?.mysticPlaces ?? '', imgPath: 'mystric.jpg'),
      (title: lng?.historicalPlaces ?? '', imgPath: 'historical.jpg'),
      (title: lng?.animals ?? '', imgPath: 'animals.jpg'),
    ];
  }

  static List<({String title, String imgPath})> product6(BuildContext context) {
    var lng = AppLocalizations.of(context);
    return [
      (title: lng?.village ?? '', imgPath: 'village.jpeg'),
      (title: lng?.motorcycles ?? '', imgPath: 'motorcycle.jpg'),
      (title: lng?.cars ?? '', imgPath: 'cars.jpg'),

      (title: lng?.animals ?? '', imgPath: 'animals.jpg'),
      (title: lng?.village ?? '', imgPath: 'village.jpeg'),
      (title: lng?.city ?? '', imgPath: 'city.jpg'),
    ];
  }
}
