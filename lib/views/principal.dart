import 'package:flutter/material.dart';
import 'cocomo81.dart';

class PrincipalView extends StatelessWidget {
  const PrincipalView({super.key});

  static final Cocomo81View _cocomo81View = Cocomo81View();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('COCOMO Estimator'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        toolbarHeight: 60,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                TextButton(onPressed: () {}, child: const Text('Archivo')),
                TextButton(onPressed: () {}, child: const Text('Ver')),
                TextButton(onPressed: () {}, child: const Text('Herramientas')),
                TextButton(onPressed: () {}, child: const Text('Ayuda')),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Software de Estimación',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Estime el esfuerzo, tiempo y costo de desarrollo de software\nutilizando diferentes modelos de estimación',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _EstimacionCard(
                    titulo: 'COCOMO-81 Intermedio',
                    descripcion:
                        'Modelo original de Boehm que utiliza conductores de coste para estimar el esfuerzo, tiempo y costo de desarrollo.',
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => _cocomo81View,
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 32),
                  _EstimacionCard(
                    titulo: 'COCOMO II Post-Arquit',
                    descripcion:
                        'Versión actualizada que incluye conductores de escala y factores de esfuerzo para proyectos modernos.',
                    onPressed: () {},
                  ),
                  const SizedBox(width: 32),
                  _EstimacionCard(
                    titulo: 'Puntos de Casos de Uso',
                    descripcion:
                        'Estimación basada en la complejidad de los casos de uso del sistema con factores de ajuste.',
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

class _EstimacionCard extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final VoidCallback onPressed;

  const _EstimacionCard({
    required this.titulo,
    required this.descripcion,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.black26),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                descripcion,
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onPressed,
                  child: const Text('Estimar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}