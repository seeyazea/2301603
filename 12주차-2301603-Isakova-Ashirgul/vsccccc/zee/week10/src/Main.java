import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        String[] hakbun = {"0801211", "0801234", "0801345",
                "0801567", "0801678", "0801251", "0801987",
                "0801684", "0801754", "0801840"};
        String[] name = new String[]{"홍길동", "이대한",
                "한나라", "이순신", "김동근", "김현호",
                "이동국", "박예림", "김혜숙", "나희영"};
        int[] kor = new int[10];
        int[] eng = new int[10];
        int[] math = new int[10];
        int[] sum = new int[10];
        float[] avg = new float[10];
        int rank[] = new int[10];
        for (int i = 0; i < 10; i++) {
            System.out.print(name[i] + "님의 국어 성적을 입력해주세요: ");
            kor[i] = scanner.nextInt();
            System.out.print(name[i] + "님의 영어 성적을 입력해주세요: ");
            eng[i] = scanner.nextInt();
            System.out.print(name[i] + "님의 수학 성적을 입력해주세요: ");
            math[i] = scanner.nextInt();

            sum[i] = kor[i] + eng[i] + math[i];
            avg[i] = (float) sum[i] / 3;
        }
        System.out.println("****************************************************");
        System.out.println("학번     이름   국어   영어   수학    총점     평균  등수");
        System.out.println("****************************************************");
        for (int i = 0; i < 10; i++) {
            rank[i] = 1;
            for (int j = 0; j < 10; j++) {
                if (sum[j] > sum[i]) {
                    rank[i]++;
                }
            }
            char korGrade;
            switch (kor[i] / 10) {
                case 10:
                case 9:
                    korGrade = '수';
                    break;
                case 8:
                    korGrade = '우';
                    break;
                case 7:
                    korGrade = '미';
                    break;
                case 6:
                    korGrade = '양';
                    break;
                default:
                    korGrade = '가';
            }

            char engGrade;
            if (eng[i] >= 95) {
                engGrade = 'A';
            } else if (eng[i] >= 90) {
                engGrade = 'A';
            } else if (eng[i] >= 85) {
                engGrade = 'B';
            } else if (eng[i] >= 80) {
                engGrade = 'B';
            } else if (eng[i] >= 75) {
                engGrade = 'C';
            } else if (eng[i] >= 70) {
                engGrade = 'C';
            } else if (eng[i] >= 65) {
                engGrade = 'D';
            } else if (eng[i] >= 60) {
                engGrade = 'D';
            } else {
                engGrade = 'F';
            }


            char mathGrade;
            switch (math[i] / 10) {
                case 10:
                    mathGrade = 'A';
                    break;
                case 9:
                    mathGrade = 'A';
                    break;
                case 8:
                    mathGrade = 'B';
                    break;
                case 7:
                    mathGrade = 'C';
                    break;
                case 6:
                    mathGrade = 'D';
                    break;
                default:
                    mathGrade = 'F';
            }


            System.out.printf("%s %s %d(%c) %d(%c) %d(%c) %d %.2f %d\n",
                    hakbun[i], name[i], kor[i], korGrade, eng[i], engGrade, math[i], mathGrade,
                    sum[i], avg[i], rank[i]);
        }
    }
}

