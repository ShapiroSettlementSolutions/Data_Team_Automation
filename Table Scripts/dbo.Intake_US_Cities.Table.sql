USE [Data_Team_Automation]
GO
/****** Object:  Table [dbo].[Intake_US_Cities]    Script Date: 6/19/2025 7:06:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Intake_US_Cities](
	[City_Id] [int] IDENTITY(1,1) NOT NULL,
	[City] [nvarchar](100) NOT NULL,
	[City_Ascii] [nvarchar](100) NOT NULL,
	[State_Id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[City_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Intake_US_Cities]  WITH CHECK ADD FOREIGN KEY([State_Id])
REFERENCES [dbo].[Intake_US_State] ([State_Id])
GO
