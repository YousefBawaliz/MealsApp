import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/data/dummy_data.dart';

final MyMealsProvider = Provider((ref) {
  return dummyMeals[1];
});


//this is a comment
//this is another commit