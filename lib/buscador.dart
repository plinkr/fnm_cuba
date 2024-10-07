import 'package:flutter/material.dart';
import 'web_database_helper.dart';
import 'search_results_screen.dart';

class RealTimeSearchScreen extends StatefulWidget {
  const RealTimeSearchScreen({super.key});

  @override
  RealTimeSearchScreenState createState() => RealTimeSearchScreenState();
}

class RealTimeSearchScreenState extends State<RealTimeSearchScreen> {
  final dbHelper = WebDatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  int _offset = 0;
  final int _limit = 100; // Número de resultados por página
  bool _hasMoreResults = true; // Bandera para verificar si hay más resultados

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onSearchChanged() async {
    final query = _searchController.text;

    // Verifica si la longitud del texto es al menos 2 caracteres
    if (query.length < 2) {
      setState(() {
        _searchResults = [];
        _offset = 0;
        _hasMoreResults = true;
        _isLoading =
            false; // Aseguramos que no se muestre el indicador de carga
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _offset = 0; // Reiniciamos el offset cuando cambie la búsqueda
      _hasMoreResults =
          true; // Restablecemos la bandera al iniciar nueva búsqueda
    });

    final results = await dbHelper.searchMedicineByProductoOrCategoria(
        query, _offset, _limit);

    setState(() {
      _searchResults = results;
      _isLoading = false;
      _hasMoreResults =
          results.length == _limit; // Verifica si hay más resultados
    });
  }

  void _loadMoreResults() async {
    if (_isLoading || !_hasMoreResults) {
      return; // Evita múltiples llamadas si ya está cargando o no hay más resultados
    }

    setState(() {
      _isLoading = true;
    });

    final query = _searchController.text;
    final newResults = await dbHelper.searchMedicineByProductoOrCategoria(
        query, _offset + _limit, _limit);

    setState(() {
      // Aseguramos que la lista temporal tenga el tipo correcto
      List<Map<String, dynamic>> updatedResults = List.from(_searchResults)
        ..addAll(newResults);
      _searchResults = updatedResults;

      _offset += _limit; // Aumentamos el offset para la próxima búsqueda
      _isLoading = false;

      // Si el número de nuevos resultados es menor que el límite, ya no hay más resultados
      _hasMoreResults = newResults.length == _limit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Medicamentos'),
        backgroundColor: Colors.blue[700],
      ),
      body: Container(
        color: Colors.blue[50], // Fondo azul claro
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar Medicamento, por nombre o categoría',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading && _searchResults.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (_searchResults.isEmpty &&
                _searchController.text.isNotEmpty)
              const Center(child: Text('No se encontraron resultados'))
            else
              Expanded(
                child: SearchResultsScreen(
                  searchResults: _searchResults,
                  loadMoreResults: _loadMoreResults,
                  title: 'Resultados de la Búsqueda', // Título dinámico
                  showAppBar: false, // No mostrar la barra de aplicaciones
                ),
              ),
          ],
        ),
      ),
    );
  }
}
