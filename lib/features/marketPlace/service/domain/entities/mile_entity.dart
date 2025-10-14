class MileEntity {
  final String id;
  final int mile;

  const MileEntity({required this.id, required this.mile});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MileEntity && other.id == id && other.mile == mile;
  }

  @override
  int get hashCode => id.hashCode ^ mile.hashCode;

  @override
  String toString() => 'MileEntity(id: $id, mile: $mile)';
}
