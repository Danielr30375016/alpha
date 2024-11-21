import 'package:alpha/ui/appbar/app_bar_widget.dart';
import 'package:alpha/ui/widgets/footer.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            color: Colors.grey[800],
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: child,
            ))),
      ),
      bottomNavigationBar: ResponsiveFooter(),
    ));
  }
}
