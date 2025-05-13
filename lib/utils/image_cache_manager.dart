import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// A custom cache manager for optimizing image loading and caching
class AppImageCacheManager {
  static final AppImageCacheManager _instance = AppImageCacheManager._internal();
  
  factory AppImageCacheManager() => _instance;
  
  AppImageCacheManager._internal();

  // Default cache manager instance
  final cacheManager = DefaultCacheManager();

  // Preload an image into the cache
  Future<void> preloadImage(String imageUrl) async {
    try {
      await cacheManager.getSingleFile(imageUrl);
    } catch (e) {
      debugPrint('Error preloading image: $e');
    }
  }

  // Preload multiple images into the cache
  Future<void> preloadImages(List<String> imageUrls) async {
    for (final url in imageUrls) {
      await preloadImage(url);
    }
  }

  // Clear the cache
  Future<void> clearCache() async {
    await cacheManager.emptyCache();
  }

  // Get the cached file for an image
  Future<FileInfo?> getCachedFile(String imageUrl) async {
    try {
      return await cacheManager.getFileFromCache(imageUrl);
    } catch (e) {
      debugPrint('Error getting cached file: $e');
      return null;
    }
  }
}

/// A widget that displays a cached network image with optimized loading
class OptimizedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Widget? placeholder;
  final Color? placeholderColor;
  final Duration fadeInDuration;
  final bool useOldImageOnUrlChange;

  const OptimizedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.placeholder,
    this.placeholderColor,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.useOldImageOnUrlChange = true,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration,
      useOldImageOnUrlChange: useOldImageOnUrlChange,
      cacheManager: AppImageCacheManager().cacheManager,
      placeholder: (context, url) {
        return placeholder ??
            Container(
              color: placeholderColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            );
      },
      errorWidget: errorWidget ??
          (context, url, error) {
            return Container(
              color: Colors.grey.shade300,
              child: Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          },
    );
  }
}
