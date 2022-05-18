local Library = select(1, ...)
local config = select(2, ...)

local GLOBALTIME = workspace:WaitForChild("GLOBALTIME")
local clienttell = GLOBALTIME:WaitForChild("clienttell")
local scrolls = {}

local instances = {}
for i,v in next, game:GetService("ReplicatedStorage"):GetDescendants() do
	if (v.Name == "SCROLLSPAWN") then
		instances[v.Parent.Name] = v.Parent
	end
end

for i,v in next, clienttell:GetChildren() do
	if (instances[v.Name] and v:IsA("StringValue") and v.Value:len() > 2) then
		local realname = instances[v.Name]:FindFirstChild("REALNAME") or instances[v.Name]:FindFirstChild("realname")

		if (realname and v:WaitForChild("gettime", 5)) then
			scrolls[v.Name] = {
				name = realname.Value,
				time = {
					min = v.gettime.min.Value,
					hr = v.gettime.hr.Value
				},
				place = {
					name = v.location.Value,
					id = 0
				}
			}
		end
	end
end

local configuration = config:get('configuration')
configuration.autohop.start = os.time()

config:save()

return scrolls
