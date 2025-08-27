class Crypto {
  final String id;
  final String name;
  final String symbol;
  final double price;
  final double change;
  final String imageUrl;

  Crypto({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.imageUrl,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      id: json['id'] as String,
      name: json['name'] as String,
      symbol: (json['symbol'] as String).toUpperCase(),
      price: (json['current_price'] as num).toDouble(),
      change: (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image'] as String, // 👈 maps API field
    );
  }
}
