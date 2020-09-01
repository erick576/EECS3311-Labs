package bank_v4;

import errors.*;

public class AccountV4 {
	private String owner;
	private int balance;
	
	public String getOwner() {
		return owner;
	}
	
	public int getBalance() {
		return balance;
	}
	
	public AccountV4(String owner, int balance)
		throws BalanceNegativeException
	{
		if(balance < 0) { /* negated precondition */
			throw new BalanceNegativeException();
		}
		else {
			this.owner = owner;
			this.balance = balance;
		}
		assert this.getBalance() > 0 : owner + "Invariant: positive balance";
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
			/* WRONT IMPLEMENTATION */
			this.balance = this.balance + amount;
		}
		assert this.getBalance() > 0 : owner + "Invariant: positive balance";
	}
	
	public String toString() {
		return owner + "'s current balance is: " + balance; 
	}
}


/** 
 * Now in V4 we expose this with changing the - to + in line 42
 * How can we improve this implementation. (Add Postconditions (Will be on V5))  
 */
