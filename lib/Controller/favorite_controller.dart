import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FavoritesController extends GetxController {
  final _storage = GetStorage();
  final RxList _favorites = [].obs;

  List get favorites => _favorites;

  @override
  void onInit() {
    _favorites.value = _storage.read<List>('favorites') ?? [];
    super.onInit();
  }

  bool isFavorite(String displayName) => _favorites.contains(displayName);

  void addFavorite(String displayName) {
    if (!_favorites.contains(displayName)) {
      _favorites.add(displayName);
      _saveToStorage();
    }
  }

  void removeFavorite(String displayName) {
    _favorites.remove(displayName);
    _saveToStorage();
  }

  void toggleFavorite(String displayName) {
    if (isFavorite(displayName)) {
      removeFavorite(displayName);
    } else {
      addFavorite(displayName);
    }
  }

  void _saveToStorage() {
    _storage.write('favorites', _favorites);
  }
}
