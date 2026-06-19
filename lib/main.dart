import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CompriceonApp());
}

// ─── Locale ───────────────────────────────────────────────────────────────────

enum AppLocale { ptBR, enUS }

class S {
  const S(this._l);
  final AppLocale _l;
  bool get _pt => _l == AppLocale.ptBR;

  String get subtitle => _pt
      ? 'Compare o preço por unidade de dois produtos'
      : 'Compare unit prices of two products';
  String get productA => _pt ? 'Produto A' : 'Product A';
  String get productB => _pt ? 'Produto B' : 'Product B';
  String get price => _pt ? 'Preço' : 'Price';
  String get quantity => _pt ? 'Quantidade' : 'Quantity';
  String get compare => _pt ? 'Comparar' : 'Compare';
  String get compareAgain => _pt ? 'Comparar novamente' : 'Compare again';
  String get bestOption => _pt ? 'Melhor opção' : 'Best option';
  String cheaperPerUnit(String pct) =>
      _pt ? '$pct% mais barato por unidade' : '$pct% cheaper per unit';
  String get tie => _pt ? 'Empate!' : 'Tie!';
  String get identicalPrice =>
      _pt ? 'Preço idêntico por unidade' : 'Identical unit price';
  String get required_ => _pt ? 'Obrigatório' : 'Required';
  String get invalid => _pt ? 'Inválido' : 'Invalid';
  String get settings => _pt ? 'Configurações' : 'Settings';
  String get language => _pt ? 'Idioma' : 'Language';
  String get supportTitle => _pt ? 'Apoiar o projeto' : 'Support the project';
  String get supportBody => _pt
      ? 'O Compriceon é gratuito e sem anúncios. Se ele te ajudou a economizar, considere apoiar o desenvolvimento — qualquer contribuição ajuda!'
      : 'Compriceon is free and ad-free. If it helped you save money, consider supporting its development — every contribution helps!';
  String get pixLabel => _pt ? 'PIX (Brasil)' : 'PIX (Brazil)';
  String get copied => _pt ? 'Copiado!' : 'Copied!';
}

class _LocaleScope extends InheritedWidget {
  final AppLocale locale;
  final void Function(AppLocale) setLocale;

  const _LocaleScope({
    required this.locale,
    required this.setLocale,
    required super.child,
  });

  static _LocaleScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_LocaleScope>()!;

  S get s => S(locale);

  @override
  bool updateShouldNotify(_LocaleScope old) => locale != old.locale;
}

// ─── App ──────────────────────────────────────────────────────────────────────

class CompriceonApp extends StatefulWidget {
  const CompriceonApp({super.key});

  @override
  State<CompriceonApp> createState() => _CompriceonAppState();
}

class _CompriceonAppState extends State<CompriceonApp> {
  AppLocale _locale = AppLocale.ptBR;

  @override
  Widget build(BuildContext context) {
    return _LocaleScope(
      locale: _locale,
      setLocale: (l) => setState(() => _locale = l),
      child: MaterialApp(
        title: 'Compriceon',
        debugShowCheckedModeBanner: false,
        theme: _theme(Brightness.light),
        darkTheme: _theme(Brightness.dark),
        themeMode: ThemeMode.system,
        home: const PriceComparatorPage(),
      ),
    );
  }

  static ThemeData _theme(Brightness b) {
    final dark = b == Brightness.dark;
    return ThemeData(
      brightness: b,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF007AFF),
        brightness: b,
      ),
      scaffoldBackgroundColor:
          dark ? const Color(0xFF000000) : const Color(0xFFF2F2F7),
      appBarTheme: AppBarTheme(
        backgroundColor:
            dark ? const Color(0xFF000000) : const Color(0xFFF2F2F7),
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle:
            dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
    );
  }
}

// ─── Page ─────────────────────────────────────────────────────────────────────

class PriceComparatorPage extends StatefulWidget {
  const PriceComparatorPage({super.key});

  @override
  State<PriceComparatorPage> createState() => _PriceComparatorPageState();
}

