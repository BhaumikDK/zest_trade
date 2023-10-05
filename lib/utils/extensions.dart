import 'dart:developer';

import 'package:flutter/material.dart';

extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return null;
  }

  toLog() {
    return log(this);
  }

  double parseDouble() {
    return double.parse(this);
  }
}

extension DoubleExtension on double {
  SizedBox get toVSB {
    return SizedBox(height: this);
  }

  SizedBox get toHSB {
    return SizedBox(width: this);
  }

  Radius get toRadius {
    return Radius.circular(this);
  }

  BorderRadius get toAllBorderRadius {
    return BorderRadius.all(toRadius);
  }
}

extension WidgetExtension on Widget {
  Widget get toExpanded {
    return Expanded(child: this);
  }

  Widget get toCenter {
    return Center(child: this);
  }

  Widget get toFlexible {
    return Flexible(child: this);
  }
}
