import 'package:flutter/material.dart';

// Global theme controller (ValueNotifier)
final ValueNotifier<bool> darkModeNotifier = ValueNotifier<bool>(false);

void main() => runApp(const RestaurantApp());

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDark, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tasty Corner',
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const MenuHome(),
        );
      },
    );
  }
}

// ---------------- THEME ----------------
const String appFont = 'Verdana';
const Color brandColor = Color(0xFF6A1B9A); // purple
const Color priceColor = Color(0xFFFF6F00); // amber-orange

ThemeData buildLightTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: appFont,
    colorScheme: ColorScheme.fromSeed(seedColor: brandColor),
    scaffoldBackgroundColor: const Color(0xFFF3E5F5),
    appBarTheme: const AppBarTheme(
      backgroundColor: brandColor,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
      titleSmall: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
    ),
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: appFont,
    colorScheme: ColorScheme.fromSeed(
      seedColor: brandColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121016),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF241B2F),
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: Colors.white,
      ),
    ),
  );
}

// ---------------- DATA ----------------
class Dish {
  final String label;
  final String photo;
  final int cost;
  final double stars;

  Dish({
    required this.label,
    required this.photo,
    required this.cost,
    required this.stars,
  });

  factory Dish.fromMap(Map<String, dynamic> m) => Dish(
    label: m['label'],
    photo: m['photo'],
    cost: m['cost'],
    stars: m['stars'],
  );
}

final List<Dish> dishes = [
  {
    'label': 'Beef Burger',
    'photo':
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
    'cost': 280,
    'stars': 4.4,
  },
  {
    'label': 'Margherita',
    'photo':
        'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500',
    'cost': 520,
    'stars': 4.8,
  },
  {
    'label': 'Spaghetti',
    'photo':
        'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=500',
    'cost': 390,
    'stars': 4.2,
  },
  {
    'label': 'Club Sandwich',
    'photo':
        'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=500',
    'cost': 210,
    'stars': 3.9,
  },
  {
    'label': 'Crispy Fries',
    'photo':
        'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=500',
    'cost': 120,
    'stars': 4.6,
  },
  {
    'label': 'BBQ Chicken',
    'photo':
        'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=500',
    'cost': 450,
    'stars': 4.7,
  },
].map(Dish.fromMap).toList();

// ---------------- HOME SCREEN ----------------
class MenuHome extends StatelessWidget {
  const MenuHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasty Corner'),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: darkModeNotifier,
            builder: (context, isDark, _) => Switch(
              value: isDark,
              thumbIcon: WidgetStateProperty.resolveWith(
                (_) => Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              ),
              onChanged: (v) => darkModeNotifier.value = v,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, box) {
          final bool wide = box.maxWidth >= 600;

          if (!wide) {
            // Mobile: ListView
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              itemCount: dishes.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: SizedBox(
                  height: 230,
                  child: DishTile(dish: dishes[index]),
                ),
              ),
            );
          }

          // Tablet/Desktop/Landscape: GridView
          return GridView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: dishes.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 320,
              mainAxisExtent: 230,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) => DishTile(dish: dishes[index]),
          );
        },
      ),
    );
  }
}

// ---------------- REUSABLE WIDGET ----------------
class DishTile extends StatelessWidget {
  final Dish dish;
  const DishTile({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Photo area with name overlay
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  dish.photo,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const ColoredBox(
                    color: Colors.black26,
                    child: Icon(Icons.lunch_dining, size: 48),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 10,
                  child: Text(
                    dish.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.headlineSmall?.copyWith(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          // Price + star rating
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Tk ${dish.cost}',
                    style: text.titleSmall?.copyWith(color: priceColor),
                  ),
                ),
                StarRow(value: dish.stars),
                const SizedBox(width: 4),
                Text(dish.stars.toString(), style: text.titleSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 5-star rating widget
class StarRow extends StatelessWidget {
  final double value;
  const StarRow({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        IconData icon;
        if (value >= i + 1) {
          icon = Icons.star_rounded;
        } else if (value > i) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }
        return Icon(icon, size: 18, color: Colors.amber);
      }),
    );
  }
}