class _PriceComparatorPageState extends State<PriceComparatorPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _price1 = TextEditingController();
  final _qty1 = TextEditingController();
  final _price2 = TextEditingController();
  final _qty2 = TextEditingController();

  ComparisonResult? _result;
  late final AnimationController _ctrl;

  late final Animation<double> _winnerScale;
  late final Animation<double> _loserOpacity;
  late final Animation<double> _loserScale;
  late final Animation<double> _badgeOpacity;
  late final Animation<double> _badgeScale;
  late final Animation<double> _resultFade;
  late final Animation<Offset> _resultSlide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _winnerScale = Tween<double>(begin: 1.0, end: 1.025).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
      ),
    );
    _loserOpacity = Tween<double>(begin: 1.0, end: 0.38).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.05, 0.55, curve: Curves.easeInOutCubic),
      ),
    );
    _loserScale = Tween<double>(begin: 1.0, end: 0.965).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.05, 0.55, curve: Curves.easeInOutCubic),
      ),
    );
    _badgeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.3, 0.72, curve: Curves.easeOut),
      ),
    );
    _badgeScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.3, 0.75, curve: Curves.easeOutCubic),
      ),
    );
    _resultFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.42, 0.88, curve: Curves.easeOut),
      ),
    );
    _resultSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.38, 1.0, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _price1.dispose();
    _qty1.dispose();
    _price2.dispose();
    _qty2.dispose();
    super.dispose();
  }

  void _compare() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    HapticFeedback.mediumImpact();

    final p1 = double.parse(_price1.text.replaceAll(',', '.'));
    final q1 = double.parse(_qty1.text.replaceAll(',', '.'));
    final p2 = double.parse(_price2.text.replaceAll(',', '.'));
    final q2 = double.parse(_qty2.text.replaceAll(',', '.'));

    final u1 = p1 / q1;
    final u2 = p2 / q2;

    final int winner;
    final double saving;
    if (u1 < u2) {
      winner = 1;
      saving = ((u2 - u1) / u2) * 100;
    } else if (u2 < u1) {
      winner = 2;
      saving = ((u1 - u2) / u1) * 100;
    } else {
      winner = 0;
      saving = 0;
    }

    setState(() {
      _result = ComparisonResult(
        unitPrice1: u1,
        unitPrice2: u2,
        winner: winner,
        savingPercent: saving,
      );
    });
    _ctrl.forward(from: 0);
  }

  void _reset() {
    HapticFeedback.lightImpact();
    _ctrl
        .animateTo(0,
            duration: const Duration(milliseconds: 400), curve: Curves.easeInOutCubic)
        .then((_) {
      if (!mounted) return;
      setState(() {
        _result = null;
        _price1.clear();
        _qty1.clear();
        _price2.clear();
        _qty2.clear();
      });
    });
  }

  void _openSettings() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SettingsSheet(
        locale: _LocaleScope.of(context).locale,
        setLocale: _LocaleScope.of(context).setLocale,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = _LocaleScope.of(context).s;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AppHeader(
                  isDark: isDark,
                  subtitle: s.subtitle,
                  onSettingsTap: _openSettings,
                ),
                const SizedBox(height: 24),
                _buildCard(1, s),
                const SizedBox(height: 12),
                _buildCard(2, s),
                const SizedBox(height: 20),
                _CompareButton(
                  onPressed: _result != null ? _reset : _compare,
                  label: _result != null ? s.compareAgain : s.compare,
                ),
                if (_result != null) ...[
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _resultFade,
                    child: SlideTransition(
                      position: _resultSlide,
                      child: _ResultCard(result: _result!, s: s),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(int index, S s) {
    final priceCtrl = index == 1 ? _price1 : _price2;
    final qtyCtrl = index == 1 ? _qty1 : _qty2;
    final label = index == 1 ? s.productA : s.productB;

    if (_result == null || _result!.winner == 0) {
      return _ProductCard(
        label: label,
        priceController: priceCtrl,
        qtyController: qtyCtrl,
        priceLabel: s.price,
        qtyLabel: s.quantity,
        requiredMsg: s.required_,
        invalidMsg: s.invalid,
        state: CardState.neutral,
        scale: 1.0,
        opacity: 1.0,
        badgeOpacity: 0.0,
        badgeScale: 0.0,
        badgeLabel: s.bestOption,
      );
    }

    final isWinner = _result!.winner == index;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) => _ProductCard(
        label: label,
        priceController: priceCtrl,
        qtyController: qtyCtrl,
        priceLabel: s.price,
        qtyLabel: s.quantity,
        requiredMsg: s.required_,
        invalidMsg: s.invalid,
        state: isWinner ? CardState.winner : CardState.loser,
        scale: isWinner ? _winnerScale.value : _loserScale.value,
        opacity: isWinner ? 1.0 : _loserOpacity.value,
        badgeOpacity: isWinner ? _badgeOpacity.value : 0.0,
        badgeScale: isWinner ? _badgeScale.value : 0.0,
        badgeLabel: s.bestOption,
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _AppHeader extends StatelessWidget {
  final bool isDark;
  final String subtitle;
  final VoidCallback onSettingsTap;

  const _AppHeader({
    required this.isDark,
    required this.subtitle,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compriceon',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF8E8E93),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: onSettingsTap,
            icon: Icon(
              Icons.tune_rounded,
              color: isDark
                  ? Colors.white.withAlpha(115)
                  : Colors.black.withAlpha(115),
              size: 24,
            ),
            padding: const EdgeInsets.only(top: 18),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

// ─── Product Card ─────────────────────────────────────────────────────────────

enum CardState { neutral, winner, loser }

class _ProductCard extends StatelessWidget {
  final String label;
  final TextEditingController priceController;
  final TextEditingController qtyController;
  final String priceLabel;
  final String qtyLabel;
  final String requiredMsg;
  final String invalidMsg;
  final CardState state;
  final double scale;
  final double opacity;
  final double badgeOpacity;
  final double badgeScale;
  final String badgeLabel;

  const _ProductCard({
    required this.label,
    required this.priceController,
    required this.qtyController,
    required this.priceLabel,
    required this.qtyLabel,
    required this.requiredMsg,
    required this.invalidMsg,
    required this.state,
    required this.scale,
    required this.opacity,
    required this.badgeOpacity,
    required this.badgeScale,
    required this.badgeLabel,
  });

  static const _green = Color(0xFF34C759);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;

    final shadows = state == CardState.winner
        ? [
            BoxShadow(
              color: _green.withAlpha(51),
              blurRadius: 24,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 51 : 13),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ]
        : [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 38 : 10),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ];

    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: state == CardState.winner
                    ? Border.all(color: _green, width: 1.5)
                    : null,
                boxShadow: shadows,
              ),
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CardLabel(label: label, state: state, isDark: isDark),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _NumField(
                          controller: priceController,
                          label: priceLabel,
                          hint: '0,00',
                          prefix: 'R\$',
                          requiredMsg: requiredMsg,
                          invalidMsg: invalidMsg,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _NumField(
                          controller: qtyController,
                          label: qtyLabel,
                          hint: '1',
                          suffix: 'un',
                          requiredMsg: requiredMsg,
                          invalidMsg: invalidMsg,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (badgeOpacity > 0)
              Positioned(
                top: -12,
                right: 16,
                child: Opacity(
                  opacity: badgeOpacity,
                  child: Transform.scale(
                    scale: badgeScale,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _green,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: _green.withAlpha(77),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_rounded,
                              color: Colors.white, size: 13),
                          const SizedBox(width: 5),
                          Text(
                            badgeLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CardLabel extends StatelessWidget {
  final String label;
  final CardState state;
  final bool isDark;

  const _CardLabel({
    required this.label,
    required this.state,
    required this.isDark,
  });

  static const _green = Color(0xFF34C759);

  @override
  Widget build(BuildContext context) {
    final isWinner = state == CardState.winner;
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 450),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isWinner
                ? _green.withAlpha(31)
                : (isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isWinner
                ? Icons.emoji_events_rounded
                : Icons.shopping_bag_outlined,
            color: isWinner ? _green : const Color(0xFF8E8E93),
            size: 16,
          ),
        ),
        const SizedBox(width: 10),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 450),
          style: TextStyle(
            color: isWinner ? _green : (isDark ? Colors.white : Colors.black),
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: -0.2,
          ),
          child: Text(label),
        ),
      ],
    );
  }
}

// ─── Input Field ──────────────────────────────────────────────────────────────

class _NumField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? prefix;
  final String? suffix;
  final String requiredMsg;
  final String invalidMsg;

  const _NumField({
    required this.controller,
    required this.label,
    required this.hint,
    this.prefix,
    this.suffix,
    required this.requiredMsg,
    required this.invalidMsg,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fill = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7);
    const gray = Color(0xFF8E8E93);

    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ],
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: gray, fontSize: 13),
        hintText: hint,
        hintStyle: TextStyle(color: gray.withAlpha(153)),
        prefixText: prefix != null ? '$prefix ' : null,
        prefixStyle: const TextStyle(color: gray, fontSize: 16),
        suffixText: suffix,
        suffixStyle: const TextStyle(color: gray, fontSize: 13),
        filled: true,
        fillColor: fill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF007AFF), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF3B30), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF3B30), width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        errorStyle: const TextStyle(
            fontSize: 10, height: 0.8, color: Color(0xFFFF3B30)),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return requiredMsg;
        final n = double.tryParse(v.replaceAll(',', '.'));
        if (n == null || n <= 0) return invalidMsg;
        return null;
      },
    );
  }
}

