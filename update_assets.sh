#!/bin/bash

set -e

# Check and print the system PATH for debugging
echo "Current system PATH: $PATH"
which rm

# Set a safe default PATH in case it's lost after yq execution
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

# Obtain the full path to yq
YQ_CMD=$(which yq)

# Check if yq is installed
if [ -z "$YQ_CMD" ]; then
    echo "Error: yq is not installed or not found in your PATH."
    exit 1
fi

echo "Using yq at: $YQ_CMD"

APP_PUBSPEC="pubspec.yaml"

# Get the path-based dependencies from app's pubspec.yaml
DEPENDENCIES=$("$YQ_CMD" e '.dependencies | to_entries | map(select(.value.path != null)) | .[] | .key + " " + .value.path' "$APP_PUBSPEC")

# Loop over each dependency
while IFS= read -r DEPENDENCY; do
    NAME=$(echo "$DEPENDENCY" | awk '{print $1}')
    PACKAGE_PATH=$(echo "$DEPENDENCY" | awk '{print $2}')

    echo "Processing dependency '$NAME' at path '$PACKAGE_PATH'"

    DEP_PUBSPEC="$PACKAGE_PATH/pubspec.yaml"

    if [ ! -f "$DEP_PUBSPEC" ]; then
        echo "Warning: $DEP_PUBSPEC not found. Skipping."
        continue
    fi

    # Extract assets from the dependency's pubspec.yaml
    DEP_ASSETS=$("$YQ_CMD" e '.flutter.assets // []' "$DEP_PUBSPEC")
    echo "DEP_ASSETS for $NAME:"
    echo "$DEP_ASSETS"

    if [ "$DEP_ASSETS" = "[]" ] || [ -z "$DEP_ASSETS" ]; then
        echo "No assets found or invalid assets in $DEP_PUBSPEC. Skipping."
        continue
    fi

    # Prefix asset paths with the dependency path
    ADJUSTED_ASSETS=$("$YQ_CMD" e 'map("'"$PACKAGE_PATH"'/" + .)' <<< "$DEP_ASSETS")
    echo "ADJUSTED_ASSETS for $NAME:"
    echo "$ADJUSTED_ASSETS"

    # Get existing assets from app's pubspec.yaml
    APP_ASSETS=$("$YQ_CMD" e '.flutter.assets // []' "$APP_PUBSPEC")
    echo "APP_ASSETS:"
    echo "$APP_ASSETS"

    # Merge and deduplicate assets
    echo "Merging assets for $NAME..."

    if [ "$APP_ASSETS" = "[]" ] || [ -z "$APP_ASSETS" ]; then
        MERGED_ASSETS="$ADJUSTED_ASSETS"
    else
        # Combine the two arrays into a YAML array
        COMBINED_ASSETS=$(echo "$APP_ASSETS" "$ADJUSTED_ASSETS" | "$YQ_CMD" ea -N '. as $item ireduce ([]; . + $item)' -)
        MERGED_ASSETS=$("$YQ_CMD" e 'unique' <<< "$COMBINED_ASSETS")
    fi

    echo "MERGED_ASSETS:"
    echo "$MERGED_ASSETS"

    # Create a temporary file for merged assets
    TEMP_ASSETS_FILE=".temp_merged_assets.yaml"
    echo "$MERGED_ASSETS" > "$TEMP_ASSETS_FILE"

    # Update app's pubspec.yaml with the merged assets using the temporary file
    "$YQ_CMD" e '.flutter.assets = load("'"$TEMP_ASSETS_FILE"'")' -i "$APP_PUBSPEC"

    # Replace asset paths in the dependency's lib folder
    DEP_LIB_FOLDER="$PACKAGE_PATH/lib"
    PACKAGE_NAME=$(basename "$PACKAGE_PATH")  # Extract package name from path

    if [ -d "$DEP_LIB_FOLDER" ]; then
        echo "Performing in-place replacement in .dart files within $DEP_LIB_FOLDER"

        # Replace "assets/" with "dependencies/<package_name>/assets/" in all .dart files
        find "$DEP_LIB_FOLDER" -type f -name "*.dart" -exec sed -i '' "s#assets/#dependencies/$PACKAGE_NAME/assets/#g" {} \;
    else
        echo "Warning: $DEP_LIB_FOLDER not found. Skipping."
    fi

    # Clean up temporary file
    /bin/rm "$TEMP_ASSETS_FILE"

done <<< "$DEPENDENCIES"

# Run flutter pub get
flutter pub get

echo "Script execution completed successfully."