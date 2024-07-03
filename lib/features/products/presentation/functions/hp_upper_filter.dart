import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HPUpperFilterOption { seeAll, other, pediatrician, obstetrician, psychologist, midwife}

class HPUpperFilterNotifier extends StateNotifier<HPUpperFilterOption> {
  HPUpperFilterNotifier() : super(HPUpperFilterOption.seeAll);

  void setFilter(HPUpperFilterOption option) {
    state = option;
  }
}

final HPUpperFilterProvider = StateNotifierProvider<HPUpperFilterNotifier, HPUpperFilterOption>((ref) {
  return HPUpperFilterNotifier();
});