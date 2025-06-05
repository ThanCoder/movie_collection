enum MovieInfoTypes {
  info,
  data,
  // link,
}

extension MovieInfoTypesExtension on MovieInfoTypes {
  static MovieInfoTypes getType(String name) {
    if (name == MovieInfoTypes.data.name) {
      return MovieInfoTypes.data;
    }
    // if (name == MovieInfoTypes.link.name) {
    //   return MovieInfoTypes.link;
    // }
    return MovieInfoTypes.info;
  }
}
