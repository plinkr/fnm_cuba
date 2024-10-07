import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fnm_cuba/medicamento_detalles.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'search_results_screen.dart';
import 'web_database_helper.dart';
import 'categoria_farmacologica.dart';
import 'presentaciones_medicamentos.dart';

class IndiceMedicamentos extends StatefulWidget {
  const IndiceMedicamentos({super.key});

  @override
  _IndiceMedicamentosState createState() => _IndiceMedicamentosState();
}

class _IndiceMedicamentosState extends State<IndiceMedicamentos> {
  String _sortOrder = 'ASC';
  String _sortIcon = 'assets/noun-sort-asc.svg.vec';

  void _toggleSortOrder() {
    setState(() {
      _sortOrder = _sortOrder == 'ASC' ? 'DESC' : 'ASC';
      _sortIcon = _sortOrder == 'ASC'
          ? 'assets/noun-sort-asc.svg.vec'
          : 'assets/noun-sort-desc.svg.vec';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: _toggleSortOrder,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SvgPicture(
                  AssetBytesLoader(_sortIcon),
                  width: 24.0,
                  height: 24.0,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Índice de Medicamentos',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        backgroundColor: Colors.blue[700],
      ),
      body: Container(
        color: Colors.blue[50], // Fondo azul claro
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButtonRow(context, 'assets/arrow-down-a-z-solid.svg.vec',
                    'Orden Alfabético'),
                const SizedBox(height: 16), // Espaciado vertical entre botones
                _buildButtonRow(context, 'assets/medicines.svg.vec',
                    'Categoría Farmacológica'),
                const SizedBox(height: 16), // Espaciado vertical entre botones
                _buildButtonRow(
                    context, 'assets/register_book.svg.vec', 'Presentación'),
                const SizedBox(height: 16), // Espaciado vertical entre botones
                _buildButtonRow(
                    context, 'assets/fetus.svg.vec', 'Riesgo en Embarazo'),
                const SizedBox(height: 16), // Espaciado vertical entre botones
                _buildButtonRow(
                    context, 'assets/lactation.svg.vec', 'Riesgo en Lactancia'),
                const SizedBox(height: 16), // Espaciado vertical entre botones
                _buildButtonRow(
                    context, 'assets/liver.svg.vec', 'Deficiencia Hepática'),
                const SizedBox(height: 16), // Espaciado vertical entre botones
                _buildButtonRow(
                    context, 'assets/kidneys.svg.vec', 'Deficiencia Renal'),
                const SizedBox(height: 16), // Espaciado vertical entre botones
                _buildButtonRow(context, 'assets/old_man.svg.vec',
                    'Riesgo en Adulto Mayor'),
                const SizedBox(height: 16), // Espaciado vertical entre botones
                _buildButtonRow(context, 'assets/child_program.svg.vec',
                    'Riesgo en el Niño'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow(
      BuildContext context, String svgAssetPath, String label) {
    return SizedBox(
      width:
          MediaQuery.of(context).size.width * 0.9, // 90% del ancho de la página
      child: ElevatedButton(
        onPressed: () {
          if (label == 'Orden Alfabético') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _buildSearchResultsScreen(
                    context, 'Orden Alfabético', label),
              ),
            );
          } else if (label == 'Categoría Farmacológica') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _buildCategoriaFarmacologica(
                    context, 'Categoría Farmacológica', label),
              ),
            );
          } else if (label == 'Presentación') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _buildPresentacionesMedicamentos(
                    context, 'Presentaciones de Medicamentos', label),
              ),
            );
          } else if (label == 'Riesgo en Embarazo') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    _buildRiesgos('E:', context, 'Riesgo en Embarazo', label),
              ),
            );
          } else if (label == 'Riesgo en Lactancia') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    _buildRiesgos('LM:', context, 'Riesgo en Lactancia', label),
              ),
            );
          } else if (label == 'Deficiencia Hepática') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _buildRiesgos(
                    'DH:', context, 'Deficiencia Hepática', label),
              ),
            );
          } else if (label == 'Deficiencia Renal') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    _buildRiesgos('DR:', context, 'Deficiencia Renal', label),
              ),
            );
          } else if (label == 'Riesgo en Adulto Mayor') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _buildRiesgos(
                    'AM:', context, 'Riesgo en Adulto Mayor', label),
              ),
            );
          } else if (label == 'Riesgo en el Niño') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _buildRiesgos(
                    'Niños:', context, 'Riesgo en el Niño', label),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[500], // Color de fondo del botón
          padding:
              const EdgeInsets.symmetric(vertical: 20.0), // Padding vertical
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0), // Espacio desde el borde izquierdo
              child: SvgPicture(
                AssetBytesLoader(svgAssetPath),
                width: 40.0, // Tamaño del icono SVG
                height: 40.0,
              ),
            ),
            const SizedBox(width: 16.0), // Espacio entre el icono y el texto
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0, // Tamaño de la fuente
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultsScreen(
      BuildContext context, String title, String label) {
    final dbHelper = WebDatabaseHelper();
    final List<Map<String, dynamic>> searchResults = [];
    int offset = 0; // Inicializar offset en 0
    final int limit = 400; // Número de resultados por página

    Future<void> loadMoreResults() async {
      final newResults = await dbHelper.getAllFromDataAlphaSorted(
        offset: offset, // Usar el offset actual
        limit: limit,
        sortOrder: _sortOrder,
      );

      setState(() {
        List<Map<String, dynamic>> updatedResults = List.from(searchResults)
          ..addAll(newResults);
        searchResults.clear();
        searchResults.addAll(updatedResults);
        offset +=
            limit; // Incrementar el offset después de cargar los resultados
      });
    }

    return SearchResultsScreen(
      searchResults: searchResults,
      loadMoreResults: loadMoreResults,
      title: title,
    );
  }

  Widget _buildCategoriaFarmacologica(
      BuildContext context, String title, String label) {
    final dbHelper = WebDatabaseHelper();

    Future<List<Map<String, dynamic>>> loadAllCategories() async {
      final allCategories =
          await dbHelper.getAllFromCategFarmAlphaSorted(sortOrder: _sortOrder);
      return allCategories;
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: loadAllCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No se encontraron Categorías.'));
        } else {
          final categories = snapshot.data!;
          return CategoriaFarmacologica(
            categories: categories,
            title: title,
          );
        }
      },
    );
  }

  Widget _buildPresentacionesMedicamentos(
      BuildContext context, String title, String label) {
    final dbHelper = WebDatabaseHelper();

    Future<List<Map<String, dynamic>>> loadAllPresentaciones() async {
      final allPresentaciones = await dbHelper
          .getPresentacionesFromDatosAlphaSorted(sortOrder: _sortOrder);
      return allPresentaciones;
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: loadAllPresentaciones(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No se encontraron Presentaciones.'));
        } else {
          final presentaciones = snapshot.data!;
          return PresentacionesMedicamentos(
            presentaciones: presentaciones,
            title: title,
          );
        }
      },
    );
  }

  Widget _buildRiesgos(
      String tipoRiesgos, BuildContext context, String title, String label) {
    final dbHelper = WebDatabaseHelper();
    Future<List<Map<String, dynamic>>> loadAllRiesgos() async {
      final allRiesgos = await dbHelper
          .getAllFromDataByRiesgosOPrecaucionesAlphaSorted(tipoRiesgos,
              sortOrder: _sortOrder);
      return allRiesgos;
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: loadAllRiesgos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No se encontraron Riesgos.'));
        } else {
          final riesgos = snapshot.data!;
          return SearchResultsScreen(
            searchResults: riesgos,
            loadMoreResults:
                () {}, // Estoy cargando todos los resultados de una vez
            title: title,
            showAppBar: true,
            onMedicamentoTap: (id) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicamentoDetalleScreen(
                    id: id,
                    focusOnRiesgos:
                        true, // Indicamos que se debe enfocar en los riesgos
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
