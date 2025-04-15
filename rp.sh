#!/bin/bash

# Set the dry_run flag to false by default
dry_run=false

# Parse the command-line arguments using getopts
while getopts ":d" opt; do
  case $opt in
    d)
      # Set the dry_run flag to true if the -d flag is present
      dry_run=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Shift the parsed options out of the argument list
shift $((OPTIND -1))

# Check if a folder was passed as a parameter
if [[ -d "$1" ]]; then
  # Set the directory to the parameter
  directory="$1"
  # Set the file pattern to match all HEIC files in the directory
  file_pattern="$directory/*.heic"
else
  # Set the directory to the current directory
  directory="."
  # Set the file pattern to match the list of files passed as parameters
  file_pattern="$@"
fi

# Loop through all files in the directory
for file in $file_pattern; do
  # Extract the content creation date and time from the file's metadata
  creation_date_time=$(mdls -name kMDItemContentCreationDate "$file" 2>/dev/null | awk -F' = ' '{print $2}')

  # Check the exit status of the mdls command
  if [[ $? -eq 0 ]]; then
    # Replace the spaces and colons in the creation date and time with hyphens
    creation_date_time=${creation_date_time// /-}
    creation_date_time=${creation_date_time//:/-}
    creation_date_time=${creation_date_time//-\+0000/}
    # Get extension
    case $file in
      (.*.*) extension=${file##*.};;
      (.*)   extension="";;
      (*.*)  extension=${file##*.};;
      (*)    extension="";;
    esac
    filename=$(basename "$file")
    cleanname=$(echo "$filename" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]//g')
    # Construct the new filename using the content creation date and time
    new_filename="`dirname $file`/$creation_date_time-$cleanname.$extension"
    # Print the new path
    echo "$file -> $new_filename"
    # Rename the file using the new filename, or print a message if dry_run is true
    if ! $dry_run; then
      mv "$file" "$new_filename"
    fi
  fi
done
