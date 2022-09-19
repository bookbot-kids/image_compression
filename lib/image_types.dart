/// Image file type base on file extension
enum ImageType {
  gif,
  png,
  jpg,
  svg,
  ai,
  eps,
  pdf,
}

extension $ImageType on ImageType {
  static final string = {
    ImageType.gif: '.gif',
    ImageType.png: '.png',
    ImageType.jpg: '.jpg',
    ImageType.svg: '.svg',
    ImageType.ai: '.ai',
    ImageType.eps: '.eps',
    ImageType.pdf: '.pdf',
  };

  static final toEnum = {
    '.gif': ImageType.gif,
    '.png': ImageType.png,
    '.jpg': ImageType.jpg,
    '.svg': ImageType.svg,
    '.jpeg': ImageType.jpg,
    '.ai': ImageType.ai,
    '.eps': ImageType.eps,
    '.pdf': ImageType.pdf,
  };

  String? get name => $ImageType.string[this];
  static ImageType? fromString(String value) =>
      $ImageType.toEnum[value.toLowerCase()];
}
