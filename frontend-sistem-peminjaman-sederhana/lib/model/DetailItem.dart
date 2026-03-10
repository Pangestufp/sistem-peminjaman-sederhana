class DetailItem {
  final String text;
  final int subtotal;

  DetailItem({required this.text, required this.subtotal});

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'subtotal': subtotal,
    };
  }
}
