import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CarCard extends StatelessWidget {
  final String imageUrl;
  final String model;
  final String brand;
  final String mileage;
  final String price;
  final String engine;
  final bool isAdmin;
  final VoidCallback? onTapEdit;
  final VoidCallback? onTapDelete;

  const CarCard({
    super.key,
    required this.imageUrl,
    required this.model,
    required this.brand,
    required this.mileage,
    required this.price,
    required this.engine,
    required this.isAdmin,
    this.onTapEdit,
    this.onTapDelete,
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
        child: LayoutBuilder(
          builder: (context, constraints) => SizedBox(
            width: constraints.maxWidth,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: constraints.maxWidth,
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(10)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
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
                        child: Column(
                          children: [
                            _buildInfoRow(
                                icons[0], texts[0], icons[1], texts[1]),
                            _buildInfoRow(
                                icons[2], texts[2], icons[3], texts[3]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isAdmin) _buildAdminButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminButtons(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (onTapEdit == null) return;
              onTapEdit!();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Botón de eliminar con fondo y sombra
          InkWell(
            onTap: () {
              _showDeleteConfirmationDialog(context);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Icon(
                Icons.clear_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Función para construir las filas de información
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
        Expanded(child: Container()),
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

  // Función para mostrar el dialogo de confirmación de eliminación
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este vehículo?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (onTapDelete == null) return;
                onTapDelete!();
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
