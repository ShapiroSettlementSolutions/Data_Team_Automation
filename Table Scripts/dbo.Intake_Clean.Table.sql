USE [Data_Team_Automation]
GO
/****** Object:  Table [dbo].[Intake_Clean]    Script Date: 6/19/2025 7:06:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Intake_Clean](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[PersonId] [int] NULL,
	[ClientId] [int] NULL,
	[AttorneyId] [int] NULL,
	[OrgId] [int] NULL,
	[CaseId] [int] NULL,
	[SSN] [nvarchar](11) NULL,
	[ITIN] [nvarchar](11) NULL,
	[DOB] [date] NULL,
	[DOD] [date] NULL,
	[Gender] [nvarchar](6) NULL,
	[Address1] [nvarchar](255) NULL,
	[Address2] [nvarchar](50) NULL,
	[City] [nvarchar](30) NULL,
	[State] [nvarchar](2) NULL,
	[Zipcode] [nvarchar](6) NULL,
	[PhoneNumber] [nvarchar](14) NULL,
	[EmailAddress] [nvarchar](255) NULL,
	[IngestionDate] [date] NULL,
	[IngestionDate2] [date] NULL,
	[IngestionDate3] [date] NULL,
	[InjuryDate] [date] NULL,
	[Surgery1] [date] NULL,
	[Surgery2] [date] NULL,
	[Surgery3] [date] NULL,
	[Surgery4] [date] NULL,
	[Surgery5] [date] NULL,
	[Surgery6] [date] NULL,
	[Surgery7] [date] NULL,
	[Surgery8] [date] NULL,
	[Surgery9] [date] NULL,
	[Surgery10] [date] NULL,
	[Surgery11] [date] NULL,
	[Surgery12] [date] NULL,
	[DescriptionOfInjury] [nvarchar](255) NULL,
	[InjuryCategory] [nvarchar](255) NULL,
	[SettlementDate] [date] NULL,
	[SettlementAmount] [decimal](10, 2) NULL,
	[AttorneyFee] [decimal](10, 2) NULL,
	[AttorneyFeePct] [decimal](10, 2) NULL,
	[ExpensesAmount] [decimal](10, 2) NULL,
	[AttorneyReferenceId] [nvarchar](50) NULL,
	[ThirdPartyId] [nvarchar](50) NULL,
	[DrugIngested] [nvarchar](255) NULL,
	[DefendantName] [nvarchar](255) NULL,
	[Prefix] [nvarchar](25) NULL,
	[MiddleName] [nvarchar](255) NULL,
	[Suffix] [nvarchar](25) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
