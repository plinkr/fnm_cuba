import 'package:flutter/material.dart';
import 'package:fnm_cuba/get_icon_for_presentation.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'web_database_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MedicamentoDetalleScreen extends StatefulWidget {
  final int id;
  final bool focusOnRiesgos; // Nuevo parámetro

  const MedicamentoDetalleScreen({
    super.key,
    required this.id,
    this.focusOnRiesgos = false, // Valor por defecto
  });

  @override
  _MedicamentoDetalleScreenState createState() =>
      _MedicamentoDetalleScreenState();
}

class _MedicamentoDetalleScreenState extends State<MedicamentoDetalleScreen> {
  final dbHelper = WebDatabaseHelper();
  Map<String, dynamic>? _medicamento;
  bool _isLoading = true;
  bool _isPrecaucionesExpanded = false;
  bool _isPoblacEspecExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadMedicamento();
  }

  Future<void> _loadMedicamento() async {
    final medicamento = await dbHelper.getByIdFromDatos(widget.id);
    setState(() {
      _medicamento = medicamento;
      _isLoading = false;

      // Si focusOnRiesgos es true, expandimos los elementos específicos
      if (widget.focusOnRiesgos) {
        _isPrecaucionesExpanded = true;
        _isPoblacEspecExpanded = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalles del Medicamento'),
          backgroundColor: Colors.blue[700],
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_medicamento == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalles del Medicamento'),
          backgroundColor: Colors.blue[700],
        ),
        body: Center(
          child: Text('No se encontró el medicamento.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_medicamento!['Producto']),
        backgroundColor: Colors.blue[700],
      ),
      body: Container(
        color: Colors.blue[50],
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GetIconForPresentation.getIcon(_medicamento!['Presentacion'],
                      size: 64),
                  SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _medicamento!['Producto'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _buildPresentacion(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blueGrey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (_medicamento!['Composicion']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Composición',
                  content: _medicamento!['Composicion'],
                ),
              if (_medicamento!['CategFarm']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Categoría Farmacológica',
                  content: _medicamento!['CategFarm'],
                ),
              if (_medicamento!['Farmacocinetica']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Farmacocinética',
                  content: _medicamento!['Farmacocinetica'],
                ),
              if (_medicamento!['Indicaciones']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Indicaciones',
                  content: _medicamento!['Indicaciones'],
                ),
              if (_medicamento!['Descripcion']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Descripción',
                  content: _medicamento!['Descripcion'],
                ),
              if (_medicamento!['Posologia']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Posología',
                  content: _medicamento!['Posologia'],
                ),
              if (_medicamento!['Contraindicaciones']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Contraindicaciones',
                  content: _medicamento!['Contraindicaciones'],
                ),
              if (_medicamento!['ReaccionesAdversas']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Reacciones Adversas',
                  content: _medicamento!['ReaccionesAdversas'],
                ),
              if (_medicamento!['TtoSobredosisEfectosAdv']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Tratamiento de Sobredosis / Efectos Adversos',
                  content: _medicamento!['TtoSobredosisEfectosAdv'],
                ),
              if (_medicamento!['Precauciones']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Precauciones',
                  content: _medicamento!['Precauciones'],
                  isExpanded: _isPrecaucionesExpanded,
                ),
              if (_medicamento!['Interacciones']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Interacciones',
                  content: _medicamento!['Interacciones'],
                ),
              if (_medicamento!['InfoPte']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Información Básica para el Paciente',
                  content: _medicamento!['InfoPte'],
                ),
              if (_medicamento!['PoblacEspec']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Uso en Población Especial',
                  content: _buildPoblacEspecContent(),
                  isExpanded: _isPoblacEspecExpanded,
                ),
              if (_medicamento!['VigilanciaInt']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Sujeto a Vigilancia Intensiva',
                  content: _medicamento!['VigilanciaInt'],
                ),
              if (_medicamento!['RegulacionPrescrip']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Regulación a la Prescripción',
                  content: _medicamento!['RegulacionPrescrip'],
                ),
              if (_medicamento!['NivelDistrib']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Nivel de Distribución',
                  content: _medicamento!['NivelDistrib'],
                ),
              if (_medicamento!['ClasifVEN']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Clasificación VEN',
                  content: _medicamento!['ClasifVEN'],
                ),
              if (_medicamento!['Laboratorio']?.isNotEmpty ?? false)
                _buildExpandableSection(
                  title: 'Laboratorio',
                  content: _medicamento!['Laboratorio'],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para generar la cadena de presentación sin coma innecesaria
  String _buildPresentacion() {
    final presentacion = _medicamento!['Presentacion'] ?? '';
    final presentacion1 = _medicamento!['Presentacion1'] ?? '';

    // Si 'Presentacion1' está vacío, solo devolvemos 'Presentacion'
    if (presentacion1.isEmpty) {
      return presentacion;
    }

    // Si ambos tienen valores, los concatenamos con coma
    return '$presentacion, $presentacion1';
  }

  Widget _buildExpandableSection(
      {required String title,
      required dynamic content,
      bool isExpanded = false}) {
    return ExpansionTile(
      initiallyExpanded: isExpanded,
      title: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blue[600], // Fondo azul
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black, // Color de texto
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: content is String
              ? Text(
                  content,
                  style: TextStyle(fontSize: 20),
                )
              : content,
        ),
      ],
    );
  }

  Widget _buildPoblacEspecContent() {
    final poblacEspec = _medicamento!['PoblacEspec'] ?? '';
    final parts = poblacEspec.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: parts.map<Widget>((part) {
        final icon = _getIconForPoblacEspec(part);
        return ListTile(
          leading: icon,
          title: Text(part),
        );
      }).toList(),
    );
  }

  Widget _getIconForPoblacEspec(String part) {
    String assetName = 'assets/info.svg.vec'; // Ícono por defecto

    if (part.startsWith('DH:')) {
      assetName = 'assets/liver.svg.vec';
    } else if (part.startsWith('DR:')) {
      assetName = 'assets/kidneys.svg.vec';
    } else if (part.startsWith('LM:')) {
      assetName = 'assets/lactation.svg.vec';
    } else if (part.startsWith('E:')) {
      assetName = 'assets/fetus.svg.vec';
    } else if (part.startsWith('AM:')) {
      assetName = 'assets/old_man.svg.vec';
    } else if (part.startsWith('Niños:')) {
      assetName = 'assets/child_program.svg.vec';
    }

    return SvgPicture(
      AssetBytesLoader(assetName),
      width: 90,
      height: 90,
      colorFilter: ColorFilter.mode(
          Colors.blueGrey[800] ?? Colors.black, BlendMode.srcIn),
    );
  }
}
