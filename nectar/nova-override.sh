#!/bin/bash

echo manual | sudo tee /etc/init/nova-network.override
echo manual | sudo tee /etc/init/nova-compute.override
echo manual | sudo tee /etc/init/nova-api-metadata.override
