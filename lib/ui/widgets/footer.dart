import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResponsiveFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      color: Colors.black,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dirección y ubicación en el mapa
          Text(
            "Nuestra ubicación:",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              // Abre Google Maps en el navegador o app
              launchURL("https://www.google.com/maps?q=Ubicación+Ejemplo");
            },
            child: Text(
              "Calle Ejemplo #123, Ciudad, País",
              style: TextStyle(color: Colors.blue, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          // Redes sociales
          Text(
            "Síguenos en nuestras redes sociales:",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(Icons.facebook, "https://facebook.com"),
              SizedBox(width: 16),
              _socialIcon(Icons.install_desktop, "https://instagram.com"),
              SizedBox(width: 16),
              _socialIcon(Icons.wb_twilight_sharp, "https://twitter.com"),
            ],
          ),
          SizedBox(height: 16),
          // Derechos reservados
          Text(
            "© 2024 Todos los derechos reservados.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon, String url) {
    return GestureDetector(
      onTap: () => launchURL(url),
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }

  void launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir $url';
    }
  }
}
