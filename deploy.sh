#oc new-project workshops
oc new-app osevg/workshopper:latest --name=workshop-containers \
	-e WORKSHOPS_URLS=https://raw.githubusercontent.com/gonzaloacosta/workshop-containers/master/_worshop.yml  \
	-e JAVA_APP=false
oc expose svc/workshop-containers
