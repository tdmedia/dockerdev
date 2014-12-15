## TD Media Development Docker Container

# Copy  your private key to the conf folder
cp ~/.ssh/id_dsa ./keys

NOTE: if you have an id_rsa instead, you will need to modify the Dockerfile. Comment out the id_dsa block and uncomment the id_rsa block

# Create the docker dev image
docker build -t tdmedia/dev .

# start the storage container
docker run -v /var/lib/mysql -v /web --name storage centos:centos6 true

This only needs to be run one time. If you get the message that a container with the name storage already exists, then you have already done this step.

# start / run the dev container
docker run -i -t -p 80:80 -p 4022:22 -p 445:445 --volumes-from storage --name dev tdmedia/dev

# use your container
1. boot2docker ip
2. use the hosts control panel to add an entry for host named docker
3. ssh -p 4022 root@docker
4. password is root

If you get an Offending Host Key erorr, take note of the line number and run:
sed -i.bak '298d' ~/.ssh/known_hosts

where 298 is the offending line number. Make sure to include the d after the line number as shown.

## NOTE
NEVER EVER push the tdmedia/dev docker container.

By design, this container contains your private ssh key. This enables the container to be easily used with our servers for git, deploy, etc. You never want your private key to be included in the dockerhub so don't push it there. :~)

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
2. docker rm dev
2. docker rmi tdmedia/dev
3. Pull the latest docker files
4. build the dev container as shown above
5. run the dev container as shown above
