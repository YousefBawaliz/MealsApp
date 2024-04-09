import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';

class categoriesScreen extends StatelessWidget {
  const categoriesScreen(
      {super.key,
      // required this.onToggleFavourite,
      required this.avaialbeMeals});

  // final void Function(Meal meal) onToggleFavourite; //for favourite
  final List<Meal> avaialbeMeals;

  //it's ok to use a function in a stateless widget here, because we are not really updating the state of the widget itself, only naviagating to another widget
  void _selectCategory(BuildContext context, Category category) {
    //we must accpet a context value, since context isn't available in a stateless widget
    final filteredMeals =
        avaialbeMeals //starting point is filtered catagories that got passed on
            .where(
              (meal) => meal.categories.contains(category.id),
            )
            .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          // onToggleFavourite: onToggleFavourite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(25),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //Creates a delegate that makes grid layouts with a fixed number of tiles in the cross axis.
          crossAxisSpacing:
              20, //The number of logical pixels between each child along the cross axis.
          mainAxisSpacing:
              20, //The number of logical pixels between each child along the main axis.
          crossAxisCount: 2, //2 items in each column
          childAspectRatio: 3 / 2), //ascpect ratio of 2/3

      children: [
        ...availableCategories.map(
          (e) => CategoryGridItem(
            category: e,
            onSelectCatagory: () {
              _selectCategory(context, e);
            },
          ),
        )
        //same as:
        // for(final category in availableCategories)
        //   CategoryGridItem(category: category)
      ],
    );
  }
}
