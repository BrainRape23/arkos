#!/bin/bash
clear

UPDATE_DATE="08112023"
LOG_FILE="/home/ark/update$UPDATE_DATE.log"
UPDATE_DONE="/home/ark/.config/.update$UPDATE_DATE"

if [ -f "$UPDATE_DONE" ]; then
	msgbox "No more updates available.  Check back later."
	rm -- "$0"
	exit 187
fi

if [ -f "$LOG_FILE" ]; then
	sudo rm "$LOG_FILE"
fi

LOCATION="http://gitcdn.link/cdn/christianhaitian/arkos/main"
ISITCHINA="$(curl -s --connect-timeout 30 -m 60 http://demo.ip-api.com/json | grep -Po '"country":.*?[^\\]"')"

if [ "$ISITCHINA" = "\"country\":\"China\"" ]; then
  printf "\n\nSwitching to China server for updates.\n\n" | tee -a "$LOG_FILE"
  LOCATION="https://raw.sevencdn.com/christianhaitian/arkos/main"
fi

sudo msgbox "ONCE YOU PROCEED WITH THIS UPDATE SCRIPT, DO NOT STOP THIS SCRIPT UNTIL IT IS COMPLETED OR THIS DISTRIBUTION MAY BE LEFT IN A STATE OF UNUSABILITY.  Make sure you've created a backup of this sd card as a precaution in case something goes very wrong with this process.  You've been warned!  Type OK in the next screen to proceed."
my_var=`osk "Enter OK here to proceed." | tail -n 1`

echo "$my_var" | tee -a "$LOG_FILE"

if [ "$my_var" != "OK" ] && [ "$my_var" != "ok" ]; then
  sudo msgbox "You didn't type OK.  This script will exit now and no changes have been made from this process."
  printf "You didn't type OK.  This script will exit now and no changes have been made from this process." | tee -a "$LOG_FILE"
  exit 187
fi

c_brightness="$(cat /sys/devices/platform/backlight/backlight/backlight/brightness)"
sudo chmod 666 /dev/tty1
echo 255 > /sys/devices/platform/backlight/backlight/backlight/brightness
touch $LOG_FILE
tail -f $LOG_FILE >> /dev/tty1 &

if [ ! -f "/home/ark/.config/.update04122022" ]; then

	printf "\nAdd Dreamcast widescreen mode for retrorun and retrorun32\nFix gzdoom crashing\nFix China repo setting for future ArkOS updates\nRemove China repo settings for retroarch core updates\nFix osk screen size\n" | tee -a "$LOG_FILE"
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/04122022/arkosupdate04122022.zip -O /home/ark/arkosupdate04122022.zip -a "$LOG_FILE" || rm -f /home/ark/arkosupdate04122022.zip | tee -a "$LOG_FILE"
	if [ -f "/home/ark/arkosupdate04122022.zip" ]; then
		cp -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update04122022.bak | tee -a "$LOG_FILE"
		sudo unzip -X -o /home/ark/arkosupdate04122022.zip -d / | tee -a "$LOG_FILE"
		sudo chown -Rv ark:ark /opt/ | tee -a "$LOG_FILE"
		sudo chown -Rv ark:ark /home/ark/.config/gzdoom/ | tee -a "$LOG_FILE"
		sudo chown -Rv ark:ark /etc/emulationstation/ | tee -a "$LOG_FILE"
		sudo rm -v /home/ark/arkosupdate04122022.zip | tee -a "$LOG_FILE"
	else 
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/devices/platform/backlight/backlight/backlight/brightness
		exit 1
	fi

	printf "\nFix retroarch core repo if in china\n" | tee -a "$LOG_FILE"
	repo=$(grep "139.196.213.206" ~/.config/retroarch/retroarch.cfg | tr -d '\0')
	if [ ! -z "$repo" ]; then
	  sed -i "/core_updater_buildbot_cores_url \=/c\core_updater_buildbot_cores_url \= \"https:\/\/raw.githubusercontent.com\/christianhaitian\/retroarch-cores\/master\/aarch64\/\"" ~/.config/retroarch/retroarch.cfg
	  sed -i "/core_updater_buildbot_cores_url \=/c\core_updater_buildbot_cores_url \= \"https:\/\/raw.githubusercontent.com\/christianhaitian\/retroarch-cores\/master\/arm7hf\/\"" ~/.config/retroarch32/retroarch.cfg
	  sed -i "/core_updater_buildbot_cores_url \=/c\core_updater_buildbot_cores_url \= \"https:\/\/raw.githubusercontent.com\/christianhaitian\/retroarch-cores\/master\/aarch64\/\"" ~/.config/retroarch/retroarch.cfg.bak
	  sed -i "/core_updater_buildbot_cores_url \=/c\core_updater_buildbot_cores_url \= \"https:\/\/raw.githubusercontent.com\/christianhaitian\/retroarch-cores\/master\/arm7hf\/\"" ~/.config/retroarch32/retroarch.cfg.bak
	  printf "\nRetroarch core repos have been changed to github\n" | tee -a "$LOG_FILE"
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update04122022"
fi

