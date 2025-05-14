import 'package:flutter/foundation.dart';

/// A utility class to manage animation states across the app
class AnimationStateManager {
  // Private constructor for singleton
  AnimationStateManager._();

  // Singleton instance
  static final AnimationStateManager _instance = AnimationStateManager._();

  // Factory constructor to return the singleton instance
  factory AnimationStateManager() => _instance;

  // Animation state tracking
  final Map<String, bool> _playedAnimations = {};

  /// Check if a specific animation has already played
  bool hasAnimationPlayed(String animationKey) {
    return _playedAnimations[animationKey] ?? false;
  }

  /// Mark a specific animation as played
  void markAnimationPlayed(String animationKey) {
    _playedAnimations[animationKey] = true;
  }

  /// Reset the animation state (useful for testing or specific user actions)
  void resetAnimationState(String animationKey) {
    _playedAnimations[animationKey] = false;
  }

  /// Reset all animation states
  void resetAllAnimationStates() {
    _playedAnimations.clear();
  }
}

// Global instance for easy access
final animationStateManager = AnimationStateManager();