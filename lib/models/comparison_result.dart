class ComparisonResult {
  final List<double?> unitPrices; // null = product not filled
  final int winner; // 0-based index; -1 = tie
  final double savingPercent;

  const ComparisonResult({
    required this.unitPrices,
    required this.winner,
    required this.savingPercent,
  });
}
