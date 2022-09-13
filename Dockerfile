FROM ubuntu:22.04

# Update distribution
RUN apt update
RUN apt full-upgrade -y

# Install usefull tools
RUN apt install -y make

# Install and configure Python
ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=UTF-8
RUN apt install -y python3.10
RUN apt install -y python3-pip
RUN apt install -y python3.10-venv

# Create default user
ARG USER_NAME=docker_user
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd ${USER_NAME} --non-unique --gid ${USER_GID}
RUN useradd ${USER_NAME} --non-unique --uid ${USER_UID} --gid ${USER_GID} --create-home

# Create required directories
RUN mkdir -p /code
RUN chown -R ${USER_UID}:${USER_GID} /code

# Change working directory
WORKDIR /code

# Change user
USER ${USER_NAME}
