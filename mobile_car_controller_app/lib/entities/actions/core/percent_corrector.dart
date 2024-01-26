typedef IPercentCorrector = int Function(double percent);

int mainPercentCorrector(double percent) => (100000 * percent).round();