RegisterCommand('daily', function()
    lib.callback('daily_rewards:claimReward', function(success)
        if success then
            print("Reward claimed successfully.")
        else
            print("Reward not claimed.")
        end
    end)
end, false)

RegisterNetEvent('daily_rewards:notify')
AddEventHandler('daily_rewards:notify', function(data)
    lib.notify({
        title = data.title,
        description = data.description,
        type = data.type
    })
end)
