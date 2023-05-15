import 'package:money_formatter/money_formatter.dart';

class MoneyFormat {
  String rupiah(double _money) {
    MoneyFormatter fmf = new MoneyFormatter(
        amount: _money,
        settings: MoneyFormatterSettings(
          symbol: 'Rp.',
          thousandSeparator: '.',
          decimalSeparator: ',',
          symbolAndNumberSeparator: ' ',
          fractionDigits: 0,
        ));
    return fmf.output.symbolOnLeft;
  }
}
