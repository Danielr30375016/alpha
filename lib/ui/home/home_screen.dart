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

class CarCard extends StatelessWidget {
  final String imageUrl;
  final String model;
  final String brand;
  final String mileage;
  final String price;
  final String engine;

  const CarCard({
    super.key,
    required this.imageUrl,
    required this.model,
    required this.brand,
    required this.mileage,
    required this.price,
    required this.engine,
  });

  @override
  Widget build(BuildContext context) {
    List<IconData> icons = [
      Icons.directions_car,
      Icons.speed,
      Icons.build,
      Icons.attach_money,
    ];

    List<String> texts = [
      brand,
      mileage,
      engine,
      price,
    ];
    return LayoutBuilder(
      builder: (context, constraints) => Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        // margin: const EdgeInsets.all(8),
        child: LayoutBuilder(
          builder: (context, constraints) => SizedBox(
            width: constraints.maxWidth,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    fit: BoxFit.cover,
                    // fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: constraints.maxWidth,
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(10)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter, // Inicia en la parte superior
                      end: Alignment
                          .bottomCenter, // Termina en la parte inferior
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: constraints.maxWidth,
                        child: LayoutBuilder(
                          builder: (context, constraints) => SizedBox(
                            width: constraints.maxWidth,
                            child: Column(
                              children: [
                                _buildInfoRow(
                                    icons[0], texts[0], icons[1], texts[1]),
                                _buildInfoRow(
                                    icons[2], texts[2], icons[3], texts[3]),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData firstIcon, String firstText,
      IconData secondIcon, String secondText) {
    return Row(
      children: [
        Icon(firstIcon, color: Colors.grey[300], size: 16),
        const SizedBox(width: 4),
        Text(
          firstText,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
        Expanded(
          child: Container(),
        ),
        Icon(secondIcon, color: Colors.grey[300], size: 16),
        const SizedBox(width: 4),
        Text(
          secondText,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
