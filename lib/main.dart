import 'package:flutter/material.dart';

void main() => runApp(const FoodieApp());

const orange = Color(0xFFFF7043);
const dark = Color(0xFF252525);
const background = Color(0xFFFFF9F5);

class Food {
  final int id;
  final String name, category, description, image, restaurant;
  final double price, rating;
  final int minutes;
  final bool isVeg;

  const Food({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.image,
    required this.restaurant,
    required this.price,
    required this.rating,
    required this.minutes,
    required this.isVeg,
  });
}

const foods = <Food>[
  Food(
    id: 1,
    name: 'Margherita Pizza',
    category: 'Pizza',
    description: 'Classic Italian pizza topped with mozzarella, tomato sauce and fresh basil.',
    image: 'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=700',
    restaurant: 'Pizza Palace',
    price: 249,
    rating: 4.8,
    minutes: 25,
    isVeg: true,
  ),
  Food(
    id: 2,
    name: 'Cheese Burger',
    category: 'Burger',
    description:
        'Juicy burger with melted cheese, lettuce and our special sauce.',
    image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=700',
    restaurant: 'Burger House',
    price: 179,
    rating: 4.6,
    minutes: 20,
    isVeg: true,
  ),
  Food(
    id: 3,
    name: 'Chicken Biryani',
    category: 'Biryani',
    description:
        'Aromatic basmati rice cooked with chicken and traditional spices.',
    image: 'chicken_biriyani.jpeg',
    restaurant: 'Hyderabad Kitchen',
    price: 299,
    rating: 4.9,
    minutes: 30,
    isVeg: false,
  ),
  Food(
    id: 4,
    name: 'Pepperoni Pizza',
    category: 'Pizza',
    description: 'Cheesy pizza loaded with pepperoni and a rich tomato base.',
    image: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=700',
    restaurant: 'Pizza Palace',
    price: 329,
    rating: 4.7,
    minutes: 25,
    isVeg: false,
  ),
  Food(
    id: 5,
    name: 'French Fries',
    category: 'Snacks',
    description: 'Crispy golden potato fries seasoned with herbs.',
    image: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=700',
    restaurant: 'Snack Corner',
    price: 99,
    rating: 4.5,
    minutes: 15,
    isVeg: true,
  ),
  Food(
    id: 6,
    name: 'Chocolate Cake',
    category: 'Dessert',
    description: 'Rich chocolate cake layered with smooth chocolate cream.',
    image: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=700',
    restaurant: 'Sweet Treats',
    price: 149,
    rating: 4.8,
    minutes: 20,
    isVeg: true,
  ),
  Food(
    id: 7,
    name: 'Chicken Burger',
    category: 'Burger',
    description: 'Crispy chicken patty with fresh vegetables and creamy sauce.',
    image: 'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=700',
    restaurant: 'Burger House',
    price: 219,
    rating: 4.7,
    minutes: 20,
    isVeg: false,
  ),
  Food(
    id: 8,
    name: 'Gulab Jamun',
    category: 'Dessert',
    description: 'Soft, syrup-soaked traditional Indian sweet.',
    image: 'https://images.unsplash.com/photo-1666190094761-7d9f5a5f8c9c?w=700',
    restaurant: 'Sweet Treats',
    price: 89,
    rating: 4.6,
    minutes: 15,
    isVeg: true,
  ),
];

