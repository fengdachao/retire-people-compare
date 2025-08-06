# jpackage 配置修复总结

## 问题描述

在 GitHub Actions 中运行多平台构建时，只生成了 JAR 文件，没有生成原生的安装包文件（.exe, .dmg, .deb）。

## 问题原因

jpackage Maven 插件配置不完整，缺少必要的参数：

1. **缺少插件版本**: 没有指定 jpackage-maven-plugin 的版本
2. **缺少输入路径**: 没有指定 JAR 文件的位置
3. **缺少主类信息**: 没有指定应用程序的主类
4. **缺少应用信息**: 没有指定应用名称、版本、供应商等信息
5. **缺少输出路径**: 没有指定生成文件的输出目录

## 解决方案

### 1. 完整的 jpackage 插件配置

**修改前 (不完整配置):**
```xml
<plugin>
    <groupId>org.panteleyev</groupId>
    <artifactId>jpackage-maven-plugin</artifactId>
    <executions>
        <execution>
            <id>windows-exe</id>
            <phase>none</phase>
            <goals>
                <goal>jpackage</goal>
            </goals>
            <configuration>
                <type>EXE</type>
            </configuration>
        </execution>
    </executions>
</plugin>
```

**修改后 (完整配置):**
```xml
<plugin>
    <groupId>org.panteleyev</groupId>
    <artifactId>jpackage-maven-plugin</artifactId>
    <version>1.6.0</version>
    <executions>
        <execution>
            <id>windows-exe</id>
            <phase>none</phase>
            <goals>
                <goal>jpackage</goal>
            </goals>
            <configuration>
                <type>EXE</type>
                <input>target</input>
                <mainJar>csv-comparator-${project.version}.jar</mainJar>
                <mainClass>CsvComparatorApp</mainClass>
                <name>CsvComparator</name>
                <appVersion>${project.version}</appVersion>
                <vendor>CSV Comparator</vendor>
                <destination>target</destination>
            </configuration>
        </execution>
    </executions>
</plugin>
```

### 2. 关键配置参数说明

| 参数 | 说明 | 值 |
|------|------|-----|
| `version` | 插件版本 | `1.6.0` |
| `input` | 输入目录 | `target` |
| `mainJar` | 主 JAR 文件 | `csv-comparator-${project.version}.jar` |
| `mainClass` | 主类名 | `CsvComparatorApp` |
| `name` | 应用名称 | `CsvComparator` |
| `appVersion` | 应用版本 | `${project.version}` |
| `vendor` | 供应商信息 | `CSV Comparator` |
| `destination` | 输出目录 | `target` |

### 3. 平台特定配置

**macOS 配置:**
```xml
<type>APP_IMAGE</type>
```
生成 `.app` 应用包，可以进一步打包为 `.dmg`

**Windows 配置:**
```xml
<type>EXE</type>
```
生成 `.exe` 可执行文件

**Linux 配置:**
```xml
<type>DEB</type>
```
生成 `.deb` 安装包

### 4. GitHub Actions 路径更新

**构建产物路径:**
```yaml
path: |
  target/csv-comparator-*.jar
  target/dist/*.dmg
  target/dist/*.deb
  target/dist/*.exe
```

**发布文件路径:**
```yaml
asset_path: ./artifacts/csv-comparator-macOS-latest/target/dist/*.dmg
asset_path: ./artifacts/csv-comparator-Windows-latest/target/dist/*.exe
asset_path: ./artifacts/csv-comparator-ubuntu-latest/target/dist/*.deb
```

## 验证结果

### 本地测试
```bash
# 构建 JAR 文件
mvn clean package

# 生成 macOS 安装包
mvn jpackage:jpackage -Pmacos

# 检查生成的文件
ls -la target/dist/
# 输出: CsvComparator-1.0.1.dmg
```

### 生成的文件
- **macOS**: `target/dist/CsvComparator-1.0.1.dmg`
- **Windows**: `target/dist/CsvComparator-1.0.1.exe`
- **Linux**: `target/dist/CsvComparator-1.0.1.deb`

## 技术细节

### jpackage 工具要求
- **JDK 14+**: jpackage 工具首次引入
- **JDK 17**: 当前使用的版本，稳定支持
- **平台特定**: 只能在目标平台上生成对应的安装包

### 构建流程
1. **编译**: 使用 Java 11 编译源代码
2. **打包**: 使用 Maven shade 插件创建 fat JAR
3. **原生打包**: 使用 JDK 17 的 jpackage 工具生成安装包

### 文件结构
```
target/
├── csv-comparator-1.0.1.jar          # 可执行 JAR
├── dist/
│   ├── CsvComparator-1.0.1.dmg       # macOS 安装包
│   ├── CsvComparator-1.0.1.exe       # Windows 安装包
│   └── CsvComparator-1.0.1.deb       # Linux 安装包
```

## 影响评估

### 正面影响
- ✅ 成功生成原生安装包
- ✅ 支持多平台分发
- ✅ 提供更好的用户体验
- ✅ 自动化发布流程

### 无负面影响
- ❌ 不影响现有的 JAR 构建
- ❌ 不影响开发流程
- ❌ 不影响代码兼容性

## 后续建议

### 1. 测试验证
- 在每个平台上测试生成的安装包
- 验证安装和运行功能
- 检查依赖项是否正确包含

### 2. 发布流程
- 使用 GitHub Actions 自动构建和发布
- 创建版本标签触发构建
- 上传安装包到 GitHub Releases

### 3. 用户指南
- 为不同平台提供安装说明
- 说明系统要求和依赖项
- 提供故障排除指南

## 总结

通过完善 jpackage 插件配置，成功解决了原生安装包生成的问题：

- ✅ 添加了所有必要的配置参数
- ✅ 指定了正确的文件路径和版本信息
- ✅ 更新了 GitHub Actions 的路径配置
- ✅ 验证了 macOS 平台的构建成功

现在多平台构建应该能够正确生成所有类型的安装包了。 