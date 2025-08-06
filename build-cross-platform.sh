#!/bin/bash

echo "🌍 Cross-Platform Build Script for CSV Comparator"
echo "=================================================="
echo ""

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "❌ Error: Maven is not installed!"
    exit 1
fi

echo "✅ Maven version: $(mvn --version | head -n 1)"
echo "🖥️  Current platform: $(uname -s)"
echo ""

echo "📋 Understanding Cross-Platform Builds:"
echo "========================================"
echo ""
echo "⚠️  IMPORTANT: jpackage can only create packages for the platform it runs on!"
echo ""
echo "   • macOS jpackage → Creates macOS packages (DMG, APP_IMAGE)"
echo "   • Windows jpackage → Creates Windows packages (EXE, MSI)"
echo "   • Linux jpackage → Creates Linux packages (DEB, RPM)"
echo ""
echo "🔄 Cross-Platform Strategy:"
echo "   1. Build JAR on any platform"
echo "   2. Transfer JAR to target platform"
echo "   3. Run jpackage on target platform"
echo ""

# Build the JAR file first
echo "🔨 Building JAR file..."
if mvn clean package; then
    echo "✅ JAR file created successfully!"
    echo "📁 Location: target/csv-comparator-1.0.0.jar"
    echo "📦 Size: $(du -h target/csv-comparator-1.0.0.jar | cut -f1)"
else
    echo "❌ JAR build failed!"
    exit 1
fi

echo ""
echo "🎯 Available Build Options:"
echo "=========================="
echo ""

# Detect current platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    CURRENT_PLATFORM="macOS"
    echo "🍎 Current Platform: macOS"
    echo ""
    echo "✅ You can create:"
    echo "   • macOS DMG installer"
    echo "   • macOS App bundle"
    echo ""
    echo "❌ You CANNOT create:"
    echo "   • Windows EXE (must run on Windows)"
    echo "   • Linux DEB/RPM (must run on Linux)"
    echo ""
    echo "🔧 Commands for macOS:"
    echo "   mvn jpackage:jpackage -Pmacos    # Create macOS app bundle"
    echo "   mvn jpackage:jpackage            # Create macOS DMG (default)"
    echo ""
    echo "📦 For Windows/Linux builds:"
    echo "   1. Copy target/csv-comparator-1.0.0.jar to Windows/Linux machine"
    echo "   2. Run: mvn jpackage:jpackage -Pwindows  # On Windows"
    echo "   3. Run: mvn jpackage:jpackage -Plinux    # On Linux"
    
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    CURRENT_PLATFORM="Linux"
    echo "🐧 Current Platform: Linux"
    echo ""
    echo "✅ You can create:"
    echo "   • Linux DEB package"
    echo "   • Linux RPM package"
    echo ""
    echo "❌ You CANNOT create:"
    echo "   • Windows EXE (must run on Windows)"
    echo "   • macOS DMG/APP (must run on macOS)"
    echo ""
    echo "🔧 Commands for Linux:"
    echo "   mvn jpackage:jpackage -Plinux    # Create Linux package"
    echo ""
    echo "📦 For Windows/macOS builds:"
    echo "   1. Copy target/csv-comparator-1.0.0.jar to Windows/macOS machine"
    echo "   2. Run: mvn jpackage:jpackage -Pwindows  # On Windows"
    echo "   3. Run: mvn jpackage:jpackage -Pmacos    # On macOS"
    
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    CURRENT_PLATFORM="Windows"
    echo "🪟 Current Platform: Windows"
    echo ""
    echo "✅ You can create:"
    echo "   • Windows EXE installer"
    echo "   • Windows MSI installer"
    echo ""
    echo "❌ You CANNOT create:"
    echo "   • macOS DMG/APP (must run on macOS)"
    echo "   • Linux DEB/RPM (must run on Linux)"
    echo ""
    echo "🔧 Commands for Windows:"
    echo "   mvn jpackage:jpackage -Pwindows  # Create Windows executable"
    echo ""
    echo "📦 For macOS/Linux builds:"
    echo "   1. Copy target/csv-comparator-1.0.0.jar to macOS/Linux machine"
    echo "   2. Run: mvn jpackage:jpackage -Pmacos    # On macOS"
    echo "   3. Run: mvn jpackage:jpackage -Plinux    # On Linux"
fi

echo ""
echo "🚀 Quick Actions:"
echo "================="
echo ""

read -p "Choose an action:
1. Create package for current platform ($CURRENT_PLATFORM)
2. Show JAR file details
3. Run the application
4. Exit

Enter your choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo "🔨 Creating package for $CURRENT_PLATFORM..."
        if [[ "$CURRENT_PLATFORM" == "macOS" ]]; then
            mvn jpackage:jpackage -Pmacos
        elif [[ "$CURRENT_PLATFORM" == "Linux" ]]; then
            mvn jpackage:jpackage -Plinux
        elif [[ "$CURRENT_PLATFORM" == "Windows" ]]; then
            mvn jpackage:jpackage -Pwindows
        fi
        ;;
    2)
        echo ""
        echo "📋 JAR File Details:"
        echo "   Location: target/csv-comparator-1.0.0.jar"
        echo "   Size: $(du -h target/csv-comparator-1.0.0.jar | cut -f1)"
        echo "   Main Class: CsvComparatorApp"
        echo "   Dependencies: Included (fat JAR)"
        echo ""
        echo "📦 JAR Contents:"
        jar tf target/csv-comparator-1.0.0.jar | head -10
        echo "... (showing first 10 entries)"
        ;;
    3)
        echo ""
        echo "🚀 Running the application..."
        mvn exec:java
        ;;
    4)
        echo "👋 Goodbye!"
        exit 0
        ;;
    *)
        echo "❌ Invalid choice. Exiting."
        exit 1
        ;;
esac

echo ""
echo "🎉 Cross-platform build process completed!"
echo ""
echo "💡 Tip: For true cross-platform builds, use CI/CD systems like:"
echo "   • GitHub Actions (runs on multiple platforms)"
echo "   • Jenkins (with multiple agents)"
echo "   • GitLab CI (with different runners)" 