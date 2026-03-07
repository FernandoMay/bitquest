import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Service for local storage operations
class StorageService {
  final SharedPreferences _prefs;

  StorageService({required SharedPreferences prefs}) : _prefs = prefs;

  /// Initialize storage service
  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs: prefs);
  }

  // ============ Player Data ============

  /// Save player data
  Future<bool> savePlayerData(Map<String, dynamic> data) async {
    final jsonString = json.encode(data);
    return _prefs.setString(AppConstants.playerKey, jsonString);
  }

  /// Get player data
  Map<String, dynamic>? getPlayerData() {
    final jsonString = _prefs.getString(AppConstants.playerKey);
    if (jsonString == null) return null;
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  /// Clear player data
  Future<bool> clearPlayerData() async {
    return _prefs.remove(AppConstants.playerKey);
  }

  // ============ Mission Progress ============

  /// Save mission progress
  Future<bool> saveMissionProgress(Map<String, dynamic> progress) async {
    final jsonString = json.encode(progress);
    return _prefs.setString(AppConstants.missionsKey, jsonString);
  }

  /// Get mission progress
  Map<String, dynamic>? getMissionProgress() {
    final jsonString = _prefs.getString(AppConstants.missionsKey);
    if (jsonString == null) return null;
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  // ============ Settings ============

  /// Save app settings
  Future<bool> saveSettings(Map<String, dynamic> settings) async {
    final jsonString = json.encode(settings);
    return _prefs.setString(AppConstants.settingsKey, jsonString);
  }

  /// Get app settings
  Map<String, dynamic>? getSettings() {
    final jsonString = _prefs.getString(AppConstants.settingsKey);
    if (jsonString == null) return _defaultSettings();
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  Map<String, dynamic> _defaultSettings() {
    return {
      'soundEnabled': true,
      'vibrationEnabled': true,
      'notificationsEnabled': true,
      'darkMode': true,
      'language': 'en',
    };
  }

  // ============ Onboarding ============

  /// Check if onboarding is complete
  bool isOnboardingComplete() {
    return _prefs.getBool(AppConstants.onboardingKey) ?? false;
  }

  /// Mark onboarding as complete
  Future<bool> setOnboardingComplete(bool value) async {
    return _prefs.setBool(AppConstants.onboardingKey, value);
  }

  // ============ Generic Methods ============

  /// Save a string value
  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  /// Get a string value
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Save an integer value
  Future<bool> setInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  /// Get an integer value
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// Save a double value
  Future<bool> setDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  /// Get a double value
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  /// Save a boolean value
  Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  /// Get a boolean value
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Save a list of strings
  Future<bool> setStringList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  /// Get a list of strings
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  /// Check if a key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  /// Remove a key
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  /// Clear all storage
  Future<bool> clearAll() async {
    return _prefs.clear();
  }

  /// Get all keys
  Set<String> getAllKeys() {
    return _prefs.getKeys();
  }
}

/// Model for app settings
class AppSettings {
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool notificationsEnabled;
  final bool darkMode;
  final String language;

  AppSettings({
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.notificationsEnabled = true,
    this.darkMode = true,
    this.language = 'en',
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      darkMode: json['darkMode'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'notificationsEnabled': notificationsEnabled,
      'darkMode': darkMode,
      'language': language,
    };
  }

  AppSettings copyWith({
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? notificationsEnabled,
    bool? darkMode,
    String? language,
  }) {
    return AppSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
    );
  }
}
