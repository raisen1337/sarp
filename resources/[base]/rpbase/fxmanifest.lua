fx_version 'adamant'

author 'Raisen - notraisen on Discord 🎉'
description 'Roleplay framework developed with LUA and MongoDB.'

games {'gta5'}

this_is_a_map 'yes'

client_script {'/shared/structs/config.lua'}
server_script {'/shared/structs/config.lua'}

client_script {'/shared/structs/lang.lua'}
server_script {'/shared/structs/lang.lua'}

server_script {"/server/commands/main.lua"}

client_script {'/shared/mapmanager/mapmanager_shared.lua'}
server_script {'/shared/mapmanager/mapmanager_shared.lua'}

client_script {'/shared/structs/structs.lua'}
server_script {'/shared/structs/structs.lua'}

client_scripts { '@menuv/menuv.lua','cl_main.lua', '/client/*.lua', 'client/**/*.lua'}
server_scripts { 'sv_main.lua', '/server/*.lua', 'server/**/*.lua'}


server_export 'InitCore'

server_export "getCurrentGameType"
server_export "getCurrentMap"
server_export "changeGameType"
server_export "changeMap"
server_export "doesMapSupportGameType"
server_export "getMaps"
server_export "roundEnded"

ui_page "html/index.html"

files {
    'html/*.*',
    'html/**/*.*'
}