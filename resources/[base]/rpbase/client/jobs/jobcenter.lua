local jobs = {
   {icon = 'fa-fishing-rod', title = 'Pescar', coords = vec3(1320.1822509766,4314.455078125,38.138744354248), description = 'Pescarul nu poate fi judecat decat de catre Dumnezeu si de catre peste!', color = '#00b3ff'},
   {icon = 'fa-farm', title = 'Fermier', coords = vec3(2309.4997558594,4885.5102539063,41.808284759521), description = 'Iti place viata la tara? Atunci jobul asta este ideal pentru tine!', color = '#87cf4c'},
   {icon = 'fa-pizza-slice', title = 'PizzaBoy', coords = vec3(-289.1872253418,6132.2939453125,31.546846389771), description = "Alătură-te echipei noastre și Fă Parte din Gustul Succesului!", color = '#f55742'},
   {icon = 'fa-truck-container-empty', title = 'Petrolier', coords = vec3(2748.4567871094,1452.4614257813,24.494695663452), description = "N-ai luat bacul sau iti place soferia? Asta este jobul ideal pentru tine!", color = '#ffb121'},
}

RegisterCommand('jobs', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openJobCenter',
        jobs = jobs
    })
end)

RegisterNUICallback('gpsJob', function(jobName)
    jobName = jobName.job
    SetNuiFocus(false, false)
    for k,v in pairs(jobs) do
        if v.title == jobName then
            Core.HasCheckpoint(function (has)
                if has then
                    Core.DeleteAllCps()
                end
            end)
            TriggerEvent('Jobs:Check', true, jobName)
            TriggerEvent('Job:StopWork', jobName)
            CreateCP(1, v.coords, {255, 0, 0, 255}, 1.0, 10.0, function()

            end)
        end
    end
end)

RegisterNUICallback('closeJobCenter', function ()
    SetNuiFocus(false, false)
end)