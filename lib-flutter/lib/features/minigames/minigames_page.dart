import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import 'widgets/minigame_card.dart';

class MinigamesPage extends StatelessWidget {
  const MinigamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: const Text('Mini-Juegos'),
        backgroundColor: AppColors.gray,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aprende Haciendo',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Simulaciones interactivas para dominar Bitcoin',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: const [
                  MinigameCard(
                    title: 'Build a Block',
                    description: 'Construye un bloque válido',
                    icon: '🧱',
                    difficulty: 'Medio',
                    xp: 100,
                    color: AppColors.bitcoinOrange,
                    isUnlocked: true,
                  ),
                  MinigameCard(
                    title: 'Mine the Hash',
                    description: 'Encuentra el hash correcto',
                    icon: '⛏️',
                    difficulty: 'Difícil',
                    xp: 150,
                    color: AppColors.success,
                    isUnlocked: true,
                  ),
                  MinigameCard(
                    title: 'Inflación MXN',
                    description: 'Simula la pérdida de valor',
                    icon: '📉',
                    difficulty: 'Fácil',
                    xp: 75,
                    color: AppColors.error,
                    isUnlocked: true,
                  ),
                  MinigameCard(
                    title: 'Lightning Race',
                    description: 'Carrera de pagos instantáneos',
                    icon: '⚡',
                    difficulty: 'Medio',
                    xp: 120,
                    color: AppColors.lightningPurple,
                    isUnlocked: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
