enum HomeListStyle {
  allListStyle,
  groupListStyle;

  static HomeListStyle getStyle(String name) {
    if (name == allListStyle.name) {
      return allListStyle;
    }
    if (name == groupListStyle.name) {
      return groupListStyle;
    }
    return allListStyle;
  }
}
