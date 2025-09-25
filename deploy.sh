#!/bin/bash

# Pixabay Gallery Deployment Script
# This script builds and prepares the Flutter web app for deployment

echo "🚀 Starting Pixabay Gallery deployment..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter could not be found. Please install Flutter first."
    exit 1
fi

echo "📋 Checking Flutter version..."
flutter --version

echo "📦 Installing dependencies..."
flutter pub get

echo "🔍 Running static analysis..."
flutter analyze

echo "🧪 Running tests..."
flutter test

echo "🏗️  Building for production..."
flutter build web --release --base-href "/pixabay_gallery/"

echo "📊 Build size analysis..."
ls -lh build/web/

echo "✅ Build completed successfully!"
echo "📁 Built files are in: build/web/"
echo ""
echo "🌐 Deployment options:"
echo "1. GitHub Pages: Push to main branch (automatic deployment via GitHub Actions)"
echo "2. Manual hosting: Upload contents of build/web/ to your web server"
echo "3. Local testing: Serve build/web/ with any static file server"
echo ""
echo "🔧 Local testing command:"
echo "cd build/web && python -m http.server 8000"
echo "Then open: http://localhost:8000"

echo ""
echo "🎉 Deployment preparation complete!"