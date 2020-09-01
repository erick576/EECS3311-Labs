package bank_v4;

import errors.*;

public class BankAppV4 {
	public static void main(String[] args) {
		System.out.println("==============================");
		System.out.println("Create an account for Jeremy with balance 100:");
		try {
			AccountV4 jeremy = new AccountV4("Jeremy", 100);
			System.out.println(jeremy);
			System.out.println("Withdraw 50 from Jeremy's account:");
			jeremy.withdraw(50);
			System.out.println(jeremy);
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
