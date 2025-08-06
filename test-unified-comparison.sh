#!/bin/bash

echo "=== 测试统一多文件比较功能 ==="
echo ""

# 检查样本文件是否存在
echo "1. 检查样本文件..."
if [ -f "sample1.csv" ] && [ -f "sample2.csv" ] && [ -f "sample3.csv" ]; then
    echo "✅ 样本文件存在"
else
    echo "❌ 样本文件不存在，正在创建..."
    # 创建样本文件
    echo "姓名,年龄" > sample1.csv
    echo "张三,25" >> sample1.csv
    echo "李四,30" >> sample1.csv
    echo "王五,35" >> sample1.csv
    
    echo "姓名,年龄" > sample2.csv
    echo "李四,30" >> sample2.csv
    echo "王五,35" >> sample2.csv
    echo "赵六,40" >> sample2.csv
    
    echo "姓名,年龄" > sample3.csv
    echo "王五,35" >> sample3.csv
    echo "赵六,40" >> sample3.csv
    echo "钱七,45" >> sample3.csv
    
    echo "✅ 样本文件创建完成"
fi

echo ""
echo "2. 编译应用..."
mvn clean compile
if [ $? -eq 0 ]; then
    echo "✅ 编译成功"
else
    echo "❌ 编译失败"
    exit 1
fi

echo ""
echo "3. 测试命令行演示功能..."
mvn exec:java -Dexec.mainClass="CsvComparatorApp" -Dexec.args="demo"
if [ $? -eq 0 ]; then
    echo "✅ 命令行演示成功"
else
    echo "❌ 命令行演示失败"
fi

echo ""
echo "4. 检查结果文件..."
if [ -f "result.csv" ]; then
    echo "✅ 结果文件已生成"
    echo "结果文件内容预览:"
    head -10 result.csv
else
    echo "❌ 结果文件未生成"
fi

echo ""
echo "5. 测试场景说明:"
echo "   - 样本文件1包含: 张三, 李四, 王五"
echo "   - 样本文件2包含: 李四, 王五, 赵六"
echo "   - 样本文件3包含: 王五, 赵六, 钱七"
echo ""
echo "   预期结果:"
echo "   - 所有文件共有: 王五"
echo "   - 文件1独有: 张三"
echo "   - 文件2独有: (无)"
echo "   - 文件3独有: 钱七"

echo ""
echo "6. 启动GUI应用进行手动测试..."
echo "   请在新窗口中测试以下功能:"
echo "   - 选择3个样本文件"
echo "   - 为每个文件选择'姓名'列"
echo "   - 点击'查找共同值'按钮"
echo "   - 验证结果显示和result.csv文件内容"

echo ""
echo "=== 测试完成 ===" 