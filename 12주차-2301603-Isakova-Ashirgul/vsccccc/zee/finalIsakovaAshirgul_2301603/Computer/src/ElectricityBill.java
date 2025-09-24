import java.util.Scanner;

public class ElectricityBill {
        public static void main(String[] args) {
                Scanner scanner = new Scanner(System.in);

                // Array to store information for 10 users
                String[] num = {"1111", "2222", "3333", "1212", "1313", "4444", "2121", "4343", "6789", "4545"};
                String[] name = {"홍길동", "이대한", "한국민", "이으뜸", "나이쁨", "김도령", "박대령", "허달수", "장마당", "정성길"};
                int[] usage = new int[10];
                int[] households = new int[10];

                for (int i = 0; i < 10; i++) {
                        System.out.print((i + 1) + " 번째  " + name[i] + " 님의 세대수: ");
                        households[i] = scanner.nextInt();
                        System.out.print((i + 1) + " 번째 " + name[i] + " 님의 월 사용량 (Kw): ");
                        usage[i] = scanner.nextInt();

                }

                System.out.printf("%-6s%-6s%-6s%-6s%-10s%-10s%-10s%-10s%-10s%n",
                        "번호", "이름", "세대수", "사용양", "기본요금", "사용요금", "부가세", "전력기금", "납부요금");
                System.out.println("------------------------------------------------------------------------");

                for (int i = 0; i < 10; i++) {
                        int basicFee = calculateBasicFee(usage[i]);
                        double usageFee = calculateUsageFee(usage[i]);
                        double tax = (basicFee + usageFee) * 0.1;
                        double powerFund = usageFee * 0.037;
                        double totalAmount = basicFee + usageFee + tax + powerFund;

                        System.out.printf("%-6s%-6s%-6s%-6s%-10s%-10s%-10s%-10s%-10s%n",
                                num[i], name[i], households[i], usage[i], basicFee, usageFee, tax, powerFund, Math.floor(totalAmount / 10) * 10);
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
                } else if (usage <= 500) {
                        return 7410;
                } else {
                        return 12750;
                }
        }

        private static double calculateUsageFee(int usage) {
                if (usage <= 100) {
                        return usage * 55.1;
                } else if (usage <= 200) {
                        return 100 * 55.1 + (usage - 100) * 113.8;
                } else if (usage <= 300) {
                        return 100 * 55.1 + 100 * 113.8 + (usage - 200) * 168.3;
                } else if (usage <= 400) {
                        return 100 * 55.1 + 100 * 113.8 + 100 * 168.3 + (usage - 300) * 248.6;
                } else if (usage <= 500) {
                        return 100 * 55.1 + 100 * 113.8 + 100 * 168.3 + 100 * 248.6 + (usage - 400) * 366.4;
                } else {
                        return 100 * 55.1 + 100 * 113.8 + 100 * 168.3 + 100 * 248.6 + 100 * 366.4 + (usage - 500) * 643.9;
                }
        }
}
