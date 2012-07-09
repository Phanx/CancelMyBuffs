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
				desc = L["Add, remove, and configure bindings for cancelling buffs. These settings are stored on a per-profile basis."],
				type = "group",
				args = {
					notes = {
						order = 1,
						name = L["Add, remove, and configure bindings for cancelling buffs. These settings are stored on a per-profile basis."],
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
						desc = L["Create a new binding with this name."],
						type = "input",
						validate = function(info, name)
							if name and #name > 0 then
								return self:NewBinding(name)
							else
								return false, L["Binding names cannot be blank. You must enter at least one letter to create a new binding."]
							end
						end,
						set = function(info, name)
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
						desc = L["Create a new buff group with this name."],
						type = "input",
						set = function(info, name)
							self:NewBuffGroup(name)
						end,
					}
				}
			},
			about = {
				order = 4,
				name = L["About"],
				type = "group",
				args = {},
			}
		}
	}

	do
		local aboutLines = {
			"This is a |cffffff00BETA|r version of CancelMyBuffs. It has been rewritten from the ground up, with a focus on configurability.",
			" ",
			"Bindings are now unlimited, so you can have as many as you want. Buffs and buff groups can be configured in-game, including limiting buffs to certain classes.",
			" ",
			"Bindings are stored on a per-profile basis. Buffs and buff groups are stored on a per-account basis, so they are available to all profiles.",
			" ",
			"If you encounter any problems, |cffffff00please|r report them! I don't have a lot of time to test every possible combination of settings, so I need your help to make sure there aren't any bugs.",
			" ",
			"I also welcome feedback on the options layout. Feel free to let me know which parts of the menus are confusing, or could be better arranged.",
		}
		for i, text in ipairs(aboutLines) do
			self.options.args.about.args[tostring(i)] = {
				order = i,
				name = text,
				type = "description",
			}
		end
		self.options.args.about.args[tostring(#aboutLines + 1)] = {
			order = #aboutLines + 1,
			name = "Post feedback here:",
			type = "input",
			get = function() return "http://www.wowinterface.com/forums/showthread.php?t=43157" end,
			set = function() end,
		}
	end


	self.options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.options.args.profiles.order = 3

	for bindingID in pairs(self.db.profile.bindings) do
		self.options.args.bindings.args[tostring(bindingID)] = self:GetBindingOptions(bindingID)
	end
	for groupName in pairs(self.db.global.buffGroups) do
		self.options.args.buffGroups.args[groupName] = self:GetBuffGroupOptions(groupName)
	end

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("CancelMyBuffs2", self.options)

	local dialog = LibStub("AceConfigDialog-3.0")
	self.optionsPanels = {
		bindings = dialog:AddToBlizOptions("CancelMyBuffs2", "CancelMyBuffs2", nil, "bindings"),
		buffGroups = dialog:AddToBlizOptions("CancelMyBuffs2", L["Buff Groups"], "CancelMyBuffs2", "buffGroups"),
		profiles = dialog:AddToBlizOptions("CancelMyBuffs2", self.options.args.profiles.name, "CancelMyBuffs2", "profiles"),
		about = dialog:AddToBlizOptions("CancelMyBuffs2", L["About"], "CancelMyBuffs2", "about"),
	}

	SLASH_CMBTWO1 = "/cmb2"
	SlashCmdList.CMBTWO = function()
		InterfaceOptionsFrame_OpenToCategory(self.optionsPanels.about)
		InterfaceOptionsFrame_OpenToCategory(self.optionsPanels.bindings)
	end
end