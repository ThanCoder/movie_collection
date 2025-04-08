import 'package:flutter/material.dart';
import 'package:movie_collections/app/models/episode_model.dart';

ValueNotifier<bool> isHomePageDropableNotifier = ValueNotifier(true);

ValueNotifier<int> seriesVideoPlayerCurrentIndexNotifier = ValueNotifier(0);
ValueNotifier<List<EpisodeModel>> seriesVideoPlayerEpListNotifier =
    ValueNotifier([]);
