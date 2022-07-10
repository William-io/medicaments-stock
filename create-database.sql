CREATE DATABASE [Medicaments-Stock]
GO

USE [Medicaments-Stock]
GO

CREATE TABLE [Medication]
(
    [Id] uniqueidentifier NOT NULL,
    [Name] NVARCHAR(120) NOT NULL,
    [Dosage] NVARCHAR(180) NOT NULL,
    [Strength] NVARCHAR(20) NULL,
    [Route] NVARCHAR(20) NULL,
    [Marketing_Start] DATETIME NULL,
    [CreateDate] DATETIME NOT NULL DEFAULT(GETDATE()),
    CONSTRAINT [PK_Medication] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Reference]
(
    [Id] uniqueidentifier NOT NULL,
    [Name] NVARCHAR(80) NOT NULL,
    [Title] NVARCHAR(80) NOT NULL,
    [Bio] NVARCHAR(2000) NOT NULL,
    [Url_Article] nvarchar(450) NULL,
    [Type] TINYINT NOT NULL, -- 0 a 255
    CONSTRAINT [PK_Reference] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Pharmacology]
(
    [Id] uniqueidentifier NOT NULL,
    [Indication] NVARCHAR(2000) NOT NULL,
    [Associated_Conditions] NVARCHAR(2000) NOT NULL,
    [Associated_Therapies] NVARCHAR(1024) NOT NULL,
    [Active] BIT NOT NULL,
    [Tags] NVARCHAR(160) NOT NULL,
    CONSTRAINT [PK_Pharmacology] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Category]
(
    [Id] uniqueidentifier NOT NULL,
    [Title] NVARCHAR(160) NOT NULL,
    [Url] NVARCHAR(1024) NOT NULL,
    [Order] int NOT NULL,
    [Description] TEXT NOT NULL,
    CONSTRAINT [PK_Category] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Identification]
(
    [Id] uniqueidentifier NOT NULL,
    [Tag] NVARCHAR(20) NOT NULL,
    [Brand_Names] NVARCHAR(160) NOT NULL,
    [Summary] NVARCHAR(2000) NOT NULL,
    [Generic_Name] NVARCHAR(1024) NOT NULL,
    [Background] NVARCHAR(2000) NOT NULL,
    [Synonyms] NVARCHAR(1024) NOT NULL,
    [ReferenceId] uniqueidentifier NOT NULL,
    [CategoryId] uniqueidentifier NOT NULL,
    [Tags] NVARCHAR(160) NOT NULL,
    CONSTRAINT [PK_Identification] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Identification_Reference_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [Reference] ([Id]),
    CONSTRAINT [FK_Identification_Category_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [Category] ([Id])
);
GO

CREATE TABLE [PharmacologyItem]
(
    [PharmacologyId] uniqueidentifier NOT NULL,
    [IdentificationId] uniqueidentifier NOT NULL,
    [Description] TEXT NOT NULL,
    [Cost] DECIMAL NOT NULL,
    [Unit] NVARCHAR(160) NOT NULL,
    
    CONSTRAINT [PK_PharmacologyItem] PRIMARY KEY ([IdentificationId], [PharmacologyId]),
    CONSTRAINT [FK_PharmacologyItem_Pharmacology_PharmacologyId] FOREIGN KEY ([PharmacologyId]) REFERENCES [Pharmacology] ([Id]),
    CONSTRAINT [FK_PharmacologyItem_Identification_IdentificationId] FOREIGN KEY ([IdentificationId]) REFERENCES [Identification] ([Id])
);
GO

CREATE TABLE [MedicationIdentification]
(
    [IdentificationId] uniqueidentifier NOT NULL,
    [MedicationId] uniqueidentifier NOT NULL,
    [Progress] TINYINT NOT NULL,
    [Favorite] BIT NOT NULL,
    [StartDate] DATETIME NOT NULL,
    [LastUpdateDate] DATETIME NULL DEFAULT(GETDATE()),
    CONSTRAINT [PK_MedicationIdentification] PRIMARY KEY ([IdentificationId], [MedicationId]),
    CONSTRAINT [FK_MedicationIdentification_Identification_IdentificationId] FOREIGN KEY ([IdentificationId]) REFERENCES [Identification] ([Id]),
    CONSTRAINT [FK_MedicationIdentification_Medication_MedicationId] FOREIGN KEY ([MedicationId]) REFERENCES [Medication] ([Id])
);
GO