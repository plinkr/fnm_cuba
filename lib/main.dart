import 'package:flutter/material.dart';
import 'package:fnm_cuba/about_page.dart';
import 'web_database_helper.dart';
import 'buscador.dart';
import 'indice_medicamentos.dart';
// import 'plantas_medicinales.dart';

void main() {
  runApp(FormularioNacionalApp());
}

class FormularioNacionalApp extends StatefulWidget {
  const FormularioNacionalApp({super.key});

  @override
  _FormularioNacionalAppState createState() => _FormularioNacionalAppState();
}

class _FormularioNacionalAppState extends State<FormularioNacionalApp> {
  // Agrega un Future para la inicialización de la base de datos
  late Future<void> _initDbFuture;

  @override
  void initState() {
    super.initState();
    // Inicializa la base de datos solo la primera vez
    _initDbFuture = _initDatabase();
  }

  Future<void> _initDatabase() async {
    // Inicializa la base de datos desde WebDatabaseHelper
    await WebDatabaseHelper().database;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initDbFuture, // Espera a que la BD se inicialice
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
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
                    borderRadius:
                        BorderRadius.circular(12.0), // Botones redondeados
                  ),
                  elevation: 8.0, // Sombra
                  padding: EdgeInsets.all(20.0), // Espaciado interno
                ),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor:
                    Colors.blue[700], // Color del FloatingActionButton
              ),
            ),
            home: FormularioNacionalPage(),
          );
        } else {
          // Muestra un indicador de carga mientras se inicializa la BD
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(), // Indicador de carga
              ),
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
