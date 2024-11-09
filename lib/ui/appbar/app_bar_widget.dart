import 'package:alpha/helper/assets_url.dart';
import 'package:flutter/material.dart';

class AutoShopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String) onLanguageChange;

  const AutoShopAppBar({super.key, required this.onLanguageChange});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Si el ancho es mayor a 600 (típico de tablet/web), mostramos una versión más amplia
        bool isWideScreen = constraints.maxWidth > 600;

        return AppBar(
          backgroundColor: Colors.black87,
          elevation: 4,
          title: Row(
            children: [
              if (!isWideScreen) ...[
                // Menú hamburguesa en pantallas pequeñas
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    // Abre el Drawer cuando se presiona el icono del menú hamburguesa
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ],
              Image.asset(
                AssetsUrl.logo,
                width: isWideScreen ? 120 : 80,
              ),
              const SizedBox(width: 8),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Acción de búsqueda
              },
            ),
            PopupMenuButton<String>(
              onSelected: onLanguageChange,
              icon: const Icon(Icons.language, color: Colors.white),
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'es',
                  child: Text('Español'),
                ),
                const PopupMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
