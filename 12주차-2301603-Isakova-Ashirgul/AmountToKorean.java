import java.text.DecimalFormat;
import java.util.Scanner;
public class AmountToKorean {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("금액 입력: ");
        long amount = scanner.nextLong();

        String koreanAmount = readKorean(amount);
        String formattedAmount = formatAmount(amount);

        System.out.println(formattedAmount + "는 " + koreanAmount + "원");
        scanner.close();
    }
    public static String readKorean(long amount) {
        if (amount == 0) {
            return "영";
        }

        String[] unit1 = {"", "만 ", "억 ", "조 "};
        String[] unit2 = {"", "십", "백", "천"};

        StringBuilder result = new StringBuilder();

        int unit1Index = 0;

        while (amount > 0) {
            StringBuilder blockResult = new StringBuilder();
            int unit2Index = 0;

            for (int i = 0; i < 4 && amount > 0; i++) {
                int digit = (int) (amount % 10);
                amount /= 10;

                if (digit > 0) {
                    blockResult.insert(0, unit2[unit2Index]);
                    blockResult.insert(0, digitToKorean(digit));
                }

                unit2Index++;
            }

            if (blockResult.length() > 0) {
                result.insert(0, unit1[unit1Index]);
                result.insert(0, blockResult);
            }

            unit1Index++;
        }

        return result.toString();
    }
    private static String digitToKorean(int digit) {
        String[] koreanDigits = {"", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구"};
        return koreanDigits[digit];
    }
    private static String formatAmount(long amount) {
        DecimalFormat decimalFormat = new DecimalFormat("#,###");
        return decimalFormat.format(amount);
    }
}
