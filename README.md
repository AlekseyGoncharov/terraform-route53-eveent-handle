# terraform-route53-eveent-handle

## Backend
backed must be deployed manually
for this need to
- go to directory backend
- auth in aws or add access key and secret key to provider configuration
- do `terraform init`
- `terraform plan` verify s3 and dynamodb table will be created
- `terraform apply` apply changes, when terraform asks type `yes`

## Route53 event handler

### How it is works

event trigger eventbrige rule this rule push data to sqs 
and sqs trigger lambda, which add additional field to log
and put it to specific cloudwatch log stream

### variables
`tags` - tags which will be added to resources
`log_group` - log group which will be created for these events
`log_stream` - log stream inside log group

### resources
`iam` - iam for lambda(sqs and cloudwatch logs)

`cloudtrail` - trail for events, without this one rule doesn't work, if you have this one already you can remove file

`cloudwatch-logs` - log group and stream for logs, if you want to uses your own, just remove/rename file

`eventbridge` - rule for route53 events and target

`sqs` - sqs queue for events

`lambda` - lambda function