import 'dart:math';
import 'package:flutter/foundation.dart'; // Para ValueNotifier

// --- DATOS Y CONSTANTES DEL MODELO UCP ---

// Pesos para los tipos de actores
const Map<String, int> pesosActores = {'Simple': 1, 'Medio': 2, 'Complejo': 3};

// Pesos para los tipos de casos de uso (basado en transacciones)
const Map<String, int> pesosCasosDeUso = {
  'Simple': 5,
  'Medio': 10,
  'Complejo': 15,
};

// Definición de los Factores Técnicos
const List<Map<String, dynamic>> factoresTecnicosData = [
  {'id': 'T1', 'desc': 'Sistema Distribuido', 'peso': 2.0},
  {'id': 'T2', 'desc': 'Desempeño', 'peso': 1.0},
  {'id': 'T3', 'desc': 'Eficiencia del usuario', 'peso': 1.0},
  {'id': 'T4', 'desc': 'Complejidad proc. interno', 'peso': 1.0},
  {'id': 'T5', 'desc': 'Reusabilidad del código', 'peso': 1.0},
  {'id': 'T6', 'desc': 'Facilidad de instalación', 'peso': 0.5},
  {'id': 'T7', 'desc': 'Facilidad de uso', 'peso': 0.5},
  {'id': 'T8', 'desc': 'Portabilidad', 'peso': 2.0},
  {'id': 'T9', 'desc': 'Facilidad de cambio', 'peso': 1.0},
  {'id': 'T10', 'desc': 'Concurrencia', 'peso': 1.0},
  {'id': 'T11', 'desc': 'Seguridad especial', 'peso': 1.0},
  {'id': 'T12', 'desc': 'Acceso a terceros', 'peso': 1.0},
  {'id': 'T13', 'desc': 'Facilidades de entrenamiento', 'peso': 1.0},
];

// Definición de los Factores Ambientales
const List<Map<String, dynamic>> factoresAmbientalesData = [
  {'id': 'F1', 'desc': 'Familiaridad con P.U.', 'peso': 1.5},
  {'id': 'F2', 'desc': 'Experiencia en aplicaciones', 'peso': 0.5},
  {'id': 'F3', 'desc': 'Experiencia en OO', 'peso': 1.0},
  {'id': 'F4', 'desc': 'Capacidad del jefe', 'peso': 0.5},
  {'id': 'F5', 'desc': 'Motivación', 'peso': 1.0},
  {'id': 'F6', 'desc': 'Estabilidad requerimientos', 'peso': 2.0},
  {'id': 'F7', 'desc': 'Personal a tiempo parcial', 'peso': -1.0},
  {'id': 'F8', 'desc': 'Lenguaje de prog. difícil', 'peso': -1.0},
];

// --- CLASE CONTENEDORA DE RESULTADOS ---

class UCPEstimacionResultado {
  final double pcusa;
  final double fct;
  final double fa;
  final double pcua;
  final double esfuerzo;
  final int x;
  final int y;
  final int tasa;

  UCPEstimacionResultado({
    required this.pcusa,
    required this.fct,
    required this.fa,
    required this.pcua,
    required this.esfuerzo,
    required this.x,
    required this.y,
    required this.tasa,
  });
}

// --- CLASE CALCULADORA ---

class UseCasePointsCalculator {
  // Calcula el Peso de los Actores (PA)
  double calcularPA({
    required int cantSimples,
    required int cantMedios,
    required int cantComplejos,
  }) {
    return (cantSimples * pesosActores['Simple']! +
            cantMedios * pesosActores['Medio']! +
            cantComplejos * pesosActores['Complejo']!)
        .toDouble();
  }

  // Calcula el Peso de los Casos de Uso (PCU)
  double calcularPCU({
    required int cantSimples,
    required int cantMedios,
    required int cantComplejos,
  }) {
    return (cantSimples * pesosCasosDeUso['Simple']! +
            cantMedios * pesosCasosDeUso['Medio']! +
            cantComplejos * pesosCasosDeUso['Complejo']!)
        .toDouble();
  }

  // Calcula el Factor de Complejidad Técnica (FCT)
  double calcularFCT(List<int> valoresAsignados) {
    double sumaValorFactor = 0;
    for (int i = 0; i < factoresTecnicosData.length; i++) {
      sumaValorFactor += factoresTecnicosData[i]['peso'] * valoresAsignados[i];
    }
    return 0.6 + (0.01 * sumaValorFactor);
  }

  // Calcula el Factor de Ambiente (FA)
  double calcularFA(List<int> valoresAsignados) {
    double sumaValorFactor = 0;
    for (int i = 0; i < factoresAmbientalesData.length; i++) {
      sumaValorFactor +=
          factoresAmbientalesData[i]['peso'] * valoresAsignados[i];
    }
    return 1.4 + (-0.03 * sumaValorFactor);
  }

  // Calcula el Esfuerzo final
  double calcularEsfuerzo(double pcua, List<int> valoresAmbientales) {
    int x = 0; // F1-F6 < 3
    int y = 0; // F7-F8 > 3

    for (int i = 0; i < 6; i++) {
      if (valoresAmbientales[i] < 3) x++;
    }
    for (int i = 6; i < 8; i++) {
      if (valoresAmbientales[i] > 3) y++;
    }

    int tasa = (x + y <= 2) ? 20 : 28;
    return pcua * tasa;
  }

  // Devuelve los factores X e Y para mostrarlos en la UI
  Map<String, int> getFactoresXY(List<int> valoresAmbientales) {
    int x = 0;
    int y = 0;
    for (int i = 0; i < 6; i++) {
      if (valoresAmbientales[i] < 3) x++;
    }
    for (int i = 6; i < 8; i++) {
      if (valoresAmbientales[i] > 3) y++;
    }
    return {'x': x, 'y': y, 'tasa': (x + y <= 2) ? 20 : 28};
  }
}
