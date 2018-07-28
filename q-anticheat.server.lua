--[[
    File Name: anticheat.lua
    Description: Anticheat for CNT.
    Authors: Quin
    Date: 7/26/18
    https://github.com/carat-ye/cnt
--]]
script.Parent = nil

--- Services
local Debris = game:GetService("Debris")

local Protections = {}
local Modules = {
    ["Speedhack"] = true
}

-- Put enabled modules in protections table
for _, Module in ipairs(script:GetChildren()) do
    if Module:IsA("LocalScript") and Modules[Module.Name] then
        table.insert(Protections, Module)
        Module.Name = ""
        Module.Parent = nil
    else
        Debris:AddItem(Module, 0)
    end
end

game:GetService("Players").PlayerAdded:connect(function(Player)
    Player.CharacterAdded:connect(function()
        for _, Module in ipairs(Protections) do
            local NewModule = Module:Clone()
            NewModule.Name = ""
            NewModule.Parent = Player.Backpack
        end
    end)
end)