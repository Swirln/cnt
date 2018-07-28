--[[
  File Name: scan.lua
  Description: Removes all "infections" from the game, like an antivirus.
  Authors: Carrot
  Date: 6/18/2018 @ 1:27 PM CST
  https://github.com/carat-ye/cnt
--]]

--- Declarations
repeat wait() until _G
repeat wait() until _G.CNT
repeat wait() until _G.CNT.AV
repeat wait() until _G.CNT.AV.Quarantine ~= nil
repeat wait() until _G.CNT.AV.Classes
repeat wait() until _G.CNT.AV.Names
repeat wait() until _G.CNT.AV.Scanning
repeat wait() until _G.CNT.AV.QuarantinePlace

local Lighting = game:GetService("Lighting")
local QUARANTINE_PLACE = game:GetService(_G.CNT.AV.QuarantinePlace) or Lighting
local QUARANTINE = _G.CNT.AV.Quarantine
local CLASSES = _G.CNT.AV.Classes
local NAMES = _G.CNT.AV.Names
local TO_SCAN = _G.CNT.AV.Scanning

--- Functions
--- Deletes an object.
-- @param Instance object: The object to be removed.
local function Destroy(instance)
  Debris:AddItem(instance, 0)
end

--- Modifies an object (quarantine or remove.)
-- @param Instance object: The object.
-- @param bool type: `false` for name, `true` for class.
local function Modify(object, type)
  if QUARANTINE then
    if object:FindFirstChild("CNTQuarantined") then
      return
    end
  end

  local oName, oClass, oParent = object.Name, object.ClassName, object.Parent.Name
  local typeName = (type and "class" or "name")
  local typeType = (type and oClass or oName)
  local message = "CNT: AV: Successfully %s object \"".. oName .."\" because of it's %s (\"%s\"). Object's parent was \"".. oParent .."\"."

  if QUARANTINE then
    local quarantined = Instance.new("StringValue")
    quarantined.Name = "CNTQuarantined"
    quarantined.Parent = object
    object.Parent = QUARANTINE_PLACE or Lighting
    message = message:format("quarantined (moved to ".. QUARANTINE_PLACE.Name or QUARANTINE_PLACE ")", typeName, typeType)
  else
    Destroy(object)
    message = message:format("removed", typeName, typeType)
  end
  warn(message)
end

print("CNT: AV: Antivirus started!")

for _, scanning in pairs(TO_SCAN) do
  scanning = game:GetService(scanning) or scanning
  for _, object in pairs(scanning:GetDescendants()) do
    for _, class in pairs(CLASSES) do
      if object:IsA(class) then
        Modify(object, true)
      end
    end
    for _, name in pairs(NAMES) do
      if string.find(name:lower(), object.Name:lower()) then
        Modify(object, false)
      end
    end
  end
end
