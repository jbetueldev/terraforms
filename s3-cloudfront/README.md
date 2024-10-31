# Deploying a cloudfront distribution for S3 Static Website using terraform
Deploying a cloudfront distribution for S3 Static Website using terraform

Amazon CloudFront is a web service that speeds up distribution of your static and dynamic web content, such as .html, .css, .js, and image files, to your users. CloudFront delivers your content through a worldwide network of data centers called edge locations. When a user requests content that you're serving with CloudFront, the request is routed to the edge location that provides the lowest latency (time delay), so that content is delivered with the best possible performance.

If the content is already in the edge location with the lowest latency, CloudFront delivers it immediately.

If the content is not in that edge location, CloudFront retrieves it from an origin that you've defined—such as an Amazon S3 bucket, a MediaPackage channel, or an HTTP server (for example, a web server) that you have identified as the source for the definitive version of your content.

CloudFront speeds up the distribution of your content by routing each user request through the AWS backbone network to the edge location that can best serve your content.

### Architecture Diagram:

![alt text](/images/diagram.png)

### Step 1: Create an S3 bucket with unique name and host static website by uploading files

### Step 2: Create a cloudfront distribution 

### Step 3: Update S3 Bucket policy to allow access from cloudfront 

### Terraform Apply Output:
```
Apply complete! Resources: 11 added, 0 changed, 0 destroyed.

Outputs:

cloudfront_domain_name = "http://d1rwkmekbjnbkd.cloudfront.net"
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

### Resources:

AWS CloudFront: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html
