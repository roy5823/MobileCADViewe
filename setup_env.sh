#!/bin/bash
# Set Java 11 installation explicitly
export JAVA_HOME=/nix/store/1jm9fvrqrry22z9kgqa0v55nnz0jsk09-openjdk-11.0.23+9
export PATH=$JAVA_HOME/bin:$PATH
echo "JAVA_HOME set to $JAVA_HOME"
java -version

# Set Android SDK environment variables
export ANDROID_HOME=/home/runner/workspace/android-sdk-linux
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
echo "ANDROID_HOME set to $ANDROID_HOME"

# Create licenses directory if it doesn't exist
mkdir -p "$ANDROID_HOME/licenses"

# Accept Android SDK licenses
echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > "$ANDROID_HOME/licenses/android-sdk-license"
echo "d56f5187479451eabf01fb78af6dfcb131a6481e" >> "$ANDROID_HOME/licenses/android-sdk-license"
echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" >> "$ANDROID_HOME/licenses/android-sdk-license"

echo "Android SDK licenses accepted"