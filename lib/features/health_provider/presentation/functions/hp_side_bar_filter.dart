import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FilterOption { alphabetical, rutDesc, rutAsc }

class FilterNotifier extends StateNotifier<FilterOption> {
  FilterNotifier() : super(FilterOption.alphabetical);

  void setFilter(FilterOption option) {
    state = option;
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, FilterOption>((ref) {
  return FilterNotifier();
});