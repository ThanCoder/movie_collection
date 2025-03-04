enum MovieTypes {
  movie,
  series,
  porns,
}

extension MovieTypesExtension on MovieTypes {
  MovieTypes getType(String name) {
    if (name == MovieTypes.porns.name) {
      return MovieTypes.porns;
    }
    if (name == MovieTypes.series.name) {
      return MovieTypes.series;
    }
    return MovieTypes.movie;
  }
}
