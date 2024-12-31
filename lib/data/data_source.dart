abstract interface class DataSource<T, K> {
  /// Loads all data.
  Future<T> loadData();

  /// Loads data by [key].
  Future<T> loadDataByKey(K key);

  /// Fetches and stores data.
  Future<void> fetchAndStoreData();

  /// Fetches and stores data by key.
  Future<void> fetchAndStoreDataByKey(K key);
}
