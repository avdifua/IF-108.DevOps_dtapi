# IF-108.DevOps_1week
Deploying the app dtapi.if.ua in google cloud.
For first, thanks to Misha Navrotsky for example vagrant code!

What do you have to change in vagrant file.

Prior to using this plugin, you will first need to make sure you have a Google Cloud Platform account, enable Google Compute Engine, and create a Service Account for API Access.
Log in with your Google Account and go to Google Cloud Platform and click on the Try it free button.
Create a new project and remember to record the Project ID
Next, enable the Google Compute Engine API for your project in the API console. If prompted, review and agree to the terms of service.
While still in the API Console, go to Credentials subsection, and click Create credentials -> Service account key. In the next dialog, create a new service account, select JSON key type and click Create.
Download the JSON private key and save this file in a secure and reliable location. This key file will be used to authorize all API requests to Google Compute Engine.
Still on the same page, click on Manage service accounts link to go to IAM console. Copy the Service account id value of the service account you just selected. (it should end with gserviceaccount.com) You will need this email address and the location of the private key file to properly configure this Vagrant plugin.
Add the SSH key you're going to use to GCE Metadata in Compute -> Compute Engine -> Metadata section of the console, SSH Keys tab. (Read the SSH Support readme section for more information.)

Example:
    google.google_project_id = "sofserv-if" - Project ID
		google.google_json_key_location = "/home/al/Vagrant/sofserv-if-123573ea618.json" - path to JSON
    
    override.ssh.username = "al" - name in linux system
		override.ssh.private_key_path = "~/.ssh/virtual_home" - path where stored keys
 
If you want to change Region your instances.
Look here - > VPC networks in Google cloud and choose correct IP address ranges
   
In the output, you have to get a working app which deployed in google cloud!
Enjoy!



