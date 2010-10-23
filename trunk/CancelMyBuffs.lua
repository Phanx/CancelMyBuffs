--[[--------------------------------------------------------------------
	CancelMyBuffs
	Cancel unwanted buffs quickly and easily.
	by Phanx < addons@phanx.net >
	http://www.wowinterface.com/addons/
----------------------------------------------------------------------]]

local ADDON_NAME, ns = ...

local L = setmetatable(ns.L or { }, { __index = function(t, k)
	if k == nil then return "" end
	local v = tostring(k)
	t[k] = k
	return k
end })

L["Shadowmourne"] = GetItemInfo(49623) or L["Shadowmourne"]
L["Slow Fall"] = GetSpellInfo(130)

------------------------------------------------------------------------

local defaults = {
	profile = {
		forms = true,
		mounts = true,
		vehicles = true,
		buffGroups = {
			["Invulnerability Effects"] = true,
			["Shapeshift Effects"] = true,
			["Slow Fall"] = true,
		},
	},
	global = {
		["Invulnerability Effects"] = {
			[19263] = true, -- Deterrence
			[1022]  = true, -- Hand of Protection
			[45438] = true, -- Ice Block
		},
		["Shapeshift Effects"] = {
			[71485] = true, -- Agility of the Vrykul
			[71556] = true, -- Agility of the Vrykul (heroic)
			[71491] = true, -- Aim of the Iron Dwarves
			[71559] = true, -- Aim of the Iron Dwarves (heroic)
			[71486] = true, -- Power of the Taunka
			[71558] = true, -- Power of the Taunka (heroic)
			[71492] = true, -- Speed of the Vrykul
			[71560] = true, -- Speed of the Vrykul (heroic)
			[71484] = true, -- Strength of the Taunka
			[71561] = true, -- Strength of the Taunka
			[24732] = true, -- Bat Costume
			[22736] = true, -- Gordok Ogre Suit
			[58501] = true, -- Iron Boot Flask
			[16591] = true, -- Noggenfogger Elixir (skeleton)
			[30167] = true, -- Red Ogre Costume (from Carved Ogre Idol)
			[24740] = true, -- Wisp Costume
		},
		["Cosmetic Effects"] = {
			[60122] = true, -- Baby Spice
			[27571] = true, -- Cascade of Roses (from Handful of Roses)
			[51010] = true, -- Dire Brew
			[6406]  = true, -- Furbolg Form (from Dartol's Rod of Transformation) -- check prevents mounting?
			[24735] = true, -- Ghost Costume
			[44185] = true, -- Jack-o'-Lanterned! (cast by Headless Horseman)
			[44212] = true, -- Jack-o'-Lanterned! (from Weighted Jack-o'-Lantern)
			[24712] = true, -- Leper Gnome Costume
			[61819] = true, -- Manabonked! (from The Mischief Maker)
			[61834] = true, -- Manabonked! (cast by Minigob Manabonk)
			[69285] = true, -- Mohawked! -- check 58493
			[24710] = true, -- Ninja Costume
			[60106] = true, -- Old Spices
			[24709] = true, -- Pirate Costume
			[24723] = true, -- Skeleton Costume -- check prevents mounting?
			[44755] = true, -- Snowflakes (from Handful of Snowflakes)
			[61815] = true, -- Sprung! (from Spring Flowers)
		},
		["Slow Fall"] = {
			[1706]  = true, -- Levitate
			[16593] = true, -- Noggenfogger Elixir (slow fall)
			[130]   = true, -- Slow Fall
		},
		["Shadowmourne"] = {
			[73422] = true, -- Chaos Bane (Shadowmourne proc) (ret paladins want to cancel it)
		},
	}
}

------------------------------------------------------------------------

local buffList = { }

local CancelMyBuffs = LibStub("AceAddon-3.0"):NewAddon("CancelMyBuffs")

function CancelMyBuffs:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("CancelMyBuffsDB", defaults, true)

	self.button = CreateFrame("Button", "CancelMyBuffsButton", nil, "SecureActionButtonTemplate")
	self.button:RegisterForClicks("AnyUp")
