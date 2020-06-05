$ oc new-app quay.io/osevg/workshopper --name=myworkshop1 \
      -e WORKSHOPS_URLS="https://raw.githubusercontent.com/gonzaloacosta/workshop-containers/master/_workshop1.yml" \
      -e JAVA_APP=false 
$ oc expose svc/myworkshop1
