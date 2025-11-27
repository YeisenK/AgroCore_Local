import 'package:flutter/material.dart';
import 'dart:developer';
import '../models/siembra_model.dart';
import '../repositories/mock_siembra_repository.dart';

class SiembraNotifier extends ChangeNotifier {
  final MockSiembraRepository _repository;

  SiembraNotifier(this._repository) {
    fetchSiembras();
  }

  bool _isLoading = false;
  List<SiembraModel> _siembras = [];

  bool get isLoading => _isLoading;
  List<SiembraModel> get siembras => _siembras;

  bool checkLoteExists(int lote, {String? siembraIdToIgnore}) {
    return _siembras.any((siembra) {
      final bool isSameLote = siembra.lote == lote;

      final bool isDifferentItem = siembra.id != siembraIdToIgnore;

      return isSameLote && isDifferentItem;
    });
  }

  Future<void> fetchSiembras() async {
    _isLoading = true;
    notifyListeners();
    try {
      _siembras = await _repository.getSiembras();
    } catch (e) {
      log('Error al cargar las siembras: $e');
      _siembras = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addSiembra(SiembraModel nuevaSiembra) async {
    try {
      _repository.addSiembra(nuevaSiembra); 
      _siembras.add(nuevaSiembra); 
      notifyListeners();
    } catch (e) {
      log('Error al añadir la siembra: $e');
    }
  }

  Future<void> actualizarSiembra(SiembraModel siembraActualizada) async {
    try {
      _repository.actualizarSiembra(
        siembraActualizada,
      );

      final index = _siembras.indexWhere((s) => s.id == siembraActualizada.id);
      if (index != -1) {
        _siembras[index] = siembraActualizada;
        notifyListeners();
      }
    } catch (e) {
      log('Error al actualizar la siembra: $e');
    }
  }

  Future<void> eliminarSiembra(String id) async {
    try {
      _repository.eliminarSiembra(id);
      _siembras.removeWhere((s) => s.id == id);
      notifyListeners();
    } catch (e) {
      log('Error al eliminar la siembra: $e');
    }
  }
}
