class Product {
  final String name;
  final double price;
  final String description;
  final List<String> images;
  final List<String> highlights;
  final Map<String, String> specifications;
  final String brandDescription;
  final String distributerDescription;

  const Product({
    required this.name,
    required this.price,
    required this.description,
    required this.images,
    required this.highlights,
    required this.specifications,
    required this.brandDescription,
    required this.distributerDescription,
  });

  static Product sampleProduct = Product(
    name: 'Kids Ride On Push Car',
    price: 1199.00,
    description: 'Perfect first ride-on toy for your little one',
    images: [
      'https://cdn.pixelspray.io/v2/black-bread-289bfa/HrdP6X/original/hamleys-product/491553623/300/491553623_6583.jpeg',
      'https://cdn.pixelspray.io/v2/black-bread-289bfa/HrdP6X/original/hamleys-product/491553626/300/491553626_9615.jpeg',
      'https://cdn.pixelspray.io/v2/black-bread-289bfa/HrdP6X/original/hamleys-product/491185539/300/491185539-1.webp',
      'https://cdn.pixelspray.io/v2/black-bread-289bfa/HrdP6X/original/hamleys-product/492336736/300/492336736-1.jpeg',
    ],
    highlights: [
      'Sturdy and safe construction',
      'Easy to clean surface',
      'Comfortable seat design',
      'Suitable for ages 1-3 years',
    ],
    specifications: {
      'Age': '12-36 months',
      'Maximum weight': '20 kg',
      'Material': 'High-quality plastic',
      'Dimensions': '60 x 30 x 40 cm',
    },
    brandDescription: 'We are committed to creating safe, durable, and fun toys that help in your child\'s development while ensuring their safety and enjoyment.',
    distributerDescription: 'We are committed to creating safe, durable, and fun toys that help in your child.',
  );

  static List<Product> relatedProducts = List.generate(
    5,
    (index) => Product(
      name: 'Related Toy ${index + 1}',
      price: 999.00 + (index * 100),
      description: 'Related product description',
      images: ['https://cdn.pixelspray.io/v2/black-bread-289bfa/HrdP6X/original/hamleys-product/491185540/300/491185540.webp'],
      highlights: [],
      specifications: {},
      brandDescription: '',
      distributerDescription: ' ',
    ),
  );
}