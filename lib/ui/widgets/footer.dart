import 'package:alpha/helper/assets_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class ResponsiveFooter extends StatelessWidget {
  const ResponsiveFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 900;
        return Column(
          children: [
            SizedBox(
              width: constraints.maxWidth,
              child: Flex(
                direction: isWeb ? Axis.horizontal : Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: isWeb
                        ? constraints.maxWidth * 0.5
                        : constraints.maxWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: LayoutBuilder(
                      builder: (context, constraints) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Nos ubicamos en: ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    launchURL(
                                        "https://www.google.com/maps?q=Ubicación+Ejemplo");
                                  },
                                  child: const Text(
                                      "Calle Ejemplo #123, Ciudad, País",
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 16),
                                      textAlign: TextAlign.center))
                            ],
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: constraints.maxWidth * 0.9,
                              height: 250,
                              child: FlutterMap(
                                options: const MapOptions(
                                    initialCenter: LatLng(
                                        4.7110, -74.0721), // Bogotá, Colombia
                                    initialZoom: 13.0),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  ),
                                  const MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: LatLng(4.7110,
                                            -74.0721), // Bogotá, Colombia
                                        width: 80.0,
                                        height: 80.0,
                                        child: Icon(
                                          Icons.location_pin,
                                          size: 40,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Redes sociales
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: isWeb
                        ? constraints.maxWidth * 0.5
                        : constraints.maxWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Síguenos en nuestras redes sociales",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: isWeb ? 30 : 10),
                        _socialIcon("https://facebook.com", AssetsUrl.facebook,
                            "@pepitoperez123"),
                        const SizedBox(height: 15),
                        _socialIcon("https://instagram.com",
                            AssetsUrl.instagram, "@pepitoperez123"),
                        const SizedBox(height: 15),
                        _socialIcon("https://twitter.com", AssetsUrl.twitter,
                            "@pepitoperez123"),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Derechos reservados
            const Text(
              "© 2024 Todos los derechos reservados.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            )
          ],
        );
      }),
    );
  }

  Widget _socialIcon(String url, String? imageUrl, String text) {
    return InkWell(
      onTap: () => launchURL(url),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageUrl!,
            fit: BoxFit.contain,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 7),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 16))
        ],
      ),
    );
  }

  void launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'No se pudo abrir $url';
    }
  }
}
