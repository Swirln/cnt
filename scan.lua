--[[
  File Name: scan.lua
  Description: Removes all "infections" from the game, like an antivirus.
  Authors: Carrot
  Date: 6/18/2018 @ 1:27 PM CST
  https://github.com/carat-ye/cnt
--]]

repeat wait() until _G
repeat wait() until _G.CNT
repeat wait() until _G.CNT.AV
repeat wait() until _G.CNT.AV.Quarantine ~= nil
repeat wait() until _G.CNT.AV.Classes
repeat wait() until _G.CNT.AV.Names
repeat wait() until _G.CNT.AV.Scanning

local Lighting = game:GetService("Lighting")
local QUARANTINE = _G.CNT.AV.Quarantine
local CLASSES = _G.CNT.AV.Classes
local NAMES = _G.CNT.AV.Names
local TO_SCAN = _G.CNT.AV.Scanning

print("CNT: AV: Antivirus started!")

for _, scanning in pairs(TO_SCAN) do
  if game:GetService(scanning) then
	scanning = game:GetService(scanning)
    for _, object in pairs(scanning:GetDescendants()) do
      for _, class in pairs(CLASSES) do
        if object:IsA(class) then
          if QUARANTINE then
            if object:FindFirstChild("Quarantined") then
              return
            end
            local oName, oClass, oParent = object.Name, object.ClassName, object.Parent.Name
            local quarantined = Instance.new("StringValue")
            quarantined.Name = "quarantined"
            quarantined.Parent = object
            object.Parent = Lighting
            warn("CNT: AV: Quarantined (moved to Lighting) object \"".. oName .."\" because of it's class (\"".. oClass .."\"). Object's parent was \"".. oParent .."\".")
          else
            local oName, oClass = object.Name, object.ClassName
            object:Destroy()
            warn("CNT: AV: Removed object \"".. oName .."\" because of it's class (\"".. oClass .."\").")
          end
        end
      end
      for _, name in pairs(NAMES) do
        if string.find(name:lower(), object.Name:lower()) then
          if QUARANTINE then
            if object:FindFirstChild("quarantined") then
              return
            end
            local oName, oClass, oParent = object.Name, object.ClassName, object.Parent.Name
            local quarantined = Instance.new("StringValue")
            quarantined.Name = "quarantined"
            quarantined.Parent = object
            object.Parent = Lighting
            warn("CNT: AV: Quarantined (moved to Lighting) object \"".. oName .."\" because of it's name. Object's class was \"".. oClass .."\" and parent was \"".. oParent .."\".")
          else
            local oName, oClass = object.Name, object.ClassName
            object:Destroy()
            warn("CNT: AV: Removed object \"".. oName .."\" because of it's name. Object's class was \"".. oClass .."\".")
          end
        end
      end
    end
  end
end
