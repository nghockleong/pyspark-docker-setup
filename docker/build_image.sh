source .env
docker build -f Dockerfile.spark-cluster -t ${SPARK_CLUSTER_IMAGE_NAME} .
docker build -f Dockerfile.spark-jupyter -t ${SPARK_JUPYTER_IMAGE_NAME} .