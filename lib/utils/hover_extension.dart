import 'package:flutter/material.dart';

extension HoverExtensions on Widget {
  Widget get showCursorOnHover {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: this,
    );
  }

  Widget get showDragCursorOnHover {
    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: this,
    );
  }
}
