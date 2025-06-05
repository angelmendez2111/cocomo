# Guía de Desarrollo - Calculadora COCOMO 81 Intermedio

## Índice
1. [Configuración del Entorno](#configuración-del-entorno)
2. [Estándares de Código](#estándares-de-código)
3. [Estado Actual y Próximos Pasos](#estado-actual-y-próximos-pasos)
4. [Pruebas](#pruebas)
5. [Contribución](#contribución)

## Configuración del Entorno

### Requisitos Previos
1. **Flutter SDK** (^3.7.0)
   ```bash
   flutter doctor
   ```

2. **IDE Recomendado**
   - Visual Studio Code con extensiones:
     - Flutter
     - Dart
   - Android Studio con el plugin de Flutter

### Configuración Inicial
1. Clonar el repositorio:
   ```bash
   git clone [URL_del_repositorio]
   cd cocomo_software
   ```

2. Instalar dependencias:
   ```bash
   flutter pub get
   ```

3. Verificar la configuración:
   ```bash
   flutter doctor
   flutter analyze
   ```

## Estándares de Código

### 1. Estructura de Archivos
```
lib/
├── main.dart              # Punto de entrada
├── cocomo_calculator.dart # Implementación del modelo COCOMO
└── views/                # Interfaces de usuario
```

### 2. Convenciones de Nombrado
- **Archivos**: snake_case (ej: `cocomo_calculator.dart`)
- **Clases**: PascalCase (ej: `CocomoCalculator`)
- **Variables/Funciones**: camelCase (ej: `calculateEffort()`)
- **Constantes**: SCREAMING_SNAKE_CASE (ej: `MAX_KLOC`)

### 3. Documentación
```dart
/// Calcula el esfuerzo basado en el modelo COCOMO intermedio
/// 
/// [kloc] es el tamaño del proyecto en miles de líneas de código
/// [mode] es el modo de desarrollo (orgánico, moderado, empotrado)
/// Returns el esfuerzo en personas-mes
double calculateEffort(double kloc, String mode) {
  // Implementación
}
```

## Estado Actual y Próximos Pasos

### Implementado Actualmente
1. **Cálculos Base**
   - Modelo COCOMO 81 Intermedio
   - Cálculo de esfuerzo
   - Cálculo de tiempo de desarrollo
   - Factor de esfuerzo compuesto (FEC)

2. **Interfaz de Usuario**
   - Entrada de KLDC
   - Selección de modo de desarrollo
   - Ajuste de conductores de coste
   - Visualización de resultados

### Próximas Implementaciones
1. **Fase 1 - Mejoras Básicas**
   - Persistencia de datos
   - Validación mejorada de entrada
   - Mensajes de error descriptivos

2. **Fase 2 - Nuevas Características**
   - Cálculo de Puntos de Función
   - Conversión a KLDC
   - Exportación de resultados

3. **Fase 3 - Expansión**
   - Soporte multiplataforma
   - Internacionalización
   - Temas visuales

## Pruebas

### 1. Pruebas Unitarias
```dart
void main() {
  group('CocomoCalculator Tests', () {
    test('should calculate effort correctly', () {
      final calculator = CocomoCalculator();
      expect(
        calculator.calculateEffort(10, 'Orgánico'),
        closeTo(31.8, 0.1),
      );
    });
  });
}
```

### 2. Pruebas de Widget
```dart
void main() {
  testWidgets('Calculator UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text('COCOMO Calculator'), findsOneWidget);
  });
}
```

## Contribución

### 1. Proceso de Pull Request
1. Actualizar la rama local:
   ```bash
   git checkout main
   git pull origin main
   ```

2. Crear rama feature/fix

3. Hacer commits con mensajes descriptivos:
   ```
   feat: implementar cálculo de esfuerzo
   
   - Añadir función de cálculo
   - Implementar validación de entrada
   - Agregar pruebas unitarias
   ```

### 2. Revisión de Código
- Verificar cálculos correctos
- Asegurar validación de entrada
- Comprobar manejo de errores
- Revisar documentación actualizada

### 3. Prioridades Actuales
1. Estabilidad del código existente
2. Precisión en los cálculos
3. Validación de entrada robusta
4. Documentación clara y actualizada

## Mejores Prácticas

### 1. Rendimiento
- Evitar cálculos pesados en el hilo principal
- Implementar lazy loading cuando sea posible
- Optimizar rebuilds de widgets

### 2. Seguridad
- No exponer información sensible
- Validar todas las entradas de usuario
- Manejar errores apropiadamente

### 3. Accesibilidad
- Implementar soporte para lectores de pantalla
- Mantener contraste adecuado
- Proporcionar textos alternativos

### 4. Internacionalización
- Usar archivos de strings localizados
- Soportar diferentes formatos de números
- Considerar diferentes tamaños de texto 