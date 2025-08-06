import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashSet;
import java.util.Set;
import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

public class CsvComparatorApp extends JFrame {
    // 静态变量控制支持的文件数量
    private static final int MAX_FILES = 4; // 可以修改此值来支持更多文件
    private static final int DEFAULT_FILES = 3; // 默认显示的文件数量
    private static int currentFileCount = DEFAULT_FILES; // 当前激活的文件数量
    
    // 动态文件相关组件数组
    private JTextField[] fileFields;
    private JButton[] browseBtns;
    private JComboBox<String>[] columnCombos;
    private File[] files;
    private List<String[]>[] filesData;
    
    private JButton findCommonBtn, addFileBtn, removeFileBtn;
    private JTextArea resultArea;

    @SuppressWarnings("unchecked")
    public CsvComparatorApp() {
        setTitle("CSV 文件比较器 (支持最多 " + MAX_FILES + " 个文件)");
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(900, 700);
        setLocationRelativeTo(null);
        setLayout(new BorderLayout());

        // 初始化数组
        fileFields = new JTextField[MAX_FILES];
        browseBtns = new JButton[MAX_FILES];
        columnCombos = new JComboBox[MAX_FILES];
        files = new File[MAX_FILES];
        filesData = new List[MAX_FILES];
        filePanels = new JPanel[MAX_FILES];

        // 创建滚动面板用于文件选择
        JPanel filesPanel = new JPanel();
        filesPanel.setLayout(new BoxLayout(filesPanel, BoxLayout.Y_AXIS));
        
        // 创建所有文件选择组件（初始时只显示默认数量）
        for (int i = 0; i < MAX_FILES; i++) {
            filePanels[i] = createFilePanel(i);
            filesPanel.add(filePanels[i]);
            
            // 初始时只显示默认数量的文件面板
            filePanels[i].setVisible(i < currentFileCount);
        }

        // 文件管理按钮面板
        JPanel fileControlPanel = new JPanel(new FlowLayout());
        addFileBtn = new JButton("添加文件");
        removeFileBtn = new JButton("移除文件");
        JLabel fileCountLabel = new JLabel("当前文件数: " + currentFileCount);
        
        addFileBtn.addActionListener(e -> addFile(fileCountLabel));
        removeFileBtn.addActionListener(e -> removeFile(fileCountLabel));
        
        fileControlPanel.add(addFileBtn);
        fileControlPanel.add(removeFileBtn);
        fileControlPanel.add(fileCountLabel);
        
        // 动作面板
        JPanel actionPanel = new JPanel();
        findCommonBtn = new JButton("查找共同值");
        findCommonBtn.setEnabled(false);
        actionPanel.add(findCommonBtn);

        // 顶部面板
        JPanel topPanel = new JPanel(new BorderLayout());
        topPanel.add(new JScrollPane(filesPanel), BorderLayout.CENTER);
        topPanel.add(fileControlPanel, BorderLayout.SOUTH);
        topPanel.add(actionPanel, BorderLayout.SOUTH);

        add(topPanel, BorderLayout.NORTH);

        resultArea = new JTextArea();
        resultArea.setEditable(false);
        add(new JScrollPane(resultArea), BorderLayout.CENTER);

        // 添加事件监听器
        findCommonBtn.addActionListener(e -> findCommonValues());
        
        // 为所有列选择器添加监听器
        for (int i = 0; i < MAX_FILES; i++) {
            columnCombos[i].addActionListener(e -> updateFindButtonState());
        }
        
        updateFindButtonState();
    }
    
