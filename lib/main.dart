import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Panel de hábitos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const PanelHabitos(),
    );
  }
}

class PanelHabitos extends StatefulWidget {
  const PanelHabitos({super.key});

  @override
  State<PanelHabitos> createState() => _PanelHabitosState();
}

class _PanelHabitosState extends State<PanelHabitos> {
  // ------------------------------------------------------------
  // HÁBITOS FIJOS
  // ------------------------------------------------------------

  final List<String> _habitos = const [
    'Beber 2 L de agua',
    'Leer 20 minutos',
    'Caminar 30 minutos',
    'Estudiar Flutter',
    'Dormir 8 horas',
  ];

  // ------------------------------------------------------------
  // VARIABLES DE ESTADO
  // ------------------------------------------------------------

  late List<bool> _cumplidos;

  int _meta = 3;

  bool _enfoque = false;

  String _nota = '';

  final TextEditingController _notaCtrl = TextEditingController();

  static const int _metaInicial = 3;

  // ------------------------------------------------------------
  // INICIALIZACIÓN
  // ------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    _cumplidos = List<bool>.filled(_habitos.length, false);
  }

  // ------------------------------------------------------------
  // LIBERAR RECURSOS
  // ------------------------------------------------------------

  @override
  void dispose() {
    _notaCtrl.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // GETTERS
  // ------------------------------------------------------------

  int get _totalCumplidos {
    return _cumplidos.where((cumplido) => cumplido).length;
  }

  double get _progreso {
    if (_habitos.isEmpty) {
      return 0;
    }

    return _totalCumplidos / _habitos.length;
  }

  bool get _metaAlcanzada {
    return _totalCumplidos >= _meta;
  }

  String get _mensaje {
    final porcentaje = (_progreso * 100).round();

    if (porcentaje == 0) {
      return '¡Empecemos!';
    }

    if (porcentaje < 50) {
      return 'Buen inicio';
    }

    if (porcentaje < 100) {
      return '¡Vas muy bien!';
    }

    return '¡Día completado! 🎉';
  }

  // ------------------------------------------------------------
  // CAMBIAR ESTADO DE UN HÁBITO
  // ------------------------------------------------------------

  void _alternarHabito(int index) {
    setState(() {
      _cumplidos[index] = !_cumplidos[index];
    });
  }

  // ------------------------------------------------------------
  // CAMBIAR META
  // ------------------------------------------------------------

  void _cambiarMeta(double valor) {
    setState(() {
      _meta = valor.round();
    });
  }

  // ------------------------------------------------------------
  // ACTIVAR / DESACTIVAR MODO ENFOQUE
  // ------------------------------------------------------------

  void _alternarEnfoque(bool valor) {
    setState(() {
      _enfoque = valor;
    });
  }

  // ------------------------------------------------------------
  // GUARDAR NOTA
  // ------------------------------------------------------------

  void _guardarNota() {
    setState(() {
      _nota = _notaCtrl.text.trim();
    });
  }

  // ------------------------------------------------------------
  // REINICIAR EL DÍA
  // ------------------------------------------------------------

  void _reiniciarDia() {
    setState(() {
      _cumplidos = List<bool>.filled(_habitos.length, false);

      _nota = '';

      _meta = _metaInicial;

      _enfoque = false;

      _notaCtrl.clear();
    });
  }

  // ------------------------------------------------------------
  // INTERFAZ
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hábitos — Cumplidos: $_totalCumplidos / ${_habitos.length}',
        ),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ------------------------------------------------------
          // ENCABEZADO
          // ------------------------------------------------------

          const Text(
            'Panel de hábitos del día',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            'Sigue tu progreso y completa tus hábitos.',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),

          const SizedBox(height: 20),

          // ------------------------------------------------------
          // PROGRESO
          // ------------------------------------------------------
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progreso del día',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        '${(_progreso * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  LinearProgressIndicator(value: _progreso, minHeight: 10),

                  const SizedBox(height: 12),

                  Text(
                    '$_totalCumplidos de ${_habitos.length} hábitos completados',
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: Text(
                      _mensaje,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ------------------------------------------------------
          // META DEL DÍA
          // ------------------------------------------------------
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meta del día',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Slider(
                    value: _meta.toDouble(),
                    min: 1,
                    max: _habitos.length.toDouble(),
                    divisions: _habitos.length - 1,
                    label: '$_meta',
                    onChanged: _cambiarMeta,
                  ),

                  Center(
                    child: Text(
                      'Meta: $_meta hábitos',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  if (_metaAlcanzada)
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),

                          SizedBox(width: 6),

                          Text(
                            'Meta alcanzada',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ------------------------------------------------------
          // MODO ENFOQUE
          // ------------------------------------------------------
          Card(
            child: SwitchListTile(
              title: const Text(
                'Modo enfoque',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Ocultar hábitos que ya completaste'),
              value: _enfoque,
              onChanged: _alternarEnfoque,
            ),
          ),

          const SizedBox(height: 16),

          // ------------------------------------------------------
          // LISTA DE HÁBITOS
          // ------------------------------------------------------
          const Text(
            'Mis hábitos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          ...List.generate(_habitos.length, (index) {
            // En modo enfoque ocultamos
            // los hábitos ya completados.
            if (_enfoque && _cumplidos[index]) {
              return const SizedBox.shrink();
            }

            return Card(
              child: CheckboxListTile(
                value: _cumplidos[index],
                onChanged: (_) {
                  _alternarHabito(index);
                },
                title: Text(_habitos[index]),
                secondary: Icon(
                  _cumplidos[index]
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: _cumplidos[index] ? Colors.green : Colors.grey,
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // ------------------------------------------------------
          // NOTA DEL DÍA
          // ------------------------------------------------------
          const Text(
            'Nota del día',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: _notaCtrl,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Escribe una nota sobre tu día...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (_) {
              _guardarNota();
            },
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _guardarNota,
              icon: const Icon(Icons.save),
              label: const Text('Guardar nota'),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.note, color: Colors.green),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      _nota.isEmpty ? 'Sin nota' : _nota,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ------------------------------------------------------
          // REINICIAR
          // ------------------------------------------------------
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _reiniciarDia,
              icon: const Icon(Icons.refresh),
              label: const Text('Reiniciar día'),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
