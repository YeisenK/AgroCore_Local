import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:main/features/gestion_siembra/models/siembra_model.dart';
import 'package:main/features/gestion_siembra/notifiers/siembra_notifier.dart';

class SiembraFormScreen extends StatefulWidget {
  final SiembraModel? siembra;

  const SiembraFormScreen({super.key, this.siembra});

  @override
  State<SiembraFormScreen> createState() => _SiembraFormScreenState();
}

class _SiembraFormScreenState extends State<SiembraFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _loteController;
  late TextEditingController _especificacionController;
  late TextEditingController _responsableController;
  DateTime? _fechaSeleccionada;

  bool _isEditMode = false;

  // --- Lista de opciones para Cultivos ---
  final List<String> _cultivosDisponibles = [
    'Tomate',
    'Chile',
    'Calabaza',
    'Aguacate',
    'Maíz',
    'Frijol',
    'Lechuga',
  ];
  String? _cultivoSeleccionado;

  final List<String> _tiposRiegoDisponibles = ['Aspersor', 'Manual'];
  String? _tipoRiegoSeleccionado;

  @override
  void initState() {
    super.initState();
    _isEditMode = (widget.siembra != null);

    if (_isEditMode) {
      _loteController = TextEditingController(text: widget.siembra!.lote);

      if (_cultivosDisponibles.contains(widget.siembra!.cultivo)) {
        _cultivoSeleccionado = widget.siembra!.cultivo;
      }

      if (_tiposRiegoDisponibles.contains(widget.siembra!.tipoRiego)) {
        _tipoRiegoSeleccionado = widget.siembra!.tipoRiego;
      }

      _especificacionController = TextEditingController(
        text: widget.siembra!.especificacion,
      );
      _responsableController = TextEditingController(
        text: widget.siembra!.responsable,
      );
      _fechaSeleccionada = widget.siembra!.fechaSiembra;
    } else {
      _loteController = TextEditingController();
      _cultivoSeleccionado = null;
      _tipoRiegoSeleccionado = null;
      _especificacionController = TextEditingController();
      _responsableController = TextEditingController();
    }
  }

  void _guardarFormulario() {
    if (!_formKey.currentState!.validate() || _fechaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa los campos obligatorios.'),
        ),
      );
      return;
    }

    final notifier = Provider.of<SiembraNotifier>(context, listen: false);

    final siembraGuardada = SiembraModel(
      id: _isEditMode ? widget.siembra!.id : const Uuid().v4(),
      lote: _loteController.text,
      cultivo: _cultivoSeleccionado!,
      fechaSiembra: _fechaSeleccionada!,
      especificacion: _especificacionController.text,
      tipoRiego: _tipoRiegoSeleccionado ?? 'No especificado',
      responsable: _responsableController.text,
      timeline: _isEditMode ? widget.siembra!.timeline : [],
    );

    if (_isEditMode) {
      notifier.actualizarSiembra(siembraGuardada);
    } else {
      notifier.addSiembra(siembraGuardada);
    }

    Navigator.of(context).pop();
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(24.0),
      constraints: BoxConstraints(
        maxWidth: 500,
        maxHeight: screenSize.height * 0.9,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEditMode ? 'Editar Siembra' : 'Agregar Siembra',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _loteController,
                decoration: const InputDecoration(labelText: 'Lote *'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _cultivoSeleccionado,
                decoration: const InputDecoration(labelText: 'Cultivo *'),
                items: _cultivosDisponibles.map((String cultivo) {
                  return DropdownMenuItem<String>(
                    value: cultivo,
                    child: Text(cultivo),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _cultivoSeleccionado = newValue;
                  });
                },
                validator: (value) =>
                    (value == null) ? 'Selecciona un cultivo' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _especificacionController,
                decoration: const InputDecoration(labelText: 'Especificación'),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _tipoRiegoSeleccionado,
                decoration: const InputDecoration(labelText: 'Tipo de Riego'),
                items: _tiposRiegoDisponibles.map((String tipo) {
                  return DropdownMenuItem<String>(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _tipoRiegoSeleccionado = newValue;
                  });
                },
              ),

              const SizedBox(height: 12),
              TextFormField(
                controller: _responsableController,
                decoration: const InputDecoration(labelText: 'Responsable'),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      _fechaSeleccionada == null
                          ? 'Fecha de siembra *'
                          : 'Fecha: ${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: _seleccionarFecha,
                    child: Text(_isEditMode ? 'Cambiar' : 'Seleccionar'),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _guardarFormulario,
                    child: Text(_isEditMode ? 'Guardar Cambios' : 'Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