end

function CancelMyBuffs:OnEnable()
	local _, class = UnitClass("player")

	local macrotext = ""
	if self.db.profile.forms and (class == "DRUID" or class == "PRIEST" or class == "SHAMAN") then
		macrotext = macrotext .. "\n/cancelform"
	end
	if self.db.profile.mounts then
		macrotext = macrotext .. "\n/dismount"
	end
	if self.db.profile.vehicles then
		macrotext = macrotext .. [[\n/run if UnitHasVehicleUI("player")then VehicleExit()end]]
	end
	for group in pairs(self.db.profile.buffGroups) do
		local buffs = self.db.global[group]
		if group then
			for id, enabled in pairs(buffs) do
				if enabled then
					local name, _, icon = GetSpellInfo(id)
					if name then
						buffList[name] = icon
					end
				end
			end
		end
	end
	for buff in pairs(buffList) do
		macrotext = macrotext .. "\n/cancelaura " .. buff
	end
	macrotext = macrotext:sub(2)

	if macrotext:len() > 1024 then
		print("Too many buffs selected!")
		macrotext = macrotext:sub(1, 1024):match("(.+)\n/[^\/]+$")
	end

	self.button:SetAttribute("type1", "macro")
	self.button:SetAttribute("macrotext1", macrotext)

	self:SetupOptions()

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

function CancelMyBuffs:SetupOptions()
	if self.options then return end

	local CANCELMYBUFFS_BINDING = "CLICK CancelMyBuffsButton:LeftButton"

	self.options = {
		name = "CancelMyBuffs",
		desc = L["CancelMyBuffs lets you quickly cancel unwanted buffs."],
		type = "group",
		get = function(t) return self.db.profile[t[#t]] end,
		set = function(t, v) self.db.profile[t[#t]] = v end,
		args = {
			keybinding = {
				name = L["Key Binding"],
				order = 100, width = "full",
				type = "keybinding",
				get = function()
					return GetBindingKey(CANCELMYBUFFS_BINDING)
				end,
				set = function(_, v)
					SetBinding(value, CANCELMYBUFFS_BINDING)
					SaveBindings(GetCurrentBindingSet())
				end,
			},
			mounts = {
				name = L["Dismount"],
				desc = L["Also dismount when cancelling buffs."],
				order = 200, width = "double",
				type = "toggle",
			},
			vehicles = {
				name = L["Leave Vehicle"],
				desc = L["Also leave vehicles when cancelling buffs."],
				order = 300, width = "double",
				type = "toggle",
			},
			buffGroups = {
				name = L["Remove Buff Groups"],
				desc = L["Select which buffs to remove."],
				order = 500,
				type = "group", inline = true,
				get = function(t) return self.db.profile.buffGroups[t[#t]] end,
				set = function(t, v) self.db.profile.buffGroups[t[#t]] = v end,
				args = {
				},
			},
		},
	}

	for groupName in pairs(self.db.global) do
		self.options.args.buffGroups.args[groupName] = {
			name = L[groupName],
			width = "double",
			type = "toggle",
		}
	end

	self.groupOptions = {
		name = L["Buff Groups"],
		type = "group",
		args = {
		},
	}

	for groupName, groupBuffs in pairs(self.db.global) do
		local t = {
			name = L[groupName],
			type = "group",
			args = {
			}
		}
		for id in pairs(groupBuffs) do
			local name, _, icon = GetSpellInfo(id)
			if name then
				t.args[name] = {
					name = "|T" .. icon .. ":0|t " .. name,
					type = "toggle",
				}
			end
		end
		self.groupOptions.args[groupName] = t
	end

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("CancelMyBuffs", self.options)

	self.optionsPanel = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("CancelMyBuffs")

	self.aboutPanel = LibStub("LibAboutPanel").new("CancelMyBuffs", "CancelMyBuffs")

	SLASH_CANCELMYBUFFS1 = "/cmb"
	SlashCmdList.CANCELMYBUFFS = function()
		InterfaceOptionsFrame_OpenToCategory(self.optionsPanel)
	end
end