import 'package:riverpod/riverpod.dart';

import 'package:meals/data/dummy_data.dart';

final mealsProvider = Provider((ref) {
  return dummyMeals;
});
