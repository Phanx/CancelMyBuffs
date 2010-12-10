--[[--------------------------------------------------------------------
	CancelMyBuffs
	Cancel unwanted buffs quickly and easily.
	by Phanx < addons@phanx.net >
	http://www.wowinterface.com/downloads/info18447-CancelMyBuffs.html
	http://wow.curse.com/downloads/wow-addons/details/cancelmybuffs.aspx

	Copyright © 2010 Phanx
	I, the copyright holder of this work, hereby release it into the public
	domain. This applies worldwide. In case this is not legally possible: I
	grant anyone the right to use this work for any purpose, without any
	conditions, unless such conditions are required by law.
----------------------------------------------------------------------]]

local ADDON_NAME, ns = ...

local _, class, _, race, _, faction = UnitClass("player"), UnitRace("player"), UnitFactionGroup("player")

local L = setmetatable(ns.L or { }, { __index = function(t, k)
	if k == nil then return "" end
	local v = tostring(k)
	t[k] = k
	return k
end })

_G["BINDING_HEADER_CANCELMYBUFFS"] = ADDON_NAME
_G["BINDING_NAME_CLICK CancelMyBuffsButton:LeftButton"] = L["Cancel buffs"]

------------------------------------------------------------------------

local defaults = {
	profile = {
		[1] = {
			forms = false,
			mounts = false,
			vehicles = false,
			weaponBuffs = false,
			buffGroups = {
				["General"] = true,
				["Shapeshift"] = true,
				["Slow Fall"] = true,
			},
		},
	},
	global = {
		["Invulnerability"] = {
			[46924] = "WARRIOR", -- Blade Storm
			[19263] = "HUNTER", -- Deterrence
			[1022]  = true, -- Hand of Protection
			[45438] = "MAGE", -- Ice Block
		},
		["Stealth"] = {
			[66]    = "MAGE", -- Invisibility
			[58984] = "NightElf", -- Shadowmeld
			[1784]  = "ROGUE", -- Stealth
			[1856]  = "ROGUE", -- Vanish -- check 11327
		},
		["Controllers"] = {
			[37868] = true, -- Arcano-Scorp Control
			[75111] = true, -- Blue Crashin' Thrashin' Racer Controller
			[30019] = true, -- Control Piece (Karazhan)
			[49352] = true, -- Crashin' Thrashin' Racer Controller
			[45440] = true, -- Steam Tonk Controller
		},
		["Deathbringer's Will"] = {
			[71485] = true, -- Agility of the Vrykul
			[71556] = true, -- Agility of the Vrykul (Heroic)
			[71491] = true, -- Aim of the Iron Dwarves
			[71559] = true, -- Aim of the Iron Dwarves (Heroic)
			[71486] = true, -- Power of the Taunka
			[71558] = true, -- Power of the Taunka (Heroic)
			[71492] = true, -- Speed of the Vrykul
			[71560] = true, -- Speed of the Vrykul (Heroic)
			[71484] = true, -- Strength of the Taunka
			[71561] = true, -- Strength of the Taunka (Heroic)
		},
		["Shapeshifts"] = {
			[24732] = true, -- Bat Costume
			[6406]  = "Alliance", -- Furbolg Form (from Dartol's Rod of Transformation)
			[22736] = true, -- Gordok Ogre Suit
			[58501] = true, -- Iron Boot Flask
			[16591] = true, -- Noggenfogger Elixir (skeleton)
			[30167] = true, -- Red Ogre Costume (from Carved Ogre Idol)
			[61716] = true, -- Rabbit Costume (from Blossoming Branch)
			[75724] = true, -- Seeds of Discord (from Ogre Disguise quest item)
			[24723] = true, -- Skeleton Costume
			[24740] = true, -- Wisp Costume
		},
		["Cosmetic Effects"] = {
			[60122] = true, -- Baby Spice
			[27571] = true, -- Cascade of Roses (from Handful of Roses)
			[51010] = true, -- Dire Brew
			[24735] = true, -- Ghost Costume
			[44185] = true, -- Jack-o'-Lanterned! (cast by Headless Horseman)
			[44212] = true, -- Jack-o'-Lanterned! (from Weighted Jack-o'-Lantern)
			[24712] = true, -- Leper Gnome Costume
			[61819] = true, -- Manabonked! (from The Mischief Maker)
			[61834] = true, -- Manabonked! (cast by Minigob Manabonk)
			[69285] = true, -- Mohawked! -- check 58493
			[42365] = true, -- Murloc Costume
			[24710] = true, -- Ninja Costume
			[60106] = true, -- Old Spices
			[24709] = true, -- Pirate Costume
			[44755] = true, -- Snowflakes (from Handful of Snowflakes)
			[61815] = true, -- Sprung! (from Spring Flowers)
			[61781] = true, -- Turkey Feathers
		},
		["Slow Fall"] = {
			[1706]  = true, -- Levitate
			[16593] = true, -- Noggenfogger Elixir (slow fall)
			[130]   = true, -- Slow Fall
		},
		["Divine Shield"] = {
			[642]   = "PALADIN", -- Divine Shield
		},
		["Hellfire"] = {
			[1949]  = "WARLOCK", -- Hellfire
			[85403] = "WARLOCK", -- Hellfire (Demonology spec version)
		},
		["Shadowmourne"] = {
			[73422] = true, -- Chaos Bane (Shadowmourne proc) (ret paladins want to cancel it)
		},
	}
}

