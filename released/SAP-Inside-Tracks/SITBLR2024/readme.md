<h2>Welcome!</h2>

Thank you for showing interest in trying out our very own Terraform Provider for SAP BTP. If you are keen on learning about Terraform, how the provider for BTP works and how you can make use of it for your own automation use cases, then you are at the right place!

You can get started by going through this learning journey : https://learning.sap.com/learning-journeys/administrating-sap-business-technology-platform/managing-sap-btp-with-terraform

This will give you a quick overview about the specifics of Terraform and also some insight into the BTP Provider. At the end there is a short exercise you may try out
<img width="939" alt="Create a Terraform Configuration for SAP BTP" src="https://github.com/user-attachments/assets/cd9e8c52-a4bd-4097-bbae-9c0ce51bfb4e">

This will open a simulated VSCode environment where you can get first hand experience with the Provider by going through an interactive tutorial. This will help you get familiar with the CLI, configuration scripts and the general flow of Terraform. 

Now you are ready to try play around with the provider yourself!

Use the code provided here : https://github.com/SAP-samples/btp-terraform-samples/tree/main/released/SAP-Inside-Tracks/SITBLR2024

You can revisit the interactive tutorial and follow the on-screen instructions and execute them on your local system using VSCode. The BTP global account and user details have already been give to you.

You can use the toggle bar in the upper portion of the screen to move backwards or forwards in the tutorial as per your convenience.

<img width="292" alt="Pasted Graphic 2" src="https://github.com/user-attachments/assets/8a7e6428-0fea-4830-b745-c08991f68a47">
<br> </br>

Points to keep in mind:
1. In the file ***sample.tfvars***, the value of ```subaccount_id``` need not be populated as you will be creating a new subaccount using terraform. In the file ***variables.tf*** modify the variable ```subaccount_name``` by appending your name to the end of the default value.
2. When creating the file **secret.auto.tfvars** set the variables ```btp_username``` and ```btp_password```as per the details given to you.
