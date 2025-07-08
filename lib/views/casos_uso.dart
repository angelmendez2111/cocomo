// use_case_points_view.dart

import 'package:flutter/material.dart';
import 'package:cocomo_software/casos_uso_calculator.dart'; // Asegúrate que el import es correcto

// Variable global para notificar a la pestaña de estimación
ValueNotifier<UCPEstimacionResultado?> estimacionUCP = ValueNotifier(null);
double pcusaGlobal = 0.0;

class UseCasePointsView extends StatelessWidget {
  const UseCasePointsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regresar al menú principal'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        toolbarHeight: 60,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Estimación por Puntos de Caso de Uso (UCP)',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Calcula el esfuerzo del proyecto basado en el método UCP de Karner.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Builder(
                  builder: (context) {
                    final tabController = TabController(
                      length: 3,
                      vsync: Scaffold.of(context),
                    );
                    final calculator = UseCasePointsCalculator();
                    return Expanded(
                      child: Column(
                        children: [
                          TabBar(
                            controller: tabController,
                            labelColor: Colors.black,
                            labelStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            unselectedLabelStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                            indicatorWeight: 4,
                            tabs: const [
                              Tab(text: 'Conteo de Actores y Casos'),
                              Tab(text: 'Factores de Complejidad'),
                              Tab(text: 'Estimación'),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Expanded(
                            child: TabBarView(
                              controller: tabController,
                              children: [
                                _ConteoTab(calculator: calculator),
                                _FactoresTab(calculator: calculator),
                                _EstimacionUCPTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =======================================================
// PESTAÑA 1: CONTEO
// =======================================================
class _ConteoTab extends StatefulWidget {
  final UseCasePointsCalculator calculator;
  const _ConteoTab({required this.calculator});
  @override
  _ConteoTabState createState() => _ConteoTabState();
}

class _ConteoTabState extends State<_ConteoTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // <-- MANTIENE EL ESTADO

  final _actoresSimples = TextEditingController(text: '0');
  final _actoresMedios = TextEditingController(text: '0');
  final _actoresComplejos = TextEditingController(text: '0');
  final _casosSimples = TextEditingController(text: '0');
  final _casosMedios = TextEditingController(text: '0');
  final _casosComplejos = TextEditingController(text: '0');

  double _totalPA = 0;
  double _totalPCU = 0;
  double _totalPCUSA = 0;

  @override
  void initState() {
    super.initState();
    [
      _actoresSimples,
      _actoresMedios,
      _actoresComplejos,
      _casosSimples,
      _casosMedios,
      _casosComplejos,
    ].forEach((controller) => controller.addListener(_recalcular));
    _recalcular();
  }

  void _recalcular() {
    setState(() {
      _totalPA = widget.calculator.calcularPA(
        cantSimples: int.tryParse(_actoresSimples.text) ?? 0,
        cantMedios: int.tryParse(_actoresMedios.text) ?? 0,
        cantComplejos: int.tryParse(_actoresComplejos.text) ?? 0,
      );
      _totalPCU = widget.calculator.calcularPCU(
        cantSimples: int.tryParse(_casosSimples.text) ?? 0,
        cantMedios: int.tryParse(_casosMedios.text) ?? 0,
        cantComplejos: int.tryParse(_casosComplejos.text) ?? 0,
      );
      _totalPCUSA = _totalPA + _totalPCU;
      pcusaGlobal = _totalPCUSA;
    });
  }

  @override
  void dispose() {
    // Limpiar controladores
    [
      _actoresSimples,
      _actoresMedios,
      _actoresComplejos,
      _casosSimples,
      _casosMedios,
      _casosComplejos,
    ].forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // El build de la interfaz no cambia
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Columna Izquierda
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildCard(
                  title: '1. Peso de Actores (PA)',
                  child: Column(
                    children: [
                      _InputRowConteo(
                        label: 'Simple (API)',
                        peso: pesosActores['Simple']!,
                        controller: _actoresSimples,
                      ),
                      _InputRowConteo(
                        label: 'Medio (Texto)',
                        peso: pesosActores['Medio']!,
                        controller: _actoresMedios,
                      ),
                      _InputRowConteo(
                        label: 'Complejo (GUI)',
                        peso: pesosActores['Complejo']!,
                        controller: _actoresComplejos,
                      ),
                      const Divider(),
                      _ResultRow(
                        label: 'Total PA:',
                        value: _totalPA.toStringAsFixed(0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildCard(
                  title: '3. Puntos de Caso de Uso sin Ajustar (PCUSA)',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PCUSA = PA + PCU',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        'PCUSA = ${_totalPA.toStringAsFixed(0)} + ${_totalPCU.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: _ResultRow(
                          label: 'Total PCUSA:',
                          value: _totalPCUSA.toStringAsFixed(0),
                          isLarge: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Columna Derecha
          Expanded(
            flex: 1,
            child: _buildCard(
              title: '2. Peso de Casos de Uso (PCU)',
              child: Column(
                children: [
                  _InputRowConteo(
                    label: 'Simple (<=3 trans.)',
                    peso: pesosCasosDeUso['Simple']!,
                    controller: _casosSimples,
                  ),
                  _InputRowConteo(
                    label: 'Medio (4-7 trans.)',
                    peso: pesosCasosDeUso['Medio']!,
                    controller: _casosMedios,
                  ),
                  _InputRowConteo(
                    label: 'Complejo (>7 trans.)',
                    peso: pesosCasosDeUso['Complejo']!,
                    controller: _casosComplejos,
                  ),
                  const Divider(),
                  _ResultRow(
                    label: 'Total PCU:',
                    value: _totalPCU.toStringAsFixed(0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================================
// PESTAÑA 2: FACTORES (CON LAYOUT VERTICAL)
// =======================================================
class _FactoresTab extends StatefulWidget {
  final UseCasePointsCalculator calculator;
  const _FactoresTab({required this.calculator});
  @override
  _FactoresTabState createState() => _FactoresTabState();
}

class _FactoresTabState extends State<_FactoresTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late List<int> _valoresTecnicos;
  late List<int> _valoresAmbientales;
  double _fct = 0, _fa = 0, _sumaValorFCT = 0, _sumaValorFA = 0;

  @override
  void initState() {
    super.initState();
    _valoresTecnicos = List.generate(factoresTecnicosData.length, (_) => 0);
    _valoresAmbientales = List.generate(
      factoresAmbientalesData.length,
      (_) => 0,
    );
    _recalcularFactores();
  }

  void _recalcularFactores() {
    setState(() {
      _fct = widget.calculator.calcularFCT(_valoresTecnicos);
      _fa = widget.calculator.calcularFA(_valoresAmbientales);

      _sumaValorFCT = 0;
      for (int i = 0; i < factoresTecnicosData.length; i++) {
        _sumaValorFCT += factoresTecnicosData[i]['peso'] * _valoresTecnicos[i];
      }
      _sumaValorFA = 0;
      for (int i = 0; i < factoresAmbientalesData.length; i++) {
        _sumaValorFA +=
            factoresAmbientalesData[i]['peso'] * _valoresAmbientales[i];
      }
    });
  }

  void _calcularFinal() {
    final pcusa = pcusaGlobal; 
    final pcua = pcusa * _fct * _fa;
    final esfuerzo = widget.calculator.calcularEsfuerzo(
      pcua,
      _valoresAmbientales,
    );
    final factoresXY = widget.calculator.getFactoresXY(_valoresAmbientales);

    estimacionUCP.value = UCPEstimacionResultado(
      pcusa: pcusa,
      fct: _fct,
      fa: _fa,
      pcua: pcua,
      esfuerzo: esfuerzo,
      x: factoresXY['x']!,
      y: factoresXY['y']!,
      tasa: factoresXY['tasa']!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Estimación calculada y actualizada.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Columna Izquierda: FCT ---
              Expanded(
                flex: 6,
                child: _buildCard(
                  title: '4. Factor de Complejidad Técnica (FCT)',
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: List.generate(7, (i) {
                                return _FactorItem(
                                  factor: factoresTecnicosData[i],
                                  valor: _valoresTecnicos[i],
                                  onChanged: (v) {
                                    setState(() {
                                      _valoresTecnicos[i] = v;
                                      _recalcularFactores();
                                    });
                                  },
                                );
                              }),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              children: List.generate(6, (i) {
                                return _FactorItem(
                                  factor: factoresTecnicosData[i + 7],
                                  valor: _valoresTecnicos[i + 7],
                                  onChanged: (v) {
                                    setState(() {
                                      _valoresTecnicos[i + 7] = v;
                                      _recalcularFactores();
                                    });
                                  },
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      _ResultRow(
                        label: 'Suma Total Valor:',
                        value: _sumaValorFCT.toStringAsFixed(1),
                      ),
                      _ResultRow(
                        label: 'FCT Calculado:',
                        value: _fct.toStringAsFixed(3),
                        isLarge: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // --- Columna Derecha: FA ---
              Expanded(
                flex: 5,
                child: _buildCard(
                  title: '5. Factor de Ambiente (FA)',
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: List.generate(4, (i) {
                                return _FactorItem(
                                  factor: factoresAmbientalesData[i],
                                  valor: _valoresAmbientales[i],
                                  onChanged: (v) {
                                    setState(() {
                                      _valoresAmbientales[i] = v;
                                      _recalcularFactores();
                                    });
                                  },
                                );
                              }),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              children: List.generate(4, (i) {
                                return _FactorItem(
                                  factor: factoresAmbientalesData[i + 4],
                                  valor: _valoresAmbientales[i + 4],
                                  onChanged: (v) {
                                    setState(() {
                                      _valoresAmbientales[i + 4] = v;
                                      _recalcularFactores();
                                    });
                                  },
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      _ResultRow(
                        label: 'Suma Total Valor:',
                        value: _sumaValorFA.toStringAsFixed(1),
                      ),
                      _ResultRow(
                        label: 'FA Calculado:',
                        value: _fa.toStringAsFixed(3),
                        isLarge: true,
                      ),

                      const SizedBox(height: 24), 
                      SizedBox(
                        // width: double.infinity, 
                        width: 250,
                        child: ElevatedButton(
                          onPressed: _calcularFinal,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            textStyle: const TextStyle(
                              // fontSize: 16,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Guardar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =======================================================
// PESTAÑA 3: ESTIMACIÓN
// =======================================================
class _EstimacionUCPTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UCPEstimacionResultado?>(
      valueListenable: estimacionUCP,
      builder: (context, resultado, child) {
        if (resultado == null) {
          return const Center(
            child: Text(
              'Presione "Calcular Estimación Final" en la pestaña anterior.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        return SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Columna Izquierda: Resultados ---
              Expanded(
                child: _buildCard(
                  title: 'Resultados de la Estimación',
                  child: Column(
                    children: [
                      _ResultRow(
                        label: 'PCUSA (Puntos sin ajustar):',
                        value: resultado.pcusa.toStringAsFixed(2),
                      ),
                      _ResultRow(
                        label: 'FCT (Factor Técnico):',
                        value: resultado.fct.toStringAsFixed(3),
                      ),
                      _ResultRow(
                        label: 'FA (Factor Ambiental):',
                        value: resultado.fa.toStringAsFixed(3),
                      ),
                      const Divider(height: 24, thickness: 1),
                      Text(
                        'PCUA = PCUSA × FCT × FA',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        '${resultado.pcusa.toStringAsFixed(2)} × ${resultado.fct.toStringAsFixed(3)} × ${resultado.fa.toStringAsFixed(3)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _ResultRow(
                        label: 'Puntos de Caso de Uso Ajustados (PCUA):',
                        value: resultado.pcua.toStringAsFixed(2),
                        isLarge: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // --- Columna Derecha: Esfuerzo ---
              Expanded(
                child: _buildCard(
                  title: 'Cálculo del Esfuerzo',
                  child: Column(
                    children: [
                      _ResultRow(
                        label: 'Factores de experiencia (X):',
                        value: resultado.x.toString(),
                      ),
                      _ResultRow(
                        label: 'Factores de riesgo (Y):',
                        value: resultado.y.toString(),
                      ),
                      _ResultRow(
                        label: 'Condición (X + Y):',
                        value: (resultado.x + resultado.y).toString(),
                      ),
                      _ResultRow(
                        label: 'Tasa de esfuerzo seleccionada:',
                        value: '${resultado.tasa} HH / PCUA',
                      ),
                      const Divider(height: 24, thickness: 1),
                      Text(
                        'Esfuerzo = PCUA × Tasa = ${resultado.pcua.toStringAsFixed(2)} × ${resultado.tasa}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _ResultRow(
                        label: 'Esfuerzo Estimado:',
                        value:
                            '${resultado.esfuerzo.toStringAsFixed(2)} Horas-Hombre',
                        isLarge: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =======================================================
// WIDGETS AUXILIARES (MODIFICADOS PARA USAR TABLAS)
// =======================================================

class _FactorItem extends StatelessWidget {
  final Map<String, dynamic> factor;
  final int valor;
  final ValueChanged<int> onChanged;

  const _FactorItem({
    required this.factor,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '${factor['id']} (${factor['desc']})',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 40,
              child: DropdownButtonFormField<int>(
                value: valor,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 12.0,
                  ),
                  border: OutlineInputBorder(),
                ),
                items:
                    [0, 1, 2, 3, 4, 5]
                        .map(
                          (v) => DropdownMenuItem(
                            value: v,
                            child: Text(v.toString()),
                          ),
                        )
                        .toList(),
                onChanged: (newValue) => onChanged(newValue!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FactorTableHeader extends StatelessWidget {
  const _FactorTableHeader();

  @override
  Widget build(BuildContext context) {
    // El encabezado es simplemente la primera TableRow de una Table.
    // Devolvemos una Table que solo contiene el encabezado.
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(3),
        3: FlexColumnWidth(2),
      },
      children: const [
        TableRow(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 1.5)),
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: Text(
                'Factor',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Peso',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Valor Asig.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Un contenedor estilizado que sirve como "tarjeta" para agrupar secciones.
Widget _buildCard({required String title, required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Divider(height: 24, thickness: 1),
        child,
      ],
    ),
  );
}

/// Una fila reutilizable para la entrada de conteos, ahora usando Table.
class _InputRowConteo extends StatelessWidget {
  final String label;
  final int peso;
  final TextEditingController controller;

  const _InputRowConteo({
    required this.label,
    required this.peso,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1.5),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              child: Text(label, style: const TextStyle(fontSize: 15)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                height: 35,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
            ),
            Center(
              child: Text('× $peso', style: const TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ],
    );
  }
}

/// Una fila reutilizable para mostrar un par de etiqueta-valor.
class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLarge;

  const _ResultRow({
    required this.label,
    required this.value,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isLarge ? 16 : 14,
              fontWeight: isLarge ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isLarge ? 16 : 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