------------------------------------------------------------------------

local groupOrder = {
	["Invulnerability"]     = 1,
	["Controllers"]     	= 2,
	["Shapeshifts"]         = 3,
	["Deathbringer's Will"] = 4,
	["Cosmetic Effects"]    = 5,
	["Slow Fall"]           = 6,
	["Stealth"]             = 7,
	["Divine Shield"]       = 8,
	["Hellfire"]            = 9,
	["Shadowmourne"]        = 10,
}

local buffList = { }

local CANCELMYBUFFS_BINDING = "CLICK CancelMyBuffsButton:LeftButton"

local CancelMyBuffs = LibStub("AceAddon-3.0"):NewAddon("CancelMyBuffs")

function CancelMyBuffs:Print(text, ...)
	if (...) then
		if text:find("%%") then
			text = text:format(...)
		else
			text = string.concat(" ", text, ...)
		end
	end
	print("|cff33ff99CancelMyBuffs:|r", text)
end

function CancelMyBuffs:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("CancelMyBuffsDB", defaults, true)

	self.button = CreateFrame("Button", "CancelMyBuffsButton", nil, "SecureActionButtonTemplate")
	self.button:RegisterForClicks("AnyUp")
end

function CancelMyBuffs:OnEnable()
	self:SetupButton()

	self:SetupOptions()

	if not GetBindingKey(CANCELMYBUFFS_BINDING) then
		self:Print([[No key binding set! Type "/cmb" for options.]])
	end

	-- self:RegisterEvent("UNIT_AURA")
end

function CancelMyBuffs:UNIT_AURA(event, unit)
	if unit ~= "player" then return end

	for buff in pairs(buffList) do
		if UnitBuff(unit, buff) then
			return self:Alert()
		end
	end
end

function CancelMyBuffs:Alert(bindGroup)
	UIErrorsFrame:AddMessage(bindGroup.name .. " buff found! Press " .. bindGroup.bind .. " to cancel!", bindGroup.color[1] or 1, bindGroup.color[2] or 1, bindGroup.color[3] or 1)
end

------------------------------------------------------------------------

function CancelMyBuffs:SetupButton()
	local _, class = UnitClass("player")

	local macrotext = ""
	if self.db.profile[1].forms and (class == "DRUID" or class == "PRIEST" or class == "SHAMAN") then
		macrotext = macrotext .. "\n/cancelform"
	end
	if self.db.profile[1].mounts then
		macrotext = macrotext .. "\n/dismount"
	end
	if self.db.profile[1].vehicles then
		macrotext = macrotext .. "\n/run if UnitHasVehicleUI(\"player\")then VehicleExit()end"
	end
	if self.db.profile[1].weaponBuffs and (class == "ROGUE" or class == "SHAMAN") then
		if not TemporaryEnchantFrame:IsShown() then
			TempEnchant1:SetID(16)
			TempEnchant2:SetID(17)
			TempEnchant3:SetID(18)
		end
		macrotext = macrotext .. "\n/click TempEnchant1 RightButton\n/click TempEnchant2 RightButton\n/click TempEnchant3 RightButton"
	end

	wipe(buffList)
	for group, enabled in pairs(self.db.profile[1].buffGroups) do
		if enabled then
			local buffs = self.db.global[group]
			if buffs then
				for id, enabled in pairs(buffs) do
					if type(enabled) == "string" then
						enabled = (enabled == class) or (enabled == race) or (enabled == faction)
					end
					if enabled then
						local name, _, icon = GetSpellInfo(id)
						if name and not buffList[name] then
							buffList[name] = icon
							macrotext = macrotext .. "\n/cancelaura " .. name
						end
					end
				end
			end
		end
	end
	macrotext = macrotext:sub(2)

	if macrotext:len() > 1000 then
		self:Print("Too many buffs selected!")
		macrotext = macrotext:sub(1, 1024):match("(.+)\n/[^\/]+$")
	end

	self.button:SetAttribute("type1", "macro")
	self.button:SetAttribute("macrotext1", macrotext)
end

------------------------------------------------------------------------

