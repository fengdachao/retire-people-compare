#!/bin/bash

echo "🧪 CSV 文件比较器测试脚本"
echo "========================"
echo ""

# Check if sample files exist
if [ ! -f "sample1.csv" ] || [ ! -f "sample2.csv" ] || [ ! -f "sample3.csv" ]; then
    echo "❌ 错误: 未找到示例CSV文件!"
    echo "请确保 sample1.csv、sample2.csv 和 sample3.csv 文件存在。"
    exit 1
fi

echo "✅ 找到示例CSV文件:"
echo "   📄 sample1.csv - 10条记录"
echo "   📄 sample2.csv - 15条记录 (包含 sample1 的所有记录 + 5条新记录)"
echo "   📄 sample3.csv - 17条记录 (包含 sample2 的所有记录 + 2条新记录)"
echo ""

echo "📊 文件比较分析:"
echo "================"
echo ""

echo "🔍 sample1.csv vs sample2.csv:"
echo "   • sample1.csv 有 10条记录"
echo "   • sample2.csv 有 15条记录"
echo "   • sample2.csv 包含 sample1.csv 的所有记录"
echo "   • sample2.csv 有 5条额外记录:"
echo "     - Jessica White,30"
echo "     - Kevin Thompson,29"
echo "     - Maria Rodriguez,28"
echo "     - Daniel Clark,34"
echo "     - Nicole Lewis,26"
echo ""

echo "🔍 sample2.csv vs sample3.csv:"
echo "   • sample2.csv 有 15条记录"
echo "   • sample3.csv 有 17条记录"
echo "   • sample3.csv 包含 sample2.csv 的所有记录"
echo "   • sample3.csv 有 2条额外记录:"
echo "     - Thomas Anderson,29"
echo "     - Rachel Green,31"
echo ""

echo "🔍 sample1.csv vs sample3.csv:"
echo "   • sample1.csv 有 10条记录"
echo "   • sample3.csv 有 17条记录"
echo "   • sample3.csv 包含 sample1.csv 的所有记录"
echo "   • sample3.csv 有 7条额外记录"
echo ""

echo "🚀 测试场景:"
echo "============"
echo ""

echo "1️⃣ 基本比较 (sample1.csv vs sample2.csv):"
echo "   • 预期: 5条记录仅在 sample2.csv 中"
echo "   • 预期: 0条记录仅在 sample1.csv 中"
echo ""

echo "2️⃣ 扩展比较 (sample2.csv vs sample3.csv):"
echo "   • 预期: 2条记录仅在 sample3.csv 中"
echo "   • 预期: 0条记录仅在 sample2.csv 中"
echo ""

echo "3️⃣ 完整比较 (sample1.csv vs sample3.csv):"
echo "   • 预期: 7条记录仅在 sample3.csv 中"
echo "   • 预期: 0条记录仅在 sample1.csv 中"
echo ""

echo "4️⃣ 反向比较 (sample2.csv vs sample1.csv):"
echo "   • 预期: 0条记录仅在 sample2.csv 中"
echo "   • 预期: 5条记录仅在 sample1.csv 中"
echo ""

echo "🎯 如何测试:"
echo "============"
echo ""

echo "1. 启动 CSV 文件比较器应用程序:"
echo "   mvn exec:java"
echo "   # 或"
echo "   java -jar target/csv-comparator-1.0.1.jar"
echo ""

echo "2. 在应用程序中:"
echo "   • 点击文件1的'浏览...'按钮，选择 sample1.csv"
echo "   • 点击文件2的'浏览...'按钮，选择 sample2.csv"
echo "   • 点击'比较'按钮查看差异"
echo ""

echo "3. 预期结果:"
echo "   • 应用程序应显示5条仅在 sample2.csv 中的记录"
echo "   • 不应显示仅在 sample1.csv 中的记录"
echo ""

echo "4. 尝试不同组合:"
echo "   • sample1.csv vs sample3.csv"
echo "   • sample2.csv vs sample3.csv"
echo "   • sample3.csv vs sample1.csv"
echo ""

echo "📋 示例文件详情:"
echo "================"
echo ""

echo "sample1.csv 内容:"
echo "----------------"
head -5 sample1.csv
echo "... (共10条记录)"
echo ""

echo "sample2.csv 内容:"
echo "----------------"
head -5 sample2.csv
echo "... (共15条记录)"
echo ""

echo "sample3.csv 内容:"
echo "----------------"
head -5 sample3.csv
echo "... (共17条记录)"
echo ""

echo "✅ 测试文件已准备就绪!"
echo "🎉 启动应用程序开始测试!" 