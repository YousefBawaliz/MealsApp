import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:meals/screens/filters.dart';

const kinitialFilters = {Filter.glutenFree: false};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favouriteMeals = [];
  Map<Filter, bool> _selectedFilters = kinitialFilters;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavouriteStatus(Meal meal) {
    // check if meal is in favourite meals or not
    final isExisting = _favouriteMeals.contains(meal);
    if (isExisting) {
      setState(
        () {
          _favouriteMeals.remove(meal);
        },
      );
      _showInfoMessage("Meal is no longer a favourite");
    } else {
      setState(
        () {
          _favouriteMeals.add(meal);
        },
      );
      _showInfoMessage("Meal is now a favourite");
    }

    print(_favouriteMeals);
  }

  //for the bottomTabView Navigation
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  //for the ListTiles inside Drawer
  void _setScreen(String identifier) async {
    Navigator.pop(
        context); //to pop the drawer, so it doesn't still appear when we press the back button.

    if (identifier == 'filters') {
      //
      //this function has been made async, because push Returns a [Future] that completes to the
      //result value passed to [pop] when the pushed route is popped off the navigator.
      //
      //since it returns a dynamic type, we have made it return Map<Filter,bool> here, beacuse that is what
      //we will return in the pop method from filters screen
      final result = await Navigator.push<Map<Filter, bool>>(
        context,
        MaterialPageRoute(
          builder: (context) => FiltersScreen(
            currenFliters: _selectedFilters,
          ),
        ),
      );
      //to set the state of the filteredMealTypes
      setState(() {
        _selectedFilters = result ?? kinitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //for passing to catagories screnn if the meals were filtered.
    final availableMeals = dummyMeals.where(
      (element) {
        if (_selectedFilters[Filter.glutenFree]! && !element.isGlutenFree) {
          return false; //select meals that are only glutenFree
        }
        return true;
      },
    ).toList();

    Widget activePage = categoriesScreen(
      avaialbeMeals: availableMeals,
      onToggleFavourite: _toggleMealFavouriteStatus,
    );
    var activePagetitle = 'categories';
    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
          //title: we don't set the title here to ensure that there won't be a scaffold here
          onToggleFavourite: _toggleMealFavouriteStatus,
          meals: _favouriteMeals);
      activePagetitle = "favourites";
    }

    return Scaffold(
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      appBar: AppBar(
        title: Text(activePagetitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex:
            _selectedPageIndex, //controls which tab will be highlighted
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: "Catagories"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favourites"),
        ],
      ),
    );
  }
}
