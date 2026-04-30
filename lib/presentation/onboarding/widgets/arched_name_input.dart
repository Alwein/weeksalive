import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ArchedNameInput extends StatefulWidget {
  const ArchedNameInput({
    super.key,
    this.initialValue,
    this.onChanged,
    this.autofocus = true,
    this.maxLength = 30,
    this.textCapitalization = TextCapitalization.sentences,
    this.fontSize = 32,
    this.color,
    this.arcRadius = 100,
    this.letterSpacing = 0.5,
    this.focusNode,
  });

  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final int maxLength;
  final TextCapitalization textCapitalization;
  final double fontSize;
  final Color? color;

  /// Radius of the imaginary circle the text follows. Larger = flatter arc.
  final double arcRadius;

  /// Extra spacing added between glyphs on the arc.
  final double letterSpacing;

  /// Optional external focus node. When provided, the parent can request focus
  /// (e.g. from an "Edit" button) by calling `focusNode.requestFocus()`.
  final FocusNode? focusNode;

  @override
  State<ArchedNameInput> createState() => _ArchedNameInputState();
}

class _ArchedNameInputState extends State<ArchedNameInput> with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final bool _ownsFocusNode;
  late final AnimationController _caretAnimation;

  String _value = '';

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? '';
    _controller = TextEditingController(text: _value);
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _caretAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    _caretAnimation.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() => _value = value);
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? DefaultTextStyle.of(context).style.color ?? Colors.black;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _focusNode.requestFocus(),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_caretAnimation, _focusNode]),
            builder: (context, _) {
              return CustomPaint(
                painter: _ArchedTextPainter(
                  text: _value,
                  caretOpacity: _focusNode.hasFocus ? _caretOpacity(_caretAnimation.value) : 0,
                  color: color,
                  fontSize: widget.fontSize,
                  radius: widget.arcRadius,
                  letterSpacing: widget.letterSpacing,
                ),
                size: Size(double.infinity, widget.fontSize * 2.2),
              );
            },
          ),
          SizedBox(
            width: 0,
            height: 0,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              maxLength: widget.maxLength,
              textCapitalization: widget.textCapitalization,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              showCursor: false,
              cursorColor: Colors.transparent,
              enableSuggestions: true,
              autocorrect: false,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[\n\r]')),
              ],
              style: const TextStyle(
                color: Colors.transparent,
                fontSize: 1,
                height: 0.01,
              ),
              decoration: const InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                counterText: '',
              ),
              onChanged: _onChanged,
            ),
          ),
        ],
      ),
    );
  }

  /// Square-ish blink so the caret stays visible longer than it's hidden
  /// (feels more natural than a pure sine wave).
  double _caretOpacity(double t) {
    final phase = (t * 2 * math.pi);
    final wave = (math.cos(phase) + 1) / 2;
    return wave > 0.5 ? 1.0 : 0.0;
  }
}

class _ArchedTextPainter extends CustomPainter {
  _ArchedTextPainter({
    required this.text,
    required this.caretOpacity,
    required this.color,
    required this.fontSize,
    required this.radius,
    required this.letterSpacing,
  });

  final String text;
  final double caretOpacity;
  final Color color;
  final double fontSize;
  final double radius;
  final double letterSpacing;

  static const String _caret = '|';
  static const String _fontFamily = 'ShadowsIntoLight';

  @override
  void paint(Canvas canvas, Size size) {
    final glyphs = <String>[...text.characters];

    // Measure each glyph individually. This keeps the arc correct even with
    // wide letters (W, M) or narrow ones (i, l).
    final painters = glyphs.map((g) => _paintFor(g)).toList();
    final caretPainter = _paintFor(_caret);

    // Total arc length consumed by the string, including letter spacing
    // between glyphs.
    double totalWidth = painters.fold<double>(0, (sum, p) => sum + p.width);
    if (painters.length > 1) {
      totalWidth += letterSpacing * (painters.length - 1);
    }

    // Convert width to an angle span around the arc center.
    final totalAngle = totalWidth / radius;

    // Center of the circle sits below the bottom edge: the text curves gently
    // downward at the edges (smile-like arc above the mascot's head).
    final center = Offset(size.width / 2, size.height + radius - fontSize * 0.9);

    // We start the first glyph to the left of the top of the arc.
    double angle = -math.pi / 2 - totalAngle / 2;

    for (var i = 0; i < painters.length; i++) {
      final p = painters[i];
      final glyphAngle = p.width / radius;
      // Place the glyph centered on its angular slot.
      final a = angle + glyphAngle / 2;
      _drawGlyph(canvas, p, center, a);
      angle += glyphAngle + (letterSpacing / radius);
    }

    if (caretOpacity > 0) {
      // Caret sits at the current cursor position (end of the text) and is
      // centered horizontally when the string is empty.
      final caretAngle = painters.isEmpty ? -math.pi / 2 : angle + (caretPainter.width / radius) / 2;
      _drawGlyph(
        canvas,
        caretPainter,
        center,
        caretAngle,
        opacity: caretOpacity,
      );
    }
  }

  TextPainter _paintFor(String char, {double opacity = 1}) {
    final tp = TextPainter(
      text: TextSpan(
        text: char,
        style: TextStyle(
          color: color.withValues(alpha: opacity),
          fontFamily: _fontFamily,
          fontSize: fontSize,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp;
  }

  void _drawGlyph(
    Canvas canvas,
    TextPainter painter,
    Offset center,
    double angle, {
    double opacity = 1,
  }) {
    // Position on the circle.
    final pos = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
    // Rotation tangent to the circle (text baseline follows the arc).
    final rotation = angle + math.pi / 2;

    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(rotation);
    if (opacity < 1) {
      canvas.saveLayer(
        Rect.fromLTWH(-painter.width, -painter.height, painter.width * 2, painter.height * 2),
        Paint()..color = Color.fromRGBO(0, 0, 0, opacity),
      );
    }
    painter.paint(canvas, Offset(-painter.width / 2, -painter.height));
    if (opacity < 1) {
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ArchedTextPainter old) {
    return old.text != text ||
        old.caretOpacity != caretOpacity ||
        old.color != color ||
        old.fontSize != fontSize ||
        old.radius != radius ||
        old.letterSpacing != letterSpacing;
  }
}
