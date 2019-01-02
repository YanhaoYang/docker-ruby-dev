# docker-ruby-dev

Build a Ruby development environment in Docker container.

Following tools are preinstalled:

* zsh: the shell
* vim: default editor
* silversearcher-ag: faster grep
* curl: to download or test APIs
* traefik: reverse proxy for apps built in the container
* locales: setup UTF-8
* sudo: enable /etc/sudoers
* headless chrome for automatic testing

## Usage

    docker-compose up -d
