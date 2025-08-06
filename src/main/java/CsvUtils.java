import java.io.*;
import java.util.*;

public class CsvUtils {
    public static List<String[]> readCsv(File file) throws IOException {
        List<String[]> rows = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] values = line.split(",");
                rows.add(values);
            }
        }
        return rows;
    }
} 