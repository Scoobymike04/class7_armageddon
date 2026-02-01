{  
    "SecurityGroups": \[  
        {  
            "GroupId": "sg-07a0e3467ea475eed",  
            "IpPermissionsEgress": \[  
                {  
                    "IpProtocol": "-1",  
                    "UserIdGroupPairs": \[\],  
                    "IpRanges": \[  
                        {  
                            "CidrIp": "0.0.0.0/0"  
                        }  
                    \],  
                    "Ipv6Ranges": \[\],  
                    "PrefixListIds": \[\]  
                }  
            \],  
            "VpcId": "vpc-09d18cc58fb43d1d0",  
            "SecurityGroupArn": "arn:aws:ec2:us-east-1:279019749553:security-group/sg-07a0e3467ea475eed",  
            "OwnerId": "279019749553",  
            "GroupName": "arm1a-b",  
            "Description": "HTTP and SSH",  
            "IpPermissions": \[  
                {  
                    "IpProtocol": "tcp",  
                    "FromPort": 80,  
                    "ToPort": 80,  
                    "UserIdGroupPairs": \[\],  
                    "IpRanges": \[  
                        {  
                            "CidrIp": "0.0.0.0/0"  
                        }  
                    \],  
                    "Ipv6Ranges": \[\],  
                    "PrefixListIds": \[\]  
                },  
                {  
                    "IpProtocol": "tcp",  
                    "FromPort": 22,  
                    "ToPort": 22,  
                    "UserIdGroupPairs": \[\],  
                    "IpRanges": \[  
                        {  
                            "CidrIp": "0.0.0.0/0"  
                        }  
                    \],  
                    "Ipv6Ranges": \[\],  
                    "PrefixListIds": \[\]  
                }  
            \]  
        }  
    \]  
}  
