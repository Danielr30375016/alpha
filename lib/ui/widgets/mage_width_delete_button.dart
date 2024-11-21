import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // Para usar kIsWeb

class ImageWithDeleteButton extends StatelessWidget {
  final XFile? selectedImage; // Imagen seleccionada (si está presente)
  final VoidCallback? onDelete; // Callback para eliminar la imagen

  const ImageWithDeleteButton({
    super.key,
    required this.selectedImage,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mostrar la imagen
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: kIsWeb
              ? _buildWebImage(selectedImage!) // Para la web
              : Image.file(
                  File(selectedImage!.path), // Para móviles
                  width: 150, // Ajusta el tamaño según lo necesites
                  height: 150,
                  fit: BoxFit.cover,
                ),
        ),
        // Botón de eliminación en la esquina superior derecha
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
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
}
