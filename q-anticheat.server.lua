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

local protections = {}
local modules = {
    ["Speedhack"] = true
}

-- Put enabled modules in protections table
for _, module in ipairs(script:GetChildren()) do
    if module:IsA("LocalScript") and modules[module.Name] then
        table.insert(Protections, module)
        module.Name = ""
        module.Parent = nil
    else
        Debris:AddItem(module, 0)
    end
end

game:GetService("Players").PlayerAdded:connect(function(player)
    player.CharacterAdded:connect(function()
        for _, module in ipairs(Protections) do
            local newModule = module:Clone()
            newModule.Name = ""
            newModule.Parent = player.Backpack
        end
    end)
end)