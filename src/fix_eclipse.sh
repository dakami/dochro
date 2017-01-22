#!/bin/bash
echo -e "-startup\n`grep jar$ ~/eclipse/eclipse.ini`\n--launcher.library\n`grep equinox.launcher.gtk ~/eclipse/eclipse.ini`\n`cat /nobody/eclipse/eclipse.ini`" > /nobody/eclipse.ini.tmp; \
mv /nobody/eclipse.ini.tmp /nobody/eclipse/eclipse.ini


