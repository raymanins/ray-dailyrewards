local QBCore = exports['qb-core']:GetCoreObject()
local Config = Config or {}

lib.callback.register('daily_rewards:claimReward', function(source, cb)
    print("Callback registered and invoked")
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then
        print("Player not found.")
        return
    end
    
    local citizenid = Player.PlayerData.citizenid
    print("Citizen ID: ", citizenid)

    -- Fetch last reward time from the database
    exports.oxmysql:single('SELECT last_reward FROM players_rewards WHERE citizenid = ?', {citizenid}, function(result)
        local lastReward = result and result.last_reward and tonumber(result.last_reward) or nil

        if lastReward and (os.time() - lastReward < 86400) then
            local timeLeft = 86400 - (os.time() - lastReward)
            local hours = math.floor(timeLeft / 3600)
            local minutes = math.floor((timeLeft % 3600) / 60)

            -- Notify the player
            TriggerClientEvent('daily_rewards:notify', source, {
                title = 'Daily Reward',
                description = 'You can claim next reward in ' .. hours .. 'h ' .. minutes .. 'm.',
                type = 'error'
            })
        else
            local reward = Config.Rewards[math.random(#Config.Rewards)]
            print("Granting reward: " .. json.encode(reward))

            if reward.type == 'money' then
                Player.Functions.AddMoney('cash', reward.amount)
            elseif reward.type == 'item' then
                Player.Functions.AddItem(reward.name, reward.amount)
            end

            -- Update last reward time in the database
            exports.oxmysql:update('REPLACE INTO players_rewards (citizenid, last_reward) VALUES (?, ?)', {citizenid, os.time()}, function(affectedRows)
                print("Database update affected rows: " .. affectedRows)
                if affectedRows > 0 then
                    -- Notify the player
                    TriggerClientEvent('daily_rewards:notify', source, {
                        title = 'Daily Reward',
                        description = 'You claimed daily reward!',
                        type = 'success'
                    })
                else
                    -- Notify the player about the error
                    TriggerClientEvent('daily_rewards:notify', source, {
                        title = 'Daily Reward',
                        description = 'Failed to update reward status. Please try again later.',
                        type = 'error'
                    })
                end
            end)
        end
    end)
end)
