SELECT        dbo.CUSTOMERS.CUSTDES AS Customer, dbo.ORDERS.ORDNAME AS [Order], dbo.fnFormatDate(dbo.MINTODATE(dbo.ORDERS.CURDATE), 'DD/MM/YY') AS Date, 
                         dbo.PART.PARTNAME AS [Part Number], dbo.PART.PARTDES AS [Part Description], dbo.fnFormatDate(dbo.MINTODATE(dbo.ORDERITEMS.DUEDATE), 'DD/MM/YY') 
                         AS [Due Date], dbo.ORDERITEMS.TQUANT / 1000 AS [Ordered Qty], dbo.ORDERITEMS.TBALANCE / 1000 AS Balance, 
                         dbo.TRANSORDER.TQUANT / 1000 AS [Transaction Quantity], 
                         CASE WHEN TRANSORDER.TYPE = 'X' THEN INVOICES.IVNUM WHEN TRANSORDER.TYPE = 'V' THEN INVOICES.IVNUM ELSE DOCUMENTS.DOCNO END AS Expr1, 
                         dbo.fnFormatDate(dbo.MINTODATE(dbo.TRANSORDER.CURDATE), 'DD/MM/YY') AS Expr2, 
                         CASE WHEN TRANSORDER.CURDATE = 0 THEN '' 
						 ELSE DATEDIFF(DAY, dbo.MINTODATE(ORDERITEMS.DUEDATE), dbo.MINTODATE(TRANSORDER.CURDATE)) 
                         END AS [Day Diff]
FROM            dbo.ORDERS INNER JOIN
                         dbo.ORDERITEMS ON dbo.ORDERS.ORD = dbo.ORDERITEMS.ORD INNER JOIN
                         dbo.CUSTOMERS ON dbo.CUSTOMERS.CUST = dbo.ORDERS.CUST INNER JOIN
                         dbo.PART ON dbo.ORDERITEMS.PART = dbo.PART.PART INNER JOIN
                         dbo.PARTPARAM ON dbo.PART.PART = dbo.PARTPARAM.PART INNER JOIN
                         dbo.ORDSTATUS ON dbo.ORDERS.ORDSTATUS = dbo.ORDSTATUS.ORDSTATUS RIGHT OUTER JOIN
                         dbo.TRANSORDER ON dbo.ORDERITEMS.ORDI = dbo.TRANSORDER.ORDI RIGHT OUTER JOIN
                         dbo.DOCUMENTS ON dbo.DOCUMENTS.DOC = dbo.TRANSORDER.DOC AND dbo.TRANSORDER.TYPE = 'X' OR dbo.TRANSORDER.TYPE = 'Y' RIGHT OUTER JOIN
                         dbo.INVOICES ON dbo.INVOICES.IV = dbo.TRANSORDER.DOC AND dbo.TRANSORDER.TYPE = 'X' OR dbo.TRANSORDER.TYPE = 'V' RIGHT OUTER JOIN
                         dbo.DOCTYPES ON dbo.TRANSORDER.TYPE = dbo.DOCTYPES.TYPE
WHERE        (dbo.PARTPARAM.INVFLAG = 'Y') AND (dbo.ORDSTATUS.MANAGERREPOUT <> 'Y') AND (dbo.ORDERS.FORECASTFLAG <> 'S') AND 
                         (dbo.ORDERS.FORECASTFLAG <> 'F') AND (dbo.DOCTYPES.OTYPE <> 'P') AND (dbo.TRANSORDER.TYPE NOT IN ('F', 'I', 'J', 'K', 'P', 'W', 'Y', 'L')) AND 
                         (dbo.ORDERITEMS.ORD <> 0) AND (dbo.DOCUMENTS.TYPE <> 'A') AND (dbo.TRANSORDER.TQUANT <> 0) AND (dbo.MINTODATE(dbo.ORDERITEMS.DUEDATE) 
                         BETWEEN DATEADD(day, - 7000, GETDATE()) AND GETDATE()) /* change dateadd back to -14 days */