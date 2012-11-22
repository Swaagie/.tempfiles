PREFIX ?= /usr/local
HOME ?= ~/
PS1 ?= "PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\] '"

target: symlink

# Dependencies:
# These pieces of software are required for the full installation of all the
# required code.
#
# @TODO automatically install mac ports
# @TODO automatically install and configure VIM with clipboard support
dependencies:
# Some general dependencies
ifeq ($(shell which vim), )
@sudo apt-get install vim 
endif

ifeq ($(shell which g++), )
@sudo apt-get install g++ 
endif

# rake is required for the .dotjs chrome extension, and might be commonly used
# by other software as it's an alternate to Make
ifeq ($(shell which rake), )
	@echo "  - Installing rake"
	@sudo apt-get install rake
endif

# Exuberant Ctags is required for the vim tag list plugin, it's an updated
# version of ctags that is shipped on unix by default.
ifeq ($(shell which ctags), )
	@echo "  - Installing Exuberant ctags"
	@sudo apt-get install ctags
endif

# Make sure we have curl installed
ifeq ($(shell which curl), )
	@echo "  - Installing curl"
	@sudo apt-get install curl
endif

	@echo "  - Adding colourful bash line to .profile"
	@echo $(PS1) >> $(HOME)/.bashrc

# Installation:
# Install all the .sh files and git submodules so our env. will be a bit easier
# to work with, and it will look pretty as well <3.
#
# @TODO install jshint for syntasic (npm install jshint -g)
# @TODO install csslint for syntastic (npm install csshint -g)
install:
	@$(MAKE) dependencies                                                              # install the dependencies
	@git submodule init                                                                # init submodules
	@git submodule update --recursive                                                  # download it's contents
	@sudo cp ./tools/n/bin/n $(PREFIX)/bin                                             # install n for node.js version management
	@sudo n stable                                                                     # install the latest node.js stable
	@curl https://npmjs.org/install.sh | sudo sh                                       # install npm, node package management
	@cd ./git/git-extras && sudo make install                                          # install git-extras
	@cd ./tools/spot && sudo make install                                              # install spot search util
ifeq ($(shell which rake), )
	@cd ./tools/dotjs && sudo rake install                                             # install .js folder extenstion
endif
	@$(MAKE) symlink                                                                   # install all the symlinks

# Symlinking:
# Update the symlinks to all the possible .dot files so they are used from this
# directory and not an other one.
symlink:
	@ln -s -f $(CURDIR)/git/.gitconfig $(HOME)                                         # add the global gitignore
	@ln -s -f $(CURDIR)/vim/.vimrc $(HOME)                                             # add the .vimrc
	@ln -s -f $(CURDIR)/vim/.vim $(HOME)                                               # add the .vim directory
	@ln -s -f $(CURDIR)/.jshintrc $(HOME)                                              # add the .jshintrc
	@ln -s -f $(CURDIR)/.js $(HOME)                                                    # add the .js folder
	@ln -s -f $(CURDIR)/.ssh/config $(HOME)/.ssh/config                                # some ssh defaults 

uninstall:
	@cd ./tools/dotjs && rake uninstall                                                # remove dotjs again
	@cd ./tools/n && make uninstall                                                    # remove n

.PHONY: symlink install uninstall dependencies
