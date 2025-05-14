// Flutter web initialization script
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

  // Try to initialize Flutter using the recommended approach
  try {
    // Load the Flutter entrypoint
    _flutter.loader.loadEntrypoint({
      // This callback is called when the entrypoint is loaded
      onEntrypointLoaded: async function (engineInitializer) {
        try {
          // Initialize the engine with the configuration
          // This is the ONLY place where we pass the config
          const appRunner = await engineInitializer.initializeEngine(config);

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
      // Specify the entrypoint if it's not the default 'main.dart.js'
      // entrypointUrl: "main.dart.js",
    });
  } catch (e) {
    console.error("Error during Flutter initialization:", e);
    hideLoadingAnimation(); // Hide loading screen even if there's an error

    // Fallback to a simpler approach if needed
    console.log("Attempting fallback initialization...");
    try {
      const scriptTag = document.createElement("script");
      scriptTag.src = "main.dart.js";
      scriptTag.type = "application/javascript";
      document.body.appendChild(scriptTag);
    } catch (fallbackError) {
      console.error("Fallback initialization failed:", fallbackError);
    }
  }
});
