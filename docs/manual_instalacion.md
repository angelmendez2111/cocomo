# Manual de Instalación - Calculadora COCOMO 81 Intermedio

## 1. Requisitos del Sistema

### 1.1 Requisitos de Hardware
- Procesador: 1.1 GHz o superior
- Memoria RAM: 4 GB mínimo
- Espacio en disco: 400 MB mínimo para Flutter y la aplicación
- Conexión a Internet (para la instalación inicial)

### 1.2 Requisitos de Software
- Sistema Operativo: Windows 10 o superior
- Flutter SDK versión 3.7.0 o superior
- Dart SDK versión 3.7.0 o superior
- Git (para clonar el repositorio)

## 2. Instalación de Herramientas Necesarias

### 2.1 Instalar Git
1. Descargar Git desde: https://git-scm.com/downloads
2. Ejecutar el instalador
3. Seguir las instrucciones del asistente de instalación
4. Verificar la instalación abriendo una terminal y escribiendo:
   ```bash
   git --version
   ```

### 2.2 Instalar Flutter
1. Descargar Flutter SDK desde: https://flutter.dev/docs/get-started/install/windows
2. Extraer el archivo zip en la ubicación deseada (por ejemplo, `C:\src\flutter`)
3. Agregar Flutter a las variables de entorno del sistema:
   - Buscar "Variables de entorno" en Windows
   - En "Variables de sistema", editar "Path"
   - Agregar la ruta `C:\src\flutter\bin`
4. Verificar la instalación:
   ```bash
   flutter doctor
   ```

## 3. Instalación de la Aplicación

### 3.1 Obtener el Código Fuente
1. Abrir una terminal
2. Navegar a la ubicación donde desea clonar el proyecto
3. Ejecutar:
   ```bash
   git clone https://github.com/angelmendez2111/cocomo.git
   cd cocomo
   ```

### 3.2 Instalar Dependencias
1. En la terminal, dentro del directorio del proyecto, ejecutar:
   ```bash
   flutter pub get
   ```

### 3.3 Compilar y Ejecutar
1. Para ejecutar en modo debug:
   ```bash
   flutter run
   ```

2. Para generar una versión de lanzamiento:
   ```bash
   flutter build windows
   ```
   El ejecutable se generará en: `build\windows\runner\Release`

## 4. Solución de Problemas Comunes

### 4.1 Flutter Doctor Muestra Errores
- Ejecutar `flutter doctor` y seguir las recomendaciones para cada error
- Asegurarse de que todas las dependencias estén correctamente instaladas
- Verificar las variables de entorno

### 4.2 Errores de Compilación
1. Limpiar la caché del proyecto:
   ```bash
   flutter clean
   flutter pub get
   ```

2. Actualizar Flutter:
   ```bash
   flutter upgrade
   ```

### 4.3 Errores de Ejecución
- Verificar que el sistema operativo cumpla con los requisitos mínimos
- Asegurarse de tener los permisos necesarios en el directorio de instalación
- Comprobar que no haya conflictos con antivirus

## 5. Verificación de la Instalación

### 5.1 Prueba Básica
1. Ejecutar la aplicación
2. Verificar que se muestre la interfaz principal
3. Probar un cálculo básico:
   - Seleccionar modo "Orgánico"
   - Ingresar un valor KLDC (por ejemplo, 10)
   - Verificar que se muestren los resultados

### 5.2 Contacto para Soporte
En caso de problemas con la instalación, contactar a:
[Tu información de contacto]

## 6. Notas Adicionales
- Se recomienda mantener actualizado el sistema operativo
- La aplicación está optimizada para Windows 10/11
- Realizar copias de seguridad antes de actualizar la aplicación
- Mantener Flutter actualizado para mejor compatibilidad 