.PHONY: all

all: dot launchagents

dot:
	cp .* ~/

launchagents:
	cp LaunchAgents/* /Library/LaunchAgents/

clean:
		@echo "Cleaning up..."
		git clean -fdx