function CancelMyBuffs:SetupOptions()
	if self.options then return end

	self.options = {
		name = "CancelMyBuffs",
		desc = L["CancelMyBuffs lets you quickly cancel unwanted buffs."],
		type = "group",
		get = function(t)
			return self.db.profile[1][t[#t]]
		end,
		set = function(t, v)
			self.db.profile[1][t[#t]] = v
			self:SetupButton()
		end,
		args = {
			addoninfo = {
				name = L["CancelMyBuffs lets you quickly cancel unwanted buffs."],
				type = "description",
				order = 5,
			},
			spacer0 = {
				name = " ",
				type = "description",
				order = 6,
			},
			keybinding = {
				name = L["Key Binding"],
				order = 10, width = "full",
				type = "keybinding",
				get = function()
					return GetBindingKey(CANCELMYBUFFS_BINDING)
				end,
				set = function(_, v)
					-- clear any previous bindings
					local prev1, prev2 = GetBindingKey(CANCELMYBUFFS_BINDING)
					if prev1 == v then return end
					if prev1 then SetBinding(prev1) end
					if prev2 then SetBinding(prev2) end

					if v and v:len() > 0 then
						-- warn if overwriting an existing binding
						local curr = GetBindingAction(v)
						if curr and curr:len() > 0 then print(KEY_UNBOUND_ERROR:format(curr)) end

						-- set new binding
						SetBinding(v, CANCELMYBUFFS_BINDING)
					end

					-- restore second binding if there was one
					if prev2 then SetBinding(prev2, CANCELMYBUFFS_BINDING) end

					-- save
					SaveBindings(GetCurrentBindingSet())
				end,
			},
			spacer1 = {
				name = " ",
				type = "description",
				order = 15,
			},
			mounts = {
				name = L["Dismount"],
				desc = L["Also dismount when cancelling buffs."],
				order = 20, width = "double",
				type = "toggle",
			},
			vehicles = {
				name = L["Leave vehicle"],
				desc = L["Also leave vehicles when cancelling buffs."],
				order = 30, width = "double",
				type = "toggle",
			},
			forms = {
				name = L["Leave form"],
				desc = L["Also cancel forms when cancelling buffs."],
				order = 40, width = "double",
				type = "toggle",
			},
			weaponBuffs = {
				name = L["Remove weapon buffs"],
				desc = L["Also remove weapon buffs when cancelling buffs."],
				order = 50, width = "double",
				type = "toggle",
			},
			spacer2 = {
				name = " ",
				type = "description",
				order = 55,
			},
			buffGroups = {
				name = L["Remove buffs"],
				desc = L["Select which buffs to remove."],
				order = 60,
				type = "group", inline = true,
				get = function(t) return
					self.db.profile[1].buffGroups[t[#t]]
				end,
				set = function(t, v)
					self.db.profile[1].buffGroups[t[#t]] = v
					self:SetupButton()
				end,
				args = {
				},
			},
		},
	}

	local t1, t2 = { }, { }
	for groupName, groupBuffs in pairs(self.db.global) do
		self.options.args.buffGroups.args[groupName] = {
			name = L[groupName],
			desc = function()
				wipe(t1)
				wipe(t2)
				for id, enabled in pairs(groupBuffs) do
					if type(enabled) == "string" then
						enabled = (enabled == class) or (enabled == race) or (enabled == faction)
					end
					if enabled then
						local name, _, icon = GetSpellInfo(id)
						if name and not t1[name] then
							t1[name] = icon
							table.insert(t2, name)
						end
					end
				end
				if #t2 > 0 then
					table.sort(t2)
					for i, v in ipairs(t2) do
						t2[i] = "|T" .. t1[v] .. ":0|t " .. v
					end
					return table.concat(t2, "\n")
				end
			end,
			order = groupOrder[groupName] or nil,
			width = "double",
			type = "toggle",
			disabled = function()
				wipe(t1)
				wipe(t2)
				for id, enabled in pairs(groupBuffs) do
					if type(enabled) == "string" then
						enabled = (enabled == class) or (enabled == race) or (enabled == faction)
					end
					if enabled then
						local name, _, icon = GetSpellInfo(id)
						if name and not t1[name] then
							t1[name] = icon
							table.insert(t2, name)
						end
					end
				end
				return #t2 == 0
			end,
		}
	end

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("CancelMyBuffs", self.options)

	self.optionsPanel = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("CancelMyBuffs")

	self.aboutPanel = LibStub("LibAboutPanel").new("CancelMyBuffs", "CancelMyBuffs")

	SLASH_CANCELMYBUFFS1 = "/cmb"
	SlashCmdList.CANCELMYBUFFS = function()
		InterfaceOptionsFrame_OpenToCategory(self.aboutPanel)
		InterfaceOptionsFrame_OpenToCategory(self.optionsPanel)
	end
end