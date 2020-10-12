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
ALTER PROCEDURE XML_Cursor
	-- Add the parameters for the stored procedure here
	@xml XML
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @dynamicQuery nvarchar(max);
	DECLARE @dynamicQuery_exec nvarchar(max);
	-- Variable for Cursor
	DECLARE @ProductNumber nvarchar(30)
	DECLARE @Operator nvarchar(30)
	DECLARE @Price nvarchar(30)

    -- Insert statements for procedure here
	-- Step 1 Create Temporary to take data from xml input
		select Tab.Col.value('@ProductNumber','nvarchar(30)') as ProductNumber,
		Tab.Col.value('@Operator','nvarchar(30)') as Operator,
		Tab.Col.value('@ListPrice','nvarchar(30)') as ListPrice
		INTO #tempXML
		FROM 
		@xml.nodes('root/Item') as Tab(Col)

	-- Step 2 Create table to collect data from cursor's output and final select
		CREATE TABLE #CollectDataCursor
		(
		ProductNumber nvarchar(30),
		Name nvarchar(30),
		ListPrice nvarchar(30)
		)

	-- Step 3 Create dynamic sql query
		SET @dynamicQuery =N'INSERT INTO #CollectDataCursor 
		SELECT b.ProductNumber,b.Name,c.ListPrice
		FROM #tempXML a
		JOIN Production.Product b ON b.ProductNumber=a.ProductNumber
		JOIN Production.ProductListPriceHistory c ON c.ProductID=b.ProductID AND c.ListPrice  '

	-- Step 4 Create Variables for cursor to place values
	-- Step 5 Declare And Set up Cursor
		DECLARE xmlCursor CURSOR FOR --declaration
		SELECT ProductNumber, Operator, ListPrice FROM #tempXML		-- the job of the cursor

		OPEN xmlCursor -- opening
		FETCH NEXT FROM xmlCursor INTO @ProductNumber,@Operator,@Price--starting point == first row of the table 
			WHILE @@FETCH_STATUS=0 -- condition for the loop WHILE this condition is true

			BEGIN -- the start of the loop
			 Set @dynamicQuery_exec=@dynamicQuery +@Operator+@Price + ' WHERE b.ProductNumber = '+''''+@ProductNumber+''''
			  print @dynamicQuery_exec
			 EXEC(@dynamicQuery_exec)

			FETCH NEXT FROM xmlCursor INTO @ProductNumber,@Operator,@Price-- all other rows except the first one
			END -- the end of the loop
		CLOSE xmlCursor
		DEALLOCATE xmlCursor
			

	-- Step 6 Make final select

		SELECT * FROM #CollectDataCursor

	-- Step 7 Drop all temp tables
	DROP TABLE #tempXML
	DROP TABLE #CollectDataCursor
END
GO


--- sample to execute Stored procedure

DECLARE @xml XML;
SET @xml=
'<root> 
				<Item ProductNumber="HL-U509-B" Operator = "&gt;=" ListPrice ="33" ></Item>
				<Item ProductNumber="SO-B909-L" Operator = "&lt;=" ListPrice ="10" ></Item>
				<Item ProductNumber="LJ-0192-S" Operator = "&gt;" ListPrice ="40" ></Item>
			</root>'
exec XML_Cursor @xml;