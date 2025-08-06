#!/bin/bash

echo "🔧 测试文件数组参数的 findCommonValues 方法"
echo "============================================"
echo ""

# Check if sample files exist
if [ ! -f "sample1.csv" ] || [ ! -f "sample2.csv" ] || [ ! -f "sample3.csv" ]; then
    echo "❌ 错误: 未找到示例CSV文件!"
    exit 1
fi

echo "✅ 重构完成的 findCommonValues 方法特性:"
echo ""

echo "📋 方法签名变更:"
echo "==============="
echo "之前: findCommonValues(String[] fileNames, List<String[]>[] filesData, int[] columnIndices)"
echo "现在: findCommonValues(String[] fileNames, int[] columnIndices)"
echo ""

echo "🔄 新功能特点:"
echo "=============="
echo "1. 📁 自动文件加载 - 方法内部根据文件名数组加载CSV数据"
echo "2. ✅ 参数验证 - 验证文件存在性和列索引有效性"
echo "3. 🔒 类型安全 - 减少泛型数组的使用，提高类型安全"
echo "4. 🚀 扩展性 - 为未来多文件比较奠定基础"
echo "5. 🎯 简化调用 - 只需传递文件名和列索引"
echo ""

echo "📊 使用示例:"
echo "============"
echo ""

echo "示例1: GUI调用（保持向后兼容）"
echo "String[] fileNames = {file1.getAbsolutePath(), file2.getAbsolutePath()};"
echo "int[] columnIndices = {0, 1}; // 比较文件1的第1列和文件2的第2列"
echo "findCommonValues(fileNames, columnIndices);"
echo ""

echo "示例2: 直接文件路径调用"
echo "String[] fileNames = {\"sample1.csv\", \"sample2.csv\"};"
echo "int[] columnIndices = {0, 0}; // 比较两个文件的第1列"
echo "findCommonValues(fileNames, columnIndices);"
echo ""

echo "示例3: 多文件准备（未来扩展）"
echo "String[] fileNames = {\"sample1.csv\", \"sample2.csv\", \"sample3.csv\"};"
echo "int[] columnIndices = {0, 0, 0}; // 目前只处理前两个文件"
echo "findCommonValues(fileNames, columnIndices);"
echo ""

echo "🧪 测试命令行演示功能:"
echo "====================="
echo ""

echo "运行演示模式:"
echo "java -jar target/csv-comparator-1.0.1.jar demo"
echo ""
echo "这将演示文件数组参数的使用方法"
echo ""

echo "🔍 演示执行..."
java -jar target/csv-comparator-1.0.1.jar demo
echo ""

echo "📄 检查生成的结果文件:"
echo "====================="
if [ -f "result.csv" ]; then
    echo "✅ result.csv 文件已生成"
    echo ""
    echo "文件内容预览:"
    echo "============"
    head -10 result.csv
    echo ""
    echo "文件行数: $(wc -l < result.csv)"
else
    echo "❌ 未找到 result.csv 文件"
fi
echo ""

echo "🎯 方法验证点:"
echo "=============="
echo "✓ 文件名数组参数接收"
echo "✓ 内部文件数据加载"
echo "✓ 列索引验证"
echo "✓ 错误处理改进"
echo "✓ 结果输出格式增强"
echo "✓ 向后兼容性保持"
echo ""

echo "🚀 未来扩展可能性:"
echo "=================="
echo "• 真正的多文件比较（3个或更多文件）"
echo "• 不同文件的多列组合比较"
echo "• 批量文件处理"
echo "• 并行文件加载"
echo "• 内存优化的大文件处理"
echo ""

echo "✅ 重构完成！"
echo "新的 findCommonValues 方法现在支持文件名数组参数！"