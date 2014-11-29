# Copy  your private key to the conf folder
cp ~/.ssh/id_dsa ./keys

NOTE: if you don't have an id_rsa instead, you will need to modify the Dockerfile starting on line 37.

# Make a web directory if it doesn't already exist
mkdir web

# Create the docker image
docker build -t tdmedia/dev .

# start the storage container
docker run -v /var/lib/mysql -v /web --name storage centos:centos6 true

This only needs to be run one time. If you get the message that a container with the name storage already exists, then you have already done this step.

# start the dev container
docker run -i -t -p 80:80 -p 4022:22 -p 445:445 --volumes-from storage --name dev tdmedia/dev

Replace /Users/rt/docker/web:/web with your own directory ie: /Users/mestrada/docker/web:/web

# use your container
1. boot2docker ip
2. use the hosts control panel to add an entry for host named docker
2. ssh -p 4022 user@docker
3. password is user
4. sudo su to become root - do everything else in the shell as root

If you get an Offending Host Key erorr, take note of the line number and run:
sed -i.bak '298d' ~/.ssh/known_hosts

where 298 is the offending line number. Make sure to include the d after the line number as shown.

## NOTE
NEVER EVER push the tdmedia/dev docker container. By design, this container copies your private ssh key which enables the container to be easily used with our servers for git, deploy, etc. You never want your private key to be included in the dockerhub so don't push it there. :~)

# mount your container samba share in osx
1. cmd+k
2. smb://docker/web
3. login as guest

# Stop dev container (done working, want to save memory)
docker stop dev

# Start dev container (after it has been stopped)
docker start dev

# rebuilding the container
1. docker stop dev
2. docker rmi tdmedia/dev
3. build the dev container as shown above
4. run the dev container as shown above
