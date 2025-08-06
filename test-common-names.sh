#!/bin/bash

echo "🔍 测试共同姓名功能"
echo "=================="
echo ""

# Check if sample files exist
if [ ! -f "sample1.csv" ] || [ ! -f "sample2.csv" ] || [ ! -f "sample3.csv" ]; then
    echo "❌ 错误: 未找到示例CSV文件!"
    exit 1
fi

echo "✅ 找到示例文件。预期共同姓名:"
echo ""

echo "📊 sample1.csv vs sample2.csv:"
echo "   • sample1.csv 中的姓名:"
head -11 sample1.csv | tail -10 | cut -d',' -f1 | sed 's/^/     - /'
echo ""
echo "   • sample2.csv 包含 sample1.csv 中的所有姓名"
echo "   • 预期共同姓名: 10个 (来自 sample1.csv 的所有姓名)"
echo ""

echo "📊 sample1.csv vs sample3.csv:"
echo "   • 预期共同姓名: 10个 (来自 sample1.csv 的所有姓名)"
echo ""

echo "📊 sample2.csv vs sample3.csv:"
echo "   • 预期共同姓名: 15个 (来自 sample2.csv 的所有姓名)"
echo ""

echo "🎯 如何测试共同姓名功能:"
echo "========================"
echo ""

echo "1. 启动应用程序:"
echo "   mvn exec:java"
echo "   # 或"
echo "   java -jar target/csv-comparator-1.0.1.jar"
echo ""

echo "2. 在应用程序中:"
echo "   • 点击文件1的'浏览...'按钮，选择 sample1.csv"
echo "   • 点击文件2的'浏览...'按钮，选择 sample2.csv"
echo "   • 点击'查找共同姓名'按钮"
echo ""

echo "3. 预期结果:"
echo "   • 应找到10个共同姓名"
echo "   • 应显示 sample1.csv 中的所有姓名"
echo "   • 应创建包含共同姓名的 result.csv 文件"
echo ""

echo "4. 检查 result.csv 文件:"
echo "   • 应包含标题: '姓名'"
echo "   • 应包含来自 sample1.csv 的10个姓名"
echo ""

echo "5. 尝试其他组合:"
echo "   • sample1.csv vs sample3.csv (应找到10个共同姓名)"
echo "   • sample2.csv vs sample3.csv (应找到15个共同姓名)"
echo ""

echo "📋 预期的 result.csv 内容 (sample1.csv vs sample2.csv):"
echo "姓名"
echo "John Smith"
echo "Sarah Johnson"
echo "Michael Brown"
echo "Emily Davis"
echo "David Wilson"
echo "Lisa Anderson"
echo "Robert Taylor"
echo "Jennifer Martinez"
echo "Christopher Lee"
echo "Amanda Garcia"
echo ""

echo "✅ 准备测试!"
echo "🎉 启动应用程序并尝试'查找共同姓名'功能!" 