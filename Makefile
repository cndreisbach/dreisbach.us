.PHONY: dev build deploy

dev:
	hugo server -D

build:
	hugo

deploy: build
	firebase deploy
