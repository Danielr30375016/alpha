import 'package:alpha/ui/appbar/app_bar_widget.dart';
import 'package:flutter/material.dart';

class Template extends StatelessWidget {
  final Widget child;
  const Template({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AutoShopAppBar(onLanguageChange: (value) {}),
            body: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                color: Colors.grey[800],
                child: child)));
  }
}
