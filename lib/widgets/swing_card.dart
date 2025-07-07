import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/golf_swing.dart';
import '../theme/app_colors.dart';

class SwingCard extends StatelessWidget {
  final GolfSwing swing;
  final VoidCallback onTap;

  const SwingCard({required this.swing, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Golf icon with accent gradient
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.sports_golf_rounded,
                    color: AppColors.surface,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Swing details
                Expanded(
                  child: Text(
                    swing.displayName,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                // Arrow icon
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
