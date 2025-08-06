# Shell 兼容性修复说明

## 问题描述

在 GitHub Actions 的 Windows 环境中运行多平台构建时，遇到以下错误：

```
Line |
   2 |  if [ "$RUNNER_OS" = "Linux" ]; then
     |    ~
     | Missing '(' after 'if' in if statement.
Error: Process completed with exit code 1.
```

## 问题原因

GitHub Actions 在不同平台上使用不同的默认 shell：

- **Linux/macOS**: 使用 bash shell
- **Windows**: 使用 PowerShell 或 cmd

原始的脚本使用了 bash 语法（`if [ ... ]`），这在 Windows 环境中不被支持，导致语法错误。

## 解决方案

### 修改前的问题代码

```yaml
- name: Build native package
  run: |
    if [ "$RUNNER_OS" = "Linux" ]; then
      mvn jpackage:jpackage -Plinux
    elif [ "$RUNNER_OS" = "macOS" ]; then
      mvn jpackage:jpackage -Pmacos
    elif [ "$RUNNER_OS" = "Windows" ]; then
      mvn jpackage:jpackage -Pwindows
    fi
```

### 修改后的解决方案

```yaml
- name: Build native package (Linux/macOS)
  if: runner.os != 'Windows'
  run: |
    if [ "$RUNNER_OS" = "Linux" ]; then
      mvn jpackage:jpackage -Plinux
    elif [ "$RUNNER_OS" = "macOS" ]; then
      mvn jpackage:jpackage -Pmacos
    fi
    
- name: Build native package (Windows)
  if: runner.os == 'Windows'
  shell: cmd
  run: mvn jpackage:jpackage -Pwindows
```

## 技术说明

### 平台特定的 Shell 处理

1. **Linux/macOS 步骤**:
   - 使用条件 `if: runner.os != 'Windows'`
   - 使用 bash 语法进行条件判断
   - 支持 Linux 和 macOS 的 jpackage 构建

2. **Windows 步骤**:
   - 使用条件 `if: runner.os == 'Windows'`
   - 明确指定 `shell: cmd`
   - 直接执行 Windows 特定的 jpackage 命令

### GitHub Actions Shell 选项

GitHub Actions 支持以下 shell 选项：

- **bash** (默认在 Linux/macOS)
- **cmd** (Windows 命令提示符)
- **powershell** (Windows PowerShell)
- **sh** (POSIX shell)

### 条件执行

使用 `if` 条件确保：
- Linux/macOS 步骤只在非 Windows 平台执行
- Windows 步骤只在 Windows 平台执行
- 避免不必要的步骤执行

## 验证

### 本地测试
```bash
# 测试 Maven 配置
mvn clean compile

# 测试 jpackage 配置
mvn jpackage:jpackage -Pmacos  # macOS
mvn jpackage:jpackage -Plinux  # Linux
```

### GitHub Actions 测试
- 推送代码到 GitHub
- 创建版本标签触发多平台构建
- 检查每个平台的构建状态

## 影响评估

### 正面影响
- ✅ 解决了 Windows 平台的 shell 兼容性问题
- ✅ 保持了 Linux/macOS 平台的正常功能
- ✅ 提高了构建的可靠性
- ✅ 简化了 Windows 平台的构建逻辑

### 无负面影响
- ❌ 不影响现有的构建流程
- ❌ 不影响构建产物的质量
- ❌ 不影响其他平台的功能

## 最佳实践

### 1. 平台特定脚本
- 为不同平台使用专门的构建步骤
- 明确指定 shell 类型
- 使用条件执行避免冲突

### 2. 错误处理
- 为每个平台提供清晰的错误信息
- 使用适当的条件判断
- 确保构建失败时有明确的反馈

### 3. 维护性
- 保持脚本的简洁性
- 使用清晰的命名约定
- 提供充分的文档说明

## 后续建议

### 1. 测试覆盖
- 确保所有平台都能正常构建
- 定期验证构建产物的质量
- 监控构建时间和成功率

### 2. 优化
- 考虑使用更高效的构建策略
- 优化缓存和依赖管理
- 减少不必要的构建步骤

### 3. 监控
- 定期检查 GitHub Actions 的更新
- 关注 shell 和工具的变化
- 及时更新构建配置

## 总结

通过将平台特定的构建步骤分离，解决了 Windows 环境的 shell 兼容性问题。这个修复：

- ✅ 解决了 Windows 构建失败问题
- ✅ 保持了跨平台的兼容性
- ✅ 提高了构建的可靠性
- ✅ 简化了维护工作

现在多平台构建应该能够在所有平台上正常工作了。 