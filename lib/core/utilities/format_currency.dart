class FormatCurrency {
  static String toRupiah(dynamic value) {
    String valueStr = value.toString();
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String result =
        valueStr.replaceAllMapped(reg, (Match match) => '${match[1]}.');
    return 'Rp $result';
  }
}