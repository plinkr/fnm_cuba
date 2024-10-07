import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'search_results_screen.dart';
import 'web_database_helper.dart';

class CategoriaFarmacologica extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final String title;

  const CategoriaFarmacologica({
    super.key,
    required this.categories,
    required this.title,
  });

  @override
  _CategoriaFarmacologicaState createState() => _CategoriaFarmacologicaState();
}

class _CategoriaFarmacologicaState extends State<CategoriaFarmacologica> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue[700],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          // Construir el header y subheader de la categoría, dividiendo por `--`
          final item = widget.categories[index];
          final categFarm = item['CategFarm'];
          final parts = categFarm.split(' -- ');
          final header = parts.isNotEmpty ? parts.removeAt(0) : '';
          final subheader = parts.join(' -- ');

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
                      .getAllFromDataByCategFarmAlphaSorted(categFarm);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResultsScreen(
                        searchResults: searchResults,
                        loadMoreResults:
                            () {}, // Estoy cargando todos los resultados de una vez
                        title: 'Resultados para $categFarm',
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
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture(
                          const AssetBytesLoader('assets/medicines.svg.vec'),
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                header,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              if (subheader.isNotEmpty)
                                Text(
                                  subheader,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[800],
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
          );
        },
      ),
    );
  }
}
