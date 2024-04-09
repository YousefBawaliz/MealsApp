import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meals_provider.dart';

enum Filter { glutenFree, lactoseFree, vegeterian, vegan }

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegan: false,
          Filter.vegeterian: false
        });

  void setFilters(Map<Filter, bool> choosenFilters) {
    state = choosenFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive
    }; //create new map, with same old values initiated in state, but override them with new values from the function
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(MyMealsProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where(
    (element) {
      if (activeFilters[Filter.glutenFree]! && !element.isGlutenFree) {
        return false; //select meals that are only glutenFree
      }
      if (activeFilters[Filter.vegan]! && !element.isVegan) {
        return false;
      }
      return true;
    },
  ).toList();
});
