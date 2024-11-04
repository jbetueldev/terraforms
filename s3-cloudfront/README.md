# Deploying a Cloudfront distribution for S3 Static Websites using Terraform

The frontend applications for the following ```RAZED House Games``` will be hosted on an AWS S3 bucket:
- Dice
- Keno
- Limbo
- Mines
- Plinko

The static websites can be accessed thru the Cloudfront distribution domain name, as well as the alternate domain name. 

### Architecture Diagram:

![alt text](https://github.com/jbetueldev/terraforms/blob/main/s3-cloudfront/images/diagram.png)

### Step 1: Create an S3 bucket with unique name and host static website by uploading files

[s3_website module](modules/s3-static-website/main.tf)

### Step 2: Create a cloudfront distribution 

[cloud_front module](modules/cloud-front/main.tf)

### Step 3: Update S3 Bucket policy to allow access from cloudfront 

[s3_cf_policy module](modules/s3-cf-policy/main.tf)

### Step 4: Edit the corresponding default values in [variables.tf](variables.tf)

### Step 5: Create ```terraform.tfvars``` file
```
# terraform.tfvars
aws_access_key = "<YOUR-AWS-IAM-USER-CREDENTIALS>"
aws_secret_key = "<YOUR-AWS-IAM-USER-CREDENTIALS>"
aws_region     = "<AWS-REGION-TO-USE>"
```

### Step 6: Run Terraform commands
```
terraform init
```
```
terraform plan
```
```
terraform apply
```

Terraform Apply Output:
```
Apply complete! Resources: 11 added, 0 changed, 0 destroyed.

Outputs:

alternate_domain_name = "http://house-games-dev.razed.com"
cloudfront_domain_name = "http://d1omkdrv4lqs4x.cloudfront.net"
s3_bucket_name = "dev-london-h0us3-g4m3s-fr0nt3nd"
```

S3 Bucket

![alt text](https://github.com/jbetueldev/terraforms/blob/main/s3-cloudfront/images/s3bucket.png)

Block public access:

![alt text](https://github.com/jbetueldev/terraforms/blob/main/s3-cloudfront/images/s3blockpublicaccess.png)

CloudFront Distribution:

![alt text](https://github.com/jbetueldev/terraforms/blob/main/s3-cloudfront/images/cfdist.png)

CloudFront Distribution Origin as S3 with Origin Access Control OAC:

![alt text](https://github.com/jbetueldev/terraforms/blob/main/s3-cloudfront/images/s3oac.png)

S3 Bucket Policy to allow access from cloudfront 

![alt text](https://github.com/jbetueldev/terraforms/blob/main/s3-cloudfront/images/s3policy.png)

### Step 7: (TEST) Upload the test file [index.html](test/index.html) to the S3 bucket
```
aws s3 cp --recursive ./test s3://dev-london-h0us3-g4m3s-fr0nt3nd/dice
```

Using cloudfront domain name to access S3 static website
```
http://d1omkdrv4lqs4x.cloudfront.net/dice/index.html
```

![alt text](https://github.com/jbetueldev/terraforms/blob/main/s3-cloudfront/images/website.png)

> [!NOTE]
> Cache Invalidation can be forced from console for a cloudfront distribution
