import 'package:flutter/material.dart';

extension AppSpacer on num {
  SizedBox get hSpacer => SizedBox(width: toDouble());
  SizedBox get vSpacer => SizedBox(height: toDouble());
}

extension AppWidgets on BuildContext {
  double get mqWidth => MediaQuery.sizeOf(this).width;
  double get mqHeight => MediaQuery.sizeOf(this).height;

  Future<T?> navigate<T>(Widget page) {
    FocusManager.instance.primaryFocus!.unfocus();
    return Navigator.push<T>(this, slideLeft(page));
  }

  void navigateBack<T>({dynamic value}) {
    FocusManager.instance.primaryFocus!.unfocus();
    return Navigator.pop<T>(this, value);
  }

  Future<T?> navigateRemoveAll<T>(Widget page) {
    FocusManager.instance.primaryFocus!.unfocus();
    return Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }
}

slideLeft(Widget nextScreen) {
  return PageRouteBuilder(
    pageBuilder: ((context, animation, secondaryAnimation) => nextScreen),
    transitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
