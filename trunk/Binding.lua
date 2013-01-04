--[[--------------------------------------------------------------------
	CancelMyBuffs
	Quickly and easily remove unwanted buffs using keybindings.
	Copyright (c) 2010-2013 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info18447-CancelMyBuffs.html
	http://www.curse.com/addons/wow/cancelmybuffs
----------------------------------------------------------------------]]

local _, addon = ...
local L = addon.L

function addon:NewBinding(bindingName)
	if bindingName == nil then bindingName = "" end
	self:Debug("NewBinding", bindingName)

	if type(bindingName) ~= "string" then
		return false, "Binding name must be a string." -- Not localized because this cannot happen through AceConfig.
	elseif bindingName:trim():len() < 1 then
		return false, L["Binding names cannot be blank. You must enter at least one non-whitespace character to create a new binding."]
	elseif self.db.profile.bindings[bindingName] then
		return false, L["That name is already used by another binding."]
	end

	--------------------------------------------------------------------
	--	Settings
	--
	--	groups  - table   - list of buff groups to cancel with this binding
	--	key     - string  - key to activate this binding
	--	verbose - boolean - whether to notify in chat when binding activated
	--------------------------------------------------------------------

	self.db.profile.bindings[bindingName] = {
		name = bindingName,
	--	key = nil,
		verbose = false,
		buffGroups = {},
	--	forms = nil,
	--	mounts = nil,
	--	vehicles = nil,
	--	weaponBuffs = nil,
	}

	self:LoadBinding(bindingName)

	return true
end

function addon:LoadBinding(bindingName)
	self:Debug("LoadBinding", bindingName)

	self.options.args.bindings.args[bindingName] = self:GetBindingOptions(bindingName)
	self:UpdateBinding(bindingName)
	self:SetBindingKey(bindingName, self.db.profile.bindings[bindingName].key)

	return true
end

function addon:UnloadBinding(bindingName)
	self:Debug("UnloadBinding", bindingName)

	self.options.args.bindings.args[bindingName] = nil
	self:ClearBindingKey(bindingName)

	return true
end

function addon:RemoveBinding(bindingName)
	self:Debug("RemoveBinding", bindingName)

	self:SetBindingKey(bindingName, nil)
	self:ClearButton(bindingName)

	self.options.args.bindings.args[bindingName] = nil
	self.db.profile.bindings[bindingName] = nil

	return true
end

function addon:RenameBinding(bindingName, newName)
	self:Debug("RenameBinding", bindingName, "-->", newName)

	self:ClearBindingKey(bindingName)
	self:ClearButton(bindingName)

	local db = self.db.profile.bindings[bindingName]
	self.db.profile.bindings[bindingName] = nil
	self.db.profile.bindings[newName] = db
	db.name = newName

	local options = self.options.args.bindings.args[bindingName]
	self.options.args.bindings.args[bindingName] = nil
	self.options.args.bindings.args[newName] = options
	options.name = newName

	self:FindAndReplaceInTable(options, "arg", bindingName, newName)

	self:SetBindingKey(newName, db.key)
	self:UpdateBinding(newName)

	return true
end

do
	local buffList = {}

	function addon:UpdateBinding(bindingName)
		self:Debug("UpdateBinding", bindingName)

		local bindingDB = self.db.profile.bindings[bindingName]

		local macrotext = "\n"--/run print('" .. bindingName .. "')"

		if bindingDB.forms and self.hasForms then
			macrotext = macrotext .. "\n/cancelform"
		end
		if bindingDB.mounts then
			macrotext = macrotext .. "\n/dismount"
		end
		if bindingDB.vehicles then
			macrotext = macrotext .. "\n/leavevehicle"
		end
		if bindingDB.weaponBuffs and self.hasWeaponBuffs then
			if not TemporaryEnchantFrame:IsShown() then
				TempEnchant1:SetID(16)
				TempEnchant2:SetID(17)
				TempEnchant3:SetID(18)
			end
			macrotext = macrotext .. "\n/click TempEnchant1 RightButton\n/click TempEnchant2 RightButton\n/click TempEnchant3 RightButton"
		end

		wipe(buffList)
		for groupName, groupEnabled in pairs(bindingDB.buffGroups) do
			if groupEnabled then
				local groupDB = self.db.global.buffGroups[groupName]
				for buffID, buffEnabled in pairs(groupDB) do
					if self:IsBuffEnabled(groupName, buffID, buffEnabled) then
						local buffName = self.spellNames[buffID]
						if buffName and not buffList[buffName] then
							buffList[buffName] = self.spellIcons[buffID]
							macrotext = macrotext .. "\n/cancelaura " .. buffName
						end
					end
				end
			end
		end

		macrotext = macrotext:sub(2)

		if macrotext:len() > 1024 then
			if not self.lastAlert then
				self.lastAlert = {}
			end

			local now = GetTime()
			if GetTime() - (self.lastAlert[bindingName] or 0) > 30 then
				self:Print(format(L["The %s binding includes too many buffs! Some buffs may not be removed. Try selecting fewer buff groups, removing some unused buffs from your buff groups, or creating a second binding."], bindingName))
				self.lastAlert[bindingName] = now
			end

			macrotext = macrotext:sub(1, 1024):match("(.+)\n/[^\/]+$")
		end

		self:UpdateButton(bindingName, macrotext)

		return true
	end
