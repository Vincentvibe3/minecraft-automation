import sys
import os
import datetime
import boto3

filename = sys.argv[1]
if len(sys.argv) < 7:
	world = os.environ["WORLD_NAME"]
	bucket = os.environ["BUCKET"]
	endpoint_url= os.environ["S3_ENDPOINT"]
	key_id = os.environ["KEY_ID"]
	key_secret = os.environ["KEY_SECRET"]
else:
	world = sys.argv[2]
	bucket = sys.argv[3]
	endpoint_url = sys.argv[4]
	key_id = sys.argv[5]
	key_secret = sys.argv[6]

if world != None and filename != None and bucket != None and endpoint_url != None:
	f = open(filename, "rb")
	client = boto3.client(
		"s3",
		endpoint_url=endpoint_url,
		aws_access_key_id=key_id,
		aws_secret_access_key=key_secret 
	)
	print(f"Uploading {world}/{os.path.basename(f.name)}")
	client.put_object(
		Bucket=bucket,
		Key=f"{world}/{os.path.basename(f.name)}",
		Body=f
	)
	current_time = datetime.datetime.now().astimezone()
	to_delete = []
	has_next = True
	next_token = None
	page_num = 1
	while has_next:
		print(f"Getting page {page_num}")
		if next_token == None:
			response = client.list_objects_v2(
				Bucket=bucket,
				Prefix=f"{world}/"
			)
		else:
			response = client.list_objects_v2(
				Bucket=bucket,
				Prefix=f"{world}/",
				ContinuationToken=next_token
			)
		if "Contents" in response:
			objects = response["Contents"]
			for obj in objects:
				object_time = obj["LastModified"]
				delta = current_time-object_time
				if delta.days > 7:
					key = obj["Key"]
					print(f"{key} queued for deletion")
					to_delete.append({"Key":key})
		if "NextContinuationToken" in response:
			next_token = response["NextContinuationToken"]
		else:
			has_next = False
		page_num+=1;
	if to_delete:
		print("Requesting deletion")
		deletion_response = client.delete_objects(
			Bucket=bucket,
			Delete={
				"Objects":to_delete
			}
		)
		if "Deleted" in deletion_response:
			for deleted in deletion_response["Deleted"]:
				print(f"{deleted['Key']} deleted")
		if "Errors" in deletion_response:
			for error in deletion_response["Errors"]:
				print(f"Error: {error}")
	else:
		print("Nothing to delete")
else:
	print("Skipping upload and cleaning")
	print("No world or file specified")