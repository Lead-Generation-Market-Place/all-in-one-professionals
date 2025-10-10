// mile_entity.dart
class MileEntity {
  final int id;
  final String name;
  final int miles;

  const MileEntity({required this.id, required this.name, required this.miles});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MileEntity &&
        other.id == id &&
        other.name == name &&
        other.miles == miles;
  }

  @override
  int get hashCode => Object.hash(id, name, miles);

  @override
  String toString() {
    return 'MileEntity(id: $id, name: $name, miles: $miles)';
  }
}
