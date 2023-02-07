# Challenge #2

# ------------------------------------------------------------------------------------------------------------------------------------------ 

# Solution using AWS Python Boto3 Apis 
# Aditya Bhangle

# ------------------------------------------------------------------------------------------------------------------------------------------ 
# Code 

import boto3

# Function to get AWS instance attribute values
def getAttributeValue():

    try: 
        ec2_client = boto3.client('ec2')

        # Enter choice
        print("Enter 1 for all instance attributes, 2 for specific attributes or metadata:")
        choice = int(input())

        if choice == 1: # get all attribute values for an instance

            # Accept instance id from user
            instance_id = input("Enter AWS instance ID: ")
            response = ec2_client.describe_instances(Filters=[{'Name': 'instance-id', 'Values': [instance_id]}])

            # Print full details for the instance
            print(response)

        elif choice == 2: # Bonus pt question
            
            # Accept instance id from user
            instance_id = str(input("Enter AWS instance ID: "))
            
            print("Valid List of attributes or metadata: # instanceType # kernel # ramdisk # userData # disableApiTermination # instanceInitiatedShutdownBehavior # rootDeviceName # blockDeviceMapping # productCodes # sourceDestCheck # groupSet # ebsOptimized # sriovNetSupport # enaSupport # enclaveOptions # disableApiStop")
            
            # Accept attribute type from user
            attribute_type = str(input("Enter Valid Attribute Type from the above list: "))

            response = ec2_client.describe_instance_attribute(
                Attribute=attribute_type,
                DryRun=False,
                InstanceId=instance_id
            )

            print(response)

        else: 
            # Executes if 1st choice input is anything other than 1 or 2
            print("Please enter 1 or 2")
            getAttributeValue()

    except Exception as e:
        # Executes if the pgm encounters any errors. Clean exit
        print("Error occured. Please try again")
        print(e)

# Start of code.
print("Get AWS Instance attributes")
getAttributeValue()


# ------------------------------------------------------------------------------------------------------------------------------------------ 
# Output 1: 
    # python challenge2.py
    # Get AWS Instance attributes
    # Enter 1 for all attributes, 2 for specific attributes (bonus question):
    # 1
    # Enter AWS instance ID: i-xxxxxxxxxxxxxx
    # {'Reservations': [{'Groups': [], 'Instances': [{'AmiLaunchIndex': 0, 'ImageId': 'ami-0cca134ecxxxxxx', 'InstanceId': 'i-xxxxxxxxxxxxxx', 'InstanceType': 't2.large', 'KeyName': 'xxxxxxxxxxxxxx', 'LaunchTime': datetime.datetime(2022, 12, 26, 6, 29, 55, tzinfo=tzlocal()), 'Monitoring': {'State': 'disabled'}, 'Placement': {'AvailabilityZone': 'ap-south-1a', 'GroupName': '', 'Tenancy': 'default'}, 'PrivateDnsName': 'ip-x-x-x-x.ap-south-1.compute.internal', 'PrivateIpAddress': 'x.x.x.x', 'ProductCodes': [], 'PublicDnsNnsAAAARecord': False}, 'MaintenanceOptions': {'AutoRecovery': 'default'}}], 'OwnerId': 'xxxxxxxxxxxxxx', 'ReservationId': 'r-xxxxxxxxxxxxxx'}], 'ResponseMetadata': {'RequestId': 'xxxxxxxxxxxxxx', 'HTTPStatusCode': 200, 'HTTPHeaders': {'x-amzn-requestid': 'xxxxxxxxxxxxxx', 'cache-control': 'no-cache, no-store', 'strict-transport-security': 'max-age=31536000; includeSubDomains', 'vary': 'accept-encoding', 'content-type': 'text/xml;charset=UTF-8', 'content-length': '7934', 'date': 'Mon, 06 Feb 2023 19:05:16 GMT', 'server': 'AmazonEC2'}, 'RetryAttempts': 0}}

# Output 2: 
    # python challenge2.py
    # Get AWS Instance attributes
    # Enter 1 for all instance attributes, 2 for specific attributes or metadata:
    # 2
    # Enter AWS instance ID: i-xxxxxxxxxxxxx
    # Valid List of attributes or metadata: # instanceType # kernel # ramdisk # userData # disableApiTermination # instanceInitiatedShutdownBehavior # rootDeviceName # blockDeviceMapping # productCodes # sourceDestCheck # groupSet # ebsOptimized # sriovNetSupport # enaSupport # enclaveOptions # disableApiStop
    # Enter Valid Attribute Type from the above list: rootDeviceName
    # {'InstanceId': 'i-xxxxxxxxxxxxx', 'RootDeviceName': {'Value': '/dev/xvda'}, 'ResponseMetadata': {'RequestId': 'xxxxxxxxxxxxx', 'HTTPStatusCode': 200, 'HTTPHeaders': {'x-amzn-requestid': 'xxxxxxxxxxxxx', 'cache-control': 'no-cache, no-store', 'strict-transport-security': 'max-age=31536000; includeSubDomains', 'content-type': 'text/xml;charset=UTF-8', 'content-length': '349', 'date': 'Mon, 06 Feb 2023 19:41:08 GMT', 'server': 'AmazonEC2'}, 'RetryAttempts': 0}}

# ------------------------------------------------------------------------------------------------------------------------------------------ 
# ------------------------------------------------------------------------------------------------------------------------------------------ 
# Solution 2 

# Can also achieve this using bash and aws cli commands 
#   aws ec2 describe-instance-attribute --instance-id <instance_id> --region <region_name> --attribute <attributeType>

# ------------------------------------------------------------------------------------------------------------------------------------------ 
# Output 1: 
    # aws ec2 describe-instance-attribute --instance-id <instance_id> --region <region_name> --attribute instanceType
    # {
    #     "InstanceId": "i-xxxxxxxxxxxxx",
    #     "InstanceType": {
    #         "Value": "t2.large"
    #     }
    # }

# # Output 2: 
    # aws ec2 describe-instance-attribute --instance-id <instance_id> --region <region_name> --attribute rootDeviceName
    # {
    #     "InstanceId": "i-xxxxxxxxxxxxx",
    #     "RootDeviceName": {
    #         "Value": "/dev/xvda"
    #     }
    # }
