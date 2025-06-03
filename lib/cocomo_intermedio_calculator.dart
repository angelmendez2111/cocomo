import 'dart:math';
import 'package:flutter/material.dart';

const Map<String, Map<String, double>> costDriverValues = {
  // ----- PRODUCTO ----- //
  'RSS': {
    'Muy bajo': 0.75,
    'Bajo': 0.88,
    'Nominal': 1.00,
    'Alto': 1.15,
    'Muy alto': 1.40,
  },
  'TBD': {
    'Bajo': 0.94,
    'Nominal': 1.00,
    'Alto': 1.08,
    'Muy alto': 1.16,
  },
  'CPR': {
    'Muy bajo': 0.70,
    'Bajo': 0.85,
    'Nominal': 1.00,
    'Alto': 1.15,
    'Muy alto': 1.30,
    'Extra alto': 1.65,
  },
  // ----- PLATAFORMA ----- //
  'RTE': {
    'Nominal': 1.00,
    'Alto': 1.11,
    'Muy alto': 1.30,
    'Extra alto': 1.66,
  },
  'RMP': {
    'Nominal': 1.00,
    'Alto': 1.06,
    'Muy alto': 1.30,
    'Extra alto': 1.58,
  },
  'VMC': {
    'Bajo': 0.87,
    'Nominal': 1.00,
    'Alto': 1.15,
    'Muy alto': 1.30,
  },
  'TRC': {
    'Bajo': 0.87,
    'Nominal': 1.00,
    'Alto': 1.07,
    'Muy alto': 1.15,
  },
  // ----- PERSONAL ----- //
  'CAN': {
    'Muy bajo': 1.46,
    'Bajo': 1.19,
    'Nominal': 1.00,
    'Alto': 0.86,
    'Muy alto': 0.71,
  },
  'EAN': {
    'Muy bajo': 1.29,
    'Bajo': 1.13,
    'Nominal': 1.00,
    'Alto': 0.91,
    'Muy alto': 0.82,
  },
  'CPRO': {
    'Muy bajo': 1.42,
    'Bajo': 1.17,
    'Nominal': 1.00,
    'Alto': 0.86,
    'Muy alto': 0.70,
  },
  'ESO': {
    'Muy bajo': 1.21,
    'Bajo': 1.12,
    'Nominal': 1.00,
    'Alto': 0.96,
  },
  'ELP': {
    'Muy bajo': 1.14,
    'Bajo': 1.10,
    'Nominal': 1.00,
    'Alto': 0.95,
  },
  // ----- PROYECTO ----- //
  'UTP': {
    'Muy bajo': 1.24,
    'Bajo': 1.10,
    'Nominal': 1.00,
    'Alto': 0.91,
    'Muy alto': 0.82,
  },
  'UHS': {
    'Muy bajo': 1.24,
    'Bajo': 1.10,
    'Nominal': 1.00,
    'Alto': 0.91,
    'Muy alto': 0.83,
    'Extra alto': 0.70,
  },
  'RPL': {
    'Muy bajo': 1.23,
    'Bajo': 1.08,
    'Nominal': 1.00,
    'Alto': 1.04,
    'Muy alto': 1.10,
  },
};

// final etapas = [
//   'Análisis',
//   'Diseño',
//   'Diseño detallado',
//   'Codificación',
//   'Integración',
//   'Mantenimiento',
// ];

EstimacionResultado? estimacionGuardada;
Map<String, double> costosGuardadosGlobal = {};

class CocomoCalculator {
  static const Map<String, Map<String, double>> _coeficientes = {
    'Orgánico': {'a': 3.2, 'b': 1.05, 'c': 0.38},
    'Moderado': {'a': 3.0, 'b': 1.12, 'c': 0.35},
    'Empotrado': {'a': 2.8, 'b': 1.20, 'c': 0.32},
  };

  static double calcularEsfuerzo(String modo, double kldc, double fec) {
    final coef = _coeficientes[modo]!;
    return coef['a']! * pow(kldc, coef['b']!) * fec;
  }

  static double calcularTiempo(String modo, double esfuerzo) {
    final coef = _coeficientes[modo]!;
    return 2.5 * pow(esfuerzo, coef['c']!);
  }

  static double calcularCostoTotal(
    double esfuerzo,
    Map<String, double> costoPorEtapa,
  ) {
    final esfuerzoPorEtapa = esfuerzo / costoPorEtapa.length;
    double total = 0;
    costoPorEtapa.forEach((etapa, costoPM) {
      total += esfuerzoPorEtapa * costoPM;
    });
    return total;
  }

  //----------------  PUNTOS DE FUNCION ---------------