class FoodieApp extends StatelessWidget {
  const FoodieApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Foodie',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(seedColor: orange),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: dark,
        elevation: 0,
      ),
    ),
    home: const MainScreen(),
  );
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int tab = 0;
  final Map<int, int> cart = {};
  final Set<int> favourites = {};
  final List<String> orderHistory = [];

  int get cartCount => cart.values.fold(0, (a, b) => a + b);

  double get subtotal => cart.entries.fold(0, (sum, entry) {
    final food = foods.firstWhere((f) => f.id == entry.key);
    return sum + food.price * entry.value;
  });

  void addFood(Food food) {
    setState(() => cart[food.id] = (cart[food.id] ?? 0) + 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${food.name} added to cart'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void changeQuantity(int id, int change) {
    setState(() {
      final quantity = (cart[id] ?? 0) + change;
      if (quantity <= 0) {
        cart.remove(id);
      } else {
        cart[id] = quantity;
      }
    });
  }

  void toggleFavourite(int id) {
    setState(() {
      if (!favourites.add(id)) favourites.remove(id);
    });
  }

  void openDetails(Food food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodDetailsPage(
          food: food,
          isFavourite: favourites.contains(food.id),
          onFavourite: () => toggleFavourite(food.id),
          onAdd: () => addFood(food),
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CartPage(
          cart: cart,
          onQuantity: changeQuantity,
          onCheckout: (total) => openCheckout(total),
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void openCheckout(double total) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutPage(
          total: total,
          onPlaceOrder: (address, payment) {
            final orderId =
                'FD${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
            setState(() {
              orderHistory.insert(
                0,
                'Order #$orderId • ₹${total.toStringAsFixed(2)}',
              );
              cart.clear();
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => TrackingPage(
                  orderNumber: orderId,
                  address: address,
                  payment: payment,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        onDetails: openDetails,
        onAdd: addFood,
        favourites: favourites,
        onFavourite: toggleFavourite,
      ),
      HomePage(
        onDetails: openDetails,
        onAdd: addFood,
        favourites: favourites,
        onFavourite: toggleFavourite,
        title: 'Explore Food',
      ),
      HomePage(
        onDetails: openDetails,
        onAdd: addFood,
        favourites: favourites,
        onFavourite: toggleFavourite,
        favouriteOnly: true,
        title: 'Your Favourites',
      ),
      ProfilePage(orders: orderHistory),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: tab, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        backgroundColor: Colors.white,
        indicatorColor: orange.withOpacity(.15),
        onDestinationSelected: (value) => setState(() => tab = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: orange),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite, color: orange),
            label: 'Favourites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: tab == 3
          ? null
          : FloatingActionButton.extended(
              onPressed: openCart,
              backgroundColor: dark,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.shopping_bag_outlined),
              label: Text('Cart ($cartCount)'),
            ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Function(Food) onDetails, onAdd;
  final Set<int> favourites;
  final Function(int) onFavourite;
  final bool favouriteOnly;
  final String title;

  const HomePage({
    super.key,
    required this.onDetails,
    required this.onAdd,
    required this.favourites,
    required this.onFavourite,
    this.favouriteOnly = false,
    this.title = 'Popular Dishes',
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String category = 'All';
  String search = '';
  final categories = const [
    'All',
    'Pizza',
    'Burger',
    'Biryani',
    'Snacks',
    'Dessert',
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = foods.where((food) {
      final categoryMatch = category == 'All' || food.category == category;
      final searchMatch =
          food.name.toLowerCase().contains(search.toLowerCase()) ||
          food.restaurant.toLowerCase().contains(search.toLowerCase());
      final favouriteMatch =
          !widget.favouriteOnly || widget.favourites.contains(food.id);
      return categoryMatch && searchMatch && favouriteMatch;
    }).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: orange),
                    const SizedBox(width: 5),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DELIVER TO',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                          Text(
                            'Hyderabad, India',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          showDragHandle: true,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Notifications',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ListTile(
                                    leading: Icon(
                                      Icons.local_offer,
                                      color: orange,
                                    ),
                                    title: Text('Special Offer!'),
                                    subtitle: Text(
                                      'Get 20% OFF using FOODIE20.',
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.delivery_dining,
                                      color: orange,
                                    ),
                                    title: Text('Free Delivery'),
                                    subtitle: Text(
                                      'Enjoy free delivery on your next order.',
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.restaurant,
                                      color: orange,
                                    ),
                                    title: Text('New Restaurants'),
                                    subtitle: Text(
                                      'Discover new restaurants near you.',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.notifications_none),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Good food,',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Good mood!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: orange,
                  ),
                ),
                const Text(
                  'Discover delicious food near you.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 18),
                Container(
                  height: 140,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [orange, Color(0xFFFFA270)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SPECIAL OFFER',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Get 20% OFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Use code: FOODIE20',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.fastfood, color: Colors.white, size: 65),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  onChanged: (value) => setState(() => search = value),
                  decoration: InputDecoration(
                    hintText: 'Search food or restaurants...',
                    prefixIcon: const Icon(Icons.search, color: orange),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 45,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: categories.map((item) {
                      final selected = category == item;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(item),
                          selected: selected,
                          selectedColor: orange,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : dark,
                          ),
                          onSelected: (_) => setState(() => category = item),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (filtered.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('No food items found')),
          ),
        if (filtered.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 90),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.crossAxisExtent;
                final columns = width > 950
                    ? 4
                    : width > 600
                    ? 3
                    : 2;
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: width > 600 ? .83 : .66,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final food = filtered[index];
                    return FoodCard(
                      food: food,
                      isFavourite: widget.favourites.contains(food.id),
                      onTap: () => widget.onDetails(food),
                      onAdd: () => widget.onAdd(food),
                      onFavourite: () => widget.onFavourite(food.id),
                    );
                  }, childCount: filtered.length),
                );
              },
            ),
          ),
      ],
    );
  }
}

