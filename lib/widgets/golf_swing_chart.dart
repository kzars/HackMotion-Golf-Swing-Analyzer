import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/golf_swing.dart';
import '../theme/app_colors.dart';
import 'timeline_markers.dart';

class GolfSwingChart extends StatefulWidget {
  final GolfSwing swing;

  const GolfSwingChart({required this.swing, super.key});

  @override
  State<GolfSwingChart> createState() => _GolfSwingChartState();
}

class _GolfSwingChartState extends State<GolfSwingChart> {
  int? _highlightedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Swing graph',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap and drag on the graph to expand',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 340,
            child: Stack(
              children: [
                _buildLineChart(),
                if (_highlightedIndex != null) _buildTooltipOverlay(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TimelineMarkers(
            swing: widget.swing,
            maxX: _getMaxX(),
            onMarkerPressed: (index) =>
                setState(() => _highlightedIndex = index),
            onMarkerReleased: () => setState(() => _highlightedIndex = null),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(AppColors.chartPrimary, 'Flexion/Extension'),
              const SizedBox(width: 24),
              _buildLegendItem(AppColors.chartSecondary, 'Ulnar/Radial'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        backgroundColor: Colors.transparent,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => AppColors.surface,
            tooltipBorder: const BorderSide(color: AppColors.border, width: 1),
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot.bar.spots[barSpot.spotIndex];
                final isFlexion = barSpot.barIndex == 0;
                return LineTooltipItem(
                  '${isFlexion ? 'Flex/Ext' : 'Ulnar/Rad'}: ${flSpot.y.toStringAsFixed(1)}°',
                  GoogleFonts.inter(
                    color: isFlexion
                        ? AppColors.chartPrimary
                        : AppColors.chartSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) =>
              const FlLine(color: AppColors.border, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 20,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}°',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(bottom: BorderSide(color: AppColors.border)),
        ),
        minX: 0,
        maxX: _getMaxX(),
        minY: _getMinY(),
        maxY: _getMaxY(),
        lineBarsData: [_buildFlexionExtensionLine(), _buildUlnarRadialLine()],
      ),
    );
  }

  LineChartBarData _buildFlexionExtensionLine() {
    return LineChartBarData(
      spots: _getFlexionExtensionSpots(),
      isCurved: true,
      gradient: AppColors.chartPrimaryGradient,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: _highlightedIndex != null,
        checkToShowDot: (spot, barData) =>
            _highlightedIndex != null && spot.x.toInt() == _highlightedIndex,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 6,
          color: AppColors.chartPrimary,
          strokeWidth: 3,
          strokeColor: AppColors.surface,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [AppColors.chartPrimaryArea, AppColors.chartPrimaryAreaLight],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  LineChartBarData _buildUlnarRadialLine() {
    return LineChartBarData(
      spots: _getUlnarRadialSpots(),
      isCurved: true,
      gradient: AppColors.chartSecondaryGradient,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: _highlightedIndex != null,
        checkToShowDot: (spot, barData) =>
            _highlightedIndex != null && spot.x.toInt() == _highlightedIndex,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 6,
          color: AppColors.chartSecondary,
          strokeWidth: 3,
          strokeColor: AppColors.surface,
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // Chart data helper methods
  List<FlSpot> _getFlexionExtensionSpots() {
    return widget.swing.parameters.flexionExtension.values
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();
  }

  List<FlSpot> _getUlnarRadialSpots() {
    return widget.swing.parameters.ulnarRadial.values
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();
  }

  double _getMaxX() {
    final flexionLength =
        widget.swing.parameters.flexionExtension.values.length;
    final radialLength = widget.swing.parameters.ulnarRadial.values.length;
    return (flexionLength > radialLength ? flexionLength : radialLength)
        .toDouble();
  }

  double _getMinY() {
    final allValues = [
      ...widget.swing.parameters.flexionExtension.values,
      ...widget.swing.parameters.ulnarRadial.values,
    ];
    if (allValues.isEmpty) return -10;
    return allValues.reduce((a, b) => a < b ? a : b) - 10;
  }

  double _getMaxY() {
    final allValues = [
      ...widget.swing.parameters.flexionExtension.values,
      ...widget.swing.parameters.ulnarRadial.values,
    ];
    if (allValues.isEmpty) return 10;
    return allValues.reduce((a, b) => a > b ? a : b) + 10;
  }

  Widget _buildTooltipOverlay() {
    if (_highlightedIndex == null) return const SizedBox.shrink();

    final flexionSpots = _getFlexionExtensionSpots();
    final radialSpots = _getUlnarRadialSpots();

    if (_highlightedIndex! >= flexionSpots.length ||
        _highlightedIndex! >= radialSpots.length) {
      return const SizedBox.shrink();
    }

    final flexionValue = flexionSpots[_highlightedIndex!].y;
    final radialValue = radialSpots[_highlightedIndex!].y;

    // Calculate tooltip position
    final maxX = _getMaxX();
    final minY = _getMinY();
    final maxY = _getMaxY();
    final xPosition = (_highlightedIndex! / (maxX - 1)) * 340;
    final yPosition = 340 - ((flexionValue - minY) / (maxY - minY)) * 340;

    // Boundary calculations
    const tooltipWidth = 160.0;
    const tooltipHeight = 60.0;
    var leftPosition = (xPosition - (tooltipWidth / 2)).clamp(
      5.0,
      340 - tooltipWidth - 5,
    );
    var topPosition = yPosition - tooltipHeight - 10;
    if (topPosition < 0) topPosition = yPosition + 20;

    return Positioned(
      left: leftPosition,
      top: topPosition,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: const Border.fromBorderSide(
            BorderSide(color: AppColors.border, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowMedium,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Flex/Ext: ${flexionValue.toStringAsFixed(1)}°',
              style: GoogleFonts.inter(
                color: AppColors.chartPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Ulnar/Rad: ${radialValue.toStringAsFixed(1)}°',
              style: GoogleFonts.inter(
                color: AppColors.chartSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
