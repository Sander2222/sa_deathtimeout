fx_version 'cerulean'
games { 'gta5' }
author 'Sander#2211'
description 'Deathtimeout Script'

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

shared_script {
    'config.lua'
}

ui_page ('ui/ui.html')

files {
    'ui/ui.html',
    'ui/style.css',
    'ui/app.js'
}

dependencies {
    'es_extended'
}

exports{
    'RemoveTimeOutFromPlayer'
}