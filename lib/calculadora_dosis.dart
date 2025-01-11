import 'dart:math';

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

  // Fórmulas de área de superficie corporal
  final Map<String, Map<String, dynamic>> formulasASC = {
    'Du Bois': {
      'formula': (double peso, double altura) =>
          0.007184 * pow(peso, 0.425) * pow(altura, 0.725),
      'description': '0.007184 × peso^0.425 × altura^0.725',
    },
    'Haycock': {
      'formula': (double peso, double altura) =>
          0.024265 * pow(peso, 0.5378) * pow(altura, 0.3964),
      'description': '0.024265 × peso^0.5378 × altura^0.3964',
    },
    'Mosteller': {
      'formula': (double peso, double altura) =>
          0.016667 * pow(peso, 0.5) * pow(altura, 0.5),
      'description': '0.016667 × peso^0.5 × altura^0.5',
    },
    'Gehan & George': {
      'formula': (double peso, double altura) =>
          0.0235 * pow(peso, 0.51456) * pow(altura, 0.42246),
      'description': '0.0235 × peso^0.51456 × altura^0.42246',
    },
    'Fujimoto': {
      'formula': (double peso, double altura) =>
          0.008883 * pow(peso, 0.444) * pow(altura, 0.663),
      'description': '0.008883 × peso^0.444 × altura^0.663',
    },
    'Takahira': {
      'formula': (double peso, double altura) =>
          0.007241 * pow(peso, 0.425) * pow(altura, 0.725),
      'description': '0.007241 × peso^0.425 × altura^0.725',
    },
    'Shuter & Aslani': {
      'formula': (double peso, double altura) =>
          0.00949 * pow(peso, 0.441) * pow(altura, 0.655),
      'description': '0.00949 × peso^0.441 × altura^0.655',
    },
    'Lipscombe': {
      'formula': (double peso, double altura) =>
          0.00878108 * pow(peso, 0.434972) * pow(altura, 0.67844),
      'description': '0.00878108 × peso^0.434972 × altura^0.67844',
    },
  };

  String? selectedFormula; // Fórmula seleccionada por el usuario

  @override
  void initState() {
    super.initState();
    _parseDosis();

    // Sustituir 'Metros cuadrados (m2)' por 'Altura (cm)' si está presente
    parametros = parametros.map((param) {
      return param == 'Metros cuadrados (m2)' ? 'Altura (cm)' : param;
    }).toList();

    controllers = {
      for (var param in parametros) param: TextEditingController()
    };
    // Seleccionar la primera fórmula por defecto
    selectedFormula = formulasASC.keys.first;
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

    // Calcular el área de superficie corporal (ASC) si se proporciona la altura
    if (parametros.contains('Altura (cm)')) {
      double peso = values['Peso (kg)']!;
      double altura = values['Altura (cm)']!;

      // Obtener la fórmula seleccionada
      final selectedEntry = formulasASC[selectedFormula];
      if (selectedEntry == null) {
        throw Exception('La fórmula seleccionada no existe.');
      }

      // Extraer la función de cálculo
      final formula =
          selectedEntry['formula'] as double Function(double, double);
      double asc = formula(peso, altura);

      values['Metros cuadrados (m2)'] = asc;
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
            // Mapear los parámetros para construir los campos de texto
            ...parametros.map((param) {
              if (param == 'Altura (cm)') {
                // Si el parámetro es 'Altura (cm)', mostrar un Row con el TextField y el DropdownButton
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(
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
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*')),
                          ],
                        ),
                      ),
                      SizedBox(
                          width:
                              16), // Espacio entre el TextField y el Dropdown
                      Tooltip(
                        message: 'Fórmula de área de superficie corporal',
                        child: DropdownButton<String>(
                          value: selectedFormula,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedFormula = newValue;
                            });
                          },
                          items: formulasASC.keys
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.help_outline, color: Colors.blue),
                        tooltip: 'Ayuda',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Ayuda'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Cómo se usa la fórmula seleccionada:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'La fórmula seleccionada calcula el área de superficie corporal usando el peso y la altura del paciente.\nSímbolos:\n×: multiplicar\n^: elevar a la potencia',
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Opciones disponibles:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      ...formulasASC.entries.map((entry) {
                                        final nombre = entry.key;
                                        final descripcion = entry
                                            .value['description'] as String;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child:
                                              Text('• $nombre: $descripcion'),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Cerrar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              } else {
                // Para otros parámetros, mostrar solo el TextField
                return Padding(
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
                );
              }
            }),
            // Botón para calcular la dosis
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
            // Mensaje de error (si existe)
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            // Si no hay errores, mostrar la información adicional
            if (errorMessage == null) ...[
              Text(
                'Importante: siempre analice la posología antes de utilizar una dosificación.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
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
