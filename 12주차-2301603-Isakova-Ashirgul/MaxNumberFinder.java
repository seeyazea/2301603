import java.util.Scanner;
public class MaxNumberFinder {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("첫 번째 숫자: ");
        double firstNumber = scanner.nextDouble();

        System.out.print("두 번째 숫자: ");
        double secondNumber = scanner.nextDouble();

        double maxNumber = Math.max(firstNumber, secondNumber);

        System.out.println("두 숫자 중에서 큰 수는: " + maxNumber);
        scanner.close();
    }
}


