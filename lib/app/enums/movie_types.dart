enum MovieTypes {
  movie,
  series,
  music,
  porns,
}

extension MovieTypesExtension on MovieTypes {
  static MovieTypes getType(String name) {
    if (name == MovieTypes.porns.name) {
      return MovieTypes.porns;
    }
    if (name == MovieTypes.music.name) {
      return MovieTypes.music;
    }
    if (name == MovieTypes.series.name) {
      return MovieTypes.series;
    }
    return MovieTypes.movie;
  }
}
