#!/bin/bash

docker build -t registry.ctfo.com:5000/registry:latest .

docker save registry.ctfo.com:5000/registry:latest | gzip > ../registry-image.tar.gz
