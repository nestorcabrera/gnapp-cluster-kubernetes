gcloud container clusters create gnapp \
	--zone us-central1-a \
	--num-nodes 3 \
	--machine-type=n1-standard-2
&&

gcloud container clusters get-credentials gnapp --zone us-central1-a