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
