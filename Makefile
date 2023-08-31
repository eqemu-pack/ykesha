# build zip files
build:
	@echo "build: pulling latest heads"
	mkdir -p bin
	-rm -rf bin/*
	make pull-maps
	zip -9pr maps.zip base nav water LICENSE
	mv maps.zip bin/maps.zip
	make pull-quests
	zip -9pr quests.zip quests
	mv quests.zip bin/quests.zip

# pull down maps
pull-maps:
	-git remote add maps https://github.com/Akkadius/eqemu-maps.git
	git fetch maps 
	git show maps/master --format=%h -s > bin/maps_version.txt
	make grab-maps
	git remote remove maps

# pull down quests
pull-quests:
	-rm -rf quests
	mkdir -p quests
	-git remote add quests https://github.com/ProjectEQ/projecteqquests
	git fetch quests
	git show quests/master --format=%h -s > bin/quests_version.txt
	make grab-quests
	make checkout-quests-plugins
	make checkout-quests-lua_modules
	git remote remove quests

grab-%:
	@for f in $(shell ls zones); do make checkout-$*-$${f%.*}; done

checkout-maps-%:
	-git checkout maps/master base/$*.map
	-git checkout maps/master nav/$*.nav
	-git checkout maps/master water/$*.wtr

checkout-quests-%:
	-git checkout quests/master $*
	mv $* quests/$*