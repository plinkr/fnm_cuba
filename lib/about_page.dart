import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Acerca de'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'El Formulario Nacional de Medicamentos de Cuba, en Flutter.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'fnm_cuba es una interfaz de usuario para el Formulario Nacional de Medicamentos (FNM) de Cuba. Este proyecto tiene como objetivo proporcionar una herramienta accesible y fácil de usar desde la web.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'La aplicación permite a los usuarios consultar información sobre medicamentos de manera eficiente, utilizando la base de datos oficial del FNM en su última versión, tal como se proporciona en la aplicación oficial.',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'Los contenidos que se encuentran en el Formulario Nacional de Medicamentos están dirigidos fundamentalmente a profesionales de la salud. La información que suministramos no debe ser utilizada, bajo ninguna circunstancia, como base para la prescripción de tratamientos o medicamentos, sin previa orientación médica.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildLink('Código fuente: https://github.com/plinkr/fnm_cuba',
                'https://github.com/plinkr/fnm_cuba'),
            const SizedBox(height: 10),
            _buildLink('Perfil GitHub: https://github.com/plinkr',
                'https://github.com/plinkr'),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra la vista flotante
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }

  Widget _buildLink(String text, String urlString) {
    final Uri url = Uri.parse(urlString);
    return GestureDetector(
      onTap: () async {
        if (await canLaunchUrl(url)) {
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );
        } else {
          throw 'No se pudo abrir el enlace: $url';
        }
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
