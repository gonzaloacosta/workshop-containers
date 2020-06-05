#oc new-project workshops
oc new-app osevg/workshopper:latest --name=workshop-containers \
	    -e WORKSHOPS_URLS=https://raw.githubusercontent.com/gonzaloacosta/workshop-containers/master/_workshop.yml
oc expose svc/workshop-containers
