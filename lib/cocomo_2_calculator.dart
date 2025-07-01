import 'dart:math';
import 'package:flutter/material.dart';

const Map<String, Map<String, double>> costDriverValues = {
  // ----- PRODUCTO ----- //
  'RSS': {
    'Muy bajo': 0.82,
    'Bajo': 0.92,
    'Nominal': 1.00,
    'Alto': 1.10,
    'Muy alto': 1.26,
  },
  'TBD': {'Bajo': 0.90, 'Nominal': 1.00, 'Alto': 1.14, 'Muy alto': 1.28},
  'CPR': {
    'Muy bajo': 0.73,
    'Bajo': 0.87,
    'Nominal': 1.00,
    'Alto': 1.17,
    'Muy alto': 1.34,
    'Extra alto': 1.74,
  },
  'RUSE': {
    'Bajo': 0.95,
    'Nominal': 1.00,
    'Alto': 1.07,
    'Muy alto': 1.15,
    'Extra alto': 1.24,
  },
  'DOC': {
    'Muy bajo': 0.81,
    'Bajo': 0.91,
    'Nominal': 1.00,
    'Alto': 1.11,
    'Muy alto': 1.23,
  },
  // ----- PLATAFORMA ----- //
  'RTE': {'Nominal': 1.00, 'Alto': 1.11, 'Muy alto': 1.29, 'Extra alto': 1.63},
  'RMP': {'Nominal': 1.00, 'Alto': 1.05, 'Muy alto': 1.17, 'Extra alto': 1.46},
  'VMC': {'Bajo': 0.87, 'Nominal': 1.00, 'Alto': 1.15, 'Muy alto': 1.30},
  // ----- PERSONAL ----- //
  'CAN': {
    'Muy bajo': 1.42,
    'Bajo': 1.19,
    'Nominal': 1.00,
    'Alto': 0.85,
    'Muy alto': 0.71,
  },
  'EAPL': {
    'Muy bajo': 1.22,
    'Bajo': 1.10,
    'Nominal': 1.00,
    'Alto': 0.88,
    'Muy alto': 0.81,
  },
  'CPRO': {
    'Muy bajo': 1.34,
    'Bajo': 1.15,
    'Nominal': 1.00,
    'Alto': 0.88,
    'Muy alto': 0.76,
  },
  'CPER': {
    'Muy bajo': 1.29,
    'Bajo': 1.12,
    'Nominal': 1.00,
    'Alto': 0.90,
    'Muy alto': 0.81,
  },
  'EPLA': {
    'Muy bajo': 1.19,
    'Bajo': 1.09,
    'Nominal': 1.00,
    'Alto': 0.91,
    'Muy alto': 0.85,
  },
  'ELP': {
    'Muy bajo': 1.20,
    'Bajo': 1.09,
    'Nominal': 1.00,
    'Alto': 0.91,
    'Muy alto': 0.84,
  },
  // ----- PROYECTO ----- //
  'UHS': {
    'Muy bajo': 1.17,
    'Bajo': 1.09,
    'Nominal': 1.00,
    'Alto': 0.90,
    'Muy alto': 0.78,
  },
  'RPL': {
    'Muy bajo': 1.43,
    'Bajo': 1.14,
    'Nominal': 1.00,
    'Alto': 1.00,
    'Muy alto': 1.00,
  },
  'DMS': {
    'Muy bajo': 1.22,
    'Bajo': 1.09,
    'Nominal': 1.00,
    'Alto': 0.93,
    'Muy alto': 0.86,
    'Extra alto': 0.80,
  },
};

