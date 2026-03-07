import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/game_button.dart';
import 'components/game_progress.dart';

/// Inflation Simulator - Interactive chart showing MXN vs BTC value over time
/// Shows the purchasing power comparison between Mexican Peso and Bitcoin
class InflationSimulator extends StatefulWidget {
  final VoidCallback? onComplete;

  const InflationSimulator({
    super.key,
    this.onComplete,
  });

  @override
  State<InflationSimulator> createState() => _InflationSimulatorState();
}

class _InflationSimulatorState extends State<InflationSimulator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _selectedYear = 2015;
  bool _showTutorial = true;
  bool _showComparison = false;

  // Mock historical data for MXN vs BTC
  final Map<int, InflationData> _historicalData = {
    2015: InflationData(
      year: 2015,
      mxnToUsd: 15.87,
      btcToUsd: 275.0,
      mxnPurchasingPower: 1000.0,
      btcPurchasingPower: 1000.0,
    ),
    2016: InflationData(
      year: 2016,
      mxnToUsd: 18.70,
      btcToUsd: 960.0,
      mxnPurchasingPower: 849.0,
      btcPurchasingPower: 3491.0,
    ),
    2017: InflationData(
      year: 2017,
      mxnToUsd: 19.04,
      btcToUsd: 13300.0,
      mxnPurchasingPower: 833.0,
      btcPurchasingPower: 48364.0,
    ),
    2018: InflationData(
      year: 2018,
      mxnToUsd: 20.26,
      btcToUsd: 3750.0,
      mxnPurchasingPower: 783.0,
      btcPurchasingPower: 13636.0,
    ),
    2019: InflationData(
      year: 2019,
      mxnToUsd: 19.25,
      btcToUsd: 7200.0,
      mxnPurchasingPower: 824.0,
      btcPurchasingPower: 26182.0,
    ),
    2020: InflationData(
      year: 2020,
      mxnToUsd: 21.50,
      btcToUsd: 29000.0,
      mxnPurchasingPower: 738.0,
      btcPurchasingPower: 105455.0,
    ),
    2021: InflationData(
      year: 2021,
      mxnToUsd: 20.52,
      btcToUsd: 46200.0,
      mxnPurchasingPower: 773.0,
      btcPurchasingPower: 168000.0,
    ),
    2022: InflationData(
      year: 2022,
      mxnToUsd: 20.10,
      btcToUsd: 16500.0,
      mxnPurchasingPower: 789.0,
      btcPurchasingPower: 60000.0,
    ),
    2023: InflationData(
      year: 2023,
      mxnToUsd: 17.15,
      btcToUsd: 42000.0,
      mxnPurchasingPower: 925.0,
      btcPurchasingPower: 152727.0,
    ),
    2024: InflationData(
      year: 2024,
      mxnToUsd: 17.20,
      btcToUsd: 67000.0,
      mxnPurchasingPower: 922.0,
      btcPurchasingPower: 243636.0,
    ),
    2025: InflationData(
      year: 2025,
      mxnToUsd: 20.50,
      btcToUsd: 95000.0,
      mxnPurchasingPower: 774.0,
      btcPurchasingPower: 345455.0,
    ),
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onYearChanged(int year) {
    setState(() {
      _selectedYear = year;
      _showComparison = true;
    });
    _animationController.forward(from: 0);
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildIntroductionCard(),
                        const SizedBox(height: 20),
                        _buildYearSelector(),
                        const SizedBox(height: 24),
                        _buildComparisonChart(),
                        const SizedBox(height: 24),
                        _buildPurchasingPowerCards(),
                        const SizedBox(height: 24),
                        _buildKeyInsights(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_showTutorial)
              _buildTutorialOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButtonGame(
            icon: Icons.close,
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Close',
          ),
          const Column(
            children: [
              Text(
                'Inflation Simulator',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'MXN vs BTC Purchasing Power',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF16213E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.school, color: Color(0xFFF7931A), size: 16),
                SizedBox(width: 4),
                Text(
                  'Learn',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroductionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF7931A).withOpacity(0.2),
            const Color(0xFF16213E).withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF7931A).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFFF7931A)),
              SizedBox(width: 8),
              Text(
                'Understanding Inflation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Inflation erodes the purchasing power of traditional currencies over time. '
            'Bitcoin, with its fixed supply of 21 million coins, is designed as a deflationary asset.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Color(0xFFF7931A), size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Use the slider below to see how \$1,000 MXN invested in 2015 would have changed in value compared to the same amount in Bitcoin.',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
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

  Widget _buildYearSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Year',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '2015',
                    style: TextStyle(
                      color: _selectedYear == 2015
                          ? const Color(0xFFF7931A)
                          : Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '2025',
                    style: TextStyle(
                      color: _selectedYear == 2025
                          ? const Color(0xFFF7931A)
                          : Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFFF7931A),
                  inactiveTrackColor: const Color(0xFF16213E),
                  thumbColor: const Color(0xFFF7931A),
                  overlayColor: const Color(0xFFF7931A).withOpacity(0.2),
                  valueIndicatorColor: const Color(0xFFF7931A),
                  valueIndicatorTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Slider(
                  value: _selectedYear.toDouble(),
                  min: 2015,
                  max: 2025,
                  divisions: 10,
                  label: _selectedYear.toString(),
                  onChanged: (value) => _onYearChanged(value.round()),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$_selectedYear',
                style: const TextStyle(
                  color: Color(0xFFF7931A),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonChart() {
    final data = _historicalData[_selectedYear]!;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Purchasing Power Comparison',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              // Visual bar comparison
              _buildBarChart(data),
              const SizedBox(height: 24),
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem('Mexican Peso', Colors.red),
                  const SizedBox(width: 24),
                  _buildLegendItem('Bitcoin', const Color(0xFFF7931A)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBarChart(InflationData data) {
    final maxValue = data.btcPurchasingPower.clamp(1000.0, 400000.0);
    final mxnPercent = (data.mxnPurchasingPower / maxValue) * _animationController.value;
    final btcPercent = (data.btcPurchasingPower / maxValue) * _animationController.value;

    return Column(
      children: [
        // MXN Bar
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Text(
                  'MXN \$${_formatNumber(data.mxnPurchasingPower)}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 24,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: constraints.maxWidth * mxnPercent.clamp(0.02, 1.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red,
                              Colors.red.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // BTC Bar
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.currency_bitcoin, color: Color(0xFFF7931A), size: 20),
                const SizedBox(width: 8),
                Text(
                  'BTC \$${_formatNumber(data.btcPurchasingPower)}',
                  style: const TextStyle(
                    color: Color(0xFFF7931A),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFF7931A).withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: constraints.maxWidth * btcPercent.clamp(0.02, 1.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFF7931A),
                              const Color(0xFFF7931A).withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPurchasingPowerCards() {
    final data = _historicalData[_selectedYear]!;
    final mxnLoss = 100 - (data.mxnPurchasingPower / 10);
    final btcGain = (data.btcPurchasingPower / 10) - 100;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'MXN Value',
                value: '\$${_formatNumber(data.mxnPurchasingPower)}',
                subtitle: mxnLoss > 0
                    ? '-${mxnLoss.toStringAsFixed(1)}% since 2015'
                    : '+${(-mxnLoss).toStringAsFixed(1)}% since 2015',
                icon: Icons.trending_down,
                color: Colors.red,
                isNegative: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'BTC Value',
                value: '\$${_formatNumber(data.btcPurchasingPower)}',
                subtitle: '+${btcGain.toStringAsFixed(0)}% since 2015',
                icon: Icons.trending_up,
                color: const Color(0xFFF7931A),
                isNegative: false,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isNegative,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: isNegative ? Colors.red.withOpacity(0.7) : const Color(0xFF00D26A).withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyInsights() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_graph, color: Color(0xFFF7931A)),
              SizedBox(width: 8),
              Text(
                'Key Insights',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            'Fixed Supply',
            'Bitcoin has a maximum supply of 21 million coins, making it scarce and deflationary.',
          ),
          _buildInsightItem(
            'Inflation Protection',
            'Unlike fiat currencies that can be printed at will, Bitcoin\'s supply is algorithmically controlled.',
          ),
          _buildInsightItem(
            'Long Term Store of Value',
            'Historical data shows Bitcoin has preserved and increased purchasing power over time.',
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: const BoxDecoration(
              color: Color(0xFFF7931A),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialOverlay() {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withOpacity(0.9),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16213E),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.show_chart,
                        size: 64,
                        color: Color(0xFFF7931A),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Inflation Simulator',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Compare how Mexican Pesos and Bitcoin have changed in value from 2015 to 2025.\n\n'
                        'Slide through the years to see the dramatic difference!',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GameButton(
                  text: 'Start Learning',
                  onPressed: () => setState(() => _showTutorial = false),
                  icon: Icons.play_arrow,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }
}

/// Data model for inflation comparison
class InflationData {
  final int year;
  final double mxnToUsd;
  final double btcToUsd;
  final double mxnPurchasingPower;
  final double btcPurchasingPower;

  InflationData({
    required this.year,
    required this.mxnToUsd,
    required this.btcToUsd,
    required this.mxnPurchasingPower,
    required this.btcPurchasingPower,
  });
}
