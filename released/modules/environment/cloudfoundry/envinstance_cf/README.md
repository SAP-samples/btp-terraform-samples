# Module: modules - cloudfoundry - envinstance_cf

## Overview

This module is executing the following tasks:
- creates a Cloudfoundry environment instance in a subaccount
- assigns users to the newly created Cloudfoundry environment (CF org). 

## Content of setup

The setup comprises the following resources:

- Creation of a SAP BTP subaccount
- Entitlements of all services and app subscriptions for SAP Build Apps
- Role collection assignments to users

## Pre-requisites

The following things need to be available before calling this:
- subaccount needs to exist
- subaacount needs to be entitled for service `cloudfoundry` with plan `standard`
