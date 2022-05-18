--[[
    Semi-GodMode, etc.
]]

local Library, config = ...
local LP = game:GetService("Players").LocalPlayer

local configuration = config:get("configuration")
local client = config:get("client")

local fakehealth = Instance.new("IntValue")
fakehealth.Name = "fakehealth"
fakehealth.Value = 9e9

local ignore_index = false

local __index = hookmetamethod(game, "__index", newcclosure(function(...)
    local self, key = ...

	if (checkcaller() and ignore_index and self == LP and tostring(key) == "Character") then
		local value;

		ignore_index = true
		while (not value) do
			value = getgenv().old__index(...)
			wait()
		end
		ignore_index = false

		return value
	end

    if (not checkcaller()) then
        -- Semi-Godmode
        if (key == "fakehealth" and configuration.semigm) then
            return fakehealth
        end
        if (key == "Health" or tostring(self) == "fakehealth") then
            if (configuration.semigm) then
                if (tostring(self) == "fakehealth" and key == "Value") then
                    return 9e9
                end

                if (key == "fakehealth") then
                    return fakehealth
                end

                if (tostring(self) == "Humanoid" and key == "Health") then
                    return 5
                end
            end
        end
    end

    return getgenv().old__index(...)
end))

-- Disable Effects
local __newindex = hookmetamethod(game, "__newindex", newcclosure(function(...)
    local self, key, value = ...

    if (not checkcaller()) then
        if (key == "Parent" and tostring(value) == "ClientEffects" and configuration.disable_effects) then
            return -- dont let it parent
        end

        if (typeof(self) == "Instance" and self:IsA("Humanoid")) then
            if (key == "WalkSpeed") then
                if (client.walk_speed_enabled) then
                    return getgenv().old__newindex(self, key, value == 0 and (client.bypass_movement and client.walk_speed or 0) or math.max(client.walk_speed, value))
                end
            end
            
            if (key == "JumpPower") then
                if (client.jump_power_enabled) then
                    return getgenv().old__newindex(self, key, value == 0 and (client.bypass_movement and client.jump_power or 0) or client.jump_power)
                end
            end
        end
    end

    return getgenv().old__newindex(...)
end))

local __namecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    if (not checkcaller()) then
        local args = {...}
        local self = table.remove(args, 1)

        if (tostring(getnamecallmethod()) == "FindFirstChild" and tostring(args[1]) == "fakehealth") then
            if (configuration.semigm) then
                return fakehealth
            end
        end
    end

    return getgenv().old__namecall(...)
end))

getgenv().old__index = getgenv().old__index or __index
getgenv().old__newindex = getgenv().old__newindex or __newindex
getgenv().old__namecall = getgenv().old__namecall or __namecall

task.spawn(function()
    local wait = task.wait
    local char = nil
    while (Library.running) do
        local Character = LP.Character
        local Main = LP.PlayerGui:FindFirstChild("Main")
        local ingame = Main and Main:FindFirstChild("ingame")
        local Bar = ingame and ingame:FindFirstChild("Bar")
        local hp = Bar and Bar:FindFirstChild("hp")

        if (Character and Character:FindFirstChild("combat") and Main and ingame and Bar and hp and hp.Text ~= "HP: 000") then
            local fakehealth, stayonground, combat = Character:FindFirstChild("fakehealth"), Character:FindFirstChild("stayonground"), Character:FindFirstChild("combat")

            if (configuration.no_cd and configuration.no_cd_priority) then
                if (not Character:FindFirstChild("zombify")) then
                    task.wait()
                    continue;
                end
            end

            if (combat) then
                if (configuration.inf_mode) then
                    local mode = combat:FindFirstChild("mode")

                    if (mode and char ~= Character) then
                        char = Character
                        mode:Clone().Parent = combat
                        wait(1)
                        mode:Destroy()
                    end
                end
            end
            
            if (configuration.semigm) then
                if (fakehealth) then
                    fakehealth:Destroy()
                end

                if (stayonground) then
                    stayonground:Destroy()
                end
            end
        end
        wait()
    end

    hookmetamethod(game, "__index", old__index)
    hookmetamethod(game, "__newindex", old__newindex)
    hookmetamethod(game, "__namecall", old__namecall)
end)
