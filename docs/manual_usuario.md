# Manual de Usuario - Calculadora COCOMO Intermedio

## Índice
1. [Introducción](#introducción)
2. [Inicio Rápido](#inicio-rápido)
3. [Funcionalidades Principales](#funcionalidades-principales)
4. [Guía Paso a Paso](#guía-paso-a-paso)
5. [Preguntas Frecuentes](#preguntas-frecuentes)

## Introducción
La Calculadora COCOMO Intermedio es una herramienta diseñada para ayudar en la estimación de costos, tiempo y esfuerzo en proyectos de desarrollo de software. Esta guía te ayudará a utilizar todas las funcionalidades de la aplicación de manera efectiva.

## Inicio Rápido
1. Inicia la aplicación
2. Selecciona el modo de desarrollo (Orgánico, Moderado o Empotrado)
3. Ingresa el tamaño del proyecto en KLDC o utiliza el calculador de Puntos de Función
4. Ajusta los conductores de coste según las características de tu proyecto
5. Obtén los resultados de estimación

## Funcionalidades Principales

### 1. Modos de Desarrollo
- **Orgánico**: Para proyectos pequeños con equipos pequeños
- **Moderado**: Para proyectos medianos con equipos mixtos
- **Empotrado**: Para proyectos complejos con fuertes restricciones

### 2. Calculador de Puntos de Función
Permite calcular el tamaño del proyecto basado en:
- Entradas Externas
- Salidas Externas
- Consultas Externas
- Archivos Lógicos Internos
- Archivos de Interfaz Externa

### 3. Conductores de Coste
#### Atributos del Producto
- Fiabilidad requerida del software (RSS)
- Tamaño de la base de datos (TBD)
- Complejidad del producto (CPR)

#### Atributos de la Plataforma
- Restricciones de tiempo de ejecución (RTE)
- Restricciones de memoria principal (RMP)
- Volatilidad de la máquina virtual (VMC)
- Tiempo de respuesta requerido (TRC)

#### Atributos del Personal
- Capacidad de los analistas (CAN)
- Experiencia en la aplicación (EAN)
- Capacidad de los programadores (CPRO)
- Experiencia en S.O. utilizado (ESO)
- Experiencia en el lenguaje de programación (ELP)

#### Atributos del Proyecto
- Uso de técnicas/prácticas modernas (UTP)
- Utilización de herramientas software (UHS)
- Restricciones de planificación del proyecto (RPL)

## Guía Paso a Paso

### 1. Cálculo del Tamaño del Proyecto
a) Usando KLDC directamente:
   - Ingresa el número de miles de líneas de código estimadas
   
b) Usando Puntos de Función:
   - Selecciona el lenguaje de programación
   - Ingresa la cantidad de componentes por cada tipo
   - La aplicación convertirá automáticamente a KLDC

### 2. Selección de Conductores de Coste
- Para cada conductor, selecciona el nivel apropiado:
  - Muy Bajo
  - Bajo
  - Nominal
  - Alto
  - Muy Alto
  - Extra Alto (donde aplique)

### 3. Interpretación de Resultados
Los resultados mostrarán:
- Esfuerzo total en personas-mes
- Tiempo de desarrollo en meses
- Costo total del proyecto
- Distribución por etapas

## Preguntas Frecuentes

### ¿Qué es KLDC?
KLDC significa "Miles de Líneas de Código". Es una medida del tamaño del software.

### ¿Cómo elijo el modo correcto?
- **Orgánico**: Para equipos pequeños y proyectos relativamente simples
- **Moderado**: Para equipos y proyectos de tamaño medio
- **Empotrado**: Para proyectos complejos con muchas restricciones

### ¿Qué son los Puntos de Función?
Los Puntos de Función son una medida del tamaño del software basada en la funcionalidad, independiente del lenguaje de programación.

### ¿Cómo actualizo los valores?
Los cambios se actualizan automáticamente al modificar cualquier valor en la interfaz.

### ¿Puedo guardar mis estimaciones?
Sí, la aplicación permite guardar y cargar diferentes estimaciones para comparar escenarios. 