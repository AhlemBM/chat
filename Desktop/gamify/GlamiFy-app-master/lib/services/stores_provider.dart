import 'package:flutter/foundation.dart';
import '../models/Store.dart';

class StoresProvider with ChangeNotifier {
  List<Store> _stores = [];
  bool _isLoading = true;
  String? _error;

  List<Store> get stores => _stores;
  bool get isLoading => _isLoading;
  String? get error => _error;

  StoresProvider() {
    fetchStores();
  }

  Future<void> fetchStores() async {
    try {
      print('Fetching stores...');
      _isLoading = true;
      _error = null;
      notifyListeners();

      _stores = await Store.loadAllStores();

      print('Processed ${_stores.length} stores');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error in fetchStores: $e');
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await fetchStores();
  }
}
