PREFIX ?= /usr/local
HOME ?= ~/

target: symlink

# Dependencies:
# These pieces of software are required for the full installation of all the
# required code.

dependencies:

ifeq ($(shell which gvim), )
	@sudo apt-get install vim-gnome
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

# Make sure extra git functionality is installed
ifeq ($(shell which git-extras), )
	@echo "  - Installing git-extras"
	@sudo apt-get install git-extras
endif

# Install notify-send package
ifeq ($(shell which notify-osd), )
	@echo "  - Installing notify-send"
	@sudo apt-get install notify-osd
endif

# Install shutter
ifeq ($(shell which shutter), )
	@echo "  - Installing shutter"
	@sudo apt-get install shutter
endif

# Install trimage
ifeq ($(shell which trimage), )
	@echo "  - Installing trimage"
	@sudo apt-get install trimage
endif

# Install phantomjs
ifeq ($(shell which phantomjs), )
	@echo "  - Installing phantomjs"
	@sudo apt-get install phantomjs
endif

# Install gimp
ifeq ($(shell which gimp), )
	@echo "  - Installing gimp"
	@sudo apt-get install gimp
endif

# Installation:
# Install all the .sh files and git submodules so our env. will be a bit easier
# to work with, and it will look pretty as well <3.
#
install:
	@$(MAKE) dependencies                                                              # install the dependencies
	@git submodule init                                                                # init submodules
	@git submodule update --recursive                                                  # download it's contents
	@sudo cp ./tools/n/bin/n $(PREFIX)/bin                                             # install n for node.js version management
	@sudo n stable                                                                     # install the latest node.js stable
	@sudo npm install dotjs-zen -g
	@sudo npm install jshint -g
	@sudo npm install jslint -g
	@sudo npm install csslint -g
	@sudo npm install stylus -g
	@sudo rm -rf $(HOME)/.npm $(HOME)/tmp
	@mkdir -p ~/projects
	@curl -skL https://github.com/sickill/git-dude/raw/master/git-dude > temp && sudo mv temp /usr/local/bin/git-dude
	@sudo chmod +x /usr/local/bin/git-dude
	@gconftool-2 --load gnome-terminal-conf.xml                                        # Install default gnome-terminal profile.
	@$(MAKE) symlink                                                                   # install all the symlinks

# Symlinking:
# Update the symlinks to all the possible .dot files so they are used from this
# directory and not an other one.
symlink:
	@ln -s -f $(CURDIR)/git/.gitconfig $(HOME)                                         # add the global gitignore
	@ln -s -f $(CURDIR)/vim/.vimrc $(HOME)                                             # add the .vimrc
	@ln -s -f $(CURDIR)/vim/.vim $(HOME)                                               # add the .vim directory
	@ln -s -f $(CURDIR)/.jshintrc $(HOME)                                              # add the .jshintrc
	@ln -s -f $(CURDIR)/.bash_aliases $(HOME)                                          # add the .bash_aliases
	@ln -s -f $(HOME)/dotfiles/.js $(HOME)                                             # add the .js folder
	@ln -s -f $(CURDIR)/.ssh/config $(HOME)/.ssh/config                                # some ssh defaults
	@ln -s -f $(CURDIR)/gd.desktop $(HOME)/.config/autostart/                          # start git-dude at startup
	@ln -s -f $(CURDIR)/djsd.desktop $(HOME)/.config/autostart/                        # start dotjs at startup
  @ln -s -f $(CURDIR)/sublime-text-3/ $(HOME)/.config																 # link sublime3 config
  @sudo ln -s -f $(HOME)/projects/ /p                                                # create quick link to projects

uninstall:
	@cd ./tools/dotjs && rake uninstall                                                # remove dotjs again
	@cd ./tools/n && make uninstall                                                    # remove n

.PHONY: symlink install uninstall dependencies