const Map<String, Map<String, double>> scaleFactorValues = {
  'PREC': {
    'Muy Bajo': 6.20,
    'Bajo': 4.96,
    'Nominal': 3.72,
    'Alto': 2.48,
    'Muy Alto': 1.24,
    'Extra Alto': 0.00,
  },
  'FLEX': {
    'Muy Bajo': 5.07,
    'Bajo': 4.05,
    'Nominal': 3.04,
    'Alto': 2.03,
    'Muy Alto': 1.01,
    'Extra Alto': 0.00,
  },
  'RESL': {
    'Muy Bajo': 7.07,
    'Bajo': 5.65,
    'Nominal': 4.24,
    'Alto': 2.83,
    'Muy Alto': 1.41,
    'Extra Alto': 0.00,
  },
  'TEAM': {
    'Muy Bajo': 5.48,
    'Bajo': 4.38,
    'Nominal': 3.29,
    'Alto': 2.19,
    'Muy Alto': 1.10,
    'Extra Alto': 0.00,
  },
  'PMAT': {
    'Muy Bajo': 7.80,
    'Bajo': 6.24,
    'Nominal': 4.68,
    'Alto': 3.12,
    'Muy Alto': 1.56,
    'Extra Alto': 0.00,
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
Map<String, double> esfuerzosGuardadosGlobal = {};
ValueNotifier<int> estimacionVersion = ValueNotifier<int>(0);

double exponenteBGlobal = 0.0;
double exponenteDGlobal = 0.0;

class Cocomo2Calculator {
  static const double A = 2.94;
  static const double B_BASE = 0.91;
  static const double C = 3.67;
  static const double D_BASE = 0.28;

  double calcularFactorEscala(Map<String, String> scaleFactors) {
    double sumOfFactors = 0.0;
    scaleFactors.forEach((name, level) {
      sumOfFactors += scaleFactorValues[name]?[level] ?? 0.0;
    });
    return (0.01 * sumOfFactors);
  }

  static calcularEsfuerzo(double kldc, double sf, double fec) {
    exponenteBGlobal = B_BASE + sf;
    return A * pow(kldc, exponenteBGlobal) * fec;
  }

  static double calcularTiempo(double esfuerzo, double sf) {
    exponenteDGlobal = D_BASE + (0.2 * sf);
    return C * pow(esfuerzo, exponenteDGlobal);
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
  final double exponentB;
  final double exponentD;
  final Map<String, double> esfuerzoEtapas;
  final Map<String, double> tiempoEtapas;
  final Map<String, double> costoEtapas;

  EstimacionResultado({
    required this.esfuerzoTotal,
    required this.tiempoTotal,
    required this.costoTotal,
    required this.exponentB,
    required this.exponentD,
    required this.esfuerzoEtapas,
    required this.tiempoEtapas,
    required this.costoEtapas,
  });
}

EstimacionResultado? calcularEstimacionCompleta({
  required double kldc,
  required double fec,
  required double sf,
  required Map<String, double> costosPM,
  required Map<String, double> esfuerzosPorcentaje,
}) {
  if (kldc <= 0 ||
      fec <= 0 ||
      sf <= 0 ||
      costosPM.isEmpty ||
      esfuerzosPorcentaje.isEmpty) {
    return null;
  }

  // final calculator = Cocomo2Calculator();

  final esfuerzoTotal = Cocomo2Calculator.calcularEsfuerzo(kldc, sf, fec);
  final tiempoTotal = Cocomo2Calculator.calcularTiempo(esfuerzoTotal, sf);

  final Map<String, double> esfuerzoEtapas = {};
  final Map<String, double> tiempoEtapas = {};
  final Map<String, double> costoEtapas = {};
  double costoTotal = 0.0;

  esfuerzosPorcentaje.forEach((etapa, porcentaje) {
    final fraccion = porcentaje / 100.0;
    final esfuerzoEtapa = esfuerzoTotal * fraccion;
    final tiempoEtapa = tiempoTotal * fraccion;
    final costoEtapa = esfuerzoEtapa * (costosPM[etapa] ?? 0);

    esfuerzoEtapas[etapa] = esfuerzoEtapa;
    tiempoEtapas[etapa] = tiempoEtapa;
    costoEtapas[etapa] = costoEtapa;

    costoTotal += costoEtapa;
  });

  return EstimacionResultado(
    esfuerzoTotal: esfuerzoTotal,
    tiempoTotal: tiempoTotal,
    costoTotal: costoTotal,
    exponentB: exponenteBGlobal,
    exponentD: exponenteDGlobal,
    esfuerzoEtapas: esfuerzoEtapas,
    tiempoEtapas: tiempoEtapas,
    costoEtapas: costoEtapas,
  );
}
