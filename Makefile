# Makefile for autonomous robot based on Turtlebot3
#
# Usage:
#   make <target> <arg-name>=<arg-value>

USE_GPU ?= false        # Use GPU devices (set to true if you have an NVIDIA GPU)

# Docker variables
IMAGE_NAME = turtlebot3
CORE_DOCKERFILE = ${PWD}/docker/dockerfile_nvidia_ros
BASE_DOCKERFILE = ${PWD}/docker/dockerfile_tb3_base
OVERLAY_DOCKERFILE = ${PWD}/docker/dockerfile_tb3_overlay

# Set Docker volumes and environment variables
DOCKER_VOLUMES = \
	--volume="${PWD}/prog_nav":"/overlay_ws/src/prog_nav":rw \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw"
DOCKER_ENV_VARS = \
	--env="NVIDIA_DRIVER_CAPABILITIES=all" \
	--env="DISPLAY" \
	--env="QT_X11_NO_MITSHM=1"
ifeq ("${USE_GPU}", "true")
DOCKER_GPU_ARGS = "--gpus all"
endif
DOCKER_ARGS = ${DOCKER_VOLUMES} ${DOCKER_ENV_VARS} ${DOCKER_GPU_VARS}


###########
#  SETUP  #
###########
# Build the core image
.PHONY: build-core
build-core:
	@docker build -f ${CORE_DOCKERFILE} -t nvidia_ros .

# Build the base image (depends on core image build)
.PHONY: build-base
build-base: build-core
	@docker build -f ${BASE_DOCKERFILE} -t ${IMAGE_NAME}_base .

# Build the overlay image (depends on base image build)
.PHONY: build
build: build-base
	@docker build -f ${OVERLAY_DOCKERFILE} -t ${IMAGE_NAME}_overlay .

###########
#  TASKS  #
###########
# Start a terminal inside the Docker container
.PHONY: term
term:
	@docker run -it --net=host \
		${DOCKER_ARGS} ${IMAGE_NAME}_overlay \
		bash

# Start basic simulation included with TurtleBot3 packages
.PHONY: sim
sim:
	@docker run -it --net=host \
		${DOCKER_ARGS} ${IMAGE_NAME}_overlay \
		roslaunch turtlebot3_gazebo turtlebot3_world.launch

# Start Terminal for teleoperating the TurtleBot3
.PHONY: teleop
teleop:
	@docker run -it --net=host \
		${DOCKER_ARGS} ${IMAGE_NAME}_overlay \
		roslaunch turtlebot3_teleop turtlebot3_teleop_key.launch

# Start our own simulation world
.PHONY: world
world:
	@docker run -it --net=host \
		${DOCKER_ARGS} ${IMAGE_NAME}_overlay \
		roslaunch prog_nav turtlebot3_house.launch
		

# Start our own simulation model behavior
.PHONY: model
model:
	@docker run -it --net=host \
		${DOCKER_ARGS} ${IMAGE_NAME}_overlay \
		roslaunch prog_nav turtlebot3_prog_nav.launch
# Goal for autonomous robot movement
.PHONY: goal
goal:
	@docker run -it --net=host \
		${DOCKER_ARGS} ${IMAGE_NAME}_overlay \
		rosrun prog_nav goal_pose.py
