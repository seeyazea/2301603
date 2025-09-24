import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        String[] hakbun = {"1601003", "1601007", "1601013", "1601024", "1601026",
                "1601058", "1601077", "1601085", "1601096", "1601110"};
        String[] name = {"홍길동", "이대한", "한나라", "이순신", "김동근",
                "김현호", "이동국", "박예림", "김혜숙", "나희영"};
        int[] kor = new int[10];
        int[] eng = new int[10];
        int[] math = new int[10];
        int[] sum = new int[10];
        float[] avg = new float[10];
        int[] rank = new int[10];

        for (int i = 0; i < 10; i++) {
            System.out.print((i + 1) + " 번째 학생 " + name[i] + " 님의 국어 성적: ");
            kor[i] = scanner.nextInt();
            System.out.print((i + 1) + " 번째 학생 " + name[i] + " 님의 영어 성적: ");
            eng[i] = scanner.nextInt();
            System.out.print((i + 1) + " 번째 학생 " + name[i] + " 님의 수학 성적: ");
            math[i] = scanner.nextInt();
            System.out.println();

            sum[i] = kor[i] + eng[i] + math[i];
            avg[i] = (float) sum[i] / 3;
        }

        System.out.println("*******************************************************************************");
        System.out.printf("%-10s%-10s%-10s%-10s%-10s%-10s%-10s%-10s%n", "학번", "이름", "국어", "영어", "수학", "총점", "평균", "석차");
        System.out.println("*******************************************************************************");
        for (int i = 0; i < 10; i++) {
            rank[i] = 1;
            for (int j = 0; j < 10; j++) {
                if (sum[j] > sum[i]) {
                    rank[i]++;
                }
            }

            String korGrade = getGrade(kor[i]);
            String engGrade = getGradeEng(eng[i]);
            String mathGrade = getGradeMath(math[i]);

            System.out.printf("%-10s%-10s%-10s%-10s%-10s%-10d%-10.2f%-10d%n",
                    hakbun[i], name[i], kor[i] + "(" + korGrade + ")", eng[i] + "(" + engGrade + ")",
                    math[i] + "(" + mathGrade + ")", sum[i], avg[i], rank[i]);
            if (i == 4) {
                System.out.println();
            }
        }


        System.out.println("*******************************************************************************");
    }


    private static String getGrade(int score) {
        return switch (score / 10) {
            case 10, 9 -> "수";
            case 8 -> "우";
            case 7 -> "미";
            case 6 -> "양";
            default -> "가";
        };
    }

    private static String getGradeEng(int score) {
        return switch (score / 10) {
            case 10 -> "A+";
            case 9 -> "A";
            case 8 -> "B";
            case 7 -> "C";
            case 6 -> "D";
            default -> "F";
        };
    }

        private static String getGradeMath(int score) {
            return switch (score / 10) {
                case 10 -> "A+";
                case 9 -> "A0";
                case 8 -> "B+";
                case 7 -> "B";
                case 6 -> "C+";
                case 5 -> "C";
                case 4 -> "D+";
                case 3, 2, 1, 0 -> "F";
                default -> throw new IllegalArgumentException("Invalid score");
            };
        }
    }




