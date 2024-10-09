import 'package:flutter/material.dart';
import 'package:fnm_cuba/about_page.dart';
import 'web_database_helper.dart';
import 'buscador.dart';
import 'indice_medicamentos.dart';
// import 'plantas_medicinales.dart';

// Inicializa la app inmediatamente
void main() {
  runApp(FormularioNacionalApp());
}

class FormularioNacionalApp extends StatelessWidget {
  const FormularioNacionalApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Muestra la app inmediatamente con un indicador de carga
    return MaterialApp(
      title: 'Formulario Nacional de Medicamentos de Cuba',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50], // Fondo azul claro
        appBarTheme: AppBarTheme(
          color: Colors.blue[700], // Color de la AppBar
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[500], // Color de fondo del botón
            foregroundColor: Colors.black, // Color del texto del botón
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Botones redondeados
            ),
            elevation: 8.0, // Sombra
            padding: EdgeInsets.all(20.0), // Espaciado interno
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue[700], // Color del FloatingActionButton
        ),
      ),
      home: InitializationWrapper(),
    );
  }
}

// Widget para manejar la inicialización
class InitializationWrapper extends StatefulWidget {
  const InitializationWrapper({super.key});

  @override
  _InitializationWrapperState createState() => _InitializationWrapperState();
}

class _InitializationWrapperState extends State<InitializationWrapper> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    // Inicia la inicialización de manera asíncrona
    _initFuture = _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Inicializa la base de datos
    await WebDatabaseHelper().database;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return FormularioNacionalPage(); // Página principal
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // Indicador de carga
            ),
          );
        }
      },
    );
  }
}

class FormularioNacionalPage extends StatelessWidget {
  const FormularioNacionalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: MediaQuery.of(context).size.width *
              0.9, // 90% del ancho de la ventana
          child: const Text(
            'Formulario Nacional de Medicamentos de Cuba',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.9, // 90% del ancho de la ventana
              height: 100, // Altura fija para botones cuadrados
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IndiceMedicamentos()),
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.list,
                      size: 32, //Tamaño del icono
                    ),
                    const SizedBox(
                        width: 16.0), // Espacio entre el icono y el texto
                    const Expanded(
                      child: Text(
                        'Índice de Medicamentos',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ), // Tamaño de texto
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Las plantas medicinales no están implementadas todavía
            // SizedBox(
            //   width: MediaQuery.of(context).size.width *
            //       0.9, // 90% del ancho de la ventana
            //   height: 100, // Altura fija para botones cuadrados
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => PlantasMedicinales()),
            //       );
            //     },
            //     child: Row(
            //       children: [
            //         const Icon(
            //           Icons.spa,
            //           size: 32, // Tamaño del icono
            //         ),
            //         const SizedBox(
            //             width: 16.0), // Espacio entre el icono y el texto
            //         const Expanded(
            //           child: Text(
            //             'Plantas Medicinales',
            //             style: TextStyle(
            //               fontSize: 22,
            //               fontWeight: FontWeight.bold,
            //             ), // Tamaño de texto
            //             textAlign: TextAlign.center,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.9, // 90% del ancho de la ventana
              height: 100, // Altura fija para botones cuadrados
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RealTimeSearchScreen()),
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 32, // Tamaño del icono
                    ),
                    const SizedBox(
                        width: 16.0), // Espacio entre el icono y el texto
                    const Expanded(
                      child: Text(
                        'Buscar Medicamentos',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ), // Tamaño de texto
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AboutPage(),
          );
        },
        child: const Icon(Icons.settings),
      ),
    );
  }
}
