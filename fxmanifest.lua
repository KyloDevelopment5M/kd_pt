fx_version 'cerulean'
game 'gta5'

lua54 'yes'

shared_script 'config.lua'

client_scripts {
    '@ox_lib/init.lua',
    'client.lua'
}

server_scripts {
    '@es_extended/imports.lua',
    'server.lua'
}
