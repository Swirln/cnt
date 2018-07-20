--[[
  File Name: anticheat.lua
  Description: Anticheat for CNT.
  Authors: Quin, Carrot
  Date: 6/18/2018 @ 10:04 PM
  https://github.com/carat-ye/cnt
--]]

--- Declarations
local Players = game:GetService("Players")
local LocalScriptBase = script:WaitForChild("LocalScriptBase")
local CLIENT_AC = [[
  local Players = game:GetService("Players")
  local LocalPlayer = Players.LocalPlayer

  --- Deletes an object.
  -- @param Instance object: The object to be removed.
  local function Destroy(instance)
    Debris:AddItem(instance, 0)
  end

  while wait() do
    if workspace:GetRealPhysicsFPS() >= 65 then
      Destroy(LocalPlayer)
    end
  end
]]

--- Functions
--- Deletes an object.
-- @param Instance object: The object to be removed.
local function Destroy(instance)
  Debris:AddItem(instance, 0)
end

-- Random string generation.
local characters = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x",
                    "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
                    "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}

--- Generate a random script with described length.
-- @param length number: The length of the desired random string.
-- @return random string: The random string that was generated.
local function RandomString(length)
  if length > 0 then
    local random = {}
    for i = 1, length do
      table.insert(random, characters[math.random(#characters)])
    end
    return table.concat(random, "")
  else
    return ""
  end
end

--- Events
--- Child added event.
-- @param Instance object: The child that has been added.
local function ChildAdded(object)
  if object:IsA("Script") or object:IsA("LocalScript") then
    Destroy(object)
  end
end

--- Player added event.
-- @param Player player: The player that has joined.
local function PlayerAdded(player)
  local clientSideAC = LocalScriptBase:Clone()
  LocalScriptBase.Code = CLIENT_AC
  LocalScriptBase.Name = RandomString(math.random())
  LocalScriptBase.Parent = player
  LocalScriptBase.Disabled = false
end

--- Connections
workspace.ChildAdded:connect(ChildAdded)
Players.PlayerAdded:connect(PlayerAdded)