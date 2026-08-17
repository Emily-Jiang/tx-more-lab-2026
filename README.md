# IBM Modernized Runtime Extension for Java Hands-On Lab 1648 in TechXchange 2026


**Duration:** 90 minutes

# Introduction

Modernizing Java applications doesn't mean manual work or abandoning your operational model. This lab walks you through a smooth and automatic end-to-end enterprise Java modernization workflow using IBM Application Modernization Accelerator (AMA), IBM Bob, and IBM Modernized Runtime Extension for Java (MoRE). 

[IBM Application Modernization Accelerator](https://www.ibm.com/docs/en/ama) has the capability to quickly evaluate your on-premises applications for rapid deployment on WebSphere Application Server and Liberty on public and private cloud environments. The first step is to download and run a custom discovery tool on your application servers. Results from the scan are uploaded to Application Modernization Accelerator where a detailed analysis is provided with advice, suggestions, and best practices are provided to ensure that the application runs correctly in the preferred destination environment.

[IBM Bob](https://bob.ibm.com/) is an AI-powered integrated development environment (IDE) and software development partner to assist enterprises throughout the entire software development lifecycle. IBM Bob offers Premium packages, which has additional workflows. This lab uses the Liberty Replatform workflow from the Premium package to assist migrating your applications to a managed Liberty server in IBM Modernized Runtime Extensions for Java.

[IBM Modernized Runtime Extension for Java](https://www.ibm.com/docs/en/more) (MoRE) is an extension of WebSphere® Application Server Network Deployment (ND) 9.0.5 that enables you to run and manage Liberty servers from the traditional WebSphere environment. With MoRE, Liberty servers can be configured, clustered, and administered using familiar tools like the administrative console and wsadmin scripting.


## About this hands-on lab

This lab provides fundamental hands-on experience of the evaluation process of WebSphere application for their modernization journey to MoRE. It shows the value of using Application Modernization Accelerator (AMA) to evaluate on-premises Java applications, modernise using IBM Bob and then deploy to MoRE. In this interactive, hands-on lab, you'll explore the cutting-edge capabilities of WebSphere Application Server and MoRE, which are designed to supercharge your modernization journey. 

Upon completion of this lab, you will have gained experience using AMA to quickly analyze on-premises Java applications without accessing their source code, and using IBM Bob to update the source code to accelerate your application modernization journey to MoRE.

You'll then deploy the modernized Modresort app to a Managed Liberty server in MoRE, using the WebSphere Administrative Console and/or automation with wsadmin scripts. 

---
# Getting started

This section guides you through the initial setup of the lab environment. Perform all tasks from the student virtual machine.

## Lab environment overview

The lab environment is preinstalled with the following packages:
* The Application Modernization Accelerator, version 5.0
* IBM Bob 2.0.3
* WebSphere Application Server Network Deployment (ND), version 9.0.5.28, running on Java SE 8

    * Modernized Runtime Extension for Java (MoRE), version 1.0.3.0

    * IBM HTTP Server (IHS) and Web Server Plug-ins for WebSphere Application Server

* WebSphere Liberty, version 26.0.0.6, running on Java SE 21

In addition, the environment is preconfigured with the following profiles and server instances:

* A Deployment Manager (`dmgr`), which serves as the central controller for the WebSphere cell.

* Two managed nodes, `node1` and `node2`, both federated into the same cell as the `dmgr`.

* A preconfigured web server, `webserver1`, running on `node2`, which listens on ports `7777` (HTTP) and `8888` (HTTPS). This server forwards incoming requests to applications running on the Liberty cluster via IHS and the WebSphere Plugin, allowing external access without directly exposing Liberty server ports.

All components are installed under `/home/techzone/IBM` on the student virtual machine.

## Cloning the lab repository

Open a command-line terminal and run the following commands to clone the lab repository to your environment:

```sh
cd /home/techzone/Student

git clone https://github.com/Emily-Jiang/tx-more-lab-2026.git
cd tx-more-lab-2026
```
# Explore Application Modernization Accelerator
In this section, you will explore the main capabilities of Application Modernization Accelerator. 

## Start AMA

Application Modernization Accelerator(AMA) is already installed and typically running. 

Let's check if AMA is already started. This can be validated by reviewing if the related podman containers are started. 

1. Open a terminal by clicking on Activities and selecting terminal.

    <kbd>![Toolbar_terminal](./images/media/Toolbar_terminal.png)</kbd>

    The terminal window opens.  

    <kbd>![Terminal](./images/media/Terminal.png)</kbd>

2. Access the AMA launch script to verify if AMA is started or not

        cd /home/techzone/IBM/application-modernization-accelerator-local-*
        ./launch.sh

        
    Check the status if AMA is started. 
    If AMA **is available** (see screenshot below), enter **q** to quit the menu and keep AMA running. 

    <kbd>![AMA_Launcher](./images/media/AMA_Launcher.png)</kbd>

    If AMA is avalable, enter **q** to quit the script.

    If AMA is **not running** (see screenshot below), enter **5** to start AMA. 
    <kbd>![AMA_Launcher_stopped](./images/media/AMA_Launcher_stopped.png)</kbd>
        
    Wait until AMA has started and the URL is displayed
    <kbd>![AMA_Launcher_stopped](./images/media/AMA_Launcher_started.png)</kbd>


## Build and deploy the WebSphere application ModResort

The objective of this section is to assess the ModResort application that has been deployed to a traditional WAS 9 instance.

### Build the WAS application

1. Install the required WAS library

       cd modresorts-project/

       mvn install:install-file -Dfile=/home/techzone/IBM/WebSphere/dev/was_public.jar -DpomFile=/home/techzone/IBM/WebSphere/dev/was_public-9.0.0.pom

    Make sure that the build is successful.

    <kbd>![mvn-install_WAS_library](./images/media/mvn-install_WAS_library.png)</kbd>

2. Build the application
    
       mvn clean package

    <kbd>![modresorts_mvn_build_tWAS_1.png](./images/media/modresorts_mvn_build_tWAS_1.png)</kbd>

    <kbd>![modresorts_mvn_build_tWAS_1.png](./images/media/modresorts_mvn_build_tWAS_2.png)</kbd>

3. Copy the generated war file into the assets directory
    
        cp target/modresorts-2.0.0.war /home/techzone/Student


### Deploy the WebSphere application and test it

The application has not been installed to traditional WAS so far. You will now perform the following steps:
- Start the WAS ND Deployment Manager and a Node Agent
- Deploy the application via wsadmin to the WAS ND server1 instance
- Configure WAS for the application
- Start server1
- Test the application if it works fine on traditional WAS.

1. In the terminal window, enter the following command to start the Deployment Manager

        /home/techzone/IBM/WebSphere/profiles/Dmgr01/bin/startManager.sh

    Wait until the Deployment Manager has been started

    <kbd>![tWAS_dmgr-start](./images/media/tWAS_dmgr-start.png)</kbd>

2. Enter the following command to start the Note Agent

       /home/techzone/IBM/WebSphere/profiles/AppSrv01/bin/startNode.sh

    Wait until the Node agent has been started
    
    <kbd>![tWAS_node-start](./images/media/tWAS_node-start.png)</kbd>

3. Deploy the application using wsadmin by entering the following commands:

        cd modresorts-project/tWAS-Scripts

        /home/techzone/IBM/WebSphere/profiles/Dmgr01/bin/wsadmin.sh -f ./modresorts_install.py

    <kbd>![tWAS_install_modresorts](./images/media/tWAS_install_modresorts.png)</kbd>


4. Set the URLProvider which is used by the modresorts application via wsadmin by entering the following commands:

        ~/usr/IBM/WebSphere/profiles/Dmgr01/bin/wsadmin.sh -f ./setURLProvider.py

    <kbd>![tWAS_set_URLProvider](./images/media/tWAS_set_URLProvider.png)</kbd>

5. Enter the following command to start the WAS server server1

       ~/usr/IBM/WebSphere/profiles/AppSrv01/bin/startServer.sh server1

    Wait until the server serer1 has been started
    
    <kbd>![tWAS_server1-start](./images/media/tWAS_server1_start.png)</kbd>

6. Test the application

    1. Open a browser window by clicking on **Activities** and then select the **Firefox** browser icon.

        <kbd>![Toolbar_firefox](./images/media/Toolbar_firefox.png)</kbd>

    2. Access the tWAS application using the URL http://localhost:9080/resorts

    <kbd>![Toolbar_firefox](./images/media/modresorts_tWAS_1.png)</kbd>


    3. Click on **Where to?** and switch to Paris or another city. 
    (If the button does not work, make sure that the browser is in full-screen.)

    <kbd>![Toolbar_firefox](./images/media/modresorts_tWAS_2.png)</kbd>

    Verify that there are no errors shown. 
    
    <kbd>![Toolbar_firefox](./images/media/modresorts_tWAS_3.png)</kbd>
    
    4. Click on the **Logout** button.

    <kbd>![Toolbar_firefox](./images/media/modresorts_tWAS_4.png)</kbd>

    Verify that there are no errors shown. 
    
    <kbd>![Toolbar_firefox](./images/media/modresorts_tWAS_5.png)</kbd>

    If everything worked fine, there should be no error displayed.
    You will test the same application later on as is if it works on Liberty as well.

7. Switch back to the terminal window and stop the WAS cell.

    /home/TechZone/IBM/WebSphere/profiles/AppSrv01/bin/stopServer.sh server1
    /home/TechZone/IBM/WebSphere/profiles/AppSrv01/bin/stopNode.sh
    /home/TechZone/IBM/WebSphere/profiles/Dmgr01/bin/stopManager.sh

As you have seen, the application works without any issue on WebSphere Traditional v9. The next step is to assess the application via AMA to find out which issues must be resolved to make the application work on Liberty with Java 8.

## Create an AMA data collection for the WAS applications

You will now switch back to the AMA User Interface and create a new workspace called **Evaluation**. Then you will download the AMA Discovery Tool to scan the existing WebSphere landscape.

To evaluate on-premises Java applications, you need to run the AMA Discovery Tool against the Application server environment. It will extract application information from the environment. The utility can be downloaded from the AMA.

1. Create in AMA a new workspace and download the AMA Discovery Tool.
    1. Switch back to the browser and open the existing AMA window.
    Then click on **Home**
        
        Note: If you closed the browser window, open a new browser window and enter the URL https://localhost:3000

    2. You should now be back on the AMA Overview page:

        <kbd>![AMA_Initial_Screen2](./images/media/AMA_Initial_Screen2.png)</kbd>
    

    3. Click on the button **Create workspace** and enter **Evaluation**, do NOT select **include sample data**, then click on **Create**.

        <kbd>![AMA_Workspace_Evaluation](./images/media/AMA_Workspace_Evaluation.png)</kbd>
    
    4. An empty workspace will be created, and you will be asked if you want to upload an existing data collection or if you want to use the Discovery Tool.
        <kbd>![AMA_Workspace_Evaluation_Create](./images/media/AMA_Workspace_Evaluation_Create.png)</kbd>
    
    5. Click on **Open discovery tool**.
        <kbd>![AMA_Workspace_Evaluation_Create2](./images/media/AMA_Workspace_Evaluation_Create2.png)</kbd>
    The Discovery Tool panel opens and provides the option to download the tool; in addition, it provides information how to use the tool. 
    6. Click on **Download discovery tool**.
    <kbd>![AMA_DiscoveryTool_Panel](./images/media/AMA_DiscoveryTool_Panel.png)</kbd>

        The discovery tool package will be generated and prepared for download.
        Once done, you will likely get a warning, that there is a potential security risk, click on **Advanced** and then **Accept the Risk and Continue**. 

        <kbd>![AMA_Potential_Security_Risk](./images/media/AMA_Potential_Security_Risk3.png)</kbd>

    
        The AMA Discovery Tool package will be generated and downloaded.
        <kbd>![AMA_DiscoveryTool_Download](./images/media/AMA_DiscoveryTool_Download.png)</kbd>
    
        It will include next to the scanner also the information to upload the data collection once created.

    7. Click the back button to return to the Discovery Tool page.

        <kbd>![AMA_DiscoveryTool_Download2](./images/media/AMA_DiscoveryTool_Download2.png)</kbd>
    
    
2. Use the AMA Discovery Tool to analyze the installed WebSphere Applications.

    Run the AMA Discovery Tool against your WebSphere environment. After downloading the zipped Data Collector utility, it needs to be unpacked and run against a WebSphere Application server (WAS) to collect all the data of deployed applications and their configuration from the WAS server.

    1. Go back to the Terminal window and navigate the /home/itzuser/Downloads directory and view its contents with commands:

            cd /home/itzuser/Downloads/
            ls -l | grep Discovery

        <kbd>![AMA_Discovery_Run_1](./images/media/AMA_Discovery_Run_1.png)</kbd>
            
        You can see the downloaded Discovery Tool file named “DiscoveryTool-Linux_Evaluation.tgz”

    2. Extract the data collector utility to the Student directory using the following command:

            tar xvfz DiscoveryTool-Linux_Evaluation.tgz -C ~/Student

        The Discovery Tool will be extracted to ~/Student/ama-discovery-5.0.0 directory.

        Note: At this point, the data collector is ready to execute against a WebSphere environment.

    3. Return to the AMA UI in the Web browser to view the section on “Run the Tool”, which shows the command to run on the WebSphere environment.

        a. From the Discovery Tool page, scroll down to the “Run Tool” section.

        <kbd>![AMA_Discovery_Run_2](./images/media/AMA_Discovery_Run_2.png)</kbd>
        
        The Discovery tool command that would be executed is based on the domain and analysis type selections you make in this section.

        b. Select the domain.

        Open the twisty to see the different domain options:

        <kbd>![AMA_Discovery_Run_3](./images/media/AMA_Discovery_Run_3.png)</kbd>
        
        
        Finally, choose the **IBM WebSphere** Domain. 

        c. Select the Analysis type
        
        Open the twisty to see the different analysis types:

        <kbd>![AMA_Discovery_Run_4](./images/media/AMA_Discovery_Run_4.png)</kbd>
        
        Choose the **Apps & Configuration** analysis. 
        Selecting **Apps & Configuration** ensures that the application data and server configuration data is collected.
 
        The server configuration data is extremely helpful in Transformation Advisor to generate deployment artifacts in the migration bundle, which we will explore later in the lab.
 
        d. Review the final command.
        To analyze the application and configuration for WebSphere will be done using a command as shown in the screenshot
        <kbd>![AMA_Discovery_Run_5](./images/media/AMA_Discovery_Run_5.png)</kbd>
    

6.  Execute the AMA Discovery Tool.

    1. Go back to the Terminal window and navigate the directory where the AMA Discovery Tool was extracted, then list the content:

            cd ~/Student/ama-discovery-*
            ls -l

        <kbd>![AMA_Discovery_Run_6](./images/media/AMA_Discovery_Run_6.png)</kbd>


    2.  Execute the following command to start the AMA Discovery Tool:

            ./bin/ama-discovery -w ~/usr/IBM/WebSphere/AppServer

        <kbd>![AMA_Discovery_Run_7](./images/media/AMA_Discovery_Run_7.png)</kbd>

        The license agreement will be displayed, and you will be asked to accept it. 
        
        <kbd>![AMA_Discovery_Run_8](./images/media/AMA_Discovery_Run_8.png)</kbd>
        

        Type **1** to accept the license agreement and press **Enter**.

    3. Wait until the analysis has completed. As you can see, 1 application has been analyzed, and the resulting data collection has been automatically uploaded. 

        The collection is also available as zip file in the directory where the discovery tool was called. It is named like the WAS profile.

            ls -l

        <kbd>![AMA_Discovery_Run_10](./images/media/AMA_Discovery_Run_10.png)</kbd>


        Comments: 
        - In the lab, the process only takes a couple of seconds. In a real scenario, the process typically takes some time to complete, depending on how many applications are deployed on the WebSphere Application server and the complexity of the applications. As this process consumes some CPU and memory, it is not recommended to run the discovery tool in production.
        - You might have recognized that the WebSphere applications were discovered even though the WebSphere instances were stopped. This is due to the fact that the discovery tools looks into the WebSphere files instead of connecting to a running instance.
        - In the lab environment, the discovery tool can connect to the AMA instance via port 2220. Therefore the collected data has been automatically uploaded. If this is not the case, you must copy over the data collection zip to another system and manually upload the data to AMA from that system before you can view the results. 
        - You can also specify in the ama-discovery command not to upload the data collection automatically. 


    4. Return to the AMA UI in the Web browser and you can see that the data collection has been uploaded. 
    
        <kbd>![AMA_Discovery_Run_11](./images/media/AMA_Discovery_Run_11.png)</kbd>

    5. Click on the **Evaluation** workspace to open it.  
    You will be asked to specify the modernization destination. Select **Liberty administered from WebSphere (MoRE)** as the destination, choose **Java SE 21** under the Standard edition and then click on **Confirm**.
    

        The Evaluation workspace will open in the Visualization View. [todo]
    
        <kbd>![AMA_Visualization_Evaluation](./images/media/AMA_Visualization_Evaluation.png)</kbd>

    ___

4. Click to download the **Migration Plan** generated by AMA.

    <kbd>![AMA_Evaluation_Assessment-modresorts11.png](./images/media/AMA_Evaluation_Assessment-modresorts11.png)</kbd>

    The migration plan will be downloaded to the Downloads directory.
    <kbd>![AMA_Evaluation_Assessment-modresorts12.png](./images/media/AMA_Evaluation_Assessment-modresorts12.png)</kbd>


### Recap

Congratulations, you have finished the application assessment part.

**Let’s recap what you did so far.** 

- You installed and tested the modresorts application on a traditional WAS instance
- You ran the AMA Discovery Tool to assess a WebSphere cell
- You assessed the modresorts application
- You generated a migration plan
You will then use IBM Bob to modernise the application.

# Modernise the application using IBM Bob 

## Explore the IBM Bob installation and complete setup

1. Initialize git

    Open a terminal window and switch to the project directory, then initialize git.

        cd ~/Student/modresorts-project
        git init
        git config --global user.name "John Doe"
        git config --global user.email john.doe@noreply

        git add .
        git commit -a -m "Initial project"

2. Open IBM Bob

    1. Start the IBM Bob IDE

            bobide . &

        The IBM Bob IDE will be opened.

        If you get a Welcome panel offering to import settings, click on **Skip for now**,

        <kbd>![Bob_Import_Panel.png](./images/media/Bob_Import_Panel.png)</kbd>
        

    2. If you get a pop-up that a Bob update is available, click on settings and select **Keep current version**.

        <kbd>![Bob_UpdateAvailable.png](./images/media/Bob_UpdateAvailable.png)</kbd>

        <kbd>![Bob_Keep_current_version.png](./images/media/Bob_Keep_current_version.png)</kbd>
       

    3. If you get a **Bob Getting Started** panel, close it:

        <kbd>![Bob_Getting_Started.png](./images/media/Bob_Getting_Started.png)</kbd>

    4. If you see during the lab a pop-up like below or any other pop-up asking to install something, close the pop-up without installation by clicking the **X**. 

        <kbd>![Bob_Popup2.png](./images/media/Bob_Popup2.png)</kbd>


    5. Look at the bottom left of your Bobide window to find out if Bobide runs in Restricted Mode.

        <kbd>![Bob_RestrictedMode2.png](./images/media/Bob_RestrictedMode2.png)</kbd>

        If so, click on the field **Restricted Mode** to open the panel.

        <kbd>![Bob_RestrictedMode1.png](./images/media/Bob_RestrictedMode1.png)</kbd>

        Then click on **Trust** to make this workspace trusted.
        <kbd>![Bob_RestrictedMode3.png](./images/media/Bob_RestrictedMode3.png)</kbd>

        Finally, close the pop-up by clicking on **X**.
        <kbd>![Bob_RestrictedMode4.png](./images/media/Bob_RestrictedMode4.png)</kbd>

        If you used Bob before, you might see a **Migration** panel like this:

        <kbd>![Bob_Skip_Migration.png](./images/media/Bob_Skip_Migration.png)</kbd>

        Click on **Skip migration** to continue.

        
    4. The lab document uses the color theme **Bob Theme**. If you want to change your theme, you can do so under settings. 

        <kbd>![Bob_Change_Theme.png](./images/media/Bob_Change_Theme.png)</kbd>


3. Take a look at the installed extensions

    1. Open the Extensions panel

        <kbd>![Bob_Extensions.png](./images/media/Bob_Extensions.png)</kbd>

    2. Click on the extension called **Liberty Tools**. The Liberty tools provide an easy way to develop against Liberty

        <kbd>![Bob_Extension_Liberty.png](./images/media/Bob_Extension_Liberty.png)</kbd>

        Look at the details, then close the Liberty Tools Extension panel.
        You might have a newer version displayed.
    
        You will use the Liberty Tools Extension during the lab.

4. Log into IBM Bob
    1. On the right side of the IDE, click on the button **Log in to Bob** 

        <kbd>![Bob_Login.png](./images/media/Bob_Login.png)</kbd>

    2. On the pop-up, click on **Allow**. 

        <kbd>![Bob_signup.png](./images/media/Bob_signup.png)</kbd>

        Click on **Open**

        <kbd>![Bob_signup2.png](./images/media/Bob_signup2.png)</kbd>

        A browser window will open.

        <kbd>![Bob_signup3.png](./images/media/Bob_signup3.png)</kbd>

    3. Choose a way of login and enter your login credentials.

        <kbd>![Bob_signup4.png](./images/media/Bob_signup4.png)</kbd>

        The example uses SSO with the IBMid.

    4. On the new browser page, select **Open Link**

        <kbd>![Bob_signup5.png](./images/media/Bob_signup5.png)</kbd>

        You should see a panel like this:

        <kbd>![Bob_signup6.png](./images/media/Bob_signup6.png)</kbd>

    5. Switch back to the IBM Bob IDE and you should see a pop-up like this:

        <kbd>![Bob_signup7.png](./images/media/Bob_signup7.png)</kbd>

        Click on **Open**.

        You should now have access to IBM Bob and the IBM Bob chat window:

        <kbd>![Bob_signup8.png](./images/media/Bob_signup8.png)</kbd>

5. Verify that you use an account that has access to the IBM Premium Package for Java Modernization

    1. On the upper right part of the Bob IDE, click on the **Settings** icon.    Then take a look at the account:
    
         <kbd>![Bob_premium_user.png](./images/media/Bob_premium_user.png)</kbd>
      
        If you have a user with access to the premium package, it is listed under add-ons (see above). 
        
    You should have an account that has access to the premium package.

        <kbd>![Bob_premium_user.png](./images/media/Bob_premium_user.png)</kbd>
    
6. Install the premium package extension:
    
    1. In the list of **Add-ons**, click on the **Install** button next to **IBM Premium Package for Java Modernization**.
    
        <kbd>![Bob_premium_user_install.png](./images/media/Bob_premium_user_install.png)</kbd>
    
    2. In the pop-up, click on **Trust Publisher & Install**.
    
        <kbd>![Bob_premium_user_install2.png](./images/media/Bob_premium_user_install2.png)</kbd>

    3. Finally, you should see something like this:

        <kbd>![Bob_premium_user_installed.png](./images/media/Bob_premium_user_installed.png)</kbd>

        As you can see, you could start the modernization workflow from here.


    4. If the **IBM Bob** Panel on the right is not open, click on the **Bob** icon to open it.

        <kbd>![Bob_Open_Bob_Panel.png](./images/media/Bob_Open_Bob_Panel.png)</kbd>

    
    5. In the **IBM Bob** panel, click on the workflow icon and take a look at the Bob workflows that are offered. 
    
        You should see different workflows including the ones for Liberty Modernization (which are expanded in the screenshot below):

        <kbd>![Bob_premium_user_Workflows.png](./images/media/Bob_premium_user_Workflows.png)</kbd>



### Modernize Modresorts to WebSphere Liberty using IBM Bob
In the section you will use the **Java Modernization** to modernize the application to Liberty. 

1. Start the Java Modernization workflow

    1. In the **Bob** panel, click on **Permissions** to see which activities IBM Bob is allowed to do without approval. Set the settings to **Read**.
    This will allow you to better understand the workflow and decisions.

        <kbd>![Bob_Permissions.png](./images/media/Bob_Permissions.png)</kbd>


    2. In the **Bob** panel, expand the Java Modernization workflow and click on **Start**.

        <kbd>![Bob_Java_Modernization_Workflow_start.png](./images/media/Bob_Java_Modernization_Workflow_start.png)</kbd>

    3. Open the twisties in the **Getting Started** section to get some background.
    
        <kbd>![Bob_Java_Modernization_Workflow_GettingStarted.png](./images/media/Bob_Java_Modernization_Workflow_GettingStarted.png)</kbd>

        Finally, click on **Continue**.

2. Bob prepares the modernization

    1. Bob has detected that the application uses Spring and offers to analyze the application for vulnerabilities. 
    
        <kbd>![Bob_Java_Modernization_Workflow_Vulnerabilities.png](./images/media/Bob_Java_Modernization_Workflow_Vulnerabilities.png)</kbd>

        Click on **Approve once**.

    2. Review the vulnerability results by expanding the twisties.
    
        <kbd>![Bob_Java_Modernization_Workflow_Vulnerabilities2.png](./images/media/Bob_Java_Modernization_Workflow_Vulnerabilities2.png)</kbd>

        Click on **Approve once**.

    3. Next Bob wants to perform an initial build of the application. 
    
        <kbd>![Bob_Java_Modernization_Workflow_InitialBuild.png](./images/media/Bob_Java_Modernization_Workflow_InitialBuild.png)</kbd>

        Click on **Approve once**.

    4. Bob offers different options of application modernization. Select **Liberty Modernization** and select to **Disable Git Flow**.
    
        <kbd>![Bob_Java_Modernization_Workflow_ModernizationType.png](./images/media/Bob_Java_Modernization_Workflow_ModernizationType.png)</kbd>

        Click on **Continue**.

3. Upload and extract Migration plan

    Bob wants to read the AMA migration plan to better understand the modernization target and identified issues. The modernization plan will help to do the modernization in a more deterministic way. 
    1. Click on **Select File**

        <kbd>![Bob_Java_Modernization_Workflow_Request_migrationplan.png](./images/media/Bob_Java_Modernization_Workflow_Request_migrationplan.png)</kbd>

    2. Click on **Downloads**, then select the migration plan and click on  **Select File**

        <kbd>![Bob_Java_Modernization_Workflow_Upload_migrationplan.png](./images/media/Bob_Java_Modernization_Workflow_Upload_migrationplan.png)</kbd>

    3. Verify that the migration plan has been selected and click on  **Continue**

        <kbd>![Bob_Java_Modernization_Workflow_Uploaded_migrationplan.png](./images/media/Bob_Java_Modernization_Workflow_Uploaded_migrationplan.png)</kbd>

    4. Bob extracts the migration plan and wants to save the embedded Liberty server configuration file **server.xml**. Click on  **Approve once** for server.xml.

        <kbd>![Bob_Java_Modernization_Workflow_Extract_migrationplan.png](./images/media/Bob_Java_Modernization_Workflow_Extract_migrationplan.png)</kbd>


    5. Bob has analyzed the AMA reports and knows which issues have been identified. As  next step, Bob wants to download the recipes for the automated fixes. Click on **Approve once** to apply the automated fixes.

        <kbd>![Bob_Java_Modernization_Workflow_after_testing.png](./images/media/Bob_Java_Modernization_Workflow_after_testing.png)</kbd>

    6. The recipes will be applied. Wait until the process has completed.

        <kbd>![Bob_Recipes_applied.png](./images/media/Bob_Recipes_applied.png)</kbd>

    7. Click on **Recipes applied** to see more details.

        <kbd>![Bob_Recipes_applied_details.png](./images/media/Bob_Recipes_applied_details.png)</kbd>

        You can see that the **LogoutServlet.java** and the **Weatherservlet.java** have been changed. 
    
    4. To better compare what has changed, switch to the **Source Control** view and compare the files. Some files have been changed. For an instance,

        - The files **server.xml** has been copied over from the migration plan.
        - The file **server.env** has been created to make Liberty use Java 21.
        - The files **LogoutServlet.java** and the **Weatherservlet.java** have been changed by the recipes. 
        
        Click on **LogoutServlet.java** to view the changes.
        <kbd>![Bob_git_compare.png](./images/media/Bob_git_compare.png)</kbd>

    5. After reviewing the changes, close the comparison.

        <kbd>![Bob_git_compare.png](./images/media/Bob_git_compare2.png)</kbd>

3. Now that Bob resolved all issues with automated fixes via recipes, Bob will take a look at the remaining issues and will use agentic AI to resolve them. While the overall resolution steps will stay the same, there might be differences in the order and the recommendations provided by Bob.

    1. Fix the issues around **WebSphere Runtime APIs and SPIs**

        1. Bob wants to start a new subtask to fix the issues around the WebSphere Runtime APIs and SPIs.

            <kbd>![Bob_Fix_WebSphere_Runtimes.png](./images/media/Bob_Fix_WebSphere_Runtimes.png)</kbd>

            Click on **Approve once** to continue. 

        2. Bob creates a subtask and a **Todo** list to fix the issue based on the recommendations from the AMA migration plan.

            <kbd>![Bob_Fix_WebSphere_Runtimes2.png](./images/media/Bob_Fix_WebSphere_Runtimes2.png)</kbd>

            Review the Todo list (you could also edit it to add or remove steps). Finally, click on **Approve once** to continue. 


        3. Bob detects that the critical code no longer exists in the WeatherServlet. It wants to review the changes in git to understand why.

            <kbd>![Bob_Fix_WebSphere_Runtimes3.png](./images/media/Bob_Fix_WebSphere_Runtimes3.png)</kbd>

            Click on **Approve once** to continue. 

        4. Bob verified that the code was already changed (by the recipes), so no further action is required. Therefore, Bob wants to update the Todo list.

            <kbd>![Bob_Fix_WebSphere_Runtimes4.png](./images/media/Bob_Fix_WebSphere_Runtimes4.png)</kbd>

            Click on **Approve once** to continue. 
    
        5. Bob wants to execute the command "mvn compile". 

            <kbd>![Bob_Fix_WebSphere_Runtimes5.png](./images/media/Bob_Fix_WebSphere_Runtimes5.png)</kbd>

            Click on **Approve once** to continue. 

        6. Bob wants to update the Todo list.

            <kbd>![Bob_Fix_WebSphere_Runtimes6.png](./images/media/Bob_Fix_WebSphere_Runtimes6.png)</kbd>

            Click on **Approve once** to continue. 

        7. Bob wants to complete the subtask.

            <kbd>![Bob_Fix_WebSphere_Runtimes7.png](./images/media/Bob_Fix_WebSphere_Runtimes7.png)</kbd>

            Click on **Approve once** to continue. 

        8. Bob has created the summary what has been done in the subtask.
            You can expand the section to see the details.

            <kbd>![Bob_Fix_WebSphere_Runtimes8.png](./images/media/Bob_Fix_WebSphere_Runtimes8.png)</kbd>


    2. Fix the issues around **WebSphere Servlet API**

        1. Bob wants to start a new subtask to fix the issues around the WebSphere Servlet API. 

            <kbd>![Bob_Fix_WebSphere_ServletAPI1.png](./images/media/Bob_Fix_WebSphere_ServletAPI1.png)</kbd>

            Click on **Approve once** to get continue. 



        2. Bob creates a subtask and a Todo list  to fix the issue based on the recommendations from the AMA migration plan.

            <kbd>![Bob_Fix_WebSphere_ServletAPI2.png](./images/media/Bob_Fix_WebSphere_ServletAPI2.png)</kbd>

            Review the Todo list (you could also edit it if needed). 
            To reduce the number of approvals, you can allow Bob to update the Todo list for the subtask without approval. 
            Click on **Approve todo tools for task** to continue. 


        3. Bob explains the issue and proposes a solution based on **Apache Commons**.

            <kbd>![Bob_Fix_WebSphere_ServletAPI3.png](./images/media/Bob_Fix_WebSphere_ServletAPI3.png)</kbd>

            You can select to apply the recommended changes or to use a different approach. Let's see which different approaches are available.

            Enter in the chat window the following text to get alternatives:

                What are the alternatives?

            <kbd>![Bob_Fix_WebSphere_ServletAPI4.png](./images/media/Bob_Fix_WebSphere_ServletAPI4.png)</kbd>

            Then press ENTER or click the icon.    

        4. Bob comes back with a list of different alternatives.

            <kbd>![Bob_Fix_WebSphere_ServletAPI5.png](./images/media/Bob_Fix_WebSphere_ServletAPI5.png)</kbd>

            Your list of alternatives might look different; Bob might also decide to display the alternatives as list instead of a table.

            Select **Apache Commons** by clicking on the related field.

        5. Bob wants to edit the pom.xml.

            <kbd>![Bob_Fix_WebSphere_ServletAPI6.png](./images/media/Bob_Fix_WebSphere_ServletAPI6.png)</kbd>

            To reduce the number of approvals for the task, click on **Approve edit tools for task** to continue. 
    
        6. Bob wants to execute the command "mvn compile". 

            <kbd>![Bob_Fix_WebSphere_ServletAPI7.png](./images/media/Bob_Fix_WebSphere_ServletAPI7.png)</kbd>

            Click on **Approve for task** to continue. 

        7. Bob wants to complete the subtask.

            <kbd>![Bob_Fix_WebSphere_ServletAPI8.png](./images/media/Bob_Fix_WebSphere_ServletAPI8.png)</kbd>

            Click on **Approve once** to continue. 

        8. Bob has created the summary what has been done in the subtask.
            You can expand the section to see the details.

            <kbd>![Bob_Fix_WebSphere_Runtimes8.png](./images/media/Bob_Fix_WebSphere_Runtimes8.png)</kbd>


    3. Bob has completed the tasks related to **Replatform Liberty issues**. Let's review the performed tasks and validate the changes.
    
        1. Review what has been done so far:
    
            <kbd>![Bob_Replatforming_Summary.png](./images/media/Bob_Replatforming_Summary.png)</kbd>

    
        2. The next step is to deploy and validate.

            <kbd>![Bob_Start_Deployment.png](./images/media/Bob_Start_Deployment.png)</kbd>

            Click on **Start local deployment**.

        3. Bob will ask for permission to start the **Deploy** subtask.

            <kbd>![Bob_Start_Deployment1.png](./images/media/Bob_Start_Deployment1.png)</kbd>

            Click on **Approve once** to continue. 

        4. Bob will ask for permission to build the application.

            <kbd>![Bob_Start_Deployment2.png](./images/media/Bob_Start_Deployment2.png)</kbd>

            Click on **Approve once** to continue. 

        5. Bob rebuilt the application and will ask again for permission to install the application.

            <kbd>![Bob_Start_Deployment3.png](./images/media/Bob_Start_Deployment3.png)</kbd>

            Click on **Approve for task** to continue. 

        6. Bob wants to clean up the Liberty installation.

            <kbd>![Bob_Start_Deployment4.png](./images/media/Bob_Start_Deployment4.png)</kbd>

            Click on **Approve for task** to continue. 
        
        7. Bob wants to install the required Liberty features.

            <kbd>![Bob_Start_Deployment5.png](./images/media/Bob_Start_Deployment5.png)</kbd>

            Click on **Approve for task** to continue. 
        
        8. Bob wants to backup the server configuration and adjust it.

            <kbd>![Bob_Start_Deployment6.png](./images/media/Bob_Start_Deployment6.png)</kbd>

            Click on **Approve for task** to continue. 

        9. Bob wants to deploy the application.

            <kbd>![Bob_Start_Deployment7.png](./images/media/Bob_Start_Deployment7.png)</kbd>

            Click on **Approve for task** to continue. 

        10. Bob wants to start the Liberty instance.

            <kbd>![Bob_Start_Deployment8.png](./images/media/Bob_Start_Deployment8.png)</kbd>

            Click on **Approve for task** to continue. 

        11. Bob started Liberty and the application, analyzed the logs and detected some configuration issues. Therefore, Bob wants to stop the Liberty instance to clean up the Liberty configuration.

            <kbd>![Bob_Start_Deployment9.png](./images/media/Bob_Start_Deployment9.png)</kbd>

            Click on **Approve for task** to continue. 

        12. Bob started Liberty again and did some reconfiguration using Liberty hot-reloading. Now Bob wants to test the endpoints via curl:

            <kbd>![Bob_Start_Deployment10.png](./images/media/Bob_Start_Deployment10.png)</kbd>

            Click on **Approve for task** to continue. 

        13. Bob tested the first endpoint successfully and wants to test additional endpoints via curl:
        
            <kbd>![Bob_Start_Deployment11.png](./images/media/Bob_Start_Deployment11.png)</kbd>

            Click on **Approve for task** to continue. 

        14. Bob tested additional endpoints successfully and wants to test additional endpoints via curl:
        
            <kbd>![Bob_Start_Deployment12.png](./images/media/Bob_Start_Deployment12.png)</kbd>

            Click on **Approve for task** to continue. 

        15. Bob tested additional endpoints successfully and got some errors. Therefore, Bob wants to test additional endpoints via curl:
        
            <kbd>![Bob_Start_Deployment13.png](./images/media/Bob_Start_Deployment13.png)</kbd>

            Click on **Approve for task** to continue. 

        16. Bob tested all endpoints successfully. Now it asks you to review the logs. 
        
            <kbd>![Bob_Start_Deployment14.png](./images/media/Bob_Start_Deployment14.png)</kbd>

            Feel free to do so, you can find the log here: 
            **Explorer > target/liberty/wlp/usr/servers/modresorts/logs/messages.log**
        
            Then click on **Yes, the application started successfully with no errors** to continue. 


        17. Bob wants to complete the subtask. 
        
            <kbd>![Bob_Start_Deployment15.png](./images/media/Bob_Start_Deployment15.png)</kbd>

            Click on **Approve for task** to continue. 

        18. Bob created a summary with a diagram visualizing the performed tasks. [todo - add a new diagram]
        
            <kbd>![Bob_Visual_Summary.png](./images/media/Bob_Visual_Summary.png)</kbd>

            Click on the diagram to expand the diagram. 

            As you can see, the diagram contains details about the performed modernization as well as details about the costs and tokens for the different tasks.

            
        19. Open the browser and test the application to verify, that the initial issues are resolved. 
        
            In the browser, open the URL http://localhost:9080/resorts.
            Then navigate to **Where To > Paris** to verify that the error is gone. Do the same with the **Logout** button. 

        20. Switch back to Bob and ask Bob to stop the Liberty instance.

                Stop Liberty

            <kbd>![Bob_Stop_Liberty](./images/media/Bob_Stop_Liberty.png)</kbd>

            Wait until the Liberty instance has stopped.


You should now have a good understanding how IBM Bob can help to modernize your applications. 

### IBM Bob Recap

Congratulations, you have finished the application modernization part.

**Let’s recap what you did so far.** 

- You used the IBM Bob to apply automated fixes via fixes
- You used the IBM Bob to apply agentic AI to fix the remaining issues. 
- You tested successfully the modernized application on Liberty
- You got an idea how to use IBM Bob to upgrade the Java SE or Java EE level of the application.
- You also should have a good understanding how to use Bob for troubleshooting migration issues.

The next step is to deploy the application to MoRE.



# Starting WebSphere and IHS servers

The [`scripts/start-was-servers.sh`](scripts/start-was-servers.sh) script starts all preconfigured WebSphere components required for the lab, including the Deployment Manager, both node agents, and `webserver1`.

Run the following command to execute the script:

```sh
./scripts/start-was-servers.sh
```
After the script completes, the message `All servers have been started!` is displayed.

---
## Creating a static managed Liberty server cluster

This section guides you through the process of creating a static managed Liberty server cluster.

You can use either of the following methods to complete this task:
* If you prefer a visual, step-by-step experience, continue with [Option 1: Using the administrative console](#option-1-using-the-administrative-console).
* If you prefer automation or scripting, skip ahead to [Option 2: Using administrative scripting](#option-2-using-administrative-scripting).

## Option 1: Using the administrative console

1. Launch the **WAS Admin Console** by selecting it from your browser bookmarks or navigating to the https://localhost:9043/ibm/console URL.

   Log in using the following credentials:
   * User ID: `techzone`
   * Password: `IBMDem0s!` (Note that the zero is used instead of the letter "O")

2. Navigate to **Servers** &rarr; **Clusters** &rarr; **WebSphere application server clusters**. Click **New...** to create a new cluster.

   ![](assets/mlscluster-creation.png)

3. On **Step 1**, set **Cluster name** to `MLSCluster`. Leave the other fields as default. Click **Next**.

4. On **Step 2**, configure the first cluster member:

   * **Member Name**: `libertyServer`
   * **Select node**: `node1`
   * **Select basis for first cluster member**: choose **Create the member using an application server template**, then select `default-managed-liberty-server` from the dropdown

   Leave all other settings as default. Click **Next**.

5. On **Step 3**, configure the second cluster member:

   * **Member Name**: `libertyServer`
   * **Select node**: `node2`

   Leave the other fields as default. Click **Add Member**, then click **Next**.

6. On **Step 4**, review the configuration summary and click **Finish**.

7. Click <ins>Review</ins>.

   ![](assets/mlscluster-creation-review.png)

8. Select **Synchronize changes with Nodes**, then click **Save** to apply the configuration and synchronize with both nodes.

   ![](assets/mlscluster-creation-sync.png)

9. After synchronization completes, click **OK**.

   ![](assets/mlscluster-creation-sync-complete.png)

10. Return to **Servers** &rarr; **Clusters** &rarr; **WebSphere application server clusters**. Locate <ins>MLSCluster</ins> in the list and ensure it is present. Check the box next to it, then click **Start** to initiate the cluster. Wait until the status displays a green arrow, indicating that it is running.

    ![](assets/mlscluster-start.png)

> [!NOTE]
> After some wait, if the cluster does not show as started, you might want to check the servers status via **Servers** &rarr;  **All Servers** &rarr; and then the cluster servers. If the  servers are started, you are ready to go.

## Option 2: Using administrative scripting

Run the following command to create and start the cluster using the provided Jython script [`createMLSCluster.py`](scripts/createMLSCluster.py):

```sh
/home/techzone/IBM/WebSphere/AppServer/profiles/Dmgr01/bin/wsadmin.sh \
  -lang jython -user techzone -password IBMDem0s! \
  -f /home/techzone/Student/tx-more-lab/scripts/createMLSCluster.py
```

The script performs the following actions:

* Creates the static cluster named `MLSCluster`
* Adds one managed Liberty server on each node
* Synchronizes the configuration across nodes
* Starts the Liberty cluster

When the cluster starts successfully, the message `!!!Successfully started the cluster!!!` is displayed.

---
# Deploy the modernised application ModResort to MoRE

## Building the application WAR file

Before deploying the application, build it to generate the application WAR file:

```sh
cd /home/techzone/Student/tx-more-lab-2026

cd modresorts-project
mvn clean package
```

The WAR file `modresorts-2.0.0.war` is created in the project's `target` directory and will be used for deployment to the Liberty cluster.

## Option 1: Using the administrative console

This section walks you through deploying the application using the administrative console.

If you prefer to use a script, skip ahead to [Option 2: Using administrative scripting](#option-2-using-administrative-scripting).

### Installing the application WAR file

1. Launch the **WAS Admin Console** by selecting it from your browser bookmarks or navigating to the https://localhost:9043/ibm/console URL.

2. Go to **Applications** &rarr; **New Application** &rarr; <ins>New Enterprise Application</ins>.

   ![](./images/media/new-app.png)

3. In the installation panel:

   * Under **Path to new application**, select **Local file system** and choose the WAR file located at `/home/techzone/Student/tx-more-lab-2026/modresorts-project/target/modresorts-2.0.0.war`
   * Set **Target Runtime Environment** to `Jakarta EE 10`
   
   Click **Next** and wait for the application to upload.

   ![](./images/media/module1-new-app-installation.png)

4. Choose **Fast Path** and click **Next**.

5. Leave **Step 1** unchanged and click **Next**.

6. On **Step 2**, map the application module:

   * Under **Cluster and servers**, select both `MLSCluster` and `webserver1` by holding **Shift** or dragging between options.

   * Check the box next to `modresorts-2.0.0.war` and click **Apply**.

   * Confirm that both `MLSCluster` and `webserver1` are now listed under the **Server** column for the `modresorts-2.0.0.war` module.
   
   Click **Next**.

   ![](./images/media/module1-map-modules-to-servers.png)

7. On **Step 3**, confirm that the **Context Root** is set to `/resorts` and click **Next**.

8. On **Step 4**, review the installation summary and click **Finish**.

9. After the installation completes, click <ins>Review</ins>. 
   
   Select **Synchronize changes with Nodes**, and click **Save**. Click **OK** when synchronization is complete.

### Generating and propagating the web server plug-in

1. Go to **Servers** &rarr; **Server Types** &rarr; **Web servers**.
   
   ![](./images/media/webserver.png)

2. Select `webserver1` and click **Generate Plug-in**.

3. Select `webserver1` again and click **Propagate Plug-in**.

After plug-in generation and propagation are complete, verify that the application is running by following the steps in [Checking out the application](#checking-out-the-application).

## Option 2: Using administrative scripting

This section walks you through deploying the application using the administrative console.

Run the following command to deploy the application using the provided Jython  script [`deployModResorts.py`](deployModResorts.py):

```sh
/home/techzone/IBM/WebSphere/profiles/Dmgr01/bin/wsadmin.sh \
  -lang jython -user techzone -password IBMDem0s! \
  -f /home/techzone/Student/tx-more-lab-2026/modresorts-project/deployModResorts.py
```

The script performs the following actions:

* Installs the `modresorts-2.0.0.war` WAR file to the managed Liberty cluster `MLSCluster`
* Maps the application to both `MLSCluster` and `webserver1`
* Generates and propagates the web server plug-in configuration

After the script finishes, the message `ModResorts successfully deployed!` is displayed. Wait for a while to let the application to start. Verify that the application is running by following the steps in [Checking out the application](#checking-out-the-application).

## Checking out the application

Because the application is accessible via IHS, use the following URLs based on the connection type:
* **SSL (HTTPS):** https://localhost:8888/resorts _(also available in bookmarks as Mod Resorts)_
* **Non-SSL (HTTP):** http://localhost:7777/resorts

To confirm the application is functioning correctly, launch it and open the **Where to?** drop-down menu. Select any destination from the list—if successful, the relevant weather details should load and display without error messages.

![](./images/media/modresorts.png)

---
# Troubleshooting

This section provides guidance on troubleshooting common issues during the lab.

## Resetting the lab environment

If you encounter problems or want to start the lab from scratch, you can reset the environment to its original state by running:

```sh
/home/techzone/Student/tx-more-lab-2026/scripts/reset-lab-env.sh
```

To remove the cloned lab repository, run:

```sh
cd /home/techzone/Student
rm -rf tx-more-lab-2026
```

This ensures you’re starting from a clean workspace.




