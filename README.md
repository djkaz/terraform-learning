# Terraform Local AWS IAM Role Example

This project demonstrates how to use Terraform (with [tflocal](https://github.com/localstack/terraform-local) and [awslocal](https://github.com/localstack/awscli-local)) to create an AWS IAM role in a local AWS environment powered by [LocalStack](https://github.com/localstack/localstack).

---

## Project Structure

```
-rw-r--r--@ 1 macbookpro  staff  181 Aug  5 22:56 terraform.tfstate
-rw-r--r--@ 1 macbookpro  staff  685 Aug  5 22:57 main.tf
```

- **main.tf**: Terraform configuration file defining the IAM role.
- **terraform.tfstate**: Terraform state file.

---

## Usage

### 1. Initialize Terraform

```sh
tflocal init
```

Sample output:
```
Initializing the backend...

Successfully configured the backend "local"! Terraform will automatically
use this backend unless the backend configuration changes.
Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v6.7.0

Terraform has been successfully initialized!
```

### 2. Review the Execution Plan

```sh
tflocal plan
```

Sample output:
```
Terraform will perform the following actions:

  # aws_iam_role.test_role will be created
  + resource "aws_iam_role" "test_role" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(...)
      + create_date           = (known after apply)
      + name                  = "test_role"
      ...
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

### 3. Apply the Plan

```sh
tflocal apply
```

Approve the action by typing `yes` when prompted.

Sample output:
```
aws_iam_role.test_role: Creating...
aws_iam_role.test_role: Creation complete after 0s [id=test_role]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

---

## Verify with AWS CLI (awslocal)

Check that the IAM role was created:

```sh
awslocal iam get-role --role-name test_role
```

Expected output:
```json
{
    "Role": {
        "Path": "/",
        "RoleName": "test_role",
        "RoleId": "AROAQAAAAAAABSMZ5CKYX",
        "Arn": "arn:aws:iam::000000000000:role/test_role",
        "CreateDate": "...",
        "AssumeRolePolicyDocument": {
            "Statement": [
                {
                    "Action": "sts:AssumeRole",
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "ec2.amazonaws.com"
                    }
                }
            ],
            "Version": "2012-10-17"
        },
        "MaxSessionDuration": 3600,
        "Tags": [],
        "RoleLastUsed": {}
    }
}
```

> **Note:** `test-role` and `test_role` are different! Use the correct name when running `awslocal iam get-role`.

---

## Troubleshooting

- If you attempt to get a role using the wrong name (e.g., `test-role` instead of `test_role`), you’ll see:
  ```
  An error occurred (NoSuchEntity) when calling the GetRole operation: Role test-role not found
  ```

- Always double-check your resource names for underscores vs. dashes.

---

## References

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [LocalStack Documentation](https://docs.localstack.cloud/)
- [Terraform Local CLI (tflocal)](https://github.com/localstack/terraform-local)
- [AWS CLI Local Wrapper (awslocal)](https://github.com/localstack/awscli-local)
