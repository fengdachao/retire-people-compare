# Cross-Platform Build Guide - CSV Comparator

## ⚠️ Important: jpackage Platform Limitations

### **The Reality**
`jpackage` can **only create packages for the platform it runs on**. This is a fundamental limitation of the tool, not a configuration issue.

### **What Happens When You Run `mvn jpackage:jpackage -Pwindows` on macOS**

```bash
# This command on macOS:
mvn jpackage:jpackage -Pwindows

# Still creates:
target/dist/CsvComparator-1.0.0.dmg  # macOS package, not Windows EXE
```

**Why?** Because `jpackage` detects the platform it's running on and creates the appropriate package type, regardless of profile settings.

## 🖥️ Platform-Specific Package Creation

| Platform | jpackage Command | Creates | File Extension |
|----------|------------------|---------|----------------|
| **macOS** | `mvn jpackage:jpackage -Pmacos` | DMG installer | `.dmg` |
| **Windows** | `mvn jpackage:jpackage -Pwindows` | EXE installer | `.exe` |
| **Linux** | `mvn jpackage:jpackage -Plinux` | DEB package | `.deb` |

## 🔄 Cross-Platform Build Strategy

### **Option 1: Manual Cross-Platform Build**
```bash
# Step 1: Build JAR on any platform
mvn clean package

# Step 2: Transfer JAR to target platform
scp target/csv-comparator-1.0.0.jar windows-machine:/path/to/

# Step 3: Run jpackage on target platform
# On Windows:
mvn jpackage:jpackage -Pwindows

# On macOS:
mvn jpackage:jpackage -Pmacos

# On Linux:
mvn jpackage:jpackage -Plinux
```

### **Option 2: CI/CD Cross-Platform Build**
Use GitHub Actions, Jenkins, or GitLab CI to build on multiple platforms simultaneously.

### **Option 3: Docker Cross-Platform Build**
Use Docker containers for each target platform.

## 🛠️ Current Project Status

### **✅ What Works on macOS:**
- ✅ Build JAR file
- ✅ Create macOS DMG installer
- ✅ Create macOS App bundle
- ✅ Run application

### **❌ What Doesn't Work on macOS:**
- ❌ Create Windows EXE (must run on Windows)
- ❌ Create Linux DEB/RPM (must run on Linux)

## 📋 Available Commands

### **On macOS:**
```bash
# Build JAR
mvn clean package

# Create macOS packages
mvn jpackage:jpackage -Pmacos    # App bundle
mvn jpackage:jpackage            # DMG installer

# Run application
mvn exec:java
java -jar target/csv-comparator-1.0.0.jar
```

### **On Windows:**
```bash
# Build JAR
mvn clean package

# Create Windows packages
mvn jpackage:jpackage -Pwindows  # EXE installer

# Run application
mvn exec:java
java -jar target/csv-comparator-1.0.0.jar
```

### **On Linux:**
```bash
# Build JAR
mvn clean package

# Create Linux packages
mvn jpackage:jpackage -Plinux    # DEB package

# Run application
mvn exec:java
java -jar target/csv-comparator-1.0.0.jar
```

## 🚀 Interactive Cross-Platform Build Script

Use the provided script to understand your options:

```bash
./build-cross-platform.sh
```

This script will:
1. Detect your current platform
2. Show what you can and cannot build
3. Provide the correct commands
4. Guide you through the process

## 💡 Solutions for True Cross-Platform Builds

### **1. GitHub Actions (Recommended)**
```yaml
# .github/workflows/build.yml
name: Cross-Platform Build
on: [push, pull_request]
jobs:
  build:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [macos-latest, windows-latest, ubuntu-latest]
    steps:
      - uses: actions/checkout@v2
      - name: Set up JDK
        uses: actions/setup-java@v2
        with:
          java-version: '11'
      - name: Build with Maven
        run: mvn clean package
      - name: Create native package
        run: mvn jpackage:jpackage -P${{ matrix.os }}
```

### **2. Jenkins Multi-Platform Pipeline**
```groovy
pipeline {
    agent none
    stages {
        stage('Build JAR') {
            agent any
            steps {
                sh 'mvn clean package'
                stash includes: 'target/*.jar', name: 'jar-file'
            }
        }
        stage('Build Windows') {
            agent { label 'windows' }
            steps {
                unstash 'jar-file'
                bat 'mvn jpackage:jpackage -Pwindows'
            }
        }
        stage('Build macOS') {
            agent { label 'macos' }
            steps {
                unstash 'jar-file'
                sh 'mvn jpackage:jpackage -Pmacos'
            }
        }
        stage('Build Linux') {
            agent { label 'linux' }
            steps {
                unstash 'jar-file'
                sh 'mvn jpackage:jpackage -Plinux'
            }
        }
    }
}
```

### **3. Docker Cross-Platform Build**
```dockerfile
# Dockerfile for each platform
FROM openjdk:11-jdk

COPY target/csv-comparator-1.0.0.jar /app/
COPY pom.xml /app/

WORKDIR /app
RUN mvn jpackage:jpackage -Plinux
```

## 🎯 Summary

### **What You Can Do Right Now:**
1. ✅ Build JAR on any platform
2. ✅ Create native packages for your current platform
3. ✅ Run the application on any platform with Java

### **What You Need for Cross-Platform Packages:**
1. 🔄 Access to target platforms (Windows/Linux machines)
2. 🔄 CI/CD system with multi-platform runners
3. 🔄 Or manual transfer and build process

### **Recommended Approach:**
1. **Development**: Use Maven on your current platform
2. **Testing**: Run JAR on any platform with Java
3. **Distribution**: Use CI/CD for automated cross-platform builds
4. **Manual**: Transfer JAR and build on target platforms when needed

The JAR file is **truly cross-platform** and can run anywhere with Java installed! 🎉 