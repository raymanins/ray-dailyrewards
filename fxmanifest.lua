fx_version 'cerulean'
game 'gta5'

description 'Daily Rewards System'
version '1.0.0'
lua54 'yes'

shared_script {
    '@ox_lib/init.lua',
    'config.lua',
}
server_script {
    'server/main.lua',
    "@oxmysql/lib/MySQL.lua",
}
client_script {
    'client/main.lua',
}