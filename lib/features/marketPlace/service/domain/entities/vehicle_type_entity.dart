class VehicleTypeEntity {
  final String id;
  final String vehicle_type;

  const VehicleTypeEntity({required this.id, required this.vehicle_type});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VehicleTypeEntity &&
        other.id == id &&
        other.vehicle_type == vehicle_type;
  }

  @override
  int get hashCode => id.hashCode ^ vehicle_type.hashCode;

  @override
  String toString() => 'vehicleTypeEntity(id: $id, minute: $vehicle_type)';
}
