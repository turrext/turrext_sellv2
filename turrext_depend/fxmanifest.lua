fx_version 'adamant'

game 'gta5'
lua54 'yes'
description 'Turrext depend'

version '2.0'
legacyversion '1.9.1'

shared_script '@es_extended/imports.lua'

server_scripts {
	'server/*'
}

client_scripts {
	'client/*'
}

shared_scripts {
    'config.lua'
}
escrow_ignore {
	'config.lua',
}
dependency 'es_extended'