  int calcularPuntosFuncion(List<List<TextEditingController>> controllers) {
    final tipos = [
      'Entradas Externas',
      'Salidas Externas',
      'Consultas Externas',
      'Archivos Lógicos Internos',
      'Archivos de Interfaz Externa',
    ];

    final pesosPorTipo = {
      'Entradas Externas': [3, 4, 6],
      'Salidas Externas': [4, 5, 7],
      'Consultas Externas': [3, 4, 6],
      'Archivos Lógicos Internos': [7, 10, 15],
      'Archivos de Interfaz Externa': [5, 7, 10],
    };

    int totalPF = 0;
    for (int row = 0; row < tipos.length; row++) {
      final pesos = pesosPorTipo[tipos[row]]!;
      for (int col = 0; col < 3; col++) {
        final valor = int.tryParse(controllers[row][col].text) ?? 0;
        totalPF += valor * pesos[col];
      }
    }
    return totalPF;
  }

  double convertirPFaKLDC(int puntosFuncion, String lenguaje) {
    const locPorLenguaje = {
      '4GL': 40,
      'Ada 83': 71,
      'Ada 95': 49,
      'APL': 32,
      'BASIC - Compilado': 91,
      'BASIC - Interpretado': 128,
      'BASIC ANSI/Quick/Turbo': 64,
      'C': 128,
      'C++': 29,
      'Clipper': 19,
      'Cocol ANSI 85': 91,
      'Delphi 1': 29,
      'Ensamblador': 320,
      'Ensamblador (Macro)': 213,
      'Forth': 64,
      'Fortran 77': 105,
      'FoxPro 2.5': 34,
      'Java': 53,
      'Modula 2': 80,
      'Oracle': 40,
      'Oracle 2000': 23,
      'Paradox': 36,
      'Pascal': 91,
      'Pascal Turbo 5': 49,
      'Power Builder': 16,
      'Prolog': 64,
      'Visual Basic 3': 32,
      'Visual C++': 34,
      'Visual Cobol': 20,
    };

    final loc = puntosFuncion * (locPorLenguaje[lenguaje] ?? 0);
    return loc / 1000.0; // Convertimos a KLDC
  }


  //----------------  CONDUCTORES DE COSTE ---------------

  double calcularFECDesdeCostDrivers(Map<String, String> seleccionados) {
    double fec = 1.0;
    seleccionados.forEach((nombre, nivel) {
      final valor = costDriverValues[nombre]?[nivel] ?? 1.0;
      fec *= valor;
    });
    return fec;
  }




}

class EstimacionResultado {
  final double esfuerzoTotal;
  final double tiempoTotal;
  final double costoTotal;
  final double a;
  final double b;
  final double c;
  final Map<String, double> esfuerzoEtapas;
  final Map<String, double> tiempoEtapas;
  final Map<String, double> costoEtapas;

  EstimacionResultado({
    required this.esfuerzoTotal,
    required this.tiempoTotal,
    required this.costoTotal,
    required this.a,
    required this.b,
    required this.c,
    required this.esfuerzoEtapas,
    required this.tiempoEtapas,
    required this.costoEtapas,
  });
}

EstimacionResultado? calcularEstimacionCompleta({
  required String modo,
  required double kldc,
  required double fec,
  required Map<String, double> costosPM,
}) {
  if (modo.isEmpty || kldc <= 0 || fec <= 0 || costosPM.isEmpty) return null;

  final esfuerzo = CocomoCalculator.calcularEsfuerzo(modo, kldc, fec);
  final tiempo = CocomoCalculator.calcularTiempo(modo, esfuerzo);

  final coef = CocomoCalculator._coeficientes[modo];
  if (coef == null) return null;

  final a = coef['a']!;
  final b = coef['b']!;
  final c = coef['c']!;

  const etapas = [
    'Análisis',
    'Diseño',
    'Diseño detallado',
    'Codificación',
    'Integración',
    'Mantenimiento',
  ];
  final esfuerzoPorEtapa = esfuerzo / etapas.length;
  final tiempoPorEtapa = tiempo / etapas.length;

  double costoTotal = 0.0;
  final Map<String, double> esfuerzoEtapas = {};
  final Map<String, double> tiempoEtapas = {};
  final Map<String, double> costoEtapas = {};

  for (final etapa in etapas) {
    final costoPM = costosPM[etapa] ?? 0.0;
    final costoEtapa = esfuerzoPorEtapa * costoPM;

    esfuerzoEtapas[etapa] = esfuerzoPorEtapa;
    tiempoEtapas[etapa] = tiempoPorEtapa;
    costoEtapas[etapa] = costoEtapa;
    costoTotal += costoEtapa;
  }

  print(
    'Estimación total: Esfuerzo=$esfuerzo, Tiempo=$tiempo, Costo=$costoTotal',
  );
  print('Esfuerzo por etapa: $esfuerzoEtapas');


  return EstimacionResultado(
    esfuerzoTotal: esfuerzo,
    tiempoTotal: tiempo,
    costoTotal: costoTotal,
    a: a,
    b: b,
    c: c,
    esfuerzoEtapas: esfuerzoEtapas,
    tiempoEtapas: tiempoEtapas,
    costoEtapas: costoEtapas,
  );
}

