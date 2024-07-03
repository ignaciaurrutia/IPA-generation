import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UpperFilterOption { seeAll, pastDue, lessThan14, lessThan30, moreThan30, postpartum}

class UpperFilterNotifier extends StateNotifier<UpperFilterOption> {
  UpperFilterNotifier() : super(UpperFilterOption.seeAll);

  void setFilter(UpperFilterOption option) {
    state = option;
  }
}

final upperFilterProvider = StateNotifierProvider<UpperFilterNotifier, UpperFilterOption>((ref) {
  return UpperFilterNotifier();
});