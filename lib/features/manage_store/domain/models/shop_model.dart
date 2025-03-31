class Shop {
  final int id;
  final String name;
  final String? description;
  final String address;
  final String phone;
  final String email;
  final String? bannerUrl;
  final ShopOwner? owner;
  final Subscription? subscription;
  final bool isOwner;

  Shop({
    required this.id,
    required this.name,
    this.description,
    required this.address,
    required this.phone,
    required this.email,
    this.bannerUrl,
    this.owner,
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
      owner: json['owner'] != null ? ShopOwner.fromJson(json['owner']) : null,
      subscription: json['subscription'] != null ? Subscription.fromJson(json['subscription']) : null,
      isOwner: json['is_owner'] ?? false,
    );
  }
}

class ShopOwner {
  final int id;
  final String username;
  final String? name;

  ShopOwner({
    required this.id,
    required this.username,
    this.name,
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
  final String plan;
  final int? daysRemaining;
  final String? expiryDate;

  Subscription({
    required this.plan,
    this.daysRemaining,
    this.expiryDate,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      plan: json['plan'] ?? 'Free',
      daysRemaining: json['days_remaining'],
      expiryDate: json['expiry_date'],
    );
  }
}