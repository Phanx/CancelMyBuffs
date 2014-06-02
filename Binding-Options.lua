--[[--------------------------------------------------------------------
	CancelMyBuffs
	Quickly and easily remove unwanted buffs using keybindings.
	Copyright (c) 2010-2014 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info18447-CancelMyBuffs.html
	http://www.curse.com/addons/wow/cancelmybuffs
----------------------------------------------------------------------]]

local _, addon = ...
local L = addon.L

------------------------------------------------------------------------

local name_get = function(info)
	return info.arg
end

local name_set = function(info, name)
	addon:RenameBinding(info.arg, name)
end

------------------------------------------------------------------------

local key_get = function(info)
	return addon.db.profile.bindings[info.arg].key
end

local key_set = function(info, key)
	local success, message = addon:SetBindingKey(info.arg, key)
	if success then
		addon.db.profile.bindings[info.arg].key = key
	else
		UIErrorsFrame:AddMessage(message)
	end
end

------------------------------------------------------------------------

local verbose_get = function(info)
	return addon.db.profile.bindings[info.arg].verbose
end

local verbose_set = function(info, checked)
	addon.db.profile.bindings[info.arg].verbose = checked
end

------------------------------------------------------------------------

local special_get = function(info)
	return addon.db.profile.bindings[info.arg][info[#info]]
end

local special_set = function(info, checked)
	addon.db.profile.bindings[info.arg][info[#info]] = checked
	addon:UpdateBinding(info.arg)
end

------------------------------------------------------------------------

local buffs_get = function(info)
	return addon.db.profile.bindings[info.arg].buffGroups[info[#info]]
end

local buffs_set = function(info, enabled)
	if not checked then
		checked = nil
	end
	addon.db.profile.bindings[info.arg].buffGroups[info[#info]] = enabled
	addon:UpdateBinding(info.arg)
end

------------------------------------------------------------------------

local group_desc, group_disabled
do
	local t, e = {}, 0

	local function update(info)
		e = 0
		wipe(t)
		local groupName = info[#info]
		for id in pairs(addon.db.global.buffGroups[groupName]) do
			local name = addon.spellNames[id]
			if not name then
				name = tostring(id)
			end
			local enabled = addon:IsBuffEnabled(groupName, id)
			if enabled and not t[name] then
				e = e + 1
				t[#t+1] = name
				t[name] = addon.spellStrings[id] or name
			elseif not enabled and not t[name] then
				t[#t+1] = name
				t[name] = addon.spellStringsDisabled[id] or name
			end
		end
		sort(t)
	end

	group_desc = function(info)
		update(info)
		local desc = t[t[1]]
		for i = 2, #t do
			desc = desc .. "\n" .. t[t[i]]
		end
		return desc
	end

	group_disabled = function(info)
		update(info)
		return e == 0
	end
end

------------------------------------------------------------------------

local delete_confirm = function(info)
	return format(L["Are you sure you want to delete the %s binding?"], info.arg)
end

local delete_func = function(info)
	addon:RemoveBinding(info.arg)
end

------------------------------------------------------------------------

function addon:GetBindingOptions(name)
	self:Debug("GetBindingOptions", name)

	local bindingName = name

	local options = {
		name = bindingName,
		type = "group",
		args = {
			name = {
				order = 1,
				width = "double",
				name = L["Name"],
				desc = L["The name to use for this binding."],
				type = "input",
				arg = bindingName,
				get = name_get,
				set = name_set,
			},
			key = {
				order = 2,
				name = KEY_BINDING,
				desc = L["Press a key to assign it to this binding."],
				type = "keybinding",
				arg = bindingName,
				get = key_get,
				set = key_set,
			},
		--[[
			verbose = {
				order = 3,
				name = L["Enable reporting"],
				desc = L["Show a message in the chat frame when buffs are cancelled with this binding."],
				type = "toggle",
				arg = bindingName,
				get = verbose_get,
				set = verbose_set,
			},
		]]
			forms = {
				width = "double",
				name = L["Cancel shapeshift forms"],
				desc = L["Cancel shapeshift forms when activating this binding."],
				type = "toggle",
				arg = bindingName,
				get = special_get,
				set = special_set,
			},
			mounts = {
				width = "double",
				name = L["Dismount"],
				desc = L["Dismount when activating this binding."],
				type = "toggle",
				arg = bindingName,
				get = special_get,
				set = special_set,
			},
			vehicles = {
				width = "double",
				name = L["Leave vehicle"],
				desc = L["Exit the vehicle you are controlling when activating this binding."],
				type = "toggle",
				arg = bindingName,
				get = special_get,
				set = special_set,
			},
			weaponBuffs = {
				width = "double",
				name = L["Remove weapon buffs"],
				desc = L["Remove weapon buffs, such as rogue poisons or shaman enchants, when activating this binding."],
				type = "toggle",
				arg = bindingName,
				get = special_get,
				set = special_set,
			},
			buffGroups = {
				order = -2,
				name = L["Buff Groups"],
				desc = L["Select which buffs to cancel with this binding."],
				type = "group",
				dialogInline = true,
				get = buffs_get,
				set = buffs_set,
				args = {},
			},
			delete = {
				order = -1,
				name = L["Remove Binding"],
				desc = L["Remove this binding. This action cannot be undone."],
				type = "execute",
				func = delete_func,
				confirm = delete_confirm,
				arg = bindingName,
			}
		}
	}

	for groupName, groupData in pairs(self.db.global.buffGroups) do
		options.args.buffGroups.args[groupName] = {
			width = "double",
			name = groupName,
			desc = group_desc,
			type = "toggle",
			disabled = group_disabled,
			arg = bindingName,
		}
	end

	return options
end