// ─── Compare Button ───────────────────────────────────────────────────────────

class _CompareButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const _CompareButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF007AFF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}

// ─── Result Card ──────────────────────────────────────────────────────────────

class _ResultCard extends StatelessWidget {
  final ComparisonResult result;
  final S s;

  const _ResultCard({required this.result, required this.s});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final textPrimary = isDark ? Colors.white : Colors.black;

    final isTie = result.winner == 0;
    final winnerLabel = result.winner == 1 ? s.productA : s.productB;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 51 : 15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isTie) ...[
            _TieRow(textPrimary: textPrimary, s: s),
          ] else ...[
            _WinnerRow(
              winnerLabel: winnerLabel,
              savingPercent: result.savingPercent,
              textPrimary: textPrimary,
              s: s,
            ),
          ],
          const SizedBox(height: 16),
          _PriceRow(
            label: s.productA,
            unitPrice: result.unitPrice1,
            isWinner: result.winner == 1,
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _PriceRow(
            label: s.productB,
            unitPrice: result.unitPrice2,
            isWinner: result.winner == 2,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _WinnerRow extends StatelessWidget {
  final String winnerLabel;
  final double savingPercent;
  final Color textPrimary;
  final S s;

  const _WinnerRow({
    required this.winnerLabel,
    required this.savingPercent,
    required this.textPrimary,
    required this.s,
  });

  static const _green = Color(0xFF34C759);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _green.withAlpha(31),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.emoji_events_rounded, color: _green, size: 26),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                winnerLabel,
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 19,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                s.cheaperPerUnit(savingPercent.toStringAsFixed(1)),
                style: const TextStyle(
                  color: _green,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _green.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${savingPercent.toStringAsFixed(0)}%',
            style: const TextStyle(
              color: _green,
              fontWeight: FontWeight.w800,
              fontSize: 22,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _TieRow extends StatelessWidget {
  final Color textPrimary;
  final S s;

  const _TieRow({required this.textPrimary, required this.s});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF8E8E93).withAlpha(31),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.balance_rounded,
              color: Color(0xFF8E8E93), size: 26),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.tie,
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              s.identicalPrice,
              style: const TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double unitPrice;
  final bool isWinner;
  final bool isDark;

  const _PriceRow({
    required this.label,
    required this.unitPrice,
    required this.isWinner,
    required this.isDark,
  });

  static const _green = Color(0xFF34C759);

  static String _fmt(double v) {
    if (v >= 1) return v.toStringAsFixed(2);
    if (v >= 0.001) return v.toStringAsFixed(4);
    return v.toStringAsFixed(6);
  }

  @override
  Widget build(BuildContext context) {
    final bg = isWinner
        ? _green.withAlpha(20)
        : (isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7));

    return Container(
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          if (isWinner) ...[
            const Icon(Icons.check_circle_rounded, color: _green, size: 16),
            const SizedBox(width: 7),
          ] else
            const SizedBox(width: 23),
          Text(
            label,
            style: TextStyle(
              color: isWinner
                  ? _green
                  : (isDark ? Colors.white70 : Colors.black54),
              fontWeight: isWinner ? FontWeight.w600 : FontWeight.w400,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            'R\$ ${_fmt(unitPrice)}/un',
            style: TextStyle(
              color: isWinner
                  ? _green
                  : (isDark ? Colors.white54 : Colors.black38),
              fontWeight: isWinner ? FontWeight.w700 : FontWeight.w400,
              fontSize: 14,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Settings Sheet ───────────────────────────────────────────────────────────

class _SettingsSheet extends StatelessWidget {
  final AppLocale locale;
  final void Function(AppLocale) setLocale;

  const _SettingsSheet({required this.locale, required this.setLocale});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final handle = isDark ? const Color(0xFF48484A) : const Color(0xFFD1D1D6);
    final s = S(locale);

    return DraggableScrollableSheet(
      initialChildSize: 0.62,
      minChildSize: 0.4,
      maxChildSize: 0.88,
      expand: false,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: handle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                children: [
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      s.settings,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  // Language section
                  _SectionLabel(label: s.language, isDark: isDark),
                  const SizedBox(height: 8),
                  _LanguageSelector(
                    locale: locale,
                    setLocale: setLocale,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 24),
                  // Support section
                  _SupportSection(s: s, isDark: isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;

  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: isDark
            ? Colors.white.withAlpha(115)
            : Colors.black.withAlpha(115),
      ),
    );
  }
}

// ─── Language Selector ────────────────────────────────────────────────────────

class _LanguageSelector extends StatelessWidget {
  final AppLocale locale;
  final void Function(AppLocale) setLocale;
  final bool isDark;

  const _LanguageSelector({
    required this.locale,
    required this.setLocale,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);
    final selectedBg = isDark ? const Color(0xFF48484A) : Colors.white;
    final selectedShadow = isDark
        ? Colors.black.withAlpha(77)
        : Colors.black.withAlpha(26);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          _SegmentBtn(
            flag: '🇧🇷',
            label: 'Português',
            selected: locale == AppLocale.ptBR,
            selectedBg: selectedBg,
            selectedShadow: selectedShadow,
            isDark: isDark,
            onTap: () => setLocale(AppLocale.ptBR),
          ),
          _SegmentBtn(
            flag: '🇺🇸',
            label: 'English',
            selected: locale == AppLocale.enUS,
            selectedBg: selectedBg,
            selectedShadow: selectedShadow,
            isDark: isDark,
            onTap: () => setLocale(AppLocale.enUS),
          ),
        ],
      ),
    );
  }
}

class _SegmentBtn extends StatelessWidget {
  final String flag;
  final String label;
  final bool selected;
  final Color selectedBg;
  final Color selectedShadow;
  final bool isDark;
  final VoidCallback onTap;

  const _SegmentBtn({
    required this.flag,
    required this.label,
    required this.selected,
    required this.selectedBg,
    required this.selectedShadow,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: selected ? selectedBg : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: selectedShadow,
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(flag, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w400,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Support Section ──────────────────────────────────────────────────────────

class _SupportSection extends StatefulWidget {
  final S s;
  final bool isDark;

  const _SupportSection({required this.s, required this.isDark});

  @override
  State<_SupportSection> createState() => _SupportSectionState();
}

class _SupportSectionState extends State<_SupportSection> {
  static const _pixKey = '3a2b8066-7987-4e10-b0da-8ccc4c9da565';
  static const _pink = Color(0xFFEC4899);

  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    final isDark = widget.isDark;
    final onSurface = isDark ? Colors.white : Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: _pink.withAlpha(15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _pink.withAlpha(46)),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite_rounded, color: _pink, size: 20),
              const SizedBox(width: 10),
              Text(
                s.supportTitle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            s.supportBody,
            style: TextStyle(
              fontSize: 14,
              height: 1.55,
              color: onSurface.withAlpha(179),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            s.pixLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: onSurface.withAlpha(128),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () async {
              if (_copied) return;
              await Clipboard.setData(const ClipboardData(text: _pixKey));
              setState(() => _copied = true);
              await Future<void>.delayed(const Duration(milliseconds: 1500));
              if (mounted) setState(() => _copied = false);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: onSurface.withAlpha(13),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: onSurface.withAlpha(26)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _pixKey,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'monospace',
                        color: onSurface.withAlpha(217),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.6, end: 1.0)
                            .animate(anim),
                        child: child,
                      ),
                    ),
                    child: _copied
                        ? const Icon(Icons.check_rounded,
                            key: ValueKey('check'),
                            size: 16,
                            color: Color(0xFF34C759))
                        : Icon(Icons.copy_rounded,
                            key: const ValueKey('copy'),
                            size: 16,
                            color: onSurface.withAlpha(102)),
                  ),
                ],
              ),
            ),
          ),
          if (_copied) ...[
            const SizedBox(height: 6),
            Center(
              child: Text(
                s.copied,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF34C759),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Model ────────────────────────────────────────────────────────────────────

class ComparisonResult {
  final double unitPrice1;
  final double unitPrice2;
  final int winner;
  final double savingPercent;

  const ComparisonResult({
    required this.unitPrice1,
    required this.unitPrice2,
    required this.winner,
    required this.savingPercent,
  });
}
