bin := /usr/local/bin/
lib := /usr/local/lib/

pikacode   = atoum-skeleton
projects   = Marvirc Dotfiles game-of-life php-tools
hoaproject = Ruler Console Bench
atoum      = atoum

all: $(projects) $(hoaproject) $(atoum) $(pikacode)

composer:
	curl -sS https://getcomposer.org/installer | php
	mv composer.phar composer
	sudo ln -s ${CURDIR}/$@ ${bin}$@

Central:
	git clone git@github.com:hoaproject/$@.git $@
	sudo ln -s ${CURDIR}/$@/Hoa/Core/Bin/hoa ${bin}/hoa
	sudo ln -s ${CURDIR}/$@/Hoa ${lib}/Hoa

$(pikacode):
	git clone git@pikacode.com:ashgenesis/$@.git $@
	cd $@ && if [ -f ${CURDIR}/$@/Makefile ]; then make all; fi;

$(projects): composer
	git clone git@github.com:vonglasow/$@.git $@
	cd $@ && if [ -f ${CURDIR}/$@/Makefile ]; then make all; fi;

$(hoaproject): composer Central
	git clone git@github.com:hoaproject/$@.git $@
	cd $@ && if [ -f ${CURDIR}/$@/composer.json ]; then composer install; fi;

$(atoum):
	git clone git@github.com:atoum/$@.git $@

clean-atoum:
	rm -rf atoum

clean-central:
	sudo rm -rf ${lib}/Hoa ${bin}/hoa
	rm -rf ${CURDIR}/Central

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
	rm -rf composer
	sudo rm -rf ${bin}composer
	rm -rf ~/.composer
