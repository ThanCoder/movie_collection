extension StringExtension on String {
  String toCaptalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1, length)}';
  }

  String getName({bool withExt = true}) {
    var name = split('/').last;
    if (withExt) {}
    //replace . ပါလာရင်
    String ext = name.split('.').last;
    final noExt = name.replaceAll('.$ext', '');
    name = '${noExt.replaceAll('.', ' ')}.$ext';
    return name;
  }

  String getExt() {
    return split('/').last.split('.').last;
  }
}
