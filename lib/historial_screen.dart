import 'package:flutter/material.dart';
import 'servicios/firestore_service.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  late Future<List<Map<String, dynamic>>> _historial;

  @override
  void initState() {
    super.initState();
    _historial = _firestoreService.obtenerHistorial();
  }

  void _recargarHistorial() {
    setState(() {
      _historial = _firestoreService.obtenerHistorial();
    });
  }

  String _formatearFecha(String fecha) {
    final partes = fecha.split('-');

    if (partes.length != 3) {
      return fecha;
    }

    return '${partes[2]}/${partes[1]}/${partes[0]}';
  }

  int _contarCumplidos(dynamic lista) {
    if (lista is! List) {
      return 0;
    }

    return lista.where((elemento) => elemento == true).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de hábitos'),
        centerTitle: true,
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _historial,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text('Error al cargar el historial'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _recargarHistorial,
                    child: const Text('Intentar nuevamente'),
                  ),
                ],
              ),
            );
          }

          final dias = snapshot.data ?? [];

          if (dias.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay registros todavía',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Completa tus hábitos para comenzar.',
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _recargarHistorial();
              await _historial;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dias.length,
              itemBuilder: (context, index) {
                final dia = dias[index];

                final fecha = dia['fecha']?.toString() ?? '';
                final cumplidos = _contarCumplidos(dia['cumplidos']);
                final meta = dia['meta'] ?? 3;
                final nota = dia['nota']?.toString() ?? '';
                final enfoque = dia['enfoque'] == true;

                final progreso = cumplidos / 5;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _formatearFecha(fecha),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$cumplidos de 5 hábitos',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${(progreso * 100).round()}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        LinearProgressIndicator(
                          value: progreso,
                          minHeight: 8,
                        ),

                        const SizedBox(height: 12),

                        Text('Meta del día: $meta hábitos'),

                        const SizedBox(height: 4),

                        Text(
                          enfoque
                              ? 'Modo enfoque: Activado'
                              : 'Modo enfoque: Desactivado',
                        ),

                        if (nota.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Divider(),
                          const Text(
                            'Nota del día:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(nota),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}