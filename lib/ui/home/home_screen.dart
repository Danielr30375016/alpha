import 'package:alpha/ui/widgets/car_card.dart';
import 'package:alpha/ui/widgets/template.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double width = 0;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Template(child: body());
  }

  Widget body() {
    int crossAxisCount = width > 1600
        ? 3
        : width > 1400
            ? 3
            : width > 800
                ? 2
                : 1;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 2,
        children: List.generate(20, (index) {
          return CarCard(
            imageUrl:
                'https://images.pexels.com/photos/244206/pexels-photo-244206.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            model: 'Modelo ${index + 1}',
            brand: 'Marca ${index + 1}',
            mileage: '${(index + 1) * 10000} km',
            price: '${(index + 1) * 50000}',
            engine: '${(index + 1) * 1.5}L',
          );
        }),
      ),
    );
  }
}
