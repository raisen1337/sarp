Commands = {}

CreateCMD = function(cmdname, help, callback)

    if #Commands == 0 then
        table.insert(Commands, {name = cmdname, help = help})
        RegisterCommand(cmdname, function(source, args, rawCommand)
            callback(source, args, rawCommand)
        end)
        return
    else
        for k,v in pairs(Commands) do
            if v.name == cmdname then
            else
                table.insert(Commands, {name = cmdname, help = help})
                RegisterCommand(cmdname, function(source, args, rawCommand)
                    callback(source, args, rawCommand)
                end)
                return
            end
        end
    end
end

CreateCMD('coords', "Get coordinates at current point.", function(source, args)
    local id = args[1]
    print('used')
    if id then
        if GetPlayerPing(id) > 0 then
            print(GetEntityCoords(GetPlayerPed(id)), GetEntityHeading(GetPlayerPed(id)))
        else
            print("Jucatorul nu este online!")
        end
    end
end)

CreateCMD('setped', "Set Ped model by id", function(source, args)
    local src = source
    local id = args[1]

    TriggerClientEvent("Ped:Change", src, id)
end)