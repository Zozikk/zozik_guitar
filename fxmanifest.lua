    -- ______        _ _    
    -- |___  /       (_) |   
    --    / / ___ _____| | __
    --   / / / _ \_  / | |/ /
    --  / /_| (_) / /| |   < 
    -- /_____\___/___|_|_|\_\

fx_version 'cerulean'
game 'gta5'

name 'Local Mechanic System'
author 'Zozik.'
description 'Script to repair car when no mechanic online'

server_script {
  'server.lua'
}

client_scripts {
  'client.lua',
  'config.lua'
}

