Steps:

1\. Create VPC:    
  - choose VPC and more    
  - select VPC CIDR block    
  - choose at least \*\*2\*\* AZ's (the RdDS DB, requires at least two. us-east-1a and 1b)    
  - Set each subnet CIDR block    
  - NAT gateway is not needed for the this simple setup (pubic subnet EC2 will use IGW)    
  - S3 Gateway not needed    
  - Enable DNS Hostnames & DNS Resolution    
    
2\. Create  security group:    
  - This is for EC2 to be accessible by HTTP and SSH    
  - Allows IPv4 anywhere for inbound HTTP and SSH (you can limit to your IP)    
    
1\. Policy & Roles to allows EC2 to get secret:    
	1\. Iam  
	2\. create policy and then role  
  - For this will create the need permissions policy first, then attach it to the role along with the proper principal,    
  - permission policy:    
{  
    "Version": "2012-10-17",  
    "Statement": \[  
        {  
            "Sid": "ReadOnlyListActions",  
            "Effect": "Allow",  
            "Action": \[  
                "ec2:DescribeInstances",  
                "ec2:DescribeSecurityGroups",  
                "rds:DescribeDBInstances"  
            \],  
            "Resource": "\*"  
        },  
        {  
            "Sid": "ReadSpecificSecret",  
            "Effect": "Allow",  
            "Action": \[  
                "secretsmanager:GetSecretValue"  
            \],  
            "Resource": "arn:aws:secretsmanager:\`\<REGION\>\`:\<account\_id\>:secret:lab/rds/mysql\*"  
        }  
    \]  
}  
N.B. Ensure to make the necessary changes for \`\<REGION\>\` and \`\<ACCOUNT\_ID\>\`, also take note of the \`lab/rds/mysql\` as this needs to be the exact secrets name in Secrets Manager.    
    
4\. EC2 creations:    
  - Default setting for AMI (Amazon Linux 2023\)    
  - Default instance type and settings    
  - create key pair    
  - Choose created VPC, public subnet, and public security group    
  - enable 'Auto-assign public IP'    
  - In advanced details select IAM instance profile (role created)  
  -   
  -   
\#\!/bin/bash  
dnf update \-y  
dnf install \-y python3-pip  
pip3 install flask pymysql boto3  
dnf install mariadb105 \-y

mkdir \-p /opt/rdsapp  
cat \>/opt/rdsapp/app.py \<\<'PY'  
import json  
import os  
import boto3  
import pymysql  
from flask import Flask, request

REGION \= os.environ.get("AWS\_REGION", "us-east-1")  
SECRET\_ID \= os.environ.get("SECRET\_ID", "lab/rds/mysql")

secrets \= boto3.client("secretsmanager", region\_name=REGION)

def get\_db\_creds():  
    resp \= secrets.get\_secret\_value(SecretId=SECRET\_ID)  
    s \= json.loads(resp\["SecretString"\])  
    \# When you use "Credentials for RDS database", AWS usually stores:  
    \# username, password, host, port, dbname (sometimes)  
    return s

def get\_conn():  
    c \= get\_db\_creds()  
    host \= c\["host"\]  
    user \= c\["username"\]  
    password \= c\["password"\]  
    port \= int(c.get("port", 3306))  
    db \= c.get("dbname", "labdb")  \# we'll create this if it doesn't exist  
    return pymysql.connect(host=host, user=user, password=password, port=port, database=db, autocommit=True)

app \= Flask(\_\_name\_\_)

@app.route("/")  
def home():  
    return """  
    \<h2\>EC2 → RDS Notes App\</h2\>  
    \<p\>POST /add?note=hello\</p\>  
    \<p\>GET /list\</p\>  
    """

@app.route("/init")  
def init\_db():  
    c \= get\_db\_creds()  
    host \= c\["host"\]  
    user \= c\["username"\]  
    password \= c\["password"\]  
    port \= int(c.get("port", 3306))

    \# connect without specifying a DB first  
    conn \= pymysql.connect(host=host, user=user, password=password, port=port, autocommit=True)  
    cur \= conn.cursor()  
    cur.execute("CREATE DATABASE IF NOT EXISTS labdb;")  
    cur.execute("USE labdb;")  
    cur.execute("""  
        CREATE TABLE IF NOT EXISTS notes (  
            id INT AUTO\_INCREMENT PRIMARY KEY,  
            note VARCHAR(255) NOT NULL  
        );  
    """)  
    cur.close()  
    conn.close()  
    return "Initialized labdb \+ notes table."

@app.route("/add", methods=\["POST", "GET"\])  
def add\_note():  
    note \= request.args.get("note", "").strip()  
    if not note:  
        return "Missing note param. Try: /add?note=hello", 400  
    conn \= get\_conn()  
    cur \= conn.cursor()  
    cur.execute("INSERT INTO notes(note) VALUES(%s);", (note,))  
    cur.close()  
    conn.close()  
    return f"Inserted note: {note}"

@app.route("/list")  
def list\_notes():  
    conn \= get\_conn()  
    cur \= conn.cursor()  
    cur.execute("SELECT id, note FROM notes ORDER BY id DESC;")  
    rows \= cur.fetchall()  
    cur.close()  
    conn.close()  
    out \= "\<h3\>Notes\</h3\>\<ul\>"  
    for r in rows:  
        out \+= f"\<li\>{r\[0\]}: {r\[1\]}\</li\>"  
    out \+= "\</ul\>"  
    return out

if \_\_name\_\_ \== "\_\_main\_\_":  
    app.run(host="0.0.0.0", port=80)  
PY

cat \>/etc/systemd/system/rdsapp.service \<\<'SERVICE'  
\[Unit\]  
Description=EC2 to RDS Notes App  
After=network.target

\[Service\]  
WorkingDirectory=/opt/rdsapp  
Environment=SECRET\_ID=lab/rds/mysql  
ExecStart=/usr/bin/python3 /opt/rdsapp/app.py  
Restart=always

\[Install\]  
WantedBy=multi-user.target  
SERVICE

systemctl daemon-reload  
systemctl enable rdsapp  
systemctl start rdsapp  
   
  - Double-check, pray, then launch instance    
    
1\. Attach role to instance:  (If you didn't add while making EC2 instance)  
  - steps \= Instance  \> Actions \> Security \> Modify IAM Role    
  - Then attach the role you just created under 'IAM Role'    
  - The click 'Update IAM Role'    
    
6\. Create RDS Database:    
  - Create subnet group  
  - Name, attach VPC, Choose AZs make sure they are available in VPC, pick subnets (DB is in private subnets), create   
  - Go to create database under 'Aurora and RDS'    
  - Go 'Full Configuration'    
  - Then "MySQL"    
  - Then Choose 'Free Tier'   
  - Single AZ  
  - Choose DB Instance Identifier ('lab-mysql')    
  - Choose Master username ('admin')    
  - Then select 'Self Managed' for 'Credentials management'    
  - Then create and remember your password ('TestArm432') {this a test, make your own}    
  - Then leave setting default until Connectivity, select "Connect to and EC2 compute resource"    
  - Choose the created EC2 under 'EC2 Instance'    
  - VPC should be automatically selected    
  - DB Subnet Group, choose automatic setup    
  - Public Access \= 'No'    
  - For VPC Security Group check 'Create New'    
  - Enable Logs then 'Create Database'    
    
7\. Create Secret in Secrets Manager    
  -  Under Secrets Manager, select 'Store a New Secret'    
  - 'Secret Type' is Credentials for Amazon RDS Database    
  - Credentials, User name \= 'admin' (or your choice)    
  - Credentials, Password \= 'you specific password'    
  - Then select your created DB, then click next    
  - Set Secret Name to be same as in policy and application script (lab/rds/mysql)    
  - Then click until you reach review (leave configuration rotation as default),    
  - Review and then 'Store' your secret.  
      
     
      
   Once in ssh  
     
   \- aws rds describe-db-instances \--db-instance-identifier lab-mysql \--query "DBInstances\[\].Endpoint"  
   \- aws secretsmanager get-secret-value \--secret-id lab/rds/mysql  
   \- mysql \-h \<RDS\_ENDPOINT\> \-u admin \-p  
   \- SHOW DATABASES;  
   \- CREATE DATABASE labdb;  
   \- sudo systemctl restart rdsapp  
   \- systemctl start rdsapp  
   \- On web page add the following with a "/" after the wed address  
   \- add?note=cloud\_labs\_are\_real  
   \- add more notes and screenshot

	Tear down  
		1\. Rds  
		2\. EC2  
		3\. VPC  
		4\. Subnet groups  
