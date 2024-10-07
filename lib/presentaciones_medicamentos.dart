import 'package:flutter/material.dart';
import 'search_results_screen.dart';
import 'web_database_helper.dart';
import 'get_icon_for_presentation.dart';

class PresentacionesMedicamentos extends StatefulWidget {
  final List<Map<String, dynamic>> presentaciones;
  final String title;

  const PresentacionesMedicamentos({
    super.key,
    required this.presentaciones,
    required this.title,
  });

  @override
  _PresentacionesMedicamentosState createState() =>
      _PresentacionesMedicamentosState();
}

class _PresentacionesMedicamentosState
    extends State<PresentacionesMedicamentos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue[700],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: widget.presentaciones.length,
        itemBuilder: (context, index) {
          final item = widget.presentaciones[index];
          final presentacion = item['Presentacion'];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () async {
                  final dbHelper = WebDatabaseHelper();
                  final searchResults = await dbHelper
                      .getAllFromDataByPresentacionAlphaSorted(presentacion);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResultsScreen(
                        searchResults: searchResults,
                        loadMoreResults:
                            () {}, // Estoy cargando todos los resultados de una vez
                        title: 'Resultados para $presentacion',
                        showAppBar: true,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[400]!, Colors.blue[500]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.8, // 80% del ancho de la pantalla
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GetIconForPresentation.getIcon(presentacion,
                              size: 46),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  presentacion,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
