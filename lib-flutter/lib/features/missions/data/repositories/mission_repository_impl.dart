import 'dart:ui';

import '../models/mission.dart';

/// Mission repository implementation
class MissionRepositoryImpl {
  // In-memory cache of missions (would be loaded from API or local storage)
  final Map<String, Mission> _missionsCache = {};

  /// Load all missions
  Future<List<Mission>> loadMissions() async {
    if (_missionsCache.isEmpty) {
      _initializeMissions();
    }
    return _missionsCache.values.toList()..sort((a, b) => a.order.compareTo(b.order));
  }

  /// Get mission by ID
  Future<Mission?> getMission(String id) async {
    if (_missionsCache.isEmpty) {
      await loadMissions();
    }
    return _missionsCache[id];
  }

  /// Initialize default missions
  void _initializeMissions() {
    final missions = _getDefaultMissions();
    for (final mission in missions) {
      _missionsCache[mission.id] = mission;
    }
  }

  /// Get default missions for BitQuest
  List<Mission> _getDefaultMissions() {
    return [
      const Mission(
        id: 'bitcoin_basics',
        title: 'Bitcoin Basics',
        description: 'Learn the fundamentals of Bitcoin and why it matters.',
        icon: '₿',
        order: 1,
        xpReward: 100,
        unlocked: true,
        category: 'basics',
        levels: [
          Level(
            id: 'what_is_bitcoin',
            missionId: 'bitcoin_basics',
            title: 'What is Bitcoin?',
            content: '''
# What is Bitcoin?

Bitcoin is a decentralized digital currency that operates without a central authority or banks. It was created in 2009 by an anonymous person or group using the name Satoshi Nakamoto.

## Key Features:
- **Decentralized**: No single entity controls Bitcoin
- **Limited Supply**: Only 21 million bitcoins will ever exist
- **Peer-to-Peer**: Transactions happen directly between users
- **Secure**: Protected by cryptographic algorithms

Bitcoin allows you to send money anywhere in the world, instantly, with low fees, and without needing permission from any bank or government.
''',
            order: 1,
            xpReward: 25,
            quiz: [
              QuizQuestion(
                id: 'q1',
                question: 'When was Bitcoin created?',
                options: ['2008', '2009', '2010', '2012'],
                correctIndex: 1,
                explanation: 'Bitcoin was launched in January 2009.',
              ),
              QuizQuestion(
                id: 'q2',
                question: 'What is the maximum supply of Bitcoin?',
                options: ['10 million', '21 million', '100 million', 'Unlimited'],
                correctIndex: 1,
                explanation: 'Bitcoin has a hard cap of 21 million coins.',
              ),
            ],
          ),
          Level(
            id: 'how_bitcoin_works',
            missionId: 'bitcoin_basics',
            title: 'How Bitcoin Works',
            content: '''
# How Bitcoin Works

Bitcoin uses a technology called blockchain to maintain a public ledger of all transactions.

## The Blockchain:
A blockchain is like a digital notebook that everyone can see but no one can erase. Each "page" in this notebook is called a block.

## Mining:
Special computers called miners verify transactions and add them to the blockchain. They're rewarded with new bitcoins for their work.

## Wallets:
Bitcoin wallets store your private keys - secret numbers that prove you own your bitcoins.
''',
            order: 2,
            xpReward: 25,
          ),
          Level(
            id: 'bitcoin_properties',
            missionId: 'bitcoin_basics',
            title: 'Bitcoin Properties',
            content: '''
# Bitcoin Properties

## Scarcity
Only 21 million bitcoins will ever exist. This makes Bitcoin scarce like gold.

## Divisibility
One bitcoin can be divided into 100 million smaller units called satoshis.

## Portability
You can carry billions of dollars worth of Bitcoin in your memory or on a small device.

## Durability
Bitcoin cannot be destroyed as long as the network exists.

## Fungibility
Each bitcoin is interchangeable with another bitcoin.
''',
            order: 3,
            xpReward: 25,
          ),
        ],
        color: const Color(0xFF2196F3),
      ),
      const Mission(
        id: 'mining_basics',
        title: 'Mining & Consensus',
        description: 'Understand how Bitcoin mining works and secures the network.',
        icon: '⛏️',
        order: 2,
        xpReward: 150,
        unlocked: false,
        category: 'intermediate',
        levels: [
          Level(
            id: 'what_is_mining',
            missionId: 'mining_basics',
            title: 'What is Mining?',
            content: '''
# Bitcoin Mining

Mining is the process of adding new transactions to the Bitcoin blockchain.

## What Miners Do:
1. Collect pending transactions
2. Verify they are valid
3. Bundle them into blocks
4. Solve a complex mathematical puzzle
5. Add the block to the blockchain

## Mining Rewards:
- Block subsidy (newly created bitcoins)
- Transaction fees
''',
            order: 1,
            xpReward: 30,
          ),
          Level(
            id: 'proof_of_work',
            missionId: 'mining_basics',
            title: 'Proof of Work',
            content: '''
# Proof of Work

Bitcoin uses Proof of Work (PoW) to secure its network.

## How it Works:
- Miners compete to find a hash below a target value
- This requires enormous computing power
- The first miner to find it gets to add the block
- Other miners verify and accept the new block

## Why It Matters:
- Prevents spam attacks
- Makes cheating extremely expensive
- Ensures network security
''',
            order: 2,
            xpReward: 30,
          ),
        ],
        color: const Color(0xFF2196F3),
      ),
      const Mission(
        id: 'wallets_security',
        title: 'Wallets & Security',
        description: 'Learn how to store your Bitcoin safely.',
        icon: '🔐',
        order: 3,
        xpReward: 150,
        unlocked: false,
        category: 'intermediate',
        color: const Color(0xFF2196F3),
      ),
      const Mission(
        id: 'lightning_network',
        title: 'Lightning Network',
        description: 'Discover Bitcoin\'s second layer for instant payments.',
        icon: '⚡',
        order: 4,
        xpReward: 200,
        unlocked: false,
        category: 'advanced',
        color: const Color(0xFF2196F3),
      ),
      const Mission(
        id: 'bitcoin_economics',
        title: 'Bitcoin Economics',
        description: 'Understand Bitcoin\'s monetary policy and value.',
        icon: '📊',
        order: 5,
        xpReward: 200,
        unlocked: false,
        category: 'advanced',
        color: const Color(0xFF2196F3),
      ),
    ];
  }

  /// Unlock a mission
  Future<Mission> unlockMission(String missionId) async {
    final mission = _missionsCache[missionId];
    if (mission == null) throw Exception('Mission not found');
    
    final updatedMission = mission.copyWith(unlocked: true);
    _missionsCache[missionId] = updatedMission;
    return updatedMission;
  }

  /// Complete a level
  Future<Mission> completeLevel(
    String missionId,
    String levelId,
  ) async {
    final mission = _missionsCache[missionId];
    if (mission == null) throw Exception('Mission not found');
    
    final updatedLevels = mission.levels.map((level) {
      if (level.id == levelId) {
        return level.copyWith(completed: true);
      }
      return level;
    }).toList();
    
    final updatedMission = mission.copyWith(levels: updatedLevels);
    _missionsCache[missionId] = updatedMission;
    return updatedMission;
  }
}
