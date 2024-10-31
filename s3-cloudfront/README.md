# Deploying a Cloudfront distribution for S3 Static Websites using Terraform

The frontend applications for the following ```RAZED House Games``` will be hosted on an AWS S3 bucket:
- Dice
- Keno
- Limbo
- Mines
- Plinko

The static websites can be accessed thru the Cloudfront distribution domain name, as well as the alternate domain name. 

### Architecture Diagram:

![alt text](/images/diagram.png)

### Step 1: Create an S3 bucket with unique name and host static website by uploading files

./modules/s3-static-website/main.tf

### Step 2: Create a cloudfront distribution 

./modules/cloud-front/main.tf

### Step 3: Update S3 Bucket policy to allow access from cloudfront 

./modules/s3-cf-policy/main.tf

### Terraform Apply Output:
```
Apply complete! Resources: 11 added, 0 changed, 0 destroyed.

Outputs:

alternate_domain_name = "http://house-games-dev.razed.com"
cloudfront_domain_name = "http://d1omkdrv4lqs4x.cloudfront.net"
s3_bucket_name = "dev-london-h0us3-g4m3s-fr0nt3nd"
```

S3 Bucket

![alt text](/images/s3bucket.png)

Block public access:

![alt text](/images/s3blockpublicaccess.png)

Static Website setting:

![alt text](/images/s3staticweb.png)

CloudFront Distribution:

![alt text](/images/cfdist.png)

CloudFront Distribution Origin as S3 with Origin Access Control OAC:

![alt text](/images/s3oac.png)

S3 Bucket Policy to allow access from cloudfront 

![alt text](/images/s3policy.png)

Using cloudfront domain name to access S3 static website

![alt text](/images/website1.png)

### Terraform Destroy Output:
```
Destroy complete! Resources: 9 destroyed.
```

### Notes:
1. Cache Invalidation can be forced from console for a cloudfront distribution
2. Deprecated Origin Access Identity OAI also can be used instead of Origin Access Cotnrol OAC

### Test:
 ```
 aws s3 cp --recursive ./test s3://dev-london-h0us3-g4m3s-fr0nt3nd/dice
 ```