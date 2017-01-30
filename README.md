# gcdns-genbot
Docker container that uses docker-gen and Google Cloud DNS via gcloud to manage DNS records

### Status
Ready for alpha testing.
Ready for Rancher catalog stack inclusion alpha testing.

### Details
Any container that has VIRTUAL_HOST env set will be added to your Google Cloud DNS managed zone.
You will need to install your valid per host credentials in /var/log/dockprox/gc-credentials.json
You need to set two container ENV vars as shown below. One for the Google CLoud project and another for the DNS zone
to be managed.

### Example Use
     docker build -t unxsio/gcdns-genbot .
     #install gc-credentials.json in /var/local/dockprox on host
     docker run --restart unless-stopped --name gcdns-genbot --env cGCDNSProject=adhoc-dev --env cGCDNSZone=sistemasadhoc-com\
     -v /var/run/docker.sock:/var/run/docker.sock:ro -v /var/local/dockprox:/var/local/dockprox -d unxsio/gcdns-genbot

### Monitoring/Debugging
Use `docker ps|grep gcdns-genbot` to get your container short tag (here we use ccb87c3fbc3c for examples below)

Check ENV, make sure cGCDNS vars are correct:
     docker exec ccb87c3fbc3c env
     
Check credentials, one must be ACTIVE:docker exec ccb87c3fbc3c /google-cloud-sdk/bin/gcloud dns record-sets list --zone=sistemasadhoc-com
     docker exec ccb87c3fbc3c /google-cloud-sdk/bin/gcloud auth list

Check DNS environment, must show cGCDNSZone:
     docker execdocker exec /google-cloud-sdk/bin/gcloud dns managed-zones list

Check your zone records using cGCDNSZOne (here we use sistemasadhoc-com as an example):
     docker exec ccb87c3fbc3c /google-cloud-sdk/bin/gcloud dns record-sets list --zone=sistemasadhoc-com

Check last docker-gen changes (already exist errors are normal):
     docker exec ccb87c3fbc3c cat /tmp/gcdns.sh.log
     
###Known issues
See github Issues
