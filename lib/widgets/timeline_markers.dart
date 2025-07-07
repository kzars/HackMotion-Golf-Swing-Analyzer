import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/golf_swing.dart';
import '../theme/app_colors.dart';

class TimelineMarkers extends StatefulWidget {
  final GolfSwing swing;
  final double maxX;
  final Function(int index) onMarkerPressed;
  final VoidCallback onMarkerReleased;

  const TimelineMarkers({
    required this.swing,
    required this.maxX,
    required this.onMarkerPressed,
    required this.onMarkerReleased,
    super.key,
  });

  @override
  State<TimelineMarkers> createState() => _TimelineMarkersState();
}

class _TimelineMarkersState extends State<TimelineMarkers> {
  int? _pressedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 26),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              _buildMarker(
                constraints.maxWidth,
                widget.swing.parameters.positionIndices.address,
                'assets/icons/golf_address.svg',
                'Address',
              ),
              _buildMarker(
                constraints.maxWidth,
                widget.swing.parameters.positionIndices.top,
                'assets/icons/golf_top.svg',
                'Top',
              ),
              _buildMarker(
                constraints.maxWidth,
                widget.swing.parameters.positionIndices.impact,
                'assets/icons/golf_impact.svg',
                'Impact',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMarker(
    double availableWidth,
    int index,
    String iconPath,
    String label,
  ) {
    final maxX = widget.maxX - 1;
    final normalizedPosition = maxX > 0 ? index / maxX : 0.0;
    var xPosition = normalizedPosition * availableWidth;

    if (index > widget.swing.parameters.positionIndices.address) {
      xPosition += 18.0;
    }

    final isPressed = _pressedIndex == index;

    return Positioned(
      left: xPosition - 15,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _pressedIndex = index);
          widget.onMarkerPressed(index);
        },
        onTapUp: (_) {
          setState(() => _pressedIndex = null);
          widget.onMarkerReleased();
        },
        onTapCancel: () {
          setState(() => _pressedIndex = null);
          widget.onMarkerReleased();
        },
        child: Container(
          // Add padding to increase the clickable area
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: isPressed
                ? AppColors.interactiveHighlight
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isPressed
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  iconPath,
                  width: 30,
                  height: 30,
                  colorFilter: ColorFilter.mode(
                    isPressed ? AppColors.primary : AppColors.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: isPressed
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
