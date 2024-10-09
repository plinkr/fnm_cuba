import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculadoraDosisScreen extends StatefulWidget {
  final String dosis;
  final String producto;
  final String presentacion;

  const CalculadoraDosisScreen({
    super.key,
    required this.dosis,
    required this.producto,
    required this.presentacion,
  });

  @override
  _CalculadoraDosisScreenState createState() => _CalculadoraDosisScreenState();
}

class _CalculadoraDosisScreenState extends State<CalculadoraDosisScreen> {
  late List<String> parametros;
  late List<Map<String, String>> formulas;
  late String dosisTotal;
  late Map<String, TextEditingController> controllers;
  String? errorMessage;
  String resultadoCalculo = '';
  double mgMl = 0.0;
  bool esSusp = false;
  Map<String, String?> fieldErrors = {};

  @override
  void initState() {
    super.initState();
    _parseDosis();
    controllers = {
      for (var param in parametros) param: TextEditingController()
    };
  }

  void _parseDosis() {
    final dosisLines = widget.dosis.split('\n');
    parametros = dosisLines
        .firstWhere((line) => line.startsWith('Param='), orElse: () => 'Param=')
        .substring(6)
        .split('~');

    formulas = dosisLines
        .firstWhere((line) => line.startsWith('Formulas='),
            orElse: () => 'Formulas=')
        .substring(9)
        .split('~')
        .map((formula) {
      final parts = formula.split('|');
      final subParts = parts[1].split('#');
      return {
        'name': parts[0],
        'unit': subParts[0],
        'formula': subParts[1],
      };
    }).toList();

    dosisTotal = dosisLines
        .firstWhere((line) => line.startsWith('DosisTotal='),
            orElse: () => 'DosisTotal=')
        .substring(11);

    String? mgMlValue = _getValueFromName('MgMl', widget.dosis, '=');
    if (mgMlValue != null && mgMlValue.isNotEmpty) {
      try {
        mgMl = double.parse(mgMlValue);
        esSusp = true;
      } catch (e) {
        esSusp = false;
      }
    } else {
      esSusp = false;
    }
  }

  void _calculateDosis() {
    setState(() {
      errorMessage = null;
      resultadoCalculo = '';
      fieldErrors.clear();
    });

    Map<String, double> values = {};
    try {
      for (var param in parametros) {
        final value = controllers[param]!.text;
        if (value.isEmpty) {
          fieldErrors[param] = 'Este campo es requerido';
          continue;
        }
        final doubleValue = double.tryParse(value);
        if (doubleValue == null || doubleValue < 0) {
          fieldErrors[param] = 'Ingrese un valor numérico válido';
          continue;
        }
        values[param] = doubleValue;
      }

      if (fieldErrors.isNotEmpty) {
        throw ('Por favor, complete todos los campos correctamente');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      return;
    }

    Map<String, double> results = {};
    try {
      for (var formula in formulas) {
        String formulaStr = formula['formula']!;
        for (var entry in values.entries) {
          formulaStr =
              formulaStr.replaceAll('[${entry.key}]', entry.value.toString());
        }
        // Eliminar corchetes de los valores numéricos en la fórmula
        formulaStr = formulaStr.replaceAllMapped(
            RegExp(r'\[(\d+(\.\d+)?)\]'), (match) => match.group(1)!);
        results[formula['name']!] = _evaluateExpression(formulaStr);
      }

      String result = dosisTotal;
      for (var entry in results.entries) {
        String name = entry.key;
        String unit = formulas.firstWhere((f) => f['name'] == name)['unit']!;
        double value = entry.value;

        if (esSusp) {
          double mlValue = value / mgMl;
          result = result.replaceAll(name,
              '${value.toStringAsFixed(1)} $unit (${mlValue.toStringAsFixed(2)} ml)');
        } else {
          result = result.replaceAll(name, '${value.toStringAsFixed(1)} $unit');
        }
      }

      setState(() {
        resultadoCalculo = result;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error en el cálculo: $e';
      });
    }
  }

  double _evaluateExpression(String expression) {
    try {
      // Evaluar la expresión con multiplicación y división
      final parts = expression.split(RegExp(r'(?<=\d)[*/](?=\d)'));
      double result = double.parse(parts[0]);

      for (int i = 1; i < parts.length; i++) {
        final operator = expression[expression.indexOf(parts[i]) - 1];
        final value = double.parse(parts[i]);

        if (operator == '*') {
          result *= value;
        } else if (operator == '/') {
          result /= value;
        }
      }

      return result;
    } catch (e) {
      throw FormatException('Error al evaluar la expresión: $e');
    }
  }

  String? _getValueFromName(String name, String dosis, String separator) {
    for (var line in dosis.split('\n')) {
      final parts = line.split(separator);
      if (parts[0] == name) {
        return parts[1];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Dosis: ${widget.producto}'),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...parametros.map((param) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextField(
                    controller: controllers[param],
                    decoration: InputDecoration(
                      labelText: param,
                      border: OutlineInputBorder(),
                      errorText: fieldErrors[param],
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                  ),
                )),
            ElevatedButton(
              onPressed: _calculateDosis,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
              ),
              child: Row(
                mainAxisSize: MainAxisSize
                    .min, // Para que el Row ocupe solo el espacio necesario
                mainAxisAlignment: MainAxisAlignment
                    .center, // Centra los elementos en el eje principal
                children: [
                  Icon(Icons.calculate), // Icono
                  SizedBox(width: 8), // Espacio entre el icono y el texto
                  Text('Calcular Dosis'),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            if (errorMessage == null) ...[
              Text(
                  'Importante: siempre analice la posología antes de utilizar una dosificación.',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
              SizedBox(height: 10),
              Text(
                'Presentación: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0), // Espacio desde la izquierda
                child: Text(widget.presentacion,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              Text(
                'Dosis indicada:${widget.dosis.split('\n').first.substring(6).replaceAll('<br>', '\n').replaceAll('-;', '\t\t')}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              if (resultadoCalculo.isNotEmpty)
                Text(
                  'Dosis calculada:${resultadoCalculo.replaceAll('<br>', '\n').replaceAll('-;', '\t\t')}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
