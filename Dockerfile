#
# Dockerfile - docker build script for a standard GlueX sim-recon 
#              container image based on centos 7.
#
# author: richard.t.jones at uconn.edu
# version: june 7, 2017
#
# usage: [as root] $ docker build Dockerfile .
#

FROM centos:6

# install a few utility rpms
RUN yum -y install bind-utils util-linux which wget tar procps less file dump gcc gcc-c++ gdb strace openssh-server

# install the hdpm package builder
ENV GLUEX_TOP /usr/local
ADD https://halldweb.jlab.org/dist/hdpm/hdpm-0.7.0.linux.tar.gz /
RUN tar xf hdpm-0.7.0.linux.tar.gz
RUN rm hdpm-0.7.0.linux.tar.gz
RUN mv hdpm-0.7.0 hdpm

# discover and install sim-recon dependencies
RUN /hdpm/bin/hdpm show -p | sh

# create mount point for sim-recon, simlinks in /usr/local
ADD cilogon-osg.pem /
RUN wget --ca-certificate=cilogon-osg.pem https://zeus.phys.uconn.edu/halld/gridwork/local.tar.gz
RUN mv /usr/sbin/sshd /usr/sbin/sshd_orig
RUN tar xf local6.tar.gz -C /
RUN rm cilogon-osg.pem
RUN rm local.tar.gz
RUN rm -rf /hdpm

# make the cvmfs filesystem visible inside the container
VOLUME /cvmfs/oasis.opensciencegrid.org

# set the default build for sim_recon
RUN ln -s /cvmfs/oasis.opensciencegrid.org/gluex/builds/6.7.2017 /usr/local/.hdpm
