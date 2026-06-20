import 'package:flutter/material.dart';

enum AppLocale { ptBR, enUS }

class AppStrings {
  const AppStrings(this._locale);
  final AppLocale _locale;
  bool get _isPortuguese => _locale == AppLocale.ptBR;

  String get subtitle => _isPortuguese
      ? 'Compare o preço por unidade de dois produtos'
      : 'Compare unit prices of two products';
  String productLabel(int i) {
    final letter = String.fromCharCode(65 + i);
    return _isPortuguese ? 'Produto $letter' : 'Product $letter';
  }

  String get price => _isPortuguese ? 'Preço' : 'Price';
  String get quantity => _isPortuguese ? 'Quantidade' : 'Quantity';
  String get compare => _isPortuguese ? 'Comparar' : 'Compare';
  String get compareAgain =>
      _isPortuguese ? 'Comparar novamente' : 'Compare again';
  String get bestOption => _isPortuguese ? 'Melhor opção' : 'Best option';
  String cheaperPerUnit(String percentage) => _isPortuguese
      ? '$percentage% mais barato por unidade'
      : '$percentage% cheaper per unit';
  String get tie => _isPortuguese ? 'Empate!' : 'Tie!';
  String get identicalPrice =>
      _isPortuguese ? 'Preço idêntico por unidade' : 'Identical unit price';
  String get required_ => _isPortuguese ? 'Obrigatório' : 'Required';
  String get invalid => _isPortuguese ? 'Inválido' : 'Invalid';
  String get settings => _isPortuguese ? 'Configurações' : 'Settings';
  String get language => _isPortuguese ? 'Idioma' : 'Language';
  String get appearance => _isPortuguese ? 'Aparência' : 'Appearance';
  String get supportTitle =>
      _isPortuguese ? 'Apoiar o projeto' : 'Support the project';
  String get supportBody => _isPortuguese
      ? 'O Compriceon é gratuito e sem anúncios. Se ele te ajudou a economizar, considere apoiar o desenvolvimento — qualquer contribuição ajuda!'
      : 'Compriceon is free and ad-free. If it helped you save money, consider supporting its development — every contribution helps!';
  String get pixLabel => _isPortuguese ? 'PIX (Brasil)' : 'PIX (Brazil)';
  String get copied => _isPortuguese ? 'Copiado!' : 'Copied!';
}

class LocaleScope extends InheritedWidget {
  final AppLocale locale;
  final void Function(AppLocale) setLocale;
  final ThemeMode themeMode;
  final void Function(ThemeMode) setThemeMode;

  const LocaleScope({
    super.key,
    required this.locale,
    required this.setLocale,
    required this.themeMode,
    required this.setThemeMode,
    required super.child,
  });

  static LocaleScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LocaleScope>()!;

  AppStrings get strings => AppStrings(locale);

  @override
  bool updateShouldNotify(LocaleScope old) =>
      locale != old.locale || themeMode != old.themeMode;
}
