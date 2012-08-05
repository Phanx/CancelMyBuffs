--[[--------------------------------------------------------------------
	CancelMyBuffs
	Quickly and easily remove unwanted buffs using keybindings.
	Copyright (c) 2010-2012 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info18447-CancelMyBuffs.html
	http://www.curse.com/addons/wow/cancelmybuffs
----------------------------------------------------------------------]]

local _, addon = ...
local L = addon.L

function addon:NewBuffGroup(groupName)
	self:Debug("NewBuffGroup", groupName)

	if self.db.global.buffGroups[groupName] then
		return false, "Group already exists."
	end

	self.db.global.buffGroups[groupName] = {
	}

	self.options.args.buffGroups[groupName] = self:GetBuffGroupOptions(groupName)

	return true
end

function addon:LoadBuffGroup(groupName)
	self:Debug("LoadBuffGroup", groupName)

	self.options.args.buffGroups.args[groupName] = self:GetBuffGroupOptions(groupName)

	return true
end

function addon:UnloadBuffGroup(groupName)
	self:Debug("UnloadBuffGroup", groupName)

	self.options.args.buffGroups.args[groupName] = nil

	return true
end

function addon:RemoveBuffGroup(groupName)
	self:Debug("RemoveBuffGroup", groupName)

	self.db.global.buffGroups[groupName] = nil
	self.options.args.buffGroups.args[groupName] = nil

	addon:UpdateAllBindings()

	return true
end

function addon:RenameBuffGroup(groupName, newName)
	self:Debug("RenameBuffGroup", groupName, "-->", newName)

	local db = self.db.global.buffGroups[groupName]
	self.db.global.buffGroups[groupName] = nil
	self.db.global.buffGroups[newName] = db

	local options = self.options.args.buffGroups[groupName]
	self.options.args.buffGroups[groupName] = nil
	self.options.args.buffGroups[newName] = options
	options.name = newName

	return true
end

function addon:IsBuffEnabled(buffGroup, buffID, buffEnabled)
	if buffEnabled == nil then
		buffEnabled = self.db.global.buffGroups[buffGroup][buffID]
	end

	if type(buffID) == "string" then
		-- TODO: find spell ID
		-- TEMP: disable for now
		return false
	end

	if type(buffEnabled) == "number" then
		return IsSpellKnown(buffEnabled)
	end

	if type(buffEnabled) == "string" then
		return buffEnabled:find(self.class)
	end

	return buffEnabled
end

function addon:AddBuffToGroup(groupName, buffName)
	self:Debug("AddBuffToGroup", groupName, buffName)

	local buffID, buffIcon, _
	if type(buffName) == "number" then
		buffID = buffName
		buffName, _, buffIcon = GetSpellInfo(buffID)
	else
		for id, name in pairs(self.spellNames) do
			if name == buffName then
				buffID = id
				buffIcon = self.spellIcons[id]
				break
			end
		end
	end
	if not buffID then
		local link = GetSpellLink(buffName)
		if link then
			buffID = link:match("spell:(%d+)")
			buffName, _, buffIcon = GetSpellInfo(buffID)
		end
	end
	if not buffID then
		for i = 1, 40 do
			local name, _, icon, _, _, _, _, _, _, _, id = UnitBuff("player", i)
			if not name then
				break
			end
			if name == buffName then
				buffID = id
				buffIcon = icon
				break
			end
		end
	end

	if not buffIcon then
		return false, format(L["%s does not appear to be a valid spell ID or spell name."], buffName or buffID)
	end

	local text = format("|T%s:0:0:0:0:32:32:2:30:2:30|t %s", buffName, buffIcon)
	self.spellNames[buffID] = buffName
	self.spellIcons[buffID] = buffIcon
	self.spellStrings[buffID] = text
	self.spellStringsDisabled[buffID] = "|cff999999" .. text .. "|r"

	self.db.global.buffGroups[groupName][buffID] = true

	self:AddOptionsForBuff(groupName, buffID)

	return true
end

function addon:RemoveBuffFromGroup(groupName, buffID)
	self:Debug("RemoveBuffFromGroup", groupName, buffID)

	self.db.global.buffGroups[groupName][buffID] = nil
	self.options.args.buffGroups.args[groupName].args.buffs.args[tostring(buffID)] = nil

	self:UpdateAllBindings()

	return true
end