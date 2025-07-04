USE [Data_Team_Automation]
GO
/****** Object:  Table [dbo].[Process_Detail]    Script Date: 6/19/2025 7:06:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Process_Detail](
	[Process_Detail_ID] [int] IDENTITY(1,1) NOT NULL,
	[Process_ID] [int] NOT NULL,
	[Sub_Process_Name] [nvarchar](255) NOT NULL,
	[Start_Time] [datetime] NULL,
	[End_Time] [datetime] NULL,
	[Row_Count] [int] NULL,
	[Duration(Min)] [nvarchar](8) NULL,
PRIMARY KEY CLUSTERED 
(
	[Process_Detail_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Process_Detail]  WITH CHECK ADD FOREIGN KEY([Process_ID])
REFERENCES [dbo].[Process] ([Process_ID])
GO
