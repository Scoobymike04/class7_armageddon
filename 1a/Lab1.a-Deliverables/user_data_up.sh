\#\!/bin/bash  
dnf update \-y  
dnf install \-y python3-pip  
pip3 install flask pymysql boto3  
dnf install mariadb105 \-y        \#installs MariaDB Client on EC2

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
    try:  
        \# Get Creds from secret smanager  
        c \= get\_db\_creds()  
        host \= c\["host"\]  
        user \= c\["username"\]  
        password \= c\["password"\]  
        port \= int(c.get("port", 3306))

        \# Connect to databse  
        conn \= pymysql.connect(host=host, user=user, password=password, port=port, autocommit=True)  
        cur \= conn.cursor()

        \# Create DB & Table  
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
        return "SUCCESS: Initialized labdb \+ notes table."

    except Exception as e:  
        \# This prints the ACTUAL error to the browser window  
        return f"FAILED: {str(e)}", 500

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
