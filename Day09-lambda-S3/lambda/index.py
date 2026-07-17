import json

def handler(event, context):
    print("Event received:", json.dumps(event))
    return {
        "statusCode": 200,
        "body": json.dumps({"message": "Hello from Lambda via S3!"})
    }
    #