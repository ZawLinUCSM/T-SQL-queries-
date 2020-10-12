DECLARE @xml XML
SET @xml='<root>
				<Item ProductNumber="CA-5965" SafetyStock ="500" >321231231 </Item> 
				<Item ProductNumber="CB-2903" SafetyStock ="1000" ></Item>
				<Item ProductNumber="BE-2349" SafetyStock ="800" ></Item>
				<Item ProductNumber="AR-5381" SafetyStock ="1000" ></Item>
</root>'

SELECT Tab.Col.value('@ProductNumber','NVARCHAR(10)') as ProductNumber,
		Tab.Col.value('@SafetyStock','INT') as SafetyStock

FROM @xml.nodes('root/Item') as Tab(Col)