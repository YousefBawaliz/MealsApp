import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';

class categoriesScreen extends StatefulWidget {
  const categoriesScreen({
    super.key,
    // required this.onToggleFavourite,
    required this.avaialbeMeals,
  });

  // final void Function(Meal meal) onToggleFavourite; //for favourite
  final List<Meal> avaialbeMeals;

  @override
  State<categoriesScreen> createState() => _categoriesScreenState();
}

class _categoriesScreenState extends State<categoriesScreen>
    with SingleTickerProviderStateMixin {
  //for animation:
  late AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    ); //vsync: makes sure it activates for every frame
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  //it's ok to use a function in a stateless widget here, because we are not really updating the state of the widget itself, only naviagating to another widget
  void _selectCategory(BuildContext context, Category category) {
    //we must accpet a context value, since context isn't available in a stateless widget
    final filteredMeals = widget
        .avaialbeMeals //starting point is filtered catagories that got passed on
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
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => SlideTransition(
              position: Tween(
                begin: const Offset(0, 0.3),
                end: const Offset(0, 0),
              ).animate(
                CurvedAnimation(
                    parent: _animationController, curve: Curves.easeInOut),
              ),
              child: child,
            ),
        child: GridView(
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
        ));
  }
}
