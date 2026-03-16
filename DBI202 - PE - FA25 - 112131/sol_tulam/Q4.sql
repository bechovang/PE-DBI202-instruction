--q4

IF OBJECT_ID('NotificationEmails', 'U') IS NOT NULL
    DROP TABLE NotificationEmails
GO

CREATE TABLE NotificationEmails(
	Id INT PRIMARY KEY ,
	Recipient INT,
	[Subject] NVARCHAR(200),
	Content NVARCHAR(500)
);

GO;

CREATE TRIGGER noti
ON Accounts -- theo dõi Accounts
AFTER UPDATE  -- hoặc INSERT, DELETE
AS
BEGIN
    DECLARE @AccountId INT
    DECLARE @OldBalance DECIMAL(15,2)
    DECLARE @NewBalance DECIMAL(15,2)
    DECLARE @Date NVARCHAR(50)

	SELECT @AccountId = Id FROM inserted
	SELECT @OldBalance = Balance FROM deleted
	SELECT @NewBalance = Balance FROM inserted
	SET @Date 
	= CONVERT(NVARCHAR, GETDATE(), 105)-- dd-MM-yyyy 
	+ ' ' 
    + CONVERT(NVARCHAR, GETDATE(), 108) -- HH:mm:ss

	INSERT INTO NotificationEmails (Recipient, [Subject], Content)
	VALUES (
	@AccountId,
	 CONCAT('Update on account: ', @AccountId),
	 CONCAT('On ',@DATE,' your balance was changed from ',
	 @OldBalance,' to ',@NewBalance)
	)
END