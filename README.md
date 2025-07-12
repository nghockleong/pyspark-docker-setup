# PySpark docker setup

This repository provides a Docker container setup such that there is no need to download PySpark dependencies locally. It allows you to work in a Jupyter notebook environment. (Works for Windows but not sure about other OS)

To use this, install the following:
1) Docker Desktop
- Easiest way to set up Docker
2) Visual Studio Code (VSCode)

Instructions to use:
1) Enter the `docker/` folder and run `./build_image.sh`.
This builds the
- Spark cluster image (for master and worker) with the name `SPARK_CLUSTER_IMAGE_NAME` by drawing reference to the .env file.
- Spark jupyter image with the name `SPARK_JUPYTER_IMAGE_NAME` by drawing reference to the .env file.
Ensure that Docker Desktop is running in the background because the bash script runs a `docker` command.

2) Go back to the root folder of this repository within VSCode. Click Ctrl+Shift+P and search for "Dev Containers: Reopen in Container"
- Selecting the option reads the configuration inside .devcontainer.json which runs the `docker-compose.yaml` and brings you into your Spark Jupyter container. Since it runs `docker` commands, Docker Desktop needs to be running in the background as well.

You can now start writing code within the `.ipynb` files. Do note that there is a bind mount made between the host and container which allows changes to be registered on host and container.

Ports accessible locally on host:
- 7077: For spark-submit to master from host
- 9090: Spark master UI
- 18080: Spark history
- 56789: Spark Driver
- 8889: Jupyter Notebook (non-VSCode version) which is within the Spark Jupyter container
- 4040: Spark Driver UI

Note:
Multi-container setup is not necessary. There is no value add to setting up multiple containers, separating the master, workers and drivers because they all use the same hardware from the same host.
This is because the Sparksession object could still be initialised as such:

```
from pyspark.sql import SparkSession
spark = SparkSession.builder.master('local[4]').getOrCreate()
```

It was done for fun to play around with the Spark standalone scripts as well as Docker network configuration. There is no practical benefit or rather overhead with the use of multi-container set up.
Ideal case should have been a network of VMs with isolated hardware resources.

## Sample test
```
from pyspark.sql import SparkSession
from dotenv import load_dotenv
import os

SPARK_MASTER_HOST = os.getenv("SPARK_MASTER_HOST")
SPARK_MASTER_PORT = os.getenv("SPARK_MASTER_PORT")
spark = SparkSession.builder.master(f"spark://{SPARK_MASTER_HOST}:{SPARK_MASTER_PORT}").getOrCreate()
df = spark.createDataFrame([{'name': 'Alice', 'age': 25}])
df.show()
```
SPARK_MASTER_HOST and SPARK_MASTER_PORT would have been defined inside `docker/.env`.

If you ever need to stop and remove the containers, enter the `docker/` folder and run the following command:
```
docker compose down
```
Have fun folks!
