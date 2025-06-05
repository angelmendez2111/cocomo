# Documentación Técnica - Calculadora COCOMO 81 Intermedio

## Índice
1. [Arquitectura del Sistema](#arquitectura-del-sistema)
2. [Estructura del Proyecto](#estructura-del-proyecto)
3. [Componentes Principales](#componentes-principales)
4. [Algoritmos y Fórmulas](#algoritmos-y-fórmulas)
5. [Implementación Actual](#implementación-actual)

## Arquitectura del Sistema

### Visión General
La aplicación implementa el modelo COCOMO 81 Intermedio utilizando Flutter. La arquitectura actual se centra en los cálculos del modelo intermedio y la interfaz de usuario básica.

### Tecnologías Utilizadas
- **Framework**: Flutter ^3.7.0
- **Lenguaje**: Dart ^3.7.0
- **UI**: Material Design

## Estructura del Proyecto

```
cocomo_software/
├── lib/
│   ├── main.dart
│   ├── cocomo_intermedio_calculator.dart
│   └── views/
│       └── [archivos de vistas]
├── test/
└── pubspec.yaml
```

## Componentes Principales

### 1. Calculadora COCOMO
```dart
class CocomoCalculator {
  static const Map<String, Map<String, double>> _coeficientes = {
    'Orgánico': {'a': 3.2, 'b': 1.05, 'c': 0.38},
    'Moderado': {'a': 3.0, 'b': 1.12, 'c': 0.35},
    'Empotrado': {'a': 2.8, 'b': 1.20, 'c': 0.32},
  };
}
```

### 2. Conductores de Coste
Los conductores de coste implementados están organizados en cuatro categorías:
- Atributos del Producto
- Atributos de la Plataforma
- Atributos del Personal
- Atributos del Proyecto

## Algoritmos y Fórmulas

### 1. Cálculo de Esfuerzo
```
Esfuerzo = a * (KLDC)^b * FEC
Donde:
- a, b: coeficientes según el modo de desarrollo
- KLDC: Miles de líneas de código
- FEC: Factor de esfuerzo compuesto
```

### 2. Cálculo de Tiempo de Desarrollo
```
Tiempo = c * (Esfuerzo)^d
Donde:
- c, d: coeficientes según el modo de desarrollo
```

### 3. Factor de Esfuerzo Compuesto (FEC)
```
FEC = Π (Multiplicadores de Esfuerzo)
```

## Implementación Actual

### Estructura de Datos
Los datos se manejan utilizando las siguientes estructuras:

1. **Estimación**
```dart
class EstimacionResultado {
  final double esfuerzoTotal;
  final double tiempoTotal;
  final double costoTotal;
}
```

2. **Conductores de Coste**
```dart
const Map<String, Map<String, double>> costDriverValues = {
  'RSS': {
    'Muy bajo': 0.75,
    'Bajo': 0.88,
    'Nominal': 1.00,
    'Alto': 1.15,
    'Muy alto': 1.40,
  },
  // ... otros conductores
};
```

### Estado de Desarrollo Actual

#### Funcionalidades Implementadas
- ✅ Cálculo básico de COCOMO 81 Intermedio
- ✅ Interfaz para ingreso de KLDC
- ✅ Selección de modo de desarrollo
- ✅ Ajuste de conductores de coste
- ✅ Cálculo de esfuerzo y tiempo

#### Pendiente de Implementación
- Almacenamiento persistente de estimaciones
- Cálculo de Puntos de Función
- Soporte multiplataforma completo
- Exportación de resultados

### Configuración de Desarrollo
1. Clonar el repositorio
2. Ejecutar `flutter pub get`
3. Ejecutar `flutter run`

### Pruebas
Las pruebas actuales se centran en:
- Cálculos del modelo COCOMO
- Validación de entrada de datos
- Funcionamiento de conductores de coste 