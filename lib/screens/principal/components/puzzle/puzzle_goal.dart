import 'package:flutter/material.dart';
import 'dart:math';

import 'package:tcc/models/meta.dart';
import 'package:tcc/service/fake_meta_service.dart';
import 'package:tcc/screens/metas/cadastro/sign_up_goal.dart';

class PuzzleGoal extends StatefulWidget {
  final List<Meta> metas;
  final double verticalPaddingBottom;

  const PuzzleGoal({
    super.key,
    required this.metas,
    this.verticalPaddingBottom = 20.0, required Null Function(dynamic index) onPieceTap,
  });

  @override
  State<PuzzleGoal> createState() => _PuzzleGoalState();
}

class _PuzzleGoalState extends State<PuzzleGoal>
    with SingleTickerProviderStateMixin {
  int? pumpIndex;

  @override
  Widget build(BuildContext context) {
    final metas = widget.metas;
    final count = metas.length;

    final dimensions = _calculateGrid(count);
    final rows = dimensions.item1;
    final columns = dimensions.item2;

    return LayoutBuilder(builder: (context, constraints) {
      const horizontalPadding = 20.0;
      final verticalPaddingTop = max(10.0, 60.0 - rows * 5);

      final maxWidthArea = constraints.maxWidth - 2 * horizontalPadding;
      final maxHeightArea =
          constraints.maxHeight - verticalPaddingTop - widget.verticalPaddingBottom;

      final maxPieceWidth = maxWidthArea / columns;
      final maxPieceHeight = maxHeightArea / rows;
      final pieceSize = min(maxPieceWidth, maxPieceHeight);

      final puzzleWidth = pieceSize * columns;
      final puzzleHeight = pieceSize * rows;

      return Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          verticalPaddingTop,
          horizontalPadding,
          widget.verticalPaddingBottom,
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: puzzleWidth,
            height: puzzleHeight,
            child: Stack(
              children: List.generate(count, (index) {
                final row = index ~/ columns;
                final column = index % columns;

                final top = row == 0
                    ? SideType.flat
                    : (row % 2 == 0 ? SideType.outward : SideType.inward);

                final bottom = row == rows - 1
                    ? SideType.flat
                    : (row % 2 == 0 ? SideType.inward : SideType.outward);

                final left = column == 0
                    ? SideType.flat
                    : (column % 2 == 0 ? SideType.outward : SideType.inward);

                final right = column == columns - 1
                    ? SideType.flat
                    : (column % 2 == 0 ? SideType.inward : SideType.outward);

                final meta = metas[index];

                return Positioned(
                  left: column * pieceSize,
                  top: row * pieceSize,
                  width: pieceSize,
                  height: pieceSize,
                  child: GestureDetector(
                    onTap: () {
                      setState(() => pumpIndex = index);

                      FakeMetaService.instance.toggleFeita(meta);

                      Future.delayed(const Duration(milliseconds: 250), () {
                        setState(() => pumpIndex = null);
                      });
                    },
                    onLongPress: () => _showOptions(meta),
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 160),
                      scale: pumpIndex == index ? 1.15 : 1.0,
                      child: PuzzlePieceWidget(
                        meta: meta,
                        row: row,
                        column: column,
                        rows: rows,
                        columns: columns,
                        top: top,
                        bottom: bottom,
                        left: left,
                        right: right,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      );
    });
  }

  void _showOptions(Meta meta) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(meta.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // EDITAR
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text("Editar meta"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SignUpGoalScreen(editMeta: meta),
                    ),
                  ).then((_) => setState(() {}));
                },
              ),

              // DELETAR
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Excluir meta"),
                onTap: () {
                  FakeMetaService.instance.deleteMeta(meta);
                  Navigator.pop(context);
                  setState(() {});
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Tuple2<int, int> _calculateGrid(int count) {
    if (count <= 0) return Tuple2(1, 1);

    int columns = sqrt(count).ceil();
    int rows = (count / columns).ceil();

    return Tuple2(rows, columns);
  }
}

class Tuple2<A, B> {
  final A item1;
  final B item2;
  Tuple2(this.item1, this.item2);
}

class PuzzlePieceWidget extends StatelessWidget {
  final Meta meta;
  final int row, column, rows, columns;
  final SideType top, bottom, left, right;

  const PuzzlePieceWidget({
    super.key,
    required this.meta,
    required this.row,
    required this.column,
    required this.rows,
    required this.columns,
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PuzzlePiecePainter(
        color: meta.feita ? Colors.green : meta.color,
        top: top,
        bottom: bottom,
        left: left,
        right: right,
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(meta.icon, color: Colors.white, size: 22),
            const SizedBox(height: 4),
            Text(
              meta.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum SideType { flat, inward, outward }
enum Side { top, bottom, left, right }

class PuzzlePiecePainter extends CustomPainter {
  final Color color;
  final SideType top, bottom, left, right;

  PuzzlePiecePainter({
    required this.color,
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    final w = size.width;
    final h = size.height;
    final knobSize = min(w, h) * 0.2;

    path.moveTo(0, 0);

    _drawSide(path, w, 0, Side.top, top, knobSize);
    _drawSide(path, h, w, Side.right, right, knobSize);
    _drawSide(path, w, h, Side.bottom, bottom, knobSize);
    _drawSide(path, h, 0, Side.left, left, knobSize);

    path.close();

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [_darken(color, 0.3), _lighten(color, 0.1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);
  }

  Color _darken(Color color, [double amount = .2]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color _lighten(Color color, [double amount = .2]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  void _drawSide(Path path, double length, double offset, Side side,
      SideType type, double knobSize) {
    double third = length / 3;

    switch (side) {
      case Side.top:
        path.lineTo(third, 0);
        _drawKnob(path, Offset(third, 0), Offset(2 * third, 0), type, true);
        path.lineTo(length, 0);
        break;

      case Side.right:
        path.lineTo(offset, third);
        _drawKnob(path, Offset(offset, third), Offset(offset, 2 * third), type,
            false);
        path.lineTo(offset, length);
        break;

      case Side.bottom:
        path.lineTo(length - third, offset);
        _drawKnob(path, Offset(length - third, offset), Offset(third, offset),
            type, true,
            reverse: true);
        path.lineTo(0, offset);
        break;

      case Side.left:
        path.lineTo(0, length - third);
        _drawKnob(path, Offset(0, length - third), Offset(0, third), type,
            false,
            reverse: true);
        path.lineTo(0, 0);
        break;
    }
  }

  void _drawKnob(Path path, Offset from, Offset to, SideType type,
      bool horizontal,
      {bool reverse = false}) {
    if (type == SideType.flat) {
      path.lineTo(to.dx, to.dy);
      return;
    }

    final mid = Offset((from.dx + to.dx) / 2, (from.dy + to.dy) / 2);

    final knobRadius =
        (horizontal ? to.dx - from.dx : to.dy - from.dy) / 1.5;

    final knobDepth = (type == SideType.outward ? 1 : -1) * knobRadius;

    if (horizontal) {
      final direction = reverse ? -1 : 1;
      path.quadraticBezierTo(
          mid.dx, mid.dy + knobDepth * direction, to.dx, to.dy);
    } else {
      final direction = reverse ? -1 : 1;
      path.quadraticBezierTo(
          mid.dx + knobDepth * direction, mid.dy, to.dx, to.dy);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
