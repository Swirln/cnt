--[[
  File Name: scan.lua
  Description: Removes all "infections" from the game, like an antivirus.
  Authors: Carrot
  Date: 6/18/2018 @ 1:27 PM CST
  https://github.com/carat-ye/cnt
--]]

local Lighting = game:GetService("Lighting")
local QUARANTINE = _G.CNT.AV.Quarantine
local CLASSES = _G.CNT.AV.Classes
local NAMES = _G.CNT.AV.Names
local TO_SCAN = _G.CNT.AV.Scanning

print("CNT: AV: Antivirus started!")

for _, scanning in pairs(TO_SCAN) do
  if game:GetService(scanning) then
    for _, object in pairs(scanning:GetDescendants()) do
      for _, class in pairs(CLASSES) do
        if object:IsA(class) then
          if QUARANTINE then
            object.Parent = Lighting
            warn("CNT: AV: Quarantined (moved to Lighting) object \"".. object.Name .."\" because of it's class (\"".. object.ClassName .."\"). Object's parent was \"".. object.Parent .."\".")
          else
            object:Destroy()
            warn("CNT: AV: Removed object \"".. object.Name .."\" because of it's class (\"".. object.ClassName .."\"). Object's parent was \"".. object.Parent .."\".")
          end
        end
      end
      for _, name in pairs(NAMES) do
        if string.find(name:lower(), object.Name:lower()) then
          if QUARANTINE then
            object.Parent = Lighting
            warn("CNT: AV: Quarantined (moved to Lighting) object \"".. object.Name .."\" because of it's name. Object's class was \"".. object.ClassName .."\" and parent was \"".. object.Parent .."\".")
          else
            object:Destroy()
            warn("CNT: AV: Removed object \"".. object.Name .."\" because of it's name. Object's class was \"".. object.ClassName .."\" and parent was \"".. object.Parent .."\".")
          end
        end
      end
    end
  end
end
