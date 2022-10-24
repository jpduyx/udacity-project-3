DROP EXTERNAL TABLE [dbo].[station]
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
		LOCATION = 'abfss://synapse4divvyfs@synapse4divvystorage.dfs.core.windows.netsynapse4divvyfs/', 
		TYPE = HADOOP 
	)
GO

CREATE EXTERNAL TABLE station (
	[id] nvarchar(4000),
	[name] nvarchar(4000),
	[latitude] float,
	[longitude] float
	)
	WITH (
	LOCATION = 'station/publicstation.txt',
	DATA_SOURCE = [synapse4divvyfs_synapse4divvystorage_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.station
GO