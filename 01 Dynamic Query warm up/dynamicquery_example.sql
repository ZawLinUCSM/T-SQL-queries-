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
-- Author:		<Author,,Zaw Lin Htay>
-- Create date: <Create Date,10 October 2020,>
-- Description:	<Created sample dynamic query to filter the result based on the input string>
-- =============================================
ALTER PROCEDURE Filter_procedure 
	-- Add the parameters for the stored procedure here
	@jobTitle1 nvarchar(30),
	@jobtitle2 nvarchar(30)=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @search nvarchar(max)
	SET @jobTitle1=RTRIM(LTRIM(@jobTitle1))-- Trim the input parameter
	SET @jobTitle2=' '+RTRIM(LTRIM(@jobTitle2))-- Trim the input parameter
		BEGIN 
		 SET @search= '%' +@jobTitle1+'%'
		END
	ELSE 
		BEGIN 
		Set @search='%'+@jobTitle1 + @jobtitle2+'%'
		END

	DECLARE @dynamic nvarchar(max)-- Declare the variable for dynamic query
	SET @dynamic='select  Jobtitle,
Count(CASE WHEN Gender=''M'' THEN 1 END ) As Male,
Count(CASE WHEN Gender=''F'' THEN 1 END) As Female from HumanResources.Employee
Where HumanResources.Employee.JobTitle LIKE @searchParam
group by JobTitle'

EXEC sp_executesql @dynamic, N'@searchParam nvarchar(100)',@searchParam=@search -- Execute the dynamic query

 
END
GO

-- Execute stored procedure
exec Filter_procedure ' DESIGN    '

exec Filter_procedure ' DESIGN    ','  Engineer   '