# IBM Modernized Runtime Extension for Java Hands-On Lab 1648 in TechXchange 2026


**Duration:** 90 minutes

# Introduction

[IBM Modernized Runtime Extension for Java](https://www.ibm.com/docs/en/more) (MoRE) is an extension of WebSphere® Application Server Network Deployment (ND) 9.0.5 that enables you to run and manage Liberty servers from the traditional WebSphere environment. With MoRE, Liberty servers can be configured, clustered, and administered using familiar tools like the administrative console and wsadmin scripting.

## About this hands-on lab

This lab provides fundamental hands-on experience of the evaluation process of WebSphere application for their modernization journey to MoRE. It shows the value of using Application Modernization Accelerator (AMA) to evaluate on-premises Java applications, modernise using IBM Bob and then deploy to MoRE. In this interactive, hands-on lab, you'll explore the cutting-edge capabilities of WebSphere Application Server and MoRE, which are designed to supercharge your modernization journey. 

Through guided modules, you'll deploy modern Jakarta EE to a Managed Liberty server, using the WebSphere Administrative Console and/or automation with wsadmin scripts. Whether you're modernizing legacy systems or building cloud-native apps, this lab is your launchpad into the next generation of enterprise application management.

Upon completion of this lab, you will have gained experience using AMA to quickly analyze on-premises Java applications without accessing their source code, estimate the effort in moving to container-based clouds, and using IBM Bob to update the source code to accelerate your application modernization journey to MoRE.

---
# Getting started

This section guides you through the initial setup of the lab environment. Perform all tasks from the student virtual machine.

## Lab environment overview

The lab environment is preinstalled with the following packages:
* The Application Modernization Accelerator, version 5.0
* IBM Bob
* WebSphere Application Server Network Deployment (ND), version 9.0.5.28, running on Java SE 8

    * Modernized Runtime Extension for Java (MoRE), version 1.0.4.0

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

## Starting WebSphere and IHS servers

The [`scripts/start-was-servers.sh`](scripts/start-was-servers.sh) script starts all preconfigured WebSphere components required for the lab, including the Deployment Manager, both node agents, and `webserver1`.

Run the following command to execute the script:

```sh
./scripts/start-was-servers.sh
```
After the script completes, the message `All servers have been started!` is displayed.

---
# Creating a static managed Liberty server cluster

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
# Next steps

Proceed to [Module 1](module1/README.md) to deploy a Java 21 and Jakarta EE 10 application to the managed Liberty cluster.

---
# Troubleshooting

This section provides guidance on troubleshooting common issues during the lab.

## Resetting the lab environment

If you encounter problems or want to start the lab from scratch, you can reset the environment to its original state by running:

```sh
/home/techzone/Student/tx-more-lab/scripts/reset-lab-env.sh
```

To remove the cloned lab repository, run:

```sh
cd /home/techzone/Student
rm -rf tx-more-lab-2026
```

This ensures you’re starting from a clean workspace.



## 5. Explore Application Modernization Accelerator
In this section, you will explore the main capabilities of Application Modernization Accelerator. You will use the sample data that is shipped with the product. 

### 5.1 Start AMA

Application Modernization Accelerator(AMA) is already installed and typically running. 

Let's check if AMA is already started. This can be validated by reviewing if the related podman containers are started. 

1. Open a terminal by clicking on Activities and selecting terminal.

    <kbd>![Toolbar_terminal](./images/media/Toolbar_terminal.png)</kbd>

    The terminal window opens.  

    <kbd>![Terminal](./images/media/Terminal.png)</kbd>

    HINT: By default, the terminal window has a dark background.

2. Access the AMA launch script to verify if AMA is started or not

        cd ~/usr/IBM/application-modernization-accelerator-local-*
        ./launch.sh

        
    Check the status if AMA is started. 
    If AMA **is available** (see screenshot below), enter **q** to quit the menu and keep AMA running. 

    <kbd>![AMA_Launcher](./images/media/AMA_Launcher.png)</kbd>

    If AMA is avalable, enter **q** to quit the script.

    If AMA is **not running** (see screenshot below), enter **5** to start AMA. 
    <kbd>![AMA_Launcher_stopped](./images/media/AMA_Launcher_stopped.png)</kbd>
        
    Wait until AMA has started and the URL is displayed
    <kbd>![AMA_Launcher_stopped](./images/media/AMA_Launcher_started.png)</kbd>



### 5.2 Explore the AMA User Interface
To explore the AMA User Interface, you will create a workspace with sample data. A workspace is a designated area that will house the migration recommendations provided by AMA for existing applications and/or environments. You can name and organize these however you want, whether it’s by business application, location, or teams.
Later on, you will create another workspace for the WebSphere landscape used in this lab environment.

1. Access the AMA UI and create a workspace with sample applications.
    1. Open a browser window by clicking on **Activities** and then select the **Firefox** browser icon.

        <kbd>![Toolbar_firefox](./images/media/Toolbar_firefox.png)</kbd>

    2. Access the AMA User Interface via the URL https://localhost:3000

        If you get a warning, that there is a potential security risk, click on **Advanced** and then **Accept the Risk and Continue**. 

        <kbd>![AMA_Potential_Security_Risk](./images/media/AMA_Potential_Security_Risk.png)</kbd>
    
        Finally, you should see the Application Modernization Overview Screen.

        <kbd>![AMA_Initial_Screen](./images/media/AMA_Initial_Screen0.png)</kbd>
    
        Click the button to **Accept all** to accept all cookies.
        An introduction wizard is displayed.

        <kbd>![AMA_Initial_Screen-Intro.png](./images/media/AMA_Initial_Screen-Intro.png)</kbd>
    
        Click through the wizard and finally close it.
        Your screen should now look like this:

        <kbd>![AMA_Initial_Screen](./images/media/AMA_Initial_Screen.png)</kbd>
    

    3. Click on the button **Create workspace** and enter **Sample_Data**, select **include sample data**, then click on **Create**.

        <kbd>![AMA_Workspace_Sample_Data](./images/media/AMA_Workspace_Sample_Data.png)</kbd>
    
    4. The workspace will be created.
        <kbd>![AMA_Workspace_Sample_Data](./images/media/AMA_Workspace_Sample_Data_create.png)</kbd>
    
    5. Wait until the workspace has been created which can take a minute or so. Finally, you will see that the workspace has been created and contains 29 sample applications, 7 databases and 9 queues.
        <kbd>![AMA_Workspace_Sample_Data_created](./images/media/AMA_Workspace_Sample_Data_created.png)</kbd>
    
2. Explore the workspace with the sample applications

    1. Click on the workspace to open it.

    2. AMA supports three destinations, **Liberty**, **MoRE** and **WebSphere Application Server** (Traditional)
    
        <kbd>![AMA_Select_Destination](./images/media/AMA_Select_Destination.png)</kbd>
    
    3. Select **Liberty** as destination and click on **Confirm**.
    
        <kbd>![AMA_Select_Liberty](./images/media/AMA_Select_Liberty.png)</kbd>
    

    4. The **Visualization** panel shows all applications and how they relate to each other regarding common databases or queues.

        As this is a AMA trial version, a pop-up will be shown in the upper right. Close the pop-up.

        <kbd>![AMA_Visualization_SampleData_PoC](./images/media/AMA_Visualization_SampleData_PoC.png)</kbd>

        Now zoom in to see the application names.


        <kbd>![AMA_Visualization_SampleData_Increased](./images/media/AMA_Visualization_SampleData_Increased.png)</kbd>
    
        You can filter by name to see only specific applications and dependencies. (For example, filter for the application ACME.)

        <kbd>![AMA_Visualization_Filter_by_Name](./images/media/AMA_Visualization_Filter_by_Name.png)</kbd>
    
        You can also filter by library to see only specific applications and dependencies. (For example, filter for Spring libraries.)

        <kbd>![AMA_Visualization_Filter_by_Library](./images/media/AMA_Visualization_Filter_by_Library.png)</kbd>
    
    As you can see in the screenshot above, the visualization provides insight which applications share the same database or queue which helps to shape your migration strategy.



    5. Switch to the **Assessment** tab 

        <kbd>![AMA_Assessment_Tab](./images/media/AMA_Assessment_Tab.png)</kbd>
    
        The assessment tab provides insight into the different applications.
        <kbd>![AMA_Assessment_Overview](./images/media/AMA_Assessment_Overview.png)</kbd>
    
    6. Take a look at the upper part

        <kbd>![AMA_Assessment_Total.png](./images/media/AMA_Assessment_Total.png)</kbd>

        - Under **Applications**, you can change the destination including the Java SE and Java EE level.
        - Under **Total Applications**, you can see the effort for the chosen target. AMA also analyzes all the application code and common code that is shared across applications and provides an estimated total cost for migrating the apps and common code in the workspace. 
        
        Total cost is the number of days of development cost to migrate that code to run on the selected migration target. In this example, WebSphere Liberty is the selected migration target.

    7. Change the Java SE Level and the Java EE level to find out how the overall effort changes. As you can see the estimated efforts change.

        <kbd>![AMA_Assessment_Total2.png](./images/media/AMA_Assessment_Total2.png)</kbd>

        Finally, change the Java SE and Java EE level back to the minimum to see the efforts for the quickest path of modernization.

    8. Take a look further down at the application list.

        <kbd>![AMA_Assessment_Application_List.png](./images/media/AMA_Assessment_Application_List.png)</kbd>
    
        The “All Java applications” page also shows the application summary analysis results for all the apps from the AppSrv01 profile for each of the selected migration targets.

        For each app / migration target combination, you can see these results:

        - Java application
        - Collection / Profile name
        - Complexity
        - Issues
        - Required code changes
        - Application cost (in days)
        - Migration plan

        The following details are included in the summary table (this is the per-application view):

        - Application Name: The name of the EAR/WAR file found on the application server.

        - Collection/Profile: Collection represents the hostname of the machine where the application resides. The profile represents the profile name in the application server where the application is installed.

        - Complexity: Indicates how complex Transformation Advisor considers this application to be if you were to migrate it to the cloud.

        - Issues: The number and severity of potential issues with the migration of the application.

        - Required code changes: Indicates the type of code change needed.

        - Application cost in days: Provides an estimate in days for the development effort to perform the migration for just this application. Cost estimates calculated by Transformation Advisor are high-level estimates only and may vary widely based on skills and other factors not considered by the tool.

        - Migration plan: accelerator files generated by Transformation advisor to aide in building and deploying the selected application to the target runtime.

    9. Feel free to expand the one or other app to see more details about an application.
        <kbd>![AMA_Assessment_Application_Expanded.png](./images/media/AMA_Assessment_Application_Expanded.png)</kbd>
    

### 5.3 Explore the AMA APIs
Application Modernization Accelerator (AMA) also provides Swagger interfaces to access some of the data via APIs.

1. Open a browser and enter the following URL:
    https://localhost:2220/openapi/ui/

    If you get a warning, that there is a potential security risk, click on **Advanced** and then **Accept the Risk and Continue**. 

    <kbd>![AMA_Potential_Security_Risk](./images/media/AMA_Potential_Security_Risk2.png)</kbd>

    Finally, the Swagger UI opens:

    <kbd>![AMA_Swagger_APIs.png](./images/media/AMA_Swagger_APIs.png)</kbd>

2. Look at the different APIs which allow to create a new workspace, upload a data collection or bulk, upload the license key and much more.

    Scroll down to the section **collection archives**.
    <kbd>![AMA_Swagger_APIs2.png](./images/media/AMA_Swagger_APIs2.png)</kbd>

    To create for example the demo workspace which you just created manually, you could use the **uploadSampleData** API via the following command:

        curl -k -X 'POST' \
        'https://localhost:2220/lands_advisor/advisor/v2/collectionArchives/uploadSampleData' \
          -H 'accept: */*' \
          -H 'locale: en' \
          -H 'workspaceName: Sample_Data' \
          -d ''

3. Close the browser window with the Swagger UI.


<br>
Right now, you just explored the capabilities of AMA based on sample data. In the next section, you will analyze the modresorts application to identify the efforts to migrate it from traditional WAS to Liberty. You will use the AMA Discovery tool to gather the data collection from an existing WebSphere installation and perform some analysis.
Then you will use the AMA Dev Tools to make the required code changes.


## 6. Build and analyze the modresorts application.

### 6.1 Verify the installed software 

1. Open a terminal by clicking on Activities and selecting terminal.

    <kbd>![Toolbar_terminal](./images/media/Toolbar_terminal.png)</kbd>

    The terminal window opens.

    <kbd>![Terminal](./images/media/Terminal.png)</kbd>

2. Check the Maven version via the following command:

        mvn -version


    <kbd>![mvn-v](./images/media/mvn-v.png)</kbd>
    
    The version might be slightly different, but must be higher than 3.8.5


3. Check the Git version via the following command:

        git -v

    <kbd>![git-v](./images/media/git-v.png)</kbd>

    The version might be slightly different.

### 6.2 Create the required working directories

1. Create the Student directories and some sub-directories used in the lab with commands:

       mkdir ~/Student
       mkdir ~/Student/assets
       mkdir ~/Student/backup

### 6.3 Build and deploy the WebSphere applications

The objective of this section is to assess the simple-pharmacy application that has been deployed to a traditional WAS 9 instance.

#### 6.3.1 Build the WAS application

1. Clone the repository to get access to the application binaries and more.

       rm -rf ~/Student/temprepo/
       git clone https://github.com/LarsBesselmann/LibertyGettingStarted-2026-AMA-Lab ~/Student/temprepo
       mv ~/Student/temprepo/modresorts-project ~/Student
       rm -rf ~/Student/temprepo/

2. Install the required WAS library

       cd ~/Student/modresorts-project/

       mvn install:install-file -Dfile=/home/itzuser/usr/IBM/WebSphere/AppServer/dev/was_public.jar -DpomFile=/home/itzuser/usr/IBM/WebSphere/AppServer/dev/was_public-9.0.0.pom

    Make sure that the build is successful.

    <kbd>![mvn-install_WAS_library](./images/media/mvn-install_WAS_library.png)</kbd>

3. Build the application
    
       mvn clean package

    <kbd>![modresorts_mvn_build_tWAS_1.png](./images/media/modresorts_mvn_build_tWAS_1.png)</kbd>

    <kbd>![modresorts_mvn_build_tWAS_1.png](./images/media/modresorts_mvn_build_tWAS_2.png)</kbd>

4. Copy the generated war file into the assets directory
    
        cp ~/Student/modresorts-project/target/modresorts-2.0.0.war ~/Student/assets/


#### 6.3.2 Deploy the WebSphere application and test it

The application has not been installed to traditional WAS so far. You will now perform the following steps:
- Start the WAS ND Deployment Manager and a Node Agent
- Deploy the application via wsadmin to the WAS ND server1 instance
- Configure WAS for the application
- Start server1
- Test the application if it works fine on traditional WAS.

1. In the terminal window, enter the following command to start the Deployment Manager

        ~/usr/IBM/WebSphere/AppServer/profiles/Dmgr01/bin/startManager.sh

    Wait until the Deployment Manager has been started

    <kbd>![tWAS_dmgr-start](./images/media/tWAS_dmgr-start.png)</kbd>

2. Enter the following command to start the Note Agent

       ~/usr/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/startNode.sh

    Wait until the Node agent has been started
    
    <kbd>![tWAS_node-start](./images/media/tWAS_node-start.png)</kbd>

3. Deploy the application using wsadmin by entering the following commands:

        cd ~/Student/modresorts-project/tWAS-Scripts

        ~/usr/IBM/WebSphere/AppServer/profiles/Dmgr01/bin/wsadmin.sh -f ./modresorts_install.py

    <kbd>![tWAS_install_modresorts](./images/media/tWAS_install_modresorts.png)</kbd>


4. Set the URLProvider which is used by the modresorts application via wsadmin by entering the following commands:

        ~/usr/IBM/WebSphere/AppServer/profiles/Dmgr01/bin/wsadmin.sh -f ./setURLProvider.py

    <kbd>![tWAS_set_URLProvider](./images/media/tWAS_set_URLProvider.png)</kbd>

5. Enter the following command to start the WAS server server1

       ~/usr/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/startServer.sh server1

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

        ~/usr/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/stopServer.sh server1
        ~/usr/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/stopNode.sh
        ~/usr/IBM/WebSphere/AppServer/profiles/Dmgr01/bin/stopManager.sh

As you have seen, the application works without any issue on WebSphere Traditional v9. The next step is to assess the application via AMA to find out which issues must be resolved to make the application work on Liberty with Java 8.

### 6.4 Create an AMA data collection for the WAS applications

You will now switch back to the AMA User Interface and create a new workspace called **Evaluation**. Then you will download the AMA Discovery Tool to scan the existing WebSphere landscape.

To evaluate on-premises Java applications, you need to run the AMA Discovery Tool against the Application server environment. It will extract application information from the environment. The utility can be downloaded from the AMA.

1. Create in AMA a new workspace and download the AMA Discovery Tool.
    1. Switch back to the browser and open the existing AMA window.
    Then click on **Home**
        
        <kbd>![AMA_Assessment_Home.png](./images/media/AMA_Assessment_Home.png)</kbd>

        (If you closed the browser window, open a new browser window and enter the URL https://localhost:3000)

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
        
        Change the domain and you can see that the command will change.
        Finally, switch back to the **IBM WebSphere** Domain. 

        c. Select the Analysis type
        
        Open the twisty to see the different analysis types:

        <kbd>![AMA_Discovery_Run_4](./images/media/AMA_Discovery_Run_4.png)</kbd>
        
        Change the analysis type and you can see that the command will change. Finally, switch back to the **Apps & Configuration** analysis. 
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

    3. Wait until the analysis has completed. As you can see, 4 applications have been analyzed, and the resulting data collection has been automatically uploaded. 

        <kbd>![AMA_Discovery_Run_9](./images/media/AMA_Discovery_Run_9.png)</kbd>
    
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
    You will be asked to specify the modernization destination. Select **Liberty** as destination and click on **Confirm**.
    
        <kbd>![AMA_Select_Liberty](./images/media/AMA_Select_Liberty.png)</kbd>

        The Evaluation workspace will open in the Visualization View. 
    
        <kbd>![AMA_Visualization_Evaluation](./images/media/AMA_Visualization_Evaluation.png)</kbd>

        You can see the 4 applications that have been discovered.

    
    **IMPORTANT!**
    
    As backup for this lab, we have placed the data collection archive (zip file) at: ~/Student/modresorts-project/ama/Dmgr01.zip. 
    ___

### 6.5 Assess the applications using AMA

In this section of the lab, you will explore assessment details for the **modresorts** application. 

#### 6.5.1 Assess the applications using the AMA Trial

1. In the AMA Visualization View, you can see that the modresorts application has no connections to a database or queue.
 
    <kbd>![AMA_Visualization_Evaluation](./images/media/AMA_Visualization_Evaluation2.png)</kbd>

2. Switch to the Assessment View.

    <kbd>![AMA_Assessment_Tab2](./images/media/AMA_Assessment_Tab2.png)</kbd>

    You can see the assessment details for the 4 applications and the efforts to modernize them to Liberty.
    <kbd>![AMA_Evaluation_AllApplications](./images/media/AMA_Evaluation_AllApplications.png)</kbd>

3. In the environment, the trial version of AMA is used. Therefore, the assessment of the applications for higher Java SE level or Java EE level is only supported for sample data workspaces but not in this workspace. You would need a different access key to unlock the option. This will be done later.

    <kbd>![AMA_Evaluation_Assessment_Trial](./images/media/AMA_Evaluation_Assessment_Trial.png)</kbd>


4. You will now assess the modresorts application.

    1. Enter as filter the text *modr** to see only the modresorts application. 

        <kbd>![AMA_Evaluation_modresorts.png](./images/media/AMA_Evaluation_modresorts.png)</kbd>

        The application modresorts has been assessed
        - of complexity **Moderate**, which means that code changes might be required
        - **5 severe issues** have been identified with need to be fixed
        - some of the required code changes can be done automated via recipes
        - the estimated development effort is 2.5 days
    
    2. Click on the application to get more details
        
        <kbd>![AMA_Evaluation_Assessment-modresorts.png](./images/media/AMA_Evaluation_Assessment-modresorts.png)</kbd>

    
    3. Scroll down to the section **`Complexity Score`** and expand the list of issues. 

        <kbd>![AMA_Evaluation_Assessment-modresorts2.png](./images/media/AMA_Evaluation_Assessment-modresorts2.png)</kbd>


        Here, you get insights into the related issues that may require code changes or configuration changes. 

        *In this example, there is 5 issues of which 3 have an automated fix:*

        - **Avoid using the deprecated WSSecurityHelper revokeSSOCookies and getLTPACookieFromSSOToken methods**
        - **Use the default InitialContext JNDI properties**
        - **The WebSphere Servlet API was superseded by a newer implementation**
        - **Getting the server name on Liberty**
        - **The WebSphere Runtime APIs and SPIs are unavailable**

        There are also 4 **informational issue** which are well known and documented how to resolve by the migration tools.

        <kbd>![AMA_Evaluation_Assessment-modresorts3.png](./images/media/AMA_Evaluation_Assessment-modresorts3.png)</kbd>

    4. Scroll down to the section **Issues**. 

        As you can see, there are no issues in common code.

        <kbd>![AMA_Evaluation_Assessment-modresorts3a.png](./images/media/AMA_Evaluation_Assessment-modresorts3a.png)</kbd>

        Under **Unique Code Issues**, expand the list of **Technology issues**.

        <kbd>![AMA_Evaluation_Assessment-modresorts4.png](./images/media/AMA_Evaluation_Assessment-modresorts4.png)</kbd>

        Expand any of the 5 issues and you can get more details about the issue, recommended changes and which code is impacted. But this capability is not available with a trial access key.

        <kbd>![AMA_Evaluation_Assessment-modresorts4.png](./images/media/AMA_Evaluation_Assessment-modresorts4a.png)</kbd>
        You will come back to this section later when the PoC access key has been applied.


    5. In addition to the information in the view, AMA also provides different kinds of reports:

        <kbd>![AMA_Evaluation_Assessment-modresorts5.png](./images/media/AMA_Evaluation_Assessment-modresorts5.png)</kbd>

        - The **Inventory Report** helps you examine what is in your application, including the number of modules and the technologies in those modules. It also gives you a view of all the utility JAR files in the application that tend to accumulate over time. Potential deployment problems and performance considerations are also covered.
       
        - The **Technology Report** identifies the editions of WebSphere Application Server that are best suited to run the application. The report provides a list of Java EE programming models that are used by the application and indicates which platforms will support the application.

        - The **Analysis Report** does a deep dive on the preferred migration target to help you understand any migration issues, like deprecated or removed APIs, Java SE version differences, and Java EE behavioural differences. Note that Application Modernization Accelerator uses a rule system based on commonly occurring events that are seen in real applications to enhance the base reports and provide practical guidance. As a result, some items may show a different severity level in Application Modernization Accelerator than they do in the detailed binary scanner reports. 

        The **Analysis Report** is greyed out and not available with an AMA trial access key.
        Feel free to look at the other two reports.

    
    Scroll to the top and you can see that the migration plan is locked.

    <kbd>![AMA_Evaluation_Assessment-migrationplan-locked.png](./images/media/AMA_Evaluation_Assessment-migrationplan-locked.png)</kbd>


#### 6.5.2 Assess the applications using the AMA PoC key
Now lets apply an AMA Access Key so that you get access to the analysis detals and the migration plan. 

This section explains how to apply the access key via AMA User Interface. You could also run the following command to apply the key:

        sh ~/software/AMA/AMA_apply_PoC_Key.sh 


**Apply the AMA access key via User Interface**


1. Click on **Trial days left** on the top of the page

    <kbd>![AMA_Evaluation_ApplyLicenseKey1.png](./images/media/AMA_Evaluation_ApplyLicenseKey1.png)</kbd>

2. In the pop-up, click on **Upload access key**

    <kbd>![AMA_Evaluation_ApplyLicenseKey2.png](./images/media/AMA_Evaluation_ApplyLicenseKey2.png)</kbd>

3. Click on **click to upload**

    <kbd>![AMA_Evaluation_ApplyLicenseKey3.png](./images/media/AMA_Evaluation_ApplyLicenseKey3.png)</kbd>


4. Navigate to **home > itzuser > software > AMA** and select the AMA key file, then cick on **Open**,

    <kbd>![AMA_Evaluation_ApplyLicenseKey4.png](./images/media/AMA_Evaluation_ApplyLicenseKey4.png)</kbd>

5. Click on **Upload**

    <kbd>![AMA_Evaluation_ApplyLicenseKey5.png](./images/media/AMA_Evaluation_ApplyLicenseKey5.png)</kbd>

6. The PoC wizzard will be shown. Feel free to walk through the wizard, then close it.

    <kbd>![AMA_Evaluation_ApplyLicenseKey6.png](./images/media/AMA_Evaluation_ApplyLicenseKey6.png)</kbd>

    As you can see, the display on the top right now switched to **Proof of Concept** and shows that there are 3 applications remaining. This means that you got access to analyze 3 applications.

    <kbd>![AMA_Evaluation_ApplyLicenseKey7.png](./images/media/AMA_Evaluation_ApplyLicenseKey7.png)</kbd>


7. The next step is to add the **modresorts** application to the PoC.   Click on **Add to PoC**

    <kbd>![AMA_Evaluation_ApplyLicenseKey8.png](./images/media/AMA_Evaluation_ApplyLicenseKey8.png)</kbd>

8. You will be asked to confirm that you want to **modresorts** application to the PoC. Click on **Confirm**.

    <kbd>![AMA_Evaluation_ApplyLicenseKey9.png](./images/media/AMA_Evaluation_ApplyLicenseKey9.png)</kbd>

9. As you can see, the application has been added to the PoC and the migration plan has been unlocked.

    <kbd>![AMA_Evaluation_ApplyLicenseKey9a.png](./images/media/AMA_Evaluation_ApplyLicenseKey9a.png)</kbd>

    Before we will go to the migration plan, we will take a look at some other unlocked capabilities.

10. Take a look at the left and you can see that the **Analysis report** has been unlocked.

    <kbd>![AMA_Evaluation_ApplyLicenseKey9b.png](./images/media/AMA_Evaluation_ApplyLicenseKey9b.png)</kbd>

    Feel free to look into the report.

11. Scroll down to the section **Issues**. 

    Under **Unique Code Issues**, expand the list of **Technology issues**.

    <kbd>![AMA_Evaluation_Assessment-modresorts4.png](./images/media/AMA_Evaluation_Assessment-modresorts4.png)</kbd>

    Expand any of the 5 issues and you can get more details about the issue, recommended changes and which code is impacted. 

    <kbd>![AMA_Evaluation_Assessment-modresorts4b.png](./images/media/AMA_Evaluation_Assessment-modresorts4b.png)</kbd>
    
    **This capability is not available with the trial access key.**


### 6.6  Examine the Liberty modernization assets generated by AMA

AMA not only provides great insights about your applications that you consider modernizing to WebSphere Liberty, but it also generates deployment accelerators for building and deploying the application on Liberty, containers, and Kubernetes based clouds. 

In this section, we take a quick peak at the **Liberty server configuration** `server.xml` that AMA generates, based on the analysis of the WebSphere configuration when the Transformation Advisor data collector was run against the WebSphere server on the VM.  

Simply put, AMA creates the server.xml file that contains the Liberty server configuration required to run the application on Liberty.  

1.	On the modresorts page, click on the button in the upper right called **View migration plan**.

    <kbd>![AMA_Evaluation_Assessment-modresorts6.png](./images/media/AMA_Evaluation_Assessment-modresorts6.png)</kbd>

 
2.	The **Migration plan** displays a "partial list" of files generated by AMA to assist in the migration of the application.

    - **server.xml:** the configuration for the Liberty server
    - **pom.xml:** Build the application using Maven
    - **Containerfile:** Create the Docker image for the application
    - **application-cr.yaml:** Custom Resource for the application to be deployed to OpenShift via the Open Liberty Operator
    - **secret.yaml:** Configuration file for defining secrets etc. in Kubernetes

    <kbd>![AMA_Evaluation_Assessment-modresorts7.png](./images/media/AMA_Evaluation_Assessment-modresorts7.png)</kbd>

3.	Click to view the contents of the **server.xml** file.
	The **server.xml** is displayed in the File preview window, click **`Show more`** to expand it.    
    <kbd>![AMA_Evaluation_Assessment-modresorts8.png](./images/media/AMA_Evaluation_Assessment-modresorts8.png)</kbd>

4.	Review the contents of the **server.xml** file.

    Notice that AMA generated the **server.xml** file that includes the Liberty server configuration that has been mapped from the original WebSphere traditional application server. 

    When the AMA Discovery Tool was run against the WebSphere Application server, it analyzed the applications and the WebSphere server configuration. The WAS server configuration data was used to generate an appropriate server.xml file to configure the application on Liberty. 

    a.	The **Liberty features** that the application uses are configured. 

    <kbd>![AMA_Evaluation_Assessment-modresorts9a.png](./images/media/AMA_Evaluation_Assessment-modresorts9a.png)</kbd>

    b.	The **application endpoints** and **enterprise application module configuration** including **context root**, **Security roles** used by the application are configured. Notice that **variables ${ }** are used to simplify external configuration overrides and default values. 

    <kbd>![AMA_Evaluation_Assessment-modresorts9b.png](./images/media/AMA_Evaluation_Assessment-modresorts9b.png)</kbd>

    c.	**Resource configurations** like URLProviders, JDBC or JMS Provider, etc.

    <kbd>![AMA_Evaluation_Assessment-modresorts9c.png](./images/media/AMA_Evaluation_Assessment-modresorts9c.png)</kbd>


    d.	**Variables** with default values, where it makes sense are configured.
    These variables are used to make the configuration portable so that it can be used in different stages.

    <kbd>![AMA_Evaluation_Assessment-modresorts9d.png](./images/media/AMA_Evaluation_Assessment-modresorts9d.png)</kbd>

    The variables are easily overridden by environment variables or configMaps and secrets in Kubernetes environments. 

    e. Close the File Preview, then scroll down and open the twisty to see application dependencies. As you can see, the application has no dependencies

    <kbd>![AMA_Evaluation_Assessment-modresorts10.png](./images/media/AMA_Evaluation_Assessment-modresorts10.png)</kbd>


5. Click to download the **Migration Plan** generated by AMA.

    <kbd>![AMA_Evaluation_Assessment-modresorts11.png](./images/media/AMA_Evaluation_Assessment-modresorts11.png)</kbd>

    The migration plan will be downloaded to the Downloads directory.
    <kbd>![AMA_Evaluation_Assessment-modresorts12.png](./images/media/AMA_Evaluation_Assessment-modresorts12.png)</kbd>

    
10.	Switch to the terminal window and execute the following command to see the content of the migration bundle. 

        unzip -t ~/Downloads/modresorts-2_0_0_war.ear_migrationPlan.zip 

    
    <kbd>![AMA_Evaluation_Assessment-modresorts13.png](./images/media/AMA_Evaluation_Assessment-modresorts13.png)</kbd>

    Next to the files mentioned before, the migration bundle contains several other files for Kubernetes deployment, for kustomization as well as placeholder files for the application and the JDBC drivers.


11. Close the browser window containing the AMA UI.


### 6.8 Recap

Congratulations, you have finished the application assessment part.

**Let’s recap what you did so far.** 

- You installed and tested the modresorts application on a traditional WAS instance
- You explored AMA using some application data 
- You ran the AMA Discovery Tool to assess a WebSphere cell
- You assessed the modresorts application
- You generated a migration plan


### 6.9 Troubleshooting

You will need the migration plan in the next section. 

1. If not already done, create the required working directories

        rm -rf ~/Student
        mkdir ~/Student
        mkdir ~/Student/assets
        mkdir ~/Student/backup

2. Clone the repository to get access to the application binaries and more.

        rm -rf ~/Student/temprepo/
        git clone https://github.com/LarsBesselmann/LibertyGettingStarted-2026-AMA-Lab ~/Student/temprepo
        mv ~/Student/temprepo/modresorts-project ~/Student
        rm -rf ~/Student/temprepo/


3. Install the required WAS library

        cd ~/Student/modresorts-project/

        mvn install:install-file -Dfile=/home/itzuser/usr/IBM/WebSphere/AppServer/dev/was_public.jar -DpomFile=/home/itzuser/usr/IBM/WebSphere/AppServer/dev/was_public-9.0.0.pom

    Make sure that the build is successful.

    <kbd>![mvn-install_WAS_library](./images/media/mvn-install_WAS_library.png)</kbd>
      
4. Apply the AMA PoC access key:

        sh ~/software/AMA/AMA_apply_PoC_Key.sh 

      

5. Copy the migration plan to the Downloads directory

        cp ~/software/AMA/modresorts/modresorts-2_0_0_war.ear_migrationPlan.zip ~/Downloads/


<br>

## 7. Use the AMA Dev Tools

Now you will use AMA Dev Tools to do the required code changes. AMA Dev Tools will help you to apply automated fixes and see the remaining issues in the source code.

### 7.1 Explore the Visual Studio Code installation and extensions

1. Initialize git

    Open a terminal window and switch to the project directory, then initialize git.

        cd ~/Student/modresorts-project
        git init
        git config --global user.name "John Doe"
        git config --global user.email john.doe@noreply

        git add .
        git commit -a -m "Initial project"

2. Open VS Code

    1. Start VS Code.

            code . &

        Visual Studio Code UI will be opened.

    2. You might see the one or other panel:
    
        1. If you get a pop-up that Authentication is required, enter **IBMDem0s!** in both fields and select **Continue**.
    
            <kbd>![VSCode_Keyring.png](./images/media/VSCode_Keyring.png)</kbd>

        2. If you get a pop-up that Authentication is required, click on **Yes, I trust the authors** to continue.

            <kbd>![VSCode_TrustAuthor.png](./images/media/VSCode_TrustAuthor.png)</kbd>

        3. If you see the panel to sign in for Copilot, close the panel.
        <kbd>![VSCode_Signup.png](./images/media/VSCode_Signup.png)</kbd>


    3. On the Welcome Panel you can open the Walkthrough which allows to change the VS Code settings like theme and other settings. 

        <kbd>![VSCode_Welcome.png](./images/media/VSCode_Welcome.png)</kbd>

        On the panel called **Walkthrough: Setup VS Code**, you can change the theme. The lab document uses as color **Light+**. Feel free to adjust the theme to your choice. 

        <kbd>![VSCode_Walkthrough.png](./images/media/VSCode_Walkthrough.png)</kbd>

    4. Finally, close the panel called **Walkthrough: Getting started with VS Code** and the **Welcome** panel. Also close the panel called **Chat**.

    5. If you see during the lab one of the pop-ups below or any other pop-up asking to install something, close the pop-up without installation by clicking the **X**. 

        <kbd>![VSCode_Popup1.png](./images/media/VSCode_Popup1.png)</kbd>

        <kbd>![VSCode_Popup2.png](./images/media/VSCode_Popup2.png)</kbd>


    6. Look at the bottom left of your VS Code window to find out if VS Code runs in **Restricted Mode**
    
        <kbd>![VSCode_RestrictedMode2.png](./images/media/VSCode_RestrictedMode2.png)</kbd>

        If so, click on the field *Restricted Mode* to open the panel.

        <kbd>![VSCode_RestrictedMode1.png](./images/media/VSCode_RestrictedMode1.png)</kbd>

        Then click on **Trust** to make this workspace trusted.
        <kbd>![VSCode_RestrictedMode3.png](./images/media/VSCode_RestrictedMode3.png)</kbd>

        Finally close the pop-up by clicking on **X**.
        <kbd>![VSCode_RestrictedMode4.png](./images/media/VSCode_RestrictedMode4.png)</kbd>



3. Take a look at the installed extensions

    1. Open the Extensions panel

        <kbd>![VSCode_Extensions1.png](./images/media/VSCode_Extensions1.png)</kbd>

    2. Click on the extension called **IBM Application Modernization Accelerator Developer Tools** (AMA Dev Tools). The AMA Dev Tools help to analyze the application based on source code. 

        <kbd>![VSCode_Extensions2.png](./images/media/VSCode_Extensions2.png)</kbd>

        Look at the details, then close the AMA Dev Tools Extensions panel.
        You might have a newer version displayed.

    3. Click on the extension called **Liberty Tools**. The Liberty tools provide an easy way to develop against Liberty

        <kbd>![VSCode_Extensions3.png](./images/media/VSCode_Extensions3.png)</kbd>

        Look at the details, then close the Liberty Tools Extension panel.
        You might have a newer version displayed.
    
    You will use both tools during the lab.

### 7.2 Modernize to WebSphere Liberty using AMA Dev Tools
In the section we will outline how AMA Dev Tools can help with the modernization to Liberty.

1. Start the modernization wizard

    1. Switch to the **Explorer**, right-click on **src** and select **Modernize Java Applications > Modernize to Liberty**

        <kbd>![AMA_DevTools_ModernizeJavaApps.png](./images/media/AMA_DevTools_ModernizeJavaApps.png)</kbd>

    2. An introduction panel is displayed.
    
        <kbd>![AMA_DevTools_ModernizeJavaApps2](./images/media/AMA_DevTools_ModernizeJavaApps2.png)</kbd>



    2. Click on **Upload migration plan**

        <kbd>![AMA_DevTools_Upload_Migrationplan](./images/media/AMA_DevTools_Upload_Migrationplan.png)</kbd>


    3. Select the migration plan from the **Downloads** directory.

        <kbd>![AMA_DevTools_Upload_Migrationplan2](./images/media/AMA_DevTools_Upload_Migrationplan2.png)</kbd>

        Click on **Open**.

    4. Keep the **server.xml** file selected and click on **Proceed**.

        <kbd>![AMA_DevTools_Upload_Migrationplan3](./images/media/AMA_DevTools_Upload_Migrationplan3.png)</kbd>

    5. AMA Dev Tools display the issues and for which of them automated fixes exist.

        <kbd>![AMA_DevTools_Issues_Overview](./images/media/AMA_DevTools_Issues_Overview.png)</kbd>


        As you can see, there are automated fix available for:
        - **Use the default InitialContext JNDI properties**
        - **Getting the server name on Liberty**
        - **Avoid using the deprecated WSSecurityHelper revokeSSOCookies and getLTPACookieFromSSOToken methods**

        

2. Test the application on Liberty

    As the tool does a static analysis, it cannot detect if the identified issues really need to be fixed or in unused code.
    Therefore, before continuing with the modernization, let's try to run the application as is on Liberty.

    1. Open a VS Code Terminal

        <kbd>![VSCode_Open_Terminal](./images/media/VSCode_Open_Terminal.png)</kbd>

    2. Configure Liberty to use Java 8. This is done via the Liberty configuration file **server.env**.

            cd ~/Student/modresorts-project
            echo "JAVA_HOME=/usr/lib/jvm/ibm-semeru-open-8-jdk" >> src/main/liberty/config/server.env

        <kbd>![modresorts_TestAppOnLiberty0](./images/media/modresorts_TestAppOnLiberty0.png)</kbd>

        The file gets added to the Liberty configuration.

        <kbd>![modresorts_TestAppOnLiberty0a](./images/media/modresorts_TestAppOnLiberty0a.png)</kbd>


    3. Expand the Liberty Dashboard and click on **Reload**.

        <kbd>![modresorts_TestAppOnLiberty1](./images/media/modresorts_TestAppOnLiberty1.png)</kbd>

    4. Right-click on modresorts and select Start to start the application on Liberty

        <kbd>![modresorts_TestAppOnLiberty2](./images/media/modresorts_TestAppOnLiberty2.png)</kbd>

    5. The application gets started 

        <kbd>![modresorts_TestAppOnLiberty2a](./images/media/modresorts_TestAppOnLiberty2a.png)</kbd>

        <kbd>![modresorts_TestAppOnLiberty2b](./images/media/modresorts_TestAppOnLiberty2b.png)</kbd>

    6. Open a browser window and access the application at the URL http://localhost:9080/resorts.

        <kbd>![modresorts_unchanged_Liberty1.png](./images/media/modresorts_unchanged_Liberty1.png)</kbd>

        Click on **Where to** and select **Paris**. 

        You should see some errors in the display of weather data.

        <kbd>![modresorts_unchanged_Liberty2.png](./images/media/modresorts_unchanged_Liberty2.png)</kbd>

        Switch to VSCode and you should see an error related to **Servername**.)

        <kbd>![modresorts_unchanged_Liberty2a.png](./images/media/modresorts_unchanged_Liberty2a.png)</kbd>

        Switch back to the browser and click on **Logout**.

        <kbd>![modresorts_unchanged_Liberty3.png](./images/media/modresorts_unchanged_Liberty3.png)</kbd>

        Switch to VSCode and you should see an error related to **revokeSSOCookies**

        <kbd>![modresorts_unchanged_Liberty3a.png](./images/media/modresorts_unchanged_Liberty3a.png)</kbd>

        This confirms that the application cannot run without any change on Liberty with Java 8.
    
    7. In VS Code, stop the Liberty instance via **Liberty Dashboard**
        (Right-click on modresorts)

        <kbd>![modresorts_TestAppOnLiberty3](./images/media/modresorts_TestAppOnLiberty3.png)</kbd>

        Make sure that the server gets stopped.

        <kbd>![modresorts_TestAppOnLiberty4](./images/media/modresorts_TestAppOnLiberty4.png)</kbd>


2. Continue with the modernization wizard

    1. Take again a look at the modernization wizard. 
    As mentioned before, two of the identified issues are issues that need to be fixed.

        <kbd>![AMA_DevTools_AutomatedFixes1](./images/media/AMA_DevTools_AutomatedFixes1.png)</kbd>

    2. Click on the button **Run automated fixes** to download the recipes and apply the automated fixes. 

        The AMA Dev Tools will download the required recipes and will execute them.

         <kbd>![AMA_DevTools_AutomatedFixes2](./images/media/AMA_DevTools_AutomatedFixes2.png)</kbd>

    3. Wait until the recipes have been applied, then click on **Rebuild and refresh**.

         <kbd>![AMA_DevTools_AutomatedFixes3](./images/media/AMA_DevTools_AutomatedFixes3.png)</kbd>

        The application source code will be rebuilt and scanned to identify which issues have already been resolved and if new issues arised.

    4. Review the updated list of issues.
    
        <kbd>![AMA_DevTools_AutomatedFixes4](./images/media/AMA_DevTools_AutomatedFixes4.png)</kbd>

        As you can see, the recipes did not only fix the issues that were listed under **Automated fixes** but also one of the issues listed under **Self-directed fixes**.

    5. Click on **Self-directed fixes** and expand the issue. 

        <kbd>![AMA_DevTools_AutomatedFixes5](./images/media/AMA_DevTools_AutomatedFixes5.png)</kbd>

        As you can see, there is only one issue left.
        **The WebSphere Servlet API was superseded by a newer implementation**. 

        Click on the issue related to **WebSphere Servlet API** and you can get more details about the issue including document links and a link to the source code. By default, you would now have to read through the documentation to find out how to fix it. But there is an indication that there seems to be a fix in the IBM AI solution called watsonx Code Assistant (and therefore also in the successor IBM Bob.)

        You can also click on the link to see the source.
        <kbd>![AMA_DevTools_AutomatedFixes6](./images/media/AMA_DevTools_AutomatedFixes6.png)</kbd>

        The solution would be to replace the current encoding mechanism with another one that is supported by Liberty. 
        You could for example use Apache Commons for this, but this is out of scope for the lab. We leave the issue as is for now.

3. Now that we resolved most of the issues, let's test again if the application now works smoother or still has the errors seen before.

    1. Navigate to the Liberty Dashboard.
    2. Right-click on **modresorts** and select **Start** to start the application on Liberty

        <kbd>![modresorts_TestAppOnLiberty2](./images/media/modresorts_TestAppOnLiberty2.png)</kbd>

    3. Wait until the server has been started. 
        
        <kbd>![AMA_Liberty_Started.png](./images/media/AMA_Liberty_Started.png)</kbd>

    4. Open a browser window and access the application at the URL http://localhost:9080/resorts.

        <kbd>![modresorts_modernized_Liberty1.png](./images/media/modresorts_modernized_Liberty1.png)</kbd>

        Click on **Where to** and select **Paris**. 

        You should no longer see any errors in the display of weather data.

        <kbd>![modresorts_modernized_Liberty2.png](./images/media/modresorts_modernized_Liberty2.png)</kbd>

        Click on **Logout** and you should no longer see an error.

        <kbd>![modresorts_modernized_Liberty3.png](./images/media/modresorts_modernized_Liberty3.png)</kbd>

        This confirms that the application has been modified to run on Liberty with Java 8. The remaining issue might be required to be resolved but this is out of scope of the lab.
    
    7. In VS Code, stop the Liberty instance via **Liberty Dashboard**
        (Right-click on modresorts)

        <kbd>![modresorts_TestAppOnLiberty3](./images/media/modresorts_TestAppOnLiberty3.png)</kbd>


### 7.3 Perform a Java upgrade using AMA Dev Tools
The AMA Dev Tools have another capability next to "Modernize to Liberty" and this is "Java Upgrade".

1. Start the modernization wizard

    1. Switch to the **Explorer**, right-click on **src** and select **Modernize Java Applications > Upgrade Java E and Java EE/Jakarta EE**

        <kbd>![AMA_DevTools_JavaUpgrade1.png](./images/media/AMA_DevTools_JavaUpgrade1.png)</kbd>

    2. An introduction panel is displayed.

        As you can see in the screenshot, you could update to a higher Java SE or/and Java EE level if you would have a full access key.
    
        <kbd>![AMA_DevTools_JavaUpgrade2](./images/media/AMA_DevTools_JavaUpgrade2.png)</kbd>.

        Alternatively you could go back to AMA, change the target to the desired Java SE and EE level and generate a new migration plan.
      
You should now have a good understanding what the AMA Dev Tools provide. So, close the modernization panel.  

### 7.4 Recap

Congratulations, you have finished the application modernization part.

**Let’s recap what you did so far.** 

- You tested the unchanged application on Liberty to validate that the identified issues cause runtime errors and need to be fixed.
- You used the AMA Dev Tools to apply automated fixes
- You used the AMA Dev Tools to see how to handle self-directed fixes
- You tested successfully the modernized application on Liberty
- You got an idea how to use the AMA Dev Tools to upgrade the Java SE or Java EE level of the application.



## 8 Lab Cleanup

1. Once you are done, make sure that Liberty and Visual Studio Code is not running.

2. Delete the Student folder via command:

        rm -rf ~/Student


3. Close the browser and all terminal windows



## Summary

In this lab, you learned how to assess a WebSphere application using IBM Application Modernization Accelerator. In addition, you learned how to use the AMA Dev Tools to apply automated fixes and resolve other issues.

**Congratulations!**

**You have successfully completed the lab "Application Modernization Accelerator"**

# Troubleshooting
<details>
<summary>Details around troubleshooting</summary>

