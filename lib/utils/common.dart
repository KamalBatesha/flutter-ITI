

import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  double heigth;
  double width;

  Gap([this.heigth = 0, this.width = 0]);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: heigth, width: width);
  }
}
