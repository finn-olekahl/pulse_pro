class WarmUp {
  final WarmUpType type;
  final int duration;

  WarmUp({
    required this.type,
    required this.duration,
  });

  factory WarmUp.fromJson(Map<String, dynamic> json) {
    return WarmUp(
      type: WarmUpType.values[json['type']],
      duration: int.parse(json['duration']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'duration': duration,
    };
  }
}

enum WarmUpType {
  jogging,
  walking,
  cycling,
  jumpRope
}

