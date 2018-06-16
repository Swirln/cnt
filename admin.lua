--[[
  File Name: admin.lua
  Description: The main admin commands for CaNT
  Authors: Niall, Carrot
  Date: 6/16/2018 @ 5:15 PM CST (23:15 PM GMT)
--]]
math.randomseed(os.time())

--- Configuration
local admins = { -- 1 = Owner, 2 = Admin, 3 = TempAdmin, 4 = Mod, 5 = Normal Player
  "Niall" = 1,
  "Raymonf" = 1,
  "Carrot" = 1,
}
local banned = {} -- List players that are banned from your game here.
local prefixes = { -- Admin prefixes, e.g ":kill EnergyCell"
	":",
	";",
	"?",
	"^",
	"@",
	".",
	"/",
	"$",
	"!",
}

--- Declarations
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local dayAndNight = false

--- Functions
-- Random string generation.
local charset = {}

for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

local function string.random(length)
  if length > 0 then
    return string.random(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end

-- Searches for a value in a table, returns true if found.
local function HasValue(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

-- Shuts down the server.
local function ShutDown()
  -- TODO: HttpPost to a url with the shutdown reason for monitoring stuff like exploits with lodes of data
  for _, player in pairs(Players:GetPlayers())
    player:Destroy()
  end
end

-- Checks if a user is banned, returns true if banned.
local function Blacklisted(name)
  name = string.lower(name)
  if HasValue(banned, name) then
    return true
  end
  return false
end

-- Checks if a user is admin, returns true if admin.
local function IsAdmin(name)
  name = string.lower(name)
  if HasValue(admins, name) then
    return true
  end
  return false
end

-- Command Functions
-- Checks if a command has no arguments passed.
local function NoArguments(arguments)
    for _, arg in pairs(arguments) do
      if arg == nil then
        return true
      end
  end
end


local function ParseMessage(message)

--- Commands
local commands = {}

commands.print = function(sender, arguments)
  if NoArguments(arguments) then
    return
  end
  local message = table.concat(arguments, " ")
  print(sender.Name .. ": " .. message)
end
commands.print.level = 5
commands.print.description = "Prints the arguments to console."

commands.kill = function(sender, arguments, targets)
  if NoArguments(arguments) then
    return
  end
  for _, player in pairs(targets) do
    if player.Character and player.Character.Humanoid.Health > 0 then
      player.Character.Humanoid:BreakJoints()
    end
  end
end
commands.kill.level = 4
commands.kill.description = "Kills a player by breaking their joints."

commands.sparkles = function(sender, arguments, targets)
  if NoArguments(arguments) then
    return
  end
  for _, player in pairs(targets) do
    if player.Character and player.Character.Torso then
      local sparkles = Instance.new("Sparkles")
      sparkles.Parent = player.Character.Torso
    end
  end
end
commands.sparkles.level = 4
commands.sparkles.description = "Adds sparkles to a player's torso."

commands.fire = function(sender, arguments, targets)
  if NoArguments(arguments) then
    return
  end
  for _, player in pairs(targets) do
    if player.Character and player.Character.Torso then
      local fire = Instance.new("Fire")
      fire.Parent = player.Character.Torso
    end
  end
end
commands.fire.level = 4
commands.fire.description = "Adds fire to a player's torso."

commands.smoke = function(sender, arguments, targets)
  if NoArguments(arguments) then
    return
  end
  for _, player in pairs(targets) do
    if player.Character and player.Character.Torso then
      local smoke = Instance.new("Smoke")
      smoke.Parent = player.Character.Torso
    end
  end
end
commands.smoke.level = 4
commands.smoke.description = "Adds smoke to a player's torso."

--- Connections
local function OnPlayerAdded(player)
  if Blacklisted(player.Name) then
    player:Destroy()
  end
  player.Chatted:connect(function(message)
    if IsAdmin(player) then
      ParseMessage(message)
    end
  end)
end

Players.PlayerAdded:connect(OnPlayerAdded)

--- Enable AC
local anticheat = game:WaitForChild("Anticheat")
anticheat.Name = string.random(math.random(69))
anticheat.Disabled = false
anticheat.Changed:connect(function()
  ShutDown()
end)
