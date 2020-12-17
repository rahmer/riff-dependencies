# riff-dependencies
Use this as a repo to maintain hermetically sealed versions of dependencies for project riff

# Use below command to bring all the images related to Issue 421 -- We are calling this 422 since this is our fix. Make sure you are docker logged in to your repositories.
awk -f snip.awk INPUT/ecr-images-sha-422.txt | tee output-422.txt

# Run the script split_large_files.sh to split any tar.gz files in OUTPUT folder to no more than 95MB to meet github filesize reqts

