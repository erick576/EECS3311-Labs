package bank_v5;

import errors.*;

public class AccountV5 {
	private String owner;
	private int balance;
	
	public String getOwner() {
		return owner;
	}
	
	public int getBalance() {
		return balance;
	}
	
	public AccountV5(String owner, int balance)
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
		// PreState Start
		int oldBalance = this.balance;                             
		if(amount < 0) { /* negated precondition */                            
			throw new WithdrawAmountNegativeException();
		}
		else if (balance < amount) { /* negated precondition */
			throw new WithdrawAmountTooLargeException();
		}
		// PreState End
		else {
			/* WRONT IMPLEMENTATION */
			this.balance = this.balance + amount;
		}
		// PostState Start 
		assert this.getBalance() > 0 : owner + "Invariant: positive balance"; // This is an invariant, NOT A POSTCONDITION
		assert this.getBalance() == oldBalance - amount : "Postcondition: balance deducted";  // Post Condition
		// PostState End
	}
	
	public String toString() {
		return owner + "'s current balance is: " + balance; 
	}
}

/**
 * Changes in V5
 * 1) Added postcondition on line 50 to be able to catch faulty implementation
 * 
 * 					Improvements Made 													Design Flaws
 * 
 *	V1					 –      								     		       Complete lack of Contract
 *	V2		Added exceptions as method preconditions  						Preconditions not strong enough (i.e., with missing cases) may result in an invalid account state.
 *	V3 		Added assertions as class invariants 										–
 *	V4		Deliberately changed withdraw’s implementation to be incorrect. Incorrect implementations do not necessarily result in a state that violates the class invariants.
 *	V5 		Added assertions as method postconditions 									–
 *	
 *	 In Versions 2, 3, 4, 5, preconditions approximated as exceptions.
 *	These are not preconditions, but their logical negation .
 *	Client BankApp’s code complicated by repeating the list of try-catch statements.
 *	 In Versions 3, 4, 5, class invariants and postconditions approximated as assertions.
 *	Unlike exceptions, these assertions will not appear in the API of withdraw.
 *	Potential clients of this method cannot know: 1) what their benefits are; and 2) what their suppliers’ obligations are.
 *	For postconditions, extra code needed to capture pre execution values of attributes.
 *
 */
