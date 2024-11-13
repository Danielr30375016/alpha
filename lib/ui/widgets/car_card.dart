import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart'; // Para usar kIsWeb

class CarCard extends StatelessWidget {
  final String? imageUrl;
  final String model;
  final String brand;
  final String mileage;
  final String price;
  final String engine;
  final bool isAdmin;
  final VoidCallback? onTapEdit;
  final VoidCallback? onTapDelete;
  final XFile? selectedImage; // Imagen seleccionada (si está presente)

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
    this.selectedImage, // Aceptamos la imagen local como parámetro opcional
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
                // Mostrar la imagen local si está disponible
                if (selectedImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: kIsWeb
                        ? _buildWebImage(selectedImage!)
                        : Image.file(
                            // Mostrar la imagen en dispositivos móviles
                            File(selectedImage!.path),
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            fit: BoxFit.cover,
                          ),
                  )
                else
                  // Si no hay imagen seleccionada, mostrar la imagen de la URL
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl ?? '',
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

  // Método para construir la imagen en la web utilizando Image.memory
  Widget _buildWebImage(XFile file) {
    return FutureBuilder<Uint8List>(
      future: file.readAsBytes(), // Usamos readAsBytes en la web
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildAdminButtons(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: Row(
        children: [
          InkWell(
            onTap: onTapEdit,
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
                onTapDelete?.call();
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
