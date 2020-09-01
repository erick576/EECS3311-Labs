package bank_v3;

import errors.*;

public class BankAppV3 {
	public static void main(String[] args) {
		System.out.println("Create an account for Alan with balance -10:");
		try {
			AccountV3 alan = new AccountV3("Alan", -10);
			System.out.println(alan);
		}
		catch (BalanceNegativeException bne) {
			System.out.println("Illegal negative account balance.");
		}
		
		System.out.println("==============================");
		System.out.println("Create an account for Mark with balance 100:");
		try {
			AccountV3 mark = new AccountV3("Mark", 100);
			System.out.println(mark);
			System.out.println("Withdraw -1000000 from Mark's account:");
			mark.withdraw(-1000000);
			System.out.println(mark);
		}
		catch (BalanceNegativeException bne) {
			System.out.println("Illegal negative account balance.");
		}
		catch (WithdrawAmountNegativeException wane) {
			System.out.println("Illegal negative withdraw amount.");
		}
		catch (WithdrawAmountTooLargeException wane) {
			System.out.println("Illegal too large withdraw amount.");
		}
		
		System.out.println("==============================");
		System.out.println("Create an account for Tom with balance 100:");
		try {
			AccountV3 tom = new AccountV3("Tom", 100);
			System.out.println(tom);
			System.out.println("Withdraw 150 from Tom's account:");
			tom.withdraw(150);
			System.out.println(tom);
		}
		catch (BalanceNegativeException bne) {
			System.out.println("Illegal negative account balance.");
		}
		catch (WithdrawAmountNegativeException wane) {
			System.out.println("Illegal negative withdraw amount.");
		}
		catch (WithdrawAmountTooLargeException wane) {
			System.out.println("Illegal too large withdraw amount.");
		}
		
		System.out.println("==============================");
		System.out.println("Create an account for Jim with balance 100:");
		try {
			AccountV3 jim = new AccountV3("Jim", 100);
			System.out.println(jim);
			System.out.println("Withdraw 100 from Jim's account:");
			jim.withdraw(100);
			System.out.println(jim);
		}
		catch (BalanceNegativeException bne) {
			System.out.println("Illegal negative account balance.");
		}
		catch (WithdrawAmountNegativeException wane) {
			System.out.println("Illegal negative withdraw amount.");
		}
		catch (WithdrawAmountTooLargeException wane) {
			System.out.println("Illegal too large withdraw amount.");
		}
	}
}
