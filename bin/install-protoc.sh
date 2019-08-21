#!/bin/bash

location=$(curl -vs https://github.com/protocolbuffers/protobuf/releases/latest 2>&1 | grep "Location:")
release=${location:(-6)}
release=${release%%[[:space:]]*}
zipurl="https://github.com/protocolbuffers/protobuf/releases/download/v${release}/protoc-${release}-linux-x86_64.zip"
curl --location --remote-name ${zipurl}
unzip protoc-${release}-linux-x86_64.zip
sudo cp bin/protoc /usr/local/bin/
sudo cp -r include/google /usr/include/
go get -u github.com/golang/protobuf/protoc-gen-go