class FoodCard extends StatelessWidget {
  final Food food;
  final bool isFavourite;
  final VoidCallback onTap, onAdd, onFavourite;

  const FoodCard({
    super.key,
    required this.food,
    required this.isFavourite,
    required this.onTap,
    required this.onAdd,
    required this.onFavourite,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(17),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  food.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const ColoredBox(
                    color: Color(0xFFFFE0D5),
                    child: Icon(Icons.fastfood, size: 45, color: orange),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 17,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      onPressed: onFavourite,
                      icon: Icon(
                        isFavourite ? Icons.favorite : Icons.favorite_border,
                        color: isFavourite ? Colors.red : dark,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.circle,
                      size: 10,
                      color: food.isVeg ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    food.restaurant,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 15),
                      Text(
                        '${food.rating}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        '${food.minutes} min',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '₹${food.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: orange,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: onAdd,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class FoodDetailsPage extends StatelessWidget {
  final Food food;
  final bool isFavourite;
  final VoidCallback onFavourite, onAdd;

  const FoodDetailsPage({
    super.key,
    required this.food,
    required this.isFavourite,
    required this.onFavourite,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Food Details')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.network(
              food.image,
              height: 270,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 270,
                child: Icon(Icons.fastfood, size: 70),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  food.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: onFavourite,
                icon: Icon(
                  isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                  size: 28,
                ),
              ),
            ],
          ),
          Text(food.restaurant, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              Text(' ${food.rating} Rating'),
              const SizedBox(width: 20),
              const Icon(Icons.access_time, color: orange),
              Text(' ${food.minutes} min'),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            'Description',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            food.description,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Text(
                'Price',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '₹${food.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 25,
                  color: orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                onAdd();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class CartPage extends StatefulWidget {
  final Map<int, int> cart;
  final Function(int, int) onQuantity;
  final Function(double) onCheckout;

  const CartPage({
    super.key,
    required this.cart,
    required this.onQuantity,
    required this.onCheckout,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final couponController = TextEditingController();
  String coupon = '';

  double get subtotal => widget.cart.entries.fold(0, (sum, entry) {
    final food = foods.firstWhere((f) => f.id == entry.key);
    return sum + food.price * entry.value;
  });
  double get discount => coupon == 'FOODIE20'
      ? subtotal * .20
      : coupon == 'FOODIE10'
      ? subtotal * .10
      : 0;
  double get delivery => widget.cart.isEmpty ? 0 : 30;
  double get tax => (subtotal - discount) * .05;
  double get total => subtotal - discount + delivery + tax;

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('My Cart')),
    body: widget.cart.isEmpty
        ? const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
                SizedBox(height: 12),
                Text('Your cart is empty!', style: TextStyle(fontSize: 20)),
                Text('Add something delicious.'),
              ],
            ),
          )
        : ListView(
            padding: const EdgeInsets.all(18),
            children: [
              ...widget.cart.entries.map((entry) {
                final food = foods.firstWhere((f) => f.id == entry.key);
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            food.image,
                            width: 75,
                            height: 75,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const SizedBox(
                              width: 75,
                              height: 75,
                              child: Icon(Icons.fastfood),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '₹${food.price.toStringAsFixed(0)}',
                                style: const TextStyle(color: orange),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            widget.onQuantity(food.id, -1);
                            setState(() {});
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text(
                          '${entry.value}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            widget.onQuantity(food.id, 1);
                            setState(() {});
                          },
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              const Text(
                'Apply Coupon',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 9),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: couponController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        hintText: 'Enter FOODIE20',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final code = couponController.text.trim().toUpperCase();
                      setState(
                        () =>
                            coupon = (code == 'FOODIE20' || code == 'FOODIE10')
                            ? code
                            : '',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            coupon.isNotEmpty
                                ? 'Coupon applied!'
                                : 'Invalid coupon code',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Apply'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Bill Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              billRow('Subtotal', subtotal),
              billRow('Discount', -discount, color: Colors.green),
              billRow('Delivery Fee', delivery),
              billRow('GST (5%)', tax),
              const Divider(height: 25),
              billRow('Total Amount', total, bold: true, color: orange),
              const SizedBox(height: 20),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () => widget.onCheckout(total),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Proceed to Checkout'),
                ),
              ),
            ],
          ),
  );

  Widget billRow(
    String label,
    double value, {
    bool bold = false,
    Color color = dark,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '${value < 0 ? '-' : ''}₹${value.abs().toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

class CheckoutPage extends StatefulWidget {
  final double total;
  final Function(String, String) onPlaceOrder;
  const CheckoutPage({
    super.key,
    required this.total,
    required this.onPlaceOrder,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final houseController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final pinController = TextEditingController();
  String payment = 'Cash on Delivery';

  @override
  void dispose() {
    houseController.dispose();
    streetController.dispose();
    cityController.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Checkout')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Icon(Icons.location_on, color: orange, size: 35),
        const SizedBox(height: 10),
        const Text(
          'Delivery Address',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: houseController,
          decoration: const InputDecoration(
            labelText: 'House / Flat Number',
            hintText: 'Example: Flat 302, House No. 12',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        TextField(
          controller: streetController,
          decoration: const InputDecoration(
            labelText: 'Street / Area',
            hintText: 'Enter street and locality',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        TextField(
          controller: cityController,
          decoration: const InputDecoration(
            labelText: 'City',
            hintText: 'Enter your city',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            labelText: 'PIN Code',
            hintText: 'Enter 6-digit PIN code',
            counterText: '',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'Payment Method',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        RadioListTile<String>(
          value: 'Cash on Delivery',
          groupValue: payment,
          activeColor: orange,
          title: const Text('Cash on Delivery'),
          onChanged: (value) => setState(() => payment = value!),
        ),
        RadioListTile<String>(
          value: 'UPI (Demo)',
          groupValue: payment,
          activeColor: orange,
          title: const Text('UPI (Demo)'),
          onChanged: (value) => setState(() => payment = value!),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Amount to Pay',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${widget.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: orange,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              final house = houseController.text.trim();
              final street = streetController.text.trim();
              final city = cityController.text.trim();
              final pin = pinController.text.trim();

              String? error;

              if (house.isEmpty) {
                error = 'Please enter your house or flat number.';
              } else if (!RegExp(r'\d').hasMatch(house)) {
                error = 'Please enter a valid house or flat number.';
              } else if (street.isEmpty) {
                error = 'Please enter your street or area.';
              } else if (city.isEmpty) {
                error = 'Please enter your city.';
              } else if (!RegExp(r'^\d{6}$').hasMatch(pin)) {
                error = 'Please enter a valid 6-digit PIN code.';
              }

              if (error != null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(error)));
                return;
              }

              final address = '$house, $street, $city - $pin';

              widget.onPlaceOrder(address, payment);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Place Order'),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Payment: $payment',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );
}

class TrackingPage extends StatelessWidget {
  final String orderNumber, address, payment;
  const TrackingPage({
    super.key,
    required this.orderNumber,
    required this.address,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    final steps = <(String, String, IconData)>[
      ('Order Placed', 'Your order has been received.', Icons.receipt_long),
      (
        'Preparing Food',
        'The restaurant is preparing your meal.',
        Icons.restaurant,
      ),
      ('Out for Delivery', 'Your food is on its way.', Icons.delivery_dining),
      ('Delivered', 'Enjoy your delicious meal!', Icons.check_circle),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking')),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 75),
          const SizedBox(height: 15),
          const Text(
            'Order Placed Successfully!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Order #$orderNumber',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 25),
          const Text(
            'Delivery Address',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text(address, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text('Payment: $payment', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 28),
          const Text(
            'Order Status',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 18),
          ...List.generate(
            steps.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 23),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    steps[index].$3,
                    color: index == 0 ? orange : Colors.grey,
                    size: 28,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          steps[index].$1,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          steps[index].$2,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            style: ElevatedButton.styleFrom(
              backgroundColor: orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final List<String> orders;
  const ProfilePage({super.key, required this.orders});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const SizedBox(height: 20),
      const CircleAvatar(
        radius: 48,
        backgroundColor: Color(0xFFFFE0D5),
        child: Icon(Icons.person, size: 55, color: orange),
      ),
      const SizedBox(height: 12),
      const Text(
        'Welcome, Foodie!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      ),
      const Text(
        'foodie@example.com',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      ),
      const SizedBox(height: 30),
      const Text(
        'My Account',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      profileTile(Icons.person_outline, 'Personal Information'),
      profileTile(Icons.location_on_outlined, 'Saved Addresses'),
      profileTile(Icons.payment_outlined, 'Payment Methods'),
      profileTile(Icons.settings_outlined, 'Settings'),
      const SizedBox(height: 25),
      const Text(
        'Order History',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      if (orders.isEmpty)
        const Text(
          'No orders yet. Start ordering!',
          style: TextStyle(color: Colors.grey),
        )
      else
        ...orders.map(
          (order) => Card(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.receipt_long, color: orange),
              title: Text(order),
              subtitle: const Text('Order placed successfully'),
            ),
          ),
        ),
    ],
  );

  static Widget profileTile(IconData icon, String title) => Card(
    color: Colors.white,
    child: ListTile(
      leading: Icon(icon, color: orange),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 15),
      onTap: () {},
    ),
  );
}