if [ ! -f "/home/ark/.config/.update04232022" ]; then

	printf "\nUpdate Retroarch and Retroarch32 to 1.10.3\nAdd mednafen emulator\nAdd A5200 libretro core as additional core for Atari 5200\nAdd Enable Developer Mode script\nUpdate yabasanshiro standalone\nUpdate GZDoom\nUpdate PPSSPPSDL\nUpdate File Manager\nUpdate Hypseus-Singe\nAdd Arduboy\nUpdate nes-box for arduboy\nUpdate Amiberry\n" | tee -a "$LOG_FILE"
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/04232022/arkosupdate04232022.zip -O /home/ark/arkosupdate04232022.zip -a "$LOG_FILE" || rm -f /home/ark/arkosupdate04232022.zip | tee -a "$LOG_FILE"
	if [ -f "/home/ark/arkosupdate04232022.zip" ]; then
		cp -v /opt/retroarch/bin/retroarch /opt/retroarch/bin/retroarch.1100.bak | tee -a "$LOG_FILE"
		cp -v /opt/retroarch/bin/retroarch32 /opt/retroarch/bin/retroarch32.1100.bak | tee -a "$LOG_FILE"
		sudo unzip -X -o /home/ark/arkosupdate04232022.zip -d / | tee -a "$LOG_FILE"
		sudo chown -Rv ark:ark /opt/yabasanshiro | tee -a "$LOG_FILE"
		sudo chown -Rv ark:ark /home/ark/.mednafen | tee -a "$LOG_FILE"
		sudo chown -Rv ark:ark /opt/retroarch | tee -a "$LOG_FILE"
		sudo chown -Rv ark:ark /opt/mednafen | tee -a "$LOG_FILE"
		sudo chown -Rv ark:ark /opt/dingux | tee -a "$LOG_FILE"
		sudo chown -Rv ark:ark /opt/hypseus-singe | tee -a "$LOG_FILE"
		sudo chown -Rv ark:ark /opt/amiberry | tee -a "$LOG_FILE"
		cp -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update04232022.bak | tee -a "$LOG_FILE"
		mkdir -v /roms/arduboy | tee -a "$LOG_FILE"
		if test -z "$(cat /etc/emulationstation/es_systems.cfg | grep arduboy)"
		then
		  sed -i -e '/<theme>wolf<\/theme>/{r /home/ark/add_arduboy.txt' -e 'd}' /etc/emulationstation/es_systems.cfg
		fi
		if [ -f "/opt/system/Advanced/Switch to main SD for Roms.sh" ]; then
		  mkdir -v /roms2/arduboy | tee -a "$LOG_FILE"
		  sed -i '/<path>\/roms\//s//<path>\/roms2\//g' /etc/emulationstation/es_systems.cfg
		fi
		if test -z "$(cat /etc/emulationstation/es_systems.cfg | grep 'name="mednafen"')"
		then
		  sed -i '/<core>quicknes<\/core>/c\\t\t \t  <core>quicknes<\/core>\n\t\t \t<\/cores>\n\t\t      <\/emulator>\n\t\t      <emulator name\=\"mednafen\">\n\t\t \t<cores>\n\t\t \t  <core>norecord-aspect<\/core>\n\t\t \t  <core>norecord-full<\/core>\n\t\t \t  <core>record-aspect<\/core>\n\t\t \t  <core>record-full<\/core>' /etc/emulationstation/es_systems.cfg
		  sed -i '/<core>mednafen_pce<\/core>/c\\t\t \t  <core>mednafen_pce<\/core>\n\t\t \t<\/cores>\n\t\t      <\/emulator>\n\t\t      <emulator name\=\"mednafen\">\n\t\t \t<cores>\n\t\t \t  <core>norecord-aspect<\/core>\n\t\t \t  <core>norecord-full<\/core>\n\t\t \t  <core>record-aspect<\/core>\n\t\t \t  <core>record-full<\/core>' /etc/emulationstation/es_systems.cfg
		  sed -i '/<core>mednafen_lynx<\/core>/c\\t\t \t  <core>mednafen_lynx<\/core>\n\t\t \t<\/cores>\n\t\t      <\/emulator>\n\t\t      <emulator name\=\"mednafen\">\n\t\t \t<cores>\n\t\t \t  <core>norecord-aspect<\/core>\n\t\t \t  <core>norecord-full<\/core>\n\t\t \t  <core>record-aspect<\/core>\n\t\t \t  <core>record-full<\/core>' /etc/emulationstation/es_systems.cfg
		  tac /etc/emulationstation/es_systems.cfg > /home/ark/temp.cfg
		  sed -i -e '/gba<\/platform>/{n;d}' /home/ark/temp.cfg
		  sed -i '/<platform>gba<\/platform>/c\\t\t<platform>gba<\/platform>\n\t\t   <\/emulators>\n\t\t \t<\/emulator>\n\t\t \t<\/cores>\n\t\t \t  <core>record-full<\/core>\n\t\t \t  <core>record-aspect<\/core>\n\t\t \t  <core>norecord-full<\/core>\n\t\t \t  <core>norecord-aspect<\/core>\n\t\t \t<cores>\n\t\t      <emulator name\=\"mednafen\">' /home/ark/temp.cfg
		  sed -i -e '/snes<\/theme>/{n;d}' /home/ark/temp.cfg
		  sed -i -e '/snes<\/theme>/{n;d}' /home/ark/temp.cfg
		  sed -i '/<theme>snes<\/theme>/c\\t\t<theme>snes<\/theme>\n\t\t<platform>snes<\/platform>\n\t\t   <\/emulators>\n\t\t \t  <\/emulator>\n\t\t \t<\/cores>\n\t\t \t  <core>record-full<\/core>\n\t\t \t  <core>record-aspect<\/core>\n\t\t \t  <core>norecord-full<\/core>\n\t\t \t  <core>norecord-aspect<\/core>\n\t\t \t<cores>\n\t\t      <emulator name\=\"mednafen\">' /home/ark/temp.cfg
		  #sed -i -e '/snes-hacks<\/theme>/{n;d}' /home/ark/temp.cfg
		  #sed -i -e '/snes-hacks<\/theme>/{n;d}' /home/ark/temp.cfg
		  #sed -i '/<theme>snes-hacks<\/theme>/c\\t\t<theme>snes-hacks<\/theme>\n\t\t<platform>snes<\/platform>\n\t\t   <\/emulators>\n\t\t \t  <\/emulator>\n\t\t \t<\/cores>\n\t\t \t  <core>record-full<\/core>\n\t\t \t  <core>record-aspect<\/core>\n\t\t \t  <core>norecord-full<\/core>\n\t\t \t  <core>norecord-aspect<\/core>\n\t\t \t<cores>\n\t\t      <emulator name\=\"mednafen\">' /home/ark/temp.cfg
		  sed -i -e '/sfc<\/theme>/{n;d}' /home/ark/temp.cfg
		  sed -i -e '/sfc<\/theme>/{n;d}' /home/ark/temp.cfg
		  sed -i '/<theme>sfc<\/theme>/c\\t\t<theme>sfc<\/theme>\n\t\t<platform>sfc<\/platform>\n\t\t   <\/emulators>\n\t\t \t  <\/emulator>\n\t\t \t<\/cores>\n\t\t \t  <core>record-full<\/core>\n\t\t \t  <core>record-aspect<\/core>\n\t\t \t  <core>norecord-full<\/core>\n\t\t \t  <core>norecord-aspect<\/core>\n\t\t \t<cores>\n\t\t      <emulator name\=\"mednafen\">' /home/ark/temp.cfg
		  sed -i -e '/<platform>gb<\/platform>/{n;d}' /home/ark/temp.cfg
		  sed -i '/<platform>gb<\/platform>/c\\t\t<platform>gb<\/platform>\n\t\t   <\/emulators>\n\t\t \t  <\/emulator>\n\t\t \t<\/cores>\n\t\t \t  <core>record-full<\/core>\n\t\t \t  <core>record-aspect<\/core>\n\t\t \t  <core>norecord-full<\/core>\n\t\t \t  <core>norecord-aspect<\/core>\n\t\t \t<cores>\n\t\t      <emulator name\=\"mednafen\">' /home/ark/temp.cfg
		  sed -i -e '/gbc<\/platform>/{n;d}' /home/ark/temp.cfg
		  sed -i '/<platform>gbc<\/platform>/c\\t\t<platform>gbc<\/platform>\n\t\t   <\/emulators>\n\t\t \t  <\/emulator>\n\t\t \t<\/cores>\n\t\t \t  <core>record-full<\/core>\n\t\t \t  <core>record-aspect<\/core>\n\t\t \t  <core>norecord-full<\/core>\n\t\t \t  <core>norecord-aspect<\/core>\n\t\t \t<cores>\n\t\t      <emulator name\=\"mednafen\">' /home/ark/temp.cfg
		  sed -i -e '/megadrive<\/platform>/{n;d}' /home/ark/temp.cfg
		  sed -i '/<platform>megadrive<\/platform>/c\\t\t<platform>megadrive<\/platform>\n\t\t   <\/emulators>\n\t\t \t  <\/emulator>\n\t\t \t<\/cores>\n\t\t \t  <core>record-full<\/core>\n\t\t \t  <core>record-aspect<\/core>\n\t\t \t  <core>norecord-full<\/core>\n\t\t \t  <core>norecord-aspect<\/core>\n\t\t \t<cores>\n\t\t      <emulator name\=\"mednafen\">' /home/ark/temp.cfg
		  sed -i -e '/genesis<\/platform>/{n;d}' /home/ark/temp.cfg
		  sed -i '/<platform>genesis<\/platform>/c\\t\t<platform>genesis<\/platform>\n\t\t   <\/emulators>\n\t\t \t  <\/emulator>\n\t\t \t<\/cores>\n\t\t \t  <core>record-full<\/core>\n\t\t \t  <core>record-aspect<\/core>\n\t\t \t  <core>norecord-full<\/core>\n\t\t \t  <core>norecord-aspect<\/core>\n\t\t \t<cores>\n\t\t      <emulator name\=\"mednafen\">' /home/ark/temp.cfg
		  sed -i -e '/mastersystem<\/platform>/{n;d}' /home/ark/temp.cfg
		  sed -i '/<platform>mastersystem<\/platform>/c\\t\t<platform>mastersystem<\/platform>\n\t\t   <\/emulators>\n\t\t \t  <\/emulator>\n\t\t \t<\/cores>\n\t\t \t  <core>record-full<\/core>\n\t\t \t  <core>record-aspect<\/core>\n\t\t \t  <core>norecord-full<\/core>\n\t\t \t  <core>norecord-aspect<\/core>\n\t\t \t<cores>\n\t\t      <emulator name\=\"mednafen\">' /home/ark/temp.cfg
		  sed -i -e '/gamegear<\/platform>/{n;d}' /home/ark/temp.cfg
		  sed -i '/<platform>gamegear<\/platform>/c\\t\t<platform>gamegear<\/platform>\n\t\t   <\/emulators>\n\t\t \t  <\/emulator>\n\t\t \t<\/cores>\n\t\t \t  <core>record-full<\/core>\n\t\t \t  <core>record-aspect<\/core>\n\t\t \t  <core>norecord-full<\/core>\n\t\t \t  <core>norecord-aspect<\/core>\n\t\t \t<cores>\n\t\t      <emulator name\=\"mednafen\">\n\t\t \t  <\/emulator>\n\t\t \t<\/cores>\n\t\t \t  <core>genesis_plus_gx<\/core>\n\t\t \t<cores>\n\t\t      <emulator name\=\"retroarch\">\n\t\t   <emulators>\n\t\t<command>sudo perfmax %EMULATOR% %CORE%; nice -n -19 \/usr\/local\/bin\/%EMULATOR% -L \/home\/ark\/.config\/%EMULATOR%\/cores\/%CORE%_libretro.so %ROM%; sudo perfnorm<\/command>' /home/ark/temp.cfg
		  sed -i -e '/wonderswan<\/platform>/{n;d}' /home/ark/temp.cfg
		  sed -i '/<platform>wonderswan<\/platform>/c\\t\t<platform>wonderswan<\/platform>\n\t\t   <\/emulators>\n\t\t \t  <\/emulator>\n\t\t \t<\/cores>\n\t\t \t  <core>record-full<\/core>\n\t\t \t  <core>record-aspect<\/core>\n\t\t \t  <core>norecord-full<\/core>\n\t\t \t  <core>norecord-aspect<\/core>\n\t\t \t<cores>\n\t\t      <emulator name\=\"mednafen\">\n\t\t \t  <\/emulator>\n\t\t \t<\/cores>\n\t\t \t  <core>mednafen_wswan<\/core>\n\t\t \t<cores>\n\t\t      <emulator name\=\"retroarch\">\n\t\t   <emulators>\n\t\t<command>sudo perfmax %EMULATOR% %CORE%; nice -n -19 \/usr\/local\/bin\/%EMULATOR% -L \/home\/ark\/.config\/%EMULATOR%\/cores\/%CORE%_libretro.so %ROM%; sudo perfnorm<\/command>' /home/ark/temp.cfg
		  sed -i -e '/wonderswancolor<\/platform>/{n;d}' /home/ark/temp.cfg
		  sed -i '/<platform>wonderswancolor<\/platform>/c\\t\t<platform>wonderswancolor<\/platform>\n\t\t   <\/emulators>\n\t\t \t  <\/emulator>\n\t\t \t<\/cores>\n\t\t \t  <core>record-full<\/core>\n\t\t \t  <core>record-aspect<\/core>\n\t\t \t  <core>norecord-full<\/core>\n\t\t \t  <core>norecord-aspect<\/core>\n\t\t \t<cores>\n\t\t      <emulator name\=\"mednafen\">\n\t\t \t  <\/emulator>\n\t\t \t<\/cores>\n\t\t \t  <core>mednafen_wswan<\/core>\n\t\t \t<cores>\n\t\t      <emulator name\=\"retroarch\">\n\t\t   <emulators>\n\t\t<command>sudo perfmax %EMULATOR% %CORE%; nice -n -19 \/usr\/local\/bin\/%EMULATOR% -L \/home\/ark\/.config\/%EMULATOR%\/cores\/%CORE%_libretro.so %ROM%; sudo perfnorm<\/command>' /home/ark/temp.cfg
		  tac /home/ark/temp.cfg > /etc/emulationstation/es_systems.cfg
		  sed -i -e '/<command>sudo perfmax %EMULATOR% %CORE%; nice -n -19 \/usr\/local\/bin\/retroarch -L \/home\/ark\/.config\/retroarch\/cores\/mednafen_vb_libretro.so %ROM%; sudo perfnorm<\/command>/{r /home/ark/add_vbmednafen_standalone.txt' -e 'd}' /etc/emulationstation/es_systems.cfg
		  sed -i -e '/<command>sudo perfmax %EMULATOR% %CORE%; nice -n -19 \/usr\/local\/bin\/retroarch -L \/home\/ark\/.config\/retroarch\/cores\/mednafen_ngp_libretro.so %ROM%; sudo perfnorm<\/command>/{r /home/ark/add_ngpmednafen_standalone.txt' -e 'd}' /etc/emulationstation/es_systems.cfg
		  sed -i -e '/.md .MD<\/extension>/{n;d}' /etc/emulationstation/es_systems.cfg
		  sed -i -e '/.md .MD<\/extension>/{n;d}' /etc/emulationstation/es_systems.cfg
		  sed -i -e '/.md .MD<\/extension>/{n;d}' /etc/emulationstation/es_systems.cfg
		  sed -i -e '/.md .MD<\/extension>/{n;d}' /etc/emulationstation/es_systems.cfg
		  sed -i -e '/.md .MD<\/extension>/{n;d}' /etc/emulationstation/es_systems.cfg
		  sed -i -e '/.md .MD<\/extension>/{n;d}' /etc/emulationstation/es_systems.cfg
		  sed -i -e '/.md .MD<\/extension>/{n;d}' /etc/emulationstation/es_systems.cfg
		  sed -i -e '/.md .MD<\/extension>/{n;d}' /etc/emulationstation/es_systems.cfg
		  sed -i -e '/.md .MD<\/extension>/{n;d}' /etc/emulationstation/es_systems.cfg
		  sed -i '/.md .MD<\/extension>/c\\        <extension>.md .MD<\/extension>\n        <command>sudo perfmax %EMULATOR% %CORE%; nice -n -19 \/usr\/local\/bin\/retroarch -L \/home\/ark\/.config\/retroarch\/cores\/genesis_plus_gx_libretro.so %ROM%; sudo perfnorm<\/command>' /etc/emulationstation/es_systems.cfg
		  sudo rm -v /home/ark/temp.cfg | tee -a "$LOG_FILE"
		  sudo rm -v /home/ark/add_vbmednafen_standalone.txt | tee -a "$LOG_FILE"
		  sudo rm -v /home/ark/add_ngpmednafen_standalone.txt | tee -a "$LOG_FILE"
		  sudo rm -v /home/ark/add_arduboy.txt | tee -a "$LOG_FILE"
		fi
		if test -z "$(grep 'a5200' /etc/emulationstation/es_systems.cfg | tr -d '\0')"
		then
		  sed -i -e '/<command>sudo perfmax %EMULATOR% %CORE%; nice -n -19 \/usr\/local\/bin\/retroarch --config \/home\/ark\/.config\/retroarch\/config\/Atari800\/retroarch_5200.cfg -L \/home\/ark\/.config\/retroarch\/cores\/atari800_libretro.so %ROM%; sudo perfnorm<\/command>/{r /home/ark/add_a5200.txt' -e 'd}' /etc/emulationstation/es_systems.cfg
		fi
		if test -z "$(grep 'record' /usr/local/bin/perfmax | tr -d '\0')"
		then
		  sudo sed -i '/\[\[ \$2 == "duckstation" \]\]/s//\[\[ $2 == \"duckstation\" \]\] || [[ "$2" == *\"record\"* ]]/' /usr/local/bin/perfmax
		  sudo sed -i '/\[\[ \$2 == "duckstation" \]\]/s//\[\[ $2 == \"duckstation\" \]\] || [[ "$2" == *\"record\"* ]]/' /usr/local/bin/perfmax.pic
		  sudo sed -i '/\[\[ \$2 == "duckstation" \]\]/s//\[\[ $2 == \"duckstation\" \]\] || [[ "$2" == *\"record\"* ]]/' /usr/local/bin/perfmax.asc
		fi
		if [ -e "/dev/input/by-path/platform-ff300000.usb-usb-0:1.2:1.0-event-joystick" ]; then
		  cp -f -v /home/ark/.mednafen/mednafen.cfg.351v /home/ark/.mednafen/mednafen.cfg | tee -a "$LOG_FILE"
		  rm -f -v /home/ark/.mednafen/mednafen.cfg.* | tee -a "$LOG_FILE"
		elif [ -e "/dev/input/by-path/platform-gameforce-gamepad-event-joystick" ]; then
		  cp -f -v /home/ark/.mednafen/mednafen.cfg.chi /home/ark/.mednafen/mednafen.cfg | tee -a "$LOG_FILE"
		  rm -f -v /home/ark/.mednafen/mednafen.cfg.* | tee -a "$LOG_FILE"
		elif [ -e "/dev/input/by-path/platform-odroidgo3-joypad-event-joystick" ]; then
		  if [ "$(cat ~/.config/.OS)" = "ArkOS" ] && [ "$(cat ~/.config/.DEVICE)" = "RGB10MAX" ]; then
		    cp -f -v /home/ark/.mednafen/mednafen.cfg.rgb10max /home/ark/.mednafen/mednafen.cfg | tee -a "$LOG_FILE"
		    rm -f -v /home/ark/.mednafen/mednafen.cfg.* | tee -a "$LOG_FILE"
		  else
		    cp -f -v /home/ark/.mednafen/mednafen.cfg.351mp /home/ark/.mednafen/mednafen.cfg | tee -a "$LOG_FILE"
		    rm -f -v /home/ark/.mednafen/mednafen.cfg.* | tee -a "$LOG_FILE"
		  fi
		elif [ -e "/dev/input/by-path/platform-odroidgo2-joypad-event-joystick" ]; then
		  if [ ! -z "$(cat /etc/emulationstation/es_input.cfg | grep '190000004b4800000010000001010000')" ]; then
		    cp -f -v /home/ark/.mednafen/mednafen.cfg.rgb10 /home/ark/.mednafen/mednafen.cfg | tee -a "$LOG_FILE"
		    rm -f -v /home/ark/.mednafen/mednafen.cfg.* | tee -a "$LOG_FILE"
		  else
		    cp -f -v /home/ark/.mednafen/mednafen.cfg.rk2020 /home/ark/.mednafen/mednafen.cfg | tee -a "$LOG_FILE"
		    rm -f -v /home/ark/.mednafen/mednafen.cfg.* | tee -a "$LOG_FILE"
		  fi
		fi
		if [ -f "/boot/rk3326-rg351v-linux.dtb" ]; then
		  cp -f -v /opt/gzdoom/gzdoom.351v /opt/gzdoom/gzdoom | tee -a "$LOG_FILE"
		  rm -f -v /opt/gzdoom/gzdoom.* | tee -a "$LOG_FILE"
		elif [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
		  cp -f -v /opt/gzdoom/gzdoom.chi /opt/gzdoom/gzdoom | tee -a "$LOG_FILE"
		  rm -f -v /opt/gzdoom/gzdoom.* | tee -a "$LOG_FILE"
		else
		  rm -f -v /opt/gzdoom/gzdoom.* | tee -a "$LOG_FILE"
		fi
		sudo apt update -y | tee -a "$LOG_FILE"
		sudo apt install -y freeglut3 fluidsynth | tee -a "$LOG_FILE"
		sudo rm -v /home/ark/add_a5200.txt | tee -a "$LOG_FILE"
		sudo rm -v /home/ark/arkosupdate04232022.zip | tee -a "$LOG_FILE"
	else 
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/devices/platform/backlight/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCopy correct yabasanshiro for device\n" | tee -a "$LOG_FILE"
	if [ ! -f "/boot/rk3326-rg351v-linux.dtb" ] && [ ! -f "/boot/rk3326-rg351mp-linux.dtb" ] && [ ! -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  if [ "$(cat ~/.config/.OS)" = "ArkOS" ] && [ "$(cat ~/.config/.DEVICE)" = "RGB10MAX" ]; then
	    cp -fv /opt/yabasanshiro/yabasanshiro.640 /opt/yabasanshiro/yabasanshiro | tee -a "$LOG_FILE"
	    rm -fv /opt/yabasanshiro/yabasanshiro.* | tee -a "$LOG_FILE"
	  else
	    cp -fv /opt/yabasanshiro/yabasanshiro.oga /opt/yabasanshiro/yabasanshiro | tee -a "$LOG_FILE"
	    rm -fv /opt/yabasanshiro/yabasanshiro.* | tee -a "$LOG_FILE"
	  fi
	else
	  cp -fv /opt/yabasanshiro/yabasanshiro.640 /opt/yabasanshiro/yabasanshiro | tee -a "$LOG_FILE"
	  rm -fv /opt/yabasanshiro/yabasanshiro.* | tee -a "$LOG_FILE"
	fi

	printf "\nAdd .mov extension for video player\n" | tee -a "$LOG_FILE"
	if test -z "$(cat /etc/emulationstation/es_systems.cfg | grep '.mov')"
	then
	  sed -i '/<extension>.mp4 .avi .mpeg .mkv/s//<extension>.mp4 .MP4 .avi .AVI .mpeg .MPEG .mkv .MKV .mov .MOV/' /etc/emulationstation/es_systems.cfg
	fi

	printf "\nInstall and link new SDL 2.0.18.2 (aka SDL 2.0.20)\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  sudo mv -f -v /home/ark/sdl2-64/libSDL2-2.0.so.0.18.2 /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.18.2 | tee -a "$LOG_FILE"
	  sudo mv -f -v /home/ark/sdl2-32/libSDL2-2.0.so.0.18.2 /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.18.2 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-32 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-64 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2.so /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.18.2 /usr/lib/aarch64-linux-gnu/libSDL2.so | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2.so /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.18.2 /usr/lib/arm-linux-gnueabihf/libSDL2.so | tee -a "$LOG_FILE"
	else
	  sudo mv -f -v /home/ark/sdl2-64/libSDL2-2.0.so.0.18.2.rotated /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.18.2 | tee -a "$LOG_FILE"
	  sudo mv -f -v /home/ark/sdl2-32/libSDL2-2.0.so.0.18.2.rotated /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.18.2 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-64 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-32 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2.so /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.18.2 /usr/lib/aarch64-linux-gnu/libSDL2.so | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2.so /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.18.2 /usr/lib/arm-linux-gnueabihf/libSDL2.so | tee -a "$LOG_FILE"
	fi

	printf "\nFix loading.ascii for rgb10max only\n" | tee -a "$LOG_FILE"
	if [ "$(cat ~/.config/.OS)" = "ArkOS" ] && [ "$(cat ~/.config/.DEVICE)" = "RGB10MAX" ]; then
	  cp -fv /roms/launchimages/loading.ascii.rgb10max /roms/launchimages/loading.ascii | tee -a "$LOG_FILE"
	  rm -fv /roms/launchimages/loading.ascii.rgb10max | tee -a "$LOG_FILE"
	else
	  rm -fv /roms/launchimages/loading.ascii.rgb10max | tee -a "$LOG_FILE"
	fi

	printf "\nHide Enable Developer Mode script in options/Advanced\n" | tee -a "$LOG_FILE"
	#if test -z "$(cat /opt/system/gamelist.xml | grep 'Developer' | tr -d '\0')"
	#then
	  sed -i '/<\/gameList>/c\\t<game>\n\t\t<path>.\/Advanced\/Enable Developer Mode.sh<\/path>\n\t\t<name>Enable Developer Mode<\/name>\n\t\t<rating>0<\/rating>\n\t\t<releasedate>19691231T190000<\/releasedate>\n\t\t<hidden>true<\/hidden>\n\t<\/game>\n</gameList>' /opt/system/gamelist.xml
	#fi

	#printf "\nFix wrong libmali 64bit being used\n" | tee -a "$LOG_FILE"
	#sudo cp -fv /usr/local/lib/aarch64-linux-gnu/libmali-bifrost-g31-rxp0-gbm.so /usr/lib/aarch64-linux-gnu/libmali-bifrost-g31-rxp0-wayland-gbm.so	| tee -a "$LOG_FILE"

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update04232022"
fi

if [ ! -f "/home/ark/.config/.update06242022" ]; then

	printf "\nUpdated yabasanshiro standalone\nAdjusted poll interval for timesync\nFix .ecwolf files not recognized for Wolfenstein\nFix exfat permission issue\nFix solarus launch script to properly link back to the solarus roms folder\nAdd Italian language support for Emulationstation\nAdd retroarch tate mode for Arcade, CPS1, CPS2, and CPS3\nAdd mame2003_plus to arcade, cps1, cps2, and cps3\n" | tee -a "$LOG_FILE"
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/06242022/arkosupdate06242022.zip -O /home/ark/arkosupdate06242022.zip -a "$LOG_FILE" || rm -f /home/ark/arkosupdate06242022.zip | tee -a "$LOG_FILE"
	if [ -f "/home/ark/arkosupdate06242022.zip" ]; then
		sudo unzip -X -o /home/ark/arkosupdate06242022.zip -d / | tee -a "$LOG_FILE"
		sudo sed -i 's/oga_controls yabasanshiro/oga_controls yaba/' /usr/local/bin/saturn.sh
		if test -z "$(grep "PollIntervalMinSec=60" /etc/systemd/timesyncd.conf | tr -d '\0')"
		then
		  sudo sed -i '$aPollIntervalMinSec=60' /etc/systemd/timesyncd.conf
		  sudo sed -i '$aPollIntervalMaxSec=3600' /etc/systemd/timesyncd.conf
		fi
		cp -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update06242022.bak | tee -a "$LOG_FILE"
		if test -z "$(cat /etc/emulationstation/es_systems.cfg | grep 'name="retroarch-tate"' | tr -d '\0')"
		then
		  sed -i '/<core>fbalpha2018<\/core>/c\\t\t \t  <core>fbalpha2018<\/core>\n\t\t \t<\/cores>\n\t\t      <\/emulator>\n\t\t      <emulator name\=\"retroarch-tate\">\n\t\t \t<cores>\n\t\t \t  <core>fbneo<\/core>\n\t\t \t  <core>mame2003_plus<\/core>' /etc/emulationstation/es_systems.cfg
		  sed -i '/<core>fbalpha2012<\/core>/c\\t\t\t  <core>fbalpha2012<\/core>\n\t\t\t  <core>mame2003_plus<\/core>' /etc/emulationstation/es_systems.cfg
		fi
		sed -i '/mame2003-plus_skip_disclaimer \=/c\mame2003-plus_skip_disclaimer \= "enabled"' /home/ark/.config/retroarch/retroarch-core-options.cfg
		sed -i '/mame2003-plus_skip_disclaimer \=/c\mame2003-plus_skip_disclaimer \= "enabled"' /home/ark/.config/retroarch/retroarch-core-options.cfg.bak
		sed -i '/mame2003-plus_skip_warnings \=/c\mame2003-plus_skip_warnings \= "enabled"' /home/ark/.config/retroarch/retroarch-core-options.cfg
		sed -i '/mame2003-plus_skip_warnings \=/c\mame2003-plus_skip_warnings \= "enabled"' /home/ark/.config/retroarch/retroarch-core-options.cfg.bak
		sed -i '/<extension>.wolf .WOLF/s//<extension>.wolf .WOLF .ecwolf .ECWOLF/' /etc/emulationstation/es_systems.cfg
		sudo sed -i 's/exfat defaults,auto,umask=000,noatime 0 0/exfat defaults,auto,umask=000,uid=1002,gid=1002,noatime 0 0/' /etc/fstab
		sudo sed -i 's/exfat umask=0000,iocharset=utf8,noatime 0 0/exfat umask=0000,iocharset=utf8,uid=1002,gid=1002,noatime 0 0/' /etc/fstab
		sudo sed -i 's/umask=0000,iocharset=utf8,noatime 0 0/umask=0000,iocharset=utf8,uid=1002,gid=1002,noatime 0 0/' /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh
		sudo sed -i 's/umask=0000,iocharset=utf8,noatime 0 0/umask=0000,iocharset=utf8,uid=1002,gid=1002,noatime 0 0/' /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh
		sudo rm -v /home/ark/arkosupdate06242022.zip | tee -a "$LOG_FILE"
	else 
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/devices/platform/backlight/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCopy correct yabasanshiro for device\n" | tee -a "$LOG_FILE"
	if [ ! -f "/boot/rk3326-rg351v-linux.dtb" ] && [ ! -f "/boot/rk3326-rg351mp-linux.dtb" ] && [ ! -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  if [ "$(cat ~/.config/.OS)" = "ArkOS" ] && [ "$(cat ~/.config/.DEVICE)" = "RGB10MAX" ]; then
	    cp -fv /opt/yabasanshiro/yabasanshiro.640 /opt/yabasanshiro/yabasanshiro | tee -a "$LOG_FILE"
	    rm -fv /opt/yabasanshiro/yabasanshiro.* | tee -a "$LOG_FILE"
	  else
	    cp -fv /opt/yabasanshiro/yabasanshiro.oga /opt/yabasanshiro/yabasanshiro | tee -a "$LOG_FILE"
	    rm -fv /opt/yabasanshiro/yabasanshiro.* | tee -a "$LOG_FILE"
	  fi
	else
	  cp -fv /opt/yabasanshiro/yabasanshiro.640 /opt/yabasanshiro/yabasanshiro | tee -a "$LOG_FILE"
	  rm -fv /opt/yabasanshiro/yabasanshiro.* | tee -a "$LOG_FILE"
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update06242022"
fi

if [ ! -f "/home/ark/.config/.update07012022" ]; then

	printf "\nUpdated scummvm.sh script for scan of new games\nAdd missing shaders folder for some scummvm games\n" | tee -a "$LOG_FILE"
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/07012022/arkosupdate07012022.zip -O /home/ark/arkosupdate07012022.zip -a "$LOG_FILE" || rm -f /home/ark/arkosupdate07012022.zip | tee -a "$LOG_FILE"
	if [ -f "/home/ark/arkosupdate07012022.zip" ]; then
		sudo unzip -X -o /home/ark/arkosupdate07012022.zip -d / | tee -a "$LOG_FILE"
		sudo rm -v /home/ark/arkosupdate07012022.zip | tee -a "$LOG_FILE"
	else 
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/devices/platform/backlight/backlight/backlight/brightness
		exit 1
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update07012022"
fi

if [ ! -f "/home/ark/.config/.update07302022" ]; then

	printf "\nUpdate PPSSPPSDL to 1.13.1\nUpdate OpenBOR\nUpdate Hypseus-Singe to 2.8.2c\nUpdate OpenBOR launcher script\n" | tee -a "$LOG_FILE"
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/07302022/arkosupdate07302022.zip -O /home/ark/arkosupdate07302022.zip -a "$LOG_FILE" || rm -f /home/ark/arkosupdate07302022.zip | tee -a "$LOG_FILE"
	if [ -f "/home/ark/arkosupdate07302022.zip" ]; then
		sudo unzip -X -o /home/ark/arkosupdate07302022.zip -d / | tee -a "$LOG_FILE"
		sudo rm -v /home/ark/arkosupdate07302022.zip | tee -a "$LOG_FILE"
	else 
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/devices/platform/backlight/backlight/backlight/brightness
		exit 1
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update07302022"
fi

if [ ! -f "/home/ark/.config/.update08222022" ]; then

	printf "\nAdd gliden64 video plugin for mupen64plus standalone\nUpdate yabasanshirosa with low res patch\nAdd Duckstation Standalone\nDefault ports governor to performance\n" | tee -a "$LOG_FILE"
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/08222022/arkosupdate08222022.zip -O /home/ark/arkosupdate08222022.zip -a "$LOG_FILE" || rm -f /home/ark/arkosupdate08222022.zip | tee -a "$LOG_FILE"
	if [ -f "/home/ark/arkosupdate08222022.zip" ]; then
		sudo unzip -X -o /home/ark/arkosupdate08222022.zip -d / | tee -a "$LOG_FILE"
		cp -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update08222022.bak | tee -a "$LOG_FILE"
		sed -i '/sudo perfmax %EMULATOR% %CORE%; nice -n -19 %ROM%; sudo perfnorm/c\\t\t<command>sudo perfmax On; nice -n -19 %ROM%; sudo perfnorm<\/command>' /etc/emulationstation/es_systems.cfg
		if test -z "$(cat /etc/emulationstation/es_systems.cfg | grep standalone-duckstation)"
		then
		  sed -i -zE 's/<\/emulators>([^\n]*\n[^\n]*<platform>psx<\/platform>)/   <emulator name=\"\standalone-duckstation\">\n\t\t      <\/emulator>\n\t\t   <\/emulators>\1/' /etc/emulationstation/es_systems.cfg
		fi
		if [ -e "/dev/input/by-path/platform-ff300000.usb-usb-0:1.2:1.0-event-joystick" ]; then
		  printf "\ncopy correct duckstation binary per device\n" | tee -a "$LOG_FILE"
		  sudo rm -fv /usr/local/bin/duckstation-nogui.chirgb10 | tee -a "$LOG_FILE"
		  sed -i '/Rotate = 1/d' /home/ark/.config/duckstation/settings.ini
		  if [ -f "/opt/system/Advanced/Switch to main SD for Roms.sh" ]; then
		    sed -i '/<path>\/roms\//s//<path>\/roms2\//g' /home/ark/.config/duckstation/settings.ini
		    sudo cp -fv "/usr/local/bin/Switch to SD2 for Roms.sh" "/opt/system/Advanced/Switch to SD2 for Roms.sh" | tee -a "$LOG_FILE"
		  else
		    sudo cp -fv "/usr/local/bin/Switch to main SD for Roms.sh" "/opt/system/Advanced/Switch to main SD for Roms.sh" | tee -a "$LOG_FILE"
		  fi
		elif [ -e "/dev/input/by-path/platform-odroidgo2-joypad-event-joystick" ]; then
			sudo rm -v "/usr/local/bin/Switch to SD2 for Roms.sh" | tee -a "$LOG_FILE"
			sudo rm -v "/usr/local/bin/Switch to main SD for Roms.sh" | tee -a "$LOG_FILE"
			if [ ! -z "$(cat /etc/emulationstation/es_input.cfg | grep "190000004b4800000010000001010000")" ]; then
			  printf "\ncopy correct duckstation binary per device\n" | tee -a "$LOG_FILE"
			  sudo mv -fv /usr/local/bin/duckstation-nogui.chirgb10 /usr/local/bin/duckstation-nogui | tee -a "$LOG_FILE"
			else
			  printf "\ncopy correct duckstation binary per device\n" | tee -a "$LOG_FILE"
			  sudo rm -fv /usr/local/bin/duckstation-nogui.chirgb10 | tee -a "$LOG_FILE"
			fi
		elif [ -e "/dev/input/by-path/platform-odroidgo3-joypad-event-joystick" ]; then
		  printf "\ncopy correct duckstation binary per device\n" | tee -a "$LOG_FILE"
		  sudo rm -fv /usr/local/bin/duckstation-nogui.chirgb10 | tee -a "$LOG_FILE"
		  if [ -f "/boot/rk3326-rg351mp-linux.dtb" ]; then
		    sed -i '/Rotate = 1/d' /home/ark/.config/duckstation/settings.ini
		    if [ -f "/opt/system/Advanced/Switch to main SD for Roms.sh" ]; then
		      sed -i '/<path>\/roms\//s//<path>\/roms2\//g' /home/ark/.config/duckstation/settings.ini
		      sudo cp -fv "/usr/local/bin/Switch to SD2 for Roms.sh" "/opt/system/Advanced/Switch to SD2 for Roms.sh" | tee -a "$LOG_FILE"
		    else
		      sudo cp -fv "/usr/local/bin/Switch to main SD for Roms.sh" "/opt/system/Advanced/Switch to main SD for Roms.sh" | tee -a "$LOG_FILE"
		    fi
		  else
			sudo rm -v "/usr/local/bin/Switch to SD2 for Roms.sh" | tee -a "$LOG_FILE"
			sudo rm -v "/usr/local/bin/Switch to main SD for Roms.sh" | tee -a "$LOG_FILE"
		  fi
		else
		  printf "\ncopy correct duckstation binary per device\n" | tee -a "$LOG_FILE"
		  sudo mv -fv /usr/local/bin/duckstation-nogui.chirgb10 /usr/local/bin/duckstation-nogui | tee -a "$LOG_FILE"
		  sed -i '/Rotate = 1/d' /home/ark/.config/duckstation/settings.ini
		  sudo rm -v "/usr/local/bin/Switch to SD2 for Roms.sh" | tee -a "$LOG_FILE"
		  sudo rm -v "/usr/local/bin/Switch to main SD for Roms.sh" | tee -a "$LOG_FILE"
		fi
		if test -z "$(cat /home/ark/.config/mupen64plus/mupen64plus.cfg | grep Video-GLideN64)"
		then
		  sed -i -e '/Rotate \= 0/{r /home/ark/add_gliden64_to_mupen64plus_cfg.txt' -e 'd}' /home/ark/.config/mupen64plus/mupen64plus.cfg
		fi
		if test -z "$(grep 'GlideN64' /usr/local/bin/perfmax | tr -d '\0')"
		then
		  sudo sed -i '/\[\[ \$1 == "standalone-Rice" \]\] || \[\[ \$1 == "standalone-Glide64mk2" \]\]/s//\[\[ \$1 == "standalone-Rice" \]\] || \[\[ \$1 == "standalone-Glide64mk2" \]\] || \[\[ \$1 == "standalone-GlideN64" \]\]/' /usr/local/bin/perfmax
  		  sudo sed -i '/\[\[ \$1 == "standalone-Rice" \]\] || \[\[ \$1 == "standalone-Glide64mk2" \]\]/s//\[\[ \$1 == "standalone-Rice" \]\] || \[\[ \$1 == "standalone-Glide64mk2" \]\] || \[\[ \$1 == "standalone-GlideN64" \]\]/' /usr/local/bin/perfmax.pic
  		  sudo sed -i '/\[\[ \$1 == "standalone-Rice" \]\] || \[\[ \$1 == "standalone-Glide64mk2" \]\]/s//\[\[ \$1 == "standalone-Rice" \]\] || \[\[ \$1 == "standalone-Glide64mk2" \]\] || \[\[ \$1 == "standalone-GlideN64" \]\]/' /usr/local/bin/perfmax.asc
		fi
		sed -i '/<extension>.cue .CUE .ccd .CCD .lha .LHA .nrg .NRG .mds .MDS .iso .ISO .m3u .M3U/s//<extension>.chd .CHD .cue .CUE .ccd .CCD .lha .LHA .nrg .NRG .mds .MDS .iso .ISO .m3u .M3U/' /etc/emulationstation/es_systems.cfg
		sudo rm -v /home/ark/arkosupdate08222022.zip | tee -a "$LOG_FILE"
		sudo rm -v /home/ark/add_gliden64_to_mupen64plus_cfg.txt | tee -a "$LOG_FILE"
	else 
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCopy correct yabasanshiro for device and add n64 widescreen support where applicable\n" | tee -a "$LOG_FILE"
	if [ ! -f "/boot/rk3326-rg351v-linux.dtb" ] && [ ! -f "/boot/rk3326-rg351mp-linux.dtb" ] && [ ! -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  if [ "$(cat ~/.config/.OS)" = "ArkOS" ] && [ "$(cat ~/.config/.DEVICE)" = "RGB10MAX" ]; then
	    printf "\nAdd support for 4:3 aspect ratio for mupen64plus standalone rice video plugin\n" | tee -a "$LOG_FILE"
	    if test -z "$(grep "ResolutionWidth" /home/ark/.config/mupen64plus/mupen64plus.cfg | tr -d '\0')"
	    then
	      sed -i "/\[Video-Rice\]/c\\[Video-Rice\]\n\n\# Hack to accomodate widescreen devices (Thanks to AmberElec sources for tip)\nResolutionWidth \= 848" /home/ark/.config/mupen64plus/mupen64plus.cfg
	    fi
	    if [ $(grep -c '<core>Default_Aspect' /etc/emulationstation/es_systems.cfg | tr -d '\0') -lt 2 ]; then 
	      sed -i '/<emulator name="standalone-Rice">/c\              <emulator name="standalone-Rice">\n\t\t \t<cores>\n\t\t \t  <core>Default_Aspect<\/core>\n\t\t \t  <core>Widescreen_Aspect<\/core>\n\t\t \t<\/cores>' /etc/emulationstation/es_systems.cfg
	    fi
	    printf "\nAdd widescreen mode support for mupen64plus-glide64mk2\n" | tee -a "$LOG_FILE"
	    if test -z "$(grep '<core>Default_Aspect' /etc/emulationstation/es_systems.cfg | tr -d '\0')"
	    then
	      sed -i '/<emulator name="standalone-Glide64mk2">/c\              <emulator name="standalone-Glide64mk2">\n\t\t \t<cores>\n\t\t \t  <core>Default_Aspect<\/core>\n\t\t \t  <core>Widescreen_Aspect<\/core>\n\t\t \t<\/cores>' /etc/emulationstation/es_systems.cfg
	    fi
	    printf "\nAdd GLideN64 plugin for mupen64plus standalone to ES\n" | tee -a "$LOG_FILE"
	    if test -z "$(grep 'standalone-GlideN64' /etc/emulationstation/es_systems.cfg | tr -d '\0')"
	    then
	      sed -i '/<emulator name="standalone-Glide64mk2">/c\              <emulator name="standalone-Glide64mk2">\n\t\t \t<cores>\n\t\t \t  <core>Default_Aspect<\/core>\n\t\t \t  <core>Widescreen_Aspect<\/core>\n\t\t \t<\/cores>\n              <\/emulator>\n              <emulator name="standalone-GlideN64">' /etc/emulationstation/es_systems.cfg
	    fi
	    cp -fv /opt/yabasanshiro/yabasanshiro.640 /opt/yabasanshiro/yabasanshiro | tee -a "$LOG_FILE"
	    rm -fv /opt/yabasanshiro/yabasanshiro.* | tee -a "$LOG_FILE"
	  else
	    printf "\nAdd GLideN64 plugin for mupen64plus standalone to ES\n" | tee -a "$LOG_FILE"
	    if test -z "$(grep 'standalone-GlideN64' /etc/emulationstation/es_systems.cfg | tr -d '\0')"
	    then
	      sed -i '/<emulator name="standalone-Glide64mk2">/c\              <emulator name="standalone-Glide64mk2">\n\t\t \t<cores>\n\t\t \t  <core>Default_Aspect<\/core>\n\t\t \t  <core>Widescreen_Aspect<\/core>\n\t\t \t<\/cores>\n              <\/emulator>\n              <emulator name="standalone-GlideN64">' /etc/emulationstation/es_systems.cfg
	    fi
	    printf "\nAdd support for 4:3 aspect ratio for mupen64plus standalone rice video plugin\n" | tee -a "$LOG_FILE"
	    if test -z "$(grep "ResolutionWidth" /home/ark/.config/mupen64plus/mupen64plus.cfg | tr -d '\0')"
	    then
	      sed -i "/\[Video-Rice\]/c\\[Video-Rice\]\n\n\# Hack to accomodate widescreen devices (Thanks to AmberElec sources for tip)\nResolutionWidth \= 480" /home/ark/.config/mupen64plus/mupen64plus.cfg
	    fi
	    if [ $(grep -c '<core>Default_Aspect' /etc/emulationstation/es_systems.cfg | tr -d '\0') -lt 2 ]; then 
	      sed -i '/<emulator name="standalone-Rice">/c\              <emulator name="standalone-Rice">\n\t\t \t<cores>\n\t\t \t  <core>Default_Aspect<\/core>\n\t\t \t  <core>Widescreen_Aspect<\/core>\n\t\t \t<\/cores>' /etc/emulationstation/es_systems.cfg
	    fi
	    cp -fv /opt/yabasanshiro/yabasanshiro.oga /opt/yabasanshiro/yabasanshiro | tee -a "$LOG_FILE"
	    rm -fv /opt/yabasanshiro/yabasanshiro.* | tee -a "$LOG_FILE"
	  fi
	else
	  printf "\nAdd GLideN64 plugin for mupen64plus standalone to ES\n" | tee -a "$LOG_FILE"
	  if test -z "$(grep 'standalone-GlideN64' /etc/emulationstation/es_systems.cfg | tr -d '\0')"
	  then
	    sed -i '/<emulator name="standalone-Glide64mk2">/c\              <emulator name="standalone-Glide64mk2">\n              <\/emulator>\n              <emulator name="standalone-GlideN64">' /etc/emulationstation/es_systems.cfg
	  fi
	  cp -fv /opt/yabasanshiro/yabasanshiro.640 /opt/yabasanshiro/yabasanshiro | tee -a "$LOG_FILE"
	  rm -fv /opt/yabasanshiro/yabasanshiro.* | tee -a "$LOG_FILE"
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update08222022"
fi

if [ ! -f "/home/ark/.config/.update09052022" ]; then

	printf "\nClean Up some system full names in ES\nFixed Switch to SD2 and Switch to main scripts\nUpdated Duckstation to prevent Vulkan setting\n" | tee -a "$LOG_FILE"
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/09052022/arkosupdate09052022.zip -O /home/ark/arkosupdate09052022.zip -a "$LOG_FILE" || rm -f /home/ark/arkosupdate09052022.zip | tee -a "$LOG_FILE"
	if [ -f "/home/ark/arkosupdate09052022.zip" ]; then
		sudo unzip -X -o /home/ark/arkosupdate09052022.zip -d / | tee -a "$LOG_FILE"
		cp -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update09052022.bak | tee -a "$LOG_FILE"
		sed -i '/<fullname>Turbografx CD<\/fullname>/s//<fullname>NEC - Turbografx CD<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/<fullname>Turbografx 16<\/fullname>/s//<fullname>NEC - Turbografx 16<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/<fullname>Sega Saturn<\/fullname>/s//<fullname>Sega - Saturn<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/<fullname>Sega Naomi<\/fullname>/s//<fullname>Sega - Naomi<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/<fullname>Sega Dreamcast<\/fullname>/s//<fullname>Sega - Dreamcast<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/<fullname>Sega Dreamcast VMU<\/fullname>/s//<fullname>Sega - Dreamcast VMU<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/<fullname>Sega Atomiswave<\/fullname>/s//<fullname>Sega - Atomiswave<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/<fullname>Phillips CDI<\/fullname>/s//<fullname>Phillips - CDI<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/<fullname>Nintendo 64DD<\/fullname>/s//<fullname>Nintendo - 64DD<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/<fullname>Nintendo DS<\/fullname>/s//<fullname>Nintendo - DS<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/<fullname>Mattel Intellivision<\/fullname>/s//<fullname>Mattel - Intellivision<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/<fullname>Microsoft MSX<\/fullname>/s//<fullname>Microsoft - MSX<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/<fullname>Microsoft MSX 2<\/fullname>/s//<fullname>Microsoft - MSX 2<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/<fullname>Fairchild ChannelF<\/fullname>/s//<fullname>Fairchild - ChannelF<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/<fullname>Atari ST<\/fullname>/s//<fullname>Atari - ST<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/<fullname>Atari Jaguar<\/fullname>/s//<fullname>Atari - Jaguar<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/<fullname>Atari 5200<\/fullname>/s//<fullname>Atari - 5200<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/<fullname>Amiga<\/fullname>/s//<fullname>Commodore - Amiga<\/fullname>/' /etc/emulationstation/es_systems.cfg
		sed -i '/\/3DO\//s//\/3do\//' /etc/emulationstation/es_systems.cfg
		sed -i '/<extension>.n64 .N64 .z64 .Z64<\/extension>/s//<extension>.d64 .D64 .n64dd .N64DD .ndd .NDD .n64 .N64 .z64 .Z64<\/extension>/' /etc/emulationstation/es_systems.cfg
		if test ! -z "$(cat /home/ark/.config/duckstation/settings.ini | grep Vulkan | tr -d '\0')"
		then
		  sed -i '/Vulkan/s//OpenGL/' /home/ark/.config/duckstation/settings.ini
		fi
	    if test -z "$(cat /etc/fstab | grep roms2 | tr -d '\0')"
		then
	      sed -i '/<path>\/roms2\//s//<path>\/roms\//g' /home/ark/.config/duckstation/settings.ini
		  sudo rm -v "/opt/system/Advanced/Switch to main SD for Roms.sh" | tee -a "$LOG_FILE"
	      sudo cp -fv "/usr/local/bin/Switch to SD2 for Roms.sh" "/opt/system/Advanced/Switch to SD2 for Roms.sh" | tee -a "$LOG_FILE"
	    else
	      sed -i '/<path>\/roms\//s//<path>\/roms2\//g' /home/ark/.config/duckstation/settings.ini
		  sudo rm -v "/opt/system/Advanced/Switch to SD2 for Roms.sh" | tee -a "$LOG_FILE"
	      sudo cp -fv "/usr/local/bin/Switch to main SD for Roms.sh" "/opt/system/Advanced/Switch to main SD for Roms.sh" | tee -a "$LOG_FILE"
	    fi
		sudo rm -v /home/ark/arkosupdate09052022.zip | tee -a "$LOG_FILE"
	else 
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCopy correct Duckstation standalone build per device\n" | tee -a "$LOG_FILE"
	if test -z "$(cat /usr/local/bin/standalone-duckstation | grep "/opt/duckstation/" | tr -d '\0')"
	then
	  sudo sed -i '/duckstation-nogui/s//\/opt\/duckstation\/duckstation-nogui/g' /usr/local/bin/standalone-duckstation
	fi
	if [ -e "/dev/input/by-path/platform-odroidgo2-joypad-event-joystick" ]; then
	  if [ ! -z "$(cat /etc/emulationstation/es_input.cfg | grep "190000004b4800000010000001010000")" ]; then
		sudo rm -fv /usr/local/bin/duckstation-nogui | tee -a "$LOG_FILE"
	    sudo mv -fv /opt/duckstation/duckstation-nogui.chirgb10 /opt/duckstation/duckstation-nogui | tee -a "$LOG_FILE"
	  else
	    sudo rm -fv /usr/local/bin/duckstation-nogui* | tee -a "$LOG_FILE"
		sudo rm -fv /opt/duckstation/duckstation-nogui.chirgb10 | tee -a "$LOG_FILE"
	  fi
	elif [ -e "/dev/input/by-path/platform-odroidgo3-joypad-event-joystick" ]; then
	  sudo rm -fv /usr/local/bin/duckstation-nogui* | tee -a "$LOG_FILE"
	  sudo rm -fv /opt/duckstation/duckstation-nogui.chirgb10 | tee -a "$LOG_FILE"
	elif [ -e "/dev/input/by-path/platform-gameforce-gamepad-event-joystick" ]; then
	  sudo rm -fv /usr/local/bin/duckstation-nogui* | tee -a "$LOG_FILE"
	  sudo mv -fv /opt/duckstation/duckstation-nogui.chirgb10 /opt/duckstation/duckstation-nogui | tee -a "$LOG_FILE"
	else
	  sudo rm -fv /usr/local/bin/duckstation-nogui* | tee -a "$LOG_FILE"
	  sudo rm -fv /opt/duckstation/duckstation-nogui.chirgb10 | tee -a "$LOG_FILE"
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update09052022"
fi

if [ ! -f "/home/ark/.config/.update10292022" ]; then

	printf "\nUpdate to Retroarch 1.12.0\nAdd Fake08 emulator\nUpdate Pico-8.sh script\nDisable Network Manager wait online by default\nAdd Love 11.4 engine\nUpdate Enable Developer Mode script\nUpdate timezones script\nEnable Threaded DSP for 3DO\nAdd headphone insertion detection workaround\Add missing gc folder\n" | tee -a "$LOG_FILE"
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/10292022/arkosupdate10292022.zip -O /home/ark/arkosupdate10292022.zip -a "$LOG_FILE" || rm -f /home/ark/arkosupdate10292022.zip | tee -a "$LOG_FILE"
	if [ -f "/home/ark/arkosupdate10292022.zip" ]; then
		sudo unzip -X -o /home/ark/arkosupdate10292022.zip -d / | tee -a "$LOG_FILE"
		cp -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update10292022.bak | tee -a "$LOG_FILE"
		if test -z "$(cat /etc/emulationstation/es_systems.cfg | grep '<emulator name="fake08">' | tr -d '\0')"
		then
		  sed -i '/<emulator name="full-screen">/c\              <emulator name="full-screen">\n              <\/emulator>\n              <emulator name="fake08">' /etc/emulationstation/es_systems.cfg
		fi
		sudo systemctl disable NetworkManager-wait-online
		sudo systemctl stop NetworkManager-wait-online
		if test -z "$(cat /opt/system/Enable\ Remote\ Services.sh | grep 'NetworkManager-wait-online' | tr -d '\0')"
		then
		  sed -i "/\#\!\/bin\/bash/c\\#\!\/bin\/bash\nsudo systemctl enable NetworkManager-wait-online\nsudo systemctl start NetworkManager-wait-online" /opt/system/Enable\ Remote\ Services.sh
		fi
		if test -z "$(cat /opt/system/Disable\ Remote\ Services.sh | grep 'NetworkManager-wait-online' | tr -d '\0')"
		then
		  sed -i "/\#\!\/bin\/bash/c\\#\!\/bin\/bash\nsudo systemctl disable NetworkManager-wait-online\nsudo systemctl stop NetworkManager-wait-online" /opt/system/Disable\ Remote\ Services.sh
		fi
		if test -z "$(cat /etc/emulationstation/es_systems.cfg | grep 'love' | tr -d '\0')"
		then
		  sed -i -e '/<theme>n64dd<\/theme>/{r /home/ark/add_love.txt' -e 'd}' /etc/emulationstation/es_systems.cfg
		fi
		if [ ! -d "/roms/love2d" ]; then
		  mkdir -v /roms/love2d | tee -a "$LOG_FILE"
		  if test ! -z "$(cat /etc/fstab | grep roms2 | tr -d '\0')"
		  then
		    if [ ! -d "/roms2/love2d" ]; then
		      mkdir -v /roms2/love2d | tee -a "$LOG_FILE"
		      sed -i '/<path>\/roms\/love2d/s//<path>\/roms2\/love2d/g' /etc/emulationstation/es_systems.cfg
			fi
		  fi
		fi
		if [ -f "/opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh" ]; then
		  if test -z "$(cat /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh | grep love2d | tr -d '\0')"
		  then
		    sudo chown -v ark:ark /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh | tee -a "$LOG_FILE"
		    sed -i '/sudo pkill filebrowser/s//if [ \! -d "\/roms2\/love2d\/" ]\; then\n      sudo mkdir \/roms2\/love2d\n  fi\n  sudo pkill filebrowser/' /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh
		  else
		    printf "\nLove2d is already being accounted for in the switch to sd2 script\n" | tee -a "$LOG_FILE"
		  fi
		  if test -z "$(cat /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh | grep gc | tr -d '\0')"
		  then
		    sed -i '/sudo pkill filebrowser/s//if [ \! -d "\/roms2\/gc\/" ]\; then\n      sudo mkdir \/roms2\/gc\n  fi\n  sudo pkill filebrowser/' /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh
		  else
		    printf "\nGC is already being accounted for in the switch to sd2 script\n" | tee -a "$LOG_FILE"
		  fi
		fi
		if [ -f "/usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh" ]; then
		  if test -z "$(cat /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh | grep love2d | tr -d '\0')"
		  then
		    sudo sed -i '/sudo pkill filebrowser/s//if [ \! -d "\/roms2\/love2d\/" ]\; then\n      sudo mkdir \/roms2\/love2d\n  fi\n  sudo pkill filebrowser/' /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh
		  else
		    printf "\nLove2d is already being accounted for in the switch to sd2 script\n" | tee -a "$LOG_FILE"
		  fi
		  if test -z "$(cat /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh | grep gc | tr -d '\0')"
		  then
		    sudo sed -i '/sudo pkill filebrowser/s//if [ \! -d "\/roms2\/gc\/" ]\; then\n      sudo mkdir \/roms2\/gc\n  fi\n  sudo pkill filebrowser/' /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh
		  else
		    printf "\nGC is already being accounted for in the switch to sd2 script\n" | tee -a "$LOG_FILE"
		  fi
		fi
		if [ -f "/boot/rk3566.dtb" ]; then
		  if [ ! -d "/roms/gc" ]; then
		    mkdir -v /roms/gc | tee -a "$LOG_FILE"
		    if test ! -z "$(cat /etc/fstab | grep roms2 | tr -d '\0')"
		    then
			  if [ ! -d "/roms2/gc" ]; then
		        mkdir -v /roms2/gc | tee -a "$LOG_FILE"
		        sed -i '/<path>\/roms\/gc/s//<path>\/roms2\/gc/g' /etc/emulationstation/es_systems.cfg
			  fi
		    fi
		  fi
		fi
		cd /roms/themes/es-theme-nes-box
		git reset --hard origin/master | tee -a "$LOG_FILE"
		git pull | tee -a "$LOG_FILE"
		sudo chown ark:ark /opt/system/Advanced/Enable\ Developer\ Mode.sh
		cd /home/ark
		sudo rm -v /home/ark/add_love.txt | tee -a "$LOG_FILE"
		sudo rm -v /home/ark/arkosupdate10292022.zip | tee -a "$LOG_FILE"
	else 
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCopy correct PPSSPPSDL for device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ]; then
      rm -fv /opt/ppsspp/PPSSPPSDL.rk3326 | tee -a "$LOG_FILE"
    else
      mv -fv /opt/ppsspp/PPSSPPSDL.rk3326 /opt/ppsspp/PPSSPPSDL | tee -a "$LOG_FILE"
	fi
	
	printf "\nCopy correct fake08 for device\n" | tee -a "$LOG_FILE"
#	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
#	    cp -fv /opt/fake08/fake08.640 /opt/fake08/fake08 | tee -a "$LOG_FILE"
#	    rm -fv /opt/fake08/fake08.* | tee -a "$LOG_FILE"
#	elif [ -f "/boot/rk3566.dtb" ]; then
#	    cp -fv /opt/fake08/fake08.960 /opt/fake08/fake08 | tee -a "$LOG_FILE"
#	    rm -fv /opt/fake08/fake08.* | tee -a "$LOG_FILE"
#	elif [ "$(cat ~/.config/.OS)" = "ArkOS" ] && [ "$(cat ~/.config/.DEVICE)" = "RGB10MAX" ]; then
#	    cp -fv /opt/fake08/fake08.848 /opt/fake08/fake08 | tee -a "$LOG_FILE"
#	    rm -fv /opt/fake08/fake08.* | tee -a "$LOG_FILE"
#	else
#	    cp -fv /opt/fake08/fake08.480 /opt/fake08/fake08 | tee -a "$LOG_FILE"
#	    rm -fv /opt/fake08/fake08.* | tee -a "$LOG_FILE"
#	fi
	if [ -f "/boot/rk3566.dtb" ]; then
      mv -fv /opt/fake08/fake08.rk3566 /opt/fake08/fake08 | tee -a "$LOG_FILE"
      rm -fv /opt/fake08/fake08.rk3326 | tee -a "$LOG_FILE"
    else
      mv -fv /opt/fake08/fake08.rk3326 /opt/fake08/fake08 | tee -a "$LOG_FILE"
      rm -fv /opt/fake08/fake08.rk3566 | tee -a "$LOG_FILE"
	fi

	printf "\nEnable Threaded DSP for 3DO by default\n" | tee -a "$LOG_FILE"
	if test ! -z "$(cat /home/ark/.config/retroarch/retroarch-core-options.cfg | grep 'opera_dsp_threaded' | tr -d '\0')"
	then
	  sed -i '/opera_dsp_threaded \= "disabled"/c\opera_dsp_threaded \= "enabled"' /home/ark/.config/retroarch/retroarch-core-options.cfg
	  sed -i '/mgba_use_bios \= \"ON\"/c\mgba_use_bios \= \"ON\"\nopera_dsp_threaded \= "enabled"' /home/ark/.config/retroarch/retroarch-core-options.cfg.bak
	else
  	  sed -i '/mgba_use_bios \= \"ON\"/c\mgba_use_bios \= \"ON\"\nopera_dsp_threaded \= "enabled"' /home/ark/.config/retroarch/retroarch-core-options.cfg
  	  sed -i '/mgba_use_bios \= \"ON\"/c\mgba_use_bios \= \"ON\"\nopera_dsp_threaded \= "enabled"' /home/ark/.config/retroarch/retroarch-core-options.cfg.bak
	fi

	printf "\nCopy correct Retroarches depending on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  cp -fv /opt/retroarch/bin/retroarch32.rk3326.unrot /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
	  cp -fv /opt/retroarch/bin/retroarch.rk3326.unrot /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-odroidgo2-linux.dtb" ] || [ -f "/boot/rk3326-odroidgo2-linux-v11.dtb" ] || [ -f "/boot/rk3326-odroidgo3-linux.dtb" ]; then
	  cp -fv /opt/retroarch/bin/retroarch32.rk3326.rot /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
	  cp -fv /opt/retroarch/bin/retroarch.rk3326.rot /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	else
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	fi

	printf "\nCopy correct emulationstation depending on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  sudo mv -fv /usr/bin/emulationstation/emulationstation.351v /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo rm -fv /usr/bin/emulationstation/emulationstation.header | tee -a "$LOG_FILE"
	  sudo rm -fv /usr/bin/emulationstation/emulationstation.fullscreen | tee -a "$LOG_FILE"
	  sudo rm -fv /usr/bin/emulationstation/emulationstation.rgb10max | tee -a "$LOG_FILE"
	  sudo rm -fv /usr/bin/emulationstation/emulationstation.503 | tee -a "$LOG_FILE"
	  cd /usr/lib/aarch64-linux-gnu/
	  sudo ln -sf libMali.so libGLES_CM.so
	  ldconfig
	  cd /home/ark
	elif [ -f "/boot/rk3326-odroidgo2-linux.dtb" ] || [ -f "/boot/rk3326-odroidgo2-linux-v11.dtb" ]; then
	  sudo cp -fv /usr/bin/emulationstation/emulationstation.header /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo rm -fv /usr/bin/emulationstation/emulationstation.351v | tee -a "$LOG_FILE"
	  sudo rm -fv /usr/bin/emulationstation/emulationstation.rgb10max | tee -a "$LOG_FILE"
	  sudo rm -fv /usr/bin/emulationstation/emulationstation.503 | tee -a "$LOG_FILE"
	  cd /usr/lib/aarch64-linux-gnu/
	  sudo cp /usr/local/lib/aarch64-linux-gnu/libmali-bifrost-g31-rxp0-gbm.so /usr/lib/aarch64-linux-gnu/.
	  sudo rm /usr/lib/aarch64-linux-gnu/libMali.so
	  sudo ln -sf libmali-bifrost-g31-rxp0-gbm.so libMali.so
	  sudo ln -sf libMali.so libGLES_CM.so
	  ldconfig
	  cd /home/ark
	elif [ -f "/boot/rk3326-odroidgo3-linux.dtb" ]; then
	  sudo cp -fv /usr/bin/emulationstation/emulationstation.header /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo mv -fv /usr/bin/emulationstation/emulationstation.rgb10max /usr/bin/emulationstation/emulationstation.fullscreen | tee -a "$LOG_FILE"
	  sudo rm -fv /usr/bin/emulationstation/emulationstation.351v | tee -a "$LOG_FILE"
	  sudo rm -fv /usr/bin/emulationstation/emulationstation.503 | tee -a "$LOG_FILE"
	  cd /usr/lib/aarch64-linux-gnu/
	  sudo ln -sf libMali.so libGLES_CM.so
	  ldconfig
	  cd /home/ark
	elif [ -f "/boot/rk3566.dtb" ]; then
	  sudo mv -fv /usr/bin/emulationstation/emulationstation.503 /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo rm -fv /usr/bin/emulationstation/emulationstation.header | tee -a "$LOG_FILE"
	  sudo rm -fv /usr/bin/emulationstation/emulationstation.fullscreen | tee -a "$LOG_FILE"
	  sudo rm -fv /usr/bin/emulationstation/emulationstation.rgb10max | tee -a "$LOG_FILE"
	  sudo rm -fv /usr/bin/emulationstation/emulationstation.351v | tee -a "$LOG_FILE"
	fi

	printf "\nMake sure retroarch core repos are still set to Github if it's been changed and make sure their set to the correct repo\n" | tee -a "$LOG_FILE"
    if [ -f "/boot/rk3566.dtb" ]; then
      sed -i "/core_updater_buildbot_cores_url \=/c\core_updater_buildbot_cores_url \= \"https:\/\/raw.githubusercontent.com\/christianhaitian\/retroarch-cores\/rg503\/aarch64\/\"" ~/.config/retroarch/retroarch.cfg
      sed -i "/core_updater_buildbot_cores_url \=/c\core_updater_buildbot_cores_url \= \"https:\/\/raw.githubusercontent.com\/christianhaitian\/retroarch-cores\/rg503\/arm7hf\/\"" ~/.config/retroarch32/retroarch.cfg
      sed -i "/core_updater_buildbot_cores_url \=/c\core_updater_buildbot_cores_url \= \"https:\/\/raw.githubusercontent.com\/christianhaitian\/retroarch-cores\/rg503\/aarch64\/\"" ~/.config/retroarch/retroarch.cfg.bak
      sed -i "/core_updater_buildbot_cores_url \=/c\core_updater_buildbot_cores_url \= \"https:\/\/raw.githubusercontent.com\/christianhaitian\/retroarch-cores\/rg503\/arm7hf\/\"" ~/.config/retroarch32/retroarch.cfg.bak
      echo "Retroarch core repos have been changed to github"
    else
      sed -i "/core_updater_buildbot_cores_url \=/c\core_updater_buildbot_cores_url \= \"https:\/\/raw.githubusercontent.com\/christianhaitian\/retroarch-cores\/master\/aarch64\/\"" ~/.config/retroarch/retroarch.cfg
      sed -i "/core_updater_buildbot_cores_url \=/c\core_updater_buildbot_cores_url \= \"https:\/\/raw.githubusercontent.com\/christianhaitian\/retroarch-cores\/master\/arm7hf\/\"" ~/.config/retroarch32/retroarch.cfg
      sed -i "/core_updater_buildbot_cores_url \=/c\core_updater_buildbot_cores_url \= \"https:\/\/raw.githubusercontent.com\/christianhaitian\/retroarch-cores\/master\/aarch64\/\"" ~/.config/retroarch/retroarch.cfg.bak
      sed -i "/core_updater_buildbot_cores_url \=/c\core_updater_buildbot_cores_url \= \"https:\/\/raw.githubusercontent.com\/christianhaitian\/retroarch-cores\/master\/arm7hf\/\"" ~/.config/retroarch32/retroarch.cfg.bak
      echo "Retroarch core repos have been changed to github"
    fi

	printf "\nCopy updated kernel based on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ]; then
	  if [ -f "/home/ark/.config/.DEVICE" ]; then
	    if test ! -z "$(grep "RG353V" /home/ark/.config/.DEVICE | tr -d '\0')"
	    then
	      sudo mv -fv /boot/Image.353 /boot/Image | tee -a "$LOG_FILE"
		  sudo rm -fv /boot/Image.503 | tee -a "$LOG_FILE"
	    else
	      sudo mv -fv /boot/Image.503 /boot/Image | tee -a "$LOG_FILE"
		  sudo rm -fv /boot/Image.353 | tee -a "$LOG_FILE"
	    fi
	  else
	    sudo mv -fv /boot/Image.503 /boot/Image | tee -a "$LOG_FILE"
		sudo rm -fv /boot/Image.353 | tee -a "$LOG_FILE"
		echo "RG503" > /home/ark/.config/.DEVICE
	  fi
	else
	  sudo rm -fv /boot/Image.503 | tee -a "$LOG_FILE"
	  sudo rm -fv /boot/Image.353 | tee -a "$LOG_FILE"
	fi

	printf "\nAdd Workaround for headphone jack sense on boot\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ]; then
	  if test -z "$(sudo crontab -l | grep 'hpwatchdaemon.sh' | tr -d '\0')"
	  then
		sudo crontab -l > temp.cron
		echo "@reboot /usr/local/bin/hpwatchdaemon.sh &" >> temp.cron
		sudo crontab temp.cron
		sudo rm -v temp.cron | tee -a "$LOG_FILE"
		sudo crontab -l | grep 'hpwatchdaemon.sh' | tr -d '\0' | tee -a "$LOG_FILE"
	  else
	    printf "  No need to add this workaround as it already exists.\n" | tee -a "$LOG_FILE"
	  fi
	else
	  printf "  This is not a device that needs this workaround\n" | tee -a "$LOG_FILE"
	  sudo rm -v /usr/local/bin/hpwatchdaemon.sh  | tee -a "$LOG_FILE"
	fi

	printf "\nClean up some old unneeded files in the system\n" | tee -a "$LOG_FILE"
	sudo rm -rfv /var/cache/* | tee -a "$LOG_FILE"
	sudo rm -rfv /var/backups/* | tee -a "$LOG_FILE"
	sudo journalctl --vacuum-time=1s

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update10292022"

fi

if [ ! -f "/home/ark/.config/.update11062022" ]; then

	printf "\nFix Retroarch Ozone menu crashing when called during game session\n" | tee -a "$LOG_FILE"
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/11062022/arkosupdate11062022.zip -O /home/ark/arkosupdate11062022.zip -a "$LOG_FILE" || rm -f /home/ark/arkosupdate11062022.zip | tee -a "$LOG_FILE"
	if [ -f "/home/ark/arkosupdate11062022.zip" ]; then
		sudo unzip -X -o /home/ark/arkosupdate11062022.zip -d / | tee -a "$LOG_FILE"
		cp -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update11062022.bak | tee -a "$LOG_FILE"
		if test -z "$(cat /etc/emulationstation/es_systems.cfg | grep -A4 "fake08" | tr -d '\0' | grep "retroarch" | tr -d '\0')"
		then
		  sed -i '/%CORE%; sudo systemctl start pico8hotkey/s//%ROM%; sudo systemctl start pico8hotkey/' /etc/emulationstation/es_systems.cfg
		  sed -i '/<emulator name="fake08">/c\              <emulator name="fake08">\n              <\/emulator>\n              <emulator name="retroarch">' /etc/emulationstation/es_systems.cfg
		fi
		if test -z "$(grep 'carts' /usr/local/bin/perfmax | tr -d '\0')"
		then
		  sudo sed -i '/\[\[ \$1 == "standalone-GlideN64" \]\]/s//\[\[ \$1 == "standalone-GlideN64" \]\] || \[\[ \$2 == *"carts"* \]\]/' /usr/local/bin/perfmax
  		  sudo sed -i '/\[\[ \$1 == "standalone-GlideN64" \]\]/s//\[\[ \$1 == "standalone-GlideN64" \]\] || \[\[ \$2 == *"carts"* \]\]/' /usr/local/bin/perfmax.pic
  		  sudo sed -i '/\[\[ \$1 == "standalone-GlideN64" \]\]/s//\[\[ \$1 == "standalone-GlideN64" \]\] || \[\[ \$2 == *"carts"* \]\]/' /usr/local/bin/perfmax.asc
		fi
		sudo rm -v /home/ark/arkosupdate11062022.zip | tee -a "$LOG_FILE"
	else 
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCopy correct libretro fake-08 core depending on device\n" | tee -a "$LOG_FILE"
	if [ ! -f "/boot/rk3566.dtb" ]; then
	  mv -fv /home/ark/.config/retroarch/cores/fake08_libretro.so.rk3326 /home/ark/.config/retroarch/cores/fake08_libretro.so | tee -a "$LOG_FILE"
	else
	  rm -fv /home/ark/.config/retroarch/cores/fake08_libretro.so.rk3326 | tee -a "$LOG_FILE"
	fi

	printf "\nCopy correct Retroarches depending on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  cp -fv /opt/retroarch/bin/retroarch32.rk3326.unrot /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
	  cp -fv /opt/retroarch/bin/retroarch.rk3326.unrot /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-odroidgo2-linux.dtb" ] || [ -f "/boot/rk3326-odroidgo2-linux-v11.dtb" ] || [ -f "/boot/rk3326-odroidgo3-linux.dtb" ]; then
	  cp -fv /opt/retroarch/bin/retroarch32.rk3326.rot /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
	  cp -fv /opt/retroarch/bin/retroarch.rk3326.rot /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	else
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update11062022"

fi

if [ ! -f "/home/ark/.config/.update11182022" ]; then

	printf "\nAdd Amstrad GX4000\nUpdate retroarch-tate script\nUpdate pico8.sh script\nUpdate N64 launch script\nUpdate PS1 M3U Generator script\nDefault external controller as Player 1\n" | tee -a "$LOG_FILE"
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/11182022/arkosupdate11182022.zip -O /home/ark/arkosupdate11182022.zip -a "$LOG_FILE" || rm -f /home/ark/arkosupdate11182022.zip | tee -a "$LOG_FILE"
	if [ -f "/home/ark/arkosupdate11182022.zip" ]; then
		sudo unzip -X -o /home/ark/arkosupdate11182022.zip -d / | tee -a "$LOG_FILE"
		if test -z "$(cat /etc/emulationstation/es_systems.cfg | grep GX4000)"
		then
		  sed -i -e '/<theme>amstradcpc<\/theme>/{r /home/ark/add_gx4000.txt' -e 'd}' /etc/emulationstation/es_systems.cfg
		fi
		if test -z "$(grep 'cap32' /usr/local/bin/perfmax | tr -d '\0')"
		then
		  sudo sed -i '/\[\[ \$1 == "standalone-Glide64mk2" \]\]/s//\[\[ \$1 == "standalone-Glide64mk2" \]\] || \[\[ \$1 == "standalone-GlideN64" \]\] || \[\[ \$2 == "cap32" \]\]/' /usr/local/bin/perfmax
  		  sudo sed -i '/\[\[ \$1 == "standalone-Glide64mk2" \]\]/s//\[\[ \$1 == "standalone-Glide64mk2" \]\] || \[\[ \$1 == "standalone-GlideN64" \]\] || \[\[ \$2 == "cap32" \]\]/' /usr/local/bin/perfmax.pic
  		  sudo sed -i '/\[\[ \$1 == "standalone-Glide64mk2" \]\]/s//\[\[ \$1 == "standalone-Glide64mk2" \]\] || \[\[ \$1 == "standalone-GlideN64" \]\] || \[\[ \$2 == "cap32" \]\]/' /usr/local/bin/perfmax.asc
		fi
		if [ ! -d "/roms/gx4000" ]; then
		  mkdir -v /roms/gx4000 | tee -a "$LOG_FILE"
		fi
		if test ! -z "$(cat /etc/fstab | grep roms2 | tr -d '\0')"
		then
		  if [ ! -d "/roms2/gx4000" ]; then
		    mkdir -v /roms2/gx4000 | tee -a "$LOG_FILE"
		    sed -i '/<path>\/roms\/gx4000/s//<path>\/roms2\/gx4000/g' /etc/emulationstation/es_systems.cfg
		  fi
		fi
		if [ -f "/opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh" ]; then
		  if test -z "$(cat /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh | grep gx4000 | tr -d '\0')"
		  then
		    sudo chown -v ark:ark /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh | tee -a "$LOG_FILE"
		    sed -i '/sudo pkill filebrowser/s//if [ \! -d "\/roms2\/gx4000\/" ]\; then\n      sudo mkdir \/roms2\/gx4000\n  fi\n  sudo pkill filebrowser/' /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh
		  else
		    printf "\nAmstrad GX4000 is already being accounted for in the switch to sd2 script\n" | tee -a "$LOG_FILE"
		  fi
		fi
		if [ -f "/usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh" ]; then
		  if test -z "$(cat /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh | grep gx4000 | tr -d '\0')"
		  then
		    sudo sed -i '/sudo pkill filebrowser/s//if [ \! -d "\/roms2\/gx4000\/" ]\; then\n      sudo mkdir \/roms2\/gx4000\n  fi\n  sudo pkill filebrowser/' /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh
		  else
		    printf "\nAmstrad GX4000 is already being accounted for in the switch to sd2 script\n" | tee -a "$LOG_FILE"
		  fi
		fi
		if [ ! -f "/boot/rk3566.dtb" ] && [ ! -f "/boot/rk3566-OC.dtb" ]; then
		  sudo rm -fv /home/ark/.config/retroarch/retroarch.cfg.ext | tee -a "$LOG_FILE"
		  sudo rm -fv /home/ark/.config/retroarch32/retroarch.cfg.ext | tee -a "$LOG_FILE"
		fi
		sudo rm -v /home/ark/add_gx4000.txt | tee -a "$LOG_FILE"
		sudo rm -v /home/ark/arkosupdate11182022.zip | tee -a "$LOG_FILE"
	else 
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCopy correct cap32_libretro core for device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ]; then
      mv -fv /home/ark/cap32_libretro.so.rk3566 /home/ark/.config/retroarch/cores/cap32_libretro.so | tee -a "$LOG_FILE"
      rm -fv /home/ark/cap32_libretro.so.rk3326 | tee -a "$LOG_FILE"
    else
      mv -fv /home/ark/cap32_libretro.so.rk3326 /home/ark/.config/retroarch/cores/cap32_libretro.so | tee -a "$LOG_FILE"
      rm -fv /home/ark/cap32_libretro.so.rk3566 | tee -a "$LOG_FILE"
	fi

	printf "\nEnable N64DD by default in retroarch-core options file\n" | tee -a "$LOG_FILE"
	sed -i '/parallel-n64-64dd-hardware \= "disabled"/c\parallel-n64-64dd-hardware \= "enabled"' /home/ark/.config/retroarch/retroarch-core-options.cfg
	sed -i '/parallel-n64-64dd-hardware \= "disabled"/c\parallel-n64-64dd-hardware \= "enabled"' /home/ark/.config/retroarch32/retroarch-core-options.cfg
	sed -i '/parallel-n64-64dd-hardware \= "disabled"/c\parallel-n64-64dd-hardware \= "enabled"' /home/ark/.config/retroarch/retroarch-core-options.cfg.bak
	sed -i '/parallel-n64-64dd-hardware \= "disabled"/c\parallel-n64-64dd-hardware \= "enabled"' /home/ark/.config/retroarch32/retroarch-core-options.cfg.bak

	printf "\nFix mupen64plus rice standalone emulator resolution\n"
	if [ "$(cat ~/.config/.DEVICE)" = "RG353V" ] || [ "$(cat ~/.config/.DEVICE)" = "RG353M" ] || [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  sed -i '/ResolutionWidth \= /c\ResolutionWidth \= "640"' /home/ark/.config/mupen64plus/mupen64plus.cfg
	else
	  printf "  This doesn't seem to be a 640x480 resolution unit.  This change is not needed." | tee -a "$LOG_FILE"
	fi

	printf "\nAdd symlink for librga.so.2 arm32bit environment\n" | tee -a "$LOG_FILE"
	if [ ! -f "/usr/lib/arm-linux-gnueabihf/librga.so.2" ]; then
	  cd /usr/lib/arm-linux-gnueabihf/
	  sudo ln -sf librga.so librga.so.2
	  cd /home/ark
	else
	  printf "  librga.so.2 already exists in /usr/lib/arm-linux-gnueabihf/" | tee -a "$LOG_FILE"
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update11182022"

fi

if [ ! -f "/home/ark/.config/.update12012022" ]; then

	printf "\nUpdated retroarch and retroarch32 to 1.13.0\nFix controls not working in retroarches with bt audio connected\nDisable OC for 353m and 353v units\n" | tee -a "$LOG_FILE"
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/12012022/arkosupdate12012022.zip -O /home/ark/arkosupdate12012022.zip -a "$LOG_FILE" || rm -f /home/ark/arkosupdate12012022.zip | tee -a "$LOG_FILE"
	if [ -f "/home/ark/arkosupdate12012022.zip" ]; then
		if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
		  sudo unzip -X -o /home/ark/arkosupdate12012022.zip -d / | tee -a "$LOG_FILE"
		else
		  sudo unzip -X -o /home/ark/arkosupdate12012022.zip -x usr/local/bin/retroarch* home/ark/rk3566* /opt/system/Wifi.sh -d / | tee -a "$LOG_FILE"
		fi
		if [ "$(cat ~/.config/.DEVICE)" = "RG353M" ]; then
		  sudo cp -fv /home/ark/rk3566-353m-notimingchange.dtb /boot/rk3566-OC.dtb.orig | tee -a "$LOG_FILE"
		  sudo cp -fv /home/ark/rk3566-353m.dtb /boot/rk3566-OC.dtb.tony | tee -a "$LOG_FILE"
		  if [ -f "/opt/system/Advanced/Screen - Switch to Original Screen Timings.sh" ]; then
		    sudo cp -fv /boot/rk3566-OC.dtb.tony /boot/rk3566-OC.dtb | tee -a "$LOG_FILE"
		  else 
		    sudo cp -fv /boot/rk3566-OC.dtb.orig /boot/rk3566-OC.dtb | tee -a "$LOG_FILE"
		  fi
		  sudo rm -fv /home/ark/rk3566-* | tee -a "$LOG_FILE"
		elif [ "$(cat ~/.config/.DEVICE)" = "RG353V" ]; then
		  sudo cp -fv /home/ark/rk3566-353v-notimingchange.dtb /boot/rk3566-OC.dtb.orig | tee -a "$LOG_FILE"
		  sudo cp -fv /home/ark/rk3566-353v.dtb /boot/rk3566-OC.dtb.tony | tee -a "$LOG_FILE"
		  if [ -f "/opt/system/Advanced/Screen - Switch to Original Screen Timings.sh" ]; then
		    sudo cp -fv /boot/rk3566-OC.dtb.tony /boot/rk3566-OC.dtb | tee -a "$LOG_FILE"
		  else 
		    sudo cp -fv /boot/rk3566-OC.dtb.orig /boot/rk3566-OC.dtb | tee -a "$LOG_FILE"
		  fi
		  sudo rm -fv /home/ark/rk3566-* | tee -a "$LOG_FILE"
		else
		  echo "  This is not a rg353m or rg353v unit so no need to update the dtb on this unit." | tee -a "$LOG_FILE"
		  sudo rm -fv /home/ark/rk3566-* | tee -a "$LOG_FILE"
		fi
		sudo rm -v /home/ark/arkosupdate12012022.zip | tee -a "$LOG_FILE"
	else 
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCopy correct Retroarches depending on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  cp -fv /opt/retroarch/bin/retroarch32.rk3326.unrot /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
	  cp -fv /opt/retroarch/bin/retroarch.rk3326.unrot /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-odroidgo2-linux.dtb" ] || [ -f "/boot/rk3326-odroidgo2-linux-v11.dtb" ] || [ -f "/boot/rk3326-odroidgo3-linux.dtb" ]; then
	  cp -fv /opt/retroarch/bin/retroarch32.rk3326.rot /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
	  cp -fv /opt/retroarch/bin/retroarch.rk3326.rot /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	else
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	fi

	printf "\nAdjust root partition check interval and enable roms partition checking on boot\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  sudo tune2fs -c 15 -i 1w -l /dev/mmcblk1p4 | egrep -i 'mount count|check' | tr -d '\0' | tee -a "$LOG_FILE"
	  sudo sed -i '/\/dev\/mmcblk1p5 \/roms exfat defaults,auto,umask\=000,uid\=1002,gid\=1002,noatime 0 0/s//\/dev\/mmcblk1p5 \/roms exfat defaults,auto,umask\=000,uid\=1002,gid\=1002,noatime 0 2/' /etc/fstab
	else
	  echo "  This doesn't seem to be a rk3566 device so root partition check interval will not be adjusted" | tee -a "$LOG_FILE"
	fi

	printf "\nCopy correct Gliden64 and glide64mk2 plugins for the chipset\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  cp -fv /opt/mupen64plus/mupen64plus-video-GLideN64.so.rk3326 /opt/mupen64plus/mupen64plus-video-GLideN64.so | tee -a "$LOG_FILE"
	  cp -fv /opt/mupen64plus/mupen64plus-video-glide64mk2.so.rk3326 /opt/mupen64plus/mupen64plus-video-glide64mk2.so | tee -a "$LOG_FILE"
	  rm -fv /opt/mupen64plus/mupen64plus-video-GLideN64.so.rk3326 | tee -a "$LOG_FILE"
	  rm -fv /opt/mupen64plus/mupen64plus-video-glide64mk2.so.rk3326 | tee -a "$LOG_FILE"
	else
	  rm -fv /opt/mupen64plus/mupen64plus-video-GLideN64.so.rk3326 | tee -a "$LOG_FILE"
	  rm -fv /opt/mupen64plus/mupen64plus-video-glide64mk2.so.rk3326 | tee -a "$LOG_FILE"
	  echo "  Correct Gliden64 and glide64mk2 plugins are already in place for this rk3566 device" | tee -a "$LOG_FILE"
	fi

	printf "\nAdjust some GlideN64 plugin settings\n" | tee -a "$LOG_FILE"
	sed -i "/EnableHWLighting \=/c\EnableHWLighting \= 0" /home/ark/.config/mupen64plus/mupen64plus.cfg
	sed -i "/UseNativeResolutionFactor \=/c\UseNativeResolutionFactor \= 1" /home/ark/.config/mupen64plus/mupen64plus.cfg
	sed -i "/ThreadedVideo \=/c\ThreadedVideo \= 1" /home/ark/.config/mupen64plus/mupen64plus.cfg
	sed -i "/bilinearMode \=/c\bilinearMode \= 1" /home/ark/.config/mupen64plus/mupen64plus.cfg
	
	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update12012022"

fi

if [ ! -f "/home/ark/.config/.update12022022" ]; then

	printf "\nRemove easyroms partition check on tf1 with everyboot\nVerify GlideN64 plugin settings\n" | tee -a "$LOG_FILE"

	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  sudo sed -i '/\/dev\/mmcblk1p5 \/roms exfat defaults,auto,umask\=000,uid\=1002,gid\=1002,noatime 0 0/s//\/dev\/mmcblk1p5 \/roms exfat defaults,auto,umask\=000,uid\=1002,gid\=1002,noatime 0 0/' /etc/fstab
	else
	  echo "  This doesn't seem to be a rk3566 device so root partition check interval will not be adjusted" | tee -a "$LOG_FILE"
	fi

	sudo chown -Rv ark:ark /home/ark/.config/mupen64plus/ | tee -a "$LOG_FILE"
	sed -i "/EnableHWLighting \=/c\EnableHWLighting \= 0" /home/ark/.config/mupen64plus/mupen64plus.cfg
	sed -i "/UseNativeResolutionFactor \=/c\UseNativeResolutionFactor \= 1" /home/ark/.config/mupen64plus/mupen64plus.cfg
	sed -i "/ThreadedVideo \=/c\ThreadedVideo \= 1" /home/ark/.config/mupen64plus/mupen64plus.cfg
	sed -i "/bilinearMode \=/c\bilinearMode \= 1" /home/ark/.config/mupen64plus/mupen64plus.cfg
	if test -z "$(cat /home/ark/.config/mupen64plus/mupen64plus.cfg | grep ThreadedVideo | tr -d '\0')"
	then
	  sed -i "/\[Video-GLideN64\]/c\\[Video-GLideN64\]\nThreadedVideo \= 1" /home/ark/.config/mupen64plus/mupen64plus.cfg
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update12022022"

fi

if [ ! -f "/home/ark/.config/.update12032022" ]; then

	printf "\nFix Wifi Menu\nFix Glide64mk2 and glideN64 plugins for mupen64plus standalone\n" | tee -a "$LOG_FILE"
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/12032022/arkosupdate12032022.zip -O /home/ark/arkosupdate12032022.zip -a "$LOG_FILE" || rm -f /home/ark/arkosupdate12032022.zip | tee -a "$LOG_FILE"
	if [ -f "/home/ark/arkosupdate12032022.zip" ]; then
		sudo unzip -X -o /home/ark/arkosupdate12032022.zip -d / | tee -a "$LOG_FILE"
		if [ -e "/dev/input/by-path/platform-ff300000.usb-usb-0:1.2:1.0-event-joystick" ]; then
		  cp -fv /opt/system/Wifi.sh.351v /opt/system/Wifi.sh | tee -a "$LOG_FILE"
		  rm -fv /opt/system/Wifi.sh.* | tee -a "$LOG_FILE"
		elif [ -e "/dev/input/by-path/platform-gameforce-gamepad-event-joystick" ]; then
		  cp -fv /opt/system/Wifi.sh.chi /opt/system/Wifi.sh | tee -a "$LOG_FILE"
		  rm -fv /opt/system/Wifi.sh.* | tee -a "$LOG_FILE"
		else
		  rm -fv /opt/system/Wifi.sh.* | tee -a "$LOG_FILE"
		fi
		cd /usr/lib/aarch64-linux-gnu/
		sudo ln -sfv libmali.so libmali.so.1 | tee -a "$LOG_FILE"
		cd /home/ark
		sudo rm -v /home/ark/arkosupdate12032022.zip | tee -a "$LOG_FILE"
	else 
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nAdjust some GlideN64 plugin settings\n" | tee -a "$LOG_FILE"
	sudo chown -Rv ark:ark /home/ark/.config/mupen64plus/ | tee -a "$LOG_FILE"
	sed -i "/EnableHWLighting \=/c\EnableHWLighting \= 0" /home/ark/.config/mupen64plus/mupen64plus.cfg
	sed -i "/UseNativeResolutionFactor \=/c\UseNativeResolutionFactor \= 1" /home/ark/.config/mupen64plus/mupen64plus.cfg
	sed -i "/ThreadedVideo \=/c\ThreadedVideo \= 1" /home/ark/.config/mupen64plus/mupen64plus.cfg
	sed -i "/bilinearMode \=/c\bilinearMode \= 1" /home/ark/.config/mupen64plus/mupen64plus.cfg
	if test -z "$(cat /home/ark/.config/mupen64plus/mupen64plus.cfg | grep ThreadedVideo | tr -d '\0')"
	then
	  sed -i "/\[Video-GLideN64\]/c\\[Video-GLideN64\]\nThreadedVideo \= 1" /home/ark/.config/mupen64plus/mupen64plus.cfg
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update12032022"

fi

if [ ! -f "/home/ark/.config/.update12182022" ]; then

	printf "\nAdd vic20 as separate system\nAdd vic20 rom folder\nUpdate retroarch.cfg.vert\nUpdate pico8.sh script for png to p8 conversion for libretro\nUpdate ppsspp to version 1.14\nUpdate Retroarch to 1.14\n" | tee -a "$LOG_FILE"
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/12182022/arkosupdate12182022.zip -O /home/ark/arkosupdate12182022.zip -a "$LOG_FILE" || rm -f /home/ark/arkosupdate12182022.zip | tee -a "$LOG_FILE"
	if [ -f "/home/ark/arkosupdate12182022.zip" ]; then
		if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
		  sudo unzip -X -o /home/ark/arkosupdate12182022.zip -d / | tee -a "$LOG_FILE"
		else
		  sudo unzip -X -o /home/ark/arkosupdate12182022.zip -x home/ark/.config/retroarch/retroarch.cfg.vert -d / | tee -a "$LOG_FILE"
		fi
		cp -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update12182022.bak | tee -a "$LOG_FILE"
		if test -z "$(cat /etc/emulationstation/es_systems.cfg | grep vic20)"
		then
		  sed -i -e '/<theme>c128<\/theme>/{r /home/ark/add_vic20.txt' -e 'd}' /etc/emulationstation/es_systems.cfg
		fi
		if [ ! -d "/roms/vic20" ]; then
		  mkdir -v /roms/vic20 | tee -a "$LOG_FILE"
		  if test ! -z "$(cat /etc/fstab | grep roms2 | tr -d '\0')"
		  then
		    if [ ! -d "/roms2/vic20" ]; then
		      mkdir -v /roms2/vic20 | tee -a "$LOG_FILE"
			fi
		    sed -i '/<path>\/roms\/vic20/s//<path>\/roms2\/vic20/g' /etc/emulationstation/es_systems.cfg
		  fi
		fi
		if [ -f "/opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh" ]; then
		  if test -z "$(cat /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh | grep vic20 | tr -d '\0')"
		  then
		    sed -i '/sudo pkill filebrowser/s//if [ \! -d "\/roms2\/vic20\/" ]\; then\n      sudo mkdir \/roms2\/vic20\n  fi\n  sudo pkill filebrowser/' /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh
		  else
		    printf "\nVic20 is already being accounted for in the switch to sd2 script\n" | tee -a "$LOG_FILE"
		  fi
		fi
		if [ -f "/usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh" ]; then
		  if test -z "$(cat /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh | grep vic20 | tr -d '\0')"
		  then
		    sudo sed -i '/sudo pkill filebrowser/s//if [ \! -d "\/roms2\/vic20\/" ]\; then\n      sudo mkdir \/roms2\/vic20\n  fi\n  sudo pkill filebrowser/' /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh
		  else
		    printf "\nVic20 is already being accounted for in the switch to sd2 script\n" | tee -a "$LOG_FILE"
		  fi
		fi
		sudo rm -v /home/ark/add_vic20.txt | tee -a "$LOG_FILE"
		sudo rm -v /home/ark/arkosupdate12182022.zip | tee -a "$LOG_FILE"
	else 
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  printf "\nUpdate exfat kernel module\n" | tee -a "$LOG_FILE"
	  sudo install -m644 -b -D -v /home/ark/exfat.ko /lib/modules/4.19.172/kernel/fs/exfat/exfat.ko | tee -a "$LOG_FILE"
	  sudo depmod -a
	fi
	sudo rm -fv /home/ark/exfat.ko | tee -a "$LOG_FILE"

	printf "\nCopy correct Retroarches depending on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  cp -fv /opt/retroarch/bin/retroarch32.rk3326.unrot /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
	  cp -fv /opt/retroarch/bin/retroarch.rk3326.unrot /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-odroidgo2-linux.dtb" ] || [ -f "/boot/rk3326-odroidgo2-linux-v11.dtb" ] || [ -f "/boot/rk3326-odroidgo3-linux.dtb" ]; then
	  cp -fv /opt/retroarch/bin/retroarch32.rk3326.rot /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
	  cp -fv /opt/retroarch/bin/retroarch.rk3326.rot /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	else
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	fi

	printf "\nCopy correct PPSSPPSDL for device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ]; then
      rm -fv /opt/ppsspp/PPSSPPSDL.rk3326 | tee -a "$LOG_FILE"
    else
      mv -fv /opt/ppsspp/PPSSPPSDL.rk3326 /opt/ppsspp/PPSSPPSDL | tee -a "$LOG_FILE"
	fi

	#printf "\nDecrease default audio latency retroarch and retroarch32 to 0ms\n" | tee -a "$LOG_FILE"
	#sed -i '/audio_latency \= \"128\"/c\audio_latency \= \"0\"' /home/ark/.config/retroarch32/retroarch.cfg
	#sed -i '/audio_latency \= \"128\"/c\audio_latency \= \"0\"' /home/ark/.config/retroarch/retroarch.cfg
	#sed -i '/audio_latency \= \"128\"/c\audio_latency \= \"0\"' /home/ark/.config/retroarch32/retroarch.cfg.bak
	#sed -i '/audio_latency \= \"128\"/c\audio_latency \= \"0\"' /home/ark/.config/retroarch/retroarch.cfg.bak

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update12182022"

fi

if [ ! -f "/home/ark/.config/.update12232022" ]; then

	printf "\nAdd workaround for auto reconnecting connected bluetooth devices\nDisable Message Of The Day service for ssh logins\nFix EasyRPG scan script\nUpdate dtb for 353m and 353v for analog range fix\nUpdated PPSSPP standalone to 1.14.1\n" | tee -a "$LOG_FILE"
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/12232022/arkosupdate12232022.zip -O /home/ark/arkosupdate12232022.zip -a "$LOG_FILE" || rm -f /home/ark/arkosupdate12232022.zip | tee -a "$LOG_FILE"
	if [ -f "/home/ark/arkosupdate12232022.zip" ]; then
		if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
		  sudo unzip -X -o /home/ark/arkosupdate12232022.zip -d / | tee -a "$LOG_FILE"
		else
		  sudo unzip -X -o /home/ark/arkosupdate12232022.zip -x usr/local/bin/btconnected.sh usr/lib/systemd/system-sleep/sleep -d / | tee -a "$LOG_FILE"
		fi
		sudo chmod -x /etc/update-motd.d/50-motd-news
		if [ "$(cat ~/.config/.DEVICE)" = "RG353M" ]; then
		  sudo cp -fv /home/ark/rk3566-353m-notimingchange.dtb /boot/rk3566-OC.dtb.orig | tee -a "$LOG_FILE"
		  sudo cp -fv /home/ark/rk3566-353m.dtb /boot/rk3566-OC.dtb.tony | tee -a "$LOG_FILE"
		  if [ -f "/opt/system/Advanced/Screen - Switch to Original Screen Timings.sh" ]; then
		    sudo cp -fv /boot/rk3566-OC.dtb.tony /boot/rk3566-OC.dtb | tee -a "$LOG_FILE"
		  else 
		    sudo cp -fv /boot/rk3566-OC.dtb.orig /boot/rk3566-OC.dtb | tee -a "$LOG_FILE"
		  fi
		  sudo rm -fv /home/ark/rk3566-* | tee -a "$LOG_FILE"
		elif [ "$(cat ~/.config/.DEVICE)" = "RG353V" ]; then
		  sudo cp -fv /home/ark/rk3566-353v-notimingchange.dtb /boot/rk3566-OC.dtb.orig | tee -a "$LOG_FILE"
		  sudo cp -fv /home/ark/rk3566-353v.dtb /boot/rk3566-OC.dtb.tony | tee -a "$LOG_FILE"
		  if [ -f "/opt/system/Advanced/Screen - Switch to Original Screen Timings.sh" ]; then
		    sudo cp -fv /boot/rk3566-OC.dtb.tony /boot/rk3566-OC.dtb | tee -a "$LOG_FILE"
		  else 
		    sudo cp -fv /boot/rk3566-OC.dtb.orig /boot/rk3566-OC.dtb | tee -a "$LOG_FILE"
		  fi
		  sudo rm -fv /home/ark/rk3566-* | tee -a "$LOG_FILE"
		else
		  echo "  This is not a rg353m or rg353v unit so no need to update the dtb on this unit." | tee -a "$LOG_FILE"
		  sudo rm -fv /home/ark/rk3566-* | tee -a "$LOG_FILE"
		fi
		sudo rm -v /home/ark/arkosupdate12232022.zip | tee -a "$LOG_FILE"
	else 
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCopy correct PPSSPPSDL for device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
      rm -fv /opt/ppsspp/PPSSPPSDL.rk3326 | tee -a "$LOG_FILE"
    else
      mv -fv /opt/ppsspp/PPSSPPSDL.rk3326 /opt/ppsspp/PPSSPPSDL | tee -a "$LOG_FILE"
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update12232022"

fi

if [ ! -f "/home/ark/.config/.update12272022" ]; then

	printf "\nUpdate ScummVM to 2.7.0 pre-release\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/12272022/arkosupdate12272022.zip -O /dev/shm/arkosupdate12272022.zip -a "$LOG_FILE" || rm -f /dev/shm/arkosupdate12272022.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate12272022.zip" ]; then
		sudo unzip -X -o /dev/shm/arkosupdate12272022.zip -d / | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate12272022.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate12272022.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update12272022"

fi

if [ ! -f "/home/ark/.config/.update01032023" ]; then

	printf "\nUpdate estuary Kodi skin UI element size for 640x480 devices\nIncrease font size for estuary Kodi skin\nFix no controls for Atari 800 and Atari XEGS\nAdd snd_aloop kernel module\nUpdate watchforbtaudio script\nUpdate PPSSPP to 1.14.3\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/01032023/arkosupdate01032023.zip -O /dev/shm/arkosupdate01032023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate01032023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate01032023.zip" ]; then
		if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
		  cp -v /opt/kodi/share/kodi/addons/skin.estuary/xml/Font.xml cp /opt/kodi/share/kodi/addons/skin.estuary/xml/Font.xml.update01032023.bak | tee -a "$LOG_FILE"
		  sudo unzip -X -o /dev/shm/arkosupdate01032023.zip -d / | tee -a "$LOG_FILE"
		  sudo depmod -a
		else
		  sudo unzip -X -o /dev/shm/arkosupdate01032023.zip -x opt/kodi/share/kodi/addons/skin.estuary/xml/Font.xml home/ark/.config/retroarch/config/Atari800/retroarch_* usr/local/bin/watchforbtaudio.sh home/ark/.asoundrcbt lib/modules/4.19.172/kernel/sound/drivers/snd-aloop.ko -d / | tee -a "$LOG_FILE"
		fi
		if [ "$(cat ~/.config/.DEVICE)" = "RG353M" ] || [ "$(cat ~/.config/.DEVICE)" = "RG353V" ]; then
		  sed -i '/<res width\="1920" height\="1440" aspect\="4:3"/s//<res width\="1623" height\="1180" aspect\="4:3"/g' /opt/kodi/share/kodi/addons/skin.estuary/addon.xml
		else
		  echo "  This is not a RG353M or RG353V/VS unit so no modification to the esturary skin ui element size will be done here." | tee -a "$LOG_FILE"
		fi
		sudo rm -fv /dev/shm/arkosupdate01032023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate01032023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCopy correct PPSSPPSDL for device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
      rm -fv /opt/ppsspp/PPSSPPSDL.rk3326 | tee -a "$LOG_FILE"
    else
      mv -fv /opt/ppsspp/PPSSPPSDL.rk3326 /opt/ppsspp/PPSSPPSDL | tee -a "$LOG_FILE"
	fi

	printf "\nChange default nekop2 and nekop2kai retroarch core joypad mappings\n" | tee -a "$LOG_FILE"
	if test -z "$(grep 'np2kai_joymode' /home/ark/.config/retroarch/retroarch-core-options.cfg | tr -d '\0')"
	then
	  sed -i -e '$anp2kai_joymode = "Keypad"' /home/ark/.config/retroarch/retroarch-core-options.cfg
	  sed -i -e '$anp2kai_joymode = "Keypad"' /home/ark/.config/retroarch/retroarch-core-options.cfg.bak
	else
	  sed -i '/np2kai_joymode \= "OFF"/c\np2kai_joymode = "Keypad"' /home/ark/.config/retroarch/retroarch-core-options.cfg
	  sed -i -e '$anp2kai_joymode = "Keypad"' /home/ark/.config/retroarch/retroarch-core-options.cfg.bak
	fi
	if test -z "$(grep 'np2_GUI_controller' /home/ark/.config/retroarch/retroarch-core-options.cfg | tr -d '\0')"
	then
	  sed -i -e '$anp2_GUI_controller = "JOY0"' /home/ark/.config/retroarch/retroarch-core-options.cfg
	  sed -i -e '$anp2_GUI_controller = "JOY0"' /home/ark/.config/retroarch/retroarch-core-options.cfg.bak
	else
	  sed -i '/np2_GUI_controller = "MOUSE"/c\np2_GUI_controller = "JOY0"' /home/ark/.config/retroarch/retroarch-core-options.cfg
	  sed -i -e '$anp2_GUI_controller = "JOY0"' /home/ark/.config/retroarch/retroarch-core-options.cfg.bak
	fi
	
	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update01032023"

fi

if [ ! -f "/home/ark/.config/.update01142023" ]; then

	printf "\nDefault pico-8 to look for 64 bit executable first\nUpdate PPSSPP to 1.14.4\nUpdate Hypseus-Singe to 2.10.1\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/01142023/arkosupdate01142023.zip -O /dev/shm/arkosupdate01142023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate01142023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate01142023.zip" ]; then
		if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
		  sudo unzip -X -o /dev/shm/arkosupdate01142023.zip -d / | tee -a "$LOG_FILE"
		else
		  sudo unzip -X -o /dev/shm/arkosupdate01142023.zip -x boot/uInitrd -d / | tee -a "$LOG_FILE"
		fi
		sudo rm -fv /dev/shm/arkosupdate01142023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate01142023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCopy correct PPSSPPSDL for device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
      rm -fv /opt/ppsspp/PPSSPPSDL.rk3326 | tee -a "$LOG_FILE"
    else
      mv -fv /opt/ppsspp/PPSSPPSDL.rk3326 /opt/ppsspp/PPSSPPSDL | tee -a "$LOG_FILE"
	fi

	printf "\nCopy correct Hypseus-Singe for device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
      rm -fv /opt/hypseus-singe/hypseus-singe.rk3326 | tee -a "$LOG_FILE"
    else
      mv -fv /opt/hypseus-singe/hypseus-singe.rk3326 /opt/hypseus-singe/hypseus-singe | tee -a "$LOG_FILE"
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update01142023"

fi

if [ ! -f "/home/ark/.config/.update01152023" ]; then

	printf "\nFix scraping for SFC\nAdd coolCV retroarch core\nUpdate OpenMSC Standalone emulator to 18.0\nBluetooth audio delay improvement\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/01152023/arkosupdate01152023.zip -O /dev/shm/arkosupdate01152023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate01152023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate01152023.zip" ]; then
		if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
		  sudo unzip -X -o /dev/shm/arkosupdate01152023.zip -d / | tee -a "$LOG_FILE"
		else
		  sudo unzip -X -o /dev/shm/arkosupdate01152023.zip -x home/ark/.asoundrcbt -d / | tee -a "$LOG_FILE"
		fi
		cp -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update01152023.bak | tee -a "$LOG_FILE"
		sed -i 's/<platform>sfc<\/platform>/<platform>snes<\/platform>/' /etc/emulationstation/es_systems.cfg
		sed -i -e '/bluemsx_libretro.so/{r /home/ark/add_coolcv.txt' -e 'd}' /etc/emulationstation/es_systems.cfg
		if [ -d "/roms/bios/openmsx" ]; then
		  cp -R -f -v /opt/openmsx/backupconfig/openmsx/share/ /roms/bios/openmsx/ | tee -a "$LOG_FILE"
		else
		  printf "No need to copy openmsx bios files as they don't exist in roms/bios for this unit yet.  Will be copied on initial load of openmsx standalone."  | tee -a "$LOG_FILE"
		fi
		if [ -f "/opt/system/Advanced/Switch to main SD for Roms.sh" ]; then
		  if [ -d "/roms2/bios/openmsx" ]; then
		    cp -R -f -v /opt/openmsx/backupconfig/openmsx/share/ /roms2/bios/openmsx/ | tee -a "$LOG_FILE"
		  else
		    printf "No need to copy openmsx bios files as they don't exist in roms2/bios on this unit yet.  Will be copied on initial load of openmsx standalone."  | tee -a "$LOG_FILE"
		  fi
		fi
		sudo rm -fv /home/ark/add_coolcv.txt | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate01152023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate01152023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nFix default screenshots to content directory setting for retroarch and retroarch32\n" | tee -a "$LOG_FILE"
	sed -i '/screenshots_in_content_dir \= "false"/c\screenshots_in_content_dir \= "true"' /home/ark/.config/retroarch32/retroarch.cfg
	sed -i '/screenshots_in_content_dir \= "false"/c\screenshots_in_content_dir \= "true"' /home/ark/.config/retroarch32/retroarch.cfg.bak
	sed -i '/screenshots_in_content_dir \= "false"/c\screenshots_in_content_dir \= "true"' /home/ark/.config/retroarch/retroarch.cfg
	sed -i '/screenshots_in_content_dir \= "false"/c\screenshots_in_content_dir \= "true"' /home/ark/.config/retroarch/retroarch.cfg.bak
	
	printf "\nCopy correct OPENMSX for device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
      rm -fv /opt/openmsx/openmsx.rk3326 | tee -a "$LOG_FILE"
    else
      mv -fv /opt/openmsx/openmsx.rk3326 /opt/openmsx/openmsx | tee -a "$LOG_FILE"
	fi

	printf "\nCopy correct latest PPSSPPSDL for device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
      rm -fv /opt/ppsspp/PPSSPPSDL.rk3326 | tee -a "$LOG_FILE"
    else
      mv -fv /opt/ppsspp/PPSSPPSDL.rk3326 /opt/ppsspp/PPSSPPSDL | tee -a "$LOG_FILE"
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update01152023"

fi

if [ ! -f "/home/ark/.config/.update01152023-1" ]; then

	printf "\nRevert openMSX back to 17.0\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/01152023-1/arkosupdate01152023-1.zip -O /dev/shm/arkosupdate01152023-1.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate01152023-1.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate01152023-1.zip" ]; then
	  sudo unzip -X -o /dev/shm/arkosupdate01152023-1.zip -d / | tee -a "$LOG_FILE"
	  if [ -d "/roms/bios/openmsx" ]; then
		cp -R -f -v /opt/openmsx/backupconfig/openmsx/share/ /roms/bios/openmsx/ | tee -a "$LOG_FILE"
	  else
		printf "No need to copy openmsx bios files as they don't exist in roms/bios for this unit yet.  Will be copied on initial load of openmsx standalone."  | tee -a "$LOG_FILE"
	  fi
	  if [ -f "/opt/system/Advanced/Switch to main SD for Roms.sh" ]; then
		if [ -d "/roms2/bios/openmsx" ]; then
		  cp -R -f -v /opt/openmsx/backupconfig/openmsx/share/ /roms2/bios/openmsx/ | tee -a "$LOG_FILE"
		else
		  printf "No need to copy openmsx bios files as they don't exist in roms2/bios on this unit yet.  Will be copied on initial load of openmsx standalone."  | tee -a "$LOG_FILE"
		fi
	  fi
	  sudo rm -fv /dev/shm/arkosupdate01152023-1.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate01152023-1.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update01152023-1"

fi

if [ ! -f "/home/ark/.config/.update01242023" ]; then

	printf "\nUpdate kernel to remove battery info log spamming\nUpdate controller_setup.sh for ps4 controller support\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/01242023/arkosupdate01242023.zip -O /dev/shm/arkosupdate01242023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate01242023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate01242023.zip" ]; then
		if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
		  sudo unzip -X -o /dev/shm/arkosupdate01242023.zip -d / | tee -a "$LOG_FILE"
		else
		  sudo unzip -X -o /dev/shm/arkosupdate01242023.zip -x home/ark/Image.353 usr/local/bin/controller_setup.sh usr/lib/systemd/system-sleep/sleep -d / | tee -a "$LOG_FILE"
		fi
		sudo rm -fv /dev/shm/arkosupdate01242023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate01242023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCopy updated kernel based on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  if [ -f "/home/ark/.config/.DEVICE" ]; then
	    if test ! -z "$(grep "RG353V" /home/ark/.config/.DEVICE | tr -d '\0')"
	    then
	      sudo mv -fv /home/ark/Image.353 /boot/Image | tee -a "$LOG_FILE"
	    elif test ! -z "$(grep "RG353M" /home/ark/.config/.DEVICE | tr -d '\0')"
		then
	      sudo mv -fv /home/ark/Image.353 /boot/Image | tee -a "$LOG_FILE"
		else 
		  sudo rm -fv /home/ark/Image.353 | tee -a "$LOG_FILE"
		fi
	  else
		sudo rm -fv /home/ark/Image.353 | tee -a "$LOG_FILE"
	  fi
	fi

	printf "\nUpdate sleep.conf to allow only freeze sleep for rk3566 devices\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  sudo sed -i "/#SuspendState\=/c\SuspendState\=freeze" /etc/systemd/sleep.conf
	else
	  echo " This is not a supported rk3566 device so sleep.conf will not be edited" | tee -a "$LOG_FILE"
	fi

	printf "\nDisable True drive emulation for C64 by default\n" | tee -a "$LOG_FILE"
	if test ! -z "$(cat /home/ark/.config/retroarch/retroarch-core-options.cfg | grep 'vice_drive_true_emulation' | tr -d '\0')"
	then
	  sed -i '/vice_drive_true_emulation \= "enabled"/c\vice_drive_true_emulation \= "disabled"' /home/ark/.config/retroarch/retroarch-core-options.cfg
	  echo 'vice_drive_true_emulation = "disabled"' >> /home/ark/.config/retroarch/retroarch-core-options.cfg.bak
	else
  	  echo 'vice_drive_true_emulation = "disabled"' >> /home/ark/.config/retroarch/retroarch-core-options.cfg
  	  echo 'vice_drive_true_emulation = "disabled"' >> /home/ark/.config/retroarch/retroarch-core-options.cfg.bak
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update01242023"

fi

if [ ! -f "/home/ark/.config/.update02092023" ]; then

	printf "\nAdd wifi importer tool\nUpdate filebrowser to version 2.23.0\nUpdate dtbs to support led on during sleep\nUpdate Hypseus-Singe to 2.10.2\nFix drastic, ppsspp, hypseus-singe, ecwolf and 351Files hdmi output\nUpdate retroarch with drm connection patch\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/02092023/arkosupdate02092023.zip -O /dev/shm/arkosupdate02092023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate02092023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate02092023.zip" ]; then
		if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	      sudo unzip -X -o /dev/shm/arkosupdate02092023.zip -d / | tee -a "$LOG_FILE"
		else
		  sudo unzip -X -o /dev/shm/arkosupdate02092023.zip -x usr/local/bin/hdmi-test.sh opt/retroarch/bin/retroarch opt/retroarch/bin/retroarch32 -d / | tee -a "$LOG_FILE"
		fi
	  sed -i '/848/s//854/' /home/ark/.config/mupen64plus/mupen64plus.cfg
	  sudo sed -i '/filebrowser.db \&/s//filebrowser.db -r \/ \&/' /opt/system/Enable\ Remote\ Services.sh
	  sudo chown ark:ark /opt/system/Enable\ Remote\ Services.sh
	  sudo systemctl daemon-reload
	  sudo systemctl enable wifi_importer.service
	  sudo rm -fv /dev/shm/arkosupdate02092023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate02092023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  printf "\nAdd check on boot for connected hdmi resolution and set drmMode\n" | tee -a "$LOG_FILE"
	  if test -z "$(sudo cat /var/spool/cron/crontabs/root | grep 'hdmi-test' | tr -d '\0')"
	  then
	    echo "@reboot /usr/local/bin/hdmi-test.sh" | sudo tee -a /var/spool/cron/crontabs/root | tee -a "$LOG_FILE"
	  else
	    printf " Check has already been added to crontab.  No need to do it again." | tee -a "$LOG_FILE"
	  fi
	fi

	printf "\nAdd support for .7z to Pokemon Mini\n" | tee -a "$LOG_FILE"
	cp -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update02092023.bak | tee -a "$LOG_FILE"
	sed -i '/<extension>.min .MIN .zip .ZIP/s//<extension>.7z .7Z .min .MIN .zip .ZIP/' /etc/emulationstation/es_systems.cfg

	printf "\nSet performance mode for drastic\n" | tee -a "$LOG_FILE"
	sed -i '/sudo perfmax %EMULATOR% %CORE%; nice -n -19 \/usr\/local\/bin\/drastic.sh %ROM%; sudo perfnorm/c\\t\t<command>sudo perfmax On; nice -n -19 \/usr\/local\/bin\/drastic.sh %ROM%; sudo perfnorm<\/command>' /etc/emulationstation/es_systems.cfg

	printf "\nCopy updated dtb based on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  if [ -f "/home/ark/.config/.DEVICE" ]; then
	    if test ! -z "$(grep "RG353V" /home/ark/.config/.DEVICE | tr -d '\0')"
	    then
		  sudo apt -y update | tee -a "$LOG_FILE"
		  sudo apt -y install libarchive-zip-perl | tee -a "$LOG_FILE"
	      sudo mv -fv /home/ark/rk3566-353v* /boot/ | tee -a "$LOG_FILE"
		  if [ $(crc32 /boot/rk3566-OC.dtb) = "4bde4e4c" ]; then
		    sudo cp -fv /boot/rk3566-353v.dtb.v2 /boot/rk3566-OC.dtb | tee -a "$LOG_FILE"
		  else
		    sudo cp -fv /boot/rk3566-353v.dtb /boot/rk3566-OC.dtb | tee -a "$LOG_FILE"
		  fi
		  sudo rm -fv /home/ark/rk3566-* | tee -a "$LOG_FILE"
	    elif test ! -z "$(grep "RG353M" /home/ark/.config/.DEVICE | tr -d '\0')"
		then
	      sudo mv -fv /home/ark/rk3566-353m* /boot/ | tee -a "$LOG_FILE"
		  sudo cp -fv /boot/rk3566-353m.dtb /boot/rk3566-OC.dtb | tee -a "$LOG_FILE"
		  sudo rm -fv /home/ark/rk3566-* | tee -a "$LOG_FILE"
		else 
		  sudo rm -fv /home/ark/rk3566-* | tee -a "$LOG_FILE"
		fi
	  else
		sudo rm -fv /home/ark/rk3566-* | tee -a "$LOG_FILE"
	  fi
	fi

	printf "\nCopy correct Hypseus-Singe for device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
      rm -fv /opt/hypseus-singe/hypseus-singe.rk3326 | tee -a "$LOG_FILE"
    else
      mv -fv /opt/hypseus-singe/hypseus-singe.rk3326 /opt/hypseus-singe/hypseus-singe | tee -a "$LOG_FILE"
	fi

	printf "\nUpdate perfmax and perfnorm scripts to replace image-viewer with ffplay\n" | tee -a "$LOG_FILE"
	sudo sed -i '/image-viewer/s//ffplay -x 1280 -y 720/' /usr/local/bin/perfmax
	sudo sed -i '/image-viewer/s//ffplay -x 1280 -y 720/' /usr/local/bin/perfmax.pic
	sudo sed -i '/image-viewer/s//ffplay -x 1280 -y 720/' /usr/local/bin/perfnorm.pic
	sudo sed -i '/image-viewer/s//ffplay -x 1280 -y 720/' /usr/local/bin/perfnorm
	sudo sed -i '/1.5s/s//2s/' /usr/local/bin/perfmax
	sudo sed -i '/1.5s/s//2s/' /usr/local/bin/perfmax.pic
	sudo sed -i '/1.5s/s//2s/' /usr/local/bin/perfnorm.pic
	sudo sed -i '/1.5s/s//2s/' /usr/local/bin/perfnorm

	printf "\nInstall and link new SDL 2.0.2600.2 (aka SDL 2.0.26.2)\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  sudo mv -f -v /home/ark/sdl2-64/libSDL2-2.0.so.0.2600.2.rk3566 /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2600.2 | tee -a "$LOG_FILE"
	  sudo mv -f -v /home/ark/sdl2-32/libSDL2-2.0.so.0.2600.2.rk3566 /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2600.2 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-32 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-64 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2.so /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2600.2 /usr/lib/aarch64-linux-gnu/libSDL2.so | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2.so /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2600.2 /usr/lib/arm-linux-gnueabihf/libSDL2.so | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  sudo mv -f -v /home/ark/sdl2-64/libSDL2-2.0.so.0.2600.2.rk3326 /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2600.2 | tee -a "$LOG_FILE"
	  sudo mv -f -v /home/ark/sdl2-32/libSDL2-2.0.so.0.2600.2.rk3326 /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2600.2 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-32 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-64 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2.so /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2600.2 /usr/lib/aarch64-linux-gnu/libSDL2.so | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2.so /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2600.2 /usr/lib/arm-linux-gnueabihf/libSDL2.so | tee -a "$LOG_FILE"
	else
	  sudo mv -f -v /home/ark/sdl2-64/libSDL2-2.0.so.0.2600.2.rotated /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2600.2 | tee -a "$LOG_FILE"
	  sudo mv -f -v /home/ark/sdl2-32/libSDL2-2.0.so.0.2600.2.rotated /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2600.2 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-64 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-32 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2.so /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2600.2 /usr/lib/aarch64-linux-gnu/libSDL2.so | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2.so /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2600.2 /usr/lib/arm-linux-gnueabihf/libSDL2.so | tee -a "$LOG_FILE"
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update02092023"

fi

if [ ! -f "/home/ark/.config/.update02172023" ]; then

	printf "\nAdd IPTV Simple PVR plugin for Kodi for rk3566 devices\nFix connection and disconnection of joysticks issue for rk3566 devices\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/02172023/arkosupdate02172023.zip -O /dev/shm/arkosupdate02172023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate02172023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate02172023.zip" ]; then
		if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	      sudo unzip -X -o /dev/shm/arkosupdate02172023.zip -x "usr/bin/*" -d / | tee -a "$LOG_FILE"
		elif [ ! -f "/boot/rk3326-rg351mp-linux.dtb" ]; then
		  sudo unzip -X -o /dev/shm/arkosupdate02172023.zip -x "opt/kodi/*" "usr/bin/*" -d / | tee -a "$LOG_FILE"
		else
		  sudo unzip -X -o /dev/shm/arkosupdate02172023.zip -x "opt/kodi/*" -d / | tee -a "$LOG_FILE"
		fi
	    sudo rm -fv /dev/shm/arkosupdate02172023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate02172023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nFix emulationstation restarting on wake from sleep on 351v and when connecting joysticks for rk3566 devices\n" | tee -a "$LOG_FILE"
	if test -z "$(sudo cat /usr/bin/emulationstation/emulationstation.sh.es | grep 'SDL_ASSERT' | tr -d '\0')"
	then
	  sudo sed -i '/#!\/bin\/bash/c\#!\/bin\/bash\n\nexport SDL_ASSERT\=\"always_ignore\"' /usr/bin/emulationstation/emulationstation.sh
	  sudo sed -i '/#!\/bin\/bash/c\#!\/bin\/bash\n\nexport SDL_ASSERT\=\"always_ignore\"' /usr/bin/emulationstation/emulationstation.sh.es
	  sudo sed -i '/#!\/bin\/bash/c\#!\/bin\/bash\n\nexport SDL_ASSERT\=\"always_ignore\"' /usr/bin/emulationstation/emulationstation.sh.ra
	else
	  printf " Fix has already been applied.  No need to do it again." | tee -a "$LOG_FILE"
	fi

	printf "\nUpdate Retroarches for 351v, 351mp and chi devices Only\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  sudo chmod -v 777 /opt/retroarch/bin/* | tee -a "$LOG_FILE"
	  sudo chown -v ark:ark /opt/retroarch/bin/* | tee -a "$LOG_FILE"
	  cp -fv /opt/retroarch/bin/retroarch32.rk3326.unrot /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
	  cp -fv /opt/retroarch/bin/retroarch.rk3326.unrot /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	else
	  printf " This is not a 351mp, 351v or chi device.  No need to update retroarch again at this time." | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update02172023"

fi

if [ ! -f "/home/ark/.config/.update02252023" ]; then

	printf "\nUpdate emulationstation to add Ignore Leading Articles when sorting feature\nAdd display panel adjustment features for 353 devices\nFix shoulder buttons paging after reconfiguration in ES\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/02252023/arkosupdate02252023.zip -O /dev/shm/arkosupdate02252023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate02252023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate02252023.zip" ]; then
		if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
		  #if [ "$(cat ~/.config/.DEVICE)" = "RG353V" ] || [ "$(cat ~/.config/.DEVICE)" = "RG353M" ]; then
	        sudo unzip -X -o /dev/shm/arkosupdate02252023.zip -d / | tee -a "$LOG_FILE"
		    sudo systemctl daemon-reload
			sudo systemctl enable shutdowntasks
		  #else
		  #  sudo unzip -X -o /dev/shm/arkosupdate02252023.zip -x usr/local/bin/panel_drm_tool usr/local/bin/panel_set.sh etc/systemd/system/shutdowntasks.service -d / | tee -a "$LOG_FILE"
		  #fi
		else
		  sudo unzip -X -o /dev/shm/arkosupdate02252023.zip -x usr/local/bin/panel_drm_tool usr/local/bin/panel_set.sh etc/systemd/system/shutdowntasks.service -d / | tee -a "$LOG_FILE"
		fi
	    sudo rm -fv /dev/shm/arkosupdate02252023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate02252023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCopy correct emulationstation depending on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  sudo mv -fv /home/ark/emulationstation.351v /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-odroidgo2-linux.dtb" ] || [ -f "/boot/rk3326-odroidgo2-linux-v11.dtb" ]; then
	  test=$(stat -c %s "/usr/bin/emulationstation/emulationstation")
	  if [ "$test" = "3191376" ]; then
	    sudo cp -fv /home/ark/emulationstation.fullscreen /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  else
	    sudo cp -fv /home/ark/emulationstation.header /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  fi
	  sudo cp -fv /home/ark/emulationstation.header /usr/bin/emulationstation/emulationstation.header | tee -a "$LOG_FILE"
	  sudo cp -fv /home/ark/emulationstation.fullscreen /usr/bin/emulationstation/emulationstation.fullscreen | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-odroidgo3-linux.dtb" ]; then
	  sudo cp -fv /home/ark/emulationstation.header /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo mv -fv /home/ark/emulationstation.rgb10max /usr/bin/emulationstation/emulationstation.fullscreen | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3566.dtb" ]; then
	  sudo mv -fv /home/ark/emulationstation.503 /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	fi


	if test ! -z "$(cat /etc/emulationstation/es_input.cfg | grep 190000004b4800000010000000010000 | tr -d '\0')"
	then
	  printf "\nFix Pico-8 controls for RK2020\nFix PSP controls for RK2020\nFix openmsx standalone controls for RK2020\n" | tee -a "$LOG_FILE"
	  sed -i "/odroidgo2 joypad v11/d" /opt/fake08/gamecontrollerdb.txt
	  sudo sed -i "/190000004b4800000010000001010000,GO-Advance Gamepad (rev 1.1)/d" /usr/local/bin/pico8.sh
	  sed -i "/190000004b4800000010000001010000,GO-Advance Gamepad (rev 1.1)/d" /opt/ppsspp/assets/gamecontrollerdb.txt
	  sed -i "/190000004b4800000010000001010000,GO-Advance Gamepad (rev 1.1)/d" /opt/ppssppgo/assets/gamecontrollerdb.txt
	  sed -i "/190000004b4800000010000001010000,GO-Advance Gamepad (rev 1.1)/d" /opt/openmsx/gamecontrollerdb.txt
	fi

	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  printf "\nAdd restore panel display settings on boot for rk3566 devices\n" | tee -a "$LOG_FILE"
	    if test -z "$(sudo cat /var/spool/cron/crontabs/root | grep 'panel_set.sh' | tr -d '\0')"
	    then
	      echo "@reboot /usr/local/bin/panel_set.sh RestoreSettings &" | sudo tee -a /var/spool/cron/crontabs/root | tee -a "$LOG_FILE"
	    else
	      printf " Panel settings restore has already been added to crontab.  No need to do it again.\n" | tee -a "$LOG_FILE"
	    fi
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update02252023"

fi

if [ ! -f "/home/ark/.config/.update02282023" ]; then

	printf "\nUpdate ES for rk3566 devices to disable display settings via hdmi\nUpdate ScummVM\nUpdate color profile restore settings failsafe for rk3566 devices\nAdded Greek translation for es\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/02282023/arkosupdate02282023.zip -O /dev/shm/arkosupdate02282023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate02282023.zip | tee -a "$LOG_FILE"
	  sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/02282023/arkosupdate02282023.z01 -O /dev/shm/arkosupdate02282023.z01 -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate02282023.z01 | tee -a "$LOG_FILE"
	else
	  sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/02282023/rk3326/arkosupdate02282023.zip -O /dev/shm/arkosupdate02282023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate02282023.zip | tee -a "$LOG_FILE"
	  sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/02282023/rk3326/arkosupdate02282023.z01 -O /dev/shm/arkosupdate02282023.z01 -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate02282023.z01 | tee -a "$LOG_FILE"
	fi
	if [ -f "/dev/shm/arkosupdate02282023.zip" ] && [ -f "/dev/shm/arkosupdate02282023.z01" ]; then
	  zip -FF /dev/shm/arkosupdate02282023.zip --out /dev/shm/arkosupdate.zip -fz | tee -a "$LOG_FILE"
	  sudo rm -fv /dev/shm/arkosupdate02282023.z* | tee -a "$LOG_FILE"
      sudo unzip -X -o /dev/shm/arkosupdate.zip -x opt/scummvm/extra/gamecontrollerdb.txt -d / | tee -a "$LOG_FILE"
      sudo rm -fv /dev/shm/arkosupdate02282023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate02282023.z* | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update02282023"

fi

if [ ! -f "/home/ark/.config/.update03112023" ]; then

	printf "\nUpdate Retroarch to 1.15.0\nAdd force kill capability for drastic and scummvm\nAdd Sega Pico platform\nUpdate emulationstation for scraping sega pico\nUpdate nes-box theme\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/03112023/arkosupdate03112023.zip -O /dev/shm/arkosupdate03112023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate03112023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate03112023.zip" ]; then
        sudo unzip -X -o /dev/shm/arkosupdate03112023.zip -d / | tee -a "$LOG_FILE"
		if test -z "$(cat /etc/emulationstation/es_systems.cfg | grep '<name>pico</name>')"
		then
		  sed -i -e '/<theme>gamegear<\/theme>/{r /home/ark/add_pico.txt' -e 'd}' /etc/emulationstation/es_systems.cfg
		fi
		mkdir -v /roms/pico | tee -a "$LOG_FILE"
		if test ! -z "$(cat /etc/fstab | grep roms2 | tr -d '\0')"
		then
		  mkdir -v /roms2/pico | tee -a "$LOG_FILE"
		  sed -i '/<path>\/roms\/pico/s//<path>\/roms2\/pico/g' /etc/emulationstation/es_systems.cfg
		fi
	    sudo rm -fv /dev/shm/arkosupdate03112023.zip | tee -a "$LOG_FILE"
	    sudo rm -fv /home/ark/add_pico.txt | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate03112023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCopy correct emulationstation depending on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  sudo mv -fv /home/ark/emulationstation.351v /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-odroidgo2-linux.dtb" ] || [ -f "/boot/rk3326-odroidgo2-linux-v11.dtb" ]; then
	  test=$(stat -c %s "/usr/bin/emulationstation/emulationstation")
	  if [ "$test" = "3203664" ]; then
	    sudo cp -fv /home/ark/emulationstation.fullscreen /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  else
	    sudo cp -fv /home/ark/emulationstation.header /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  fi
	  sudo cp -fv /home/ark/emulationstation.header /usr/bin/emulationstation/emulationstation.header | tee -a "$LOG_FILE"
	  sudo cp -fv /home/ark/emulationstation.fullscreen /usr/bin/emulationstation/emulationstation.fullscreen | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-odroidgo3-linux.dtb" ]; then
	  sudo cp -fv /home/ark/emulationstation.header /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo mv -fv /home/ark/emulationstation.rgb10max /usr/bin/emulationstation/emulationstation.fullscreen | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3566.dtb" ]; then
	  sudo mv -fv /home/ark/emulationstation.503 /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	fi

	printf "\nCopy correct Retroarches depending on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  cp -fv /opt/retroarch/bin/retroarch32.rk3326.unrot /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
	  cp -fv /opt/retroarch/bin/retroarch.rk3326.unrot /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-odroidgo2-linux.dtb" ] || [ -f "/boot/rk3326-odroidgo2-linux-v11.dtb" ] || [ -f "/boot/rk3326-odroidgo3-linux.dtb" ]; then
	  cp -fv /opt/retroarch/bin/retroarch32.rk3326.rot /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
	  cp -fv /opt/retroarch/bin/retroarch.rk3326.rot /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	else
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	fi

	printf "\nMake sure permissions for the ark home directory are set to 755\n" | tee -a "$LOG_FILE"
	sudo chown -R ark:ark /home/ark
	sudo chmod -R 755 /home/ark
	
	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update03112023"

fi

if [ ! -f "/home/ark/.config/.update03212023" ]; then

	printf "\nAdd Microvision emulator\nFixed GZDoom\nAdd swanstation libretro core for psx\nUpdated Backup Settings\nUpdated bluetooth audio backend\nUpdated Emulationstation with volume and brightness OSD\nUpdated Restore Settings with confirmation capability\nAdd default Drastic settings script\nAdd microvision to nes-box theme\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/03212023/arkosupdate03212023.zip -O /dev/shm/arkosupdate03212023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate03212023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate03212023.zip" ]; then
		if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
          sudo unzip -X -o /dev/shm/arkosupdate03212023.zip -d / | tee -a "$LOG_FILE"
		  cd /home/ark/bluez-alsa03192023/build
		  sudo make CFLAGS="-I /home/ark/bluez-alsa03192023/build/depends/include/ \
		  -I /home/ark/bluez-alsa03192023/build/depends/include/aarch64-linux-gnu/ \
		  -I /home/ark/bluez-alsa03192023/build/depends/include/dbus-1.0 -I /home/ark/bluez-alsa03192023/build/depends/include/glib-2.0 \
		  -I /home/ark/bluez-alsa03192023/build/depends/include/gio-unix-2.0" LDFLAGS="-L/home/ark/bluez-alsa03192023/build/depends/include/bluetooth \
		  -L/home/ark/bluez-alsa03192023/build/depends/include/sbc" install | tee -a "$LOG_FILE"
		  cd /home/ark
		  sudo rm -rfv /home/ark/bluez-alsa03192023/ | tee -a "$LOG_FILE"
		else
          sudo unzip -X -o /dev/shm/arkosupdate03212023.zip -x "home/ark/bluez-alsa03192023/*" home/ark/update_amiga.txt -d / | tee -a "$LOG_FILE"
		fi
		if test -z "$(grep 'swanstation' /usr/local/bin/perfmax | tr -d '\0')"
		then
		  sudo sed -i '/\[\[ \$2 == "duckstation" \]\]/s//\[\[ \$2 == "duckstation" \]\] || \[\[ \$2 == "swanstation" \]\] || \[\[ \$2 == *"uae"* \]\]/' /usr/local/bin/perfmax
  		  sudo sed -i '/\[\[ \$2 == "duckstation" \]\]/s//\[\[ \$2 == "duckstation" \]\] || \[\[ \$2 == "swanstation" \]\] || \[\[ \$2 == *"uae"* \]\]/' /usr/local/bin/perfmax.pic
  		  sudo sed -i '/\[\[ \$2 == "duckstation" \]\]/s//\[\[ \$2 == "duckstation" \]\] || \[\[ \$2 == "swanstation" \]\] || \[\[ \$2 == *"uae"* \]\]/' /usr/local/bin/perfmax.asc
		fi
		cp -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update03212023.bak | tee -a "$LOG_FILE"
		if test -z "$(cat /etc/emulationstation/es_systems.cfg | grep microvision)"
		then
		  sed -i -e '/<theme>easyrpg<\/theme>/{r /home/ark/add_microvision.txt' -e 'd}' /etc/emulationstation/es_systems.cfg
		fi
		if [ ! -d "/roms/mv" ]; then
		  mkdir -v /roms/mv | tee -a "$LOG_FILE"
		  if test ! -z "$(cat /etc/fstab | grep roms2 | tr -d '\0')"
		  then
		    if [ ! -d "/roms2/mv" ]; then
		      mkdir -v /roms2/mv | tee -a "$LOG_FILE"
			fi
		    sed -i '/<path>\/roms\/mv/s//<path>\/roms2\/mv/g' /etc/emulationstation/es_systems.cfg
		  fi
		fi
		if [ -f "/opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh" ]; then
		  if test -z "$(cat /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh | grep mv | tr -d '\0')"
		  then
		    sed -i '/sudo pkill filebrowser/s//if [ \! -d "\/roms2\/mv\/" ]\; then\n      sudo mkdir \/roms2\/mv\n  fi\n  sudo pkill filebrowser/' /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh
		  else
		    printf "\nMicrovision is already being accounted for in the switch to sd2 script\n" | tee -a "$LOG_FILE"
		  fi
		fi
		if [ -f "/usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh" ]; then
		  if test -z "$(cat /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh | grep mv | tr -d '\0')"
		  then
		    sudo sed -i '/sudo pkill filebrowser/s//if [ \! -d "\/roms2\/mv\/" ]\; then\n      sudo mkdir \/roms2\/mv\n  fi\n  sudo pkill filebrowser/' /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh
		  else
		    printf "\nMicrovision is already being accounted for in the switch to sd2 script\n" | tee -a "$LOG_FILE"
		  fi
		fi
		sudo rm -fv /home/ark/add_microvision.txt | tee -a "$LOG_FILE"
	    sudo rm -fv /dev/shm/arkosupdate03212023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate03212023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCopy correct gzdoom depending on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  sudo rm -fv /opt/gzdoom/gzdoom.* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  cp -fv /opt/gzdoom/gzdoom.chi /opt/gzdoom/gzdoom | tee -a "$LOG_FILE"
	  sudo rm -fv /opt/gzdoom/gzdoom.* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-rg351v-linux.dtb" ]; then
	  cp -fv /opt/gzdoom/gzdoom.351v /opt/gzdoom/gzdoom | tee -a "$LOG_FILE"
	  sudo rm -fv /opt/gzdoom/gzdoom.* | tee -a "$LOG_FILE"
	fi

	printf "\nAdd swanstation libreto for psx to ES\n" | tee -a "$LOG_FILE"
	if test -z "$(grep 'swanstation' /etc/emulationstation/es_systems.cfg | tr -d '\0')"
	then
	  sed -i '/<core>duckstation<\/core>/c\\t\t\t  <core>duckstation<\/core>\n\t\t\t  <core>swanstation<\/core>' /etc/emulationstation/es_systems.cfg
	fi

	printf "\nAdd puae2021 libreto for amiga to ES\n" | tee -a "$LOG_FILE"
	if test -z "$(grep 'puae2021' /etc/emulationstation/es_systems.cfg | tr -d '\0')"
	then
	  sed -i 's/<core>puae<\/core>/<core>puae2021<\/core>\n\t\t\t  <core>puae<\/core>/g' /etc/emulationstation/es_systems.cfg
	fi

	printf "\nCopy correct swanstation libretro depending on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  cp -fv /home/ark/swanstation_libretro.so /home/ark/.config/retroarch/cores/. | tee -a "$LOG_FILE"
	  sudo rm -rf /home/ark/swanstation_libretro* | tee -a "$LOG_FILE"
	else
	  cp -fv /home/ark/swanstation_libretro.so.rk3326 /home/ark/.config/retroarch/cores/swanstation_libretro.so | tee -a "$LOG_FILE"
	  sudo rm -rf /home/ark/swanstation_libretro* | tee -a "$LOG_FILE"
	fi

	printf "\nCopy correct puae2021 libretro depending on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  cp -fv /home/ark/puae2021_libretro.so /home/ark/.config/retroarch/cores/. | tee -a "$LOG_FILE"
	  sudo rm -rf /home/ark/puae2021_libretro* | tee -a "$LOG_FILE"
	else
	  cp -fv /home/ark/puae2021_libretro.so.rk3326 /home/ark/.config/retroarch/cores/puae2021_libretro.so | tee -a "$LOG_FILE"
	  sudo rm -rf /home/ark/puae2021_libretro* | tee -a "$LOG_FILE"
	fi

	printf "\nCopy correct emulationstation depending on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  sudo mv -fv /home/ark/emulationstation.351v /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-odroidgo2-linux.dtb" ] || [ -f "/boot/rk3326-odroidgo2-linux-v11.dtb" ] || [ -f "/boot/rk3326-odroidgo3-linux-v11.dtb" ]; then
	  test=$(stat -c %s "/usr/bin/emulationstation/emulationstation")
	  if [ "$test" = "3199568" ]; then
	    sudo cp -fv /home/ark/emulationstation.351v /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  fi
	  if [ -f "/boot/rk3326-odroidgo3-linux-v11.dtb" ]; then
	    cd /usr/lib/aarch64-linux-gnu/
		sudo ln -sfv libMali.so libGLES_CM.so | tee -a "$LOG_FILE"
		ldconfig
		cd /home/ark
	  fi
	  sudo cp -fv /home/ark/emulationstation.351v /usr/bin/emulationstation/emulationstation.fullscreen | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3566.dtb" ]; then
	  sudo mv -fv /home/ark/emulationstation.503 /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	fi

	printf "\nCleanup some unneeded left over files in the home folder from previous updates if need be\n" | tee -a "$LOG_FILE"
	if [ $(ls -1 /home/ark/*.dtb 2>/dev/null | wc -l) != 0 ]; then
	  sudo rm -fv /home/ark/*.dtb | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/*.v2 | tee -a "$LOG_FILE"
	  printf "   Cleaned up some unneeded files found.\n" | tee -a "$LOG_FILE"
	else
	  printf "   No clean up needed.\n" | tee -a "$LOG_FILE"
	fi

	printf "\nEnable software renderer for swanstation by default\n" | tee -a "$LOG_FILE"
	if test ! -z "$(cat /home/ark/.config/retroarch/retroarch-core-options.cfg | grep 'swanstation_GPU_Renderer' | tr -d '\0')"
	then
	  sed -i '/swanstation_GPU_Renderer \= /c\swanstation_GPU_Renderer \= "Software"' /home/ark/.config/retroarch/retroarch-core-options.cfg
	  sed -i '/mgba_use_bios \= \"ON\"/c\mgba_use_bios \= \"ON\"\nswanstation_GPU_Renderer \= "Software"' /home/ark/.config/retroarch/retroarch-core-options.cfg.bak
	else
  	  sed -i '/mgba_use_bios \= \"ON\"/c\mgba_use_bios \= \"ON\"\nswanstation_GPU_Renderer \= "Software"' /home/ark/.config/retroarch/retroarch-core-options.cfg
  	  sed -i '/mgba_use_bios \= \"ON\"/c\mgba_use_bios \= \"ON\"\nswanstation_GPU_Renderer \= "Software"' /home/ark/.config/retroarch/retroarch-core-options.cfg.bak
	fi

	printf "\nDefault dreamcast emulator and core to retroarch32 and flycast32_rumble\n" | tee -a "$LOG_FILE"
	sed -i -e '/<name>dreamcast/ {n;N;N;N;N;N;N;N;N;N;N;N;N;N;N;N;N;N;d;}' /etc/emulationstation/es_systems.cfg
	sed -i -e '/<name>dreamcast<\/name>/{r /home/ark/update_dreamcast.txt' -e 'd}' /etc/emulationstation/es_systems.cfg
	if test ! -z "$(cat /etc/fstab | grep roms2 | tr -d '\0')"
	then
	  sed -i '/<path>\/roms\/dreamcast/s//<path>\/roms2\/dreamcast/g' /etc/emulationstation/es_systems.cfg
	fi
	sudo rm -fv /home/ark/update_dreamcast.txt | tee -a "$LOG_FILE"

	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  printf "\nDefault amiga emulator and core to retroarch32 and uae4arm\n" | tee -a "$LOG_FILE"
	  sed -i -e '/<name>amiga</ {n;N;N;N;N;N;N;N;N;N;N;N;N;N;N;N;N;N;d;}' /etc/emulationstation/es_systems.cfg
	  sed -i -e '/<name>amiga<\/name>/{r /home/ark/update_amiga.txt' -e 'd}' /etc/emulationstation/es_systems.cfg
	  if test ! -z "$(cat /etc/fstab | grep roms2 | tr -d '\0')"
	  then
	    sed -i '/<path>\/roms\/amiga/s//<path>\/roms2\/amiga/g' /etc/emulationstation/es_systems.cfg
	  fi
	  sudo rm -fv /home/ark/update_amiga.txt | tee -a "$LOG_FILE"
	fi

	if test -z "$(cat /etc/fstab | grep roms2 | tr -d '\0')"
	then
	  printf "\nFix Duckstation Standalone not booting with 1 SD card setup\n" | tee -a "$LOG_FILE"
	  sed -i '/roms2/s//roms/g'  /home/ark/.config/duckstation/settings.ini
	fi

	printf "\nMake sure permissions for the ark home directory are set to 755\n" | tee -a "$LOG_FILE"
	sudo chown -R ark:ark /home/ark
	sudo chmod -R 755 /home/ark
	
	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update03212023"

fi

if [ ! -f "/home/ark/.config/.update03252023" ]; then

	printf "\nUpdate Mupen64plus standalone\nFix swanstation and puae2021 not loading for rk3326 devices\nFix Space Invaders and Super Blockbuster controls for Microvision\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/03252023/arkosupdate03252023.zip -O /dev/shm/arkosupdate03252023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate03252023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate03252023.zip" ]; then
        sudo unzip -X -o /dev/shm/arkosupdate03252023.zip -d / | tee -a "$LOG_FILE"
        sudo rm -fv /dev/shm/arkosupdate03252023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate03252023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	#printf "\nCopy updated dtb based on device\n" | tee -a "$LOG_FILE"
	#if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	#  if [ -f "/home/ark/.config/.DEVICE" ]; then
	#    if test ! -z "$(grep "RG353V" /home/ark/.config/.DEVICE | tr -d '\0')"
	#    then
	#      sudo cp -fv /boot/rk3566-353v.dtb /boot/rk3566-OC.dtb | tee -a "$LOG_FILE"
	#	  sudo rm -fv /boot/rk3566-353v.dtb.v2 | tee -a "$LOG_FILE"
	#	  sudo rm -fv /boot/rk3566-353m* | tee -a "$LOG_FILE"
	#    elif test ! -z "$(grep "RG353M" /home/ark/.config/.DEVICE | tr -d '\0')"
	#	then
	#      sudo cp -fv /boot/rk3566-353m.dtb /boot/rk3566-OC.dtb | tee -a "$LOG_FILE"
	#	  sudo rm -fv /boot/rk3566-353m.dtb.v2 | tee -a "$LOG_FILE"
	#	  sudo rm -fv /boot/rk3566-353v* | tee -a "$LOG_FILE"
	#	else
	#	  sudo rm -fv /boot/rk3566-353m* | tee -a "$LOG_FILE"
	#	  sudo rm -fv /boot/rk3566-353v* | tee -a "$LOG_FILE"
	#	fi
	#  else
	#	  sudo rm -fv /boot/rk3566-353m* | tee -a "$LOG_FILE"
	#	  sudo rm -fv /boot/rk3566-353v* | tee -a "$LOG_FILE"
	#  fi
	#fi

	if [ ! -f "/boot/rk3566.dtb" ] && [ ! -f "/boot/rk3566-OC.dtb" ]; then
	  printf "\nFixing swanstation and puae2021 not booting...\n" | tee -a "$LOG_FILE"
	  if [ -f "/home/ark/.config/retroarch/cores/swanstation_libretro.so.rk3326" ]; then
	    mv -fv /home/ark/.config/retroarch/cores/swanstation_libretro.so.rk3326 /home/ark/.config/retroarch/cores/swanstation_libretro.so | tee -a "$LOG_FILE"
	  fi
	  if [ -f "/home/ark/.config/retroarch/cores/puae2021_libretro.so.rk3326" ]; then
	    mv -fv /home/ark/.config/retroarch/cores/puae2021_libretro.so.rk3326 /home/ark/.config/retroarch/cores/puae2021_libretro.so | tee -a "$LOG_FILE"
	  fi
	fi

	printf "\nCopy correct mupen64plus standalone for the chipset\n" | tee -a "$LOG_FILE"
	if [ ! -f "/boot/rk3566.dtb" ] && [ ! -f "/boot/rk3566-OC.dtb" ]; then
	  cp -fv /opt/mupen64plus/mupen64plus-video-GLideN64.so.rk3326 /opt/mupen64plus/mupen64plus-video-GLideN64.so | tee -a "$LOG_FILE"
	  cp -fv /opt/mupen64plus/mupen64plus-video-glide64mk2.so.rk3326 /opt/mupen64plus/mupen64plus-video-glide64mk2.so | tee -a "$LOG_FILE"
	  cp -fv /opt/mupen64plus/mupen64plus-video-rice.so.rk3326 /opt/mupen64plus/mupen64plus-video-rice.so | tee -a "$LOG_FILE"
	  cp -fv /opt/mupen64plus/mupen64plus-audio-sdl.so.rk3326 /opt/mupen64plus/mupen64plus-audio-sdl.so | tee -a "$LOG_FILE"
	  cp -fv /opt/mupen64plus/mupen64plus.rk3326 /opt/mupen64plus/mupen64plus | tee -a "$LOG_FILE"
	  cp -fv /opt/mupen64plus/libmupen64plus.so.2.0.0.rk3326 /opt/mupen64plus/libmupen64plus.so.2.0.0 | tee -a "$LOG_FILE"
	  cp -fv /opt/mupen64plus/mupen64plus-rsp-hle.so.rk3326 /opt/mupen64plus/mupen64plus-rsp-hle.so | tee -a "$LOG_FILE"
	  cp -fv /opt/mupen64plus/mupen64plus-input-sdl.so.rk3326 /opt/mupen64plus/mupen64plus-input-sdl.so | tee -a "$LOG_FILE"
	  rm -fv /opt/mupen64plus/*.rk3326 | tee -a "$LOG_FILE"
	else
	  rm -fv /opt/mupen64plus/*.rk3326 | tee -a "$LOG_FILE"
	  echo "  Correct Mupen64plus standalone files are already in place for this rk3566 device" | tee -a "$LOG_FILE"
	fi

	printf "\nMake sure permissions for the ark home directory are set to 755\n" | tee -a "$LOG_FILE"
	sudo chown -R ark:ark /home/ark
	sudo chmod -R 755 /home/ark
	
	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update03252023"

fi

if [ ! -f "/home/ark/.config/.update03302023" ]; then

	printf "\nUpdate ECWolf to 1.4.1\nFix ability to reconfigure keys in drastic\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/03302023/arkosupdate03302023.zip -O /dev/shm/arkosupdate03302023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate03302023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate03302023.zip" ]; then
        sudo unzip -X -o /dev/shm/arkosupdate03302023.zip -d / | tee -a "$LOG_FILE"
        sudo rm -fv /dev/shm/arkosupdate03302023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate03302023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nFix drastic ability to change key configuration\n" | tee -a "$LOG_FILE"
	sudo cp -fv /usr/local/bin/ti99keydemon.py /usr/local/bin/drastickeydemon.py | tee -a "$LOG_FILE"
	sudo chmod 777 /usr/local/bin/drastickeydemon.py
	sudo sed -i 's/ti99sim-sdl/drastic/' /usr/local/bin/drastickeydemon.py

	printf "\nCopy updated kernel based on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  if [ -f "/home/ark/.config/.DEVICE" ]; then
	    if test ! -z "$(grep "RG353" /home/ark/.config/.DEVICE | tr -d '\0')"
	    then
	      sudo mv -fv /boot/Image.353 /boot/Image | tee -a "$LOG_FILE"
		  sudo rm -fv /boot/Image.503 | tee -a "$LOG_FILE"
	    else
	      sudo mv -fv /boot/Image.503 /boot/Image | tee -a "$LOG_FILE"
		  sudo rm -fv /boot/Image.353 | tee -a "$LOG_FILE"
	    fi
	  fi
	else
	  sudo rm -fv /boot/Image.503 | tee -a "$LOG_FILE"
	  sudo rm -fv /boot/Image.353 | tee -a "$LOG_FILE"
	fi

	printf "\nDefault mgba libretro emulator governor to performance\n" | tee -a "$LOG_FILE"
	if test -z "$(grep 'mgba' /usr/local/bin/perfmax.pic | tr -d '\0')"
	then
	  sudo sed -i '/\[\[ \$1 == "On" \]\]/s//\[\[ \$1 == "On" \]\] || \[\[ \$2 == *"mgba"* \]\]/' /usr/local/bin/perfmax
  	  sudo sed -i '/\[\[ \$1 == "On" \]\]/s//\[\[ \$1 == "On" \]\] || \[\[ \$2 == *"mgba"* \]\]/' /usr/local/bin/perfmax.pic
  	  sudo sed -i '/\[\[ \$1 == "On" \]\]/s//\[\[ \$1 == "On" \]\] || \[\[ \$2 == *"mgba"* \]\]/' /usr/local/bin/perfmax.asc
	fi

	printf "\nReplace interactive cpu governor with schedutil\n" | tee -a "$LOG_FILE"
	if test -z "$(grep 'echo schedutil' /usr/local/bin/perfmax.pic | tr -d '\0')"
	then
	  sudo sed -i 's/echo interactive/echo schedutil/' /usr/local/bin/perfmax
	  sudo sed -i 's/echo interactive/echo schedutil/' /usr/local/bin/perfmax.pic
	  sudo sed -i 's/echo interactive/echo schedutil/' /usr/local/bin/perfmax.asc
	fi

	printf "\nMake sure permissions for the ark home directory are set to 755\n" | tee -a "$LOG_FILE"
	sudo chown -R ark:ark /home/ark
	sudo chmod -R 755 /home/ark

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update03302023"

fi

if [ ! -f "/home/ark/.config/.update04012023" ]; then

	printf "\nFix gzdoom and lzdoom ability to change key configuration\nUpdate fake-08 standalone emulator\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/04012023/arkosupdate04012023.zip -O /dev/shm/arkosupdate04012023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate04012023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate04012023.zip" ]; then
        sudo unzip -X -o /dev/shm/arkosupdate04012023.zip -d / | tee -a "$LOG_FILE"
        sudo rm -fv /dev/shm/arkosupdate04012023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate04012023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nFix gzdoom and lzdoom ability to change key configuration\n" | tee -a "$LOG_FILE"
	sudo cp -fv /usr/local/bin/ti99keydemon.py /usr/local/bin/doomkeydemon.py | tee -a "$LOG_FILE"
	sudo chmod 777 /usr/local/bin/doomkeydemon.py
	sudo sed -i 's/ti99sim-sdl/-f doom/' /usr/local/bin/doomkeydemon.py

	printf "\nMake sure permissions for the ark home directory are set to 755\n" | tee -a "$LOG_FILE"
	sudo chown -R ark:ark /home/ark
	sudo chmod -R 755 /home/ark

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update04012023"

fi

if [ ! -f "/home/ark/.config/.update04272023" ]; then

	printf "\nAdd Adventure Vision\nUpdate vibration script to allow strong and weak vibration\nUpdate retroarch only mode to default to performance governor\nRebuild retroarch and retroarch32 to resolve microstutter issues\nUpdate hypseus-singe to 2.10.3\nAdd fbneo as optional core for NeoGeo CD\nUpdated kernel and dtb for rg353 devices for v1 and v2 screen support\nUpdated SDL to 2.26.5\nAdd retroarch audio filters\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/04272023/arkosupdate04272023.zip -O /dev/shm/arkosupdate04272023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate04272023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate04272023.zip" ]; then
		if test ! -z "$(grep "RG353" /home/ark/.config/.DEVICE | tr -d '\0')"
		then
          sudo unzip -X -o /dev/shm/arkosupdate04272023.zip -d / | tee -a "$LOG_FILE"
		elif test ! -z "$(grep "RK2023" /home/ark/.config/.DEVICE | tr -d '\0')"
		then
          sudo unzip -X -o /dev/shm/arkosupdate04272023.zip -d / | tee -a "$LOG_FILE"
		else
          sudo unzip -X -o /dev/shm/arkosupdate04272023.zip -x "home/ark/v1v2/*" -d / | tee -a "$LOG_FILE"
		fi
		cp -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update04272023.bak | tee -a "$LOG_FILE"
		sed -i '/<name>neogeocd<\/name>/,/<platform>neogeocd<\/platform>/{//!d}' /etc/emulationstation/es_systems.cfg
		sed -i -e '/<name>neogeocd<\/name>/{r /home/ark/update_neogeocd.txt' -e 'd}' /etc/emulationstation/es_systems.cfg
		if test ! -z "$(cat /etc/fstab | grep roms2 | tr -d '\0')"
		then
		  sed -i '/<path>\/roms\/neogeocd/s//<path>\/roms2\/neogeocd/g' /etc/emulationstation/es_systems.cfg
		fi
		if test -z "$(cat /etc/emulationstation/es_systems.cfg | grep 'advision' | tr -d '\0')"
		then
		  sed -i -e '/<name>amiga<\/name>/{r /home/ark/add_advision.txt' -e 'd}' /etc/emulationstation/es_systems.cfg
		fi
		if [ ! -d "/roms/advision" ]; then
		  mkdir -v /roms/advision | tee -a "$LOG_FILE"
		  if test ! -z "$(cat /etc/fstab | grep roms2 | tr -d '\0')"
		  then
		    if [ ! -d "/roms2/advision" ]; then
		      mkdir -v /roms2/advision | tee -a "$LOG_FILE"
		      sed -i '/<path>\/roms\/advision/s//<path>\/roms2\/advision/g' /etc/emulationstation/es_systems.cfg
			  cp -fv /roms/bios/mame/hash/advision.xml /roms2/bios/mame/hash/advision.xml | tee -a "$LOG_FILE"
			fi
		  fi
		fi
		if [ -f "/opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh" ]; then
		  if test -z "$(cat /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh | grep advision | tr -d '\0')"
		  then
		    sudo chown -v ark:ark /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh | tee -a "$LOG_FILE"
		    sed -i '/sudo pkill filebrowser/s//if [ \! -d "\/roms2\/advision\/" ]\; then\n      sudo mkdir \/roms2\/advision\n  fi\n  sudo pkill filebrowser/' /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh
		  else
		    printf "\nAdventure Vision is already being accounted for in the switch to sd2 script\n" | tee -a "$LOG_FILE"
		  fi
		fi
		if [ -f "/usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh" ]; then
		  if test -z "$(cat /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh | grep advision | tr -d '\0')"
		  then
		    sudo sed -i '/sudo pkill filebrowser/s//if [ \! -d "\/roms2\/advision\/" ]\; then\n      sudo mkdir \/roms2\/advision\n  fi\n  sudo pkill filebrowser/' /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh
		  else
		    printf "\nAdventure Vision is already being accounted for in the switch to sd2 script\n" | tee -a "$LOG_FILE"
		  fi
		fi
		cd /roms/themes/es-theme-nes-box
		sudo git fetch --all | tee -a "$LOG_FILE"
		sudo git reset --hard origin/master | tee -a "$LOG_FILE"
		sudo git pull | tee -a "$LOG_FILE"
		cd /home/ark
        sudo rm -fv /home/ark/update_neogeocd.txt | tee -a "$LOG_FILE"
		sudo rm -v /home/ark/add_advision.txt | tee -a "$LOG_FILE"
        sudo rm -fv /dev/shm/arkosupdate04272023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate04272023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	if { [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; } && [ -z "$(grep "RK2023" /home/ark/.config/.DEVICE | tr -d '\0')" ]; then
	  printf "\nUpdate enable_vibration script\n" | tee -a "$LOG_FILE"
	  if test -z "$(grep 'chmod 777 /sys/class/pwm/pwmchip1/pwm0/duty_cycle' /usr/local/bin/enable_vibration.sh | tr -d '\0')"
	  then
	    echo "sudo chmod 777 /sys/class/pwm/pwmchip1/pwm0/duty_cycle" | sudo tee -a /usr/local/bin/enable_vibration.sh | tee -a "$LOG_FILE"
	    echo "sudo chmod 777 /sys/class/pwm/pwmchip1/pwm0/period" | sudo tee -a /usr/local/bin/enable_vibration.sh | tee -a "$LOG_FILE"
	  else
	    printf " Looks like it's already supported for this device. " | tee -a "$LOG_FILE"
	  fi
	fi

	printf "\nUpdate retroarch only mode to default to performance governor\n" | tee -a "$LOG_FILE"
	if test -z "$(grep 'echo performance' /usr/bin/emulationstation/emulationstation.sh.ra | tr -d '\0')"
	then
	  if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	    sudo sed -i '/retroarch \"\$@\"/s//echo performance \| sudo tee \/sys\/devices\/platform\/fde60000.gpu\/devfreq\/fde60000.gpu\/governor\n      echo performance \| sudo tee \/sys\/devices\/system\/cpu\/cpufreq\/policy0\/scaling_governor\n      echo performance \| sudo tee \/sys\/devices\/platform\/dmc\/devfreq\/dmc\/governor\n      retroarch \"\$@\"/' /usr/bin/emulationstation/emulationstation.sh
	    sudo sed -i '/retroarch \"\$@\"/s//echo performance \| sudo tee \/sys\/devices\/platform\/fde60000.gpu\/devfreq\/fde60000.gpu\/governor\n      echo performance \| sudo tee \/sys\/devices\/system\/cpu\/cpufreq\/policy0\/scaling_governor\n      echo performance \| sudo tee \/sys\/devices\/platform\/dmc\/devfreq\/dmc\/governor\n      retroarch \"\$@\"/' /usr/bin/emulationstation/emulationstation.sh.ra
	  else
	    sudo sed -i '/retroarch \"\$@\"/s//echo performance \| sudo tee \/sys\/devices\/platform\/ff400000.gpu\/devfreq\/ff400000.gpu\/governor\n      echo performance \| sudo tee \/sys\/devices\/system\/cpu\/cpufreq\/policy0\/scaling_governor\n      echo performance \| sudo tee \/sys\/devices\/platform\/dmc\/devfreq\/dmc\/governor\n      retroarch \"\$@\"/' /usr/bin/emulationstation/emulationstation.sh
	    sudo sed -i '/retroarch \"\$@\"/s//echo performance \| sudo tee \/sys\/devices\/platform\/ff400000.gpu\/devfreq\/ff400000.gpu\/governor\n      echo performance \| sudo tee \/sys\/devices\/system\/cpu\/cpufreq\/policy0\/scaling_governor\n      echo performance \| sudo tee \/sys\/devices\/platform\/dmc\/devfreq\/dmc\/governor\n      retroarch \"\$@\"/' /usr/bin/emulationstation/emulationstation.sh.ra
	  fi
	else
	  printf " Looks like the performance governor for retroarch only mode is already set for this device. " | tee -a "$LOG_FILE"
	fi

	printf "\nReplace simple_ondemand cpu governor with dmc_ondemand\n" | tee -a "$LOG_FILE"
	if test ! -z "$(grep 'echo simple_ondemand' /usr/local/bin/perfmax.pic | tr -d '\0')"
	then
	  sudo sed -i 's/echo simple_ondemand/echo dmc_ondemand/' /usr/local/bin/perfmax
	  sudo sed -i 's/echo simple_ondemand/echo dmc_ondemand/' /usr/local/bin/perfmax.pic
	  sudo sed -i 's/echo simple_ondemand/echo dmc_ondemand/' /usr/local/bin/perfmax.asc
	  sudo sed -i 's/echo simple_ondemand/echo dmc_ondemand/' /usr/local/bin/perfnorm
	  sudo sed -i 's/echo simple_ondemand/echo dmc_ondemand/' /usr/local/bin/perfnorm.pic
	  sudo sed -i 's/echo simple_ondemand/echo dmc_ondemand/' /usr/local/bin/perfnorm.asc
	fi

	printf "\nCopy correct Hypseus-Singe for device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
      rm -fv /opt/hypseus-singe/hypseus-singe.rk3326 | tee -a "$LOG_FILE"
    else
      mv -fv /opt/hypseus-singe/hypseus-singe.rk3326 /opt/hypseus-singe/hypseus-singe | tee -a "$LOG_FILE"
	fi

	printf "\nAdd puae2021 libreto for amiga to ES\n" | tee -a "$LOG_FILE"
	if test -z "$(grep -Pzo "puae2021.*(\n|.)*<platform>amiga<" /etc/emulationstation/es_systems.cfg | tr -d '\0')"
	then
	  sed -i '0,/<core>puae<\/core>/s/<core>puae<\/core>/<core>puae2021<\/core>\n\t\t\t  <core>puae<\/core>/' /etc/emulationstation/es_systems.cfg
	fi

	printf "\nAdd .cmd extension support for PC98\n" | tee -a "$LOG_FILE"
	sed -i '/<extension>.d88 .D88 .fdi .FDI .hdi .HDI .zip .ZIP<\/extension>/s//<extension>.cmd .CMD .d88 .D88 .fdi .FDI .hdi .HDI .zip .ZIP<\/extension>/' /etc/emulationstation/es_systems.cfg

	if test ! -z "$(grep "RG353" /home/ark/.config/.DEVICE | tr -d '\0')"
	then
	  printf "\nCopy updated kernel and dtb with multipanel support based on device\n" | tee -a "$LOG_FILE"
	  if [ -f "/home/ark/.config/.DEVICE" ]; then
	    if test ! -z "$(grep "RG353V" /home/ark/.config/.DEVICE | tr -d '\0')"
	    then
	      sudo mv -fv /home/ark/v1v2/Image.353 /boot/Image | tee -a "$LOG_FILE"
		  sudo mv -fv /home/ark/v1v2/rk3566-353v.dtb /boot/rk3566-OC.dtb | tee -a "$LOG_FILE"
		  sudo rm -rfv /home/ark/v1v2 | tee -a "$LOG_FILE"
		  sudo rm -rfv /boot/rk3566-OC.dtb.orig | tee -a "$LOG_FILE"
		  sudo rm -rfv /boot/rk3566-OC.dtb.tony | tee -a "$LOG_FILE"
		  sudo rm -fv /opt/system/Advanced/Screen* | tee -a "$LOG_FILE"
	    elif test ! -z "$(grep "RG353M" /home/ark/.config/.DEVICE | tr -d '\0')"
		then
	      sudo mv -fv /home/ark/v1v2/Image.353 /boot/Image | tee -a "$LOG_FILE"
		  sudo mv -fv /home/ark/v1v2/rk3566-353m.dtb /boot/rk3566-OC.dtb | tee -a "$LOG_FILE"
		  sudo rm -rfv /home/ark/v1v2 | tee -a "$LOG_FILE"
		  sudo rm -rfv /boot/rk3566-OC.dtb.orig | tee -a "$LOG_FILE"
		  sudo rm -rfv /boot/rk3566-OC.dtb.tony | tee -a "$LOG_FILE"
		  sudo rm -fv /opt/system/Advanced/Screen* | tee -a "$LOG_FILE"
	    elif test ! -z "$(grep "RK2023" /home/ark/.config/.DEVICE | tr -d '\0')"
		then
		  sudo mv -fv /home/ark/v1v2/rk3566-rk2023.dtb /boot/rk3566-OC.dtb | tee -a "$LOG_FILE"
		  sudo rm -rfv /home/ark/v1v2 | tee -a "$LOG_FILE"
		else 
		  sudo rm -rfv /home/ark/v1v2/ | tee -a "$LOG_FILE"
		fi
	  else
		sudo rm -rfv /home/ark/v1v2/ | tee -a "$LOG_FILE"
	  fi
	fi

	printf "\nCopy correct Retroarches depending on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  cp -fv /opt/retroarch/bin/retroarch32.rk3326.unrot /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
	  cp -fv /opt/retroarch/bin/retroarch.rk3326.unrot /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-odroidgo2-linux.dtb" ] || [ -f "/boot/rk3326-odroidgo2-linux-v11.dtb" ] || [ -f "/boot/rk3326-odroidgo3-linux.dtb" ]; then
	  cp -fv /opt/retroarch/bin/retroarch32.rk3326.rot /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
	  cp -fv /opt/retroarch/bin/retroarch.rk3326.rot /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	else
	  rm -fv /opt/retroarch/bin/retroarch.* | tee -a "$LOG_FILE"
	  rm -fv /opt/retroarch/bin/retroarch32.* | tee -a "$LOG_FILE"
	fi

	printf "\nUpdate audio filters directory in retroarch and retroarch32 configs\n" | tee -a "$LOG_FILE"
	sed -i "/audio_filter_dir = \"/c\\audio_filter_dir = \"~\/.config\/retroarch\/filters\/audio\"" /home/ark/.config/retroarch/retroarch.cfg
	sed -i "/audio_filter_dir = \"/c\\audio_filter_dir = \"~\/.config\/retroarch\/filters\/audio\"" /home/ark/.config/retroarch/retroarch.cfg.bak
	sed -i "/audio_filter_dir = \"/c\\audio_filter_dir = \"~\/.config\/retroarch32\/filters\/audio\"" /home/ark/.config/retroarch32/retroarch.cfg
	sed -i "/audio_filter_dir = \"/c\\audio_filter_dir = \"~\/.config\/retroarch32\/filters\/audio\"" /home/ark/.config/retroarch32/retroarch.cfg.bak

	printf "\nInstall and link new SDL 2.0.2600.5 (aka SDL 2.0.26.5)\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  sudo mv -f -v /home/ark/sdl2-64/libSDL2-2.0.so.0.2600.5.rk3566 /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2600.5 | tee -a "$LOG_FILE"
	  sudo mv -f -v /home/ark/sdl2-32/libSDL2-2.0.so.0.2600.5.rk3566 /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2600.5 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-32 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-64 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2.so /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2600.5 /usr/lib/aarch64-linux-gnu/libSDL2.so | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2.so /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2600.5 /usr/lib/arm-linux-gnueabihf/libSDL2.so | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  sudo mv -f -v /home/ark/sdl2-64/libSDL2-2.0.so.0.2600.5.rk3326 /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2600.5 | tee -a "$LOG_FILE"
	  sudo mv -f -v /home/ark/sdl2-32/libSDL2-2.0.so.0.2600.5.rk3326 /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2600.5 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-32 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-64 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2.so /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2600.5 /usr/lib/aarch64-linux-gnu/libSDL2.so | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2.so /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2600.5 /usr/lib/arm-linux-gnueabihf/libSDL2.so | tee -a "$LOG_FILE"
	else
	  sudo mv -f -v /home/ark/sdl2-64/libSDL2-2.0.so.0.2600.5.rotated /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2600.5 | tee -a "$LOG_FILE"
	  sudo mv -f -v /home/ark/sdl2-32/libSDL2-2.0.so.0.2600.5.rotated /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2600.5 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-64 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-32 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2.so /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2600.5 /usr/lib/aarch64-linux-gnu/libSDL2.so | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2.so /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2600.5 /usr/lib/arm-linux-gnueabihf/libSDL2.so | tee -a "$LOG_FILE"
	fi

	printf "\nMake sure permissions for the ark home directory are set to 755\n" | tee -a "$LOG_FILE"
	sudo chown -R ark:ark /home/ark
	sudo chmod -R 755 /home/ark

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update04272023"

fi

if [ ! -f "/home/ark/.config/.update05042023" ]; then

	printf "\nUpdated PPSSPP to 1.15.0\nUpdated emulationstation to include panel id info in display settings for RG353 devices only\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/05042023/arkosupdate05042023.zip -O /dev/shm/arkosupdate05042023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate05042023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate05042023.zip" ]; then
		if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
          sudo unzip -X -o /dev/shm/arkosupdate05042023.zip -x opt/ppsspp/assets/gamecontrollerdb.txt -d / | tee -a "$LOG_FILE"
		else
          sudo unzip -X -o /dev/shm/arkosupdate05042023.zip -x opt/ppsspp/assets/gamecontrollerdb.txt usr/bin/emulationstation/emulationstation usr/local/bin/panel_id.sh -d / | tee -a "$LOG_FILE"
		fi
        sudo rm -fv /dev/shm/arkosupdate05042023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate05042023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	if test ! -z "$(grep "RG353" /home/ark/.config/.DEVICE | tr -d '\0')"
	then
	  printf "\nAdd check on boot for panel info\n" | tee -a "$LOG_FILE"
	  if test -z "$(sudo cat /var/spool/cron/crontabs/root | grep 'panel id' | tr -d '\0')"
	  then
	    echo "@reboot dmesg | grep 'panel id' > /home/ark/.config/.panel_info &" | sudo tee -a /var/spool/cron/crontabs/root | tee -a "$LOG_FILE"
	  else
	    printf " Check has already been added to crontab.  No need to do it again." | tee -a "$LOG_FILE"
	  fi
	fi

	printf "\nCopy correct emulationstation depending on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  sudo mv -fv /usr/bin/emulationstation/emulationstation.351v /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-odroidgo2-linux.dtb" ] || [ -f "/boot/rk3326-odroidgo2-linux-v11.dtb" ] || [ -f "/boot/rk3326-odroidgo3-linux.dtb" ]; then
	  test=$(stat -c %s "/usr/bin/emulationstation/emulationstation")
	  if [ "$test" = "3281744" ]; then
	    sudo cp -fv /usr/bin/emulationstation/emulationstation.351v /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
		sudo mv -fv /usr/bin/emulationstation/emulationstation.351v /usr/bin/emulationstation/emulationstation.fullscreen | tee -a "$LOG_FILE"
	  else
	    sudo mv -fv /usr/bin/emulationstation/emulationstation.351v /usr/bin/emulationstation/emulationstation.fullscreen | tee -a "$LOG_FILE"
	  fi
	else
	  sudo rm -fv /usr/bin/emulationstation/emulationstation.351v | tee -a "$LOG_FILE"
	fi
	
	printf "\nRemoving showbatteryindicator setting from es_settings.cfg file\n" | tee -a "$LOG_FILE"
	sed -i "/<bool name\=\"ShowBatteryIndicator\"/d " /home/ark/.emulationstation/es_settings.cfg

	printf "\nCopy correct PPSSPPSDL for device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
      rm -fv /opt/ppsspp/PPSSPPSDL.rk3326 | tee -a "$LOG_FILE"
    else
      mv -fv /opt/ppsspp/PPSSPPSDL.rk3326 /opt/ppsspp/PPSSPPSDL | tee -a "$LOG_FILE"
	fi

	if [ ! -f "/boot/rk3566.dtb" ] || [ ! -f "/boot/rk3566-OC.dtb" ]; then
	  printf "\nRevert schedutil default cpu governor back to interactive for rk3326 devices\n" | tee -a "$LOG_FILE"
	  if test ! -z "$(grep 'echo schedutil' /usr/local/bin/perfmax.pic | tr -d '\0')"
	  then
	    sudo sed -i 's/echo schedutil/echo interactive/' /usr/local/bin/perfmax
	    sudo sed -i 's/echo schedutil/echo interactive/' /usr/local/bin/perfmax.pic
	    sudo sed -i 's/echo schedutil/echo interactive/' /usr/local/bin/perfmax.asc
	  else
	    printf " Not needed as it seems to have been done already." | tee -a "$LOG_FILE"
	  fi
	fi

	if test -z "$(cat /etc/fstab | grep roms2 | tr -d '\0')"
	then
	  printf "\nFixed Amiga, Amiga CD32, Dreamcast and Microvision not showing up with single sd card setup\n" | tee -a "$LOG_FILE"
	  sed -i '/<path>\/roms2\//s//<path>\/roms\//g' /etc/emulationstation/es_systems.cfg
	fi

	printf "\nRemove .m3u support from ES for Amiga and Amiga CD32\n" | tee -a "$LOG_FILE"
	sed -i '/<extension>.lha .LHA .hdf .HDF .adf .ADF .m3u .M3U .zip .ZIP<\/extension>/s//<extension>.lha .LHA .hdf .HDF .adf .ADF .zip .ZIP<\/extension>/' /etc/emulationstation/es_systems.cfg
	sed -i '/<extension>.chd .CHD .cue .CUE .ccd .CCD .lha .LHA .nrg .NRG .mds .MDS .iso .ISO .m3u .M3U<\/extension>/s//<extension>.chd .CHD .cue .CUE .ccd .CCD .lha .LHA .nrg .NRG .mds .MDS .iso .ISO<\/extension>/' /etc/emulationstation/es_systems.cfg

	printf "\nFix some GlideN64 plugin settings\n" | tee -a "$LOG_FILE"
	sed -i "/UseNativeResolutionFactor \=/c\UseNativeResolutionFactor \= 1" /home/ark/.config/mupen64plus/mupen64plus.cfg
	sed -i "/ThreadedVideo \=/c\ThreadedVideo \= True" /home/ark/.config/mupen64plus/mupen64plus.cfg

	printf "\nMake sure permissions for the ark home directory are set to 755\n" | tee -a "$LOG_FILE"
	sudo chown -R ark:ark /home/ark
	sudo chmod -R 755 /home/ark

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update05042023"

fi

if [ ! -f "/home/ark/.config/.update05112023" ]; then

	printf "\nUpdate PPSSPP standalone\nUpdate hypseus-singe to 2.10.4\nRevert rg353 v1 screen timings\nUpdate uboot for rk2023 and rg353 devices\nAdd rtl8812au wifi driver for rk2023\nAdd Gearsystem for sega master system and game gear\nAdd picodrive for game gear\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/05112023/arkosupdate05112023.zip -O /dev/shm/arkosupdate05112023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate05112023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate05112023.zip" ]; then
		if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
		  if test ! -z "$(grep "RK2023" /home/ark/.config/.DEVICE | tr -d '\0')"
		  then
            sudo unzip -X -o /dev/shm/arkosupdate05112023.zip -d / | tee -a "$LOG_FILE"
		  elif test ! -z "$(grep "RG353" /home/ark/.config/.DEVICE | tr -d '\0')"
		  then
		    sudo unzip -X -o /dev/shm/arkosupdate05112023.zip -x usr/lib/modules/4.19.172/kernel/drivers/net/wireless/rtl8812au.ko -d / | tee -a "$LOG_FILE"
		  else
		    sudo unzip -X -o /dev/shm/arkosupdate05112023.zip -x home/ark/uboot.img.rk2023 usr/lib/modules/4.19.172/kernel/drivers/net/wireless/rtl8812au.ko -d / | tee -a "$LOG_FILE"
		  fi
		else
          sudo unzip -X -o /dev/shm/arkosupdate05112023.zip -x home/ark/uboot.img.rk2023 usr/lib/modules/4.19.172/kernel/drivers/net/wireless/rtl8812au.ko -d / | tee -a "$LOG_FILE"
		fi
		cp -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update05112023.bak | tee -a "$LOG_FILE"
		sed -i '/<name>gamegear<\/name>/,/<platform>gamegear<\/platform>/{//!d}' /etc/emulationstation/es_systems.cfg
		sed -i -e '/<name>gamegear<\/name>/{r /home/ark/update_gamegear.txt' -e 'd}' /etc/emulationstation/es_systems.cfg
		sed -i '/<name>mastersystem<\/name>/,/<platform>mastersystem<\/platform>/{//!d}' /etc/emulationstation/es_systems.cfg
		sed -i -e '/<name>mastersystem<\/name>/{r /home/ark/update_mastersystem.txt' -e 'd}' /etc/emulationstation/es_systems.cfg
		if test ! -z "$(cat /etc/fstab | grep roms2 | tr -d '\0')"
		then
		  sed -i '/<path>\/roms\/gamegear/s//<path>\/roms2\/gamegear/g' /etc/emulationstation/es_systems.cfg
		  sed -i '/<path>\/roms\/mastersystem/s//<path>\/roms2\/mastersystem/g' /etc/emulationstation/es_systems.cfg
		fi
		sudo rm -fv /home/ark/update_gamegear.txt | tee -a "$LOG_FILE"
		sudo rm -fv /home/ark/update_mastersystem.txt | tee -a "$LOG_FILE"
        sudo rm -fv /dev/shm/arkosupdate05112023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate05112023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCopy correct Hypseus-Singe for device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
      rm -fv /opt/hypseus-singe/hypseus-singe.rk3326 | tee -a "$LOG_FILE"
    else
      mv -fv /opt/hypseus-singe/hypseus-singe.rk3326 /opt/hypseus-singe/hypseus-singe | tee -a "$LOG_FILE"
	fi

	if test ! -z "$(grep "RK2023" /home/ark/.config/.DEVICE | tr -d '\0')"
	then
	  printf "\nAdd rtl8812au wifi driver\n" | tee -a "$LOG_FILE"
	  sudo depmod -a
	fi

	printf "\nCopy correct latest PPSSPPSDL for device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
      rm -fv /opt/ppsspp/PPSSPPSDL.rk3326 | tee -a "$LOG_FILE"
    else
      mv -fv /opt/ppsspp/PPSSPPSDL.rk3326 /opt/ppsspp/PPSSPPSDL | tee -a "$LOG_FILE"
	fi

	if [ -f "/home/ark/.config/.DEVICE" ]; then
	  if [ ! -z "$(grep "RG353" /home/ark/.config/.DEVICE | tr -d '\0')" ] || [ ! -z "$(grep "RK2023" /home/ark/.config/.DEVICE | tr -d '\0')" ]; then
	    printf "\nUpdating uboot...\n" | tee -a "$LOG_FILE"
	    sudo dd if=/home/ark/uboot.img.rk2023 of=/dev/mmcblk1 bs=512 count=8192 seek=16384 | tee -a "$LOG_FILE"
	    sudo rm -f /home/ark/uboot.img.rk2023 | tee -a "$LOG_FILE"
	  fi
	fi

	printf "\nMake sure permissions for the ark home directory are set to 755\n" | tee -a "$LOG_FILE"
	sudo chown -R ark:ark /home/ark
	sudo chmod -R 755 /home/ark

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update05112023"

fi

if [ ! -f "/home/ark/.config/.update05172023" ]; then

	printf "\nUpdate sleep script to go to powersave on sleep then restore previous governors on wake\nFix Deep sleep for 353 and rk2023\nUpdate Restore Settings script to check for a backup file in the roms backup folder\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/05172023/arkosupdate05172023.zip -O /dev/shm/arkosupdate05172023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate05172023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate05172023.zip" ]; then
		if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
		  if test ! -z "$(grep "RK2023" /home/ark/.config/.DEVICE | tr -d '\0')"
		  then
            sudo unzip -X -o /dev/shm/arkosupdate05172023.zip -d / | tee -a "$LOG_FILE"
		  elif test ! -z "$(grep "RG353" /home/ark/.config/.DEVICE | tr -d '\0')"
		  then
		    sudo unzip -X -o /dev/shm/arkosupdate05172023.zip -d / | tee -a "$LOG_FILE"
		  else
		    sudo unzip -X -o /dev/shm/arkosupdate05172023.zip -x usr/local/bin/sleep_governors.sh lib/systemd/system-sleep/sleep "usr/local/bin/uboot.img.*" "usr/local/bin/Sleep\ -\ Switch\ to\ Deep\ sleep\ support.sh" "usr/local/bin/Sleep\ -\ Switch\ to\ Light\ sleep\ support.sh" -d / | tee -a "$LOG_FILE"
		  fi
		else
          sudo unzip -X -o /dev/shm/arkosupdate05172023.zip -x usr/local/bin/sleep_governors.sh lib/systemd/system-sleep/sleep "usr/local/bin/uboot.img.*" "usr/local/bin/Sleep\ -\ Switch\ to\ Deep\ sleep\ support.sh" "usr/local/bin/Sleep\ -\ Switch\ to\ Light\ sleep\ support.sh" -d / | tee -a "$LOG_FILE"
		fi
        sudo rm -fv /dev/shm/arkosupdate05172023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate05172023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  printf "\nRevert schedutil default cpu governor back to interactive for rk3566 devices\n" | tee -a "$LOG_FILE"
	  if test ! -z "$(grep 'echo schedutil' /usr/local/bin/perfmax.pic | tr -d '\0')"
	  then
	    sudo sed -i 's/echo schedutil/echo interactive/' /usr/local/bin/perfmax
	    sudo sed -i 's/echo schedutil/echo interactive/' /usr/local/bin/perfmax.pic
	    sudo sed -i 's/echo schedutil/echo interactive/' /usr/local/bin/perfmax.asc
	    sudo sed -i 's/echo ondemand/echo interactive/' /usr/local/bin/perfnorm
	    sudo sed -i 's/echo ondemand/echo interactive/' /usr/local/bin/perfnorm.pic
	    sudo sed -i 's/echo ondemand/echo interactive/' /usr/local/bin/perfnorm.asc
	  else
	    printf " Not needed as it seems to have been done already." | tee -a "$LOG_FILE"
	  fi
	fi

	printf "\nCopy correct emulationstation depending on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  sudo mv -fv /home/ark/emulationstation.351v /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-odroidgo2-linux.dtb" ] || [ -f "/boot/rk3326-odroidgo2-linux-v11.dtb" ] || [ -f "/boot/rk3326-odroidgo3-linux.dtb" ]; then
	  test=$(stat -c %s "/usr/bin/emulationstation/emulationstation")
	  if [ "$test" = "3302224" ]; then
	    sudo cp -fv /home/ark/emulationstation.351v /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  elif [ -f "/home/ark/.config/.DEVICE" ]; then
		sudo cp -fv /home/ark/emulationstation.rgb10max /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  else
	    sudo cp -fv /home/ark/emulationstation.header /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  fi
	  if [ -f "/home/ark/.config/.DEVICE" ]; then
	    sudo cp -fv /home/ark/emulationstation.rgb10max /usr/bin/emulationstation/emulationstation.header | tee -a "$LOG_FILE"
	  else
	    sudo cp -fv /home/ark/emulationstation.header /usr/bin/emulationstation/emulationstation.header | tee -a "$LOG_FILE"
	  fi
	  sudo cp -fv /home/ark/emulationstation.351v /usr/bin/emulationstation/emulationstation.fullscreen | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  sudo mv -fv /home/ark/emulationstation.503 /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	fi

	printf "\nFix Backup of symlinks in Backup Settings script\n" | tee -a "$LOG_FILE"
	sed -i 's/sudo tar -zchvf/sudo tar -zcvf/' /opt/system/Advanced/Backup\ Settings.sh
	sudo rm -f /opt/system/Advanced/Restore\ ArkOS\ Settings.sh | tee -a "$LOG_FILE"

	if test ! -z "$(grep "RK2023" /home/ark/.config/.DEVICE | tr -d '\0')"
	then
	  printf "\nCopying updated sleep script to Options/Advanced section\n" | tee -a "$LOG_FILE"
	  if [ -f "/opt/system/Advanced/Sleep - Switch to Deep sleep support.sh" ]; then
	    cp -fv /usr/local/bin/"Sleep - Switch to Deep sleep support.sh" /opt/system/Advanced/"Sleep - Switch to Deep sleep support.sh" | tee -a "$LOG_FILE"
	    sudo dd if=/usr/local/bin/uboot.img.anbernic of=/dev/mmcblk1 conv=notrunc bs=512 seek=16384 | tee -a "$LOG_FILE"
	  elif [ -f "/opt/system/Advanced/Sleep - Switch to Light sleep support.sh" ]; then
	    cp -fv /usr/local/bin/"Sleep - Switch to Light sleep support.sh" /opt/system/Advanced/"Sleep - Switch to Light sleep support.sh" | tee -a "$LOG_FILE"
	  fi
	elif test ! -z "$(grep "RG353" /home/ark/.config/.DEVICE | tr -d '\0')"
	then
	  printf "\nCopying updated sleep script to Options/Advanced section\n" | tee -a "$LOG_FILE"
	  if [ -f "/opt/system/Advanced/Sleep - Switch to Deep sleep support.sh" ]; then
	    cp -fv /usr/local/bin/"Sleep - Switch to Deep sleep support.sh" /opt/system/Advanced/"Sleep - Switch to Deep sleep support.sh" | tee -a "$LOG_FILE"
	    sudo dd if=/usr/local/bin/uboot.img.anbernic of=/dev/mmcblk1 conv=notrunc bs=512 seek=16384 | tee -a "$LOG_FILE"
	  elif [ -f "/opt/system/Advanced/Sleep - Switch to Light sleep support.sh" ]; then
	    cp -fv /usr/local/bin/"Sleep - Switch to Light sleep support.sh" /opt/system/Advanced/"Sleep - Switch to Light sleep support.sh" | tee -a "$LOG_FILE"
	  fi
	fi
		
	printf "\nMake sure permissions for the ark home directory are set to 755\n" | tee -a "$LOG_FILE"
	sudo chown -R ark:ark /home/ark
	sudo chmod -R 755 /home/ark

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update05172023"

fi

if [ ! -f "/home/ark/.config/.update06012023" ]; then

	printf "\nAdd retroarch and retroarch32 core options to backup script\nAdd missing assets for scummvm touch\nFix scummvm save location for sd2 setup and script\nAdd retroarch32 with touch support\nUpdate retroarch touch\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/06012023/arkosupdate06012023.zip -O /dev/shm/arkosupdate06012023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate06012023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate06012023.zip" ]; then
		if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
		  if [ ! -z "$(grep "RG353M" /home/ark/.config/.DEVICE | tr -d '\0')" ] || [ ! -z "$(grep "RG353V" /home/ark/.config/.DEVICE | tr -d '\0')" ]; then
	        sudo unzip -X -o /dev/shm/arkosupdate06012023.zip -d / | tee -a "$LOG_FILE"
		  else
		    sudo unzip -X -o /dev/shm/arkosupdate06012023.zip -x "opt/retroarch/bin/retroarch*" "usr/local/bin/experimental/*" -d / | tee -a "$LOG_FILE"
		  fi
		else
          sudo unzip -X -o /dev/shm/arkosupdate06012023.zip -x "opt/retroarch/bin/retroarch*" "usr/local/bin/experimental/*" -d / | tee -a "$LOG_FILE"
		fi
        sudo rm -fv /dev/shm/arkosupdate06012023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate06012023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	if [ ! -z "$(grep "RG353M" /home/ark/.config/.DEVICE | tr -d '\0')" ] || [ ! -z "$(grep "RG353V" /home/ark/.config/.DEVICE | tr -d '\0')" ]; then
	  printf "\nSyncing missing assets from scummvm to scummvm.touch folder...\n" | tee -a "$LOG_FILE"
	  if [ -f "/opt/system/Advanced/Enable Experimental Touch support.sh" ]; then
	    rsync --ignore-existing -av /opt/scummvm/ /opt/scummvm.touch/ | tee -a "$LOG_FILE"
	  else
	    rsync --ignore-existing -av /opt/scummvm.orig/ /opt/scummvm/ | tee -a "$LOG_FILE"
	  fi
	fi

	if [ ! -z "$(grep "RG353M" /home/ark/.config/.DEVICE | tr -d '\0')" ] || [ ! -z "$(grep "RG353V" /home/ark/.config/.DEVICE | tr -d '\0')" ]; then
	  printf "\nUpdate Experimental Touch support script...\n" | tee -a "$LOG_FILE"
	  if [ -f "/opt/system/Advanced/Enable Experimental Touch support.sh" ]; then
	    cp -fv /usr/local/bin/experimental/Enable\ Experimental\ Touch\ support.sh /opt/system/Advanced/Enable\ Experimental\ Touch\ support.sh | tee -a "$LOG_FILE"
	  else
	    cp -fv /opt/retroarch/bin/retroarch32.touch /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
	    cp -fv /opt/retroarch/bin/retroarch.touch /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
	    cp -fv /usr/local/bin/experimental/Disable\ Experimental\ Touch\ support.sh /opt/system/Advanced/Disable\ Experimental\ Touch\ support.sh | tee -a "$LOG_FILE"
	  fi
	fi

	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ] || [ -f "/boot/rk3566.dtb" ]; then
	  printf "\nFix ScummVM game save location not changing to roms2 when using 2 sd card setup" | tee -a "$LOG_FILE"
	  if test -z "$(grep "/home/ark/.config/scummvm/scummvm.ini" /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh | tr -d '\0')"
	  then
	    sudo sed -i "s+\/roms2\/bios\/scummvm.ini+\/roms2\/bios\/scummvm.ini\n  sed -i \'/roms\\\//s//roms2\\\//g\\' \/home\/ark\/.config\/scummvm\/scummvm.ini+g" /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh
		sudo sed -i "s+/opt/amiberry/conf/amiberry.conf+/opt/amiberry/conf/amiberry.conf\n  sed -i \'/roms2\\\//s//roms\\\//g\\' \/home\/ark\/.config\/scummvm\/scummvm.ini+g" /usr/local/bin/Switch\ to\ main\ SD\ for\ Roms.sh
	    sed -i "s+\/roms2\/bios\/scummvm.ini+\/roms2\/bios\/scummvm.ini\n  sed -i \'/roms\\\//s//roms2\\\//g\\' \/home\/ark\/.config\/scummvm\/scummvm.ini+g" /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh
		if test ! -z "$(cat /etc/fstab | grep roms2 | tr -d '\0')"
		then
		  sed -i '/roms\/scummvm/s//roms2\/scummvm/g' /home/ark/.config/scummvm/scummvm.ini
		  rsync --ignore-existing -av /roms/scummvm/ /roms2/scummvm/ --exclude menu.scummvm --exclude Scan_for_new_games.scummvm | tee -a "$LOG_FILE"
		  sed -i "s+/opt/amiberry/conf/amiberry.conf+/opt/amiberry/conf/amiberry.conf\n  sed -i \'/roms2\\\//s//roms\\\//g\\' \/home\/ark\/.config\/scummvm\/scummvm.ini+g" /opt/system/Advanced/Switch\ to\ main\ SD\ for\ Roms.sh
		else
		  sed -i "s+\/roms2\/bios\/scummvm.ini+\/roms2\/bios\/scummvm.ini\n  sed -i \'/roms\\\//s//roms2\\\//g\\' \/home\/ark\/.config\/scummvm\/scummvm.ini+g" /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh
		fi
	  else
	    printf "\nThis fix was already applied.  No need to do it again." | tee -a "$LOG_FILE"
	  fi
	fi

	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ]; then
	  printf "\nRemove standalone-stock from ES menu\n" | tee -a "$LOG_FILE"
	  cp -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update06012023.bak | tee -a "$LOG_FILE"
	  sed -i '/standalone-stock/,+1d' /etc/emulationstation/es_systems.cfg
	fi

	printf "\nCopy correct PPSSPPSDL for device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
      rm -fv /opt/ppsspp/PPSSPPSDL.rk3326 | tee -a "$LOG_FILE"
    else
      mv -fv /opt/ppsspp/PPSSPPSDL.rk3326 /opt/ppsspp/PPSSPPSDL | tee -a "$LOG_FILE"
	fi

	printf "\nMake sure permissions for the ark home directory are set to 755\n" | tee -a "$LOG_FILE"
	sudo chown -R ark:ark /home/ark
	sudo chmod -R 755 /home/ark

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update06012023"

fi

if [ ! -f "/home/ark/.config/.update06222023" ]; then

	printf "\nUpdate emulationstation with 12hr clock and potential black screen on return from gaming\nAdd RACE libretro core\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/06222023/arkosupdate06222023.zip -O /dev/shm/arkosupdate06222023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate06222023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate06222023.zip" ]; then
		sudo unzip -X -o /dev/shm/arkosupdate06222023.zip -d / | tee -a "$LOG_FILE"
		cp -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update06222023.bak | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate06222023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate06222023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCopy correct emulationstation depending on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  sudo mv -fv /home/ark/emulationstation.351v /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-odroidgo2-linux.dtb" ] || [ -f "/boot/rk3326-odroidgo2-linux-v11.dtb" ] || [ -f "/boot/rk3326-odroidgo3-linux.dtb" ]; then
	  test=$(stat -c %s "/usr/bin/emulationstation/emulationstation")
	  if [ "$test" = "3306320" ]; then
	    sudo cp -fv /home/ark/emulationstation.351v /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  elif [ -f "/home/ark/.config/.DEVICE" ]; then
		sudo cp -fv /home/ark/emulationstation.rgb10max /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  else
	    sudo cp -fv /home/ark/emulationstation.header /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  fi
	  if [ -f "/home/ark/.config/.DEVICE" ]; then
	    sudo cp -fv /home/ark/emulationstation.rgb10max /usr/bin/emulationstation/emulationstation.header | tee -a "$LOG_FILE"
	  else
	    sudo cp -fv /home/ark/emulationstation.header /usr/bin/emulationstation/emulationstation.header | tee -a "$LOG_FILE"
	  fi
	  sudo cp -fv /home/ark/emulationstation.351v /usr/bin/emulationstation/emulationstation.fullscreen | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  sudo mv -fv /home/ark/emulationstation.503 /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	fi

	if test -z "$(grep 'race' /etc/emulationstation/es_systems.cfg | tr -d '\0')"
	then
	  printf "\nAdd RACE libreto for ngp and ngpc to ES\n" | tee -a "$LOG_FILE"
	  sed -i '/<core>mednafen_ngp<\/core>/c\\t\t\t  <core>mednafen_ngp<\/core>\n\t\t\t  <core>race<\/core>' /etc/emulationstation/es_systems.cfg
	fi

	if test -z "$(grep 'gearcoleco' /etc/emulationstation/es_systems.cfg | tr -d '\0')"
	then
	  printf "\nAdd gearcoleco libretro for colecovision to ES\n" | tee -a "$LOG_FILE"
	  sed -i -zE 's/<core>bluemsx<\/core>([^\n]*\n[^\n]*<\/cores>)/<core>bluemsx<\/core>\n\t\t\t  <core>gearcoleco<\/core>\1/' /etc/emulationstation/es_systems.cfg
	fi

	printf "\nAdd .d71 and .d81 extension support for C64 to ES\n" | tee -a "$LOG_FILE"
	sed -i '/<extension>.d64 .D64 .zip .ZIP .7z .7Z .t64 .T64 .crt .CRT .prg .PRG .nib .NIB .tap .TAP .vsf .VSF<\/extension>/s//<extension>.d64 .D64 .d71 .D71 .d81 .D81 .zip .ZIP .7z .7Z .t64 .T64 .crt .CRT .prg .PRG .nib .NIB .tap .TAP .vsf .VSF<\/extension>/' /etc/emulationstation/es_systems.cfg

	printf "\nMake sure permissions for the ark home directory are set to 755\n" | tee -a "$LOG_FILE"
	sudo chown -R ark:ark /home/ark
	sudo chmod -R 755 /home/ark

	printf "\nFix scummvm ability to change key configuration\n" | tee -a "$LOG_FILE"
	sudo cp -fv /usr/local/bin/ti99keydemon.py /usr/local/bin/scummvmkeydemon.py | tee -a "$LOG_FILE"
	sudo chmod 777 /usr/local/bin/scummvmkeydemon.py
	sudo sed -i 's/ti99sim-sdl/scummvm/' /usr/local/bin/scummvmkeydemon.py

	printf "\nFix mednafen emulator horizontal lines issue\n" | tee -a "$LOG_FILE"
	sed -i 's/sms.slstart 0/sms.slstart 24/' /home/ark/.mednafen/mednafen.cfg
	sed -i 's/sms.slend 239/sms.slend 215/' /home/ark/.mednafen/mednafen.cfg
	sed -i 's/sms.slstartp 0/sms.slstartp 8/' /home/ark/.mednafen/mednafen.cfg
	sed -i 's/sms.slendp 239/sms.slendp 231/' /home/ark/.mednafen/mednafen.cfg

	if [ -f "/boot/rk3326-odroidgo2-linux.dtb" ] || [ -f "/boot/rk3326-odroidgo2-linux-v11.dtb" ] || [ -f "/boot/rk3326-odroidgo3-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  printf "\nUpdate perfmax script to not remove .asoundrc file when launching ports\n" | tee -a "$LOG_FILE"
	  if test -z "$(grep '!= "On"' /usr/local/bin/perfmax | tr -d '\0')"
	  then
	    sudo sed -i "/rm \/home\/ark\/.asoundrc/c\if [[ \$1 \!\= \"On\" ]]\; then\n  rm \/home\/ark\/.asoundrc\nfi" /usr/local/bin/perfmax
		sudo sed -i "/rm \/home\/ark\/.asoundrc/c\if [[ \$1 \!\= \"On\" ]]\; then\n  rm \/home\/ark\/.asoundrc\nfi" /usr/local/bin/perfmax.asc
		sudo sed -i "/rm \/home\/ark\/.asoundrc/c\if [[ \$1 \!\= \"On\" ]]\; then\n  rm \/home\/ark\/.asoundrc\nfi" /usr/local/bin/perfmax.pic
	  else
	    printf "  This change is not needed on this installation\n" | tee -a "$LOG_FILE"
	  fi
	fi
	  
	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update06222023"

fi

if [ ! -f "/home/ark/.config/.update07232023" ]; then

	printf "\nAdd ONScripter\nAdd mbrola and US voices for espeak-ng\nAdd Quick Mode\nAdd GZdoom and LZdoom settings reset options\nUpdate pico8 script\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/07232023/arkosupdate07232023.zip -O /dev/shm/arkosupdate07232023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate07232023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate07232023.zip" ]; then
		sudo unzip -X -o /dev/shm/arkosupdate07232023.zip -d / | tee -a "$LOG_FILE"
		cp -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update07232023.bak | tee -a "$LOG_FILE"
		sed -i '/<extension>.32x .32X .smd .SMD .bin .BIN .md .MD .gen .GEN .cue .CUE .iso .ISO .sms .SMS .68k .68K .zip .ZIP .7z .7Z/s//<extension>.32x .32X .smd .SMD .bin .BIN .chd .CHD .md .MD .gen .GEN .cue .CUE .iso .ISO .sms .SMS .68k .68K .zip .ZIP .7z .7Z/' /etc/emulationstation/es_systems.cfg
		if test -z "$(cat /etc/emulationstation/es_systems.cfg | grep onscripter)"
		then
		  sed -i -e '/<theme>microvision<\/theme>/{r /home/ark/add_onscripter.txt' -e 'd}' /etc/emulationstation/es_systems.cfg
		fi
		if [ ! -d "/roms/onscripter" ]; then
		  mkdir -v /roms/onscripter | tee -a "$LOG_FILE"
		  if test ! -z "$(cat /etc/fstab | grep roms2 | tr -d '\0')"
		  then
		    if [ ! -d "/roms2/onscripter" ]; then
		      mkdir -v /roms2/onscripter | tee -a "$LOG_FILE"
			fi
		    sed -i '/<path>\/roms\/onscripter/s//<path>\/roms2\/onscripter/g' /etc/emulationstation/es_systems.cfg
		  fi
		fi
		if [ -f "/opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh" ]; then
		  if test -z "$(cat /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh | grep mv | tr -d '\0')"
		  then
		    sed -i '/sudo pkill filebrowser/s//if [ \! -d "\/roms2\/onscripter\/" ]\; then\n      sudo mkdir \/roms2\/onscripter\n  fi\n  sudo pkill filebrowser/' /opt/system/Advanced/Switch\ to\ SD2\ for\ Roms.sh
		  else
		    printf "\nONScripter is already being accounted for in the switch to sd2 script\n" | tee -a "$LOG_FILE"
		  fi
		fi
		if [ -f "/usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh" ]; then
		  if test -z "$(cat /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh | grep mv | tr -d '\0')"
		  then
		    sudo sed -i '/sudo pkill filebrowser/s//if [ \! -d "\/roms2\/onscripter\/" ]\; then\n      sudo mkdir \/roms2\/onscripter\n  fi\n  sudo pkill filebrowser/' /usr/local/bin/Switch\ to\ SD2\ for\ Roms.sh
		  else
		    printf "\nONScripter is already being accounted for in the switch to sd2 script\n" | tee -a "$LOG_FILE"
		  fi
		fi
		sudo cp -fv /usr/local/bin/finish.sh.orig /usr/local/bin/finish.sh | tee -a "$LOG_FILE"
		sudo rm -fv /home/ark/add_onscripter.txt | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate07232023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate07232023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nInstall espeak-ng package\n" | tee -a "$LOG_FILE"
	sudo apt update -y | tee -a "$LOG_FILE"
	sudo apt install -y espeak-ng | tee -a "$LOG_FILE"

	printf "\nCopy correct updated ogage depending on device\n" | tee -a "$LOG_FILE"
	sudo systemctl stop oga_events
	if [ -e "/dev/input/by-path/platform-ff300000.usb-usb-0:1.2:1.0-event-joystick" ]; then
	  sudo cp -fv /usr/local/bin/ogage.351v /usr/local/bin/ogage | tee -a "$LOG_FILE"
	  sudo rm -fv /usr/local/bin/ogage.* | tee -a "$LOG_FILE"
	elif [ -e "/dev/input/by-path/platform-odroidgo2-joypad-event-joystick" ]; then
		if [ ! -z "$(cat /etc/emulationstation/es_input.cfg | grep "190000004b4800000010000001010000" | tr -d '\0')" ]; then
			sudo cp -fv /usr/local/bin/ogage.rgb10 /usr/local/bin/ogage | tee -a "$LOG_FILE"
			sudo rm -fv /usr/local/bin/ogage.* | tee -a "$LOG_FILE"
		else
			sudo cp -fv /usr/local/bin/ogage.2020 /usr/local/bin/ogage | tee -a "$LOG_FILE"
			sudo rm -fv /usr/local/bin/ogage.* | tee -a "$LOG_FILE"
		fi
	elif [ -e "/dev/input/by-path/platform-odroidgo3-joypad-event-joystick" ]; then
		if [ "$(cat ~/.config/.OS)" = "ArkOS" ] && [ "$(cat ~/.config/.DEVICE)" = "RGB10MAX" ]; then
			sudo cp -fv /usr/local/bin/ogage.rgb10max /usr/local/bin/ogage | tee -a "$LOG_FILE"
			sudo rm -fv /usr/local/bin/ogage.* | tee -a "$LOG_FILE"
		else
			sudo cp -fv /usr/local/bin/ogage.351mp /usr/local/bin/ogage | tee -a "$LOG_FILE"
			sudo rm -fv /usr/local/bin/ogage.* | tee -a "$LOG_FILE"
		fi
	elif [ -e "/dev/input/by-path/platform-gameforce-gamepad-event-joystick" ]; then
		sudo cp -fv /usr/local/bin/ogage.chi /usr/local/bin/ogage | tee -a "$LOG_FILE"
		sudo rm -fv /usr/local/bin/ogage.* | tee -a "$LOG_FILE"
	elif [ ! -z "$(grep "RK2023" /home/ark/.config/.DEVICE | tr -d '\0')" ]; then
		sudo cp -fv /usr/local/bin/ogage.2023 /usr/local/bin/ogage | tee -a "$LOG_FILE"
		sudo rm -fv /usr/local/bin/ogage.* | tee -a "$LOG_FILE"
	elif [ ! -z "$(grep "RG353M" /home/ark/.config/.DEVICE | tr -d '\0')" ] || [ ! -z "$(grep "RG353V" /home/ark/.config/.DEVICE | tr -d '\0')" ]; then
		sudo cp -fv /usr/local/bin/ogage.353 /usr/local/bin/ogage | tee -a "$LOG_FILE"
		sudo rm -fv /usr/local/bin/ogage.* | tee -a "$LOG_FILE"
	elif [ ! -z "$(grep "RG503" /home/ark/.config/.DEVICE | tr -d '\0')" ]; then
		sudo cp -fv /usr/local/bin/ogage.503 /usr/local/bin/ogage | tee -a "$LOG_FILE"
		sudo rm -fv /usr/local/bin/ogage.* | tee -a "$LOG_FILE"
	fi
	sudo systemctl start oga_events

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "/home/ark/.config/.update07232023"

fi

if [ ! -f "$UPDATE_DONE" ]; then

	printf "\nAdd workaround for audio channel issue for RG353V/VS units\nAdd ability to disable and change verbal battery warning\nFix wifi osk does not exit for rk3566 devices\n" | tee -a "$LOG_FILE"
	sudo rm -rf /dev/shm/*
	sudo wget -t 3 -T 60 --no-check-certificate "$LOCATION"/08112023/arkosupdate08112023.zip -O /dev/shm/arkosupdate08112023.zip -a "$LOG_FILE" || sudo rm -f /dev/shm/arkosupdate08112023.zip | tee -a "$LOG_FILE"
	if [ -f "/dev/shm/arkosupdate08112023.zip" ]; then
		if [ "$(cat ~/.config/.DEVICE)" = "RG353V" ]; then
		  sudo unzip -X -o /dev/shm/arkosupdate08112023.zip -d / | tee -a "$LOG_FILE"
		elif [ "$(cat ~/.config/.DEVICE)" = "RG353M" ] || [ "$(cat ~/.config/.DEVICE)" = "RG503" ] || [ "$(cat ~/.config/.DEVICE)" = "RK2023" ]; then
		  sudo unzip -X -o /dev/shm/arkosupdate08112023.zip -x home/ark/.asoundrc-hp usr/local/bin/hpwatchdaemon.sh -d / | tee -a "$LOG_FILE"
		elif [ "$(cat ~/.config/.DEVICE)" = "RGB10MAX" ]; then
		  sudo unzip -X -o /dev/shm/arkosupdate08112023.zip -x home/ark/.asoundrc-hp usr/local/bin/hpwatchdaemon.sh opt/wifi/oga_controls -d / | tee -a "$LOG_FILE"
		  sudo cp -fv /usr/local/bin/ogage.rgb10max /usr/local/bin/ogage | tee -a "$LOG_FILE"
		  sudo rm -f /usr/local/bin/ogage.rgb10max | tee -a "$LOG_FILE"
		else
		  sudo unzip -X -o /dev/shm/arkosupdate08112023.zip -x home/ark/.asoundrc-hp usr/local/bin/hpwatchdaemon.sh opt/wifi/oga_controls usr/local/bin/ogage.rgb10max -d / | tee -a "$LOG_FILE"
		fi
		sudo rm -fv /dev/shm/arkosupdate08112023.zip | tee -a "$LOG_FILE"
	else
		printf "\nThe update couldn't complete because the package did not download correctly.\nPlease retry the update again." | tee -a "$LOG_FILE"
		sudo rm -fv /dev/shm/arkosupdate08112023.z* | tee -a "$LOG_FILE"
		sleep 3
		echo $c_brightness > /sys/class/backlight/backlight/brightness
		exit 1
	fi

	printf "\nCheck if quickboot mode is enabled and if it is, replace quickmode.sh script\n" | tee -a "$LOG_FILE"
	if [ -f "/opt/system/Advanced/Disable\ Quick\ Mode.sh" ]; then
	  printf " quickmode.sh has been udpated" | tee -a "$LOG_FILE"
	else
	  sudo rm -fv /usr/local/bin/quickmode.sh | tee -a "$LOG_FILE"
	  sudo cp -fv /usr/local/bin/Enable\ Quick\ Mode.sh /opt/system/Advanced/Enable\ Quick\ Mode.sh | tee -a "$LOG_FILE"
	fi

	printf "\nCopy correct emulationstation depending on device\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  sudo mv -fv /home/ark/emulationstation.351v /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-odroidgo2-linux.dtb" ] || [ -f "/boot/rk3326-odroidgo2-linux-v11.dtb" ] || [ -f "/boot/rk3326-odroidgo3-linux.dtb" ]; then
	  test=$(stat -c %s "/usr/bin/emulationstation/emulationstation")
	  if [ "$test" = "3314512" ]; then
	    sudo cp -fv /home/ark/emulationstation.351v /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  elif [ -f "/home/ark/.config/.DEVICE" ]; then
		sudo cp -fv /home/ark/emulationstation.rgb10max /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  else
	    sudo cp -fv /home/ark/emulationstation.header /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  fi
	  if [ -f "/home/ark/.config/.DEVICE" ]; then
	    sudo cp -fv /home/ark/emulationstation.rgb10max /usr/bin/emulationstation/emulationstation.header | tee -a "$LOG_FILE"
	  else
	    sudo cp -fv /home/ark/emulationstation.header /usr/bin/emulationstation/emulationstation.header | tee -a "$LOG_FILE"
	  fi
	  sudo cp -fv /home/ark/emulationstation.351v /usr/bin/emulationstation/emulationstation.fullscreen | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  sudo mv -fv /home/ark/emulationstation.503 /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	  sudo rm -fv /home/ark/emulationstation.* | tee -a "$LOG_FILE"
	  sudo chmod -v 777 /usr/bin/emulationstation/emulationstation* | tee -a "$LOG_FILE"
	fi

	printf "\nInstall and link new SDL 2.0.2800.2 (aka SDL 2.0.28.2)\n" | tee -a "$LOG_FILE"
	if [ -f "/boot/rk3566.dtb" ] || [ -f "/boot/rk3566-OC.dtb" ]; then
	  sudo mv -f -v /home/ark/sdl2-64/libSDL2-2.0.so.0.2800.2.rk3566 /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2800.2 | tee -a "$LOG_FILE"
	  sudo mv -f -v /home/ark/sdl2-32/libSDL2-2.0.so.0.2800.2.rk3566 /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2800.2 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-32 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-64 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2.so /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2800.2 /usr/lib/aarch64-linux-gnu/libSDL2.so | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2.so /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2800.2 /usr/lib/arm-linux-gnueabihf/libSDL2.so | tee -a "$LOG_FILE"
	elif [ -f "/boot/rk3326-rg351v-linux.dtb" ] || [ -f "/boot/rk3326-rg351mp-linux.dtb" ] || [ -f "/boot/rk3326-gameforce-linux.dtb" ]; then
	  sudo mv -f -v /home/ark/sdl2-64/libSDL2-2.0.so.0.2800.2.rk3326 /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2800.2 | tee -a "$LOG_FILE"
	  sudo mv -f -v /home/ark/sdl2-32/libSDL2-2.0.so.0.2800.2.rk3326 /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2800.2 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-32 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-64 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2.so /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2800.2 /usr/lib/aarch64-linux-gnu/libSDL2.so | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2.so /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2800.2 /usr/lib/arm-linux-gnueabihf/libSDL2.so | tee -a "$LOG_FILE"
	else
	  sudo mv -f -v /home/ark/sdl2-64/libSDL2-2.0.so.0.2800.2.rotated /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2800.2 | tee -a "$LOG_FILE"
	  sudo mv -f -v /home/ark/sdl2-32/libSDL2-2.0.so.0.2800.2.rotated /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2800.2 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-64 | tee -a "$LOG_FILE"
	  sudo rm -rfv /home/ark/sdl2-32 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2.so /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0.2800.2 /usr/lib/aarch64-linux-gnu/libSDL2.so | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2.so /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"
	  sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.2800.2 /usr/lib/arm-linux-gnueabihf/libSDL2.so | tee -a "$LOG_FILE"
	fi

	printf "\nUpdate boot text to reflect current version of ArkOS\n" | tee -a "$LOG_FILE"
	sudo sed -i "/title\=/c\title\=ArkOS 2.0 ($UPDATE_DATE)" /usr/share/plymouth/themes/text.plymouth

	touch "$UPDATE_DONE"
	rm -v -- "$0" | tee -a "$LOG_FILE"
	printf "\033c" >> /dev/tty1
	if [ -f "/boot/rk3326-rg351v-linux.dtb" ]; then
	  LD_LIBRARY_PATH=/usr/local/bin msgbox "Updates have been completed.  System will now restart after you hit the A button to continue.  If the system doesn't restart after pressing A, just restart the system manually."
	else
	  msgbox "Updates have been completed.  System will now restart after you hit the A button to continue.  If the system doesn't restart after pressing A, just restart the system manually."
	fi
	echo $c_brightness > /sys/class/backlight/backlight/brightness
	sudo reboot
	exit 187
fi