class Shop {
  final int id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;
  final String? bannerUrl;
  final ShopOwner owner;
  final Subscription? subscription;
  final bool isOwner;

  Shop({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    this.bannerUrl,
    required this.owner,
    this.subscription,
    required this.isOwner,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      bannerUrl: json['banner_url'],
      owner: ShopOwner.fromJson(json['owner']),
      subscription: json['subscription'] != null 
          ? Subscription.fromJson(json['subscription']) 
          : null,
      isOwner: json['is_owner'] ?? false,
    );
  }
}

class ShopOwner {
  final int id;
  final String username;
  final String name;

  ShopOwner({
    required this.id,
    required this.username,
    required this.name,
  });

  factory ShopOwner.fromJson(Map<String, dynamic> json) {
    return ShopOwner(
      id: json['id'],
      username: json['username'],
      name: json['name'],
    );
  }
}

class Subscription {
  final int id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int daysRemaining;

  Subscription({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.daysRemaining,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      daysRemaining: json['days_remaining'] ?? 0,
    );
  }
}