    // 创建单个文件面板
    private JPanel createFilePanel(int index) {
        JPanel mainPanel = new JPanel(new BorderLayout(5, 5));
        mainPanel.setBorder(BorderFactory.createTitledBorder("文件 " + (index + 1)));
        
        // 文件选择面板
        JPanel fileSelectPanel = new JPanel(new BorderLayout(5, 5));
        fileFields[index] = new JTextField();
        browseBtns[index] = new JButton("浏览...");
        
        fileSelectPanel.add(new JLabel("文件路径:"), BorderLayout.WEST);
        fileSelectPanel.add(fileFields[index], BorderLayout.CENTER);
        fileSelectPanel.add(browseBtns[index], BorderLayout.EAST);
        
        // 列选择面板
        JPanel columnSelectPanel = new JPanel(new BorderLayout(5, 5));
        columnCombos[index] = new JComboBox<>();
        columnCombos[index].setEnabled(false);
        
        columnSelectPanel.add(new JLabel("选择列:"), BorderLayout.WEST);
        columnSelectPanel.add(columnCombos[index], BorderLayout.CENTER);
        
        // 组合面板
        JPanel contentPanel = new JPanel(new GridLayout(2, 1, 5, 5));
        contentPanel.add(fileSelectPanel);
        contentPanel.add(columnSelectPanel);
        
        mainPanel.add(contentPanel, BorderLayout.CENTER);
        
        // 添加事件监听器
        final int fileIndex = index;
        browseBtns[index].addActionListener(e -> chooseFile(fileIndex));
        
        return mainPanel;
    }
    
    // 存储文件面板引用以便后续操作
    private JPanel[] filePanels;
    
    // 添加文件
    private void addFile(JLabel countLabel) {
        if (currentFileCount < MAX_FILES) {
            // 显示下一个文件面板
            filePanels[currentFileCount].setVisible(true);
            
            currentFileCount++;
            countLabel.setText("当前文件数: " + currentFileCount);
            
            addFileBtn.setEnabled(currentFileCount < MAX_FILES);
            removeFileBtn.setEnabled(currentFileCount > 2);
            
            updateFindButtonState();
            revalidate();
            repaint();
        }
    }
    
    // 移除文件
    private void removeFile(JLabel countLabel) {
        if (currentFileCount > 2) {
            currentFileCount--;
            
            // 隐藏最后一个文件面板
            filePanels[currentFileCount].setVisible(false);
            
            // 清理数据
            fileFields[currentFileCount].setText("");
            columnCombos[currentFileCount].removeAllItems();
            columnCombos[currentFileCount].setEnabled(false);
            files[currentFileCount] = null;
            filesData[currentFileCount] = null;
            
            countLabel.setText("当前文件数: " + currentFileCount);
            
            addFileBtn.setEnabled(true);
            removeFileBtn.setEnabled(currentFileCount > 2);
            
            updateFindButtonState();
            revalidate();
            repaint();
        }
    }

