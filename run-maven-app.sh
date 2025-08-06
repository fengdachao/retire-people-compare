#!/bin/bash

echo "🚀 Running CSV Comparator (Maven Build)"
echo "======================================="
echo ""

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "❌ Error: Maven is not installed!"
    exit 1
fi

# Check if the JAR file exists
if [ ! -f "target/csv-comparator-1.0.1.jar" ]; then
    echo "❌ Error: JAR file not found! Please build first with: mvn clean package"
    exit 1
fi

echo "✅ JAR file found: target/csv-comparator-1.0.1.jar"
echo "📦 JAR size: $(du -h target/csv-comparator-1.0.1.jar | cut -f1)"
echo ""

echo "🎯 Choose how to run the application:"
echo "1. Run with Maven exec plugin (recommended)"
echo "2. Run with java -jar command"
echo "3. Run with Maven compile and exec"
echo "4. Show JAR contents"
echo ""

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo "🔧 Running with Maven exec plugin..."
        echo "Command: mvn exec:java"
        echo ""
        mvn exec:java
        ;;
    2)
        echo ""
        echo "☕ Running with java -jar..."
        echo "Command: java -jar target/csv-comparator-1.0.1.jar"
        echo ""
        java -jar target/csv-comparator-1.0.1.jar
        ;;
    3)
        echo ""
        echo "🔨 Compiling and running with Maven..."
        echo "Command: mvn compile exec:java"
        echo ""
        mvn compile exec:java
        ;;
    4)
        echo ""
        echo "📋 JAR file contents:"
        echo "Command: jar tf target/csv-comparator-1.0.1.jar"
        echo ""
        jar tf target/csv-comparator-1.0.1.jar | head -20
        echo "... (showing first 20 entries)"
        echo ""
        echo "📊 JAR file details:"
        echo "   - Main class: CsvComparatorApp"
        echo "   - Dependencies included: Yes (fat JAR)"
        echo "   - Size: $(du -h target/csv-comparator-1.0.1.jar | cut -f1)"
        ;;
    *)
        echo "❌ Invalid choice. Exiting."
        exit 1
        ;;
esac

echo ""
echo "🎉 Application execution completed!" 