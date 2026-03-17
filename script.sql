USE [master]
GO
/****** Object:  Database [BD_SISCO]    Script Date: 10/03/2026 15:10:22 ******/
CREATE DATABASE [BD_SISCO] ON  PRIMARY 
( NAME = N'BD_SISCO', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL.1\MSSQL\Data\BD_SISCO.mdf' , SIZE = 1605632KB , MAXSIZE = UNLIMITED, FILEGROWTH = 200%)
 LOG ON 
( NAME = N'BD_SISCO_log', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL.1\MSSQL\Data\BD_SISCO_log.ldf' , SIZE = 517184KB , MAXSIZE = 2048GB , FILEGROWTH = 200%)
GO
ALTER DATABASE [BD_SISCO] SET COMPATIBILITY_LEVEL = 90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BD_SISCO].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BD_SISCO] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BD_SISCO] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BD_SISCO] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BD_SISCO] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BD_SISCO] SET ARITHABORT OFF 
GO
ALTER DATABASE [BD_SISCO] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BD_SISCO] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BD_SISCO] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BD_SISCO] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BD_SISCO] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BD_SISCO] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BD_SISCO] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BD_SISCO] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BD_SISCO] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BD_SISCO] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BD_SISCO] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BD_SISCO] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BD_SISCO] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BD_SISCO] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [BD_SISCO] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BD_SISCO] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BD_SISCO] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BD_SISCO] SET  MULTI_USER 
GO
ALTER DATABASE [BD_SISCO] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BD_SISCO] SET DB_CHAINING OFF 
GO
USE [BD_SISCO]
GO
/****** Object:  Schema [DataSync]    Script Date: 10/03/2026 15:10:22 ******/
CREATE SCHEMA [DataSync]
GO
/****** Object:  Table [DataSync].[ADM_PERFIL_OPCIONES_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[ADM_PERFIL_OPCIONES_dss_tracking](
	[CH_CODI_SISTEMA] [char](3) NOT NULL,
	[CH_CODI_MODULO] [char](3) NOT NULL,
	[CH_CODI_OPCION] [char](2) NOT NULL,
	[CH_CODI_PERFIL] [char](3) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.ADM_PERFIL_OPCIONES_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_SISTEMA] ASC,
	[CH_CODI_MODULO] ASC,
	[CH_CODI_OPCION] ASC,
	[CH_CODI_PERFIL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[CAB_CIERRE_TURNO_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DataSync].[CAB_CIERRE_TURNO_dss_tracking](
	[NU_CODI_CIERRE] [int] NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.CAB_CIERRE_TURNO_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[NU_CODI_CIERRE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [DataSync].[CAB_COBRANZA_CREDITO_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DataSync].[CAB_COBRANZA_CREDITO_dss_tracking](
	[NU_CODI_COBR_CRED] [int] NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.CAB_COBRANZA_CREDITO_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[NU_CODI_COBR_CRED] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [DataSync].[CAB_DOCUMENTO_VENTA_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DataSync].[CAB_DOCUMENTO_VENTA_dss_tracking](
	[NU_CODI_DOCU_VENT] [int] NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.CAB_DOCUMENTO_VENTA_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[NU_CODI_DOCU_VENT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [DataSync].[CAB_RECIBO_EGRESO_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DataSync].[CAB_RECIBO_EGRESO_dss_tracking](
	[NU_CODI_RECIBO] [int] NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.CAB_RECIBO_EGRESO_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[NU_CODI_RECIBO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [DataSync].[DET_COBRANZA_CREDITO_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DataSync].[DET_COBRANZA_CREDITO_dss_tracking](
	[NU_CODI_COBR_CRED] [int] NOT NULL,
	[NU_CODI_DETALLE] [int] NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.DET_COBRANZA_CREDITO_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[NU_CODI_COBR_CRED] ASC,
	[NU_CODI_DETALLE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [DataSync].[DET_TARIFARIO_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[DET_TARIFARIO_dss_tracking](
	[CH_CODI_TARIFARIO] [char](6) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.DET_TARIFARIO_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_TARIFARIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[dtproperties_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[dtproperties_dss_tracking](
	[id] [int] NOT NULL,
	[property] [varchar](64) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.dtproperties_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[property] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_CHOFER_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_CHOFER_dss_tracking](
	[CH_CODI_CHOFER] [char](4) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_CHOFER_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_CHOFER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_CLIENTE_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_CLIENTE_dss_tracking](
	[CH_CODI_CLIENTE] [char](4) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_CLIENTE_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_CLIENTE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_CORRELATIVO_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_CORRELATIVO_dss_tracking](
	[CH_CODI_CORRELATIVO] [char](4) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_CORRELATIVO_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_CORRELATIVO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_GARITA_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_GARITA_dss_tracking](
	[CH_CODI_GARITA] [char](3) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_GARITA_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_GARITA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[mae_garita_x_usuario_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[mae_garita_x_usuario_dss_tracking](
	[ch_codi_garita] [char](3) NOT NULL,
	[ch_codi_usuario] [char](15) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.mae_garita_x_usuario_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[ch_codi_garita] ASC,
	[ch_codi_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_MODULO_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_MODULO_dss_tracking](
	[CH_CODI_SISTEMA] [char](3) NOT NULL,
	[CH_CODI_MODULO] [char](3) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_MODULO_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_SISTEMA] ASC,
	[CH_CODI_MODULO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_OPCION_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_OPCION_dss_tracking](
	[CH_CODI_SISTEMA] [char](3) NOT NULL,
	[CH_CODI_MODULO] [char](3) NOT NULL,
	[CH_CODI_OPCION] [char](2) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_OPCION_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_SISTEMA] ASC,
	[CH_CODI_MODULO] ASC,
	[CH_CODI_OPCION] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_PERFIL_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_PERFIL_dss_tracking](
	[CH_CODI_PERFIL] [char](3) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_PERFIL_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_PERFIL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_tracking](
	[CH_CODI_USUARIO] [char](20) NOT NULL,
	[CH_CODI_PERFIL] [char](3) NOT NULL,
	[CH_NUME_ASIGNA] [char](3) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_PERFIL_MAE_USUARIO_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_USUARIO] ASC,
	[CH_CODI_PERFIL] ASC,
	[CH_NUME_ASIGNA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_PROVEEDOR_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_PROVEEDOR_dss_tracking](
	[CH_CODI_PROVEEDOR] [char](4) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_PROVEEDOR_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_PROVEEDOR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_SISTEMA_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_SISTEMA_dss_tracking](
	[CH_CODI_SISTEMA] [char](3) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_SISTEMA_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_SISTEMA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_TIPO_DOCUMENTO_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_TIPO_DOCUMENTO_dss_tracking](
	[CH_CODI_TIPO_DCMNT] [char](2) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_TIPO_DOCUMENTO_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_TIPO_DCMNT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_TIPO_EGRESO_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_TIPO_EGRESO_dss_tracking](
	[CH_CODI_TIPO_EGRESO] [char](3) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_TIPO_EGRESO_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_TIPO_EGRESO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_TIPO_INCIDENTE_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_TIPO_INCIDENTE_dss_tracking](
	[CH_CODI_TIPO_INCIDENTE] [char](3) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_TIPO_INCIDENTE_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_TIPO_INCIDENTE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_TIPO_INGRESO_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_TIPO_INGRESO_dss_tracking](
	[CH_CODI_TIPO_INGRESO] [char](3) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_TIPO_INGRESO_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_TIPO_INGRESO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_TIPO_VEHICULO_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_TIPO_VEHICULO_dss_tracking](
	[CH_TIPO_VEHICULO] [char](2) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_TIPO_VEHICULO_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_TIPO_VEHICULO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_USUARIO_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_USUARIO_dss_tracking](
	[CH_CODI_USUARIO] [char](20) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_USUARIO_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_USUARIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_VARIABLE_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_VARIABLE_dss_tracking](
	[CH_CODI_VARIABLE] [char](2) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_VARIABLE_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_VARIABLE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MAE_VEHICULO_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[MAE_VEHICULO_dss_tracking](
	[CH_CODI_VEHICULO] [char](6) NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MAE_VEHICULO_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_VEHICULO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[MOV_TICKET_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DataSync].[MOV_TICKET_dss_tracking](
	[NU_CODI_TICKET] [int] NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.MOV_TICKET_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[NU_CODI_TICKET] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [DataSync].[provision_marker_dss]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DataSync].[provision_marker_dss](
	[object_id] [int] NOT NULL,
	[owner_scope_local_id] [int] NOT NULL,
	[provision_scope_local_id] [int] NULL,
	[provision_timestamp] [bigint] NOT NULL,
	[provision_local_peer_key] [int] NOT NULL,
	[provision_scope_peer_key] [int] NULL,
	[provision_scope_peer_timestamp] [bigint] NULL,
	[provision_datetime] [datetime] NULL,
	[state] [int] NULL,
	[version] [timestamp] NOT NULL,
 CONSTRAINT [PK_DataSync.provision_marker_dss] PRIMARY KEY CLUSTERED 
(
	[owner_scope_local_id] ASC,
	[object_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [DataSync].[schema_info_dss]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DataSync].[schema_info_dss](
	[schema_major_version] [int] NOT NULL,
	[schema_minor_version] [int] NOT NULL,
	[schema_extended_info] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_DataSync.schema_info_dss] PRIMARY KEY CLUSTERED 
(
	[schema_major_version] ASC,
	[schema_minor_version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [DataSync].[scope_config_dss]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[scope_config_dss](
	[config_id] [uniqueidentifier] NOT NULL,
	[config_data] [xml] NOT NULL,
	[scope_status] [char](1) NULL,
 CONSTRAINT [PK_DataSync.scope_config_dss] PRIMARY KEY CLUSTERED 
(
	[config_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[scope_info_dss]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DataSync].[scope_info_dss](
	[scope_local_id] [int] IDENTITY(1,1) NOT NULL,
	[scope_id] [uniqueidentifier] NOT NULL,
	[sync_scope_name] [nvarchar](100) NOT NULL,
	[scope_sync_knowledge] [varbinary](max) NULL,
	[scope_tombstone_cleanup_knowledge] [varbinary](max) NULL,
	[scope_timestamp] [timestamp] NULL,
	[scope_config_id] [uniqueidentifier] NULL,
	[scope_restore_count] [int] NOT NULL,
	[scope_user_comment] [nvarchar](max) NULL,
 CONSTRAINT [PK_DataSync.scope_info_dss] PRIMARY KEY CLUSTERED 
(
	[sync_scope_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [DataSync].[sysdiagrams_dss_tracking]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DataSync].[sysdiagrams_dss_tracking](
	[diagram_id] [int] NOT NULL,
	[update_scope_local_id] [int] NULL,
	[scope_update_peer_key] [int] NULL,
	[scope_update_peer_timestamp] [bigint] NULL,
	[local_update_peer_key] [int] NOT NULL,
	[local_update_peer_timestamp] [timestamp] NOT NULL,
	[create_scope_local_id] [int] NULL,
	[scope_create_peer_key] [int] NULL,
	[scope_create_peer_timestamp] [bigint] NULL,
	[local_create_peer_key] [int] NOT NULL,
	[local_create_peer_timestamp] [bigint] NOT NULL,
	[sync_row_is_tombstone] [int] NOT NULL,
	[restore_timestamp] [bigint] NULL,
	[last_change_datetime] [datetime] NULL,
 CONSTRAINT [PK_DataSync.sysdiagrams_dss_tracking] PRIMARY KEY CLUSTERED 
(
	[diagram_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ADM_PERFIL_OPCIONES]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ADM_PERFIL_OPCIONES](
	[CH_CODI_SISTEMA] [char](3) NOT NULL,
	[CH_CODI_MODULO] [char](3) NOT NULL,
	[CH_CODI_OPCION] [char](2) NOT NULL,
	[CH_CODI_PERFIL] [char](3) NOT NULL,
 CONSTRAINT [PK__ADM_PERFIL_OPCIO__2C88998B] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_SISTEMA] ASC,
	[CH_CODI_MODULO] ASC,
	[CH_CODI_OPCION] ASC,
	[CH_CODI_PERFIL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CAB_CIERRE_TURNO]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CAB_CIERRE_TURNO](
	[NU_CODI_CIERRE] [int] NOT NULL,
	[DT_FECH_TURNO] [datetime] NULL,
	[CH_CODI_TURNO_CAJA] [char](2) NULL,
	[CH_CODI_CAJERO] [char](15) NULL,
	[CH_SERI_CIERRE] [char](4) NULL,
	[CH_NUME_CIERRE] [char](10) NULL,
	[NU_IMPO_TOTA_EFECTIVO] [decimal](12, 3) NULL,
	[NU_IMPO_TOTA_CREDITO] [decimal](12, 3) NULL,
	[NU_IMPO_TOTAL] [decimal](12, 3) NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
	[CH_TIPO_CIERRE] [char](1) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
	[VC_OBSE_CIERRE] [varchar](100) NULL,
	[CH_CODI_GARITA] [char](3) NULL,
	[NU_IMPO_COBR_CRED] [decimal](12, 3) NULL,
	[NU_IMPO_TOTA_INGR] [decimal](12, 3) NULL,
	[NU_IMPO_EGRE] [decimal](12, 3) NULL,
	[NU_IMPO_UTIL_TURNO] [decimal](12, 3) NULL,
	[NU_IMPO_OTRO_INGR] [decimal](12, 3) NULL,
 CONSTRAINT [XPKCAB_CIERRE_TURNO] PRIMARY KEY NONCLUSTERED 
(
	[NU_CODI_CIERRE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CAB_COBRANZA_CREDITO]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CAB_COBRANZA_CREDITO](
	[NU_CODI_COBR_CRED] [int] NOT NULL,
	[DT_FECH_COBR] [datetime] NULL,
	[VC_OBSE_COBR] [varchar](100) NULL,
	[CH_SERI_COBR] [char](4) NULL,
	[CH_NUME_COBR] [char](10) NULL,
	[NU_IMPO_TOTAL] [decimal](12, 3) NULL,
	[CH_CODI_CLIENTE] [char](4) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
	[dt_fech_turno] [datetime] NULL,
	[ch_codi_turno_caja] [char](2) NULL,
	[ch_codi_garita] [char](3) NULL,
	[ch_codi_cajero] [char](15) NULL,
 CONSTRAINT [XPKCAB_COBRANZA_CREDITO] PRIMARY KEY NONCLUSTERED 
(
	[NU_CODI_COBR_CRED] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CAB_DOCUMENTO_VENTA]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CAB_DOCUMENTO_VENTA](
	[NU_CODI_DOCU_VENT] [int] NOT NULL,
	[DT_FECH_EMISION] [datetime] NULL,
	[NU_CODI_TICKET] [int] NULL,
	[CH_SERI_CMPRBT] [char](4) NULL,
	[CH_NUME_CMPRBT] [char](10) NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
	[CH_CODI_CLIENTE] [char](4) NULL,
	[VC_DESC_CLIENTE] [varchar](100) NULL,
	[VC_DIRE_CLIENTE] [varchar](100) NULL,
	[VC_OBSE_CMPRBT] [varchar](100) NULL,
	[ch_tipo_cmprbnt] [char](2) NULL,
	[nu_impo_total] [decimal](12, 3) NULL,
	[nu_impo_igv] [decimal](12, 3) NULL,
	[nu_impo_afecto] [decimal](12, 3) NULL,
	[ch_ruc_cliente] [char](11) NULL,
	[NU_CODI_COBR_CRED] [int] NULL,
 CONSTRAINT [XPKCAB_DOCUMENTO_VENTA] PRIMARY KEY NONCLUSTERED 
(
	[NU_CODI_DOCU_VENT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CAB_RECIBO_EGRESO]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CAB_RECIBO_EGRESO](
	[NU_CODI_RECIBO] [int] NOT NULL,
	[DT_FECH_EGRE] [datetime] NULL,
	[VC_OBSE_EGRE] [varchar](100) NULL,
	[CH_SERI_EGRE] [char](4) NULL,
	[CH_NUME_EGRE] [char](10) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
	[CH_CODI_TIPO_EGRESO] [char](3) NULL,
	[CH_CODI_PROVEEDOR] [char](4) NULL,
	[ch_codi_cajero] [char](15) NULL,
	[ch_codi_garita] [char](3) NULL,
	[ch_codi_turno_caja] [char](2) NULL,
	[dt_fech_turno] [datetime] NULL,
	[ch_codi_autoriza] [char](15) NULL,
	[nu_impo_egre] [decimal](12, 3) NULL,
 CONSTRAINT [XPKCAB_RECIBO_EGRESO] PRIMARY KEY NONCLUSTERED 
(
	[NU_CODI_RECIBO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CAB_RECIBO_INGRESO]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CAB_RECIBO_INGRESO](
	[NU_CODI_RECIBO] [int] NOT NULL,
	[DT_FECH_INGR] [datetime] NULL,
	[VC_OBSE_INGR] [varchar](100) NULL,
	[CH_SERI_INGR] [char](4) NULL,
	[CH_NUME_INGR] [char](10) NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
	[CH_CODI_CLIENTE] [char](4) NULL,
	[CH_CODI_TIPO_INGRESO] [char](3) NULL,
	[CH_CODI_CAJERO] [char](15) NULL,
	[CH_CODI_GARITA] [char](3) NULL,
	[CH_CODI_TURNO_CAJA] [char](2) NULL,
	[DT_FECH_TURNO] [datetime] NULL,
	[NU_IMPO_INGR] [numeric](12, 3) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DET_COBRANZA_CREDITO]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DET_COBRANZA_CREDITO](
	[NU_CODI_COBR_CRED] [int] NOT NULL,
	[NU_CODI_DETALLE] [int] NOT NULL,
	[NU_CODI_TICKET] [int] NULL,
	[NU_IMPO_COBR] [decimal](12, 3) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
	[ch_seri_tckt] [char](4) NULL,
	[ch_nume_tckt] [char](10) NULL,
	[ch_plac_vehiculo] [char](20) NULL,
	[ch_esta_activo] [char](1) NULL,
	[nu_impo_original] [decimal](12, 3) NULL,
 CONSTRAINT [XPKDET_COBRANZA_CREDITO] PRIMARY KEY NONCLUSTERED 
(
	[NU_CODI_COBR_CRED] ASC,
	[NU_CODI_DETALLE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DET_TARIFARIO]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DET_TARIFARIO](
	[CH_CODI_TARIFARIO] [char](6) NOT NULL,
	[VC_DESC_TARIFARIO] [varchar](50) NULL,
	[CH_TIPO_VEHICULO] [char](2) NULL,
	[CH_CODI_CLIENTE] [char](4) NULL,
	[NU_IMPO_DIA] [decimal](12, 3) NULL,
	[NU_IMPO_NOCHE] [decimal](12, 3) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
	[nu_nume_hora_tlrnc] [decimal](12, 3) NULL,
	[nu_nume_hora_frccn] [decimal](12, 3) NULL,
	[nu_impo_frccn_noche] [decimal](12, 3) NULL,
	[nu_impo_frccn_dia] [decimal](12, 3) NULL,
	[ch_tipo_cmprbnt] [char](2) NULL,
 CONSTRAINT [XPKDET_TARIFARIO] PRIMARY KEY NONCLUSTERED 
(
	[CH_CODI_TARIFARIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[dtproperties]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dtproperties](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[objectid] [int] NULL,
	[property] [varchar](64) NOT NULL,
	[value] [varchar](255) NULL,
	[uvalue] [nvarchar](255) NULL,
	[lvalue] [image] NULL,
	[version] [int] NOT NULL,
 CONSTRAINT [pk_dtproperties] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[property] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_CHOFER]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_CHOFER](
	[CH_CODI_CHOFER] [char](4) NOT NULL,
	[VC_DESC_CHOFER] [varchar](100) NULL,
	[CH_NUME_CELU] [char](20) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
	[VC_DIRE_CHOFER] [varchar](100) NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
	[ch_nume_dni] [char](15) NULL,
 CONSTRAINT [XPKMAE_CHOFER] PRIMARY KEY NONCLUSTERED 
(
	[CH_CODI_CHOFER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_CLIENTE]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_CLIENTE](
	[CH_CODI_CLIENTE] [char](4) NOT NULL,
	[CH_RUC_CLIENTE] [char](11) NULL,
	[VC_RAZO_SOCI_CLIENTE] [varchar](100) NULL,
	[VC_DIRE_CLIENTE] [varchar](100) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
	[CH_ESTA_CLIENTE_VIP] [char](1) NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
	[CH_ESTA_TARIFA_UNICA] [char](1) NULL,
	[NU_IMPO_TARIFA] [decimal](13, 3) NULL,
 CONSTRAINT [XPKMAE_CLIENTE] PRIMARY KEY NONCLUSTERED 
(
	[CH_CODI_CLIENTE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_CORRELATIVO]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_CORRELATIVO](
	[CH_CODI_CORRELATIVO] [char](4) NOT NULL,
	[CH_CODI_TIPO_DCMNT] [char](2) NULL,
	[CH_SERI_ACTUAL] [char](4) NULL,
	[CH_NUME_ACTUAL] [char](10) NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
 CONSTRAINT [XPKMAE_CORRELATIVO] PRIMARY KEY NONCLUSTERED 
(
	[CH_CODI_CORRELATIVO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_GARITA]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_GARITA](
	[CH_CODI_GARITA] [char](3) NOT NULL,
	[VC_DESC_GARITA] [varchar](50) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
 CONSTRAINT [XPKMAE_GARITA] PRIMARY KEY NONCLUSTERED 
(
	[CH_CODI_GARITA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[mae_garita_x_usuario]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mae_garita_x_usuario](
	[ch_codi_garita] [char](3) NOT NULL,
	[ch_codi_usuario] [char](15) NOT NULL,
	[ch_esta_activo] [char](1) NULL,
	[ch_codi_usua_regi] [char](15) NULL,
	[ch_codi_usua_modi] [char](15) NULL,
	[dt_fech_usua_regi] [datetime] NULL,
	[dt_fech_usua_modi] [datetime] NULL,
 CONSTRAINT [pk_garita_x_usuario] PRIMARY KEY CLUSTERED 
(
	[ch_codi_garita] ASC,
	[ch_codi_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_MODULO]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_MODULO](
	[CH_CODI_SISTEMA] [char](3) NOT NULL,
	[CH_CODI_MODULO] [char](3) NOT NULL,
	[VC_DESC_MODULO] [varchar](50) NULL,
	[CH_ESTA_MODULO] [char](1) NULL,
 CONSTRAINT [PK__MAE_MODULO__28B808A7] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_SISTEMA] ASC,
	[CH_CODI_MODULO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_OPCION]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_OPCION](
	[CH_CODI_SISTEMA] [char](3) NOT NULL,
	[CH_CODI_MODULO] [char](3) NOT NULL,
	[CH_CODI_OPCION] [char](2) NOT NULL,
	[VC_DESC_OPCION] [varchar](50) NULL,
	[VC_DESC_NOM_VENTANA] [varchar](50) NULL,
	[VC_TIPO_OPCION] [varchar](3) NULL,
	[VC_DESC_ICONO_OPCION] [varchar](50) NULL,
	[VC_DESC_RESPONSABLE] [varchar](50) NULL,
	[DT_FECH_CREACION_OPCION] [datetime] NULL,
	[DT_FECH_MOD_OPCION] [datetime] NULL,
	[CH_ESTA_PARAMETRO] [char](1) NULL,
	[CH_ESTA_OPCION] [char](1) NULL,
	[CH_DESC_NOM_CORTO] [varchar](50) NULL,
	[CH_RUTA_PROGRAMA] [char](50) NULL,
	[CH_ESTA_OPCION_INTERNET] [char](1) NULL,
	[CH_IND_ORIGINAL] [char](1) NULL,
 CONSTRAINT [PK__MAE_OPCION__2AA05119] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_SISTEMA] ASC,
	[CH_CODI_MODULO] ASC,
	[CH_CODI_OPCION] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_PERFIL]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_PERFIL](
	[CH_CODI_PERFIL] [char](3) NOT NULL,
	[VC_DESC_PERFIL] [varchar](50) NULL,
	[CH_ESTA_PERFIL] [char](1) NULL,
 CONSTRAINT [PK__MAE_PERFIL__24E777C3] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_PERFIL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_PERFIL_MAE_USUARIO]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_PERFIL_MAE_USUARIO](
	[CH_CODI_USUARIO] [char](20) NOT NULL,
	[CH_CODI_PERFIL] [char](3) NOT NULL,
	[CH_NUME_ASIGNA] [char](3) NOT NULL,
	[DT_FECH_ASIGNA] [datetime] NULL,
	[CH_CODI_USUA_ASIGNA] [char](15) NULL,
	[DT_FECH_REVOCA] [datetime] NULL,
	[CH_CODI_USUA_REVOCA] [char](15) NULL,
	[CH_ESTA_PERFIL_USUA] [char](1) NULL,
 CONSTRAINT [PK__MAE_PERFIL_MAE_U__3AD6B8E2] PRIMARY KEY NONCLUSTERED 
(
	[CH_CODI_USUARIO] ASC,
	[CH_CODI_PERFIL] ASC,
	[CH_NUME_ASIGNA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_PROVEEDOR]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_PROVEEDOR](
	[CH_CODI_PROVEEDOR] [char](4) NOT NULL,
	[VC_RAZO_SOCI_PROV] [varchar](100) NULL,
	[CH_RUC_PROV] [char](11) NULL,
	[VC_DIRE_PROV] [varchar](100) NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
 CONSTRAINT [XPKMAE_PROVEEDOR] PRIMARY KEY NONCLUSTERED 
(
	[CH_CODI_PROVEEDOR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_SISTEMA]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_SISTEMA](
	[CH_CODI_SISTEMA] [char](3) NOT NULL,
	[VC_DESL_SISTEMA] [varchar](50) NULL,
	[VC_DESC_SISTEMA] [varchar](30) NULL,
	[CH_ESTA_SISTEMA] [char](1) NULL,
	[VC_DESC_LOGO] [varchar](50) NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
 CONSTRAINT [PK__MAE_SISTEMA__26CFC035] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_SISTEMA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_TIPO_DOCUMENTO]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_TIPO_DOCUMENTO](
	[CH_CODI_TIPO_DCMNT] [char](2) NOT NULL,
	[VC_DESC_TIPO_DCMNT] [varchar](30) NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
 CONSTRAINT [XPKMAE_TIPO_DOCUMENTO] PRIMARY KEY NONCLUSTERED 
(
	[CH_CODI_TIPO_DCMNT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_TIPO_EGRESO]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_TIPO_EGRESO](
	[CH_CODI_TIPO_EGRESO] [char](3) NOT NULL,
	[VC_DESC_TIPO_EGRESO] [varchar](50) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
	[ch_esta_activo] [char](1) NULL,
 CONSTRAINT [XPKMAE_TIPO_EGRESO] PRIMARY KEY NONCLUSTERED 
(
	[CH_CODI_TIPO_EGRESO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_TIPO_INCIDENTE]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_TIPO_INCIDENTE](
	[CH_CODI_TIPO_INCIDENTE] [char](3) NOT NULL,
	[VC_DESC_TIPO_INCIDENTE] [varchar](50) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
	[ch_esta_activo] [char](1) NULL,
 CONSTRAINT [XPKMAE_TIPO_INCIDENTE] PRIMARY KEY NONCLUSTERED 
(
	[CH_CODI_TIPO_INCIDENTE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_TIPO_INGRESO]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_TIPO_INGRESO](
	[CH_CODI_TIPO_INGRESO] [char](3) NOT NULL,
	[VC_DESC_TIPO_INGRESO] [varchar](50) NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
 CONSTRAINT [XPKMAE_TIPO_INGRESO] PRIMARY KEY NONCLUSTERED 
(
	[CH_CODI_TIPO_INGRESO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_TIPO_VEHICULO]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_TIPO_VEHICULO](
	[CH_TIPO_VEHICULO] [char](2) NOT NULL,
	[VC_DESC_TIPO_VEHICULO] [varchar](50) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
 CONSTRAINT [XPKMAE_TIPO_VEHICULO] PRIMARY KEY NONCLUSTERED 
(
	[CH_TIPO_VEHICULO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_USUARIO]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_USUARIO](
	[CH_CODI_USUARIO] [char](20) NOT NULL,
	[VC_DESC_NOMB_USUARIO] [varchar](30) NULL,
	[CH_CODI_CENTRO] [char](4) NULL,
	[VC_DESC_APELL_PATERNO] [varchar](30) NULL,
	[VC_DESC_APELL_MATERNO] [varchar](30) NULL,
	[VC_DESC_EMAIL_USUARIO] [varchar](30) NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
	[VC_HOST_CONEXION] [varchar](30) NULL,
	[CH_ESTA_CONEXION] [char](1) NULL,
	[CH_PASS_USUA] [char](10) NULL,
	[CH_CODI_USUA] [char](15) NULL,
	[DT_FECH_ULTI_ACTU] [datetime] NULL,
	[CH_CODI_CTA_UPCH] [char](15) NULL,
	[CH_ESTA_PROGRAMA_TODOS] [char](1) NULL,
	[CH_ESTA_HORAS_EXTRA] [char](1) NULL,
	[ch_esta_autoriza] [char](1) NULL,
	[ch_tipo_usuario] [char](1) NULL,
	[ch_pass_usua2] [char](10) NULL,
 CONSTRAINT [PK__MAE_USUARIO__38EE7070] PRIMARY KEY NONCLUSTERED 
(
	[CH_CODI_USUARIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_VARIABLE]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_VARIABLE](
	[CH_CODI_VARIABLE] [char](2) NOT NULL,
	[VC_DESC_VARIABLE] [char](70) NULL,
	[NU_NUME_VALOR] [numeric](10, 2) NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
	[DT_FECH_ULTI_ACTU] [datetime] NULL,
	[CH_CODI_USUA] [char](15) NULL,
	[CH_VALO_VARIABLE] [char](10) NULL,
	[nu_nume_valo_desde] [numeric](10, 2) NULL,
	[nu_nume_valo_hasta] [numeric](10, 2) NULL,
	[ch_nume_valo_desde] [char](10) NULL,
	[ch_nume_valo_hasta] [char](10) NULL,
 CONSTRAINT [PK__MAE_VARIABLE__69E6AD86] PRIMARY KEY CLUSTERED 
(
	[CH_CODI_VARIABLE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAE_VEHICULO]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAE_VEHICULO](
	[CH_CODI_VEHICULO] [char](6) NOT NULL,
	[CH_PLAC_VEHICULO] [char](20) NULL,
	[CH_TIPO_VEHICULO] [char](2) NULL,
	[CH_CODI_CLIENTE] [char](4) NULL,
	[CH_CODI_CHOFER] [char](4) NULL,
	[NU_NUME_LLANTA] [int] NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
	[CH_ESTA_PARQUEADO] [char](1) NULL,
	[nu_impo_alquiler] [numeric](12, 3) NULL,
 CONSTRAINT [XPKMAE_VEHICULO] PRIMARY KEY NONCLUSTERED 
(
	[CH_CODI_VEHICULO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MOV_TICKET]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MOV_TICKET](
	[NU_CODI_TICKET] [int] NOT NULL,
	[CH_CODI_GARITA] [char](3) NULL,
	[DT_FECH_EMISION] [datetime] NULL,
	[DT_FECH_TURNO] [datetime] NULL,
	[CH_CODI_TURNO_CAJA] [char](2) NULL,
	[CH_CODI_VEHICULO] [char](6) NULL,
	[CH_CODI_CLIENTE] [char](4) NULL,
	[CH_CODI_CHOFER] [char](4) NULL,
	[DT_FECH_INGRESO] [datetime] NULL,
	[CH_NUME_TELEFONO] [char](20) NULL,
	[CH_ESTA_DUERMEN] [char](1) NULL,
	[CH_ESTA_LLAVE] [char](1) NULL,
	[VC_OBSE_TCKT_INGRESO] [varchar](100) NULL,
	[CH_CODI_CAJERO] [char](15) NULL,
	[CH_CODI_USUA_REGI] [char](15) NULL,
	[CH_CODI_USUA_MODI] [char](15) NULL,
	[DT_FECH_USUA_REGI] [datetime] NULL,
	[DT_FECH_USUA_MODI] [datetime] NULL,
	[CH_ESTA_ACTIVO] [char](1) NULL,
	[CH_TIPO_COMPROBANTE] [char](2) NULL,
	[NU_IMPO_TOTAL] [decimal](12, 3) NULL,
	[CH_ESTA_CLIENTE_VIP] [char](1) NULL,
	[DT_FECH_SALIDA] [datetime] NULL,
	[CH_CODI_TARIFARIO] [char](6) NULL,
	[NU_IMPO_DIA] [decimal](12, 3) NULL,
	[NU_IMPO_NOCHE] [decimal](12, 3) NULL,
	[NU_CANT_DIA] [decimal](12, 3) NULL,
	[NU_CANT_NOCHE] [decimal](12, 3) NULL,
	[NU_TOTA_DIA] [decimal](12, 3) NULL,
	[NU_TOTA_NOCHE] [decimal](12, 3) NULL,
	[CH_ESTA_CONDICION] [char](1) NULL,
	[CH_ESTA_CANCELADO] [char](1) NULL,
	[DT_FECH_CANCELADO] [datetime] NULL,
	[CH_OBSE_TCKT_SALIDA] [varchar](100) NULL,
	[CH_ESTA_INCIDENTE] [char](1) NULL,
	[CH_CODI_TIPO_INCIDENTE] [char](3) NULL,
	[CH_SERI_TCKT] [char](4) NULL,
	[CH_NUME_TCKT] [char](10) NULL,
	[NU_IMPO_SALDO] [decimal](12, 3) NULL,
	[NU_IMPO_SUBTOTAL] [decimal](12, 3) NULL,
	[NU_IMPO_DSCTO] [decimal](12, 3) NULL,
	[CH_CODI_USUA_DSCTO] [char](15) NULL,
	[VC_DESC_DSCTO] [varchar](100) NULL,
	[CH_ESTA_TICKET] [char](1) NULL,
	[ch_tipo_vehiculo] [char](2) NULL,
	[ch_codi_garita_sld] [char](3) NULL,
	[dt_fech_turno_sld] [datetime] NULL,
	[ch_codi_turno_sld] [char](2) NULL,
	[dt_fech_emision_sld] [datetime] NULL,
	[ch_codi_cajero_sld] [char](15) NULL,
	[ch_codi_usua_modi_sld] [char](15) NULL,
	[dt_fech_usua_modi_sld] [datetime] NULL,
	[nu_impo_dia_frccn] [decimal](12, 3) NULL,
	[nu_impo_noche_frccn] [decimal](12, 3) NULL,
	[nu_cant_dia_frccn] [decimal](12, 3) NULL,
	[nu_cant_noche_frccn] [decimal](12, 3) NULL,
	[nu_impo_paga] [decimal](12, 3) NULL,
	[nu_impo_vuelto] [decimal](12, 3) NULL,
 CONSTRAINT [XPKMOV_TICKET] PRIMARY KEY NONCLUSTERED 
(
	[NU_CODI_TICKET] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[ADM_PERFIL_OPCIONES_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_SISTEMA] ASC,
	[CH_CODI_MODULO] ASC,
	[CH_CODI_OPCION] ASC,
	[CH_CODI_PERFIL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[ADM_PERFIL_OPCIONES_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[CAB_CIERRE_TURNO_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[NU_CODI_CIERRE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[CAB_CIERRE_TURNO_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[CAB_COBRANZA_CREDITO_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[NU_CODI_COBR_CRED] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[CAB_COBRANZA_CREDITO_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[CAB_DOCUMENTO_VENTA_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[NU_CODI_DOCU_VENT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[CAB_DOCUMENTO_VENTA_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[CAB_RECIBO_EGRESO_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[NU_CODI_RECIBO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[CAB_RECIBO_EGRESO_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[DET_COBRANZA_CREDITO_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[NU_CODI_COBR_CRED] ASC,
	[NU_CODI_DETALLE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[DET_COBRANZA_CREDITO_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[DET_TARIFARIO_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_TARIFARIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[DET_TARIFARIO_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[dtproperties_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[id] ASC,
	[property] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[dtproperties_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_CHOFER_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_CHOFER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_CHOFER_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_CLIENTE_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_CLIENTE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_CLIENTE_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_CORRELATIVO_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_CORRELATIVO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_CORRELATIVO_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_GARITA_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_GARITA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_GARITA_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[mae_garita_x_usuario_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[ch_codi_garita] ASC,
	[ch_codi_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[mae_garita_x_usuario_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_MODULO_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_SISTEMA] ASC,
	[CH_CODI_MODULO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_MODULO_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_OPCION_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_SISTEMA] ASC,
	[CH_CODI_MODULO] ASC,
	[CH_CODI_OPCION] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_OPCION_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_PERFIL_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_PERFIL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_PERFIL_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_USUARIO] ASC,
	[CH_CODI_PERFIL] ASC,
	[CH_NUME_ASIGNA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_PROVEEDOR_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_PROVEEDOR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_PROVEEDOR_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_SISTEMA_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_SISTEMA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_SISTEMA_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_TIPO_DOCUMENTO_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_TIPO_DCMNT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_TIPO_DOCUMENTO_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_TIPO_EGRESO_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_TIPO_EGRESO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_TIPO_EGRESO_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_TIPO_INCIDENTE_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_TIPO_INCIDENTE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_TIPO_INCIDENTE_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_TIPO_INGRESO_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_TIPO_INGRESO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_TIPO_INGRESO_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_TIPO_VEHICULO_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_TIPO_VEHICULO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_TIPO_VEHICULO_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_USUARIO_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_USUARIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_USUARIO_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_VARIABLE_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_VARIABLE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_VARIABLE_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MAE_VEHICULO_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[CH_CODI_VEHICULO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MAE_VEHICULO_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[MOV_TICKET_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[NU_CODI_TICKET] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[MOV_TICKET_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [local_update_peer_timestamp_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index] ON [DataSync].[sysdiagrams_dss_tracking]
(
	[local_update_peer_timestamp] ASC,
	[diagram_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [tombstone_index]    Script Date: 10/03/2026 15:10:22 ******/
