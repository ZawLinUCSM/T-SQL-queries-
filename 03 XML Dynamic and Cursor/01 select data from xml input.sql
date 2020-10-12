DECLARE @xml XML;
SET @xml=
'<root> 
				<Item ProductNumber="HL-U509-B" Operator = "&gt;=" ListPrice ="33" ></Item>
				<Item ProductNumber="SO-B909-L" Operator = "&lt;=" ListPrice ="10" ></Item>
				<Item ProductNumber="LJ-0192-S" Operator = "&gt;" ListPrice ="40" ></Item>
			</root>'

select Tab.Col.value('@ProductNumber','nvarchar(30)') as ProductNumber,
Tab.Col.value('@Operator','nvarchar(30)') as Operator,
Tab.Col.value('@ListPrice','nvarchar(30)') as ListPrice
FROM 
@xml.nodes('root/Item') as Tab(Col)
