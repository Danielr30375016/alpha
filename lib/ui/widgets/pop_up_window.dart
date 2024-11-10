import 'package:flutter/material.dart';

class PopUpWindow {
  static OverlayEntry? _overlayEntry;

  // Método estático para mostrar el mensaje de error
  static void showError(BuildContext context, String message) {
    final overlay = Overlay.of(context);

    _overlayEntry?.remove();

    _overlayEntry = _createOverlayEntry(message);
    overlay.insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 3), () {
      _overlayEntry?.remove();
    });
  }

  // Método para crear el OverlayEntry que muestra el mensaje
  static OverlayEntry _createOverlayEntry(String message) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
