# Hive to Synapse

## Using Azure Data Factory

If you want to use ADF you can follow this guide:

https://docs.microsoft.com/en-us/azure/data-factory/connector-hive?tabs=data-factory

## Using Hive Command Line

if you want to do it manually you can following the next steps:

1.Create user from the HDP sandbox on the azure deployment configuration or reset the password:

![create sandbox and user](https://user-images.githubusercontent.com/7907123/156600810-15bda27f-b015-46cf-82e8-914a03594b42.png)


![User creation](https://user-images.githubusercontent.com/7907123/156598598-7a5e7f39-9807-4ce1-b910-0da3f3093b20.png)

2.Accessing via Putty or other ssh terminal configuring a tunnel to get access to the VM:

![putty](https://user-images.githubusercontent.com/7907123/156598922-7f3ed2d6-eef3-434e-9ecb-ec6e15d85eb4.png)

3.Getting access from the website using the IP of the tunnel and the port 127.0.0.1:4200




4.Use the User root and change the password

![sandbox website](https://user-images.githubusercontent.com/7907123/156598978-2bc83363-598e-4346-8113-a41ac62717d4.png)

5.Access Hive and check the DB to export

![Hive](https://user-images.githubusercontent.com/7907123/156599505-baa24405-62c7-49fa-883e-6b4d2083c9ed.png)

6.Use the following command to expeort into a CSV the DB and get the file from the sandbox using sFTP connection
```
 hive -f "select * from db.table" >> expoerthivedb.csv
```

7.Import the DB's into Synpse using the import button:

![synapse](https://user-images.githubusercontent.com/7907123/156605005-9f8ed058-0db3-4f83-98ff-a25cf4d6d043.png)









