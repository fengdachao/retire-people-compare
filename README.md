# CSV Comparator App

A Java application for comparing CSV files with a simple GUI interface.

## Project Structure

```
retire-data-compaire-app/
├── src/                    # Maven source code
│   ├── main/java/          # Java source files
│   │   ├── CsvComparatorApp.java
│   │   └── CsvUtils.java
│   ├── main/resources/     # Application resources
│   └── test/               # Test files
├── target/                 # Build output
│   └── csv-comparator-1.0.1.jar
├── pom.xml                 # Maven configuration
├── build-maven.sh          # Maven build script
├── run-maven-app.sh        # Interactive runner
├── build-cross-platform.sh # Cross-platform guide
└── README.md
```

## Building the Application

### Prerequisites
- Java 14 or later with jpackage support
- Platform-specific build tools (for cross-platform builds)
- Maven 3.6+ (for Maven builds)

### Quick Build (Current Platform)

**Maven Build (Recommended):**
```bash
# Build the application
mvn clean package

# Run the application
mvn exec:java
```

### Maven Build (Recommended)
```bash
# Build the application
mvn clean package

# Run the application
mvn exec:java

# Or run the JAR directly
java -jar target/csv-comparator-1.0.1.jar

# Use the interactive runner
./run-maven-app.sh
```

### Cross-Platform Build Preparation
For building packages for other platforms:

**Use the interactive cross-platform build script:**
```bash
./build-cross-platform.sh
```

**Or use Maven profiles:**
```bash
# macOS package
mvn jpackage:jpackage -Pmacos

# Windows package (must run on Windows)
mvn jpackage:jpackage -Pwindows

# Linux package (must run on Linux)
mvn jpackage:jpackage -Plinux
```

## Features
- 🎯 灵活的列选择 - 可以选择不同文件中的任意列进行比较
- 📊 智能列检测 - 自动加载和显示可用列
- 🔍 统一多文件比较 - 支持2个或更多文件的统一比较逻辑
- 📄 详细结果导出 - 输出包含类型、值和来源的详细结果
- 🖥️ 简洁用户界面 - 移除冗余功能，专注核心比较逻辑
- 🌐 跨平台兼容 - 支持 Windows、macOS、Linux

## Installation
After building, install the generated package:

**macOS:**
```bash
# Run the app directly:
open build/dist/CsvComparator.app

# Or run from terminal:
build/dist/CsvComparator.app/Contents/MacOS/CsvComparator
```

**Linux (Debian/Ubuntu):**
```bash
sudo dpkg -i dist/CsvComparator.deb
sudo apt-get install -f  # (if there are dependency issues)
```

**Windows:**
Run the generated `CsvComparator.exe` from the `dist` folder.

## Usage

### 多文件比较功能
1. 启动应用程序
2. 选择CSV文件（支持2-4个文件）- 列选择器会自动加载可用列
3. 从下拉菜单中选择要比较的列（可以是不同列）
4. 点击"查找共同值"按钮执行比较
5. 查看详细结果：所有文件共有的值、每个文件独有的值
6. 检查 result.csv 文件获取完整的结果报告

### 支持的比较类型
- **同列比较**: 比较多个文件中相同的列（如姓名 vs 姓名 vs 姓名）
- **跨列比较**: 比较不同类型的列（如姓名 vs 年龄 vs 地址）
- **任意列组合**: 灵活选择任意列进行比较分析
- **多文件支持**: 统一处理2个或更多文件的比较

## Development
The source code is located in the `src/` directory. To modify the application:



### Maven Development (Recommended)
1. Edit files in `src/main/java/`
2. Run `mvn clean compile` to compile
3. Run `mvn test` to run tests
4. Run `mvn package` to create JAR
5. Run `mvn exec:java` to test the application

### Maven Benefits
- **Dependency Management**: Automatic library downloads
- **Testing**: Built-in JUnit integration
- **Code Quality**: Checkstyle and other tools
- **Standardization**: Industry-standard build process
- **Cross-Platform**: Single command works everywhere

## Build Scripts
- `build-maven.sh` - Complete Maven build process
- `run-maven-app.sh` - Interactive Maven application runner
- `build-cross-platform.sh` - Cross-platform build guide and automation
- `test-csv-comparison.sh` - Test script for CSV comparison functionality
- `test-common-names.sh` - Test script for common names functionality
- `test-refactored-app.sh` - Test script for the refactored column comparison features
- `test-unified-comparison.sh` - Test script for unified multi-file comparison functionality 