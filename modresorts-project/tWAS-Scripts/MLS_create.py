# Create a managed liberty server
AdminTask.createManagedLibertyServer('AppSrv01Node1', ['-name', 'txc'])
AdminConfig.save()

