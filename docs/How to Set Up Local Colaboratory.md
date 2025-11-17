# Reference: https://research.google.com/colaboratory/local-runtimes.html

Colaboratory

# **Local runtimes**

Colab lets you connect to a local runtime. This allows you to execute code on your local hardware.

## **Security considerations**

Make sure you trust the authors of any notebook before executing it. With a local connection, the code you execute can read, write, and delete files on your computer.

Connecting to a runtime on your local machine can provide many benefits. With these benefits come serious potential risks. By connecting to a local runtime, you are allowing the Colab frontend to execute code in the notebook using the local resources on your machine. This means that the notebook could:

* Invoke arbitrary commands (e.g. "rm \-rf /")  
* Access the local file system  
* Run malicious content on your machine

Before attempting to connect to a local runtime, make sure you trust the authors of the notebook and ensure you understand what code is being executed. For more information on the Jupyter notebook server's security model, consult [Jupyter's documentation](http://jupyter-notebook.readthedocs.io/en/stable/security.html).

## **Setup instructions**

### **Step 1: Start a runtime**

You can either run Jupyter directly or use Colab's Docker image. The Docker image includes packages found in our hosted runtime environments ([https://colab.research.google.com](https://colab.research.google.com/)) and enables some UI features such as debugging and the resource utilization monitor. Packages (files in general) installed on your local machine are however not available by default. The Docker image is provided for linux/amd64 platforms.

#### ***Option 1\. Colab Docker runtime image***

*Install [Docker](https://docs.docker.com/get-docker/) on your local machine. Note that* europe-docker.pkg.dev *and* asia-docker.pkg.dev *are alternative mirrors to* us-docker.pkg.dev *below. Downloads will be faster for users in those continents. The images are identical. Start a runtime:*

       docker run \-p 127.0.0.1:9000:8080 us-docker.pkg.dev/colab-images/public/runtime

     

*For GPU support, with [NVIDIA drivers](https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html) and the [NVIDIA container toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) installed, use:*

       docker run \--gpus=all \-p 127.0.0.1:9000:8080 us-docker.pkg.dev/colab-images/public/runtime

     

*The image has been tested with NVIDIA T4, L4, and A100 GPUs.*

*Once the container has started, it will print a message with the initial backend URL used for authentication, of the form 'http://127.0.0.1:9000/?token=...'. Make a copy of this URL as you'll need to provide this for step 2 below.*

#### ***Option 2\. Jupyter runtime***

*Install [Jupyter](http://jupyter.org/install) on your local machine. New notebook servers are started normally, though you will need to set a flag to explicitly trust WebSocket connections from the Colab frontend.*

 jupyter notebook \\  
    \--NotebookApp.allow\_origin='https://colab.research.google.com' \\  
    \--port=8888 \\  
    \--NotebookApp.port\_retries=0 \\  
    \--NotebookApp.allow\_credentials=True

   

*Once the server has started, it will print a message with the initial backend URL used for authentication. Make a copy of this URL as you'll need to provide this for step 2 below.*

### **Step 2: Connect to the local runtime**

In Colab, click the "Connect" button and select "Connect to local runtime...". Enter the URL from the previous step in the dialog that appears and click the "Connect" button. After this, you should now be connected to your local runtime.

## **Sharing**

If you share your notebook with others, the runtime on your local machine will not be shared. When others open the shared notebook, they will be connected to a standard Colab hosted runtime by default.

By default, all code cell outputs are stored in Google Drive. If your local connection will access sensitive data and you would like to omit code cell outputs, select **Edit \> Notebook settings \> Omit code cell output when saving this notebook**.

## **Connecting to a runtime on another machine**

If the runtime you'd like to connect to is running on another machine (e.g. Google Compute Engine instance), you can set up SSH local port forwarding to allow Colab to connect to it.

First, set up your runtime using the instructions above.

Second, establish an SSH connection from your local machine to the remote instance (e.g. Google Compute Engine instance) and specify the '-L' flag. For example, to forward port 8888 on your local machine to port 8888 on your Google Compute Engine instance, run the following:

gcloud compute ssh \--zone YOUR\_ZONE YOUR\_INSTANCE\_NAME \-- \-L 8888:localhost:8888

   

Finally, make the connection within Colab by connecting to the forwarded port (follow the same instructions under Step 2: Connect to the local runtime).

