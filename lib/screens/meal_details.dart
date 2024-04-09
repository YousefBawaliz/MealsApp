import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/favorites_provider.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
    // required this.onToggleFavourite
  });

  final Meal meal;
  // final void Function(Meal meal) onToggleFavourite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouriteMeals = ref.watch(favoriteMealsProvider);
    final isFavorite = favouriteMeals.contains(meal);

    return Scaffold(
        appBar: AppBar(
          actions: [
            //favourite Button
            IconButton(
              onPressed: () {
                //we use .notifier to access the Notifier class itself, which has the toggleFavotieMethod
                final wasAdded = ref
                    .read(favoriteMealsProvider.notifier)
                    .toggleMealFavoriteStatus(meal);
                // onToggleFavourite(meal);

                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(wasAdded
                        ? "added to favorites"
                        : "removed from favorites"),
                  ),
                );
              },
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => RotationTransition(
                  // turns: animation, //the default between 0,1
                  turns: Tween(begin: 0.8, end: 1.0).animate(animation),
                  child: child,
                ),
                child: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  key: ValueKey(
                      isFavorite), //must provide a key to tell Flutter that the value has changed
                ),
              ),
            ),
          ],
          title: Text(meal.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: meal.id,
                child: Image.network(
                  meal.imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Ingredients',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 14),
              for (final ingredient in meal.ingredients)
                Text(
                  ingredient,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              const SizedBox(height: 24),
              Text(
                'Steps',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 14),
              for (final step in meal.steps)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    step,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
            ],
          ),
        ));
  }
}
