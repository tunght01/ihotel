extension IterableExtension<T> on Iterable<T> {
  T? get firstItemOrNull=> isEmpty? null: first;
}
