#!/bin/bash

echo "🚀 Maven Build Script for CSV Comparator"
echo "========================================"
echo ""

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "❌ Error: Maven is not installed!"
    echo "Please install Maven first:"
    echo "  macOS: brew install maven"
    echo "  Linux: sudo apt-get install maven"
    echo "  Windows: Download from https://maven.apache.org/"
    exit 1
fi

echo "✅ Maven version: $(mvn --version | head -n 1)"
echo ""

# Function to run Maven command with description
run_maven() {
    local description="$1"
    local command="$2"
    
    echo "🔨 $description"
    echo "   Command: $command"
    echo ""
    
    if eval "$command"; then
        echo "✅ $description completed successfully!"
    else
        echo "❌ $description failed!"
        return 1
    fi
    echo ""
}

# Clean previous builds
run_maven "Cleaning previous builds" "mvn clean"

# Compile source code
run_maven "Compiling source code" "mvn compile"

# Run tests (if any)
run_maven "Running tests" "mvn test"

# Create JAR file
run_maven "Creating JAR file" "mvn package"

# Create fat JAR (with dependencies)
run_maven "Creating fat JAR with dependencies" "mvn clean package"

# Create custom runtime image
run_maven "Creating custom runtime image" "mvn jlink:jlink"

# Create native package for current platform
echo "🎯 Creating native package for $(uname -s)..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    run_maven "Creating macOS app bundle" "mvn jpackage:jpackage -Pmacos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    run_maven "Creating Linux package" "mvn jpackage:jpackage -Plinux"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    run_maven "Creating Windows executable" "mvn jpackage:jpackage -Pwindows"
fi

echo ""
echo "🎉 Maven build completed!"
echo ""
echo "📁 Generated artifacts:"
echo "   - JAR file: target/csv-comparator-1.0.0.jar"
echo "   - Fat JAR: target/csv-comparator-1.0.0-shaded.jar"
echo "   - Runtime: target/image/"
echo "   - Native package: target/dist/"

if [[ "$OSTYPE" == "darwin"* ]] && [ -d "target/dist/CsvComparator.app" ]; then
    echo ""
    echo "🍎 macOS app bundle created!"
    echo "   Run with: open target/dist/CsvComparator.app"
fi

echo ""
echo "📋 Available Maven commands:"
echo "   mvn clean          - Clean build artifacts"
echo "   mvn compile        - Compile source code"
echo "   mvn test           - Run tests"
echo "   mvn package        - Create JAR file"
echo "   mvn install        - Install to local repository"
echo "   mvn jlink:jlink    - Create custom runtime"
echo "   mvn jpackage:jpackage - Create native package"
echo "" 