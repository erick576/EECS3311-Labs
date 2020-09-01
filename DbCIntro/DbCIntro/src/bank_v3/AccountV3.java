package bank_v3;

import errors.*;

public class AccountV3 {
	private String owner;
	private int balance;
	
	public String getOwner() {
		return owner;
	}
	
	public int getBalance() {
		return balance;
	}
	
	public AccountV3(String owner, int balance)
		throws BalanceNegativeException
	{
		if(balance < 0) { /* negated precondition */
			throw new BalanceNegativeException();
		}
		else {
			this.owner = owner;
			this.balance = balance;
		}
		assert this.getBalance() > 0 : "Invariant: positive balance";
	}
	
	public void withdraw(int amount)
		throws 
			WithdrawAmountNegativeException, 
			WithdrawAmountTooLargeException
	{
		if(amount < 0) { /* negated precondition */
			throw new WithdrawAmountNegativeException();
		}
		else if (balance < amount) { /* negated precondition */
			throw new WithdrawAmountTooLargeException();
		}
		else {
			this.balance = this.balance - amount;
		}
		assert this.getBalance() > 0 : "Invariant: positive balance";
	}
	
	public String toString() {
		return owner + "'s current balance is: " + balance; 
	}
}


/**
 * Problems from V1
 * The condition we added in line 42 in V2 is a exception condition that amount must be greater than balance
 * but when they both are equal the balance will be 0 and that is not strictly positive breaking the requirements
 * 
 * Changes in V3 we added an invariant condition that this.balance > 0 throughout the lifetime of all instances of Account (Line 27 & 44)  
 * Why is this still not a good design. 
 * 1) If the code gets bigger the number of class invariants and preconditions will keep increasing
 * 2)  The class invariant can't catch faulty implementation. Example) we change the - on line 42 to +
 * 
 */
