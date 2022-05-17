USE [master]
GO
/****** Object:  Database [events_db]    Script Date: 5/17/2022 9:55:22 PM ******/
CREATE DATABASE [events_db]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'events_db', FILENAME = N'E:\Interform\events\events_db.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'events_db_log', FILENAME = N'E:\Interform\events\events_db_log.LDF' , SIZE = 1088KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [events_db] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [events_db].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [events_db] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [events_db] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [events_db] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [events_db] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [events_db] SET ARITHABORT OFF 
GO
ALTER DATABASE [events_db] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [events_db] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [events_db] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [events_db] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [events_db] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [events_db] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [events_db] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [events_db] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [events_db] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [events_db] SET  ENABLE_BROKER 
GO
ALTER DATABASE [events_db] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [events_db] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [events_db] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [events_db] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [events_db] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [events_db] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [events_db] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [events_db] SET RECOVERY FULL 
GO
ALTER DATABASE [events_db] SET  MULTI_USER 
GO
ALTER DATABASE [events_db] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [events_db] SET DB_CHAINING OFF 
GO
ALTER DATABASE [events_db] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [events_db] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [events_db] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [events_db] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'events_db', N'ON'
GO
ALTER DATABASE [events_db] SET QUERY_STORE = OFF
GO
USE [events_db]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 5/17/2022 9:55:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Event]    Script Date: 5/17/2022 9:55:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Event](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](100) NOT NULL,
	[Date] [datetime2](7) NOT NULL,
	[EventDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventFile]    Script Date: 5/17/2022 9:55:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventFile](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EventId] [int] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Path] [nvarchar](max) NULL,
	[Type] [nvarchar](max) NULL,
 CONSTRAINT [PK_EventFile] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX_EventFile_EventId]    Script Date: 5/17/2022 9:55:22 PM ******/
CREATE NONCLUSTERED INDEX [IX_EventFile_EventId] ON [dbo].[EventFile]
(
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EventFile]  WITH CHECK ADD  CONSTRAINT [FK_EventFile_Event_EventId] FOREIGN KEY([EventId])
REFERENCES [dbo].[Event] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EventFile] CHECK CONSTRAINT [FK_EventFile_Event_EventId]
GO
USE [master]
GO
ALTER DATABASE [events_db] SET  READ_WRITE 
GO
