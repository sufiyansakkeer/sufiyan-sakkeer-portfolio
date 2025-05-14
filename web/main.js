// Flutter web initialization script
window.addEventListener("load", function () {
  // Ensure serviceWorkerVersion is defined
  if (typeof serviceWorkerVersion === "undefined") {
    // Provide a default value if not set by the build process
    window.serviceWorkerVersion = null;
    console.log("serviceWorkerVersion was undefined, set to null as fallback");
  }

  // Safe message handling implementation
  try {
    // Setup safe message handling functions
    const messageTimeouts = {};

    // Safe message sender function
    window.sendSafeMessage = function (
      target,
      message,
      responseCallback,
      timeoutMs = 5000
    ) {
      const messageId = Date.now().toString() + Math.random().toString();

      // Set timeout to handle message port closure
      messageTimeouts[messageId] = setTimeout(() => {
        delete messageTimeouts[messageId];
        // Call callback with null to indicate timeout
        if (responseCallback) {
          responseCallback(null);
        }
      }, timeoutMs);

      try {
        // Wrap actual message sending in try-catch
        if (target && typeof target.postMessage === "function") {
          target.postMessage({ ...message, messageId }, "*");
        }
      } catch (msgError) {
        console.log("Handled message sending error:", msgError);
        clearTimeout(messageTimeouts[messageId]);
        delete messageTimeouts[messageId];
        if (responseCallback) {
          responseCallback(null);
        }
      }
    };

    // Handle incoming messages safely
    window.handleSafeMessage = function (event, handler) {
      try {
        if (handler && typeof handler === "function") {
          handler(event.data);
        }
      } catch (handlerError) {
        console.log("Handled message processing error:", handlerError);
      }
    };
  } catch (error) {
    console.log("Error setting up message handlers:", error);
  }
  // Create a function to hide our custom loading animation
  function hideLoadingAnimation() {
    try {
      const loadingElement = document.getElementById("loading");
      if (loadingElement) {
        loadingElement.style.opacity = "0";
        setTimeout(function () {
          try {
            loadingElement.style.display = "none";
          } catch (e) {
            console.log("Error hiding loading element:", e);
          }
        }, 300);
      }
    } catch (e) {
      console.log("Error in hideLoadingAnimation:", e);
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
  };

  // Only add serviceWorker config if serviceWorkerVersion is available
  if (serviceWorkerVersion) {
    config.serviceWorker = {
      serviceWorkerVersion: serviceWorkerVersion,
    };
  }

  // Try to initialize Flutter using the recommended approach
  try {
    // Ensure _flutter object exists
    if (typeof _flutter === "undefined" || !_flutter) {
      console.error("_flutter object is not defined. Creating it...");
      window._flutter = window._flutter || {};
      window._flutter.loader = window._flutter.loader || {};
    }

    // Ensure loader object exists
    if (!_flutter.loader) {
      console.error("_flutter.loader is not defined. Creating it...");
      _flutter.loader = {};
    }

    // Check if loadEntrypoint method exists
    if (typeof _flutter.loader.loadEntrypoint !== "function") {
      console.error(
        "_flutter.loader.loadEntrypoint is not a function. Using fallback initialization..."
      );
      throw new Error("Flutter loader not properly initialized");
    }

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

          // Setup error handler for runtime.lastError
          if (typeof chrome !== "undefined" && chrome.runtime) {
            const originalGetError = chrome.runtime.lastError;
            Object.defineProperty(chrome.runtime, "lastError", {
              get: function () {
                try {
                  return originalGetError;
                } catch (e) {
                  console.log("Safely handled runtime.lastError access");
                  return { message: "Error was prevented" };
                }
              },
            });
          }

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

      // Add error handling for script loading
      scriptTag.onerror = function (error) {
        console.error("Script loading failed:", error);
        // Show user-friendly error message if needed
        const errorElement = document.createElement("div");
        errorElement.style.position = "fixed";
        errorElement.style.top = "50%";
        errorElement.style.left = "50%";
        errorElement.style.transform = "translate(-50%, -50%)";
        errorElement.style.padding = "20px";
        errorElement.style.backgroundColor = "rgba(255,0,0,0.1)";
        errorElement.style.border = "1px solid red";
        errorElement.style.borderRadius = "5px";
        errorElement.textContent =
          "Application failed to load. Please try refreshing the page.";
        document.body.appendChild(errorElement);
      };

      document.body.appendChild(scriptTag);
    } catch (fallbackError) {
      console.error("Fallback initialization failed:", fallbackError);
    }
  }

  // Global error handler for uncaught exceptions
  window.addEventListener("error", function (event) {
    console.log("Global error caught:", event.error);
    // Prevent the error from bubbling up
    event.preventDefault();
    return true;
  });
});
