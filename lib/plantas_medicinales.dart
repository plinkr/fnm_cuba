import 'package:flutter/material.dart';

class PlantasMedicinales extends StatelessWidget {
  const PlantasMedicinales({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantas Medicinales'),
      ),
      body: Container(
        color: Colors.blue[50], // Fondo azul muy clarito
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Contenido de Plantas Medicinales',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
