DROP EXTERNAL TABLE [dbo].[trip]
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

CREATE EXTERNAL TABLE trip (
	[id] nvarchar(40),
	[rideable_type] nvarchar(20),
	[start_at] nvarchar(40),
	[ended_at] nvarchar(40),
	[startstation] nvarchar(4000),
	[endstation] nvarchar(4000),
	[rider_id] bigint
	)
	WITH (
	LOCATION = 'trip/publictrip.txt',
	DATA_SOURCE = [synapse4divvyfs_synapse4divvystorage_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO

SELECT TOP 100 * FROM dbo.trip
GO
