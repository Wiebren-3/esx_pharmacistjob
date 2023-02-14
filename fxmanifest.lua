fx_version 'cerulean'
game 'gta5'

author 'Wiebren#6393'
description 'ESX Pharmacistjob'
version '1.0.0'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'locales/en.lua',
	'locales/en.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'locales/en.lua',
	'localization/en.lua',
	'client/main.lua'
}

dependencies {
    'es_extended',
    'async',
	'mysql-async'
}


