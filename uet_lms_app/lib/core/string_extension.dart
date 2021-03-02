extension StringExtension on String {
  String capitalize() {
    List<String> newStringParts = [];
    if (this.length > 0) {
      final parts = this.split(" ");
      for (final each in parts) {
        String newPart = "";
        if (each.length > 1) {
          newPart = each[0].toUpperCase() + each.toLowerCase().substring(1);
        }
        newStringParts.add(newPart);
      }
    }

    return newStringParts.join(" ");
  }
}
