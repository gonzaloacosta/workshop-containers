#oc new-project workshops
oc new-app osevg/workshopper:latest --name=workshop-containers \
	    -e WORKSHOPS_URLS=https://raw.githubusercontent.com/gonzaloacosta/workshop-containers/master/_modules.yml
oc expose svc/workshop-containers
