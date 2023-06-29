#!/bin/bash

openstack --os-volume-api-version 3.42 volume set "$(< fileid.txt)" --size "$(< filesize.txt)"
