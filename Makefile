bin := /usr/local/bin/
lib := /usr/local/lib/

pikacode   = atoum-skeleton sandbox
projects   = Marvirc Dotfiles game-of-life php-tools gg
hoaproject = Ruler Console Bench Math Test
atoum      = atoum
brew       = php56 the_silver_searcher highlight tmux ansible graphviz git hub nmap weechat gource

all: $(projects) $(hoaproject) $(atoum) $(pikacode) $(brew)

brew: /usr/local/bin/brew
/usr/local/bin/brew:
	ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
	brew install caskroom/cask/brew-cask

packer: brew
	brew tap homebrew/binary
	brew install packer

virtualbox: brew /usr/bin/VBoxHeadless
/usr/bin/VBoxHeadless:
	brew cask install virtualbox

$(brew): brew
	brew install $@

rust: /usr/local/bin/rustc
/usr/local/bin/rustc:
	curl -sSf https://static.rust-lang.org/rustup.sh | sh

atom: brew /usr/local/bin/atom
/usr/local/bin/atom:
	brew cask install atom

composer: /usr/local/bin/composer
/usr/local/bin/composer:
	curl -sS https://getcomposer.org/installer | php
	sudo mv composer.phar ${bin}composer

Central:
	git clone git@github.com:hoaproject/$@.git $@
	sudo ln -s ${CURDIR}/$@/Hoa/Cli/Bin/hoa ${bin}hoa
	sudo ln -s ${CURDIR}/$@/Hoa ${lib}Hoa
	git clone https://github.com/hoaproject/Contributions-Atoum-PraspelExtension.git atoum-praspel
	sudo ln -s ${CURDIR}/atoum-praspel ${lib}atoum-praspel
	sudo echo 'declare -x HOA_ATOUM_PRASPEL_EXTENSION=/usr/local/lib/atoum-praspel/' >> ~/.zshrc

atoum: /usr/local/bin/atoum
/usr/local/bin/atoum:
	git clone git@github.com:atoum/$@.git $@
	ln -s ${CURDIR}/$@/bin/atoum ${bin}atoum

keycastr: brew /opt/homebrew-cask/Caskroom/keycastr/0.8.2-bezel/KeyCastr.app
/opt/homebrew-cask/Caskroom/keycastr/0.8.2-bezel/KeyCastr.app:
	brew cask install keycastr

clean-atoum:
	rm -rf atoum
	rm -rf ${bin}atoum

clean-central:
	sudo rm -rf ${lib}Hoa ${bin}hoa
	rm -rf ${CURDIR}/Central
	rm -rf ${CURDIR}/atoum-praspel
	sudo rm -rf ${lib}atoum-praspel

clean-pikacode:
	for prefix in $(pikacode); do \
		echo $$prefix; \
		cd ${CURDIR}/$$prefix && if [ -f ${CURDIR}/$$prefix/Makefile ]; then make clean; fi; \
		rm -rf ${CURDIR}/$$prefix; \
	done

clean-hoaproject:
	for prefix in $(hoaproject); do \
		echo $$prefix; \
		cd ${CURDIR}/$$prefix && if [ -f ${CURDIR}/$$prefix/Makefile ]; then make clean; fi; \
		rm -rf ${CURDIR}/$$prefix; \
	done

clean-projects:
	for prefix in $(projects); do \
		echo $$prefix; \
		cd ${CURDIR}/$$prefix && if [ -f ${CURDIR}/$$prefix/Makefile ]; then make clean; fi; \
		rm -rf ${CURDIR}/$$prefix; \
	done

clean: clean-projects clean-hoaproject clean-atoum clean-central clean-pikacode
	sudo rm -rf ${bin}composer
	rm -rf ~/.composer
