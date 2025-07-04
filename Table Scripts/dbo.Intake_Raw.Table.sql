USE [Data_Team_Automation]
GO
/****** Object:  Table [dbo].[Intake_Raw]    Script Date: 6/19/2025 7:06:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Intake_Raw](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Prefix] [nvarchar](50) NULL,
	[FirstName] [nvarchar](255) NOT NULL,
	[MiddleName] [nvarchar](255) NULL,
	[LastName] [nvarchar](255) NOT NULL,
	[Suffix] [nvarchar](50) NULL,
	[SSN] [nvarchar](255) NULL,
	[ITIN] [nvarchar](255) NULL,
	[DOB] [date] NULL,
	[DOD] [date] NULL,
	[Gender] [nvarchar](255) NULL,
	[Address1] [nvarchar](255) NULL,
	[Address2] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[Zipcode] [nvarchar](255) NULL,
	[PhoneNumber1] [nvarchar](255) NULL,
	[PhoneNumber2] [nvarchar](255) NULL,
	[EmailAddress] [nvarchar](255) NULL,
	[IngestionDate] [nvarchar](150) NULL,
	[InjuryDate] [nvarchar](150) NULL,
	[Surgery1] [nvarchar](150) NULL,
	[DescriptionOfInjury] [nvarchar](255) NULL,
	[InjuryCategory] [nvarchar](255) NULL,
	[SettlementDate] [date] NULL,
	[SettlementAmount] [decimal](10, 2) NULL,
	[AttorneyFee] [decimal](10, 2) NULL,
	[AttorneyFeePct] [decimal](10, 2) NULL,
	[CaseExpenses] [decimal](10, 2) NULL,
	[AttorneyReferenceId] [nvarchar](50) NULL,
	[ThirdPartyId] [nvarchar](50) NULL,
	[DefendantName] [nvarchar](255) NULL,
	[DrugIngested] [nvarchar](255) NULL,
	[AttorneyId] [int] NULL,
	[OrgId] [int] NULL,
	[CaseId] [int] NULL,
	[CreatedBy] [nvarchar](20) NULL,
	[Createdon] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Intake_Raw] ADD  CONSTRAINT [DF_Intake_Raw_CreatedBy]  DEFAULT (user_name()) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Intake_Raw] ADD  CONSTRAINT [DF_Intake_Raw_CreatedOn]  DEFAULT (getdate()) FOR [Createdon]
GO