    private void chooseFile(int index) {
        if (index >= MAX_FILES) return;
        
        JFileChooser chooser = new JFileChooser();
        int ret = chooser.showOpenDialog(this);
        if (ret == JFileChooser.APPROVE_OPTION) {
            try {
                files[index] = chooser.getSelectedFile();
                fileFields[index].setText(files[index].getAbsolutePath());
                filesData[index] = CsvUtils.readCsv(files[index]);
                loadColumnsToComboBox(filesData[index], columnCombos[index]);
                updateFindButtonState();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "加载文件时出错: " + ex.getMessage(), "错误", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void loadColumnsToComboBox(List<String[]> data, JComboBox<String> comboBox) {
        comboBox.removeAllItems();
        if (data != null && !data.isEmpty()) {
            String[] headers = data.get(0);
            for (int i = 0; i < headers.length; i++) {
                comboBox.addItem("列 " + (i + 1) + ": " + headers[i]);
            }
            comboBox.setEnabled(true);
        } else {
            comboBox.setEnabled(false);
        }
    }

    private void updateFindButtonState() {
        boolean canFind = true;
        
        // 检查当前激活的文件是否都已选择并且列也已选择
        for (int i = 0; i < currentFileCount; i++) {
            if (filesData[i] == null || columnCombos[i].getSelectedItem() == null) {
                canFind = false;
                break;
            }
        }
        
        // 至少需要2个文件才能比较
        canFind = canFind && currentFileCount >= 2;
        
        findCommonBtn.setEnabled(canFind);
        
        // 更新添加/移除按钮状态
        if (addFileBtn != null) {
            addFileBtn.setEnabled(currentFileCount < MAX_FILES);
        }
        if (removeFileBtn != null) {
            removeFileBtn.setEnabled(currentFileCount > 2);
        }
    }



    // UI调用的方法 - 支持多文件比对
    private void findCommonValues() {
        // 验证至少有2个文件
        if (currentFileCount < 2) {
            JOptionPane.showMessageDialog(this, "至少需要选择两个CSV文件。", "错误", JOptionPane.ERROR_MESSAGE);
            return;
        }
        
        // 验证所有当前文件都已选择
        for (int i = 0; i < currentFileCount; i++) {
            if (filesData[i] == null) {
                JOptionPane.showMessageDialog(this, "请选择文件 " + (i + 1) + "。", "错误", JOptionPane.ERROR_MESSAGE);
                return;
            }
            if (columnCombos[i].getSelectedItem() == null) {
                JOptionPane.showMessageDialog(this, "请为文件 " + (i + 1) + " 选择要比较的列。", "错误", JOptionPane.ERROR_MESSAGE);
                return;
            }
        }
        
        try {
            // 准备文件信息数组（根据当前文件数量）
            String[] fileNames = new String[currentFileCount];
            int[] columnIndices = new int[currentFileCount];
            
            for (int i = 0; i < currentFileCount; i++) {
                fileNames[i] = files[i].getAbsolutePath();
                columnIndices[i] = columnCombos[i].getSelectedIndex();
            }
            
            // 调用重构后的方法（保持方法定义不变）
            findCommonValues(fileNames, columnIndices);
            
        } catch (Exception ex) {
            resultArea.setText("错误: " + ex.getMessage());
            JOptionPane.showMessageDialog(this, "错误: " + ex.getMessage(), "错误", JOptionPane.ERROR_MESSAGE);
        }
    }
    
    // 重构后的方法 - 接收文件名数组参数，统一使用多文件比较逻辑
    private void findCommonValues(String[] fileNames, int[] columnIndices) {
        if (fileNames == null || columnIndices == null) {
            throw new IllegalArgumentException("参数不能为空");
        }
        
        if (fileNames.length != columnIndices.length) {
            throw new IllegalArgumentException("文件名和列索引数组长度必须相同");
        }
        
        if (fileNames.length < 2) {
            throw new IllegalArgumentException("至少需要两个文件进行比较");
        }
        
        try {
            // 加载文件数据
            List<String[]>[] loadedFilesData = loadFilesData(fileNames);
            
            // 验证列索引有效性
            for (int i = 0; i < fileNames.length; i++) {
                validateColumnIndex(loadedFilesData[i], columnIndices[i], fileNames[i]);
            }
            
            // 统一使用多文件比较逻辑
            handleMultiFileComparison(loadedFilesData, columnIndices, fileNames);
            
        } catch (Exception ex) {
            resultArea.setText("错误: " + ex.getMessage());
            JOptionPane.showMessageDialog(this, "错误: " + ex.getMessage(), "错误", JOptionPane.ERROR_MESSAGE);
        }
    }
    

    
    // 处理文件比较（统一逻辑）
    private void handleMultiFileComparison(List<String[]>[] filesData, int[] columnIndices, String[] fileNames) {
        // 提取所有文件的列值
        List<Set<String>> allFileValues = new ArrayList<>();
        List<String> columnNames = new ArrayList<>();
        
        for (int i = 0; i < filesData.length; i++) {
            String columnName = filesData[i].get(0)[columnIndices[i]];
            Set<String> values = extractColumnValues(filesData[i], columnIndices[i]);
            
            allFileValues.add(values);
            columnNames.add(columnName);
        }
        
        // 计算多文件交集和差集
        MultiFileComparisonResult result = performMultiFileComparison(allFileValues, fileNames);
        
        try {
            // 写入比较结果
            writeMultiFileComparisonResults(result, columnNames, fileNames);
            
            // 显示比较结果
            displayMultiFileComparisonResults(result, columnNames, fileNames);
        } catch (IOException e) {
            throw new RuntimeException("写入结果文件时出错: " + e.getMessage(), e);
        }
    }
    
    // 加载多个文件的数据
    @SuppressWarnings("unchecked")
    private List<String[]>[] loadFilesData(String[] fileNames) throws IOException {
        List<String[]>[] filesData = new List[fileNames.length];
        
        for (int i = 0; i < fileNames.length; i++) {
            File file = new File(fileNames[i]);
            if (!file.exists()) {
                throw new IOException("文件不存在: " + fileNames[i]);
            }
            filesData[i] = CsvUtils.readCsv(file);
        }
        
        return filesData;
    }
    
    // 验证列索引的有效性
    private void validateColumnIndex(List<String[]> data, int columnIndex, String fileName) {
        if (data == null || data.isEmpty()) {
            throw new IllegalArgumentException("文件数据为空: " + fileName);
        }
        
        String[] headers = data.get(0);
        if (columnIndex < 0 || columnIndex >= headers.length) {
            throw new IllegalArgumentException("列索引超出范围: " + columnIndex + ", 文件: " + fileName + 
                                             " (共有 " + headers.length + " 列)");
        }
    }
    
    // 比较结果数据结构

    
    // 多文件比较结果数据结构
    private static class MultiFileComparisonResult {
        final Set<String> commonToAllFiles;        // 所有文件共有的值
        final Map<String, Set<String>> uniqueToFile; // 每个文件独有的值
        final Map<String, Set<String>> sharedSubsets; // 部分文件共享的值
        
        MultiFileComparisonResult(Set<String> commonToAllFiles, 
                                Map<String, Set<String>> uniqueToFile,
                                Map<String, Set<String>> sharedSubsets) {
            this.commonToAllFiles = commonToAllFiles;
            this.uniqueToFile = uniqueToFile;
            this.sharedSubsets = sharedSubsets;
        }
    }
    

    
    // 执行多文件比较逻辑
    private MultiFileComparisonResult performMultiFileComparison(List<Set<String>> allFileValues, String[] fileNames) {
        // 计算所有文件的交集（共同值）
        Set<String> commonToAllFiles = new HashSet<>(allFileValues.get(0));
        for (int i = 1; i < allFileValues.size(); i++) {
            commonToAllFiles.retainAll(allFileValues.get(i));
        }
        
        // 计算每个文件的独有值
        Map<String, Set<String>> uniqueToFile = new HashMap<>();
        for (int i = 0; i < allFileValues.size(); i++) {
            Set<String> uniqueValues = new HashSet<>(allFileValues.get(i));
            // 移除与其他所有文件的交集
            for (int j = 0; j < allFileValues.size(); j++) {
                if (i != j) {
                    uniqueValues.removeAll(allFileValues.get(j));
                }
            }
            uniqueToFile.put(fileNames[i], uniqueValues);
        }
        
        // 计算部分文件共享的值（可选，这里简化处理）
        Map<String, Set<String>> sharedSubsets = new HashMap<>();
        
        return new MultiFileComparisonResult(commonToAllFiles, uniqueToFile, sharedSubsets);
    }
    

    
    // 显示多文件比较结果
    private void displayMultiFileComparisonResults(MultiFileComparisonResult result, List<String> columnNames, String[] fileNames) {
        StringBuilder sb = new StringBuilder();
        sb.append("多文件比较结果:\n");
        sb.append("比较文件数: ").append(fileNames.length).append("\n\n");
        
        for (int i = 0; i < fileNames.length; i++) {
            sb.append("文件").append(i + 1).append(": ").append(new File(fileNames[i]).getName())
              .append(" (列: ").append(columnNames.get(i)).append(")\n");
        }
        sb.append("\n");
        
        sb.append("所有文件共有的值 (").append(result.commonToAllFiles.size()).append(" 个):\n");
        for (String value : result.commonToAllFiles) {
            sb.append("  ").append(value).append("\n");
        }
        sb.append("\n");
        
        for (String fileName : fileNames) {
            Set<String> uniqueValues = result.uniqueToFile.get(fileName);
            String shortName = new File(fileName).getName();
            sb.append("仅在 ").append(shortName).append(" 中的值 (").append(uniqueValues.size()).append(" 个):\n");
            for (String value : uniqueValues) {
                sb.append("  ").append(value).append("\n");
            }
            sb.append("\n");
        }
        
        sb.append("结果已保存到: result.csv");
        
        resultArea.setText(sb.toString());
        
        int totalUnique = result.uniqueToFile.values().stream().mapToInt(Set::size).sum();
        JOptionPane.showMessageDialog(this, 
            "多文件比较完成!\n所有文件共有值: " + result.commonToAllFiles.size() + 
            "\n各文件独有值总数: " + totalUnique + 
            "\n结果已保存到 result.csv", 
            "成功", JOptionPane.INFORMATION_MESSAGE);
    }
    
    // 写入多文件比较结果
    private void writeMultiFileComparisonResults(MultiFileComparisonResult result, List<String> columnNames, String[] fileNames) throws IOException {
        File resultFile = new File("result.csv");
        try (FileWriter writer = new FileWriter(resultFile)) {
            writer.write("类型,值,来源文件,来源列\n");
            
            // 写入所有文件共有的值
            for (String value : result.commonToAllFiles) {
                String allFileNames = String.join(" & ", 
                    java.util.Arrays.stream(fileNames)
                        .map(f -> new File(f).getName())
                        .toArray(String[]::new));
                String allColumnNames = String.join(" & ", columnNames);
                writer.write("所有文件共有,\"" + value + "\",\"" + allFileNames + "\",\"" + allColumnNames + "\"\n");
            }
            
            // 写入每个文件独有的值
            for (int i = 0; i < fileNames.length; i++) {
                String fileName = fileNames[i];
                String shortName = new File(fileName).getName();
                String columnName = columnNames.get(i);
                Set<String> uniqueValues = result.uniqueToFile.get(fileName);
                
                for (String value : uniqueValues) {
                    writer.write("独有值,\"" + value + "\",\"" + shortName + "\",\"" + columnName + "\"\n");
                }
            }
        }
    }
    
    private Set<String> extractColumnValues(List<String[]> data, int columnIndex) {
        Set<String> values = new HashSet<>();
        // Skip header row (index 0)
        for (int i = 1; i < data.size(); i++) {
            String[] row = data.get(i);
            if (row.length > columnIndex && row[columnIndex] != null) {
                String value = row[columnIndex].trim();
                if (!value.isEmpty()) {
                    values.add(value);
                }
            }
        }
        return values;
    }
    


    // 公共方法示例 - 可以从外部调用进行多文件比较
    public void compareFiles(String[] fileNames, int[] columnIndices) {
        findCommonValues(fileNames, columnIndices);
    }
    
    // 命令行使用示例
    public static void demonstrateFileArrayComparison() {
        try {
            CsvComparatorApp app = new CsvComparatorApp();
            
            // 示例：比较三个文件的第一列（姓名列）
            String[] fileNames = {"sample1.csv", "sample2.csv", "sample3.csv"};
            int[] columnIndices = {0, 0, 0}; // 都选择第一列
            
            System.out.println("演示多文件比较功能:");
            System.out.println("比较文件: " + String.join(", ", fileNames));
            System.out.println("比较列索引: " + java.util.Arrays.toString(columnIndices));
            
            app.findCommonValues(fileNames, columnIndices);
            
        } catch (Exception e) {
            System.err.println("演示过程中出错: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        // 如果有命令行参数，演示文件数组比较功能
        if (args.length > 0 && "demo".equals(args[0])) {
            demonstrateFileArrayComparison();
        } else {
            // 正常启动GUI
        SwingUtilities.invokeLater(() -> new CsvComparatorApp().setVisible(true));
        }
    }
} 