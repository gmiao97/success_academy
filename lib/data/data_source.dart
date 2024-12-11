abstract interface class DataSource<T, K> {
  Future<T> loadData(K key);

  Future<void> fetchAndStoreData();
}
