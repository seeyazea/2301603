import java.util.Scanner;
public class switchc


        ase {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        String[] num = {"1111", "2222", "3333", "1212", "1313", "4444", "2121", "4343", "6789", "4545"};
        String[] name = {"홍길동", "이으뜸", "장마당", "김도령", "이대한", "허달수", "정성길", "나이쁨", "한국민", "박대령"};
        int[] usage = {390, 520, 332, 390, 390, 252, 195, 138, 132, 128};
        int[] households = {1, 3, 1, 2, 2, 1, 1, 1, 1, 1};

        System.out.println("                                             전    기    요   금                                            ");
        System.out.println("----------------------------------------------------------------------------------------------------------");

        System.out.printf("%-10s%-10s%-10s%-8s%-10s%-13s%-13s%-13s%-13s%n",
                "번호", "이름", "세대수", "사용양", "기본요금", "사용요금", "부가가치세", "전력기금", "사용금액");
        System.out.println("----------------------------------------------------------------------------------------------------------");
        for (int i = 0; i < 10; i++) {
            int basicFee = calculateBasicFee(usage[i], households[i]);
            int usageFee = calculateUsageFee(usage[i]);
            int vat = (basicFee + usageFee) / 10;
            int powerFund = (int) (usageFee * 0.037);
            int totalAmount = basicFee + usageFee + vat + powerFund;

            System.out.printf("%-10s%-10s%-12s%-9s%-11s%-14s%-16s%-14s%-17s%n",
                    num[i], name[i], households[i], usage[i], formatWithComma(basicFee),
                    formatWithComma(usageFee), formatWithComma(vat), formatWithComma(powerFund),
                    formatWithComma(totalAmount));
        }
    }

    private static int calculateBasicFee(int usage, int households) {
        int fee = 0;

        switch (usage / 100) {
            case 0:
                fee = households * 1370;
                break;
            case 1:
                fee = households * 1820;
                break;
            case 2:
                fee = households * 2430;
                break;
            case 3:
                fee = households * 4420;
                break;
            case 4:
                fee = households * 7410;
                break;
            default:
                fee = households * 12750;
        }

        return fee;
    }

    private static int calculateUsageFee(int usage) {
        int remainingUsage = usage;
        int totalUsageFee = 0;

        for (int i = 0; i < 5; i++) {
            int stepUsage = Math.min(100, remainingUsage);
            int stepFee = 0;

            switch (i) {
                case 0:
                    stepFee = (int) (stepUsage * 55.1);
                    break;
                case 1:
                    stepFee = (int) (stepUsage * 113.8);
                    break;
                case 2:
                    stepFee = (int) (stepUsage * 168.3);
                    break;
                case 3:
                    stepFee = (int) (stepUsage * 248.6);
                    break;
                case 4:
                    stepFee = (int) (stepUsage * 366.4);
                    break;
            }

            totalUsageFee += stepFee;
            remainingUsage -= stepUsage;

            if (remainingUsage <= 0) {
                break;
            }
        }

        return totalUsageFee;
    }

    private static String formatWithComma(int number) {
        return String.format("%,d", number);
    }
}