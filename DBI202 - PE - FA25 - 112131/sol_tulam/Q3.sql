--q3
-- check:
-- amount > 0
-- @AccountId có tồn tại
-- balance >= amount

-- thực hiện:
-- trừ tiền => balance - amount


CREATE PROCEDURE WithDrawMoney
	@AccountId INT,
	@Amount DECIMAL(15,2)
AS
BEGIN
	BEGIN TRANSACTION
		IF	@Amount <= 0 
			BEGIN
				ROLLBACK;
				RETURN;
			END
		IF  NOT EXISTS ( SELECT 1 FROM [Accounts] WHERE Id = @AccountId )
			BEGIN
				ROLLBACK;
				RETURN;
			END
		
		DECLARE @balance DECIMAL(15,2);
		SELECT @balance = Balance FROM [Accounts] WHERE Id = @AccountId ;

		IF  @balance - @Amount < 0
			BEGIN
				ROLLBACK;
			END

	-- thực hiện
	UPDATE [Accounts] 
	SET Balance = Balance - @Amount
	WHERE Id = @AccountId;
	COMMIT;
	
		


END