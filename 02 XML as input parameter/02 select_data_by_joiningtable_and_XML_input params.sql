-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE XML_Filter
	-- Add the parameters for the stored procedure here
	@xml XML
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT T.C.value('@ProductNumber','nvarchar(10)') as ProductNumber, -- Select data from xml input parameters 																	
		T.C.value('@SafetyClock','INT') as SafetyStock 
		INTO #tempTable												--and then store the result in temporary table
		FROM @xml.nodes('root/Item') as T(C)

DECLARE @tempCount Varchar(10)
SELECT @tempCount=COUNT(*) FROM #tempTable -- Check how many data exist in the temporary table
print @tempCount 							-- Print and check in the console

SELECT c.TransactionDate,c.TransactionType,c.Quantity,c.ActualCost
, b.ListPrice,b.Color
FROM #tempTable a
JOIN Production.Product b ON a.ProductNumber=b.ProductNumber --AND a.SafetyStock=b.SafetyStockLevel
JOIN Production.TransactionHistory c ON b.ProductID=c.ProductID

DROP TABLE #tempTable			-- Drop the whole temp table
END
GO

--Execute the Stored procedure
EXEC XML_Filter '<root>
				<Item ProductNumber="CA-5965" SafetyStock ="500" >321231231 </Item> 
				<Item ProductNumber="CB-2903" SafetyStock ="1000" ></Item>
				<Item ProductNumber="BE-2349" SafetyStock ="800" ></Item>
				<Item ProductNumber="AR-5381" SafetyStock ="1000" ></Item>
</root>'