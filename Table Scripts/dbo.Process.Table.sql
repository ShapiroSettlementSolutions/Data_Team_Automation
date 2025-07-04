USE [Data_Team_Automation]
GO
/****** Object:  Table [dbo].[Process]    Script Date: 6/19/2025 7:06:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Process](
	[Process_ID] [int] IDENTITY(1,1) NOT NULL,
	[Process_Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[Stored_Procedure] [nvarchar](255) NULL,
	[IsRunning] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Process_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
