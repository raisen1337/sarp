fx_version 'adamant'

author 'Raisen - notraisen on Discord 🎉'
description 'Roleplay framework developed with LUA.'

games { 'gta5' }

this_is_a_map 'yes'

shared_script { '/shared/structs/config.lua' }

client_script { '/shared/structs/config.lua' }
server_script { '/shared/structs/config.lua' }

client_script { '/shared/structs/lang.lua' }
server_script { '/shared/structs/lang.lua' }

server_script { "/server/commands/main.lua" }

client_script { '/shared/mapmanager/mapmanager_shared.lua' }
server_script { '/shared/mapmanager/mapmanager_shared.lua' }

client_script { '/shared/structs/structs.lua' }
server_script { '/shared/structs/structs.lua' }

client_scripts { '@menuv/menuv.lua', 'cl_main.lua', '/client/*.lua', 'client/**/*.lua' }
server_scripts { 'sv_main.lua', '/server/*.lua', 'server/**/*.lua' }


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
	'data/**/carcols.meta',
	'data/**/carvariations.meta',
	'data/**/contentunlocks.meta',
	'data/**/handling.meta',
	'data/**/vehiclelayouts.meta',
	'data/**/vehicles.meta',
	'data/**/dlctext.meta',
	'data/**/*.meta',
	'html/*.*',
	'html/**/*.*'
}

data_file 'HANDLING_FILE' 'data/**/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/**/vehicles.meta'
data_file 'CARCOLS_FILE' 'data/**/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/**/carvariations.meta'
data_file 'VEHICLE_LAYOUTS_FILE' 'data/**/vehiclelayouts.meta'
data_file "SCALEFORM_DLC_FILE" "stream/int3232302352.gfx"

files {
	"stream/int3232302352.gfx"
}
data_file('DLC_ITYP_REQUEST')('stream/int_cayo_props.ytyp')
data_file('DLC_ITYP_REQUEST')('stream/med/int_cayo_med_props.ytyp')
