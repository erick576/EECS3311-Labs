package bank_v1;

public class AccountV1 {
	private String owner;
	private int balance;
	
	public String getOwner() {
		return owner;
	}
	
	public int getBalance() {
		return balance;
	}

	public AccountV1(String owner, int balance) {
		assert( balance > 0 ); // Check for contract Violation (I ADDED)
		this.owner = owner;
		this.balance = balance;
	}

	public void withdraw(int amount) {
		assert( this.balance > amount ); // Check for contract Violation (I ADDED)
		this.balance = this.balance - amount;
	}
	
	public String toString() {
		return owner + "'s current balance is: " + balance; 
	}
}

/**
 * What was wrong with this implementation initially? Refer to requirements on notes
 * 
 * 1. Positive amount balance always (Wasn't checked for before) 
 * 2. Negative Balance Withdrawal
 * 3. Positive amount withdrawal less than the current balance
 * 
 * This Implementation tried to satisfy requirements 1 & 2 and broke both of them
 */

