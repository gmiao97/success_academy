abstract interface class DataSource<T, K> {
  Future<T> loadData();

  Future<T> loadDataByKey(K key);

  Future<void> fetchAndStoreData();

  Future<void> fetchAndStoreDataByKey(K key);
}
