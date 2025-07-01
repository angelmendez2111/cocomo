import 'package:flutter/material.dart';
import 'package:cocomo_software/cocomo_2_calculator.dart';

double _kldcGuardado = 0.0;
double _sfGuardado = 1.0;
double _fecGuardado = 1.0;

class Cocomo2View extends StatelessWidget {
  const Cocomo2View({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regresar al menú principal'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        toolbarHeight: 60,
      ),
      body: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'COCOMO II Post-Arquitectura',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Estimación de esfuerzo y tiempo basado en el modelo COCOMO II Post-Arquitectura',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Builder(
                      builder: (context) {
                        final TabController tabController = TabController(
                          length: 3,
                          vsync: Scaffold.of(context),
                          animationDuration: Duration.zero,
                        );
                        return Column(
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
                                Tab(text: 'Factores y Tamaño'),
                                Tab(text: 'Costo persona-mes'),
                                Tab(text: 'Estimación'),
                              ],
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              height: 950,
                              child: TabBarView(
                                controller: tabController,
                                children: [
                                  SingleChildScrollView(
                                    child: _ModoYTamanoTab(),
                                  ),
                                  const _CostoPersonaMesTab(),
                                  const _EstimacionTab(),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModoYTamanoTab extends StatefulWidget {
  @override
  State<_ModoYTamanoTab> createState() => _ModoYTamanoTabState();
}

class _ModoYTamanoTabState extends State<_ModoYTamanoTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _tamanoSoftware = 'KLDC';
  String _valorKLDC = '';
  String _lenguajeSeleccionado = 'Escoge';
  int _resultadoPF = 0;
  double _resultadoKLDC = 0.0;

  final cocomo = Cocomo2Calculator();
  final List<String> _opcionesLenguaje = [
    'Escoge',
    '4GL',
    'Ada 83',
    'Ada 95',
    'APL',
    'BASIC - Compilado',
    'BASIC - Interpretado',
    'BASIC ANSI/Quick/Turbo',
    'C',
    'C++',
    'Clipper',
    'Cocol ANSI 85',
    'Delphi 1',
    'Ensamblador',
    'Ensamblador (Macro)',
    'Forth',
    'Fortran 77',
    'FoxPro 2.5',
    'Java',
    'Modula 2',
    'Oracle',
    'Oracle 2000',
    'Paradox',
    'Pascal',
    'Pascal Turbo 5',
    'Power Builder',
    'Prolog',
    'Visual Basic 3',
    'Visual C++',
    'Visual Cobol',
  ];

  // Estado de selección de la tabla (5 filas x 3 columnas)
  List<int?> _seleccionTabla = List.generate(
    5,
    (_) => null,
  ); // null: nada, 0: baja, 1: media, 2: alta
  final List<List<TextEditingController>> _pfControllers = List.generate(
    5,
    (_) => List.generate(3, (_) => TextEditingController()),
  );

  final GlobalKey<_CostDriverSectionState> _productoKey = GlobalKey();
  final GlobalKey<_CostDriverSectionState> _proyectoKey = GlobalKey();
  final GlobalKey<_CostDriverSectionState> _personalKey = GlobalKey();
  final GlobalKey<_CostDriverSectionState> _plataformaKey = GlobalKey();
  final GlobalKey<_ScaleFactorSectionState> _scaleFactorsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Columna izquierda: 50%
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila superior: Modo de desarrollo y Tamaño del software
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Text(
                            'Tamaño del Software',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black26),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: 'KLDC',
                                      groupValue: _tamanoSoftware,
                                      onChanged: (value) {
                                        setState(() {
                                          _tamanoSoftware = value!;
                                        });
                                      },
                                    ),
                                    const Text('KLDC'),
                                    const SizedBox(width: 8),
                                    if (_tamanoSoftware == 'KLDC')
                                      SizedBox(
                                        width: 150,
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 8,
                                                  horizontal: 8,
                                                ),
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              _valorKLDC = value;
                                            });
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: 'Puntos de función',
                                      groupValue: _tamanoSoftware,
                                      onChanged: (value) {
                                        setState(() {
                                          _tamanoSoftware = value!;
                                        });
                                      },
                                    ),
                                    const Text('Puntos de función'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Puntos de Función debajo
              const Padding(
                padding: EdgeInsets.only(left: 6, bottom: 2, top: 18),
                child: Text(
                  'Puntos de Función',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AbsorbPointer(
                absorbing: _tamanoSoftware != 'Puntos de función',
                child: Opacity(
                  opacity: _tamanoSoftware == 'Puntos de función' ? 1.0 : 0.5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Lenguaje de programación:',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 180,
                              child: DropdownMenu<String>(
                                initialSelection: _lenguajeSeleccionado,
                                onSelected: (String? value) {
                                  setState(() {
                                    _lenguajeSeleccionado = value!;
                                  });
                                },
                                dropdownMenuEntries:
                                    _opcionesLenguaje
                                        .map(
                                          (op) => DropdownMenuEntry<String>(
                                            value: op,
                                            label: op,
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        Table(
                          border: TableBorder.all(
                            color: Colors.black,
                            width: 2,
                          ),
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(),
                            2: FlexColumnWidth(),
                            3: FlexColumnWidth(),
                          },
                          children: [
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Center(
                                    child: Text(
                                      'Tipo de Función',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Center(
                                    child: Text(
                                      'Baja',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Center(
                                    child: Text(
                                      'Media',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Center(
                                    child: Text(
                                      'Alta',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ...List.generate(5, (row) {
                              final tipos = [
                                'Entradas Externas',
                                'Salidas Externas',
                                'Consultas Externas',
                                'Archivos Lógicos Internos',
                                'Archivos de Interfaz Externa',
                              ];
                              return TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(tipos[row]),
                                  ),
                                  ...List.generate(3, (col) {
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: TextField(
                                        controller: _pfControllers[row][col],
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 8,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              );
                            }),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  for (var fila in _pfControllers) {
                                    for (var controller in fila) {
                                      controller.clear();
                                    }
                                  }
                                  _resultadoPF = 0;
                                  _resultadoKLDC = 0.0;
                                });
                              },
                              child: const Text('Limpiar'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                final totalPF = cocomo.calcularPuntosFuncion(
                                  _pfControllers,
                                );
                                final loc = cocomo.convertirPFaKLDC(
                                  totalPF,
                                  _lenguajeSeleccionado,
                                );

                                setState(() {
                                  _resultadoPF = totalPF;
                                  _resultadoKLDC = loc;
                                });
                              },
                              child: const Text('Calcular'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('Total: $_resultadoPF Puntos de Función'),
                        const SizedBox(height: 4),
                        Text(
                          'Líneas de Código (KLDC): ${_resultadoKLDC.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Espaciado entre columnas
        const SizedBox(width: 32),

        // Columna central: 50%
        Expanded(
          flex: 2, // Ajusta el flex según necesites
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 6, bottom: 2),
                child: Text(
                  'Factores de Escala',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: _ScaleFactorSection(
                  key: _scaleFactorsKey, // <-- Necesitas añadir esta GlobalKey
                  items: const ['PREC', 'FLEX', 'RESL', 'TEAM', 'PMAT'],
                ),
              ),
            ],
          ),
        ),

        // Espaciado entre columnas
        const SizedBox(width: 32),

        // Columna derecha: 50%
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 6, bottom: 2),
                child: Text(
                  'Conductores de Coste',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _CostDriverSection(
                              key: _productoKey,
                              title: 'Producto',
                              items: ['RSS', 'TBD', 'CPR', 'RUSE', 'DOC'],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _CostDriverSection(
                              key: _proyectoKey,
                              title: 'Proyecto',
                              items: ['UHS', 'RPL', 'DMS'],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _CostDriverSection(
                              key: _personalKey,
                              title: 'Personal',
                              items: ['CAN', 'EAPL', 'CPRO', 'CPER', 'EPLA', 'ELP'],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _CostDriverSection(
                              key: _plataformaKey,
                              title: 'Plataforma',
                              items: ['RTE', 'RMP', 'VMC'],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final scaleFactors  = {
                              ...?_scaleFactorsKey.currentState?.getSelecciones(),
                            };

                            final costDrivers  = {
                              ...?_productoKey.currentState?.getSelecciones(),
                              ...?_proyectoKey.currentState?.getSelecciones(),
                              ...?_personalKey.currentState?.getSelecciones(),
                              ...?_plataformaKey.currentState?.getSelecciones(),
                            };
                            // print('SELECCIONADOS: $seleccionados');
                            final double sf = cocomo.calcularFactorEscala(
                              scaleFactors,
                            );
                            final fec = cocomo.calcularFECDesdeCostDrivers(
                              costDrivers,
                            );

                            setState(() {
                              _kldcGuardado =
                                  _resultadoKLDC > 0
                                      ? _resultadoKLDC
                                      : double.tryParse(_valorKLDC) ?? 0.0;
                              _fecGuardado = fec;
                              _sfGuardado = sf;
                            });

                            if (
                                _kldcGuardado > 0 &&
                                _fecGuardado > 0 &&
                                _sfGuardado > 0 &&
                                costosGuardadosGlobal.isNotEmpty) {
                              final resultado = calcularEstimacionCompleta(
                                kldc: _kldcGuardado,
                                fec: _fecGuardado,
                                sf: _sfGuardado,
                                costosPM: costosGuardadosGlobal,
                                esfuerzosPorcentaje: esfuerzosGuardadosGlobal,
                              );

                              if (resultado != null) {
                                setState(() {
                                  estimacionGuardada = resultado;
                                  estimacionVersion
                                      .value++; // Notifica que hay nueva estimación
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Estimación actualizada'),
                                  ),
                                );
                              }
                            }

                            showDialog(
                              context: context,
                              builder:
                                  (_) => AlertDialog(
                                    title: const Text('Valores Ingresados'),
                                    content: Text(
                                      'Tamaño (KLDC): $_kldcGuardado\n'
                                      'SF: ${_sfGuardado.toStringAsFixed(2)}\n'
                                      'FEC: ${_fecGuardado.toStringAsFixed(2)}\n',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                            );

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content: Text(
                            //       'Parámetros guardados correctamente',
                            //     ),
                            //   ),
                            // );
                          },
                          child: const Text('Guardar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    for (final fila in _pfControllers) {
      for (final controller in fila) {
        controller.dispose();
      }
    }
    super.dispose();
  }
}

class _CostDriverSection extends StatefulWidget {
  final String title;
  final List<String> items;
  const _CostDriverSection({Key? key, required this.title, required this.items})
    : super(key: key);

  @override
  State<_CostDriverSection> createState() => _CostDriverSectionState();
}

class _CostDriverSectionState extends State<_CostDriverSection> {
  final List<List<String>> opcionesPorItem = [];

  @override
  void initState() {
    super.initState();
    seleccionadas = [];
    for (var item in widget.items) {
      final opciones = costDriverValues[item]?.keys.toList() ?? ['Nominal'];
      opcionesPorItem.add(opciones);
      seleccionadas.add('Nominal'); // valor por defecto
    }
  }

  late List<String> seleccionadas;

  Map<String, String> getSelecciones() {
    final Map<String, String> resultado = {};
    for (int i = 0; i < widget.items.length; i++) {
      resultado[widget.items[i]] = seleccionadas[i];
    }
    return resultado;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   seleccionadas = List.generate(widget.items.length, (_) => 'Nominal');
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...List.generate(
          widget.items.length,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 70,
                  child: Text(
                    widget.items[i],
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: DropdownMenu<String>(
                    initialSelection: seleccionadas[i],
                    onSelected: (String? value) {
                      setState(() {
                        seleccionadas[i] = value!;
                      });
                    },
                    dropdownMenuEntries:
                        opcionesPorItem[i]
                            .map(
                              (op) => DropdownMenuEntry(value: op, label: op),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _CostDriverBox extends StatelessWidget {
  final String title;
  final List<String> items;
  const _CostDriverBox({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: _CostDriverSection(title: title, items: items),
    );
  }
}

class _CostoPersonaMesRow extends StatelessWidget {
  final String etapa;
  final TextEditingController costoController;
  final TextEditingController esfuerzoController;

  const _CostoPersonaMesRow({
    required this.etapa,
    required this.costoController,
    required this.esfuerzoController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(etapa)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: costoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Costo',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: esfuerzoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Esfuerzo (%)',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CostoPersonaMesTab extends StatefulWidget {
  const _CostoPersonaMesTab();

  @override
  State<_CostoPersonaMesTab> createState() => _CostoPersonaMesTabState();
}

class _CostoPersonaMesTabState extends State<_CostoPersonaMesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final Map<String, TextEditingController> _controladoresCosto = {
    'Análisis': TextEditingController(),
    'Diseño': TextEditingController(),
    'Diseño detallado': TextEditingController(),
    'Codificación': TextEditingController(),
    'Integración': TextEditingController(),
    'Mantenimiento': TextEditingController(),
  };

  final Map<String, TextEditingController> _controladoresEsfuerzo = {
    'Análisis': TextEditingController(),
    'Diseño': TextEditingController(),
    'Diseño detallado': TextEditingController(),
    'Codificación': TextEditingController(),
    'Integración': TextEditingController(),
    'Mantenimiento': TextEditingController(),
  };

  @override
  void dispose() {
    for (final controller in _controladoresCosto.values) {
      controller.dispose();
    }
    for (final controller in _controladoresEsfuerzo.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Costo persona-mes',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Etapa',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Esfuerzo (%)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Costo persona-mes',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ..._controladoresCosto.keys.map((etapa) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(child: Text(etapa)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _controladoresEsfuerzo[etapa],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _controladoresCosto[etapa],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      final Map<String, double> nuevosCostos = {};
                      final Map<String, double> nuevosEsfuerzos = {};
                      double sumaEsfuerzo = 0;

                      for (final etapa in _controladoresCosto.keys) {
                        final costo =
                            double.tryParse(_controladoresCosto[etapa]!.text) ??
                            0.0;
                        final esfuerzo =
                            double.tryParse(
                              _controladoresEsfuerzo[etapa]!.text,
                            ) ??
                            0.0;

                        if (costo > 0 && esfuerzo > 0) {
                          nuevosCostos[etapa] = costo;
                          nuevosEsfuerzos[etapa] = esfuerzo;
                          sumaEsfuerzo += esfuerzo;
                        }
                      }

                      if (sumaEsfuerzo != 100) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'La suma de esfuerzo por etapa debe ser exactamente 100%.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      costosGuardadosGlobal = nuevosCostos;
                      esfuerzosGuardadosGlobal = nuevosEsfuerzos;

                      if (
                          _kldcGuardado > 0 &&
                          _fecGuardado > 0 &&
                          _sfGuardado > 0) {
                        final resultado = calcularEstimacionCompleta(
                          kldc: _kldcGuardado,
                          fec: _fecGuardado,
                          sf: _sfGuardado,
                          costosPM: nuevosCostos,
                          esfuerzosPorcentaje: nuevosEsfuerzos,
                        );

                        if (resultado != null) {
                          setState(() {
                            estimacionGuardada = resultado;
                            estimacionVersion
                                .value++; // Notifica que hay nueva estimación
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Estimación actualizada'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Costos guardados. Faltan datos para estimar.',
                              style: TextStyle(color: Colors.black),
                            ),
                            backgroundColor: Colors.yellowAccent,
                          ),
                        );
                      }

                      // showDialog(
                      //   context: context,
                      //   builder:
                      //       (_) => AlertDialog(
                      //         title: const Text('Resultado'),
                      //         content: Text(
                      //           'Costo total: $nuevosCostos\nEsfuerzos: $nuevosEsfuerzos',
                      //         ),
                      //         actions: [
                      //           TextButton(
                      //             onPressed: () => Navigator.pop(context),
                      //             child: const Text('OK'),
                      //           ),
                      //         ],
                      //       ),
                      // );

                      final resumen = nuevosEsfuerzos.entries
                          .map((entry) {
                            final etapa = entry.key;
                            final esfuerzo = entry.value.toStringAsFixed(0);
                            final costo =
                                nuevosCostos[etapa]?.toStringAsFixed(2) ??
                                '0.00';
                            return '$etapa: $esfuerzo% - $costo';
                          })
                          .join('\n');

                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text('Etapas Ingresadas'),
                              content: Text(resumen),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                      );
                    },
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EstimacionTab extends StatefulWidget {
  const _EstimacionTab();
  @override
  State<_EstimacionTab> createState() => _EstimacionTabState();
}

class _EstimacionTabState extends State<_EstimacionTab>
    with AutomaticKeepAliveClientMixin {
  double esfuerzoTotal = 0.0;
  double tiempoTotal = 0.0;
  double costoTotal = 0.0;

  double exponenteB = 0.0;
  double exponenteD = 0.0;

  Map<String, double> esfuerzoEtapas = {};
  Map<String, double> tiempoEtapas = {};
  Map<String, double> costoEtapas = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _cargarEstimacion();
    });
  }

  void _cargarEstimacion() {
    if (estimacionGuardada != null) {
      esfuerzoTotal = estimacionGuardada!.esfuerzoTotal;
      tiempoTotal = estimacionGuardada!.tiempoTotal;
      costoTotal = estimacionGuardada!.costoTotal;

      exponenteB = estimacionGuardada!.exponentB;
      exponenteD = estimacionGuardada!.exponentD;

      esfuerzoEtapas = estimacionGuardada!.esfuerzoEtapas;
      tiempoEtapas = estimacionGuardada!.tiempoEtapas;
      costoEtapas = estimacionGuardada!.costoEtapas;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ValueListenableBuilder<int>(
      valueListenable: estimacionVersion,
      builder: (context, version, _) {
        _cargarEstimacion();

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Ecuaciones Utilizadas
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ecuaciones Utilizadas',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Esfuerzo (ESF) = 2.94 × FEC × (KLDC)^${exponenteB.toStringAsFixed(2)}',
                                ),
                                Text(
                                  'Tiempo (TDES) = 3.67 × (ESF)^${exponenteD.toStringAsFixed(2)}',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  '* KLCD: tamaño del proyecto en Kilo Líneas de Código',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  '* FEC: conductores de coste',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Resultado de la Estimación
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Resultado de la Estimación',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _EstimacionCardBox(
                                  title: 'Esfuerzo Total',
                                  value: esfuerzoTotal.toStringAsFixed(2),
                                  subtitle: 'Personas-mes',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _EstimacionCardBox(
                                  title: 'Tiempo de Desarrollo',
                                  value: tiempoTotal.toStringAsFixed(2),
                                  subtitle: 'Meses',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _EstimacionCardBox(
                                  title: 'Costo Total',
                                  value: costoTotal.toStringAsFixed(2),
                                  subtitle: 'Soles',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Estimación por Etapas
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Estimación por Etapas',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(),
                              2: FlexColumnWidth(),
                              3: FlexColumnWidth(),
                            },
                            border: TableBorder.all(color: Colors.black26),
                            children: [
                              const TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      'Etapa',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      'Esfuerzo (Persona-Mes)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      'Costo Persona-Mes (PEN)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      'Tiempo de desarrollo (Mes)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ...[
                                'Análisis',
                                'Diseño',
                                'Diseño detallado',
                                'Codificación',
                                'Integración',
                                'Mantenimiento',
                              ].map(
                                (etapa) => TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(etapa),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        esfuerzoEtapas[etapa]?.toStringAsFixed(
                                              2,
                                            ) ??
                                            '-',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        costoEtapas[etapa]?.toStringAsFixed(
                                              2,
                                            ) ??
                                            '-',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        tiempoEtapas[etapa]?.toStringAsFixed(
                                              2,
                                            ) ??
                                            '-',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Botón Guardar Estimación
                    // const SizedBox(height: 8),
                    // SizedBox(
                    //   width: 220,
                    //   child: ElevatedButton(
                    //     onPressed: () {},
                    //     child: const Text('Guardar Estimación'),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EstimacionCardBox extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  const _EstimacionCardBox({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

// ===============================
//  SECCIÓN DE FACTORES DE ESCALA
// ===============================
class _ScaleFactorSection extends StatefulWidget {
  final List<String> items;
  const _ScaleFactorSection({Key? key, required this.items}) : super(key: key);

  @override
  State<_ScaleFactorSection> createState() => _ScaleFactorSectionState();
}

class _ScaleFactorSectionState extends State<_ScaleFactorSection> {
  late List<String> seleccionadas;
  // Opciones para los factores de escala de COCOMO II
  final List<String> opciones = const [
    'Muy Bajo',
    'Bajo',
    'Nominal',
    'Alto',
    'Muy Alto',
    'Extra Alto',
  ];

  @override
  void initState() {
    super.initState();
    seleccionadas = List.generate(widget.items.length, (_) => 'Nominal');
  }

  // Método para que el widget padre pueda obtener los valores
  Map<String, String> getSelecciones() {
    return Map.fromIterables(widget.items, seleccionadas);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          widget.items.length,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Text(
                    widget.items[i],
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownMenu<String>(
                    initialSelection: seleccionadas[i],
                    onSelected: (String? value) {
                      setState(() {
                        seleccionadas[i] = value!;
                      });
                    },
                    dropdownMenuEntries:
                        opciones
                            .map(
                              (op) => DropdownMenuEntry(value: op, label: op),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
