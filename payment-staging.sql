DROP EXTERNAL TABLE [dbo].[payment]
 GO
 
IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ';',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'synapse4divvyfs_synapse4divvystorage_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [synapse4divvyfs_synapse4divvystorage_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://synapse4divvyfs@synapse4divvystorage.dfs.core.windows.net', 
		TYPE = HADOOP 
	)
GO

CREATE EXTERNAL TABLE payment (
	[id] int,
	[date] nvarchar(40),
	[amount] float,
	[account_nr] int
	)
	WITH (
	LOCATION = 'payment',
	DATA_SOURCE = [synapse4divvyfs_synapse4divvystorage_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.payment
GO