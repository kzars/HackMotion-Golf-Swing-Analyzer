import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/golf_swing_cubit.dart';
import '../models/golf_swing.dart';
import '../widgets/golf_swing_chart.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../theme/app_colors.dart';

class InspectionPage extends StatelessWidget {
  const InspectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Inspection',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_rounded, color: AppColors.error),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: BlocListener<GolfSwingCubit, GolfSwingState>(
        listener: (context, state) {
          // Only navigate back to home if no swings are left after deletion
          if (state.swings.isEmpty) {
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<GolfSwingCubit, GolfSwingState>(
          builder: (context, state) {
            if (state.currentSwing == null) {
              return const Center(
                child: Text(
                  'No swing selected',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              );
            }

            final swing = state.currentSwing!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildSwingTitle(swing),
                  GolfSwingChart(swing: swing),
                  _buildNavigationControls(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSwingTitle(GolfSwing swing) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.sports_golf_rounded,
              color: AppColors.surface,
              size: 14,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            swing.displayName,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls(BuildContext context, GolfSwingState state) {
    final currentIndex = state.currentIndex ?? 0;
    final totalCount = state.swings.length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: currentIndex > 0
                ? () => context.read<GolfSwingCubit>().goToPrevious()
                : null,
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 28,
              color: currentIndex > 0 ? AppColors.primary : AppColors.disabled,
            ),
          ),
          Text(
            '${currentIndex + 1} of $totalCount',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          IconButton(
            onPressed: currentIndex < totalCount - 1
                ? () => context.read<GolfSwingCubit>().goToNext()
                : null,
            icon: Icon(
              Icons.arrow_forward_rounded,
              size: 28,
              color: currentIndex < totalCount - 1
                  ? AppColors.primary
                  : AppColors.disabled,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    DeleteConfirmationDialog.show(context, () {
      context.read<GolfSwingCubit>().deleteCurrentSwing();
    });
  }
}
