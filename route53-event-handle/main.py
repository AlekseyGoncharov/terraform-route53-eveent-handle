import boto3
import logging
from datetime import datetime
import json

def lambda_handler(event, context):
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)

    client = boto3.client("logs")

    if event.get("Records"):
        for record in event["Records"]:
            data = json.loads(record["body"])
            data.update({"EventType": "DNS"})
            response = client.put_log_events(
                logGroupName='${LOG_GROUP}',
                logStreamName='${LOG_STREAM}',
                logEvents=[
                    {
                        "timestamp": int(round(datetime.utcnow().timestamp())) * 1000,
                        "message": json.dumps(data)
                    }
                ]
            )
            logger.debug(response)

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
