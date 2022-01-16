fx_version 'cerulean'
games { 'gta5' }
author 'zJu1C3#7819 & Hyz#9918'
lua54 'TC168'
ui_page 'web/index.html'

client_scripts {
    'config.lua',
    '@vrp/client/Tunnel.lua',
    '@vrp/client/Proxy.lua',
    'client/c_main.lua'
}

server_scripts {
    '@vrp/lib/utils.lua',
    'server/s_main.lua'
}

files {
    'web/index.html',
    'web/identity.js',
    'web/design.css'
}