#!/bin/bash

# Function to update the conf file
update_conf() {
    local component="$1"
    local scale="$2"
    local view="$3"
    local count="$4"

    local filename="sig.conf"

    # Interpret view input
    if [[ "$view" == "auction" ]]; then
        view="vdopiasample"
    elif [[ "$view" == "bid" ]]; then
        view="vdopiasample-bid"
    fi

    # Constructing the line to be replaced
    local line="$view ; $scale ; $component ; ETL ; vdopia-etl= $count"

    # Debugging statement to show the line being appended
    echo "Appending line: $line to $filename"

    # Append the line to the conf file
    echo "$line" > "$filename"

    echo "Updated $filename with the following line:"
    echo "$line"
}

# Main script starts here

# Parse command-line options
while getopts ":c:s:v:n:" opt; do
    case $opt in
        c) component=$OPTARG ;;
        s) scale=$OPTARG ;;
        v) view=$OPTARG ;;
        n) count=$OPTARG ;;
        \?) echo "Invalid option: -$OPTARG" >&2
            exit 1 ;;
        :) echo "Option -$OPTARG requires an argument." >&2
            exit 1 ;;
    esac
done

# Validate component name
if [[ ! "$component" =~ ^(INGESTOR|JOINER|WRANGLER|VALIDATOR)$ ]]; then
    echo "Invalid component name: $component" >&2
    exit 1
fi

# Validate scale
if [[ ! "$scale" =~ ^(MID|HIGH|LOW)$ ]]; then
    echo "Invalid scale: $scale" >&2
    exit 1
fi

# Validate view
if [[ ! "$view" =~ ^(auction|bid)$ ]]; then
    echo "Invalid view: $view" >&2
    exit 1
fi

# Validate count
if [[ ! "$count" =~ ^[0-9]$ ]]; then
    echo "Invalid count: $count" >&2
    exit 1
fi

# Call the function to update the conf file
update_conf "$component" "$scale" "$view" "$count"

