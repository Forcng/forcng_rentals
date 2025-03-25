ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback("forcng:server:checkMoney", function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cash = xPlayer.getInventoryItem("cash").count

    if cash >= price then
        xPlayer.removeInventoryItem("cash", price)
        cb(true)
    else
        cb(false)
    end
end)
