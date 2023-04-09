local times = 1
local event = game:GetService("ReplicatedStorage").RemoteFunction
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/ROBLOX/main/ModificationWallyUi", true))()
local w = library:CreateWindow("Auto Stack V3")
local h = 5
local Mouse = game.Players.LocalPlayer:GetMouse()
local troops = {}
for i,v in next, game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("Session", "Search", "Inventory.Troops") do
    if v.Equipped then
        table.insert(troops, i)
    end
end
local upgradeTroop = troops[1] 
w:Section("Stacking - DONT STACK BETWEEN -6 AND 6 OR IT WONT WORK")
local Toggle = w:Toggle('Stacking Enabled', {flag = "toggle1"})
w:Slider("Amount",
    {
        precise = false,
        default = 1,
        min = 1,
        max = 15,
    },
function(v)
	times = v
end)
w:Slider("Height",
    {
        precise = false,
        default = 6,
        min = -8,
        max = 120,
    },
function(v)
	h = v
end)
w:Button('Upgrade All', function()
for i,v in pairs(game.Workspace.Towers:GetChildren()) do
    if v:WaitForChild("Owner").Value == game.Players.LocalPlayer.UserId then
        event:InvokeServer("Troops","Upgrade","Set",{["Troop"] = v})
        wait()
    end
end
end)
w:Button("Upgrade Troop", function()
    for i,v in pairs(game.Workspace.Towers:GetChildren()) do
        if v:WaitForChild("Owner").Value == game.Players.LocalPlayer.UserId and v:WaitForChild("Replicator"):GetAttribute("Type") == upgradeTroop then
            event:InvokeServer("Troops","Upgrade","Set",{["Troop"] = v})
            wait()
        end
    end
end)
w:Dropdown("Set Tower", {
    location = _G;
    flag = "troops";
    list = troops;
}, function(value)
    upgradeTroop = value
end)
w:Section('DANGER ZONE')
w:Button('Sell All', function()
    for i,v in pairs(game.Workspace.Towers:GetChildren()) do
        if v:WaitForChild("Owner").Value == game.Players.LocalPlayer.UserId then
            event:InvokeServer("Troops","Sell",{["Troop"] = v})
            wait()
        end
    end
end)

local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args = {...}
    local NamecallMethod = getnamecallmethod()
    if w.flags.toggle1 and #Args == 4 and NamecallMethod == "InvokeServer" and Self == event and Args[1] == "Troops" and Args[2] == "Place" then
        spawn(function()
            for i = 1, times do
                event:InvokeServer(Args[1], Args[2], Args[3], {Rotation = CFrame.new(0,h,0),Position = Args[4]['Position']}, true)
                wait(.2)
            end
        end)
        return nil
    end
    return OldNamecall(Self, ...)
end)
