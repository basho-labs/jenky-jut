#!/usr/bin/env sh
for plugin in $(cat jenkins/plugins.ls); do
    plugin_id=$(echo $plugin |awk -F '@' '{print $1}')
    plugin_data="<jenkins><install plugin=\"$plugin\" /></jenkins>"

    curl -vvv -X POST -d "$plugin_data" \
        -H 'Content-Type: application/xml' \
        http://localhost:18080/pluginManager/installNecessaryPlugins
done
# sleep or jenkins pluginManager will not have time to do its thing
sleep 20
curl -XPOST http://localhost:18080/safeRestart
