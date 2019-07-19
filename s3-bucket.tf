// resource "aws_s3_bucket" "state-storage-s3" {
//     bucket = "sikandar-terraform-state-storage"
//      versioning {
//       enabled = true
//     }
//      lifecycle {
//       prevent_destroy = true
//     }
//      tags ={
//       Name = "S3 Remote Terraform State Store"
//     }      
// }

// resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
//   name = "Sikandar-terraform-state-lock"
//   hash_key = "LockID"
//   read_capacity = 5
//   write_capacity = 5
//    attribute {
//     name = "LockID"
//     type = "S"
//   }
//    tags ={
//     Name = "Sikandar-DynamoDB-Terraform-State-Lock-Table"
//   }
// }
