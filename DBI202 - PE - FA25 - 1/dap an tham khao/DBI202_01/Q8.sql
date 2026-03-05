create proc proc_SumQuantityProduct
	@Store_id int,
	@SumQuantity decimal(10,2) output
as
begin
	Select @SumQuantity=SUM(PIN.quantity)
	from stocks PIN
	where PIN.store_id =@Store_id
end