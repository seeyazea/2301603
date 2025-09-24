import java.util.Scanner;

public class elseif {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // Array to store information for 10 users
        String[] num = {"1111", "1212", "6789", "4444", "2222", "4343", "4545", "1313", "3333", "2121"};
        String[] name = {"홍길동", "이으뜸", "장마당", "김도령", "이대한", "허달수", "정성길", "나이쁨", "한국민", "박대령"};
        int[] usage = new int[10];
        int[] households = new int[10];

        for (int i = 0; i < 10; i++) {
            System.out.print((i + 1) + " 번째  " + name[i] + " 님의 세대수: ");
            households[i] = scanner.nextInt();
            System.out.print((i + 1) + " 번째 " + name[i] + " 님의 월 사용량 (Kw): ");
            usage[i] = scanner.nextInt();
        }

        System.out.println("                                             전    기    요   금                                            ");
        System.out.println("----------------------------------------------------------------------------------------------------------");

        System.out.printf("%-10s%-10s%-10s%-8s%-12s%-15s%-15s%-15s%-15s%n",
                "번호", "이름", "세대수", "사용양", "기본요금", "사용요금", "부가가치세", "전력기금", "사용금액");
        System.out.println("----------------------------------------------------------------------------------------------------------");
        for (int i = 0; i < 10; i++) {
            int basicFee = calculateBasicFee(usage[i]);
            double usageFee = calculateUsageFee(usage[i]);
            int tax = (int) (usageFee / 10);
            int powerFund = (int) (usageFee * 3.7 / 100);
            int totalAmount = basicFee + (int) usageFee + tax + powerFund;

            System.out.printf("%-10s%-10s%-12s%-9s%-13s%-16s%-16s%-16s%-16s%n",
                    num[i], name[i], households[i], usage[i], formatWithComma(basicFee),
                    formatWithComma((int) usageFee), formatWithComma(tax), formatWithComma(powerFund),
                    formatWithComma(totalAmount));
        }
    }

    private static int calculateBasicFee(int usage) {
        if (usage <= 100) {
            return 1370;
        } else if (usage <= 200) {
            return 1820;
        } else if (usage <= 300) {
            return 2430;
        } else if (usage <= 400) {
            return 4420;
        } else if (usage <= 520) {
            return 7410;
        } else {
            return 12750;
        }
    }

    private static double calculateUsageFee(int usage) {
        double usageFee;

        if (usage <= 100) {
            usageFee = usage * 55.1;
        } else if (usage <= 200) {
            usageFee = 100 * 55.1 + (usage - 100) * 113.8;
        } else if (usage <= 300) {
            usageFee = 100 * 55.1 + 100 * 113.8 + (usage - 200) * 168.3;
        } else if (usage <= 400) {
            usageFee = 100 * 55.1 + 100 * 113.8 + 100 * 168.3 + (usage - 300) * 248.6;
        } else if (usage <= 500) {
            usageFee = 100 * 55.1 + 100 * 113.8 + 100 * 168.3 + 100 * 248.6 + (usage - 400) * 366.4;
        } else {
            usageFee = 100 * 55.1 + 100 * 113.8 + 100 * 168.3 + 100 * 248.6 + 100 * 366.4 + (usage - 500) * 643.9;
        }

        return usageFee;
    }

    private static String formatWithComma(int number) {
        return String.format("%,d", number);
    }
}


