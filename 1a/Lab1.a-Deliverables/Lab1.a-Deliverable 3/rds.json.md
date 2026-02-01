{  
    "DBInstances": \[  
        {  
            "DBInstanceIdentifier": "lab-mysql",  
            "DBInstanceClass": "db.t4g.micro",  
            "Engine": "mysql",  
            "DBInstanceStatus": "available",  
            "MasterUsername": "admin",  
            "Endpoint": {  
                "Address": "lab-mysql.cav6w4c8a739.us-east-1.rds.amazonaws.com",  
                "Port": 3306,  
                "HostedZoneId": "Z2R2ITUGPM61AM"  
            },  
            "AllocatedStorage": 400,  
            "InstanceCreateTime": "2026-01-18T17:22:55.948000+00:00",  
            "PreferredBackupWindow": "06:51-07:21",  
            "BackupRetentionPeriod": 1,  
            "DBSecurityGroups": \[\],  
            "VpcSecurityGroups": \[  
                {  
                    "VpcSecurityGroupId": "sg-07a8287f2a2e077f7",  
                    "Status": "active"  
                },  
                {  
                    "VpcSecurityGroupId": "sg-014f8b49d2ccdf668",  
                    "Status": "active"  
                }  
            \],  
            "DBParameterGroups": \[  
                {  
                    "DBParameterGroupName": "default.mysql8.0",  
                    "ParameterApplyStatus": "in-sync"  
                }  
            \],  
            "AvailabilityZone": "us-east-1a",  
            "DBSubnetGroup": {  
                "DBSubnetGroupName": "rds-ec2-db-subnet-group-2",  
                "DBSubnetGroupDescription": "Created from the RDS Management Console",  
                "VpcId": "vpc-09d18cc58fb43d1d0",  
                "SubnetGroupStatus": "Complete",  
                "Subnets": \[  
                    {  
                        "SubnetIdentifier": "subnet-0ada9485580275f5b",  
                        "SubnetAvailabilityZone": {  
                            "Name": "us-east-1f"  
                        },  
                        "SubnetOutpost": {},  
                        "SubnetStatus": "Active"  
                    },  
                    {  
                        "SubnetIdentifier": "subnet-06be3047922825855",  
                        "SubnetAvailabilityZone": {  
                            "Name": "us-east-1e"  
                        },  
                        "SubnetOutpost": {},  
                        "SubnetStatus": "Active"  
                    },  
                    {  
                        "SubnetIdentifier": "subnet-0b474dcb599fbcd2a",  
                        "SubnetAvailabilityZone": {  
                            "Name": "us-east-1b"  
                        },  
                        "SubnetOutpost": {},  
                        "SubnetStatus": "Active"  
                    },  
                    {  
                        "SubnetIdentifier": "subnet-039ed1c5fe1d33c27",  
                        "SubnetAvailabilityZone": {  
                            "Name": "us-east-1a"  
                        },  
                        "SubnetOutpost": {},  
                        "SubnetStatus": "Active"  
                    },  
                    {  
                        "SubnetIdentifier": "subnet-09f7997d6d8648740",  
                        "SubnetAvailabilityZone": {  
                            "Name": "us-east-1d"  
                        },  
                        "SubnetOutpost": {},  
                        "SubnetStatus": "Active"  
                    }  
                \]  
            },  
            "PreferredMaintenanceWindow": "sat:07:54-sat:08:24",  
            "UpgradeRolloutOrder": "second",  
            "PendingModifiedValues": {},  
            "LatestRestorableTime": "2026-01-25T07:10:00+00:00",  
            "MultiAZ": false,  
            "EngineVersion": "8.0.43",  
            "AutoMinorVersionUpgrade": true,  
            "ReadReplicaDBInstanceIdentifiers": \[\],  
            "LicenseModel": "general-public-license",  
            "StorageThroughput": 0,  
            "OptionGroupMemberships": \[  
                {  
                    "OptionGroupName": "default:mysql-8-0",  
                    "Status": "in-sync"  
                }  
            \],  
            "PubliclyAccessible": false,  
            "StorageType": "gp2",  
            "DbInstancePort": 0,  
            "StorageEncrypted": true,  
            "KmsKeyId": "arn:aws:kms:us-east-1:279019749553:key/6276d14d-b433-4e7b-a231-84bf419d62fb",  
            "DbiResourceId": "db-4ODKNGJAFMOID7ZAUZPZDRQXJU",  
            "CACertificateIdentifier": "rds-ca-rsa2048-g1",  
            "DomainMemberships": \[\],  
            "CopyTagsToSnapshot": true,  
            "MonitoringInterval": 0,  
            "DBInstanceArn": "arn:aws:rds:us-east-1:279019749553:db:lab-mysql",  
            "IAMDatabaseAuthenticationEnabled": false,  
            "DatabaseInsightsMode": "standard",  
            "PerformanceInsightsEnabled": false,  
            "EnabledCloudwatchLogsExports": \[  
                "audit",  
                "error",  
                "general",  
                "iam-db-auth-error",  
                "slowquery"  
            \],  
            "DeletionProtection": false,  
            "AssociatedRoles": \[\],  
            "MaxAllocatedStorage": 1000,  
            "TagList": \[\],  
            "CustomerOwnedIpEnabled": false,  
            "NetworkType": "IPV4",  
            "ActivityStreamStatus": "stopped",  
            "BackupTarget": "region",  
            "CertificateDetails": {  
                "CAIdentifier": "rds-ca-rsa2048-g1",  
                "ValidTill": "2027-01-18T17:21:37+00:00"  
            },  
            "DedicatedLogVolume": false,  
            "IsStorageConfigUpgradeAvailable": false,  
            "EngineLifecycleSupport": "open-source-rds-extended-support-disabled"  
        }  
    \]  
}  
