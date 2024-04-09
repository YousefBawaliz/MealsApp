import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier()
      : super(
            []); //constructor with initial data that will be stored in the notifier

  bool toggleMealFavoriteStatus(Meal meal) {
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      //for removing a meal
      state = state
          .where((element) => element.id != meal.id)
          .toList(); //keep a meal if it's id is not equal to id of the argument meal
      return false;
    } else {
      //to add a meal:
      state = [...state, meal];
      return true;
    }
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>(
        //specify the type of data to be returned
        (ref) => FavoriteMealsNotifier());
