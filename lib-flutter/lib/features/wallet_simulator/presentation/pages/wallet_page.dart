import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class WalletSimulatorPage extends StatefulWidget {
  const WalletSimulatorPage({super.key});

  @override
  State<WalletSimulatorPage> createState() => _WalletSimulatorPageState();
}

class _WalletSimulatorPageState extends State<WalletSimulatorPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  
  int _balance = 500; // Simulated balance in sats
  bool _isSending = false;
  
  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _simulateSend() async {
    if (_amountController.text.isEmpty) return;
    
    final amount = int.tryParse(_amountController.text) ?? 0;
    if (amount > _balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saldo insuficiente'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    setState(() => _isSending = true);
    
    // Simulate Lightning Network transaction (instant)
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _balance -= amount;
      _isSending = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚡ $amount sats enviados instantáneamente!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
    
    _amountController.clear();
    _addressController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: const Text('Wallet Lab'),
        backgroundColor: AppColors.gray,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.bitcoinOrange.withOpacity(0.3),
                    AppColors.lightningPurple.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.bitcoinOrange.withOpacity(0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Balance Demo',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.flash_on,
                        color: AppColors.bitcoinOrange,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$_balance',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          'sats',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '≈ \$${(_balance * 0.00003).toStringAsFixed(2)} USD',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Send Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.gray,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enviar Sats',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Address Input
                  TextField(
                    controller: _addressController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Dirección Lightning',
                      labelStyle: const TextStyle(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.grayLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(
                        Icons.key,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Amount Input
                  TextField(
                    controller: _amountController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Cantidad (sats)',
                      labelStyle: const TextStyle(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.grayLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(
                        Icons.flash_on,
                        color: AppColors.bitcoinOrange,
                      ),
                      suffixText: 'sats',
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Quick Amount Buttons
                  Row(
                    children: [
                      _buildQuickAmount(100),
                      const SizedBox(width: 8),
                      _buildQuickAmount(250),
                      const SizedBox(width: 8),
                      _buildQuickAmount(500),
                      const SizedBox(width: 8),
                      _buildQuickAmount(_balance),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Send Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSending ? null : _simulateSend,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.bitcoinOrange,
                        foregroundColor: AppColors.textDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.textDark,
                                ),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.flash_on),
                                SizedBox(width: 8),
                                Text(
                                  'Enviar por Lightning',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Education Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lightningPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.lightningPurple.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.lightningPurple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.school,
                          color: AppColors.lightningPurple,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '¿Sabías que?',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Lightning Network permite enviar Bitcoin de forma instantánea y con comisiones cercanas a cero. ¡Es ideal para pagos diarios y remesas!',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAmount(int amount) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _amountController.text = amount.toString();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.grayLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            amount == _balance ? 'Max' : '$amount',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
