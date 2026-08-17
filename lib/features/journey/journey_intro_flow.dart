import 'package:flutter/material.dart';

class JourneyIntroFlow extends StatefulWidget {
  final String language;
  final String flag;
  final String greeting;
  final String backgroundAsset;
  final String guideKey;
  final String guideName;

  const JourneyIntroFlow({
    super.key,
    required this.language,
    required this.flag,
    required this.greeting,
    required this.backgroundAsset,
    required this.guideKey,
    required this.guideName,
  });

  @override
  State<JourneyIntroFlow> createState() => _JourneyIntroFlowState();
}

class _JourneyIntroFlowState extends State<JourneyIntroFlow> {
  int _step = 1;
  String? _selectedLevel;
  final TextEditingController _nameController = TextEditingController();

  String get learningGreeting {
    switch (widget.language) {
      case 'Türkçe':
        return 'Merhaba!';
      case 'Ελληνικά':
        return 'Γεια σου!';
      default:
        return 'Hello!';
    }
  }

  bool get _isLeon => widget.guideKey == 'leon';

  String get _guideAsset {
    if (_step == 2) {
      return _isLeon
          ? 'assets/characters/leon_confident.png'
          : 'assets/characters/maria_confident.png';
    }
    if (_step == 3) {
      return _isLeon
          ? 'assets/characters/leon_relaxed.png'
          : 'assets/characters/maria_thinking.png';
    }
    return _isLeon
        ? 'assets/characters/leon_invite.png'
        : 'assets/characters/maria_welcome.png';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final landscape = screen.width > screen.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF050508),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            widget.backgroundAsset,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) =>
                const ColoredBox(color: Color(0xFF050508)),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x16000000),
                  Color(0x08000000),
                  Color(0xB8000000),
                ],
                stops: [0.0, 0.50, 1.0],
              ),
            ),
          ),
          _guideLayer(screen, landscape),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                landscape ? 24 : 18,
                landscape ? 8 : 12,
                landscape ? 24 : 18,
                landscape ? 10 : 18,
              ),
              child: _buildStep(screen, landscape),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(Size screen, bool landscape) {
    switch (_step) {
      case 2:
        return landscape
            ? _stepTwoLandscape(screen)
            : _stepTwoPortrait(screen);
      case 3:
        return landscape
            ? _stepThreeLandscape(screen)
            : _stepThreePortrait(screen);
      default:
        return landscape
            ? _stepOneLandscape(screen)
            : _stepOnePortrait(screen);
    }
  }

  Widget _guideLayer(Size screen, bool landscape) {
    if (landscape) {
      final onRight = _step == 2;
      return Positioned(
        left: onRight ? null : (_step == 3 ? -8 : -18),
        right: onRight ? -12 : null,
        bottom: -6,
        child: IgnorePointer(
          child: SizedBox(
            width: screen.width * (_step == 2 ? 0.31 : (_step == 3 ? 0.32 : 0.34)),
            height: screen.height * 0.86,
            child: Image.asset(
              _guideAsset,
              fit: BoxFit.contain,
              alignment: onRight ? Alignment.bottomRight : Alignment.bottomLeft,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ),
      );
    }

    final onRight = _step == 2;
    return Positioned(
      left: onRight ? null : (_step == 3 ? -28 : -34),
      right: onRight ? -42 : null,
      bottom: _step == 2 ? 108 : (_step == 3 ? 122 : 138),
      child: IgnorePointer(
        child: SizedBox(
          width: screen.width * (_step == 2 ? 0.61 : (_step == 3 ? 0.62 : 0.67)),
          height: screen.height * (_step == 2 ? 0.58 : (_step == 3 ? 0.56 : 0.61)),
          child: Image.asset(
            _guideAsset,
            fit: BoxFit.contain,
            alignment: onRight ? Alignment.bottomRight : Alignment.bottomLeft,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Widget _stepOnePortrait(Size screen) {
    return Column(
      children: [
        _header('1 / 8', () => Navigator.of(context).pop()),
        const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: _welcomeCard(width: screen.width * 0.68, compact: false),
        ),
        const SizedBox(height: 16),
        _pinkButton('Weiter', () => setState(() => _step = 2)),
      ],
    );
  }

  Widget _stepOneLandscape(Size screen) {
    return Column(
      children: [
        _header('1 / 8', () => Navigator.of(context).pop()),
        const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: _welcomeCard(width: screen.width * 0.56, compact: true),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: screen.width * 0.48,
            child: _pinkButton(
              'Weiter',
              () => setState(() => _step = 2),
              height: 50,
            ),
          ),
        ),
      ],
    );
  }

  Widget _welcomeCard({required double width, required bool compact}) {
    return Container(
      width: width,
      padding: EdgeInsets.fromLTRB(
        compact ? 22 : 18,
        18,
        compact ? 22 : 18,
        compact ? 18 : 20,
      ),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.favorite_rounded,
                color: Color(0xFFFF2E9A),
                size: 21,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  learningGreeting,
                  style: TextStyle(
                    color: const Color(0xFFFF5BAE),
                    fontSize: compact ? 16 : 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 8 : 12),
          Text(
            '${widget.guideName} begrüßt dich',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              height: 1.08,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: compact ? 8 : 12),
          const Divider(color: Color(0xCCFF2E9A), thickness: 1.2),
          SizedBox(height: compact ? 8 : 12),
          Text(
            'Schön, dass du da bist. Bevor wir gemeinsam auf Reisen gehen, möchte ich dich ein wenig kennenlernen.',
            style: TextStyle(
              color: const Color(0xFFF2EDF2),
              fontSize: compact ? 14 : 14.5,
              height: compact ? 1.32 : 1.42,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: compact ? 10 : 14),
          Text(
            '${widget.flag} ${widget.language}',
            style: TextStyle(
              color: const Color(0xFFFF5BAE),
              fontSize: compact ? 17 : 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepTwoPortrait(Size screen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header('2 / 8', _backToStepOne),
        const Spacer(),
        Align(
          alignment: Alignment.centerLeft,
          child: _nameCard(width: screen.width * 0.66, compact: false),
        ),
        const SizedBox(height: 16),
        _continueNameButton(),
      ],
    );
  }

  Widget _stepTwoLandscape(Size screen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header('2 / 8', _backToStepOne),
        const Spacer(),
        Align(
          alignment: Alignment.centerLeft,
          child: _nameCard(width: screen.width * 0.62, compact: true),
        ),
        const SizedBox(height: 9),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: screen.width * 0.47,
            child: _continueNameButton(height: 50),
          ),
        ),
      ],
    );
  }

  Widget _nameCard({required double width, required bool compact}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'LERNEN WIR UNS KENNEN',
            style: TextStyle(
              color: const Color(0xFFFF5BAE),
              fontSize: compact ? 14 : 14.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: compact ? 6 : 9),
          Text(
            'Wie darf ich dich nennen?',
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 25 : 27,
              height: 1.07,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: compact ? 6 : 9),
          Text(
            'Dein Name macht deine Reise persönlicher. ${widget.guideName} wird dich während des Lernens damit ansprechen.',
            style: TextStyle(
              color: const Color(0xFFF2EDF2),
              fontSize: 13.5,
              height: compact ? 1.28 : 1.36,
            ),
          ),
          SizedBox(height: compact ? 10 : 14),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onChanged: (_) => setState(() {}),
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 17 : 18,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: 'Dein Vorname',
              hintStyle: const TextStyle(color: Color(0xFFAAA3AC)),
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: Color(0xFFFF2E9A),
              ),
              filled: true,
              fillColor: const Color(0xE61E1C22),
              contentPadding: EdgeInsets.symmetric(
                horizontal: compact ? 14 : 15,
                vertical: compact ? 12 : 15,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Color(0xFF514A56)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Color(0xFFFF2E9A),
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: compact ? 9 : 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(compact ? 10 : 12),
            decoration: BoxDecoration(
              color: const Color(0xC91E1C22),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: const Color(0xFF3C3740)),
            ),
            child: Row(
              children: [
                Text(widget.flag, style: TextStyle(fontSize: compact ? 22 : 24)),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Du lernst ${widget.language} – Schritt für Schritt und in deinem Tempo.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      height: 1.25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepThreePortrait(Size screen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header('3 / 8', _backToStepTwo),
        const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: _levelCard(width: screen.width * 0.72, compact: false),
        ),
        const SizedBox(height: 16),
        _continueLevelButton(),
      ],
    );
  }

  Widget _stepThreeLandscape(Size screen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header('3 / 8', _backToStepTwo),
        const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: _levelCard(width: screen.width * 0.64, compact: true),
        ),
        const SizedBox(height: 9),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: screen.width * 0.47,
            child: _continueLevelButton(height: 50),
          ),
        ),
      ],
    );
  }

  Widget _levelCard({required double width, required bool compact}) {
    return Container(
      width: width,
      padding: EdgeInsets.all(compact ? 16 : 18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'DEIN STARTPUNKT',
            style: TextStyle(
              color: const Color(0xFFFF5BAE),
              fontSize: compact ? 13.5 : 14.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: compact ? 5 : 8),
          Text(
            'Wo stehst du gerade?',
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 24 : 27,
              height: 1.07,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: compact ? 5 : 8),
          Text(
            '${widget.guideName} passt deine ersten Schritte an dein aktuelles Niveau an.',
            style: TextStyle(
              color: const Color(0xFFF2EDF2),
              fontSize: compact ? 12.5 : 13.5,
              height: 1.3,
            ),
          ),
          SizedBox(height: compact ? 8 : 12),
          _levelOption(
            'new',
            Icons.auto_awesome_rounded,
            'Ich starte ganz neu',
            'Keine oder fast keine Vorkenntnisse',
            compact,
          ),
          SizedBox(height: compact ? 6 : 8),
          _levelOption(
            'words',
            Icons.chat_bubble_outline_rounded,
            'Ich kenne ein paar Wörter',
            'Begrüßungen und einzelne Begriffe sind mir vertraut',
            compact,
          ),
          SizedBox(height: compact ? 6 : 8),
          _levelOption(
            'sentences',
            Icons.record_voice_over_rounded,
            'Ich kann einfache Sätze',
            'Kurze Alltagssituationen klappen schon',
            compact,
          ),
          SizedBox(height: compact ? 6 : 8),
          _levelOption(
            'restart',
            Icons.refresh_rounded,
            'Ich möchte wieder einsteigen',
            'Ich habe früher gelernt und möchte auffrischen',
            compact,
          ),
        ],
      ),
    );
  }

  Widget _levelOption(
    String value,
    IconData icon,
    String title,
    String subtitle,
    bool compact,
  ) {
    final selected = _selectedLevel == value;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedLevel = value),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 11 : 12,
            vertical: compact ? 8 : 10,
          ),
          decoration: BoxDecoration(
            color: selected ? const Color(0x3DFF2E9A) : const Color(0xC91E1C22),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? const Color(0xFFFF2E9A) : const Color(0xFF3C3740),
              width: selected ? 1.8 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFFFF2E9A), size: compact ? 21 : 23),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 12.5 : 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: const Color(0xFFD7D0D7),
                        fontSize: compact ? 10.5 : 11.5,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle_rounded, color: Color(0xFFFF2E9A), size: 21),
            ],
          ),
        ),
      ),
    );
  }

  void _backToStepOne() {
    FocusScope.of(context).unfocus();
    setState(() => _step = 1);
  }

  void _backToStepTwo() {
    FocusScope.of(context).unfocus();
    setState(() => _step = 2);
  }

  Widget _continueNameButton({double height = 62}) {
    return _pinkButton(
      'Weiter',
      _nameController.text.trim().isEmpty
          ? null
          : () {
              FocusScope.of(context).unfocus();
              setState(() => _step = 3);
            },
      height: height,
    );
  }

  Widget _continueLevelButton({double height = 62}) {
    return _pinkButton(
      'Weiter',
      _selectedLevel == null
          ? null
          : () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Danke, ${_nameController.text.trim()}! Dein Startpunkt ist gespeichert. Schritt 4 folgt als Nächstes.',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
      height: height,
    );
  }

  Widget _header(String step, VoidCallback onBack) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 34,
          ),
        ),
        Text(
          step,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: const Color(0xE817161A),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0x44FFFFFF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x77000000),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      );

  Widget _pinkButton(
    String label,
    VoidCallback? onPressed, {
    double height = 62,
  }) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFF2E9A),
          disabledBackgroundColor: const Color(0x88FF2E9A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: height < 55 ? 18 : 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.arrow_forward_rounded,
              size: height < 55 ? 24 : 28,
            ),
          ],
        ),
      ),
    );
  }
}
