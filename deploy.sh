oc new-app quay.io/osevg/workshopper --name=workshop \
      -e WORKSHOPS_URLS="https://raw.githubusercontent.com/gonzaloacosta/workshop-containers/master/_workshop.yml" \
      -e JAVA_APP=false 
oc expose svc/workshop