end

function addon:UpdateAllBindings()
	self:Debug("UpdateAllBindings")

	for bindingName in pairs(self.db.profile.bindings) do
		self:UpdateBinding(bindingName)
	end

	return true
end

function addon:SetBindingKey(bindingName, key)
	self:Debug("SetBindingKey", bindingName, key)

	if InCombatLockdown() then
		return false, L["Bindings cannot be changed in combat."]
	end

	local db = addon.db.profile.bindings[bindingName]
	if not db then
		return false, format("Binding %s not found.", bindingName) -- Not localized because this cannot happen through AceConfig.
	end

	local name = self.db.profile.bindings[bindingName].name

	-- Remove old binding
	local oldKey = self.db.profile.bindings[bindingName].key
	if oldKey then
		SetOverrideBinding(addon.eventFrame, false, oldKey, nil)
	end

	if key and #key > 0 then
		-- Get the button for this binding
		local button = self:GetButton(bindingName)

		-- Apply new binding
		self:Debug("SetOverrideBinding", key, button.command)
		SetOverrideBinding(addon.eventFrame, false, key, button.command)
	end

	return true
end

function addon:ClearBindingKey(bindingName)
	self:Debug("ClearBindingKey", bindingName)

	local key = self.db.profile.bindings[bindingName].key
	if key then
		local button = self:GetButton(bindingName)
		SetOverrideBinding(addon.eventFrame, false, key, button.command)
		self:ClearButton(bindingName)
	end

	return true
end

do
	local i = 0
	local buttons = {}
	local commands = {}
	local unused = {}

	function addon:GetButton(bindingName, doNotCreate)
		self:Debug("GetButton", bindingName, doNotCreate)

		local button = buttons[bindingName]
		if not button and not doNotCreate then
			if InCombatLockdown() then
				return false, "Buttons cannot be created in combat."
			elseif unused[1] then
				button = tremove(unused, 1)
			else
				i = i + 1
				local buttonName = "CancelMyBuffsButton" .. i
				button = CreateFrame("Button", buttonName, nil, "SecureActionButtonTemplate")
				button:RegisterForClicks("AnyUp")
				button.command = "CLICK " .. buttonName .. ":LeftButton"
			end
			buttons[bindingName] = button
		end
		return button
	end

	function addon:UpdateButton(bindingName, macrotext)
		self:Debug("UpdateButton", bindingName, macrotext)

		if InCombatLockdown() then
			return false, "Button attributes cannot be changed in combat."
		end

		local button = self:GetButton(bindingName)
		button:SetAttribute("type1", "macro")
		button:SetAttribute("macrotext1", macrotext)

		return button
	end

	function addon:ClearButton(bindingName)
		self:Debug("ClearButton", bindingName)

		if InCombatLockdown() then
			return false, "Button attributes cannot be changed in combat."
		end

		local button = buttons[bindingName]
		if not button then
			return false, "Button for binding " .. bindingName .. " cannot be cleared because it does not exist."
		end

		buttons[bindingName] = nil
		tinsert(unused, button)

		button:SetAttribute("type1", nil)
		button:SetAttribute("macrotext1", nil)

		return button
	end
end