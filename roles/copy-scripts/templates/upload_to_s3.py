import boto3
import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--upload-file', type=str, required=True, help='file to upload')
    parser.add_argument('--storage-class', type=str, required=False, default='STANDARD_IA', help='Storage class on AWS')
    parser.add_argument('--bucket-name', type=str, required=True, help='Name of the AWS bucket')
    parser.add_argument('--dest-key', type=str, required=True, help='Key for object on AWS')
    args = parser.parse_args()

    s3_client = boto3.client('s3')

    with open(args.upload_file, 'rb') as f:
        s3_client.upload_fileobj(f, Bucket=args.bucket_name, Key=args.dest_key,
                                 ExtraArgs={'StorageClass': args.storage_class})