CREATE NONCLUSTERED INDEX [tombstone_index] ON [DataSync].[sysdiagrams_dss_tracking]
(
	[sync_row_is_tombstone] ASC,
	[local_update_peer_timestamp] ASC
)
INCLUDE ( 	[last_change_datetime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [DataSync].[scope_info_dss] ADD  DEFAULT (newid()) FOR [scope_id]
GO
ALTER TABLE [DataSync].[scope_info_dss] ADD  DEFAULT ((0)) FOR [scope_restore_count]
GO
ALTER TABLE [dbo].[dtproperties] ADD  CONSTRAINT [DF__dtpropert__versi__117F9D94]  DEFAULT ((0)) FOR [version]
GO
ALTER TABLE [dbo].[ADM_PERFIL_OPCIONES]  WITH CHECK ADD  CONSTRAINT [FK__ADM_PERFI__CH_CO__3DB3258D] FOREIGN KEY([CH_CODI_PERFIL])
REFERENCES [dbo].[MAE_PERFIL] ([CH_CODI_PERFIL])
GO
ALTER TABLE [dbo].[ADM_PERFIL_OPCIONES] CHECK CONSTRAINT [FK__ADM_PERFI__CH_CO__3DB3258D]
GO
ALTER TABLE [dbo].[ADM_PERFIL_OPCIONES]  WITH CHECK ADD  CONSTRAINT [FK__ADM_PERFIL_OPCIO__3EA749C6] FOREIGN KEY([CH_CODI_SISTEMA], [CH_CODI_MODULO], [CH_CODI_OPCION])
REFERENCES [dbo].[MAE_OPCION] ([CH_CODI_SISTEMA], [CH_CODI_MODULO], [CH_CODI_OPCION])
GO
ALTER TABLE [dbo].[ADM_PERFIL_OPCIONES] CHECK CONSTRAINT [FK__ADM_PERFIL_OPCIO__3EA749C6]
GO
ALTER TABLE [dbo].[CAB_COBRANZA_CREDITO]  WITH CHECK ADD  CONSTRAINT [R_16] FOREIGN KEY([CH_CODI_CLIENTE])
REFERENCES [dbo].[MAE_CLIENTE] ([CH_CODI_CLIENTE])
GO
ALTER TABLE [dbo].[CAB_COBRANZA_CREDITO] CHECK CONSTRAINT [R_16]
GO
ALTER TABLE [dbo].[CAB_DOCUMENTO_VENTA]  WITH CHECK ADD  CONSTRAINT [R_12] FOREIGN KEY([NU_CODI_TICKET])
REFERENCES [dbo].[MOV_TICKET] ([NU_CODI_TICKET])
GO
ALTER TABLE [dbo].[CAB_DOCUMENTO_VENTA] CHECK CONSTRAINT [R_12]
GO
ALTER TABLE [dbo].[CAB_DOCUMENTO_VENTA]  WITH CHECK ADD  CONSTRAINT [R_15] FOREIGN KEY([CH_CODI_CLIENTE])
REFERENCES [dbo].[MAE_CLIENTE] ([CH_CODI_CLIENTE])
GO
ALTER TABLE [dbo].[CAB_DOCUMENTO_VENTA] CHECK CONSTRAINT [R_15]
GO
ALTER TABLE [dbo].[CAB_RECIBO_EGRESO]  WITH CHECK ADD  CONSTRAINT [R_19] FOREIGN KEY([CH_CODI_TIPO_EGRESO])
REFERENCES [dbo].[MAE_TIPO_EGRESO] ([CH_CODI_TIPO_EGRESO])
GO
ALTER TABLE [dbo].[CAB_RECIBO_EGRESO] CHECK CONSTRAINT [R_19]
GO
ALTER TABLE [dbo].[CAB_RECIBO_EGRESO]  WITH CHECK ADD  CONSTRAINT [R_20] FOREIGN KEY([CH_CODI_PROVEEDOR])
REFERENCES [dbo].[MAE_PROVEEDOR] ([CH_CODI_PROVEEDOR])
GO
ALTER TABLE [dbo].[CAB_RECIBO_EGRESO] CHECK CONSTRAINT [R_20]
GO
ALTER TABLE [dbo].[DET_COBRANZA_CREDITO]  WITH CHECK ADD  CONSTRAINT [R_17] FOREIGN KEY([NU_CODI_COBR_CRED])
REFERENCES [dbo].[CAB_COBRANZA_CREDITO] ([NU_CODI_COBR_CRED])
GO
ALTER TABLE [dbo].[DET_COBRANZA_CREDITO] CHECK CONSTRAINT [R_17]
GO
ALTER TABLE [dbo].[DET_COBRANZA_CREDITO]  WITH CHECK ADD  CONSTRAINT [R_18] FOREIGN KEY([NU_CODI_TICKET])
REFERENCES [dbo].[MOV_TICKET] ([NU_CODI_TICKET])
GO
ALTER TABLE [dbo].[DET_COBRANZA_CREDITO] CHECK CONSTRAINT [R_18]
GO
ALTER TABLE [dbo].[DET_TARIFARIO]  WITH CHECK ADD  CONSTRAINT [R_8] FOREIGN KEY([CH_TIPO_VEHICULO])
REFERENCES [dbo].[MAE_TIPO_VEHICULO] ([CH_TIPO_VEHICULO])
GO
ALTER TABLE [dbo].[DET_TARIFARIO] CHECK CONSTRAINT [R_8]
GO
ALTER TABLE [dbo].[DET_TARIFARIO]  WITH CHECK ADD  CONSTRAINT [R_9] FOREIGN KEY([CH_CODI_CLIENTE])
REFERENCES [dbo].[MAE_CLIENTE] ([CH_CODI_CLIENTE])
GO
ALTER TABLE [dbo].[DET_TARIFARIO] CHECK CONSTRAINT [R_9]
GO
ALTER TABLE [dbo].[MAE_CORRELATIVO]  WITH CHECK ADD  CONSTRAINT [R_13] FOREIGN KEY([CH_CODI_TIPO_DCMNT])
REFERENCES [dbo].[MAE_TIPO_DOCUMENTO] ([CH_CODI_TIPO_DCMNT])
GO
ALTER TABLE [dbo].[MAE_CORRELATIVO] CHECK CONSTRAINT [R_13]
GO
ALTER TABLE [dbo].[MAE_MODULO]  WITH CHECK ADD  CONSTRAINT [FK__MAE_MODUL__CH_CO__3BCADD1B] FOREIGN KEY([CH_CODI_SISTEMA])
REFERENCES [dbo].[MAE_SISTEMA] ([CH_CODI_SISTEMA])
GO
ALTER TABLE [dbo].[MAE_MODULO] CHECK CONSTRAINT [FK__MAE_MODUL__CH_CO__3BCADD1B]
GO
ALTER TABLE [dbo].[MAE_OPCION]  WITH CHECK ADD  CONSTRAINT [FK__MAE_OPCION__3CBF0154] FOREIGN KEY([CH_CODI_SISTEMA], [CH_CODI_MODULO])
REFERENCES [dbo].[MAE_MODULO] ([CH_CODI_SISTEMA], [CH_CODI_MODULO])
GO
ALTER TABLE [dbo].[MAE_OPCION] CHECK CONSTRAINT [FK__MAE_OPCION__3CBF0154]
GO
ALTER TABLE [dbo].[MAE_PERFIL_MAE_USUARIO]  WITH CHECK ADD  CONSTRAINT [FK__MAE_PERFI__CH_CO__436BFEE3] FOREIGN KEY([CH_CODI_PERFIL])
REFERENCES [dbo].[MAE_PERFIL] ([CH_CODI_PERFIL])
GO
ALTER TABLE [dbo].[MAE_PERFIL_MAE_USUARIO] CHECK CONSTRAINT [FK__MAE_PERFI__CH_CO__436BFEE3]
GO
ALTER TABLE [dbo].[MAE_PERFIL_MAE_USUARIO]  WITH CHECK ADD  CONSTRAINT [FK__MAE_PERFI__CH_CO__4460231C] FOREIGN KEY([CH_CODI_USUARIO])
REFERENCES [dbo].[MAE_USUARIO] ([CH_CODI_USUARIO])
GO
ALTER TABLE [dbo].[MAE_PERFIL_MAE_USUARIO] CHECK CONSTRAINT [FK__MAE_PERFI__CH_CO__4460231C]
GO
ALTER TABLE [dbo].[MAE_VEHICULO]  WITH CHECK ADD  CONSTRAINT [R_1] FOREIGN KEY([CH_TIPO_VEHICULO])
REFERENCES [dbo].[MAE_TIPO_VEHICULO] ([CH_TIPO_VEHICULO])
GO
ALTER TABLE [dbo].[MAE_VEHICULO] CHECK CONSTRAINT [R_1]
GO
ALTER TABLE [dbo].[MAE_VEHICULO]  WITH CHECK ADD  CONSTRAINT [R_2] FOREIGN KEY([CH_CODI_CLIENTE])
REFERENCES [dbo].[MAE_CLIENTE] ([CH_CODI_CLIENTE])
GO
ALTER TABLE [dbo].[MAE_VEHICULO] CHECK CONSTRAINT [R_2]
GO
ALTER TABLE [dbo].[MAE_VEHICULO]  WITH CHECK ADD  CONSTRAINT [R_3] FOREIGN KEY([CH_CODI_CHOFER])
REFERENCES [dbo].[MAE_CHOFER] ([CH_CODI_CHOFER])
GO
ALTER TABLE [dbo].[MAE_VEHICULO] CHECK CONSTRAINT [R_3]
GO
ALTER TABLE [dbo].[MOV_TICKET]  WITH CHECK ADD  CONSTRAINT [R_10] FOREIGN KEY([CH_CODI_TARIFARIO])
REFERENCES [dbo].[DET_TARIFARIO] ([CH_CODI_TARIFARIO])
GO
ALTER TABLE [dbo].[MOV_TICKET] CHECK CONSTRAINT [R_10]
GO
ALTER TABLE [dbo].[MOV_TICKET]  WITH CHECK ADD  CONSTRAINT [R_11] FOREIGN KEY([CH_CODI_TIPO_INCIDENTE])
REFERENCES [dbo].[MAE_TIPO_INCIDENTE] ([CH_CODI_TIPO_INCIDENTE])
GO
ALTER TABLE [dbo].[MOV_TICKET] CHECK CONSTRAINT [R_11]
GO
ALTER TABLE [dbo].[MOV_TICKET]  WITH CHECK ADD  CONSTRAINT [R_4] FOREIGN KEY([CH_CODI_GARITA])
REFERENCES [dbo].[MAE_GARITA] ([CH_CODI_GARITA])
GO
ALTER TABLE [dbo].[MOV_TICKET] CHECK CONSTRAINT [R_4]
GO
ALTER TABLE [dbo].[MOV_TICKET]  WITH CHECK ADD  CONSTRAINT [R_5] FOREIGN KEY([CH_CODI_VEHICULO])
REFERENCES [dbo].[MAE_VEHICULO] ([CH_CODI_VEHICULO])
GO
ALTER TABLE [dbo].[MOV_TICKET] CHECK CONSTRAINT [R_5]
GO
ALTER TABLE [dbo].[MOV_TICKET]  WITH CHECK ADD  CONSTRAINT [R_6] FOREIGN KEY([CH_CODI_CLIENTE])
REFERENCES [dbo].[MAE_CLIENTE] ([CH_CODI_CLIENTE])
GO
ALTER TABLE [dbo].[MOV_TICKET] CHECK CONSTRAINT [R_6]
GO
ALTER TABLE [dbo].[MOV_TICKET]  WITH CHECK ADD  CONSTRAINT [R_7] FOREIGN KEY([CH_CODI_CHOFER])
REFERENCES [dbo].[MAE_CHOFER] ([CH_CODI_CHOFER])
GO
ALTER TABLE [dbo].[MOV_TICKET] CHECK CONSTRAINT [R_7]
GO
/****** Object:  StoredProcedure [DataSync].[ADM_PERFIL_OPCIONES_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[ADM_PERFIL_OPCIONES_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 Char(3),
	@P_3 Char(2),
	@P_4 Char(3),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[ADM_PERFIL_OPCIONES] FROM [dbo].[ADM_PERFIL_OPCIONES] [base] JOIN [DataSync].[ADM_PERFIL_OPCIONES_dss_tracking] [side] ON [base].[CH_CODI_SISTEMA] = [side].[CH_CODI_SISTEMA] AND [base].[CH_CODI_MODULO] = [side].[CH_CODI_MODULO] AND [base].[CH_CODI_OPCION] = [side].[CH_CODI_OPCION] AND [base].[CH_CODI_PERFIL] = [side].[CH_CODI_PERFIL] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_SISTEMA] = @P_1 AND [base].[CH_CODI_MODULO] = @P_2 AND [base].[CH_CODI_OPCION] = @P_3 AND [base].[CH_CODI_PERFIL] = @P_4); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[ADM_PERFIL_OPCIONES_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[ADM_PERFIL_OPCIONES_dss_deletemetadata]
	@P_1 Char(3),
	@P_2 Char(3),
	@P_3 Char(2),
	@P_4 Char(3),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[ADM_PERFIL_OPCIONES_dss_tracking] [side] WHERE [CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2 AND [CH_CODI_OPCION] = @P_3 AND [CH_CODI_PERFIL] = @P_4 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[ADM_PERFIL_OPCIONES_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[ADM_PERFIL_OPCIONES_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 Char(3),
	@P_3 Char(2),
	@P_4 Char(3),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[ADM_PERFIL_OPCIONES_dss_tracking] WHERE [CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2 AND [CH_CODI_OPCION] = @P_3 AND [CH_CODI_PERFIL] = @P_4)
BEGIN 
INSERT INTO [dbo].[ADM_PERFIL_OPCIONES]([CH_CODI_SISTEMA], [CH_CODI_MODULO], [CH_CODI_OPCION], [CH_CODI_PERFIL]) VALUES (@P_1, @P_2, @P_3, @P_4);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[ADM_PERFIL_OPCIONES_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[ADM_PERFIL_OPCIONES_dss_insertmetadata]
	@P_1 Char(3),
	@P_2 Char(3),
	@P_3 Char(2),
	@P_4 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[ADM_PERFIL_OPCIONES_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2 AND [CH_CODI_OPCION] = @P_3 AND [CH_CODI_PERFIL] = @P_4) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[ADM_PERFIL_OPCIONES_dss_tracking] ([CH_CODI_SISTEMA], [CH_CODI_MODULO], [CH_CODI_OPCION], [CH_CODI_PERFIL], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @P_2, @P_3, @P_4, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[ADM_PERFIL_OPCIONES_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[ADM_PERFIL_OPCIONES_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_SISTEMA], [side].[CH_CODI_MODULO], [side].[CH_CODI_OPCION], [side].[CH_CODI_PERFIL], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[ADM_PERFIL_OPCIONES] [base] RIGHT JOIN [DataSync].[ADM_PERFIL_OPCIONES_dss_tracking] [side] ON [base].[CH_CODI_SISTEMA] = [side].[CH_CODI_SISTEMA] AND [base].[CH_CODI_MODULO] = [side].[CH_CODI_MODULO] AND [base].[CH_CODI_OPCION] = [side].[CH_CODI_OPCION] AND [base].[CH_CODI_PERFIL] = [side].[CH_CODI_PERFIL]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[ADM_PERFIL_OPCIONES_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[ADM_PERFIL_OPCIONES_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 Char(3),
	@P_3 Char(2),
	@P_4 Char(3),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_SISTEMA], [side].[CH_CODI_MODULO], [side].[CH_CODI_OPCION], [side].[CH_CODI_PERFIL], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[ADM_PERFIL_OPCIONES] [base] RIGHT JOIN [DataSync].[ADM_PERFIL_OPCIONES_dss_tracking] [side] ON [base].[CH_CODI_SISTEMA] = [side].[CH_CODI_SISTEMA] AND [base].[CH_CODI_MODULO] = [side].[CH_CODI_MODULO] AND [base].[CH_CODI_OPCION] = [side].[CH_CODI_OPCION] AND [base].[CH_CODI_PERFIL] = [side].[CH_CODI_PERFIL] WHERE [side].[CH_CODI_SISTEMA]  = @P_1 AND [side].[CH_CODI_MODULO]  = @P_2 AND [side].[CH_CODI_OPCION]  = @P_3 AND [side].[CH_CODI_PERFIL]  = @P_4
END
GO
/****** Object:  StoredProcedure [DataSync].[ADM_PERFIL_OPCIONES_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[ADM_PERFIL_OPCIONES_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 Char(3),
	@P_3 Char(2),
	@P_4 Char(3),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SELECT @sync_row_count = COUNT(*)
 FROM [dbo].[ADM_PERFIL_OPCIONES] [base] JOIN [DataSync].[ADM_PERFIL_OPCIONES_dss_tracking] [side] ON [base].[CH_CODI_SISTEMA] = [side].[CH_CODI_SISTEMA] AND [base].[CH_CODI_MODULO] = [side].[CH_CODI_MODULO] AND [base].[CH_CODI_OPCION] = [side].[CH_CODI_OPCION] AND [base].[CH_CODI_PERFIL] = [side].[CH_CODI_PERFIL]
 WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_SISTEMA] = @P_1 AND [base].[CH_CODI_MODULO] = @P_2 AND [base].[CH_CODI_OPCION] = @P_3 AND [base].[CH_CODI_PERFIL] = @P_4)


END
GO
/****** Object:  StoredProcedure [DataSync].[ADM_PERFIL_OPCIONES_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[ADM_PERFIL_OPCIONES_dss_updatemetadata]
	@P_1 Char(3),
	@P_2 Char(3),
	@P_3 Char(2),
	@P_4 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[ADM_PERFIL_OPCIONES_dss_tracking] WHERE ([CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2 AND [CH_CODI_OPCION] = @P_3 AND [CH_CODI_PERFIL] = @P_4);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[ADM_PERFIL_OPCIONES_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2 AND [CH_CODI_OPCION] = @P_3 AND [CH_CODI_PERFIL] = @P_4) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[ADM_PERFIL_OPCIONES_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2 AND [CH_CODI_OPCION] = @P_3 AND [CH_CODI_PERFIL] = @P_4) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_CIERRE_TURNO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_CIERRE_TURNO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[CAB_CIERRE_TURNO] FROM [dbo].[CAB_CIERRE_TURNO] [base] JOIN [DataSync].[CAB_CIERRE_TURNO_dss_tracking] [side] ON [base].[NU_CODI_CIERRE] = [side].[NU_CODI_CIERRE] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[NU_CODI_CIERRE] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_CIERRE_TURNO_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_CIERRE_TURNO_dss_deletemetadata]
	@P_1 Int,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[CAB_CIERRE_TURNO_dss_tracking] [side] WHERE [NU_CODI_CIERRE] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_CIERRE_TURNO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_CIERRE_TURNO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 DateTime,
	@P_3 Char(2),
	@P_4 Char(15),
	@P_5 Char(4),
	@P_6 Char(10),
	@P_7 Decimal(12,3),
	@P_8 Decimal(12,3),
	@P_9 Decimal(12,3),
	@P_10 Char(1),
	@P_11 Char(1),
	@P_12 Char(15),
	@P_13 Char(15),
	@P_14 DateTime,
	@P_15 DateTime,
	@P_16 VarChar(100),
	@P_17 Char(3),
	@P_18 Decimal(12,3),
	@P_19 Decimal(12,3),
	@P_20 Decimal(12,3),
	@P_21 Decimal(12,3),
	@P_22 Decimal(12,3),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[CAB_CIERRE_TURNO_dss_tracking] WHERE [NU_CODI_CIERRE] = @P_1)
BEGIN 
INSERT INTO [dbo].[CAB_CIERRE_TURNO]([NU_CODI_CIERRE], [DT_FECH_TURNO], [CH_CODI_TURNO_CAJA], [CH_CODI_CAJERO], [CH_SERI_CIERRE], [CH_NUME_CIERRE], [NU_IMPO_TOTA_EFECTIVO], [NU_IMPO_TOTA_CREDITO], [NU_IMPO_TOTAL], [CH_ESTA_ACTIVO], [CH_TIPO_CIERRE], [CH_CODI_USUA_REGI], [CH_CODI_USUA_MODI], [DT_FECH_USUA_REGI], [DT_FECH_USUA_MODI], [VC_OBSE_CIERRE], [CH_CODI_GARITA], [NU_IMPO_COBR_CRED], [NU_IMPO_TOTA_INGR], [NU_IMPO_EGRE], [NU_IMPO_UTIL_TURNO], [NU_IMPO_OTRO_INGR]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11, @P_12, @P_13, @P_14, @P_15, @P_16, @P_17, @P_18, @P_19, @P_20, @P_21, @P_22);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_CIERRE_TURNO_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_CIERRE_TURNO_dss_insertmetadata]
	@P_1 Int,
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[CAB_CIERRE_TURNO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_CIERRE] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[CAB_CIERRE_TURNO_dss_tracking] ([NU_CODI_CIERRE], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_CIERRE_TURNO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_CIERRE_TURNO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[NU_CODI_CIERRE], [base].[DT_FECH_TURNO], [base].[CH_CODI_TURNO_CAJA], [base].[CH_CODI_CAJERO], [base].[CH_SERI_CIERRE], [base].[CH_NUME_CIERRE], [base].[NU_IMPO_TOTA_EFECTIVO], [base].[NU_IMPO_TOTA_CREDITO], [base].[NU_IMPO_TOTAL], [base].[CH_ESTA_ACTIVO], [base].[CH_TIPO_CIERRE], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[VC_OBSE_CIERRE], [base].[CH_CODI_GARITA], [base].[NU_IMPO_COBR_CRED], [base].[NU_IMPO_TOTA_INGR], [base].[NU_IMPO_EGRE], [base].[NU_IMPO_UTIL_TURNO], [base].[NU_IMPO_OTRO_INGR], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[CAB_CIERRE_TURNO] [base] RIGHT JOIN [DataSync].[CAB_CIERRE_TURNO_dss_tracking] [side] ON [base].[NU_CODI_CIERRE] = [side].[NU_CODI_CIERRE]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_CIERRE_TURNO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_CIERRE_TURNO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[NU_CODI_CIERRE], [base].[DT_FECH_TURNO], [base].[CH_CODI_TURNO_CAJA], [base].[CH_CODI_CAJERO], [base].[CH_SERI_CIERRE], [base].[CH_NUME_CIERRE], [base].[NU_IMPO_TOTA_EFECTIVO], [base].[NU_IMPO_TOTA_CREDITO], [base].[NU_IMPO_TOTAL], [base].[CH_ESTA_ACTIVO], [base].[CH_TIPO_CIERRE], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[VC_OBSE_CIERRE], [base].[CH_CODI_GARITA], [base].[NU_IMPO_COBR_CRED], [base].[NU_IMPO_TOTA_INGR], [base].[NU_IMPO_EGRE], [base].[NU_IMPO_UTIL_TURNO], [base].[NU_IMPO_OTRO_INGR], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[CAB_CIERRE_TURNO] [base] RIGHT JOIN [DataSync].[CAB_CIERRE_TURNO_dss_tracking] [side] ON [base].[NU_CODI_CIERRE] = [side].[NU_CODI_CIERRE] WHERE [side].[NU_CODI_CIERRE]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_CIERRE_TURNO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_CIERRE_TURNO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 DateTime,
	@P_3 Char(2),
	@P_4 Char(15),
	@P_5 Char(4),
	@P_6 Char(10),
	@P_7 Decimal(12,3),
	@P_8 Decimal(12,3),
	@P_9 Decimal(12,3),
	@P_10 Char(1),
	@P_11 Char(1),
	@P_12 Char(15),
	@P_13 Char(15),
	@P_14 DateTime,
	@P_15 DateTime,
	@P_16 VarChar(100),
	@P_17 Char(3),
	@P_18 Decimal(12,3),
	@P_19 Decimal(12,3),
	@P_20 Decimal(12,3),
	@P_21 Decimal(12,3),
	@P_22 Decimal(12,3),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[CAB_CIERRE_TURNO] SET [DT_FECH_TURNO] = @P_2, [CH_CODI_TURNO_CAJA] = @P_3, [CH_CODI_CAJERO] = @P_4, [CH_SERI_CIERRE] = @P_5, [CH_NUME_CIERRE] = @P_6, [NU_IMPO_TOTA_EFECTIVO] = @P_7, [NU_IMPO_TOTA_CREDITO] = @P_8, [NU_IMPO_TOTAL] = @P_9, [CH_ESTA_ACTIVO] = @P_10, [CH_TIPO_CIERRE] = @P_11, [CH_CODI_USUA_REGI] = @P_12, [CH_CODI_USUA_MODI] = @P_13, [DT_FECH_USUA_REGI] = @P_14, [DT_FECH_USUA_MODI] = @P_15, [VC_OBSE_CIERRE] = @P_16, [CH_CODI_GARITA] = @P_17, [NU_IMPO_COBR_CRED] = @P_18, [NU_IMPO_TOTA_INGR] = @P_19, [NU_IMPO_EGRE] = @P_20, [NU_IMPO_UTIL_TURNO] = @P_21, [NU_IMPO_OTRO_INGR] = @P_22 FROM [dbo].[CAB_CIERRE_TURNO] [base] JOIN [DataSync].[CAB_CIERRE_TURNO_dss_tracking] [side] ON [base].[NU_CODI_CIERRE] = [side].[NU_CODI_CIERRE] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[NU_CODI_CIERRE] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_CIERRE_TURNO_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_CIERRE_TURNO_dss_updatemetadata]
	@P_1 Int,
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[CAB_CIERRE_TURNO_dss_tracking] WHERE ([NU_CODI_CIERRE] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[CAB_CIERRE_TURNO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_CIERRE] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[CAB_CIERRE_TURNO_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_CIERRE] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_COBRANZA_CREDITO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_COBRANZA_CREDITO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[CAB_COBRANZA_CREDITO] FROM [dbo].[CAB_COBRANZA_CREDITO] [base] JOIN [DataSync].[CAB_COBRANZA_CREDITO_dss_tracking] [side] ON [base].[NU_CODI_COBR_CRED] = [side].[NU_CODI_COBR_CRED] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[NU_CODI_COBR_CRED] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_COBRANZA_CREDITO_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_COBRANZA_CREDITO_dss_deletemetadata]
	@P_1 Int,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[CAB_COBRANZA_CREDITO_dss_tracking] [side] WHERE [NU_CODI_COBR_CRED] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_COBRANZA_CREDITO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_COBRANZA_CREDITO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 DateTime,
	@P_3 VarChar(100),
	@P_4 Char(4),
	@P_5 Char(10),
	@P_6 Decimal(12,3),
	@P_7 Char(4),
	@P_8 Char(15),
	@P_9 Char(15),
	@P_10 DateTime,
	@P_11 DateTime,
	@P_12 Char(1),
	@P_13 DateTime,
	@P_14 Char(2),
	@P_15 Char(3),
	@P_16 Char(15),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[CAB_COBRANZA_CREDITO_dss_tracking] WHERE [NU_CODI_COBR_CRED] = @P_1)
BEGIN 
INSERT INTO [dbo].[CAB_COBRANZA_CREDITO]([NU_CODI_COBR_CRED], [DT_FECH_COBR], [VC_OBSE_COBR], [CH_SERI_COBR], [CH_NUME_COBR], [NU_IMPO_TOTAL], [CH_CODI_CLIENTE], [CH_CODI_USUA_REGI], [CH_CODI_USUA_MODI], [DT_FECH_USUA_REGI], [DT_FECH_USUA_MODI], [CH_ESTA_ACTIVO], [dt_fech_turno], [ch_codi_turno_caja], [ch_codi_garita], [ch_codi_cajero]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11, @P_12, @P_13, @P_14, @P_15, @P_16);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_COBRANZA_CREDITO_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_COBRANZA_CREDITO_dss_insertmetadata]
	@P_1 Int,
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[CAB_COBRANZA_CREDITO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_COBR_CRED] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[CAB_COBRANZA_CREDITO_dss_tracking] ([NU_CODI_COBR_CRED], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_COBRANZA_CREDITO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_COBRANZA_CREDITO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[NU_CODI_COBR_CRED], [base].[DT_FECH_COBR], [base].[VC_OBSE_COBR], [base].[CH_SERI_COBR], [base].[CH_NUME_COBR], [base].[NU_IMPO_TOTAL], [base].[CH_CODI_CLIENTE], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_ESTA_ACTIVO], [base].[dt_fech_turno], [base].[ch_codi_turno_caja], [base].[ch_codi_garita], [base].[ch_codi_cajero], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[CAB_COBRANZA_CREDITO] [base] RIGHT JOIN [DataSync].[CAB_COBRANZA_CREDITO_dss_tracking] [side] ON [base].[NU_CODI_COBR_CRED] = [side].[NU_CODI_COBR_CRED]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_COBRANZA_CREDITO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_COBRANZA_CREDITO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[NU_CODI_COBR_CRED], [base].[DT_FECH_COBR], [base].[VC_OBSE_COBR], [base].[CH_SERI_COBR], [base].[CH_NUME_COBR], [base].[NU_IMPO_TOTAL], [base].[CH_CODI_CLIENTE], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_ESTA_ACTIVO], [base].[dt_fech_turno], [base].[ch_codi_turno_caja], [base].[ch_codi_garita], [base].[ch_codi_cajero], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[CAB_COBRANZA_CREDITO] [base] RIGHT JOIN [DataSync].[CAB_COBRANZA_CREDITO_dss_tracking] [side] ON [base].[NU_CODI_COBR_CRED] = [side].[NU_CODI_COBR_CRED] WHERE [side].[NU_CODI_COBR_CRED]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_COBRANZA_CREDITO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_COBRANZA_CREDITO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 DateTime,
	@P_3 VarChar(100),
	@P_4 Char(4),
	@P_5 Char(10),
	@P_6 Decimal(12,3),
	@P_7 Char(4),
	@P_8 Char(15),
	@P_9 Char(15),
	@P_10 DateTime,
	@P_11 DateTime,
	@P_12 Char(1),
	@P_13 DateTime,
	@P_14 Char(2),
	@P_15 Char(3),
	@P_16 Char(15),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[CAB_COBRANZA_CREDITO] SET [DT_FECH_COBR] = @P_2, [VC_OBSE_COBR] = @P_3, [CH_SERI_COBR] = @P_4, [CH_NUME_COBR] = @P_5, [NU_IMPO_TOTAL] = @P_6, [CH_CODI_CLIENTE] = @P_7, [CH_CODI_USUA_REGI] = @P_8, [CH_CODI_USUA_MODI] = @P_9, [DT_FECH_USUA_REGI] = @P_10, [DT_FECH_USUA_MODI] = @P_11, [CH_ESTA_ACTIVO] = @P_12, [dt_fech_turno] = @P_13, [ch_codi_turno_caja] = @P_14, [ch_codi_garita] = @P_15, [ch_codi_cajero] = @P_16 FROM [dbo].[CAB_COBRANZA_CREDITO] [base] JOIN [DataSync].[CAB_COBRANZA_CREDITO_dss_tracking] [side] ON [base].[NU_CODI_COBR_CRED] = [side].[NU_CODI_COBR_CRED] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[NU_CODI_COBR_CRED] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_COBRANZA_CREDITO_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_COBRANZA_CREDITO_dss_updatemetadata]
	@P_1 Int,
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[CAB_COBRANZA_CREDITO_dss_tracking] WHERE ([NU_CODI_COBR_CRED] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[CAB_COBRANZA_CREDITO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_COBR_CRED] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[CAB_COBRANZA_CREDITO_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_COBR_CRED] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_DOCUMENTO_VENTA_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_DOCUMENTO_VENTA_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[CAB_DOCUMENTO_VENTA] FROM [dbo].[CAB_DOCUMENTO_VENTA] [base] JOIN [DataSync].[CAB_DOCUMENTO_VENTA_dss_tracking] [side] ON [base].[NU_CODI_DOCU_VENT] = [side].[NU_CODI_DOCU_VENT] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[NU_CODI_DOCU_VENT] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_DOCUMENTO_VENTA_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_DOCUMENTO_VENTA_dss_deletemetadata]
	@P_1 Int,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[CAB_DOCUMENTO_VENTA_dss_tracking] [side] WHERE [NU_CODI_DOCU_VENT] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_DOCUMENTO_VENTA_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_DOCUMENTO_VENTA_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 DateTime,
	@P_3 Int,
	@P_4 Char(4),
	@P_5 Char(10),
	@P_6 Char(1),
	@P_7 Char(15),
	@P_8 Char(15),
	@P_9 DateTime,
	@P_10 DateTime,
	@P_11 Char(4),
	@P_12 VarChar(100),
	@P_13 VarChar(100),
	@P_14 VarChar(100),
	@P_15 Char(2),
	@P_16 Decimal(12,3),
	@P_17 Decimal(12,3),
	@P_18 Decimal(12,3),
	@P_19 Char(11),
	@P_20 Int,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[CAB_DOCUMENTO_VENTA_dss_tracking] WHERE [NU_CODI_DOCU_VENT] = @P_1)
BEGIN 
INSERT INTO [dbo].[CAB_DOCUMENTO_VENTA]([NU_CODI_DOCU_VENT], [DT_FECH_EMISION], [NU_CODI_TICKET], [CH_SERI_CMPRBT], [CH_NUME_CMPRBT], [CH_ESTA_ACTIVO], [CH_CODI_USUA_REGI], [CH_CODI_USUA_MODI], [DT_FECH_USUA_REGI], [DT_FECH_USUA_MODI], [CH_CODI_CLIENTE], [VC_DESC_CLIENTE], [VC_DIRE_CLIENTE], [VC_OBSE_CMPRBT], [ch_tipo_cmprbnt], [nu_impo_total], [nu_impo_igv], [nu_impo_afecto], [ch_ruc_cliente], [NU_CODI_COBR_CRED]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11, @P_12, @P_13, @P_14, @P_15, @P_16, @P_17, @P_18, @P_19, @P_20);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_DOCUMENTO_VENTA_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_DOCUMENTO_VENTA_dss_insertmetadata]
	@P_1 Int,
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[CAB_DOCUMENTO_VENTA_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_DOCU_VENT] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[CAB_DOCUMENTO_VENTA_dss_tracking] ([NU_CODI_DOCU_VENT], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_DOCUMENTO_VENTA_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_DOCUMENTO_VENTA_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[NU_CODI_DOCU_VENT], [base].[DT_FECH_EMISION], [base].[NU_CODI_TICKET], [base].[CH_SERI_CMPRBT], [base].[CH_NUME_CMPRBT], [base].[CH_ESTA_ACTIVO], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_CODI_CLIENTE], [base].[VC_DESC_CLIENTE], [base].[VC_DIRE_CLIENTE], [base].[VC_OBSE_CMPRBT], [base].[ch_tipo_cmprbnt], [base].[nu_impo_total], [base].[nu_impo_igv], [base].[nu_impo_afecto], [base].[ch_ruc_cliente], [base].[NU_CODI_COBR_CRED], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[CAB_DOCUMENTO_VENTA] [base] RIGHT JOIN [DataSync].[CAB_DOCUMENTO_VENTA_dss_tracking] [side] ON [base].[NU_CODI_DOCU_VENT] = [side].[NU_CODI_DOCU_VENT]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_DOCUMENTO_VENTA_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_DOCUMENTO_VENTA_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[NU_CODI_DOCU_VENT], [base].[DT_FECH_EMISION], [base].[NU_CODI_TICKET], [base].[CH_SERI_CMPRBT], [base].[CH_NUME_CMPRBT], [base].[CH_ESTA_ACTIVO], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_CODI_CLIENTE], [base].[VC_DESC_CLIENTE], [base].[VC_DIRE_CLIENTE], [base].[VC_OBSE_CMPRBT], [base].[ch_tipo_cmprbnt], [base].[nu_impo_total], [base].[nu_impo_igv], [base].[nu_impo_afecto], [base].[ch_ruc_cliente], [base].[NU_CODI_COBR_CRED], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[CAB_DOCUMENTO_VENTA] [base] RIGHT JOIN [DataSync].[CAB_DOCUMENTO_VENTA_dss_tracking] [side] ON [base].[NU_CODI_DOCU_VENT] = [side].[NU_CODI_DOCU_VENT] WHERE [side].[NU_CODI_DOCU_VENT]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_DOCUMENTO_VENTA_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_DOCUMENTO_VENTA_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 DateTime,
	@P_3 Int,
	@P_4 Char(4),
	@P_5 Char(10),
	@P_6 Char(1),
	@P_7 Char(15),
	@P_8 Char(15),
	@P_9 DateTime,
	@P_10 DateTime,
	@P_11 Char(4),
	@P_12 VarChar(100),
	@P_13 VarChar(100),
	@P_14 VarChar(100),
	@P_15 Char(2),
	@P_16 Decimal(12,3),
	@P_17 Decimal(12,3),
	@P_18 Decimal(12,3),
	@P_19 Char(11),
	@P_20 Int,
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[CAB_DOCUMENTO_VENTA] SET [DT_FECH_EMISION] = @P_2, [NU_CODI_TICKET] = @P_3, [CH_SERI_CMPRBT] = @P_4, [CH_NUME_CMPRBT] = @P_5, [CH_ESTA_ACTIVO] = @P_6, [CH_CODI_USUA_REGI] = @P_7, [CH_CODI_USUA_MODI] = @P_8, [DT_FECH_USUA_REGI] = @P_9, [DT_FECH_USUA_MODI] = @P_10, [CH_CODI_CLIENTE] = @P_11, [VC_DESC_CLIENTE] = @P_12, [VC_DIRE_CLIENTE] = @P_13, [VC_OBSE_CMPRBT] = @P_14, [ch_tipo_cmprbnt] = @P_15, [nu_impo_total] = @P_16, [nu_impo_igv] = @P_17, [nu_impo_afecto] = @P_18, [ch_ruc_cliente] = @P_19, [NU_CODI_COBR_CRED] = @P_20 FROM [dbo].[CAB_DOCUMENTO_VENTA] [base] JOIN [DataSync].[CAB_DOCUMENTO_VENTA_dss_tracking] [side] ON [base].[NU_CODI_DOCU_VENT] = [side].[NU_CODI_DOCU_VENT] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[NU_CODI_DOCU_VENT] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_DOCUMENTO_VENTA_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_DOCUMENTO_VENTA_dss_updatemetadata]
	@P_1 Int,
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[CAB_DOCUMENTO_VENTA_dss_tracking] WHERE ([NU_CODI_DOCU_VENT] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[CAB_DOCUMENTO_VENTA_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_DOCU_VENT] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[CAB_DOCUMENTO_VENTA_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_DOCU_VENT] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_RECIBO_EGRESO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_RECIBO_EGRESO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[CAB_RECIBO_EGRESO] FROM [dbo].[CAB_RECIBO_EGRESO] [base] JOIN [DataSync].[CAB_RECIBO_EGRESO_dss_tracking] [side] ON [base].[NU_CODI_RECIBO] = [side].[NU_CODI_RECIBO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[NU_CODI_RECIBO] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_RECIBO_EGRESO_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_RECIBO_EGRESO_dss_deletemetadata]
	@P_1 Int,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[CAB_RECIBO_EGRESO_dss_tracking] [side] WHERE [NU_CODI_RECIBO] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_RECIBO_EGRESO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_RECIBO_EGRESO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 DateTime,
	@P_3 VarChar(100),
	@P_4 Char(4),
	@P_5 Char(10),
	@P_6 Char(15),
	@P_7 Char(15),
	@P_8 Char(1),
	@P_9 DateTime,
	@P_10 DateTime,
	@P_11 Char(3),
	@P_12 Char(4),
	@P_13 Char(15),
	@P_14 Char(3),
	@P_15 Char(2),
	@P_16 DateTime,
	@P_17 Char(15),
	@P_18 Decimal(12,3),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[CAB_RECIBO_EGRESO_dss_tracking] WHERE [NU_CODI_RECIBO] = @P_1)
BEGIN 
INSERT INTO [dbo].[CAB_RECIBO_EGRESO]([NU_CODI_RECIBO], [DT_FECH_EGRE], [VC_OBSE_EGRE], [CH_SERI_EGRE], [CH_NUME_EGRE], [CH_CODI_USUA_REGI], [CH_CODI_USUA_MODI], [CH_ESTA_ACTIVO], [DT_FECH_USUA_REGI], [DT_FECH_USUA_MODI], [CH_CODI_TIPO_EGRESO], [CH_CODI_PROVEEDOR], [ch_codi_cajero], [ch_codi_garita], [ch_codi_turno_caja], [dt_fech_turno], [ch_codi_autoriza], [nu_impo_egre]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11, @P_12, @P_13, @P_14, @P_15, @P_16, @P_17, @P_18);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_RECIBO_EGRESO_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_RECIBO_EGRESO_dss_insertmetadata]
	@P_1 Int,
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[CAB_RECIBO_EGRESO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_RECIBO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[CAB_RECIBO_EGRESO_dss_tracking] ([NU_CODI_RECIBO], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_RECIBO_EGRESO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_RECIBO_EGRESO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[NU_CODI_RECIBO], [base].[DT_FECH_EGRE], [base].[VC_OBSE_EGRE], [base].[CH_SERI_EGRE], [base].[CH_NUME_EGRE], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[CH_ESTA_ACTIVO], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_CODI_TIPO_EGRESO], [base].[CH_CODI_PROVEEDOR], [base].[ch_codi_cajero], [base].[ch_codi_garita], [base].[ch_codi_turno_caja], [base].[dt_fech_turno], [base].[ch_codi_autoriza], [base].[nu_impo_egre], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[CAB_RECIBO_EGRESO] [base] RIGHT JOIN [DataSync].[CAB_RECIBO_EGRESO_dss_tracking] [side] ON [base].[NU_CODI_RECIBO] = [side].[NU_CODI_RECIBO]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_RECIBO_EGRESO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_RECIBO_EGRESO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[NU_CODI_RECIBO], [base].[DT_FECH_EGRE], [base].[VC_OBSE_EGRE], [base].[CH_SERI_EGRE], [base].[CH_NUME_EGRE], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[CH_ESTA_ACTIVO], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_CODI_TIPO_EGRESO], [base].[CH_CODI_PROVEEDOR], [base].[ch_codi_cajero], [base].[ch_codi_garita], [base].[ch_codi_turno_caja], [base].[dt_fech_turno], [base].[ch_codi_autoriza], [base].[nu_impo_egre], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[CAB_RECIBO_EGRESO] [base] RIGHT JOIN [DataSync].[CAB_RECIBO_EGRESO_dss_tracking] [side] ON [base].[NU_CODI_RECIBO] = [side].[NU_CODI_RECIBO] WHERE [side].[NU_CODI_RECIBO]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_RECIBO_EGRESO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_RECIBO_EGRESO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 DateTime,
	@P_3 VarChar(100),
	@P_4 Char(4),
	@P_5 Char(10),
	@P_6 Char(15),
	@P_7 Char(15),
	@P_8 Char(1),
	@P_9 DateTime,
	@P_10 DateTime,
	@P_11 Char(3),
	@P_12 Char(4),
	@P_13 Char(15),
	@P_14 Char(3),
	@P_15 Char(2),
	@P_16 DateTime,
	@P_17 Char(15),
	@P_18 Decimal(12,3),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[CAB_RECIBO_EGRESO] SET [DT_FECH_EGRE] = @P_2, [VC_OBSE_EGRE] = @P_3, [CH_SERI_EGRE] = @P_4, [CH_NUME_EGRE] = @P_5, [CH_CODI_USUA_REGI] = @P_6, [CH_CODI_USUA_MODI] = @P_7, [CH_ESTA_ACTIVO] = @P_8, [DT_FECH_USUA_REGI] = @P_9, [DT_FECH_USUA_MODI] = @P_10, [CH_CODI_TIPO_EGRESO] = @P_11, [CH_CODI_PROVEEDOR] = @P_12, [ch_codi_cajero] = @P_13, [ch_codi_garita] = @P_14, [ch_codi_turno_caja] = @P_15, [dt_fech_turno] = @P_16, [ch_codi_autoriza] = @P_17, [nu_impo_egre] = @P_18 FROM [dbo].[CAB_RECIBO_EGRESO] [base] JOIN [DataSync].[CAB_RECIBO_EGRESO_dss_tracking] [side] ON [base].[NU_CODI_RECIBO] = [side].[NU_CODI_RECIBO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[NU_CODI_RECIBO] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[CAB_RECIBO_EGRESO_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[CAB_RECIBO_EGRESO_dss_updatemetadata]
	@P_1 Int,
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[CAB_RECIBO_EGRESO_dss_tracking] WHERE ([NU_CODI_RECIBO] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[CAB_RECIBO_EGRESO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_RECIBO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[CAB_RECIBO_EGRESO_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_RECIBO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[DET_COBRANZA_CREDITO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[DET_COBRANZA_CREDITO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 Int,
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[DET_COBRANZA_CREDITO] FROM [dbo].[DET_COBRANZA_CREDITO] [base] JOIN [DataSync].[DET_COBRANZA_CREDITO_dss_tracking] [side] ON [base].[NU_CODI_COBR_CRED] = [side].[NU_CODI_COBR_CRED] AND [base].[NU_CODI_DETALLE] = [side].[NU_CODI_DETALLE] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[NU_CODI_COBR_CRED] = @P_1 AND [base].[NU_CODI_DETALLE] = @P_2); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[DET_COBRANZA_CREDITO_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[DET_COBRANZA_CREDITO_dss_deletemetadata]
	@P_1 Int,
	@P_2 Int,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[DET_COBRANZA_CREDITO_dss_tracking] [side] WHERE [NU_CODI_COBR_CRED] = @P_1 AND [NU_CODI_DETALLE] = @P_2 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[DET_COBRANZA_CREDITO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[DET_COBRANZA_CREDITO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 Int,
	@P_3 Int,
	@P_4 Decimal(12,3),
	@P_5 Char(15),
	@P_6 Char(15),
	@P_7 DateTime,
	@P_8 DateTime,
	@P_9 Char(4),
	@P_10 Char(10),
	@P_11 Char(20),
	@P_12 Char(1),
	@P_13 Decimal(12,3),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[DET_COBRANZA_CREDITO_dss_tracking] WHERE [NU_CODI_COBR_CRED] = @P_1 AND [NU_CODI_DETALLE] = @P_2)
BEGIN 
INSERT INTO [dbo].[DET_COBRANZA_CREDITO]([NU_CODI_COBR_CRED], [NU_CODI_DETALLE], [NU_CODI_TICKET], [NU_IMPO_COBR], [CH_CODI_USUA_MODI], [CH_CODI_USUA_REGI], [DT_FECH_USUA_REGI], [DT_FECH_USUA_MODI], [ch_seri_tckt], [ch_nume_tckt], [ch_plac_vehiculo], [ch_esta_activo], [nu_impo_original]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11, @P_12, @P_13);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[DET_COBRANZA_CREDITO_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[DET_COBRANZA_CREDITO_dss_insertmetadata]
	@P_1 Int,
	@P_2 Int,
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[DET_COBRANZA_CREDITO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_COBR_CRED] = @P_1 AND [NU_CODI_DETALLE] = @P_2) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[DET_COBRANZA_CREDITO_dss_tracking] ([NU_CODI_COBR_CRED], [NU_CODI_DETALLE], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @P_2, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[DET_COBRANZA_CREDITO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[DET_COBRANZA_CREDITO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[NU_CODI_COBR_CRED], [side].[NU_CODI_DETALLE], [base].[NU_CODI_TICKET], [base].[NU_IMPO_COBR], [base].[CH_CODI_USUA_MODI], [base].[CH_CODI_USUA_REGI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[ch_seri_tckt], [base].[ch_nume_tckt], [base].[ch_plac_vehiculo], [base].[ch_esta_activo], [base].[nu_impo_original], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[DET_COBRANZA_CREDITO] [base] RIGHT JOIN [DataSync].[DET_COBRANZA_CREDITO_dss_tracking] [side] ON [base].[NU_CODI_COBR_CRED] = [side].[NU_CODI_COBR_CRED] AND [base].[NU_CODI_DETALLE] = [side].[NU_CODI_DETALLE]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[DET_COBRANZA_CREDITO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[DET_COBRANZA_CREDITO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 Int,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[NU_CODI_COBR_CRED], [side].[NU_CODI_DETALLE], [base].[NU_CODI_TICKET], [base].[NU_IMPO_COBR], [base].[CH_CODI_USUA_MODI], [base].[CH_CODI_USUA_REGI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[ch_seri_tckt], [base].[ch_nume_tckt], [base].[ch_plac_vehiculo], [base].[ch_esta_activo], [base].[nu_impo_original], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[DET_COBRANZA_CREDITO] [base] RIGHT JOIN [DataSync].[DET_COBRANZA_CREDITO_dss_tracking] [side] ON [base].[NU_CODI_COBR_CRED] = [side].[NU_CODI_COBR_CRED] AND [base].[NU_CODI_DETALLE] = [side].[NU_CODI_DETALLE] WHERE [side].[NU_CODI_COBR_CRED]  = @P_1 AND [side].[NU_CODI_DETALLE]  = @P_2
END
GO
/****** Object:  StoredProcedure [DataSync].[DET_COBRANZA_CREDITO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[DET_COBRANZA_CREDITO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 Int,
	@P_3 Int,
	@P_4 Decimal(12,3),
	@P_5 Char(15),
	@P_6 Char(15),
	@P_7 DateTime,
	@P_8 DateTime,
	@P_9 Char(4),
	@P_10 Char(10),
	@P_11 Char(20),
	@P_12 Char(1),
	@P_13 Decimal(12,3),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[DET_COBRANZA_CREDITO] SET [NU_CODI_TICKET] = @P_3, [NU_IMPO_COBR] = @P_4, [CH_CODI_USUA_MODI] = @P_5, [CH_CODI_USUA_REGI] = @P_6, [DT_FECH_USUA_REGI] = @P_7, [DT_FECH_USUA_MODI] = @P_8, [ch_seri_tckt] = @P_9, [ch_nume_tckt] = @P_10, [ch_plac_vehiculo] = @P_11, [ch_esta_activo] = @P_12, [nu_impo_original] = @P_13 FROM [dbo].[DET_COBRANZA_CREDITO] [base] JOIN [DataSync].[DET_COBRANZA_CREDITO_dss_tracking] [side] ON [base].[NU_CODI_COBR_CRED] = [side].[NU_CODI_COBR_CRED] AND [base].[NU_CODI_DETALLE] = [side].[NU_CODI_DETALLE] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[NU_CODI_COBR_CRED] = @P_1 AND [base].[NU_CODI_DETALLE] = @P_2); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[DET_COBRANZA_CREDITO_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[DET_COBRANZA_CREDITO_dss_updatemetadata]
	@P_1 Int,
	@P_2 Int,
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[DET_COBRANZA_CREDITO_dss_tracking] WHERE ([NU_CODI_COBR_CRED] = @P_1 AND [NU_CODI_DETALLE] = @P_2);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[DET_COBRANZA_CREDITO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_COBR_CRED] = @P_1 AND [NU_CODI_DETALLE] = @P_2) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[DET_COBRANZA_CREDITO_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_COBR_CRED] = @P_1 AND [NU_CODI_DETALLE] = @P_2) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[DET_TARIFARIO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[DET_TARIFARIO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(6),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[DET_TARIFARIO] FROM [dbo].[DET_TARIFARIO] [base] JOIN [DataSync].[DET_TARIFARIO_dss_tracking] [side] ON [base].[CH_CODI_TARIFARIO] = [side].[CH_CODI_TARIFARIO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_TARIFARIO] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[DET_TARIFARIO_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[DET_TARIFARIO_dss_deletemetadata]
	@P_1 Char(6),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[DET_TARIFARIO_dss_tracking] [side] WHERE [CH_CODI_TARIFARIO] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[DET_TARIFARIO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[DET_TARIFARIO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(6),
	@P_2 VarChar(50),
	@P_3 Char(2),
	@P_4 Char(4),
	@P_5 Decimal(12,3),
	@P_6 Decimal(12,3),
	@P_7 Char(15),
	@P_8 Char(15),
	@P_9 DateTime,
	@P_10 DateTime,
	@P_11 Char(1),
	@P_12 Decimal(12,3),
	@P_13 Decimal(12,3),
	@P_14 Decimal(12,3),
	@P_15 Decimal(12,3),
	@P_16 Char(2),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[DET_TARIFARIO_dss_tracking] WHERE [CH_CODI_TARIFARIO] = @P_1)
BEGIN 
INSERT INTO [dbo].[DET_TARIFARIO]([CH_CODI_TARIFARIO], [VC_DESC_TARIFARIO], [CH_TIPO_VEHICULO], [CH_CODI_CLIENTE], [NU_IMPO_DIA], [NU_IMPO_NOCHE], [CH_CODI_USUA_REGI], [CH_CODI_USUA_MODI], [DT_FECH_USUA_REGI], [DT_FECH_USUA_MODI], [CH_ESTA_ACTIVO], [nu_nume_hora_tlrnc], [nu_nume_hora_frccn], [nu_impo_frccn_noche], [nu_impo_frccn_dia], [ch_tipo_cmprbnt]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11, @P_12, @P_13, @P_14, @P_15, @P_16);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[DET_TARIFARIO_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[DET_TARIFARIO_dss_insertmetadata]
	@P_1 Char(6),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[DET_TARIFARIO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_TARIFARIO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[DET_TARIFARIO_dss_tracking] ([CH_CODI_TARIFARIO], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[DET_TARIFARIO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[DET_TARIFARIO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_TARIFARIO], [base].[VC_DESC_TARIFARIO], [base].[CH_TIPO_VEHICULO], [base].[CH_CODI_CLIENTE], [base].[NU_IMPO_DIA], [base].[NU_IMPO_NOCHE], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_ESTA_ACTIVO], [base].[nu_nume_hora_tlrnc], [base].[nu_nume_hora_frccn], [base].[nu_impo_frccn_noche], [base].[nu_impo_frccn_dia], [base].[ch_tipo_cmprbnt], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[DET_TARIFARIO] [base] RIGHT JOIN [DataSync].[DET_TARIFARIO_dss_tracking] [side] ON [base].[CH_CODI_TARIFARIO] = [side].[CH_CODI_TARIFARIO]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[DET_TARIFARIO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[DET_TARIFARIO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(6),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_TARIFARIO], [base].[VC_DESC_TARIFARIO], [base].[CH_TIPO_VEHICULO], [base].[CH_CODI_CLIENTE], [base].[NU_IMPO_DIA], [base].[NU_IMPO_NOCHE], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_ESTA_ACTIVO], [base].[nu_nume_hora_tlrnc], [base].[nu_nume_hora_frccn], [base].[nu_impo_frccn_noche], [base].[nu_impo_frccn_dia], [base].[ch_tipo_cmprbnt], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[DET_TARIFARIO] [base] RIGHT JOIN [DataSync].[DET_TARIFARIO_dss_tracking] [side] ON [base].[CH_CODI_TARIFARIO] = [side].[CH_CODI_TARIFARIO] WHERE [side].[CH_CODI_TARIFARIO]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[DET_TARIFARIO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[DET_TARIFARIO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(6),
	@P_2 VarChar(50),
	@P_3 Char(2),
	@P_4 Char(4),
	@P_5 Decimal(12,3),
	@P_6 Decimal(12,3),
	@P_7 Char(15),
	@P_8 Char(15),
	@P_9 DateTime,
	@P_10 DateTime,
	@P_11 Char(1),
	@P_12 Decimal(12,3),
	@P_13 Decimal(12,3),
	@P_14 Decimal(12,3),
	@P_15 Decimal(12,3),
	@P_16 Char(2),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[DET_TARIFARIO] SET [VC_DESC_TARIFARIO] = @P_2, [CH_TIPO_VEHICULO] = @P_3, [CH_CODI_CLIENTE] = @P_4, [NU_IMPO_DIA] = @P_5, [NU_IMPO_NOCHE] = @P_6, [CH_CODI_USUA_REGI] = @P_7, [CH_CODI_USUA_MODI] = @P_8, [DT_FECH_USUA_REGI] = @P_9, [DT_FECH_USUA_MODI] = @P_10, [CH_ESTA_ACTIVO] = @P_11, [nu_nume_hora_tlrnc] = @P_12, [nu_nume_hora_frccn] = @P_13, [nu_impo_frccn_noche] = @P_14, [nu_impo_frccn_dia] = @P_15, [ch_tipo_cmprbnt] = @P_16 FROM [dbo].[DET_TARIFARIO] [base] JOIN [DataSync].[DET_TARIFARIO_dss_tracking] [side] ON [base].[CH_CODI_TARIFARIO] = [side].[CH_CODI_TARIFARIO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_TARIFARIO] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[DET_TARIFARIO_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[DET_TARIFARIO_dss_updatemetadata]
	@P_1 Char(6),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[DET_TARIFARIO_dss_tracking] WHERE ([CH_CODI_TARIFARIO] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[DET_TARIFARIO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_TARIFARIO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[DET_TARIFARIO_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_TARIFARIO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[dtproperties_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[dtproperties_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_3 VarChar(64),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[dtproperties] FROM [dbo].[dtproperties] [base] JOIN [DataSync].[dtproperties_dss_tracking] [side] ON [base].[id] = [side].[id] AND [base].[property] = [side].[property] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[id] = @P_1 AND [base].[property] = @P_3); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[dtproperties_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[dtproperties_dss_deletemetadata]
	@P_1 Int,
	@P_3 VarChar(64),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[dtproperties_dss_tracking] [side] WHERE [id] = @P_1 AND [property] = @P_3 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[dtproperties_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[dtproperties_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 Int,
	@P_3 VarChar(64),
	@P_4 VarChar(255),
	@P_5 NVarChar(255),
	@P_6 Image,
	@P_7 Int,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[dtproperties_dss_tracking] WHERE [id] = @P_1 AND [property] = @P_3)
BEGIN 
SET IDENTITY_INSERT [dbo].[dtproperties] ON; INSERT INTO [dbo].[dtproperties]([id], [objectid], [property], [value], [uvalue], [lvalue], [version]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[dtproperties] OFF; END 
END
GO
/****** Object:  StoredProcedure [DataSync].[dtproperties_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[dtproperties_dss_insertmetadata]
	@P_1 Int,
	@P_3 VarChar(64),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[dtproperties_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([id] = @P_1 AND [property] = @P_3) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[dtproperties_dss_tracking] ([id], [property], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @P_3, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[dtproperties_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[dtproperties_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[id], [side].[property], [base].[objectid], [base].[value], [base].[uvalue], [base].[lvalue], [base].[version], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[dtproperties] [base] RIGHT JOIN [DataSync].[dtproperties_dss_tracking] [side] ON [base].[id] = [side].[id] AND [base].[property] = [side].[property]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[dtproperties_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[dtproperties_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_3 VarChar(64),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[id], [side].[property], [base].[objectid], [base].[value], [base].[uvalue], [base].[lvalue], [base].[version], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[dtproperties] [base] RIGHT JOIN [DataSync].[dtproperties_dss_tracking] [side] ON [base].[id] = [side].[id] AND [base].[property] = [side].[property] WHERE [side].[id]  = @P_1 AND [side].[property]  = @P_3
END
GO
/****** Object:  StoredProcedure [DataSync].[dtproperties_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[dtproperties_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 Int,
	@P_3 VarChar(64),
	@P_4 VarChar(255),
	@P_5 NVarChar(255),
	@P_6 Image,
	@P_7 Int,
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[dtproperties] SET [objectid] = @P_2, [value] = @P_4, [uvalue] = @P_5, [lvalue] = @P_6, [version] = @P_7 FROM [dbo].[dtproperties] [base] JOIN [DataSync].[dtproperties_dss_tracking] [side] ON [base].[id] = [side].[id] AND [base].[property] = [side].[property] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[id] = @P_1 AND [base].[property] = @P_3); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[dtproperties_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[dtproperties_dss_updatemetadata]
	@P_1 Int,
	@P_3 VarChar(64),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[dtproperties_dss_tracking] WHERE ([id] = @P_1 AND [property] = @P_3);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[dtproperties_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([id] = @P_1 AND [property] = @P_3) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[dtproperties_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([id] = @P_1 AND [property] = @P_3) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CHOFER_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CHOFER_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(4),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_CHOFER] FROM [dbo].[MAE_CHOFER] [base] JOIN [DataSync].[MAE_CHOFER_dss_tracking] [side] ON [base].[CH_CODI_CHOFER] = [side].[CH_CODI_CHOFER] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_CHOFER] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CHOFER_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CHOFER_dss_deletemetadata]
	@P_1 Char(4),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_CHOFER_dss_tracking] [side] WHERE [CH_CODI_CHOFER] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CHOFER_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CHOFER_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(4),
	@P_2 VarChar(100),
	@P_3 Char(20),
	@P_4 Char(15),
	@P_5 Char(15),
	@P_6 DateTime,
	@P_7 DateTime,
	@P_8 VarChar(100),
	@P_9 Char(1),
	@P_10 Char(15),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_CHOFER_dss_tracking] WHERE [CH_CODI_CHOFER] = @P_1)
BEGIN 
INSERT INTO [dbo].[MAE_CHOFER]([CH_CODI_CHOFER], [VC_DESC_CHOFER], [CH_NUME_CELU], [CH_CODI_USUA_REGI], [CH_CODI_USUA_MODI], [DT_FECH_USUA_REGI], [DT_FECH_USUA_MODI], [VC_DIRE_CHOFER], [CH_ESTA_ACTIVO], [ch_nume_dni]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CHOFER_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CHOFER_dss_insertmetadata]
	@P_1 Char(4),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_CHOFER_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_CHOFER] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_CHOFER_dss_tracking] ([CH_CODI_CHOFER], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CHOFER_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CHOFER_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_CHOFER], [base].[VC_DESC_CHOFER], [base].[CH_NUME_CELU], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[VC_DIRE_CHOFER], [base].[CH_ESTA_ACTIVO], [base].[ch_nume_dni], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_CHOFER] [base] RIGHT JOIN [DataSync].[MAE_CHOFER_dss_tracking] [side] ON [base].[CH_CODI_CHOFER] = [side].[CH_CODI_CHOFER]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CHOFER_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CHOFER_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(4),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_CHOFER], [base].[VC_DESC_CHOFER], [base].[CH_NUME_CELU], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[VC_DIRE_CHOFER], [base].[CH_ESTA_ACTIVO], [base].[ch_nume_dni], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_CHOFER] [base] RIGHT JOIN [DataSync].[MAE_CHOFER_dss_tracking] [side] ON [base].[CH_CODI_CHOFER] = [side].[CH_CODI_CHOFER] WHERE [side].[CH_CODI_CHOFER]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CHOFER_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CHOFER_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(4),
	@P_2 VarChar(100),
	@P_3 Char(20),
	@P_4 Char(15),
	@P_5 Char(15),
	@P_6 DateTime,
	@P_7 DateTime,
	@P_8 VarChar(100),
	@P_9 Char(1),
	@P_10 Char(15),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_CHOFER] SET [VC_DESC_CHOFER] = @P_2, [CH_NUME_CELU] = @P_3, [CH_CODI_USUA_REGI] = @P_4, [CH_CODI_USUA_MODI] = @P_5, [DT_FECH_USUA_REGI] = @P_6, [DT_FECH_USUA_MODI] = @P_7, [VC_DIRE_CHOFER] = @P_8, [CH_ESTA_ACTIVO] = @P_9, [ch_nume_dni] = @P_10 FROM [dbo].[MAE_CHOFER] [base] JOIN [DataSync].[MAE_CHOFER_dss_tracking] [side] ON [base].[CH_CODI_CHOFER] = [side].[CH_CODI_CHOFER] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_CHOFER] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CHOFER_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CHOFER_dss_updatemetadata]
	@P_1 Char(4),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_CHOFER_dss_tracking] WHERE ([CH_CODI_CHOFER] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_CHOFER_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_CHOFER] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_CHOFER_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_CHOFER] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CLIENTE_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CLIENTE_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(4),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_CLIENTE] FROM [dbo].[MAE_CLIENTE] [base] JOIN [DataSync].[MAE_CLIENTE_dss_tracking] [side] ON [base].[CH_CODI_CLIENTE] = [side].[CH_CODI_CLIENTE] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_CLIENTE] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CLIENTE_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CLIENTE_dss_deletemetadata]
	@P_1 Char(4),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_CLIENTE_dss_tracking] [side] WHERE [CH_CODI_CLIENTE] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CLIENTE_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CLIENTE_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(4),
	@P_2 Char(11),
	@P_3 VarChar(100),
	@P_4 VarChar(100),
	@P_5 Char(15),
	@P_6 Char(15),
	@P_7 DateTime,
	@P_8 DateTime,
	@P_9 Char(1),
	@P_10 Char(1),
	@P_11 Char(1),
	@P_12 Decimal(13,3),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_CLIENTE_dss_tracking] WHERE [CH_CODI_CLIENTE] = @P_1)
BEGIN 
INSERT INTO [dbo].[MAE_CLIENTE]([CH_CODI_CLIENTE], [CH_RUC_CLIENTE], [VC_RAZO_SOCI_CLIENTE], [VC_DIRE_CLIENTE], [CH_CODI_USUA_REGI], [CH_CODI_USUA_MODI], [DT_FECH_USUA_REGI], [DT_FECH_USUA_MODI], [CH_ESTA_CLIENTE_VIP], [CH_ESTA_ACTIVO], [CH_ESTA_TARIFA_UNICA], [NU_IMPO_TARIFA]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11, @P_12);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CLIENTE_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CLIENTE_dss_insertmetadata]
	@P_1 Char(4),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_CLIENTE_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_CLIENTE] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_CLIENTE_dss_tracking] ([CH_CODI_CLIENTE], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CLIENTE_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CLIENTE_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_CLIENTE], [base].[CH_RUC_CLIENTE], [base].[VC_RAZO_SOCI_CLIENTE], [base].[VC_DIRE_CLIENTE], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_ESTA_CLIENTE_VIP], [base].[CH_ESTA_ACTIVO], [base].[CH_ESTA_TARIFA_UNICA], [base].[NU_IMPO_TARIFA], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_CLIENTE] [base] RIGHT JOIN [DataSync].[MAE_CLIENTE_dss_tracking] [side] ON [base].[CH_CODI_CLIENTE] = [side].[CH_CODI_CLIENTE]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CLIENTE_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CLIENTE_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(4),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_CLIENTE], [base].[CH_RUC_CLIENTE], [base].[VC_RAZO_SOCI_CLIENTE], [base].[VC_DIRE_CLIENTE], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_ESTA_CLIENTE_VIP], [base].[CH_ESTA_ACTIVO], [base].[CH_ESTA_TARIFA_UNICA], [base].[NU_IMPO_TARIFA], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_CLIENTE] [base] RIGHT JOIN [DataSync].[MAE_CLIENTE_dss_tracking] [side] ON [base].[CH_CODI_CLIENTE] = [side].[CH_CODI_CLIENTE] WHERE [side].[CH_CODI_CLIENTE]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CLIENTE_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CLIENTE_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(4),
	@P_2 Char(11),
	@P_3 VarChar(100),
	@P_4 VarChar(100),
	@P_5 Char(15),
	@P_6 Char(15),
	@P_7 DateTime,
	@P_8 DateTime,
	@P_9 Char(1),
	@P_10 Char(1),
	@P_11 Char(1),
	@P_12 Decimal(13,3),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_CLIENTE] SET [CH_RUC_CLIENTE] = @P_2, [VC_RAZO_SOCI_CLIENTE] = @P_3, [VC_DIRE_CLIENTE] = @P_4, [CH_CODI_USUA_REGI] = @P_5, [CH_CODI_USUA_MODI] = @P_6, [DT_FECH_USUA_REGI] = @P_7, [DT_FECH_USUA_MODI] = @P_8, [CH_ESTA_CLIENTE_VIP] = @P_9, [CH_ESTA_ACTIVO] = @P_10, [CH_ESTA_TARIFA_UNICA] = @P_11, [NU_IMPO_TARIFA] = @P_12 FROM [dbo].[MAE_CLIENTE] [base] JOIN [DataSync].[MAE_CLIENTE_dss_tracking] [side] ON [base].[CH_CODI_CLIENTE] = [side].[CH_CODI_CLIENTE] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_CLIENTE] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CLIENTE_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CLIENTE_dss_updatemetadata]
	@P_1 Char(4),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_CLIENTE_dss_tracking] WHERE ([CH_CODI_CLIENTE] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_CLIENTE_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_CLIENTE] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_CLIENTE_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_CLIENTE] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CORRELATIVO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CORRELATIVO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(4),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_CORRELATIVO] FROM [dbo].[MAE_CORRELATIVO] [base] JOIN [DataSync].[MAE_CORRELATIVO_dss_tracking] [side] ON [base].[CH_CODI_CORRELATIVO] = [side].[CH_CODI_CORRELATIVO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_CORRELATIVO] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CORRELATIVO_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CORRELATIVO_dss_deletemetadata]
	@P_1 Char(4),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_CORRELATIVO_dss_tracking] [side] WHERE [CH_CODI_CORRELATIVO] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CORRELATIVO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CORRELATIVO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(4),
	@P_2 Char(2),
	@P_3 Char(4),
	@P_4 Char(10),
	@P_5 Char(1),
	@P_6 Char(15),
	@P_7 Char(15),
	@P_8 DateTime,
	@P_9 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_CORRELATIVO_dss_tracking] WHERE [CH_CODI_CORRELATIVO] = @P_1)
BEGIN 
INSERT INTO [dbo].[MAE_CORRELATIVO]([CH_CODI_CORRELATIVO], [CH_CODI_TIPO_DCMNT], [CH_SERI_ACTUAL], [CH_NUME_ACTUAL], [CH_ESTA_ACTIVO], [CH_CODI_USUA_REGI], [CH_CODI_USUA_MODI], [DT_FECH_USUA_REGI], [DT_FECH_USUA_MODI]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CORRELATIVO_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CORRELATIVO_dss_insertmetadata]
	@P_1 Char(4),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_CORRELATIVO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_CORRELATIVO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_CORRELATIVO_dss_tracking] ([CH_CODI_CORRELATIVO], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CORRELATIVO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CORRELATIVO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_CORRELATIVO], [base].[CH_CODI_TIPO_DCMNT], [base].[CH_SERI_ACTUAL], [base].[CH_NUME_ACTUAL], [base].[CH_ESTA_ACTIVO], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_CORRELATIVO] [base] RIGHT JOIN [DataSync].[MAE_CORRELATIVO_dss_tracking] [side] ON [base].[CH_CODI_CORRELATIVO] = [side].[CH_CODI_CORRELATIVO]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CORRELATIVO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CORRELATIVO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(4),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_CORRELATIVO], [base].[CH_CODI_TIPO_DCMNT], [base].[CH_SERI_ACTUAL], [base].[CH_NUME_ACTUAL], [base].[CH_ESTA_ACTIVO], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_CORRELATIVO] [base] RIGHT JOIN [DataSync].[MAE_CORRELATIVO_dss_tracking] [side] ON [base].[CH_CODI_CORRELATIVO] = [side].[CH_CODI_CORRELATIVO] WHERE [side].[CH_CODI_CORRELATIVO]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CORRELATIVO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CORRELATIVO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(4),
	@P_2 Char(2),
	@P_3 Char(4),
	@P_4 Char(10),
	@P_5 Char(1),
	@P_6 Char(15),
	@P_7 Char(15),
	@P_8 DateTime,
	@P_9 DateTime,
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_CORRELATIVO] SET [CH_CODI_TIPO_DCMNT] = @P_2, [CH_SERI_ACTUAL] = @P_3, [CH_NUME_ACTUAL] = @P_4, [CH_ESTA_ACTIVO] = @P_5, [CH_CODI_USUA_REGI] = @P_6, [CH_CODI_USUA_MODI] = @P_7, [DT_FECH_USUA_REGI] = @P_8, [DT_FECH_USUA_MODI] = @P_9 FROM [dbo].[MAE_CORRELATIVO] [base] JOIN [DataSync].[MAE_CORRELATIVO_dss_tracking] [side] ON [base].[CH_CODI_CORRELATIVO] = [side].[CH_CODI_CORRELATIVO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_CORRELATIVO] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_CORRELATIVO_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_CORRELATIVO_dss_updatemetadata]
	@P_1 Char(4),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_CORRELATIVO_dss_tracking] WHERE ([CH_CODI_CORRELATIVO] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_CORRELATIVO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_CORRELATIVO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_CORRELATIVO_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_CORRELATIVO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_GARITA_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_GARITA_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_GARITA] FROM [dbo].[MAE_GARITA] [base] JOIN [DataSync].[MAE_GARITA_dss_tracking] [side] ON [base].[CH_CODI_GARITA] = [side].[CH_CODI_GARITA] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_GARITA] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_GARITA_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_GARITA_dss_deletemetadata]
	@P_1 Char(3),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_GARITA_dss_tracking] [side] WHERE [CH_CODI_GARITA] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_GARITA_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_GARITA_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 VarChar(50),
	@P_3 Char(15),
	@P_4 Char(15),
	@P_5 DateTime,
	@P_6 DateTime,
	@P_7 Char(1),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_GARITA_dss_tracking] WHERE [CH_CODI_GARITA] = @P_1)
BEGIN 
INSERT INTO [dbo].[MAE_GARITA]([CH_CODI_GARITA], [VC_DESC_GARITA], [CH_CODI_USUA_REGI], [CH_CODI_USUA_MODI], [DT_FECH_USUA_REGI], [DT_FECH_USUA_MODI], [CH_ESTA_ACTIVO]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_GARITA_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_GARITA_dss_insertmetadata]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_GARITA_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_GARITA] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_GARITA_dss_tracking] ([CH_CODI_GARITA], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_GARITA_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_GARITA_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_GARITA], [base].[VC_DESC_GARITA], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_ESTA_ACTIVO], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_GARITA] [base] RIGHT JOIN [DataSync].[MAE_GARITA_dss_tracking] [side] ON [base].[CH_CODI_GARITA] = [side].[CH_CODI_GARITA]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_GARITA_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_GARITA_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_GARITA], [base].[VC_DESC_GARITA], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_ESTA_ACTIVO], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_GARITA] [base] RIGHT JOIN [DataSync].[MAE_GARITA_dss_tracking] [side] ON [base].[CH_CODI_GARITA] = [side].[CH_CODI_GARITA] WHERE [side].[CH_CODI_GARITA]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_GARITA_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_GARITA_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 VarChar(50),
	@P_3 Char(15),
	@P_4 Char(15),
	@P_5 DateTime,
	@P_6 DateTime,
	@P_7 Char(1),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_GARITA] SET [VC_DESC_GARITA] = @P_2, [CH_CODI_USUA_REGI] = @P_3, [CH_CODI_USUA_MODI] = @P_4, [DT_FECH_USUA_REGI] = @P_5, [DT_FECH_USUA_MODI] = @P_6, [CH_ESTA_ACTIVO] = @P_7 FROM [dbo].[MAE_GARITA] [base] JOIN [DataSync].[MAE_GARITA_dss_tracking] [side] ON [base].[CH_CODI_GARITA] = [side].[CH_CODI_GARITA] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_GARITA] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_GARITA_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_GARITA_dss_updatemetadata]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_GARITA_dss_tracking] WHERE ([CH_CODI_GARITA] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_GARITA_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_GARITA] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_GARITA_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_GARITA] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[mae_garita_x_usuario_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[mae_garita_x_usuario_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 Char(15),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[mae_garita_x_usuario] FROM [dbo].[mae_garita_x_usuario] [base] JOIN [DataSync].[mae_garita_x_usuario_dss_tracking] [side] ON [base].[ch_codi_garita] = [side].[ch_codi_garita] AND [base].[ch_codi_usuario] = [side].[ch_codi_usuario] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[ch_codi_garita] = @P_1 AND [base].[ch_codi_usuario] = @P_2); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[mae_garita_x_usuario_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[mae_garita_x_usuario_dss_deletemetadata]
	@P_1 Char(3),
	@P_2 Char(15),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[mae_garita_x_usuario_dss_tracking] [side] WHERE [ch_codi_garita] = @P_1 AND [ch_codi_usuario] = @P_2 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[mae_garita_x_usuario_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[mae_garita_x_usuario_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 Char(15),
	@P_3 Char(1),
	@P_4 Char(15),
	@P_5 Char(15),
	@P_6 DateTime,
	@P_7 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[mae_garita_x_usuario_dss_tracking] WHERE [ch_codi_garita] = @P_1 AND [ch_codi_usuario] = @P_2)
BEGIN 
INSERT INTO [dbo].[mae_garita_x_usuario]([ch_codi_garita], [ch_codi_usuario], [ch_esta_activo], [ch_codi_usua_regi], [ch_codi_usua_modi], [dt_fech_usua_regi], [dt_fech_usua_modi]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[mae_garita_x_usuario_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[mae_garita_x_usuario_dss_insertmetadata]
	@P_1 Char(3),
	@P_2 Char(15),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[mae_garita_x_usuario_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([ch_codi_garita] = @P_1 AND [ch_codi_usuario] = @P_2) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[mae_garita_x_usuario_dss_tracking] ([ch_codi_garita], [ch_codi_usuario], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @P_2, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[mae_garita_x_usuario_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[mae_garita_x_usuario_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[ch_codi_garita], [side].[ch_codi_usuario], [base].[ch_esta_activo], [base].[ch_codi_usua_regi], [base].[ch_codi_usua_modi], [base].[dt_fech_usua_regi], [base].[dt_fech_usua_modi], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[mae_garita_x_usuario] [base] RIGHT JOIN [DataSync].[mae_garita_x_usuario_dss_tracking] [side] ON [base].[ch_codi_garita] = [side].[ch_codi_garita] AND [base].[ch_codi_usuario] = [side].[ch_codi_usuario]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[mae_garita_x_usuario_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[mae_garita_x_usuario_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 Char(15),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[ch_codi_garita], [side].[ch_codi_usuario], [base].[ch_esta_activo], [base].[ch_codi_usua_regi], [base].[ch_codi_usua_modi], [base].[dt_fech_usua_regi], [base].[dt_fech_usua_modi], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[mae_garita_x_usuario] [base] RIGHT JOIN [DataSync].[mae_garita_x_usuario_dss_tracking] [side] ON [base].[ch_codi_garita] = [side].[ch_codi_garita] AND [base].[ch_codi_usuario] = [side].[ch_codi_usuario] WHERE [side].[ch_codi_garita]  = @P_1 AND [side].[ch_codi_usuario]  = @P_2
END
GO
/****** Object:  StoredProcedure [DataSync].[mae_garita_x_usuario_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[mae_garita_x_usuario_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 Char(15),
	@P_3 Char(1),
	@P_4 Char(15),
	@P_5 Char(15),
	@P_6 DateTime,
	@P_7 DateTime,
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[mae_garita_x_usuario] SET [ch_esta_activo] = @P_3, [ch_codi_usua_regi] = @P_4, [ch_codi_usua_modi] = @P_5, [dt_fech_usua_regi] = @P_6, [dt_fech_usua_modi] = @P_7 FROM [dbo].[mae_garita_x_usuario] [base] JOIN [DataSync].[mae_garita_x_usuario_dss_tracking] [side] ON [base].[ch_codi_garita] = [side].[ch_codi_garita] AND [base].[ch_codi_usuario] = [side].[ch_codi_usuario] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[ch_codi_garita] = @P_1 AND [base].[ch_codi_usuario] = @P_2); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[mae_garita_x_usuario_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[mae_garita_x_usuario_dss_updatemetadata]
	@P_1 Char(3),
	@P_2 Char(15),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[mae_garita_x_usuario_dss_tracking] WHERE ([ch_codi_garita] = @P_1 AND [ch_codi_usuario] = @P_2);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[mae_garita_x_usuario_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([ch_codi_garita] = @P_1 AND [ch_codi_usuario] = @P_2) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[mae_garita_x_usuario_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([ch_codi_garita] = @P_1 AND [ch_codi_usuario] = @P_2) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_MODULO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_MODULO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 Char(3),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_MODULO] FROM [dbo].[MAE_MODULO] [base] JOIN [DataSync].[MAE_MODULO_dss_tracking] [side] ON [base].[CH_CODI_SISTEMA] = [side].[CH_CODI_SISTEMA] AND [base].[CH_CODI_MODULO] = [side].[CH_CODI_MODULO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_SISTEMA] = @P_1 AND [base].[CH_CODI_MODULO] = @P_2); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_MODULO_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_MODULO_dss_deletemetadata]
	@P_1 Char(3),
	@P_2 Char(3),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_MODULO_dss_tracking] [side] WHERE [CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_MODULO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_MODULO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 Char(3),
	@P_3 VarChar(50),
	@P_4 Char(1),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_MODULO_dss_tracking] WHERE [CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2)
BEGIN 
INSERT INTO [dbo].[MAE_MODULO]([CH_CODI_SISTEMA], [CH_CODI_MODULO], [VC_DESC_MODULO], [CH_ESTA_MODULO]) VALUES (@P_1, @P_2, @P_3, @P_4);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_MODULO_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_MODULO_dss_insertmetadata]
	@P_1 Char(3),
	@P_2 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_MODULO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_MODULO_dss_tracking] ([CH_CODI_SISTEMA], [CH_CODI_MODULO], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @P_2, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_MODULO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_MODULO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_SISTEMA], [side].[CH_CODI_MODULO], [base].[VC_DESC_MODULO], [base].[CH_ESTA_MODULO], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_MODULO] [base] RIGHT JOIN [DataSync].[MAE_MODULO_dss_tracking] [side] ON [base].[CH_CODI_SISTEMA] = [side].[CH_CODI_SISTEMA] AND [base].[CH_CODI_MODULO] = [side].[CH_CODI_MODULO]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_MODULO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_MODULO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 Char(3),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_SISTEMA], [side].[CH_CODI_MODULO], [base].[VC_DESC_MODULO], [base].[CH_ESTA_MODULO], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_MODULO] [base] RIGHT JOIN [DataSync].[MAE_MODULO_dss_tracking] [side] ON [base].[CH_CODI_SISTEMA] = [side].[CH_CODI_SISTEMA] AND [base].[CH_CODI_MODULO] = [side].[CH_CODI_MODULO] WHERE [side].[CH_CODI_SISTEMA]  = @P_1 AND [side].[CH_CODI_MODULO]  = @P_2
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_MODULO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_MODULO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 Char(3),
	@P_3 VarChar(50),
	@P_4 Char(1),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_MODULO] SET [VC_DESC_MODULO] = @P_3, [CH_ESTA_MODULO] = @P_4 FROM [dbo].[MAE_MODULO] [base] JOIN [DataSync].[MAE_MODULO_dss_tracking] [side] ON [base].[CH_CODI_SISTEMA] = [side].[CH_CODI_SISTEMA] AND [base].[CH_CODI_MODULO] = [side].[CH_CODI_MODULO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_SISTEMA] = @P_1 AND [base].[CH_CODI_MODULO] = @P_2); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_MODULO_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_MODULO_dss_updatemetadata]
	@P_1 Char(3),
	@P_2 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_MODULO_dss_tracking] WHERE ([CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_MODULO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_MODULO_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_OPCION_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_OPCION_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 Char(3),
	@P_3 Char(2),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_OPCION] FROM [dbo].[MAE_OPCION] [base] JOIN [DataSync].[MAE_OPCION_dss_tracking] [side] ON [base].[CH_CODI_SISTEMA] = [side].[CH_CODI_SISTEMA] AND [base].[CH_CODI_MODULO] = [side].[CH_CODI_MODULO] AND [base].[CH_CODI_OPCION] = [side].[CH_CODI_OPCION] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_SISTEMA] = @P_1 AND [base].[CH_CODI_MODULO] = @P_2 AND [base].[CH_CODI_OPCION] = @P_3); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_OPCION_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_OPCION_dss_deletemetadata]
	@P_1 Char(3),
	@P_2 Char(3),
	@P_3 Char(2),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_OPCION_dss_tracking] [side] WHERE [CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2 AND [CH_CODI_OPCION] = @P_3 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_OPCION_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_OPCION_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 Char(3),
	@P_3 Char(2),
	@P_4 VarChar(50),
	@P_5 VarChar(50),
	@P_6 VarChar(3),
	@P_7 VarChar(50),
	@P_8 VarChar(50),
	@P_9 DateTime,
	@P_10 DateTime,
	@P_11 Char(1),
	@P_12 Char(1),
	@P_13 VarChar(50),
	@P_14 Char(50),
	@P_15 Char(1),
	@P_16 Char(1),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_OPCION_dss_tracking] WHERE [CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2 AND [CH_CODI_OPCION] = @P_3)
BEGIN 
INSERT INTO [dbo].[MAE_OPCION]([CH_CODI_SISTEMA], [CH_CODI_MODULO], [CH_CODI_OPCION], [VC_DESC_OPCION], [VC_DESC_NOM_VENTANA], [VC_TIPO_OPCION], [VC_DESC_ICONO_OPCION], [VC_DESC_RESPONSABLE], [DT_FECH_CREACION_OPCION], [DT_FECH_MOD_OPCION], [CH_ESTA_PARAMETRO], [CH_ESTA_OPCION], [CH_DESC_NOM_CORTO], [CH_RUTA_PROGRAMA], [CH_ESTA_OPCION_INTERNET], [CH_IND_ORIGINAL]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11, @P_12, @P_13, @P_14, @P_15, @P_16);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_OPCION_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_OPCION_dss_insertmetadata]
	@P_1 Char(3),
	@P_2 Char(3),
	@P_3 Char(2),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_OPCION_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2 AND [CH_CODI_OPCION] = @P_3) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_OPCION_dss_tracking] ([CH_CODI_SISTEMA], [CH_CODI_MODULO], [CH_CODI_OPCION], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @P_2, @P_3, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_OPCION_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_OPCION_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_SISTEMA], [side].[CH_CODI_MODULO], [side].[CH_CODI_OPCION], [base].[VC_DESC_OPCION], [base].[VC_DESC_NOM_VENTANA], [base].[VC_TIPO_OPCION], [base].[VC_DESC_ICONO_OPCION], [base].[VC_DESC_RESPONSABLE], [base].[DT_FECH_CREACION_OPCION], [base].[DT_FECH_MOD_OPCION], [base].[CH_ESTA_PARAMETRO], [base].[CH_ESTA_OPCION], [base].[CH_DESC_NOM_CORTO], [base].[CH_RUTA_PROGRAMA], [base].[CH_ESTA_OPCION_INTERNET], [base].[CH_IND_ORIGINAL], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_OPCION] [base] RIGHT JOIN [DataSync].[MAE_OPCION_dss_tracking] [side] ON [base].[CH_CODI_SISTEMA] = [side].[CH_CODI_SISTEMA] AND [base].[CH_CODI_MODULO] = [side].[CH_CODI_MODULO] AND [base].[CH_CODI_OPCION] = [side].[CH_CODI_OPCION]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_OPCION_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_OPCION_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 Char(3),
	@P_3 Char(2),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_SISTEMA], [side].[CH_CODI_MODULO], [side].[CH_CODI_OPCION], [base].[VC_DESC_OPCION], [base].[VC_DESC_NOM_VENTANA], [base].[VC_TIPO_OPCION], [base].[VC_DESC_ICONO_OPCION], [base].[VC_DESC_RESPONSABLE], [base].[DT_FECH_CREACION_OPCION], [base].[DT_FECH_MOD_OPCION], [base].[CH_ESTA_PARAMETRO], [base].[CH_ESTA_OPCION], [base].[CH_DESC_NOM_CORTO], [base].[CH_RUTA_PROGRAMA], [base].[CH_ESTA_OPCION_INTERNET], [base].[CH_IND_ORIGINAL], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_OPCION] [base] RIGHT JOIN [DataSync].[MAE_OPCION_dss_tracking] [side] ON [base].[CH_CODI_SISTEMA] = [side].[CH_CODI_SISTEMA] AND [base].[CH_CODI_MODULO] = [side].[CH_CODI_MODULO] AND [base].[CH_CODI_OPCION] = [side].[CH_CODI_OPCION] WHERE [side].[CH_CODI_SISTEMA]  = @P_1 AND [side].[CH_CODI_MODULO]  = @P_2 AND [side].[CH_CODI_OPCION]  = @P_3
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_OPCION_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_OPCION_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 Char(3),
	@P_3 Char(2),
	@P_4 VarChar(50),
	@P_5 VarChar(50),
	@P_6 VarChar(3),
	@P_7 VarChar(50),
	@P_8 VarChar(50),
	@P_9 DateTime,
	@P_10 DateTime,
	@P_11 Char(1),
	@P_12 Char(1),
	@P_13 VarChar(50),
	@P_14 Char(50),
	@P_15 Char(1),
	@P_16 Char(1),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_OPCION] SET [VC_DESC_OPCION] = @P_4, [VC_DESC_NOM_VENTANA] = @P_5, [VC_TIPO_OPCION] = @P_6, [VC_DESC_ICONO_OPCION] = @P_7, [VC_DESC_RESPONSABLE] = @P_8, [DT_FECH_CREACION_OPCION] = @P_9, [DT_FECH_MOD_OPCION] = @P_10, [CH_ESTA_PARAMETRO] = @P_11, [CH_ESTA_OPCION] = @P_12, [CH_DESC_NOM_CORTO] = @P_13, [CH_RUTA_PROGRAMA] = @P_14, [CH_ESTA_OPCION_INTERNET] = @P_15, [CH_IND_ORIGINAL] = @P_16 FROM [dbo].[MAE_OPCION] [base] JOIN [DataSync].[MAE_OPCION_dss_tracking] [side] ON [base].[CH_CODI_SISTEMA] = [side].[CH_CODI_SISTEMA] AND [base].[CH_CODI_MODULO] = [side].[CH_CODI_MODULO] AND [base].[CH_CODI_OPCION] = [side].[CH_CODI_OPCION] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_SISTEMA] = @P_1 AND [base].[CH_CODI_MODULO] = @P_2 AND [base].[CH_CODI_OPCION] = @P_3); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_OPCION_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_OPCION_dss_updatemetadata]
	@P_1 Char(3),
	@P_2 Char(3),
	@P_3 Char(2),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_OPCION_dss_tracking] WHERE ([CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2 AND [CH_CODI_OPCION] = @P_3);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_OPCION_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2 AND [CH_CODI_OPCION] = @P_3) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_OPCION_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_SISTEMA] = @P_1 AND [CH_CODI_MODULO] = @P_2 AND [CH_CODI_OPCION] = @P_3) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PERFIL_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PERFIL_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_PERFIL] FROM [dbo].[MAE_PERFIL] [base] JOIN [DataSync].[MAE_PERFIL_dss_tracking] [side] ON [base].[CH_CODI_PERFIL] = [side].[CH_CODI_PERFIL] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_PERFIL] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PERFIL_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PERFIL_dss_deletemetadata]
	@P_1 Char(3),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_PERFIL_dss_tracking] [side] WHERE [CH_CODI_PERFIL] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PERFIL_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PERFIL_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 VarChar(50),
	@P_3 Char(1),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_PERFIL_dss_tracking] WHERE [CH_CODI_PERFIL] = @P_1)
BEGIN 
INSERT INTO [dbo].[MAE_PERFIL]([CH_CODI_PERFIL], [VC_DESC_PERFIL], [CH_ESTA_PERFIL]) VALUES (@P_1, @P_2, @P_3);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PERFIL_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PERFIL_dss_insertmetadata]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_PERFIL_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_PERFIL] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_PERFIL_dss_tracking] ([CH_CODI_PERFIL], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PERFIL_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PERFIL_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_PERFIL], [base].[VC_DESC_PERFIL], [base].[CH_ESTA_PERFIL], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_PERFIL] [base] RIGHT JOIN [DataSync].[MAE_PERFIL_dss_tracking] [side] ON [base].[CH_CODI_PERFIL] = [side].[CH_CODI_PERFIL]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PERFIL_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PERFIL_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_PERFIL], [base].[VC_DESC_PERFIL], [base].[CH_ESTA_PERFIL], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_PERFIL] [base] RIGHT JOIN [DataSync].[MAE_PERFIL_dss_tracking] [side] ON [base].[CH_CODI_PERFIL] = [side].[CH_CODI_PERFIL] WHERE [side].[CH_CODI_PERFIL]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PERFIL_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PERFIL_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 VarChar(50),
	@P_3 Char(1),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_PERFIL] SET [VC_DESC_PERFIL] = @P_2, [CH_ESTA_PERFIL] = @P_3 FROM [dbo].[MAE_PERFIL] [base] JOIN [DataSync].[MAE_PERFIL_dss_tracking] [side] ON [base].[CH_CODI_PERFIL] = [side].[CH_CODI_PERFIL] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_PERFIL] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PERFIL_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PERFIL_dss_updatemetadata]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_PERFIL_dss_tracking] WHERE ([CH_CODI_PERFIL] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_PERFIL_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_PERFIL] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_PERFIL_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_PERFIL] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(20),
	@P_2 Char(3),
	@P_3 Char(3),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_PERFIL_MAE_USUARIO] FROM [dbo].[MAE_PERFIL_MAE_USUARIO] [base] JOIN [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_tracking] [side] ON [base].[CH_CODI_USUARIO] = [side].[CH_CODI_USUARIO] AND [base].[CH_CODI_PERFIL] = [side].[CH_CODI_PERFIL] AND [base].[CH_NUME_ASIGNA] = [side].[CH_NUME_ASIGNA] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_USUARIO] = @P_1 AND [base].[CH_CODI_PERFIL] = @P_2 AND [base].[CH_NUME_ASIGNA] = @P_3); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_deletemetadata]
	@P_1 Char(20),
	@P_2 Char(3),
	@P_3 Char(3),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_tracking] [side] WHERE [CH_CODI_USUARIO] = @P_1 AND [CH_CODI_PERFIL] = @P_2 AND [CH_NUME_ASIGNA] = @P_3 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(20),
	@P_2 Char(3),
	@P_3 Char(3),
	@P_4 DateTime,
	@P_5 Char(15),
	@P_6 DateTime,
	@P_7 Char(15),
	@P_8 Char(1),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_tracking] WHERE [CH_CODI_USUARIO] = @P_1 AND [CH_CODI_PERFIL] = @P_2 AND [CH_NUME_ASIGNA] = @P_3)
BEGIN 
INSERT INTO [dbo].[MAE_PERFIL_MAE_USUARIO]([CH_CODI_USUARIO], [CH_CODI_PERFIL], [CH_NUME_ASIGNA], [DT_FECH_ASIGNA], [CH_CODI_USUA_ASIGNA], [DT_FECH_REVOCA], [CH_CODI_USUA_REVOCA], [CH_ESTA_PERFIL_USUA]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_insertmetadata]
	@P_1 Char(20),
	@P_2 Char(3),
	@P_3 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_USUARIO] = @P_1 AND [CH_CODI_PERFIL] = @P_2 AND [CH_NUME_ASIGNA] = @P_3) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_tracking] ([CH_CODI_USUARIO], [CH_CODI_PERFIL], [CH_NUME_ASIGNA], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @P_2, @P_3, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_USUARIO], [side].[CH_CODI_PERFIL], [side].[CH_NUME_ASIGNA], [base].[DT_FECH_ASIGNA], [base].[CH_CODI_USUA_ASIGNA], [base].[DT_FECH_REVOCA], [base].[CH_CODI_USUA_REVOCA], [base].[CH_ESTA_PERFIL_USUA], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_PERFIL_MAE_USUARIO] [base] RIGHT JOIN [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_tracking] [side] ON [base].[CH_CODI_USUARIO] = [side].[CH_CODI_USUARIO] AND [base].[CH_CODI_PERFIL] = [side].[CH_CODI_PERFIL] AND [base].[CH_NUME_ASIGNA] = [side].[CH_NUME_ASIGNA]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(20),
	@P_2 Char(3),
	@P_3 Char(3),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_USUARIO], [side].[CH_CODI_PERFIL], [side].[CH_NUME_ASIGNA], [base].[DT_FECH_ASIGNA], [base].[CH_CODI_USUA_ASIGNA], [base].[DT_FECH_REVOCA], [base].[CH_CODI_USUA_REVOCA], [base].[CH_ESTA_PERFIL_USUA], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_PERFIL_MAE_USUARIO] [base] RIGHT JOIN [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_tracking] [side] ON [base].[CH_CODI_USUARIO] = [side].[CH_CODI_USUARIO] AND [base].[CH_CODI_PERFIL] = [side].[CH_CODI_PERFIL] AND [base].[CH_NUME_ASIGNA] = [side].[CH_NUME_ASIGNA] WHERE [side].[CH_CODI_USUARIO]  = @P_1 AND [side].[CH_CODI_PERFIL]  = @P_2 AND [side].[CH_NUME_ASIGNA]  = @P_3
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(20),
	@P_2 Char(3),
	@P_3 Char(3),
	@P_4 DateTime,
	@P_5 Char(15),
	@P_6 DateTime,
	@P_7 Char(15),
	@P_8 Char(1),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_PERFIL_MAE_USUARIO] SET [DT_FECH_ASIGNA] = @P_4, [CH_CODI_USUA_ASIGNA] = @P_5, [DT_FECH_REVOCA] = @P_6, [CH_CODI_USUA_REVOCA] = @P_7, [CH_ESTA_PERFIL_USUA] = @P_8 FROM [dbo].[MAE_PERFIL_MAE_USUARIO] [base] JOIN [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_tracking] [side] ON [base].[CH_CODI_USUARIO] = [side].[CH_CODI_USUARIO] AND [base].[CH_CODI_PERFIL] = [side].[CH_CODI_PERFIL] AND [base].[CH_NUME_ASIGNA] = [side].[CH_NUME_ASIGNA] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_USUARIO] = @P_1 AND [base].[CH_CODI_PERFIL] = @P_2 AND [base].[CH_NUME_ASIGNA] = @P_3); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_updatemetadata]
	@P_1 Char(20),
	@P_2 Char(3),
	@P_3 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_tracking] WHERE ([CH_CODI_USUARIO] = @P_1 AND [CH_CODI_PERFIL] = @P_2 AND [CH_NUME_ASIGNA] = @P_3);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_USUARIO] = @P_1 AND [CH_CODI_PERFIL] = @P_2 AND [CH_NUME_ASIGNA] = @P_3) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_PERFIL_MAE_USUARIO_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_USUARIO] = @P_1 AND [CH_CODI_PERFIL] = @P_2 AND [CH_NUME_ASIGNA] = @P_3) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PROVEEDOR_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PROVEEDOR_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(4),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_PROVEEDOR] FROM [dbo].[MAE_PROVEEDOR] [base] JOIN [DataSync].[MAE_PROVEEDOR_dss_tracking] [side] ON [base].[CH_CODI_PROVEEDOR] = [side].[CH_CODI_PROVEEDOR] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_PROVEEDOR] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PROVEEDOR_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PROVEEDOR_dss_deletemetadata]
	@P_1 Char(4),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_PROVEEDOR_dss_tracking] [side] WHERE [CH_CODI_PROVEEDOR] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PROVEEDOR_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PROVEEDOR_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(4),
	@P_2 VarChar(100),
	@P_3 Char(11),
	@P_4 VarChar(100),
	@P_5 Char(1),
	@P_6 Char(15),
	@P_7 Char(15),
	@P_8 DateTime,
	@P_9 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_PROVEEDOR_dss_tracking] WHERE [CH_CODI_PROVEEDOR] = @P_1)
BEGIN 
INSERT INTO [dbo].[MAE_PROVEEDOR]([CH_CODI_PROVEEDOR], [VC_RAZO_SOCI_PROV], [CH_RUC_PROV], [VC_DIRE_PROV], [CH_ESTA_ACTIVO], [CH_CODI_USUA_REGI], [CH_CODI_USUA_MODI], [DT_FECH_USUA_MODI], [DT_FECH_USUA_REGI]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PROVEEDOR_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PROVEEDOR_dss_insertmetadata]
	@P_1 Char(4),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_PROVEEDOR_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_PROVEEDOR] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_PROVEEDOR_dss_tracking] ([CH_CODI_PROVEEDOR], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PROVEEDOR_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PROVEEDOR_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_PROVEEDOR], [base].[VC_RAZO_SOCI_PROV], [base].[CH_RUC_PROV], [base].[VC_DIRE_PROV], [base].[CH_ESTA_ACTIVO], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_MODI], [base].[DT_FECH_USUA_REGI], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_PROVEEDOR] [base] RIGHT JOIN [DataSync].[MAE_PROVEEDOR_dss_tracking] [side] ON [base].[CH_CODI_PROVEEDOR] = [side].[CH_CODI_PROVEEDOR]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PROVEEDOR_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PROVEEDOR_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(4),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_PROVEEDOR], [base].[VC_RAZO_SOCI_PROV], [base].[CH_RUC_PROV], [base].[VC_DIRE_PROV], [base].[CH_ESTA_ACTIVO], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_MODI], [base].[DT_FECH_USUA_REGI], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_PROVEEDOR] [base] RIGHT JOIN [DataSync].[MAE_PROVEEDOR_dss_tracking] [side] ON [base].[CH_CODI_PROVEEDOR] = [side].[CH_CODI_PROVEEDOR] WHERE [side].[CH_CODI_PROVEEDOR]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PROVEEDOR_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PROVEEDOR_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(4),
	@P_2 VarChar(100),
	@P_3 Char(11),
	@P_4 VarChar(100),
	@P_5 Char(1),
	@P_6 Char(15),
	@P_7 Char(15),
	@P_8 DateTime,
	@P_9 DateTime,
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_PROVEEDOR] SET [VC_RAZO_SOCI_PROV] = @P_2, [CH_RUC_PROV] = @P_3, [VC_DIRE_PROV] = @P_4, [CH_ESTA_ACTIVO] = @P_5, [CH_CODI_USUA_REGI] = @P_6, [CH_CODI_USUA_MODI] = @P_7, [DT_FECH_USUA_MODI] = @P_8, [DT_FECH_USUA_REGI] = @P_9 FROM [dbo].[MAE_PROVEEDOR] [base] JOIN [DataSync].[MAE_PROVEEDOR_dss_tracking] [side] ON [base].[CH_CODI_PROVEEDOR] = [side].[CH_CODI_PROVEEDOR] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_PROVEEDOR] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_PROVEEDOR_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_PROVEEDOR_dss_updatemetadata]
	@P_1 Char(4),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_PROVEEDOR_dss_tracking] WHERE ([CH_CODI_PROVEEDOR] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_PROVEEDOR_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_PROVEEDOR] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_PROVEEDOR_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_PROVEEDOR] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_SISTEMA_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_SISTEMA_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_SISTEMA] FROM [dbo].[MAE_SISTEMA] [base] JOIN [DataSync].[MAE_SISTEMA_dss_tracking] [side] ON [base].[CH_CODI_SISTEMA] = [side].[CH_CODI_SISTEMA] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_SISTEMA] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_SISTEMA_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_SISTEMA_dss_deletemetadata]
	@P_1 Char(3),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_SISTEMA_dss_tracking] [side] WHERE [CH_CODI_SISTEMA] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_SISTEMA_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_SISTEMA_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 VarChar(50),
	@P_3 VarChar(30),
	@P_4 Char(1),
	@P_5 VarChar(50),
	@P_6 Char(1),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_SISTEMA_dss_tracking] WHERE [CH_CODI_SISTEMA] = @P_1)
BEGIN 
INSERT INTO [dbo].[MAE_SISTEMA]([CH_CODI_SISTEMA], [VC_DESL_SISTEMA], [VC_DESC_SISTEMA], [CH_ESTA_SISTEMA], [VC_DESC_LOGO], [CH_ESTA_ACTIVO]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_SISTEMA_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_SISTEMA_dss_insertmetadata]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_SISTEMA_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_SISTEMA] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_SISTEMA_dss_tracking] ([CH_CODI_SISTEMA], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_SISTEMA_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_SISTEMA_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_SISTEMA], [base].[VC_DESL_SISTEMA], [base].[VC_DESC_SISTEMA], [base].[CH_ESTA_SISTEMA], [base].[VC_DESC_LOGO], [base].[CH_ESTA_ACTIVO], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_SISTEMA] [base] RIGHT JOIN [DataSync].[MAE_SISTEMA_dss_tracking] [side] ON [base].[CH_CODI_SISTEMA] = [side].[CH_CODI_SISTEMA]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_SISTEMA_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_SISTEMA_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_SISTEMA], [base].[VC_DESL_SISTEMA], [base].[VC_DESC_SISTEMA], [base].[CH_ESTA_SISTEMA], [base].[VC_DESC_LOGO], [base].[CH_ESTA_ACTIVO], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_SISTEMA] [base] RIGHT JOIN [DataSync].[MAE_SISTEMA_dss_tracking] [side] ON [base].[CH_CODI_SISTEMA] = [side].[CH_CODI_SISTEMA] WHERE [side].[CH_CODI_SISTEMA]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_SISTEMA_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_SISTEMA_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 VarChar(50),
	@P_3 VarChar(30),
	@P_4 Char(1),
	@P_5 VarChar(50),
	@P_6 Char(1),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_SISTEMA] SET [VC_DESL_SISTEMA] = @P_2, [VC_DESC_SISTEMA] = @P_3, [CH_ESTA_SISTEMA] = @P_4, [VC_DESC_LOGO] = @P_5, [CH_ESTA_ACTIVO] = @P_6 FROM [dbo].[MAE_SISTEMA] [base] JOIN [DataSync].[MAE_SISTEMA_dss_tracking] [side] ON [base].[CH_CODI_SISTEMA] = [side].[CH_CODI_SISTEMA] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_SISTEMA] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_SISTEMA_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_SISTEMA_dss_updatemetadata]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_SISTEMA_dss_tracking] WHERE ([CH_CODI_SISTEMA] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_SISTEMA_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_SISTEMA] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_SISTEMA_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_SISTEMA] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_DOCUMENTO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_DOCUMENTO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(2),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_TIPO_DOCUMENTO] FROM [dbo].[MAE_TIPO_DOCUMENTO] [base] JOIN [DataSync].[MAE_TIPO_DOCUMENTO_dss_tracking] [side] ON [base].[CH_CODI_TIPO_DCMNT] = [side].[CH_CODI_TIPO_DCMNT] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_TIPO_DCMNT] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_DOCUMENTO_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_DOCUMENTO_dss_deletemetadata]
	@P_1 Char(2),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_TIPO_DOCUMENTO_dss_tracking] [side] WHERE [CH_CODI_TIPO_DCMNT] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_DOCUMENTO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_DOCUMENTO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(2),
	@P_2 VarChar(30),
	@P_3 Char(1),
	@P_4 Char(15),
	@P_5 Char(15),
	@P_6 DateTime,
	@P_7 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_TIPO_DOCUMENTO_dss_tracking] WHERE [CH_CODI_TIPO_DCMNT] = @P_1)
BEGIN 
INSERT INTO [dbo].[MAE_TIPO_DOCUMENTO]([CH_CODI_TIPO_DCMNT], [VC_DESC_TIPO_DCMNT], [CH_ESTA_ACTIVO], [CH_CODI_USUA_REGI], [CH_CODI_USUA_MODI], [DT_FECH_USUA_REGI], [DT_FECH_USUA_MODI]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_DOCUMENTO_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_DOCUMENTO_dss_insertmetadata]
	@P_1 Char(2),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_TIPO_DOCUMENTO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_TIPO_DCMNT] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_TIPO_DOCUMENTO_dss_tracking] ([CH_CODI_TIPO_DCMNT], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_DOCUMENTO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_DOCUMENTO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_TIPO_DCMNT], [base].[VC_DESC_TIPO_DCMNT], [base].[CH_ESTA_ACTIVO], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_TIPO_DOCUMENTO] [base] RIGHT JOIN [DataSync].[MAE_TIPO_DOCUMENTO_dss_tracking] [side] ON [base].[CH_CODI_TIPO_DCMNT] = [side].[CH_CODI_TIPO_DCMNT]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_DOCUMENTO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_DOCUMENTO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(2),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_TIPO_DCMNT], [base].[VC_DESC_TIPO_DCMNT], [base].[CH_ESTA_ACTIVO], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_TIPO_DOCUMENTO] [base] RIGHT JOIN [DataSync].[MAE_TIPO_DOCUMENTO_dss_tracking] [side] ON [base].[CH_CODI_TIPO_DCMNT] = [side].[CH_CODI_TIPO_DCMNT] WHERE [side].[CH_CODI_TIPO_DCMNT]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_DOCUMENTO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_DOCUMENTO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(2),
	@P_2 VarChar(30),
	@P_3 Char(1),
	@P_4 Char(15),
	@P_5 Char(15),
	@P_6 DateTime,
	@P_7 DateTime,
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_TIPO_DOCUMENTO] SET [VC_DESC_TIPO_DCMNT] = @P_2, [CH_ESTA_ACTIVO] = @P_3, [CH_CODI_USUA_REGI] = @P_4, [CH_CODI_USUA_MODI] = @P_5, [DT_FECH_USUA_REGI] = @P_6, [DT_FECH_USUA_MODI] = @P_7 FROM [dbo].[MAE_TIPO_DOCUMENTO] [base] JOIN [DataSync].[MAE_TIPO_DOCUMENTO_dss_tracking] [side] ON [base].[CH_CODI_TIPO_DCMNT] = [side].[CH_CODI_TIPO_DCMNT] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_TIPO_DCMNT] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_DOCUMENTO_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_DOCUMENTO_dss_updatemetadata]
	@P_1 Char(2),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_TIPO_DOCUMENTO_dss_tracking] WHERE ([CH_CODI_TIPO_DCMNT] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_TIPO_DOCUMENTO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_TIPO_DCMNT] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_TIPO_DOCUMENTO_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_TIPO_DCMNT] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_EGRESO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_EGRESO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_TIPO_EGRESO] FROM [dbo].[MAE_TIPO_EGRESO] [base] JOIN [DataSync].[MAE_TIPO_EGRESO_dss_tracking] [side] ON [base].[CH_CODI_TIPO_EGRESO] = [side].[CH_CODI_TIPO_EGRESO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_TIPO_EGRESO] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_EGRESO_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_EGRESO_dss_deletemetadata]
	@P_1 Char(3),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_TIPO_EGRESO_dss_tracking] [side] WHERE [CH_CODI_TIPO_EGRESO] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_EGRESO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_EGRESO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 VarChar(50),
	@P_3 Char(15),
	@P_4 Char(15),
	@P_5 DateTime,
	@P_6 DateTime,
	@P_7 Char(1),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_TIPO_EGRESO_dss_tracking] WHERE [CH_CODI_TIPO_EGRESO] = @P_1)
BEGIN 
INSERT INTO [dbo].[MAE_TIPO_EGRESO]([CH_CODI_TIPO_EGRESO], [VC_DESC_TIPO_EGRESO], [CH_CODI_USUA_REGI], [CH_CODI_USUA_MODI], [DT_FECH_USUA_REGI], [DT_FECH_USUA_MODI], [ch_esta_activo]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_EGRESO_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_EGRESO_dss_insertmetadata]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_TIPO_EGRESO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_TIPO_EGRESO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_TIPO_EGRESO_dss_tracking] ([CH_CODI_TIPO_EGRESO], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_EGRESO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_EGRESO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_TIPO_EGRESO], [base].[VC_DESC_TIPO_EGRESO], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[ch_esta_activo], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_TIPO_EGRESO] [base] RIGHT JOIN [DataSync].[MAE_TIPO_EGRESO_dss_tracking] [side] ON [base].[CH_CODI_TIPO_EGRESO] = [side].[CH_CODI_TIPO_EGRESO]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_EGRESO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_EGRESO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_TIPO_EGRESO], [base].[VC_DESC_TIPO_EGRESO], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[ch_esta_activo], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_TIPO_EGRESO] [base] RIGHT JOIN [DataSync].[MAE_TIPO_EGRESO_dss_tracking] [side] ON [base].[CH_CODI_TIPO_EGRESO] = [side].[CH_CODI_TIPO_EGRESO] WHERE [side].[CH_CODI_TIPO_EGRESO]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_EGRESO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_EGRESO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 VarChar(50),
	@P_3 Char(15),
	@P_4 Char(15),
	@P_5 DateTime,
	@P_6 DateTime,
	@P_7 Char(1),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_TIPO_EGRESO] SET [VC_DESC_TIPO_EGRESO] = @P_2, [CH_CODI_USUA_REGI] = @P_3, [CH_CODI_USUA_MODI] = @P_4, [DT_FECH_USUA_REGI] = @P_5, [DT_FECH_USUA_MODI] = @P_6, [ch_esta_activo] = @P_7 FROM [dbo].[MAE_TIPO_EGRESO] [base] JOIN [DataSync].[MAE_TIPO_EGRESO_dss_tracking] [side] ON [base].[CH_CODI_TIPO_EGRESO] = [side].[CH_CODI_TIPO_EGRESO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_TIPO_EGRESO] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_EGRESO_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_EGRESO_dss_updatemetadata]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_TIPO_EGRESO_dss_tracking] WHERE ([CH_CODI_TIPO_EGRESO] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_TIPO_EGRESO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_TIPO_EGRESO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_TIPO_EGRESO_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_TIPO_EGRESO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_INCIDENTE_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_INCIDENTE_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_TIPO_INCIDENTE] FROM [dbo].[MAE_TIPO_INCIDENTE] [base] JOIN [DataSync].[MAE_TIPO_INCIDENTE_dss_tracking] [side] ON [base].[CH_CODI_TIPO_INCIDENTE] = [side].[CH_CODI_TIPO_INCIDENTE] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_TIPO_INCIDENTE] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_INCIDENTE_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_INCIDENTE_dss_deletemetadata]
	@P_1 Char(3),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_TIPO_INCIDENTE_dss_tracking] [side] WHERE [CH_CODI_TIPO_INCIDENTE] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_INCIDENTE_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_INCIDENTE_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 VarChar(50),
	@P_3 Char(15),
	@P_4 Char(15),
	@P_5 DateTime,
	@P_6 DateTime,
	@P_7 Char(1),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_TIPO_INCIDENTE_dss_tracking] WHERE [CH_CODI_TIPO_INCIDENTE] = @P_1)
BEGIN 
INSERT INTO [dbo].[MAE_TIPO_INCIDENTE]([CH_CODI_TIPO_INCIDENTE], [VC_DESC_TIPO_INCIDENTE], [CH_CODI_USUA_REGI], [CH_CODI_USUA_MODI], [DT_FECH_USUA_REGI], [DT_FECH_USUA_MODI], [ch_esta_activo]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_INCIDENTE_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_INCIDENTE_dss_insertmetadata]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_TIPO_INCIDENTE_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_TIPO_INCIDENTE] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_TIPO_INCIDENTE_dss_tracking] ([CH_CODI_TIPO_INCIDENTE], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_INCIDENTE_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_INCIDENTE_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_TIPO_INCIDENTE], [base].[VC_DESC_TIPO_INCIDENTE], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[ch_esta_activo], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_TIPO_INCIDENTE] [base] RIGHT JOIN [DataSync].[MAE_TIPO_INCIDENTE_dss_tracking] [side] ON [base].[CH_CODI_TIPO_INCIDENTE] = [side].[CH_CODI_TIPO_INCIDENTE]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_INCIDENTE_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_INCIDENTE_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_TIPO_INCIDENTE], [base].[VC_DESC_TIPO_INCIDENTE], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[ch_esta_activo], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_TIPO_INCIDENTE] [base] RIGHT JOIN [DataSync].[MAE_TIPO_INCIDENTE_dss_tracking] [side] ON [base].[CH_CODI_TIPO_INCIDENTE] = [side].[CH_CODI_TIPO_INCIDENTE] WHERE [side].[CH_CODI_TIPO_INCIDENTE]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_INCIDENTE_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_INCIDENTE_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 VarChar(50),
	@P_3 Char(15),
	@P_4 Char(15),
	@P_5 DateTime,
	@P_6 DateTime,
	@P_7 Char(1),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_TIPO_INCIDENTE] SET [VC_DESC_TIPO_INCIDENTE] = @P_2, [CH_CODI_USUA_REGI] = @P_3, [CH_CODI_USUA_MODI] = @P_4, [DT_FECH_USUA_REGI] = @P_5, [DT_FECH_USUA_MODI] = @P_6, [ch_esta_activo] = @P_7 FROM [dbo].[MAE_TIPO_INCIDENTE] [base] JOIN [DataSync].[MAE_TIPO_INCIDENTE_dss_tracking] [side] ON [base].[CH_CODI_TIPO_INCIDENTE] = [side].[CH_CODI_TIPO_INCIDENTE] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_TIPO_INCIDENTE] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_INCIDENTE_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_INCIDENTE_dss_updatemetadata]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_TIPO_INCIDENTE_dss_tracking] WHERE ([CH_CODI_TIPO_INCIDENTE] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_TIPO_INCIDENTE_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_TIPO_INCIDENTE] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_TIPO_INCIDENTE_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_TIPO_INCIDENTE] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_INGRESO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_INGRESO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_TIPO_INGRESO] FROM [dbo].[MAE_TIPO_INGRESO] [base] JOIN [DataSync].[MAE_TIPO_INGRESO_dss_tracking] [side] ON [base].[CH_CODI_TIPO_INGRESO] = [side].[CH_CODI_TIPO_INGRESO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_TIPO_INGRESO] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_INGRESO_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_INGRESO_dss_deletemetadata]
	@P_1 Char(3),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_TIPO_INGRESO_dss_tracking] [side] WHERE [CH_CODI_TIPO_INGRESO] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_INGRESO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_INGRESO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 VarChar(50),
	@P_3 Char(1),
	@P_4 Char(15),
	@P_5 Char(15),
	@P_6 DateTime,
	@P_7 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_TIPO_INGRESO_dss_tracking] WHERE [CH_CODI_TIPO_INGRESO] = @P_1)
BEGIN 
INSERT INTO [dbo].[MAE_TIPO_INGRESO]([CH_CODI_TIPO_INGRESO], [VC_DESC_TIPO_INGRESO], [CH_ESTA_ACTIVO], [CH_CODI_USUA_REGI], [CH_CODI_USUA_MODI], [DT_FECH_USUA_REGI], [DT_FECH_USUA_MODI]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_INGRESO_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_INGRESO_dss_insertmetadata]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_TIPO_INGRESO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_TIPO_INGRESO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_TIPO_INGRESO_dss_tracking] ([CH_CODI_TIPO_INGRESO], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_INGRESO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_INGRESO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_TIPO_INGRESO], [base].[VC_DESC_TIPO_INGRESO], [base].[CH_ESTA_ACTIVO], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_TIPO_INGRESO] [base] RIGHT JOIN [DataSync].[MAE_TIPO_INGRESO_dss_tracking] [side] ON [base].[CH_CODI_TIPO_INGRESO] = [side].[CH_CODI_TIPO_INGRESO]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_INGRESO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_INGRESO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_TIPO_INGRESO], [base].[VC_DESC_TIPO_INGRESO], [base].[CH_ESTA_ACTIVO], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_TIPO_INGRESO] [base] RIGHT JOIN [DataSync].[MAE_TIPO_INGRESO_dss_tracking] [side] ON [base].[CH_CODI_TIPO_INGRESO] = [side].[CH_CODI_TIPO_INGRESO] WHERE [side].[CH_CODI_TIPO_INGRESO]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_INGRESO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_INGRESO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(3),
	@P_2 VarChar(50),
	@P_3 Char(1),
	@P_4 Char(15),
	@P_5 Char(15),
	@P_6 DateTime,
	@P_7 DateTime,
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_TIPO_INGRESO] SET [VC_DESC_TIPO_INGRESO] = @P_2, [CH_ESTA_ACTIVO] = @P_3, [CH_CODI_USUA_REGI] = @P_4, [CH_CODI_USUA_MODI] = @P_5, [DT_FECH_USUA_REGI] = @P_6, [DT_FECH_USUA_MODI] = @P_7 FROM [dbo].[MAE_TIPO_INGRESO] [base] JOIN [DataSync].[MAE_TIPO_INGRESO_dss_tracking] [side] ON [base].[CH_CODI_TIPO_INGRESO] = [side].[CH_CODI_TIPO_INGRESO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_TIPO_INGRESO] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_INGRESO_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_INGRESO_dss_updatemetadata]
	@P_1 Char(3),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_TIPO_INGRESO_dss_tracking] WHERE ([CH_CODI_TIPO_INGRESO] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_TIPO_INGRESO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_TIPO_INGRESO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_TIPO_INGRESO_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_TIPO_INGRESO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_VEHICULO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_VEHICULO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(2),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_TIPO_VEHICULO] FROM [dbo].[MAE_TIPO_VEHICULO] [base] JOIN [DataSync].[MAE_TIPO_VEHICULO_dss_tracking] [side] ON [base].[CH_TIPO_VEHICULO] = [side].[CH_TIPO_VEHICULO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_TIPO_VEHICULO] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_VEHICULO_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_VEHICULO_dss_deletemetadata]
	@P_1 Char(2),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_TIPO_VEHICULO_dss_tracking] [side] WHERE [CH_TIPO_VEHICULO] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_VEHICULO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_VEHICULO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(2),
	@P_2 VarChar(50),
	@P_3 Char(15),
	@P_4 Char(15),
	@P_5 DateTime,
	@P_6 DateTime,
	@P_7 Char(1),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_TIPO_VEHICULO_dss_tracking] WHERE [CH_TIPO_VEHICULO] = @P_1)
BEGIN 
INSERT INTO [dbo].[MAE_TIPO_VEHICULO]([CH_TIPO_VEHICULO], [VC_DESC_TIPO_VEHICULO], [CH_CODI_USUA_REGI], [CH_CODI_USUA_MODI], [DT_FECH_USUA_REGI], [DT_FECH_USUA_MODI], [CH_ESTA_ACTIVO]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_VEHICULO_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_VEHICULO_dss_insertmetadata]
	@P_1 Char(2),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_TIPO_VEHICULO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_TIPO_VEHICULO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_TIPO_VEHICULO_dss_tracking] ([CH_TIPO_VEHICULO], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_VEHICULO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_VEHICULO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_TIPO_VEHICULO], [base].[VC_DESC_TIPO_VEHICULO], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_ESTA_ACTIVO], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_TIPO_VEHICULO] [base] RIGHT JOIN [DataSync].[MAE_TIPO_VEHICULO_dss_tracking] [side] ON [base].[CH_TIPO_VEHICULO] = [side].[CH_TIPO_VEHICULO]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_VEHICULO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_VEHICULO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(2),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_TIPO_VEHICULO], [base].[VC_DESC_TIPO_VEHICULO], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_ESTA_ACTIVO], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_TIPO_VEHICULO] [base] RIGHT JOIN [DataSync].[MAE_TIPO_VEHICULO_dss_tracking] [side] ON [base].[CH_TIPO_VEHICULO] = [side].[CH_TIPO_VEHICULO] WHERE [side].[CH_TIPO_VEHICULO]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_VEHICULO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_VEHICULO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(2),
	@P_2 VarChar(50),
	@P_3 Char(15),
	@P_4 Char(15),
	@P_5 DateTime,
	@P_6 DateTime,
	@P_7 Char(1),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_TIPO_VEHICULO] SET [VC_DESC_TIPO_VEHICULO] = @P_2, [CH_CODI_USUA_REGI] = @P_3, [CH_CODI_USUA_MODI] = @P_4, [DT_FECH_USUA_REGI] = @P_5, [DT_FECH_USUA_MODI] = @P_6, [CH_ESTA_ACTIVO] = @P_7 FROM [dbo].[MAE_TIPO_VEHICULO] [base] JOIN [DataSync].[MAE_TIPO_VEHICULO_dss_tracking] [side] ON [base].[CH_TIPO_VEHICULO] = [side].[CH_TIPO_VEHICULO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_TIPO_VEHICULO] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_TIPO_VEHICULO_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_TIPO_VEHICULO_dss_updatemetadata]
	@P_1 Char(2),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_TIPO_VEHICULO_dss_tracking] WHERE ([CH_TIPO_VEHICULO] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_TIPO_VEHICULO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_TIPO_VEHICULO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_TIPO_VEHICULO_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_TIPO_VEHICULO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_USUARIO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_USUARIO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(20),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_USUARIO] FROM [dbo].[MAE_USUARIO] [base] JOIN [DataSync].[MAE_USUARIO_dss_tracking] [side] ON [base].[CH_CODI_USUARIO] = [side].[CH_CODI_USUARIO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_USUARIO] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_USUARIO_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_USUARIO_dss_deletemetadata]
	@P_1 Char(20),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_USUARIO_dss_tracking] [side] WHERE [CH_CODI_USUARIO] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_USUARIO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_USUARIO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(20),
	@P_2 VarChar(30),
	@P_3 Char(4),
	@P_4 VarChar(30),
	@P_5 VarChar(30),
	@P_6 VarChar(30),
	@P_7 Char(1),
	@P_8 VarChar(30),
	@P_9 Char(1),
	@P_10 Char(10),
	@P_11 Char(15),
	@P_12 DateTime,
	@P_13 Char(15),
	@P_14 Char(1),
	@P_15 Char(1),
	@P_16 Char(1),
	@P_17 Char(1),
	@P_18 Char(10),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_USUARIO_dss_tracking] WHERE [CH_CODI_USUARIO] = @P_1)
BEGIN 
INSERT INTO [dbo].[MAE_USUARIO]([CH_CODI_USUARIO], [VC_DESC_NOMB_USUARIO], [CH_CODI_CENTRO], [VC_DESC_APELL_PATERNO], [VC_DESC_APELL_MATERNO], [VC_DESC_EMAIL_USUARIO], [CH_ESTA_ACTIVO], [VC_HOST_CONEXION], [CH_ESTA_CONEXION], [CH_PASS_USUA], [CH_CODI_USUA], [DT_FECH_ULTI_ACTU], [CH_CODI_CTA_UPCH], [CH_ESTA_PROGRAMA_TODOS], [CH_ESTA_HORAS_EXTRA], [ch_esta_autoriza], [ch_tipo_usuario], [ch_pass_usua2]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11, @P_12, @P_13, @P_14, @P_15, @P_16, @P_17, @P_18);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_USUARIO_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_USUARIO_dss_insertmetadata]
	@P_1 Char(20),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_USUARIO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_USUARIO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_USUARIO_dss_tracking] ([CH_CODI_USUARIO], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_USUARIO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_USUARIO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_USUARIO], [base].[VC_DESC_NOMB_USUARIO], [base].[CH_CODI_CENTRO], [base].[VC_DESC_APELL_PATERNO], [base].[VC_DESC_APELL_MATERNO], [base].[VC_DESC_EMAIL_USUARIO], [base].[CH_ESTA_ACTIVO], [base].[VC_HOST_CONEXION], [base].[CH_ESTA_CONEXION], [base].[CH_PASS_USUA], [base].[CH_CODI_USUA], [base].[DT_FECH_ULTI_ACTU], [base].[CH_CODI_CTA_UPCH], [base].[CH_ESTA_PROGRAMA_TODOS], [base].[CH_ESTA_HORAS_EXTRA], [base].[ch_esta_autoriza], [base].[ch_tipo_usuario], [base].[ch_pass_usua2], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_USUARIO] [base] RIGHT JOIN [DataSync].[MAE_USUARIO_dss_tracking] [side] ON [base].[CH_CODI_USUARIO] = [side].[CH_CODI_USUARIO]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_USUARIO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_USUARIO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(20),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_USUARIO], [base].[VC_DESC_NOMB_USUARIO], [base].[CH_CODI_CENTRO], [base].[VC_DESC_APELL_PATERNO], [base].[VC_DESC_APELL_MATERNO], [base].[VC_DESC_EMAIL_USUARIO], [base].[CH_ESTA_ACTIVO], [base].[VC_HOST_CONEXION], [base].[CH_ESTA_CONEXION], [base].[CH_PASS_USUA], [base].[CH_CODI_USUA], [base].[DT_FECH_ULTI_ACTU], [base].[CH_CODI_CTA_UPCH], [base].[CH_ESTA_PROGRAMA_TODOS], [base].[CH_ESTA_HORAS_EXTRA], [base].[ch_esta_autoriza], [base].[ch_tipo_usuario], [base].[ch_pass_usua2], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_USUARIO] [base] RIGHT JOIN [DataSync].[MAE_USUARIO_dss_tracking] [side] ON [base].[CH_CODI_USUARIO] = [side].[CH_CODI_USUARIO] WHERE [side].[CH_CODI_USUARIO]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_USUARIO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_USUARIO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(20),
	@P_2 VarChar(30),
	@P_3 Char(4),
	@P_4 VarChar(30),
	@P_5 VarChar(30),
	@P_6 VarChar(30),
	@P_7 Char(1),
	@P_8 VarChar(30),
	@P_9 Char(1),
	@P_10 Char(10),
	@P_11 Char(15),
	@P_12 DateTime,
	@P_13 Char(15),
	@P_14 Char(1),
	@P_15 Char(1),
	@P_16 Char(1),
	@P_17 Char(1),
	@P_18 Char(10),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_USUARIO] SET [VC_DESC_NOMB_USUARIO] = @P_2, [CH_CODI_CENTRO] = @P_3, [VC_DESC_APELL_PATERNO] = @P_4, [VC_DESC_APELL_MATERNO] = @P_5, [VC_DESC_EMAIL_USUARIO] = @P_6, [CH_ESTA_ACTIVO] = @P_7, [VC_HOST_CONEXION] = @P_8, [CH_ESTA_CONEXION] = @P_9, [CH_PASS_USUA] = @P_10, [CH_CODI_USUA] = @P_11, [DT_FECH_ULTI_ACTU] = @P_12, [CH_CODI_CTA_UPCH] = @P_13, [CH_ESTA_PROGRAMA_TODOS] = @P_14, [CH_ESTA_HORAS_EXTRA] = @P_15, [ch_esta_autoriza] = @P_16, [ch_tipo_usuario] = @P_17, [ch_pass_usua2] = @P_18 FROM [dbo].[MAE_USUARIO] [base] JOIN [DataSync].[MAE_USUARIO_dss_tracking] [side] ON [base].[CH_CODI_USUARIO] = [side].[CH_CODI_USUARIO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_USUARIO] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_USUARIO_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_USUARIO_dss_updatemetadata]
	@P_1 Char(20),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_USUARIO_dss_tracking] WHERE ([CH_CODI_USUARIO] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_USUARIO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_USUARIO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_USUARIO_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_USUARIO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_VARIABLE_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_VARIABLE_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(2),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_VARIABLE] FROM [dbo].[MAE_VARIABLE] [base] JOIN [DataSync].[MAE_VARIABLE_dss_tracking] [side] ON [base].[CH_CODI_VARIABLE] = [side].[CH_CODI_VARIABLE] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_VARIABLE] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_VARIABLE_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_VARIABLE_dss_deletemetadata]
	@P_1 Char(2),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_VARIABLE_dss_tracking] [side] WHERE [CH_CODI_VARIABLE] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_VARIABLE_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_VARIABLE_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(2),
	@P_2 Char(70),
	@P_3 Decimal(10,2),
	@P_4 Char(1),
	@P_5 DateTime,
	@P_6 Char(15),
	@P_7 Char(10),
	@P_8 Decimal(10,2),
	@P_9 Decimal(10,2),
	@P_10 Char(10),
	@P_11 Char(10),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_VARIABLE_dss_tracking] WHERE [CH_CODI_VARIABLE] = @P_1)
BEGIN 
INSERT INTO [dbo].[MAE_VARIABLE]([CH_CODI_VARIABLE], [VC_DESC_VARIABLE], [NU_NUME_VALOR], [CH_ESTA_ACTIVO], [DT_FECH_ULTI_ACTU], [CH_CODI_USUA], [CH_VALO_VARIABLE], [nu_nume_valo_desde], [nu_nume_valo_hasta], [ch_nume_valo_desde], [ch_nume_valo_hasta]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_VARIABLE_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_VARIABLE_dss_insertmetadata]
	@P_1 Char(2),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_VARIABLE_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_VARIABLE] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_VARIABLE_dss_tracking] ([CH_CODI_VARIABLE], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_VARIABLE_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_VARIABLE_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_VARIABLE], [base].[VC_DESC_VARIABLE], [base].[NU_NUME_VALOR], [base].[CH_ESTA_ACTIVO], [base].[DT_FECH_ULTI_ACTU], [base].[CH_CODI_USUA], [base].[CH_VALO_VARIABLE], [base].[nu_nume_valo_desde], [base].[nu_nume_valo_hasta], [base].[ch_nume_valo_desde], [base].[ch_nume_valo_hasta], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_VARIABLE] [base] RIGHT JOIN [DataSync].[MAE_VARIABLE_dss_tracking] [side] ON [base].[CH_CODI_VARIABLE] = [side].[CH_CODI_VARIABLE]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_VARIABLE_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_VARIABLE_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(2),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_VARIABLE], [base].[VC_DESC_VARIABLE], [base].[NU_NUME_VALOR], [base].[CH_ESTA_ACTIVO], [base].[DT_FECH_ULTI_ACTU], [base].[CH_CODI_USUA], [base].[CH_VALO_VARIABLE], [base].[nu_nume_valo_desde], [base].[nu_nume_valo_hasta], [base].[ch_nume_valo_desde], [base].[ch_nume_valo_hasta], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_VARIABLE] [base] RIGHT JOIN [DataSync].[MAE_VARIABLE_dss_tracking] [side] ON [base].[CH_CODI_VARIABLE] = [side].[CH_CODI_VARIABLE] WHERE [side].[CH_CODI_VARIABLE]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_VARIABLE_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_VARIABLE_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(2),
	@P_2 Char(70),
	@P_3 Decimal(10,2),
	@P_4 Char(1),
	@P_5 DateTime,
	@P_6 Char(15),
	@P_7 Char(10),
	@P_8 Decimal(10,2),
	@P_9 Decimal(10,2),
	@P_10 Char(10),
	@P_11 Char(10),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_VARIABLE] SET [VC_DESC_VARIABLE] = @P_2, [NU_NUME_VALOR] = @P_3, [CH_ESTA_ACTIVO] = @P_4, [DT_FECH_ULTI_ACTU] = @P_5, [CH_CODI_USUA] = @P_6, [CH_VALO_VARIABLE] = @P_7, [nu_nume_valo_desde] = @P_8, [nu_nume_valo_hasta] = @P_9, [ch_nume_valo_desde] = @P_10, [ch_nume_valo_hasta] = @P_11 FROM [dbo].[MAE_VARIABLE] [base] JOIN [DataSync].[MAE_VARIABLE_dss_tracking] [side] ON [base].[CH_CODI_VARIABLE] = [side].[CH_CODI_VARIABLE] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_VARIABLE] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_VARIABLE_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_VARIABLE_dss_updatemetadata]
	@P_1 Char(2),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_VARIABLE_dss_tracking] WHERE ([CH_CODI_VARIABLE] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_VARIABLE_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_VARIABLE] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_VARIABLE_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_VARIABLE] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_VEHICULO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_VEHICULO_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(6),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MAE_VEHICULO] FROM [dbo].[MAE_VEHICULO] [base] JOIN [DataSync].[MAE_VEHICULO_dss_tracking] [side] ON [base].[CH_CODI_VEHICULO] = [side].[CH_CODI_VEHICULO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_VEHICULO] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_VEHICULO_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_VEHICULO_dss_deletemetadata]
	@P_1 Char(6),
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MAE_VEHICULO_dss_tracking] [side] WHERE [CH_CODI_VEHICULO] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_VEHICULO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_VEHICULO_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(6),
	@P_2 Char(20),
	@P_3 Char(2),
	@P_4 Char(4),
	@P_5 Char(4),
	@P_6 Int,
	@P_7 Char(15),
	@P_8 Char(15),
	@P_9 DateTime,
	@P_10 DateTime,
	@P_11 Char(1),
	@P_12 Char(1),
	@P_13 Decimal(12,3),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MAE_VEHICULO_dss_tracking] WHERE [CH_CODI_VEHICULO] = @P_1)
BEGIN 
INSERT INTO [dbo].[MAE_VEHICULO]([CH_CODI_VEHICULO], [CH_PLAC_VEHICULO], [CH_TIPO_VEHICULO], [CH_CODI_CLIENTE], [CH_CODI_CHOFER], [NU_NUME_LLANTA], [CH_CODI_USUA_REGI], [CH_CODI_USUA_MODI], [DT_FECH_USUA_REGI], [DT_FECH_USUA_MODI], [CH_ESTA_ACTIVO], [CH_ESTA_PARQUEADO], [nu_impo_alquiler]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11, @P_12, @P_13);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_VEHICULO_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_VEHICULO_dss_insertmetadata]
	@P_1 Char(6),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MAE_VEHICULO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_VEHICULO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MAE_VEHICULO_dss_tracking] ([CH_CODI_VEHICULO], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_VEHICULO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_VEHICULO_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[CH_CODI_VEHICULO], [base].[CH_PLAC_VEHICULO], [base].[CH_TIPO_VEHICULO], [base].[CH_CODI_CLIENTE], [base].[CH_CODI_CHOFER], [base].[NU_NUME_LLANTA], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_ESTA_ACTIVO], [base].[CH_ESTA_PARQUEADO], [base].[nu_impo_alquiler], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_VEHICULO] [base] RIGHT JOIN [DataSync].[MAE_VEHICULO_dss_tracking] [side] ON [base].[CH_CODI_VEHICULO] = [side].[CH_CODI_VEHICULO]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_VEHICULO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_VEHICULO_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(6),
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[CH_CODI_VEHICULO], [base].[CH_PLAC_VEHICULO], [base].[CH_TIPO_VEHICULO], [base].[CH_CODI_CLIENTE], [base].[CH_CODI_CHOFER], [base].[NU_NUME_LLANTA], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_ESTA_ACTIVO], [base].[CH_ESTA_PARQUEADO], [base].[nu_impo_alquiler], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MAE_VEHICULO] [base] RIGHT JOIN [DataSync].[MAE_VEHICULO_dss_tracking] [side] ON [base].[CH_CODI_VEHICULO] = [side].[CH_CODI_VEHICULO] WHERE [side].[CH_CODI_VEHICULO]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_VEHICULO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_VEHICULO_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Char(6),
	@P_2 Char(20),
	@P_3 Char(2),
	@P_4 Char(4),
	@P_5 Char(4),
	@P_6 Int,
	@P_7 Char(15),
	@P_8 Char(15),
	@P_9 DateTime,
	@P_10 DateTime,
	@P_11 Char(1),
	@P_12 Char(1),
	@P_13 Decimal(12,3),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MAE_VEHICULO] SET [CH_PLAC_VEHICULO] = @P_2, [CH_TIPO_VEHICULO] = @P_3, [CH_CODI_CLIENTE] = @P_4, [CH_CODI_CHOFER] = @P_5, [NU_NUME_LLANTA] = @P_6, [CH_CODI_USUA_REGI] = @P_7, [CH_CODI_USUA_MODI] = @P_8, [DT_FECH_USUA_REGI] = @P_9, [DT_FECH_USUA_MODI] = @P_10, [CH_ESTA_ACTIVO] = @P_11, [CH_ESTA_PARQUEADO] = @P_12, [nu_impo_alquiler] = @P_13 FROM [dbo].[MAE_VEHICULO] [base] JOIN [DataSync].[MAE_VEHICULO_dss_tracking] [side] ON [base].[CH_CODI_VEHICULO] = [side].[CH_CODI_VEHICULO] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[CH_CODI_VEHICULO] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MAE_VEHICULO_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MAE_VEHICULO_dss_updatemetadata]
	@P_1 Char(6),
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MAE_VEHICULO_dss_tracking] WHERE ([CH_CODI_VEHICULO] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MAE_VEHICULO_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_VEHICULO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MAE_VEHICULO_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([CH_CODI_VEHICULO] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MOV_TICKET_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MOV_TICKET_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[MOV_TICKET] FROM [dbo].[MOV_TICKET] [base] JOIN [DataSync].[MOV_TICKET_dss_tracking] [side] ON [base].[NU_CODI_TICKET] = [side].[NU_CODI_TICKET] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[NU_CODI_TICKET] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MOV_TICKET_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MOV_TICKET_dss_deletemetadata]
	@P_1 Int,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[MOV_TICKET_dss_tracking] [side] WHERE [NU_CODI_TICKET] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[MOV_TICKET_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MOV_TICKET_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 Char(3),
	@P_3 DateTime,
	@P_4 DateTime,
	@P_5 Char(2),
	@P_6 Char(6),
	@P_7 Char(4),
	@P_8 Char(4),
	@P_9 DateTime,
	@P_10 Char(20),
	@P_11 Char(1),
	@P_12 Char(1),
	@P_13 VarChar(100),
	@P_14 Char(15),
	@P_15 Char(15),
	@P_16 Char(15),
	@P_17 DateTime,
	@P_18 DateTime,
	@P_19 Char(1),
	@P_20 Char(2),
	@P_21 Decimal(12,3),
	@P_22 Char(1),
	@P_23 DateTime,
	@P_24 Char(6),
	@P_25 Decimal(12,3),
	@P_26 Decimal(12,3),
	@P_27 Decimal(12,3),
	@P_28 Decimal(12,3),
	@P_29 Decimal(12,3),
	@P_30 Decimal(12,3),
	@P_31 Char(1),
	@P_32 Char(1),
	@P_33 DateTime,
	@P_34 VarChar(100),
	@P_35 Char(1),
	@P_36 Char(3),
	@P_37 Char(4),
	@P_38 Char(10),
	@P_39 Decimal(12,3),
	@P_40 Decimal(12,3),
	@P_41 Decimal(12,3),
	@P_42 Char(15),
	@P_43 VarChar(100),
	@P_44 Char(1),
	@P_45 Char(2),
	@P_46 Char(3),
	@P_47 DateTime,
	@P_48 Char(2),
	@P_49 DateTime,
	@P_50 Char(15),
	@P_51 Char(15),
	@P_52 DateTime,
	@P_53 Decimal(12,3),
	@P_54 Decimal(12,3),
	@P_55 Decimal(12,3),
	@P_56 Decimal(12,3),
	@P_57 Decimal(12,3),
	@P_58 Decimal(12,3),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[MOV_TICKET_dss_tracking] WHERE [NU_CODI_TICKET] = @P_1)
BEGIN 
INSERT INTO [dbo].[MOV_TICKET]([NU_CODI_TICKET], [CH_CODI_GARITA], [DT_FECH_EMISION], [DT_FECH_TURNO], [CH_CODI_TURNO_CAJA], [CH_CODI_VEHICULO], [CH_CODI_CLIENTE], [CH_CODI_CHOFER], [DT_FECH_INGRESO], [CH_NUME_TELEFONO], [CH_ESTA_DUERMEN], [CH_ESTA_LLAVE], [VC_OBSE_TCKT_INGRESO], [CH_CODI_CAJERO], [CH_CODI_USUA_REGI], [CH_CODI_USUA_MODI], [DT_FECH_USUA_REGI], [DT_FECH_USUA_MODI], [CH_ESTA_ACTIVO], [CH_TIPO_COMPROBANTE], [NU_IMPO_TOTAL], [CH_ESTA_CLIENTE_VIP], [DT_FECH_SALIDA], [CH_CODI_TARIFARIO], [NU_IMPO_DIA], [NU_IMPO_NOCHE], [NU_CANT_DIA], [NU_CANT_NOCHE], [NU_TOTA_DIA], [NU_TOTA_NOCHE], [CH_ESTA_CONDICION], [CH_ESTA_CANCELADO], [DT_FECH_CANCELADO], [CH_OBSE_TCKT_SALIDA], [CH_ESTA_INCIDENTE], [CH_CODI_TIPO_INCIDENTE], [CH_SERI_TCKT], [CH_NUME_TCKT], [NU_IMPO_SALDO], [NU_IMPO_SUBTOTAL], [NU_IMPO_DSCTO], [CH_CODI_USUA_DSCTO], [VC_DESC_DSCTO], [CH_ESTA_TICKET], [ch_tipo_vehiculo], [ch_codi_garita_sld], [dt_fech_turno_sld], [ch_codi_turno_sld], [dt_fech_emision_sld], [ch_codi_cajero_sld], [ch_codi_usua_modi_sld], [dt_fech_usua_modi_sld], [nu_impo_dia_frccn], [nu_impo_noche_frccn], [nu_cant_dia_frccn], [nu_cant_noche_frccn], [nu_impo_paga], [nu_impo_vuelto]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11, @P_12, @P_13, @P_14, @P_15, @P_16, @P_17, @P_18, @P_19, @P_20, @P_21, @P_22, @P_23, @P_24, @P_25, @P_26, @P_27, @P_28, @P_29, @P_30, @P_31, @P_32, @P_33, @P_34, @P_35, @P_36, @P_37, @P_38, @P_39, @P_40, @P_41, @P_42, @P_43, @P_44, @P_45, @P_46, @P_47, @P_48, @P_49, @P_50, @P_51, @P_52, @P_53, @P_54, @P_55, @P_56, @P_57, @P_58);  SET @sync_row_count = @@rowcount;  END 
END
GO
/****** Object:  StoredProcedure [DataSync].[MOV_TICKET_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MOV_TICKET_dss_insertmetadata]
	@P_1 Int,
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[MOV_TICKET_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_TICKET] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[MOV_TICKET_dss_tracking] ([NU_CODI_TICKET], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_1, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[MOV_TICKET_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MOV_TICKET_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[NU_CODI_TICKET], [base].[CH_CODI_GARITA], [base].[DT_FECH_EMISION], [base].[DT_FECH_TURNO], [base].[CH_CODI_TURNO_CAJA], [base].[CH_CODI_VEHICULO], [base].[CH_CODI_CLIENTE], [base].[CH_CODI_CHOFER], [base].[DT_FECH_INGRESO], [base].[CH_NUME_TELEFONO], [base].[CH_ESTA_DUERMEN], [base].[CH_ESTA_LLAVE], [base].[VC_OBSE_TCKT_INGRESO], [base].[CH_CODI_CAJERO], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_ESTA_ACTIVO], [base].[CH_TIPO_COMPROBANTE], [base].[NU_IMPO_TOTAL], [base].[CH_ESTA_CLIENTE_VIP], [base].[DT_FECH_SALIDA], [base].[CH_CODI_TARIFARIO], [base].[NU_IMPO_DIA], [base].[NU_IMPO_NOCHE], [base].[NU_CANT_DIA], [base].[NU_CANT_NOCHE], [base].[NU_TOTA_DIA], [base].[NU_TOTA_NOCHE], [base].[CH_ESTA_CONDICION], [base].[CH_ESTA_CANCELADO], [base].[DT_FECH_CANCELADO], [base].[CH_OBSE_TCKT_SALIDA], [base].[CH_ESTA_INCIDENTE], [base].[CH_CODI_TIPO_INCIDENTE], [base].[CH_SERI_TCKT], [base].[CH_NUME_TCKT], [base].[NU_IMPO_SALDO], [base].[NU_IMPO_SUBTOTAL], [base].[NU_IMPO_DSCTO], [base].[CH_CODI_USUA_DSCTO], [base].[VC_DESC_DSCTO], [base].[CH_ESTA_TICKET], [base].[ch_tipo_vehiculo], [base].[ch_codi_garita_sld], [base].[dt_fech_turno_sld], [base].[ch_codi_turno_sld], [base].[dt_fech_emision_sld], [base].[ch_codi_cajero_sld], [base].[ch_codi_usua_modi_sld], [base].[dt_fech_usua_modi_sld], [base].[nu_impo_dia_frccn], [base].[nu_impo_noche_frccn], [base].[nu_cant_dia_frccn], [base].[nu_cant_noche_frccn], [base].[nu_impo_paga], [base].[nu_impo_vuelto], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MOV_TICKET] [base] RIGHT JOIN [DataSync].[MOV_TICKET_dss_tracking] [side] ON [base].[NU_CODI_TICKET] = [side].[NU_CODI_TICKET]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[MOV_TICKET_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MOV_TICKET_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[NU_CODI_TICKET], [base].[CH_CODI_GARITA], [base].[DT_FECH_EMISION], [base].[DT_FECH_TURNO], [base].[CH_CODI_TURNO_CAJA], [base].[CH_CODI_VEHICULO], [base].[CH_CODI_CLIENTE], [base].[CH_CODI_CHOFER], [base].[DT_FECH_INGRESO], [base].[CH_NUME_TELEFONO], [base].[CH_ESTA_DUERMEN], [base].[CH_ESTA_LLAVE], [base].[VC_OBSE_TCKT_INGRESO], [base].[CH_CODI_CAJERO], [base].[CH_CODI_USUA_REGI], [base].[CH_CODI_USUA_MODI], [base].[DT_FECH_USUA_REGI], [base].[DT_FECH_USUA_MODI], [base].[CH_ESTA_ACTIVO], [base].[CH_TIPO_COMPROBANTE], [base].[NU_IMPO_TOTAL], [base].[CH_ESTA_CLIENTE_VIP], [base].[DT_FECH_SALIDA], [base].[CH_CODI_TARIFARIO], [base].[NU_IMPO_DIA], [base].[NU_IMPO_NOCHE], [base].[NU_CANT_DIA], [base].[NU_CANT_NOCHE], [base].[NU_TOTA_DIA], [base].[NU_TOTA_NOCHE], [base].[CH_ESTA_CONDICION], [base].[CH_ESTA_CANCELADO], [base].[DT_FECH_CANCELADO], [base].[CH_OBSE_TCKT_SALIDA], [base].[CH_ESTA_INCIDENTE], [base].[CH_CODI_TIPO_INCIDENTE], [base].[CH_SERI_TCKT], [base].[CH_NUME_TCKT], [base].[NU_IMPO_SALDO], [base].[NU_IMPO_SUBTOTAL], [base].[NU_IMPO_DSCTO], [base].[CH_CODI_USUA_DSCTO], [base].[VC_DESC_DSCTO], [base].[CH_ESTA_TICKET], [base].[ch_tipo_vehiculo], [base].[ch_codi_garita_sld], [base].[dt_fech_turno_sld], [base].[ch_codi_turno_sld], [base].[dt_fech_emision_sld], [base].[ch_codi_cajero_sld], [base].[ch_codi_usua_modi_sld], [base].[dt_fech_usua_modi_sld], [base].[nu_impo_dia_frccn], [base].[nu_impo_noche_frccn], [base].[nu_cant_dia_frccn], [base].[nu_cant_noche_frccn], [base].[nu_impo_paga], [base].[nu_impo_vuelto], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[MOV_TICKET] [base] RIGHT JOIN [DataSync].[MOV_TICKET_dss_tracking] [side] ON [base].[NU_CODI_TICKET] = [side].[NU_CODI_TICKET] WHERE [side].[NU_CODI_TICKET]  = @P_1
END
GO
/****** Object:  StoredProcedure [DataSync].[MOV_TICKET_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MOV_TICKET_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 Char(3),
	@P_3 DateTime,
	@P_4 DateTime,
	@P_5 Char(2),
	@P_6 Char(6),
	@P_7 Char(4),
	@P_8 Char(4),
	@P_9 DateTime,
	@P_10 Char(20),
	@P_11 Char(1),
	@P_12 Char(1),
	@P_13 VarChar(100),
	@P_14 Char(15),
	@P_15 Char(15),
	@P_16 Char(15),
	@P_17 DateTime,
	@P_18 DateTime,
	@P_19 Char(1),
	@P_20 Char(2),
	@P_21 Decimal(12,3),
	@P_22 Char(1),
	@P_23 DateTime,
	@P_24 Char(6),
	@P_25 Decimal(12,3),
	@P_26 Decimal(12,3),
	@P_27 Decimal(12,3),
	@P_28 Decimal(12,3),
	@P_29 Decimal(12,3),
	@P_30 Decimal(12,3),
	@P_31 Char(1),
	@P_32 Char(1),
	@P_33 DateTime,
	@P_34 VarChar(100),
	@P_35 Char(1),
	@P_36 Char(3),
	@P_37 Char(4),
	@P_38 Char(10),
	@P_39 Decimal(12,3),
	@P_40 Decimal(12,3),
	@P_41 Decimal(12,3),
	@P_42 Char(15),
	@P_43 VarChar(100),
	@P_44 Char(1),
	@P_45 Char(2),
	@P_46 Char(3),
	@P_47 DateTime,
	@P_48 Char(2),
	@P_49 DateTime,
	@P_50 Char(15),
	@P_51 Char(15),
	@P_52 DateTime,
	@P_53 Decimal(12,3),
	@P_54 Decimal(12,3),
	@P_55 Decimal(12,3),
	@P_56 Decimal(12,3),
	@P_57 Decimal(12,3),
	@P_58 Decimal(12,3),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[MOV_TICKET] SET [CH_CODI_GARITA] = @P_2, [DT_FECH_EMISION] = @P_3, [DT_FECH_TURNO] = @P_4, [CH_CODI_TURNO_CAJA] = @P_5, [CH_CODI_VEHICULO] = @P_6, [CH_CODI_CLIENTE] = @P_7, [CH_CODI_CHOFER] = @P_8, [DT_FECH_INGRESO] = @P_9, [CH_NUME_TELEFONO] = @P_10, [CH_ESTA_DUERMEN] = @P_11, [CH_ESTA_LLAVE] = @P_12, [VC_OBSE_TCKT_INGRESO] = @P_13, [CH_CODI_CAJERO] = @P_14, [CH_CODI_USUA_REGI] = @P_15, [CH_CODI_USUA_MODI] = @P_16, [DT_FECH_USUA_REGI] = @P_17, [DT_FECH_USUA_MODI] = @P_18, [CH_ESTA_ACTIVO] = @P_19, [CH_TIPO_COMPROBANTE] = @P_20, [NU_IMPO_TOTAL] = @P_21, [CH_ESTA_CLIENTE_VIP] = @P_22, [DT_FECH_SALIDA] = @P_23, [CH_CODI_TARIFARIO] = @P_24, [NU_IMPO_DIA] = @P_25, [NU_IMPO_NOCHE] = @P_26, [NU_CANT_DIA] = @P_27, [NU_CANT_NOCHE] = @P_28, [NU_TOTA_DIA] = @P_29, [NU_TOTA_NOCHE] = @P_30, [CH_ESTA_CONDICION] = @P_31, [CH_ESTA_CANCELADO] = @P_32, [DT_FECH_CANCELADO] = @P_33, [CH_OBSE_TCKT_SALIDA] = @P_34, [CH_ESTA_INCIDENTE] = @P_35, [CH_CODI_TIPO_INCIDENTE] = @P_36, [CH_SERI_TCKT] = @P_37, [CH_NUME_TCKT] = @P_38, [NU_IMPO_SALDO] = @P_39, [NU_IMPO_SUBTOTAL] = @P_40, [NU_IMPO_DSCTO] = @P_41, [CH_CODI_USUA_DSCTO] = @P_42, [VC_DESC_DSCTO] = @P_43, [CH_ESTA_TICKET] = @P_44, [ch_tipo_vehiculo] = @P_45, [ch_codi_garita_sld] = @P_46, [dt_fech_turno_sld] = @P_47, [ch_codi_turno_sld] = @P_48, [dt_fech_emision_sld] = @P_49, [ch_codi_cajero_sld] = @P_50, [ch_codi_usua_modi_sld] = @P_51, [dt_fech_usua_modi_sld] = @P_52, [nu_impo_dia_frccn] = @P_53, [nu_impo_noche_frccn] = @P_54, [nu_cant_dia_frccn] = @P_55, [nu_cant_noche_frccn] = @P_56, [nu_impo_paga] = @P_57, [nu_impo_vuelto] = @P_58 FROM [dbo].[MOV_TICKET] [base] JOIN [DataSync].[MOV_TICKET_dss_tracking] [side] ON [base].[NU_CODI_TICKET] = [side].[NU_CODI_TICKET] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[NU_CODI_TICKET] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[MOV_TICKET_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[MOV_TICKET_dss_updatemetadata]
	@P_1 Int,
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[MOV_TICKET_dss_tracking] WHERE ([NU_CODI_TICKET] = @P_1);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[MOV_TICKET_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_TICKET] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[MOV_TICKET_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([NU_CODI_TICKET] = @P_1) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[sysdiagrams_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[sysdiagrams_dss_delete_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_2 Int,
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [dbo].[sysdiagrams] FROM [dbo].[sysdiagrams] [base] JOIN [DataSync].[sysdiagrams_dss_tracking] [side] ON [base].[diagram_id] = [side].[diagram_id] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[diagram_id] = @P_2); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[sysdiagrams_dss_deletemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[sysdiagrams_dss_deletemetadata]
	@P_2 Int,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[sysdiagrams_dss_tracking] [side] WHERE [diagram_id] = @P_2 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT ;

END
GO
/****** Object:  StoredProcedure [DataSync].[sysdiagrams_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[sysdiagrams_dss_insert_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 Int,
	@P_3 Int,
	@P_4 VarBinary(max),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF NOT EXISTS (SELECT * FROM [DataSync].[sysdiagrams_dss_tracking] WHERE [diagram_id] = @P_2)
BEGIN 
SET IDENTITY_INSERT [dbo].[sysdiagrams] ON; INSERT INTO [dbo].[sysdiagrams]([principal_id], [diagram_id], [version], [definition]) VALUES (@P_1, @P_2, @P_3, @P_4);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[sysdiagrams] OFF; END 
END
GO
/****** Object:  StoredProcedure [DataSync].[sysdiagrams_dss_insertmetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[sysdiagrams_dss_insertmetadata]
	@P_2 Int,
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [DataSync].[sysdiagrams_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([diagram_id] = @P_2) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT;IF (@sync_row_count = 0) BEGIN INSERT INTO [DataSync].[sysdiagrams_dss_tracking] ([diagram_id], [create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [scope_update_peer_key], [scope_update_peer_timestamp], [local_update_peer_key], [restore_timestamp], [sync_row_is_tombstone], [last_change_datetime]) VALUES (@P_2, @sync_scope_local_id, @sync_create_peer_key, @sync_create_peer_timestamp, 0, CAST(@@DBTS AS BIGINT) + 1, @sync_scope_local_id, @sync_update_peer_key, @sync_update_peer_timestamp, 0, NULL, @sync_row_is_tombstone, GETDATE());SET @sync_row_count = @@ROWCOUNT; END;
END
GO
/****** Object:  StoredProcedure [DataSync].[sysdiagrams_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[sysdiagrams_dss_selectchanges_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int,
	@sync_update_peer_key Int
AS
BEGIN

SELECT [side].[diagram_id], [base].[principal_id], [base].[version], [base].[definition], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[sysdiagrams] [base] RIGHT JOIN [DataSync].[sysdiagrams_dss_tracking] [side] ON [base].[diagram_id] = [side].[diagram_id]
 WHERE 
 ([side].[update_scope_local_id] IS NULL OR [side].[update_scope_local_id] <> @sync_scope_local_id OR ([side].[update_scope_local_id] = @sync_scope_local_id AND [side].[scope_update_peer_key] <> @sync_update_peer_key)) AND [side].[local_update_peer_timestamp] > @sync_min_timestamp
END
GO
/****** Object:  StoredProcedure [DataSync].[sysdiagrams_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[sysdiagrams_dss_selectrow_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_2 Int,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
AS
BEGIN
SELECT [side].[diagram_id], [base].[principal_id], [base].[version], [base].[definition], [side].[sync_row_is_tombstone] as sync_row_is_tombstone, [side].[local_update_peer_timestamp] as sync_row_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then COALESCE([restore_timestamp], [side].[local_update_peer_timestamp]) else [side].[scope_update_peer_timestamp] end as sync_update_peer_timestamp, case when ([side].[update_scope_local_id] is null or [side].[update_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_update_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_update_peer_key] end else [side].[scope_update_peer_key] end as sync_update_peer_key, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then [side].[local_create_peer_timestamp] else [side].[scope_create_peer_timestamp] end as sync_create_peer_timestamp, case when ([side].[create_scope_local_id] is null or [side].[create_scope_local_id] <> @sync_scope_local_id) then case when ([side].[local_create_peer_key] > @sync_scope_restore_count) then @sync_scope_restore_count else [side].[local_create_peer_key] end else [side].[scope_create_peer_key] end as sync_create_peer_key FROM [dbo].[sysdiagrams] [base] RIGHT JOIN [DataSync].[sysdiagrams_dss_tracking] [side] ON [base].[diagram_id] = [side].[diagram_id] WHERE [side].[diagram_id]  = @P_2
END
GO
/****** Object:  StoredProcedure [DataSync].[sysdiagrams_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[sysdiagrams_dss_update_02cfe19c-dea3-4cc5-816b-cd97583976ba]
	@P_1 Int,
	@P_2 Int,
	@P_3 Int,
	@P_4 VarBinary(max),
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; UPDATE [dbo].[sysdiagrams] SET [principal_id] = @P_1, [version] = @P_3, [definition] = @P_4 FROM [dbo].[sysdiagrams] [base] JOIN [DataSync].[sysdiagrams_dss_tracking] [side] ON [base].[diagram_id] = [side].[diagram_id] WHERE ([side].[local_update_peer_timestamp] <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[diagram_id] = @P_2); SET @sync_row_count = @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [DataSync].[sysdiagrams_dss_updatemetadata]    Script Date: 10/03/2026 15:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DataSync].[sysdiagrams_dss_updatemetadata]
	@P_2 Int,
	@sync_scope_local_id Int,
	@sync_row_is_tombstone Int,
	@sync_create_peer_key Int,
	@sync_create_peer_timestamp BigInt,
	@sync_update_peer_key Int,
	@sync_update_peer_timestamp BigInt,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DECLARE @was_tombstone int; SELECT @was_tombstone = [sync_row_is_tombstone] FROM [DataSync].[sysdiagrams_dss_tracking] WHERE ([diagram_id] = @P_2);IF (@was_tombstone IS NOT NULL AND @was_tombstone = 1 AND @sync_row_is_tombstone = 0) BEGIN UPDATE [DataSync].[sysdiagrams_dss_tracking] SET [create_scope_local_id] = @sync_scope_local_id, [scope_create_peer_key] = @sync_create_peer_key, [scope_create_peer_timestamp] = @sync_create_peer_timestamp, [local_create_peer_key] = 0, [local_create_peer_timestamp] = CAST(@@DBTS AS BIGINT) + 1, [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([diagram_id] = @P_2) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp); END ELSE BEGIN UPDATE [DataSync].[sysdiagrams_dss_tracking] SET [update_scope_local_id] = @sync_scope_local_id, [scope_update_peer_key] = @sync_update_peer_key, [scope_update_peer_timestamp] = @sync_update_peer_timestamp, [local_update_peer_key] = 0, [restore_timestamp] = NULL, [sync_row_is_tombstone] = @sync_row_is_tombstone WHERE ([diagram_id] = @P_2) AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = @@ROWCOUNT; END;
END
GO
USE [master]
GO
ALTER DATABASE [BD_SISCO] SET  READ_WRITE 
GO
