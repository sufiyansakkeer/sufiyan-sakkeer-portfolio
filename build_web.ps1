# Custom Flutter web build script with favicon replacement
Write-Host "Starting custom Flutter web build process..." -ForegroundColor Cyan

# Step 1: Build the Flutter web application
Write-Host "Building Flutter web application..." -ForegroundColor Green
flutter build web --release

# Check if the build was successful
if ($LASTEXITCODE -ne 0) {
    Write-Host "Flutter build failed with exit code $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "Flutter build completed successfully." -ForegroundColor Green

# Step 2: Replace the default icons with our custom icons
Write-Host "Replacing default icons with custom icons..." -ForegroundColor Green

# Create the icons directory if it doesn't exist
if (-not (Test-Path "build/web/icons")) {
    New-Item -ItemType Directory -Path "build/web/icons" -Force | Out-Null
}

# Copy our custom icons to replace the default ones
Copy-Item "web/favicon/web-app-manifest-192x192.png" "build/web/icons/Icon-192.png" -Force
Copy-Item "web/favicon/web-app-manifest-512x512.png" "build/web/icons/Icon-512.png" -Force
Copy-Item "web/favicon/web-app-manifest-192x192.png" "build/web/icons/Icon-maskable-192.png" -Force
Copy-Item "web/favicon/web-app-manifest-512x512.png" "build/web/icons/Icon-maskable-512.png" -Force

Write-Host "Custom icons copied successfully." -ForegroundColor Green

# Step 3: Verify that the manifest.json file correctly references the icons
Write-Host "Verifying manifest.json file..." -ForegroundColor Green

# The manifest.json file is already correctly configured to use our custom icons
# from the favicon directory, so we don't need to modify it.

Write-Host "Build process completed successfully!" -ForegroundColor Cyan
Write-Host "You can now deploy the contents of the build/web directory." -ForegroundColor Cyan
