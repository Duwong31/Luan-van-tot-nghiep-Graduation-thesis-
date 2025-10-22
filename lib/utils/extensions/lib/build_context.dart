import 'package:Celes/ui/theme/theme.dart';
import 'package:flutter/material.dart';

extension CustomContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  //This one for colorScheme shortcut
  ColorScheme get color => Theme.of(this).colorScheme;

//This one for fontSize
  Font get font => Theme.of(this).textTheme.font;
}
