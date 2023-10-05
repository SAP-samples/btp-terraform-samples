# Module: modules - services_apps - sap_build_apps - standard

## Content of setup

This module is executing the following tasks:
- subscribes an already entitled subaccount to the SAP Build Apps plan `standard`
- creates all necessary role collections for SAP Build Apps
- assigns users to the newly created role collections
- creates a service instance for service `destination` with plan `lite` pointing to the Visual Cloud Functions

## Pre-requisites

The following things need to be available before calling this:
- subaccount needs to exist
- subaacount needs to be entitled for service `destination` with plan `lite`
- subaacount needs to be entitled for app subscription `SAP Build Apps` with plan `standard`

