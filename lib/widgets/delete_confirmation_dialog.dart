import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({required this.onConfirm, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(
        'Delete Swing',
        style: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this swing? This action cannot be undone.',
        style: GoogleFonts.inter(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: GoogleFonts.inter(color: AppColors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: Text(
            'Delete',
            style: GoogleFonts.inter(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  static Future<void> show(BuildContext context, VoidCallback onConfirm) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return DeleteConfirmationDialog(onConfirm: onConfirm);
      },
    );
  }
}
