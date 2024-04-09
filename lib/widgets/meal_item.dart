import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meal_details.dart';
import 'package:meals/widgets/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class Meal_Item extends StatelessWidget {
  const Meal_Item({
    super.key,
    required this.meal,
    //  required this.onToggleFavourite
  });
  final Meal meal;
  // final void Function(Meal meal) onToggleFavourite; //for favourite

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip
          .hardEdge, //clips the widget, removing any content of the child widget that would go outside this card
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealDetailsScreen(
                // onToggleFavourite: onToggleFavourite,
                meal: meal,
              ),
            ),
          );
        },
        child: Stack(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(meal.imageUrl),
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              //this means that this widget will be put on the bottom of the stack, and span from the very left to the very right
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 44, vertical: 6),
                color: Colors.black54,
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow
                          .ellipsis, //Use an ellipsis to indicate that the text has overflowed.
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MealItemTrait(
                          icon: Icons.schedule,
                          label: "${meal.duration} min",
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        MealItemTrait(
                            icon: Icons.work,
                            label: "${meal.complexity.name.toUpperCase()}"),
                        MealItemTrait(
                            icon: Icons.attach_money,
                            label: "${meal.affordability.name.toUpperCase()}"),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
