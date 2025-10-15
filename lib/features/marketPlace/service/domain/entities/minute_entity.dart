class MinuteEntity {
  final String id;
  final int minute;

  const MinuteEntity({required this.id, required this.minute});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MinuteEntity && other.id == id && other.minute == minute;
  }

  @override
  int get hashCode => id.hashCode ^ minute.hashCode;

  @override
  String toString() => 'minuteEntity(id: $id, minute: $minute)';
}
