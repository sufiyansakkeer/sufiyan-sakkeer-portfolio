// This file contains custom initialization logic for Flutter web

// The following line will be replaced with the Flutter.js content during build
{
  {
    flutter_js;
  }
}

// The following line will be replaced with Flutter build configuration during build
{
  {
    flutter_build_config;
  }
}

// Wait for the page to load before initializing Flutter
window.addEventListener("load", function () {
  // Create a function to hide our custom loading animation
  function hideLoadingAnimation() {
    const loadingElement = document.getElementById("loading");
    if (loadingElement) {
      loadingElement.style.opacity = "0";
      setTimeout(function () {
        loadingElement.style.display = "none";
      }, 300);
    }
  }

  // Configure Flutter to use our custom loading indicator
  window._flutter = window._flutter || {};
  window._flutter.loader = window._flutter.loader || {};
  window._flutter.loader.didCreateEngineInitializer = function () {
    // This prevents Flutter from showing its own loading indicator
    return true;
  };

  // Create config for the engine initializer
  const config = {
    // Use CanvasKit renderer for better animation performance
    renderer: "canvaskit",
    serviceWorker: {
      serviceWorkerVersion: serviceWorkerVersion,
    },
  };

  // Try to initialize Flutter
  try {
    // Initialize Flutter engine with the newer approach
    _flutter.loader.load({
      config: config,
      onEntrypointLoaded: async function (engineInitializer) {
        try {
          // Initialize the engine
          const appRunner = await engineInitializer.initializeEngine();

          // Make the hideLoadingScreen function available to the Flutter app
          window.hideLoadingScreen = hideLoadingAnimation;

          // Run the app - our custom loading animation will remain visible
          // until the app calls window.hideLoadingScreen()
          await appRunner.runApp();
        } catch (e) {
          console.error("Error during Flutter engine initialization:", e);
          hideLoadingAnimation(); // Hide loading screen even if there's an error
        }
      },
    });
  } catch (e) {
    console.error("Error during Flutter initialization:", e);

    // Fallback to a simple loader if everything else fails
    console.log("Using fallback Flutter loader");
    const scriptTag = document.createElement("script");
    scriptTag.src = "main.dart.js";
    scriptTag.type = "application/javascript";
    document.body.appendChild(scriptTag);

    // Make the hideLoadingScreen function available to the Flutter app
    window.hideLoadingScreen = hideLoadingAnimation;
  }
});
