class ProductCategory {
  final String name;
  final String icon;
  final List<PredefinedProduct> products;

  ProductCategory({
    required this.name,
    required this.icon,
    required this.products,
  });
}

class PredefinedProduct {
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  final String units;
  final String category;

  PredefinedProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.units,
    required this.category,
  });
}

// Predefined product categories and items
final List<ProductCategory> predefinedCategories = [
  ProductCategory(
    name: 'Fruits',
    icon: '🍎',
    products: [
      PredefinedProduct(
        name: 'Apple',
        description: 'Fresh red apples',
        price: '120',
        imageUrl: 'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce',
        units: 'kg',
        category: 'Fruits',
      ),
      PredefinedProduct(
        name: 'Banana',
        description: 'Sweet yellow bananas',
        price: '60',
        imageUrl: 'https://images.unsplash.com/photo-1603833665858-e61d17a86224',
        units: 'dozen',
        category: 'Fruits',
      ),
    ],
  ),
  ProductCategory(
    name: 'Vegetables',
    icon: '🥬',
    products: [
      PredefinedProduct(
        name: 'Tomato',
        description: 'Fresh red tomatoes',
        price: '40',
        imageUrl: 'https://images.unsplash.com/photo-1546094096-0df4bcaaa337',
        units: 'kg',
        category: 'Vegetables',
      ),
      PredefinedProduct(
        name: 'Potato',
        description: 'Fresh potatoes',
        price: '30',
        imageUrl: 'https://images.unsplash.com/photo-1518977676601-b53f82aba655',
        units: 'kg',
        category: 'Vegetables',
      ),
    ],
  ),
  ProductCategory(
    name: 'Dairy',
    icon: '🥛',
    products: [
      PredefinedProduct(
        name: 'Milk',
        description: 'Fresh dairy milk',
        price: '60',
        imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b',
        units: 'liter',
        category: 'Dairy',
      ),
      PredefinedProduct(
        name: 'Curd',
        description: 'Fresh homemade curd',
        price: '40',
        imageUrl: 'https://images.unsplash.com/photo-1628088062854-d1870b4553da',
        units: 'kg',
        category: 'Dairy',
      ),
    ],
  ),
  ProductCategory(
    name: 'Beverages',
    icon: '🥤',
    products: [
      PredefinedProduct(
        name: 'Cola',
        description: 'Refreshing cola drink',
        price: '40',
        imageUrl: 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97',
        units: 'bottle',
        category: 'Beverages',
      ),
      PredefinedProduct(
        name: 'Water',
        description: 'Mineral water',
        price: '20',
        imageUrl: 'https://images.unsplash.com/photo-1548839140-29a749e1cf4d',
        units: 'bottle',
        category: 'Beverages',
      ),
    ],
  ),
]; 