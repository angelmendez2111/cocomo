import 'package:flutter/material.dart';

class Cocomo81View extends StatelessWidget {
  const Cocomo81View({super.key});

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
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'COCOMO-81 Intermedio',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Estimación de esfuerzo, tiempo y costo basado en el modelo COCOMO-81 Intermedio',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Builder(
                      builder: (context) {
                        final TabController tabController = TabController(length: 3, vsync: Scaffold.of(context), animationDuration: Duration.zero);
                        return Column(
                          children: [
                            TabBar(
                              controller: tabController,
                              labelColor: Colors.black,
                              labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              unselectedLabelStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                              indicatorWeight: 4,
                              tabs: const [
                                Tab(text: 'Modo y Tamaño'),
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
                                  SingleChildScrollView(child: _ModoYTamanoTab()),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 12),
                                      Center(
                                        child: Container(
                                          constraints: const BoxConstraints(maxWidth: 600),
                                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
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
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const Center(
                                                child: Text(
                                                  'Costo persona-mes',
                                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Row(
                                                children: const [
                                                  Expanded(
                                                    child: Text('Etapa', style: TextStyle(fontWeight: FontWeight.bold)),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Costo persona-mes',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              _CostoPersonaMesRow(etapa: 'Análisis'),
                                              _CostoPersonaMesRow(etapa: 'Diseño'),
                                              _CostoPersonaMesRow(etapa: 'Diseño detallado'),
                                              _CostoPersonaMesRow(etapa: 'Codificación'),
                                              _CostoPersonaMesRow(etapa: 'Integración'),
                                              _CostoPersonaMesRow(etapa: 'Mantenimiento'),
                                              const SizedBox(height: 16),
                                              SizedBox(
                                                width: 120,
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  child: const Text('Guardar'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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

class _ModoYTamanoTabState extends State<_ModoYTamanoTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _modoDesarrollo = 'Orgánico';
  String _tamanoSoftware = 'KLDC';
  String _valorKLDC = '';
  String _lenguajeSeleccionado = 'Escoge';

  final List<String> _opcionesModo = ['Orgánico', 'Moderado', 'Empotrado'];
  final List<String> _opcionesLenguaje = [
    'Escoge',
    'Java',
    'C',
    'C++',
    'C#',
    'Python',
    'JavaScript',
    'Kotlin',
    'Swift',
  ];

  final Map<String, String> _textoModo = {
    'Orgánico': 'Proyectos de software pequeños y sencillos en los que trabajan pequenos equipos, con buena experiencia en la aplicación, sobre un conjunto de requisitos poco rígidos',
    'Moderado': 'Proyectos de software intermedios en tamaño y complejidad en los que equipos, con variados niveles de experiencia, deben satisfacer requisitos medio rigidos',
    'Empotrado': 'Proyectos de software complejos que deben ser desarrollados en un conjunto de hardware, software y restricciones operativas muy restringido.',
  };

  // Estado de selección de la tabla (5 filas x 3 columnas)
  List<int?> _seleccionTabla = List.generate(5, (_) => null); // null: nada, 0: baja, 1: media, 2: alta

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Columna izquierda: 50%
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila superior: Modo de desarrollo y Tamaño del software
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 6, bottom: 2),
                          child: Text(
                            'Modo de desarrollo',
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: DropdownMenu<String>(
                                        initialSelection: _modoDesarrollo,
                                        onSelected: (String? value) {
                                          setState(() {
                                            _modoDesarrollo = value!;
                                          });
                                        },
                                        dropdownMenuEntries: _opcionesModo
                                            .map((op) => DropdownMenuEntry<String>(value: op, label: op))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  _textoModo[_modoDesarrollo] ?? '',
                                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 6, bottom: 2),
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
                                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
                                dropdownMenuEntries: _opcionesLenguaje
                                    .map((op) => DropdownMenuEntry<String>(value: op, label: op))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        Table(
                          border: TableBorder.all(color: Colors.black, width: 2),
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
                                  child: Center(child: Text('Tipo de Función', style: TextStyle(fontWeight: FontWeight.bold))),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Center(child: Text('Baja', style: TextStyle(fontWeight: FontWeight.bold))),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Center(child: Text('Media', style: TextStyle(fontWeight: FontWeight.bold))),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Center(child: Text('Alta', style: TextStyle(fontWeight: FontWeight.bold))),
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
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _seleccionTabla[row] = col;
                                        });
                                      },
                                      child: Container(
                                        height: 32,
                                        margin: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black, width: 2),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: _seleccionTabla[row] == col
                                              ? const Text('X', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green))
                                              : const SizedBox.shrink(),
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
                                  _seleccionTabla = List.generate(5, (_) => null);
                                });
                              },
                              child: const Text('Limpiar'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(onPressed: () {}, child: const Text('Calcular')),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('Total:'),
                        const SizedBox(height: 4),
                        const Text('Líneas de Código (LOC):'),
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
        // Columna derecha: 50%
        Expanded(
          flex: 1,
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
                            child: _CostDriverBox(
                              title: 'Producto',
                              items: ['RSS', 'TBD', 'CPR'],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _CostDriverBox(
                              title: 'Proyecto',
                              items: ['UTP', 'UHS', 'RPL'],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _CostDriverBox(
                              title: 'Personal',
                              items: ['CAN', 'EAN', 'CPRO', 'ESO', 'ELP'],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _CostDriverBox(
                              title: 'Plataforma',
                              items: ['RTE', 'RMP', 'VMC', 'TRC'],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
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
}

class _CostDriverSection extends StatefulWidget {
  final String title;
  final List<String> items;
  const _CostDriverSection({required this.title, required this.items});

  @override
  State<_CostDriverSection> createState() => _CostDriverSectionState();
}

class _CostDriverSectionState extends State<_CostDriverSection> {
  final List<String> opciones = ['Muy bajo', 'Bajo', 'Nominal', 'Alto', 'Muy alto'];
  late List<String> seleccionadas;

  @override
  void initState() {
    super.initState();
    seleccionadas = List.generate(widget.items.length, (_) => 'Nominal');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...List.generate(widget.items.length, (i) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 70,
                child: Text(widget.items[i], style: const TextStyle(fontSize: 15)),
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
                  dropdownMenuEntries: opciones.map((op) => DropdownMenuEntry<String>(value: op, label: op)).toList(),
                ),
              ),
            ],
          ),
        )),
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
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: _CostDriverSection(title: title, items: items),
    );
  }
}

class _CostoPersonaMesRow extends StatelessWidget {
  final String etapa;
  const _CostoPersonaMesRow({required this.etapa});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(etapa)),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 32,
              child: TextField(
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EstimacionTab extends StatefulWidget {
  const _EstimacionTab();
  @override
  State<_EstimacionTab> createState() => _EstimacionTabState();
}

class _EstimacionTabState extends State<_EstimacionTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                          children: const [
                            Text('Ecuaciones Utilizadas', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text('Esfuerzo (ESF) = 2.8 × (KLDC)^1.20 × FEC'),
                            Text('Tiempo de desarrollo (TDES) = 2.5 × (ESF)^0.32'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('* KLCD: tamaño del proyecto en Kilo Líneas de Código', style: TextStyle(fontSize: 12)),
                            Text('* FEC: conductores de coste', style: TextStyle(fontSize: 12)),
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
                      const Text('Resultado de la Estimación', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _EstimacionCardBox(
                              title: 'Esfuerzo Total',
                              value: '39.55',
                              subtitle: 'Personas-mes',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _EstimacionCardBox(
                              title: 'Tiempo de Desarrollo',
                              value: '9.06',
                              subtitle: 'Meses',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _EstimacionCardBox(
                              title: 'Costo Total',
                              value: '155422.47',
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
                      const Text('Estimación por Etapas', style: TextStyle(fontWeight: FontWeight.bold)),
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
                                child: Text('Etapa', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text('Esfuerzo (Persona-Mes)', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text('Costo Persona-Mes (PEN)', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text('Tiempo de desarrollo (Mes)', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          ...['Análisis', 'Diseño', 'Diseño detallado', 'Codificación', 'Integración', 'Mantenimiento'].map(
                            (etapa) => TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(etapa),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    height: 28,
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    height: 28,
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    height: 28,
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                      ),
                                    ),
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
                const SizedBox(height: 8),
                SizedBox(
                  width: 220,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Guardar Estimación'),
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

class _EstimacionCardBox extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  const _EstimacionCardBox({required this.title, required this.value, required this.subtitle});

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
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
} 