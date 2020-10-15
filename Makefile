.PHONY: all

all: dot launchagents

dot:
	cp .* ~/

launchagents:
	cp LaunchDaemons/* /Library/LaunchDaemons

clean:
		@echo "Cleaning up..."
		git clean -fdx
