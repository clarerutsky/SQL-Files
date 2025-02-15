
CREATE TABLE [dbo].[Users](
	[userid] [int] NOT NULL,
	[username] [nvarchar](50) NOT NULL,
	[managerid] [int] NULL
) ON [PRIMARY]

GO
INSERT [dbo].[Users] ([userid], [username], [managerid]) VALUES (1, N'John', NULL)
INSERT [dbo].[Users] ([userid], [username], [managerid]) VALUES (2, N'Charles', 1)
INSERT [dbo].[Users] ([userid], [username], [managerid]) VALUES (3, N'Nicolas', 2)
INSERT [dbo].[Users] ([userid], [username], [managerid]) VALUES (4, N'Neil', 2)
INSERT [dbo].[Users] ([userid], [username], [managerid]) VALUES (5, N'Lynn', 1)
INSERT [dbo].[Users] ([userid], [username], [managerid]) VALUES (6, N'Vince', 5)
INSERT [dbo].[Users] ([userid], [username], [managerid]) VALUES (7, N'Claire', 6)


SELECT * FROM [Users]


 SELECT userId, userName, managerId FROM dbo.Users


 -- REQUIREMENT :  HOW TO REPORT LIST OF ALL MANAGERS IN THE HIERARCHY FOR A GIVEN EMPLOYEE ?
 -- EXAMPLE:  YOU WERE GIVEN USERID = 7. NOW, YOU NEED TO REPORT HIS MANAGER, MANAGER'S MANAGER AND SO ON...

 -- SOLUTION : WE USE  "RECURSIVE CTE"  :  A SPECIAL TYPE OF CTE THAT CALLS THE SAME CTE INSIDE IT.
 -- TO IMPLEMENT RECURSIVE CTE, WE NEED AN ANCHOR ELEMENT [BASE DATA, START VALUE]  & TERMINATION CHECK

WITH UserCTE AS 
	(
  SELECT userId, userName, managerId, 0 AS steps		-- ANCHOR ELEMENT
  FROM dbo.Users
  WHERE userId = 7
    
  UNION ALL			-- TO COMBINE THE RESULT, IN ORDER
  
  SELECT mgr.userId, mgr.userName, mgr.managerId, usr.steps +1 AS steps
  FROM UserCTE AS usr
  INNER JOIN dbo.Users AS mgr							-- SELF JOIN
  ON usr.managerId = mgr.userId						-- TERMINATION CHECK
	)
SELECT * FROM UserCTE;


