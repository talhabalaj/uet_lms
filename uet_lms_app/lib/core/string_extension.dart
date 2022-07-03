extension StringExtension on String {
  String capitalize() {
    List<String> newStringParts = [];
    if (this.length > 0) {
      final parts = this.split(" ");
      if (parts.length > 0) {
        for (final each in parts) {
          String newPart = "";
          if (each.length > 1) {
            newPart = each[0].toUpperCase() + each.toLowerCase().substring(1);
          }
          else {
            newPart = each.toUpperCase();
          }
          newStringParts.add(newPart);
        }
      }
    }

    return newStringParts.join(" ");
  }
}
