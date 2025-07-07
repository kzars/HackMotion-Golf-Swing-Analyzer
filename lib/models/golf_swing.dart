class GolfSwing {
  final SwingParameters parameters;

  // Additional properties for UI display
  final String id;
  final String displayName;

  GolfSwing({
    required this.parameters,
    required this.id,
    required this.displayName,
  });

  factory GolfSwing.fromJson(Map<String, dynamic> json, String fileName) {
    // Generate a unique ID from filename
    final id = fileName.replaceAll('.json', '');

    // Create a display name
    final displayName = 'Swing ${id.toUpperCase()}';

    return GolfSwing(
      parameters: SwingParameters.fromJson(json['parameters'] ?? {}),
      id: id,
      displayName: displayName,
    );
  }
}

class SwingParameters {
  final MetricData flexionExtension; // HFA_crWrFlexEx
  final MetricData ulnarRadial; // HFA_crWrRadUln
  final SwingPositionIndices positionIndices; // glfATICapPosInd

  SwingParameters({
    required this.flexionExtension,
    required this.ulnarRadial,
    required this.positionIndices,
  });

  factory SwingParameters.fromJson(Map<String, dynamic> json) {
    return SwingParameters(
      flexionExtension: MetricData.fromJson(json['HFA_crWrFlexEx'] ?? {}),
      ulnarRadial: MetricData.fromJson(json['HFA_crWrRadUln'] ?? {}),
      positionIndices: SwingPositionIndices.fromJson(
        json['glfATICapPosInd'] ?? {},
      ),
    );
  }
}

class MetricData {
  final List<double> values;

  MetricData({required this.values});

  factory MetricData.fromJson(Map<String, dynamic> json) {
    final values =
        (json['values'] as List<dynamic>?)
            ?.map((e) => (e as num).toDouble())
            .toList() ??
        [];

    return MetricData(values: values);
  }
}

class SwingPositionIndices {
  final int address;
  final int impact;
  final int top;

  SwingPositionIndices({
    required this.address,
    required this.impact,
    required this.top,
  });

  factory SwingPositionIndices.fromJson(Map<String, dynamic> json) {
    return SwingPositionIndices(
      address: json['address'] ?? 0,
      impact: json['impact'] ?? 0,
      top: json['top'] ?? 0,
    );
  }
}
