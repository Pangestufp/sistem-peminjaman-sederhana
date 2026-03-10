class Assign {
  final int index;
  final int pararel;
  final String assignnedName;
  final String action;

  Assign({
    required this.index,
    required this.pararel,
    required this.assignnedName,
    required this.action,
  });

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'pararel': pararel,
      'assignnedName': assignnedName,
      'action': action,
    };
  }


  Assign copyWith({
    int? index,
    int? pararel,
    String? assignnedName,
    String? action,
  }) {
    return Assign(
      index: index ?? this.index,
      pararel: pararel ?? this.pararel,
      assignnedName: assignnedName ?? this.assignnedName,
      action: action ?? this.action,
    );
  }

}
