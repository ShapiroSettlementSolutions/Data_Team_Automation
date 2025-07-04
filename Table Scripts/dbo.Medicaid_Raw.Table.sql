USE [Data_Team_Automation]
GO
/****** Object:  Table [dbo].[Medicaid_Raw]    Script Date: 6/19/2025 7:06:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Medicaid_Raw](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Project] [nvarchar](100) NULL,
	[ClientId] [bigint] NULL,
	[ClientSSN] [nvarchar](20) NULL,
	[LienId] [bigint] NULL,
	[Stage] [nvarchar](100) NULL,
	[EV] [nvarchar](50) NULL,
	[Claims] [nvarchar](50) NULL,
	[McaidNumber] [nvarchar](100) NULL,
	[IdNumber] [nvarchar](100) NULL,
	[CaseNum] [nvarchar](100) NULL,
	[MCO] [nvarchar](255) NULL,
	[LienAmount] [nvarchar](50) NULL,
	[CreatedBy] [nvarchar](30) NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](30) NULL,
	[UpdatedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Medicaid_Raw] ADD  DEFAULT (suser_sname()) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Medicaid_Raw] ADD  DEFAULT (getdate()) FOR [CreatedOn]
GO
