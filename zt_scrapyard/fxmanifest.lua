fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'zurst development'
description 'Advanced Scrapyard System for ESX'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua',
    'locales/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

dependencies {
    'es_extended',
    'ox_lib',
    'ox_target',
    'ox_inventory'
}

escrow_ignore {
     'config.lua',
     'locales/*.lua'
}
