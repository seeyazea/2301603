import java.util.Scanner;

public class ElectricityBill {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        String[] num = {"1111", "2222", "3333", "1212", "1313", "4444", "2121", "4343", "6789", "4545"};
        String[] name = {"홍길동", "이대한", "한국민", "이으뜸", "나이쁨",
                "김도령", "박대령" , "허달수", "장마당", "정성길"};
        int[] usage = {390, 520, 332, 390, 390, 252, 195, 138, 132, 128};
        int[] households = {1, 3, 1, 2, 2, 1, 1, 1, 1, 1};
        int[] basicFee = new int[10];
        int[] usageFee = new int[10];
        int[] vat = new int[10];
        int[] powerFund = new int[10];
        int[] totalAmount = new int[10];

        for (int i = 0; i < 10; i++) {
            System.out.print((i + 1) + " 번째 사용자 " + name[i] + " 님의 세대수 입력: ");
            households[i] = scanner.nextInt();
            System.out.print((i + 1) + " 번째 사용자 " + name[i] + " 님의 전기 사용량(Kw): ");
            usage[i] = scanner.nextInt();

            System.out.printf("%-6s%-6s%-6s%-6s%-10s%-12s%-6s%-10s%-10s%n",
                    "번호", "이름", "세대수", "사용양", "기본요금", " 사용요금", "세금", "전력기금", "납부요금");
            System.out.println("------------------------------------------------------------------------");



        }


        for (int i = 0; i < 10; i++) {

            System.out.printf("%-6s%-6s%-6s%-6s%-10d%-12d%-6d%-10d%-10d%n",
                    num[i], name[i], households[i], usage[i],
                    calculateBasicFee(usage[i]),
                    calculateUsageFee(usage[i]),
                    calculateVAT(calculateBasicFee(usage[i]) + calculateUsageFee(usage[i])),
                    (int) (calculateUsageFee(usage[i]) * 0.037),
                    calculateTotalAmount(
                            calculateBasicFee(usage[i]),
                            calculateUsageFee(usage[i]),
                            calculateVAT(calculateBasicFee(usage[i]) + calculateUsageFee(usage[i])),
                            (int) (calculateUsageFee(usage[i]) * 0.037),
                            (households[i])));
        }

    }


    private static int calculateBasicFee(int used) {
        if (used <= 100) {
            return 1370;
        } else if (used <= 200) {
            return 1820;
        } else if (used <= 300) {
            return 2430;
        } else if (used <= 400) {
            return 4420;
        } else if (used <= 500) {
            return 7410;
        } else {
            return 12750;
        }
    }

    private static int calculateUsageFee(int used) {
        if (used <= 100) {
            return (int) (used * 55.1);
        } else if (used <= 200) {
            return (int) (100 * 55.1 + (used - 100) * 113.8);
        } else if (used <= 300) {
            return (int) (100 * 55.1 + 100 * 113.8 + (used - 200) * 168.3);
        } else if (used <= 400) {
            return (int) (100 * 55.1 + 100 * 113.8 + 100 * 168.3 + (used - 300) * 248.6);
        } else if (used <= 500) {
            return (int) (100 * 55.1 + 100 * 113.8 + 100 * 168.3 + 100 * 248.6 + (used - 400) * 366.4);
        } else {
            return (int) (100 * 55.1 + 100 * 113.8 + 100 * 168.3 + 100 * 248.6 + 100 * 366.4 + (used - 500) * 643.9);
        }
    }

    private static int calculateVAT(int amount) {
        return (int) (amount * 0.1);
    }

    private static int calculateTotalAmount(int basicFee, int usageFee, int vat, int powerFund, int household) {
        return (basicFee + usageFee + vat + powerFund) * household;
    }
}
