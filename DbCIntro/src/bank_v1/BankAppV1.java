package bank_v1;

public class BankAppV1 {
	public static void main(String[] args) {
		System.out.println("Create an account for Alan with balance -10:");
		AccountV1 alan = new AccountV1("Alan", -10); // Violates Contract
		System.out.println(alan);
		
		System.out.println("==============================");
		
		System.out.println("Create an account for Mark with balance 100:");
		AccountV1 mark = new AccountV1("Mark", 100);
		System.out.println(mark);
		System.out.println("Withdraw -1000000 from Mark's account:");
		mark.withdraw(-1000000); // Violates Contract
		System.out.println(mark);
		
		System.out.println("==============================");
		System.out.println("Create an account for Tom with balance 100:");
		AccountV1 tom = new AccountV1("Tom", 100);
		System.out.println(tom);
		System.out.println("Withdraw 150 from Tom's account:");
		tom.withdraw(150); // Violates Contract
		System.out.println(tom);
	}
}
