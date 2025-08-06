# CI/CD 使用指南

## 概述

本项目使用 GitHub Actions 实现持续集成和持续部署（CI/CD），自动化构建、测试和发布流程。

## 工作流配置

### 1. CI 工作流 (`ci.yml`)

**触发条件:**
- 推送到 `main` 或 `develop` 分支
- 创建 Pull Request 到 `main` 分支

**执行步骤:**
- ✅ 检出代码
- ✅ 设置 Java 11 环境
- ✅ 缓存 Maven 依赖
- ✅ 运行单元测试
- ✅ 构建 JAR 文件
- ✅ 上传构建产物

**查看方式:**
- 在 GitHub 仓库页面点击 "Actions" 标签
- 查看 "CI" 工作流的执行状态

### 2. 多平台构建工作流 (`build-multi-platform.yml`)

**触发条件:**
- 推送版本标签（如 `v1.0.2`）
- 手动触发（workflow_dispatch）

**执行步骤:**
- ✅ 在 Ubuntu、Windows、macOS 上并行构建
- ✅ 设置 Java 11 环境
- ✅ 构建 JAR 文件
- ✅ 设置 Java 14 环境（用于 jpackage）
- ✅ 生成平台特定的安装包
- ✅ 上传构建产物

**生成的文件:**
- `csv-comparator-*.jar` - 可执行 JAR 文件
- `CsvComparator-*.dmg` - macOS 安装包
- `CsvComparator-*.exe` - Windows 安装包
- `CsvComparator-*.deb` - Linux 安装包

### 3. 发布工作流 (`release.yml`)

**触发条件:**
- 推送版本标签（如 `v1.0.2`）

**执行步骤:**
- ✅ 等待多平台构建完成
- ✅ 下载所有构建产物
- ✅ 创建 GitHub Release
- ✅ 上传各平台安装包到 Release

### 4. 代码质量检查工作流 (`code-quality.yml`)

**触发条件:**
- 推送到 `main` 或 `develop` 分支
- 创建 Pull Request 到 `main` 分支

**执行步骤:**
- ✅ 运行 Checkstyle 代码风格检查
- ✅ 运行 SpotBugs 静态代码分析
- ✅ 生成测试覆盖率报告
- ✅ 上传覆盖率到 Codecov

## 使用方法

### 日常开发

1. **创建功能分支:**
   ```bash
   git checkout -b feature/new-feature
   ```

2. **提交代码:**
   ```bash
   git add .
   git commit -m "Add new feature"
   git push origin feature/new-feature
   ```

3. **创建 Pull Request:**
   - 在 GitHub 上创建 PR 到 `main` 分支
   - CI 和代码质量检查会自动运行
   - 检查通过后合并代码

### 发布新版本

1. **更新版本号:**
   ```bash
   # 编辑 pom.xml 中的版本号
   <version>1.0.2</version>
   ```

2. **提交版本更新:**
   ```bash
   git add pom.xml
   git commit -m "Bump version to 1.0.2"
   git push origin main
   ```

3. **创建版本标签:**
   ```bash
   git tag v1.0.2
   git push origin v1.0.2
   ```

4. **自动发布:**
   - 多平台构建工作流自动启动
   - 发布工作流自动创建 GitHub Release
   - 各平台安装包自动上传到 Release

### 手动触发构建

1. **在 GitHub 仓库页面:**
   - 点击 "Actions" 标签
   - 选择 "Multi-Platform Build" 工作流
   - 点击 "Run workflow" 按钮
   - 选择分支并运行

## 监控和维护

### 查看构建状态

- **GitHub Actions 页面:** 查看所有工作流的执行状态
- **构建产物:** 在 Actions 页面下载构建的 JAR 和安装包
- **Release 页面:** 查看发布的版本和下载链接

### 常见问题

1. **构建失败:**
   - 检查错误日志
   - 确保代码符合 Checkstyle 规范
   - 确保所有测试通过

2. **jpackage 失败:**
   - 检查 JDK 版本（需要 14+）
   - 检查平台特定的依赖
   - 查看详细的错误信息

3. **缓存问题:**
   - 清除 Maven 缓存
   - 重新运行构建

### 性能优化

- **缓存策略:** Maven 依赖已配置缓存
- **并行构建:** 多平台构建并行执行
- **构建时间:** 通常 5-10 分钟完成

## 配置说明

### Maven 插件

- **Checkstyle:** 代码风格检查
- **SpotBugs:** 静态代码分析
- **JaCoCo:** 测试覆盖率报告
- **jpackage:** 生成原生安装包

### 环境要求

- **Java 11:** 编译和测试
- **Java 14:** jpackage 打包
- **Maven 3.6+:** 构建工具

## 扩展功能

### 添加新的检查

1. **在 pom.xml 中添加插件**
2. **在 code-quality.yml 中添加步骤**
3. **配置相应的规则**

### 添加新的平台

1. **在 build-multi-platform.yml 中添加平台**
2. **配置相应的 jpackage 参数**
3. **在 release.yml 中添加上传步骤**

### 集成其他服务

- **Slack 通知:** 构建完成通知
- **Docker 镜像:** 容器化部署
- **自动测试:** 集成测试和端到端测试

## 最佳实践

1. **保持工作流简洁:** 每个工作流专注于特定任务
2. **使用缓存:** 减少构建时间
3. **错误处理:** 提供清晰的错误信息
4. **文档更新:** 及时更新相关文档
5. **安全考虑:** 使用 GitHub Secrets 存储敏感信息 