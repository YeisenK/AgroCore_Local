class DetalleSiembraModel {
  final String cultivo;
  final String especificacion;
  final int cantidad;

  DetalleSiembraModel({
    required this.cultivo,
    required this.especificacion,
    required this.cantidad,
  });

  factory DetalleSiembraModel.fromJson(Map<String, dynamic> json) {
    return DetalleSiembraModel(
      cultivo: json['cultivo'] ?? 'Sin Cultivo',
      especificacion: json['especificacion'] ?? 'Sin Especificación',
      cantidad: int.tryParse(json['cantidad'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cultivo': cultivo,
      'especificacion': especificacion,
      'cantidad': cantidad,
    };
  }
}

class SiembraModel {
  final String id;
  final int lote;
  final DateTime fechaSiembra;
  final String tipoRiego;
  final String responsable;
  final List<TimelineEvent> timeline;

  final List<DetalleSiembraModel> detalles;

  SiembraModel({
    required this.id,
    required this.lote,
    required this.fechaSiembra,
    required this.tipoRiego,
    required this.responsable,
    this.timeline = const [],
    required this.detalles,
  });

  factory SiembraModel.fromJson(Map<String, dynamic> json) {
    var detallesList = <DetalleSiembraModel>[];
    if (json['detalles'] != null && json['detalles'] is List) {
      detallesList = (json['detalles'] as List)
          .map((item) => DetalleSiembraModel.fromJson(item))
          .toList();
    }

    return SiembraModel(
      id: json['id'].toString(),
      lote: int.tryParse(json['lote'].toString()) ?? 0,
      fechaSiembra: DateTime.parse(json['fechaSiembra']),
      tipoRiego: json['tipoRiego'] ?? 'No especificado',
      responsable: json['responsable'] ?? 'No asignado',
      timeline:
          (json['timeline'] as List<dynamic>?)
              ?.map((eventJson) => TimelineEvent.fromJson(eventJson))
              .toList() ??
          [],
      detalles: detallesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lote': lote,
      'fechaSiembra': fechaSiembra.toIso8601String(),
      'tipoRiego': tipoRiego,
      'responsable': responsable,
      'timeline': timeline.map((event) => event.toJson()).toList(),
      'detalles': detalles.map((detalle) => detalle.toJson()).toList(),
    };
  }
}

class TimelineEvent {
  final String titulo;
  final String descripcion;
  final DateTime fecha;

  TimelineEvent({
    required this.titulo,
    required this.descripcion,
    required this.fecha,
  });

  factory TimelineEvent.fromJson(Map<String, dynamic> json) {
    return TimelineEvent(
      titulo: json['titulo'] ?? 'Evento',
      descripcion: json['descripcion'] ?? '',
      fecha: DateTime.parse(json['fecha']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(),
    };
  }
}
