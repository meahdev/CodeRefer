class HtmlEntityConvertor {
  List<String> mEntities = ["&amp;", "&quot;", "&#39", "&lt;", "&gt;", "&#47;"];
  String convert(String text) {
    var result = text;
    for (int j = 0; j < mEntities.length; j++) {
      if (result.contains(mEntities[j])) {
        if (mEntities[j] == "&amp;") {
          result = result.replaceAll(mEntities[j], "&");
        } else if (mEntities[j] == "&quot;") {
          result = result.replaceAll(mEntities[j], '"');
        } else if (mEntities[j] == "&#39") {
          result = result.replaceAll(mEntities[j], "'");
        } else if (mEntities[j] == "&lt;") {
          result = result.replaceAll(mEntities[j], '<');
        } else if (mEntities[j] == "&gt;") {
          result = result.replaceAll(mEntities[j], '>');
        } else if (mEntities[j] == "&#47;") {
          result = result.replaceAll(mEntities[j], '/');
        }
      }
    }
    return result;
  }
}
