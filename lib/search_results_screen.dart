import 'package:flutter/material.dart';
import 'medicamento_detalles.dart';
import 'get_icon_for_presentation.dart';

class SearchResultsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> searchResults;
  final Function loadMoreResults;
  final String title;
  final bool showAppBar;
  final Function(int)? onMedicamentoTap;

  const SearchResultsScreen({
    super.key,
    required this.searchResults,
    required this.loadMoreResults,
    required this.title,
    this.showAppBar = true,
    this.onMedicamentoTap,
  });

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Solo cargamos los primeros resultados si no se viene de la pantalla de búsqueda
    if (widget.title != 'Resultados de la Búsqueda') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadMoreResults();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(widget.title),
              backgroundColor: Colors.blue[700],
            )
          : null,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              widget.searchResults.isNotEmpty) {
            _loadMoreResults();
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: widget.searchResults.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == widget.searchResults.length) {
              // Si llegamos al final de la lista y aún estamos cargando
              return Center(child: CircularProgressIndicator());
            }

            final item = widget.searchResults[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    if (widget.onMedicamentoTap != null) {
                      widget.onMedicamentoTap!(item['_id']);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MedicamentoDetalleScreen(id: item['_id']),
                        ),
                      );
                    }
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
                          GetIconForPresentation.getIcon(item['Presentacion'],
                              size: 64),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['Producto'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _buildPresentacion(item),
                                  style: TextStyle(
                                    fontSize: 14,
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
            );
          },
        ),
      ),
    );
  }

  String _buildPresentacion(Map<String, dynamic> item) {
    final presentacion = item['Presentacion'] ?? '';
    final presentacion1 = item['Presentacion1'] ?? '';
    return presentacion1.isEmpty
        ? presentacion
        : '$presentacion, $presentacion1';
  }

  void _loadMoreResults() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Llama al método de carga de más resultados
    await widget.loadMoreResults();

    setState(() {
      _isLoading = false;
    });
  }
}
