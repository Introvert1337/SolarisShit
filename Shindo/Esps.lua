local function InitESPs(Library, esps)
    _G.t = false
    wait(.5)
    _G.t = true


    local c = workspace.CurrentCamera
    local w = task.wait
    local s = game:GetService("RunService").Stepped
    local objects  = {}
    local players  = game:GetService("Players")

    local function AddESPs(player)
        local name = player.Name
        local object = objects[name]

        object.top.Color = Color3.fromRGB(255,255,255)
        object.bottom.Color = Color3.fromRGB(255,255,255)
        
        object.top.Text = name
        -- object.bottom.Text = name

        object.top.Center = true

        object.top.Font = Drawing.Fonts.Monospace
        object.bottom.Font = Drawing.Fonts.Monospace
        local formats = {
            name = "Name: %s",
            fakehealth = "HP: %s",
            stamina = "CHI: %s",
            stamina2 = "STM: %s",
            mode = "MD: %s"
        }

        local f = "Name: %s | HP: %s\nCHI: %s | STM: %s\nMD: %s"

        while (Library.running and player.Parent == players) do
            if (esps.enabled and player.Character) then
                local Head = player.Character:FindFirstChild("Head")
                local fakehealth = player.Character:FindFirstChild("fakehealth")
                local combat = player.Character:FindFirstChild("combat")

                if (Head and fakehealth and combat) then
                    local v3, os = c:WorldToViewportPoint(Head.Position)
                    
                    local text = ""
                    local neg = 30

                    if (esps.enabled) then
                        text = formats.name:format(name)
                        
                        if (esps.health) then
                            text ..= " | " .. formats.fakehealth:format(tostring(fakehealth.Value))
                            neg += 20
                        end

                        text = text .. "\n"

                        if (esps.chakra) then
                            text ..= formats.stamina:format(tostring(combat.stamina.Value))
                        end

                        if (esps.stamina) then
                            if (esps.chakra) then
                                text ..= " | "
                            end

                            text ..= formats.stamina2:format(tostring(combat.stamina2.Value))
                        end

                        if (esps.stamina or esps.chakra) then
                            text ..= "\n"
                            neg += 20
                        end

                        if (esps.mode) then
                            text ..= formats.mode:format(tostring(combat.mode.Value))
                        end
                    end

                    object.top.Text = text

                    object.top.Visible = os
                    object.bottom.Visible = os
                    object.top.Position = Vector2.new(v3.X, v3.Y - neg)
                else
                    object.top.Visible = false
                    object.bottom.Visible = false
                end
            else
                object.top.Visible = false
                object.bottom.Visible = false
            end

            s:Wait()
        end

        object.top.Visible = false
        object.bottom.Visible = false

        object.top:Remove()
        object.bottom:Remove()

        objects[name] = nil
    end

    task.spawn(function()
        while (Library.running) do
            for i, player in next, players:GetChildren() do
                if (i ~= 1 and not objects[player.Name]) then
                    objects[player.Name] = objects[player.Name] or {
                        top = Drawing.new("Text"),
                        bottom = Drawing.new("Text")
                    }

                    task.spawn(AddESPs, player)
                end
            end

            w()
        end
    end)
end

return InitESPs
