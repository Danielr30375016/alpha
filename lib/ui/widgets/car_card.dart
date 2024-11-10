import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
                CachedNetworkImage(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/alpha-ea10f.firebasestorage.app/o/car_images%2F1731261706628?alt=media&token=104d9233-97f0-4e70-9aae-c987f970ef35",
                  placeholder: (context, url) =>
                      CircularProgressIndicator(), // Muestra un cargador mientras se descarga la imagen
                  errorWidget: (context, url, error) => Icon(Icons
                      .error), // Muestra un ícono de error si no se puede cargar
                  fit: BoxFit.cover,
                ),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(10),
                //   child: Image.network(
                //     imageUrl,
                //     width: constraints.maxWidth,
                //     height: constraints.maxHeight,
                //     fit: BoxFit.cover,
                //     // fit: BoxFit.contain,
                //     loadingBuilder: (context, child, loadingProgress) {
                //       if (loadingProgress == null) return child;
                //       return const Center(child: CircularProgressIndicator());
                //     },
                //     errorBuilder: (context, error, stackTrace) => const Center(
                //       child: Icon(
                //         Icons.error,
                //         color: Colors.red,
                //       ),
                //     ),
                //   ),
                // ),
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
