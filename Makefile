.PHONY: dev build deploy

dev:
	hugo server -D

build:
	hugo

deploy: build
	rsync --archive --verbose --rsh=ssh public/ homebase@homebase.dreisbach.us:/var/www/static_web/
