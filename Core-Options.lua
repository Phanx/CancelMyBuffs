--[[--------------------------------------------------------------------
	CancelMyBuffs
	Quickly and easily remove unwanted buffs using keybindings.
	Copyright (c) 2010-2015 Phanx <addons@phanx.net>. All rights reserved.
	http://www.wowinterface.com/downloads/info18447-CancelMyBuffs.html
	http://www.curse.com/addons/wow/cancelmybuffs
	https://github.com/Phanx/CancelMyBuffs
----------------------------------------------------------------------]]

local CANCELMYBUFFS, addon = ...
local L = addon.L

function addon:LoadOptions()
	if self.options then
		return
	end

	self.options = {
		type = "group",
		args = {
			bindings = {
				order = 1,
				name = L["Bindings"],
				desc = L["Add, remove, and configure bindings for removing buffs. These settings are stored on a per-profile basis."],
				type = "group",
				args = {
					notes = {
						order = 1,
						name = L["Add, remove, and configure bindings for removing buffs. These settings are stored on a per-profile basis."],
						type = "description", cmdHidden = true, dropdownHidden = true,
					},
					spacer = {
						order = 2,
						name = " ",
						type = "description", cmdHidden = true, dropdownHidden = true,
					},
					new = {
						order = 3,
						width = "double",
						name = L["New binding"],
						desc = L["Create a new binding with the specified name."],
						type = "input",
						validate = function(info, name)
							return self:NewBinding(name)
						end,
						set = function(info, name)
							-- Do nothing, since it was already handled in validate.
						end,
					}
				},
			},
			buffGroups = {
				order = 2,
				name = L["Buff Groups"],
				type = "group",
				args = {
					notes = {
						order = 1,
						name = L["Add, remove, and configure buffs and buff groups. These settings are stored on a global basis."],
						type = "description", cmdHidden = true, dropdownHidden = true,
					},
					spacer = {
						order = 2,
						name = " ",
						type = "description", cmdHidden = true, dropdownHidden = true,
					},
					new = {
						order = 3,
						name = L["New buff group"],
						desc = L["Create a new buff group with the specified name."],
						type = "input",
						validate = function(info, name)
							return self:NewBuffGroup(name)
						end,
						set = function(info, name)
							-- Do nothing, since it was already handled in validate.
						end,
					}
				}
			}
		}
	}

	self.options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.options.args.profiles.order = 3

	for bindingID in pairs(self.db.profile.bindings) do
		self.options.args.bindings.args[tostring(bindingID)] = self:GetBindingOptions(bindingID)
	end
	for groupName in pairs(self.db.global.buffGroups) do
		self.options.args.buffGroups.args[groupName] = self:GetBuffGroupOptions(groupName)
	end

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(CANCELMYBUFFS, self.options)

	local dialog = LibStub("AceConfigDialog-3.0")
	self.optionsPanels = {
		bindings = dialog:AddToBlizOptions(CANCELMYBUFFS, CANCELMYBUFFS, nil, "bindings"),
		buffGroups = dialog:AddToBlizOptions(CANCELMYBUFFS, L["Buff Groups"], CANCELMYBUFFS, "buffGroups"),
		profiles = dialog:AddToBlizOptions(CANCELMYBUFFS, self.options.args.profiles.name, CANCELMYBUFFS, "profiles"),
		about = LibStub("LibAboutPanel").new(CANCELMYBUFFS, CANCELMYBUFFS),
	}

	SLASH_CANCELMYBUFFS1 = "/cmb"
	SLASH_CANCELMYBUFFS2 = "/cancelmybuffs"
	SlashCmdList.CANCELMYBUFFS = function()
		InterfaceOptionsFrame_OpenToCategory(self.optionsPanels.about)
		InterfaceOptionsFrame_OpenToCategory(self.optionsPanels.bindings)
	end
end