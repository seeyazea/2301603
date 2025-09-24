import java.util.Scanner;

public class ElectricityBill {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        String[] num = {"1111", "2222", "3333", "1212", "1313", "4444", "2121", "4343", "6789", "4545"};
        String[] name = {"홍길동", "이대한", "한국민", "이으뜸", "나이쁨", "김도령", "박대령", "허달수", "장마당", "정성길"};
        int[] households = {10};
        int[] usage = {10};



            for (int i = 0; i < 10; i++) {
                System.out.print((i + 1) + " 번째 " + name[i] + " 님의 월 세대수: ");
                usage [i] = scanner.nextInt();
                System.out.print((i + 1) + " 번째  " + name[i] + " 님의 사용량: ");
                households  [i] = scanner.nextInt();



                System.out.printf("%-6s%-6s%-6s%-6s%-10.1f%-12.1f%-6.1f%-10.1f%-10.1f%n",
                    num[i], name[i], households[i], usage[i]);

                System.out.printf("%-6s%-6s%-6s%-6s%-10s%-12s%-6s%-10s%-10s%n",
                        "번호", "이름", "세대수", "사용량", "기본요금", "사용요금", "세금", "전력기금", "납부요금",
                num[i], name[i], households[i], usage[i],
                        calculateBasicFee(usage[i]),
                        calculateUsageFee(usage[i]),
                        calculateVAT(calculateBasicFee(usage[i]) + calculateUsageFee(usage[i])),
                        calculatePowerFund(calculateUsageFee(usage[i])),
                        calculateTotalAmount(
                                calculateBasicFee(usage[i]),
                                calculateUsageFee(usage[i]),
                                calculateVAT(calculateBasicFee(usage[i]) + calculateUsageFee(usage[i])),
                                calculatePowerFund(calculateUsageFee(usage[i])),
                                households[i]
                        )
                );
                System.out.println("------------------------------------------------------------------------");

            }
    }
    private static double calculateTotalAmount(double basicFee, double usageFee, double vat, double powerFund, int household) {
        return (basicFee + usageFee + vat + powerFund) * household;
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

    private static int calculatePowerFund(int amount) {
        return (int) (amount * 0.037);
    }
}