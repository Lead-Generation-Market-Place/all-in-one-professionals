class Service {
  final int id;
  final String name;
  final bool active;
  final bool completed;
  final String description;
  final ServiceMetrics metrics;
  final SetupProgress?
  setupProgress; // Optional because not all services have it

  Service({
    required this.id,
    required this.name,
    required this.active,
    required this.completed,
    required this.description,
    required this.metrics,
    this.setupProgress,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      active: json['active'],
      completed: json['completed'],
      description: json['description'],
      metrics: ServiceMetrics.fromJson(json['metrics']),
      setupProgress: json['setupProgress'] != null
          ? SetupProgress.fromJson(json['setupProgress'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'active': active,
      'completed': completed,
      'description': description,
      'metrics': metrics.toJson(),
      'setupProgress': setupProgress?.toJson(),
    };
  }
}

class ServiceMetrics {
  final String spent;
  final int leads;
  final int views;

  ServiceMetrics({
    required this.spent,
    required this.leads,
    required this.views,
  });

  factory ServiceMetrics.fromJson(Map<String, dynamic> json) {
    return ServiceMetrics(
      spent: json['spent'],
      leads: json['leads'],
      views: json['views'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'spent': spent, 'leads': leads, 'views': views};
  }
}

class SetupProgress {
  final bool questions;
  final bool pricing;
  final bool availability;
  final bool serviceArea;

  SetupProgress({
    required this.questions,
    required this.pricing,
    required this.availability,
    required this.serviceArea,
  });

  factory SetupProgress.fromJson(Map<String, dynamic> json) {
    return SetupProgress(
      questions: json['questions'],
      pricing: json['pricing'],
      availability: json['availability'],
      serviceArea: json['serviceArea'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questions': questions,
      'pricing': pricing,
      'availability': availability,
      'serviceArea': serviceArea,
    };
  }
}
