#oc new-project workshops
oc new-app osevg/workshopper:latest --name=workshop-containers \
	-e CONTENT_URL_PREFIX=https://raw.githubusercontent.com/gonzaloacosta/workshop-containers/master \
	-e WORKSHOPS_URLS=https://raw.githubusercontent.com/gonzaloacosta/workshop-containers/master/_worshop.yml  
oc expose svc/workshop-containers
