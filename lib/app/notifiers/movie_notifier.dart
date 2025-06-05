import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/episode_model.dart';

import '../models/result_screen_data.dart';

ValueNotifier<bool> isHomePageDropableNotifier = ValueNotifier(true);

ValueNotifier<int> seriesVideoPlayerCurrentIndexNotifier = ValueNotifier(0);
ValueNotifier<List<EpisodeModel>> seriesVideoPlayerEpListNotifier =
    ValueNotifier([]);

ValueNotifier<ResultScreenData> resultScreenDataNotifier =
    ValueNotifier(ResultScreenData.empty());
