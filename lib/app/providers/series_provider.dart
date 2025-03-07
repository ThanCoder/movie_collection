import 'package:flutter/widgets.dart';
import 'package:movie_collections/app/models/series_model.dart';

class SeriesProvider with ChangeNotifier {
  final List<SeriesModel> _list = [];
  SeriesModel? _series;
  bool _isLoading = false;

  List<SeriesModel> get getList => _list;
  bool get isLoading => _isLoading;
  SeriesModel? get getCurrent => _series;
}
