# Module: modules - btp cloudfoundry org and space setup

## Overview

This module performs the following tasks:
- Creates a Cloud Foundry environment instance in a subaccount.
- Assigns users to the newly created Cloud Foundry environment (CF org).
- Creates a space in the newly created Cloud Foundry org.
- Assigns users to the newly created space.

## Prerequisites

The following requirements must be met before using this module:
- The subaccount must be entitled to the `cloudfoundry` service with the desired plan. The default plan is `standard`.
