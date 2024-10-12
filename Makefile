SHELL=git-bash.exe

default:
	@echo No Default make command configured
	@echo Please use either
	@echo    - make curseforge
	@echo    - make multimc
	@echo    - make technic
	@echo    - make all
	@echo    - make server
	
curseforge:
	@echo "[Platform Build] Creating CurseForge ZIP"
	packwiz curseforge export --pack-file .minecraft/pack.toml -o build/FairburnPack-curseforge.zip
	7z d build/FairburnPack-curseforge.zip overrides/packwiz-installer-bootstrap.jar overrides/pack.toml  overrides/index.toml overrides/bin/modpack.jar	
	@echo "Done"
	
multimc:
	@echo "[Platform Build] Creating MultiMC ZIP"
	7z d build/FairburnPack-multimc.zip ./* -r
	7z a build/FairburnPack-multimc.zip ./.minecraft -r
	7z a build/FairburnPack-multimc.zip ./instance.cfg
	7z a build/FairburnPack-multimc.zip ./mmc-pack.json

technic: clean
	@echo "[Platform Build] Creating Technic ZIP"
	-cp -r .minecraft .technic
	cd .technic && java -jar packwiz-installer-bootstrap.jar ../.minecraft/pack.toml && cd ..
	-rm -rf .technic/packwiz* .technic/pack.toml .technic/index.toml .technic/mods/*.pw.toml
	7z d build/patriam-technic.zip ./* -r
	7z a build/patriam-technic.zip ./.technic/* -r

server:
	@echo "[Platform Build] Creating Server Files"
	-cd .server && java -jar packwiz-installer-bootstrap.jar -g -s server ../.minecraft/pack.toml

clean:
	-rm -rf build/*
	-rm -rf .technic
	-git gc --aggressive --prune

clean-server:
	-rm -rf .server/config
	-rm -rf .server/crash-reports
	-rm -rf .server/logs
	-rm -rf .server/mods
	-rm -rf .server/world
	echo "eula=true" > .server/eula.txt

clean-libs: clean
	-rm -rf .server/libraries

all: clean server multimc technic curseforge

update-packwiz:
	go install github.com/packwiz/packwiz@latest
	clear
	@echo "Packwiz has been Updated"
