--[[--------------------------------------------------------------------
	CancelMyBuffs
	Cancel unwanted buffs quickly and easily.
	by Phanx < addons@phanx.net >
	http://www.wowinterface.com/addons/
----------------------------------------------------------------------]]

local _, ns = ...

local L = setmetatable(ns.L or { }, { __index = function(t, k)
	if k == nil then return "" end
	local v = tostring(k)
	t[k] = k
	return k
end })

L["SLOWFALL"] = GetSpellInfo(130)
L["SHADOWMOURNE"] = GetItemInfo(49623) or L["SHADOWMOURNE"]

------------------------------------------------------------------------

local defaults = {
	profile = {
		{
			name = L["Default"],
			enable = true,
			color = { 1, 1, 0 },
			flash = true,
			sound = "NONE",
			include = {
				["INVULNERABLE"] = true,
				["SHAPESHIFTED"] = true,
				["SLOWFALL"] = true,
			},
		},
		{
			name = L["Weapon Buffs"],
			enable = true,
			color = { 118 / 255, 47 / 255, 170 / 255 },
			flash = false,
			sound = "NONE",
			include = {
				["WEAPONBUFFS"] = true,
			},
		},
	},
	global = {
		["INVULNERABLE"] = {
			[19263] = true, -- Deterrence
			[1022]  = true, -- Hand of Protection
			[45438] = true, -- Ice Block
		},
		["SHAPESHIFTED"] = {
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
			[58501] = true, -- Iron Boot Flask
			[16591] = true, -- Noggenfogger Elixir (skeleton)
			[24740] = true, -- Wisp Costume
		},
		["COSMETIC"] = {
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
			[30167] = true, -- Red Ogre Costume (from Carved Ogre Idol) -- check prevents mounting?
			[24723] = true, -- Skeleton Costume -- check prevents mounting?
			[44755] = true, -- Snowflakes (from Handful of Snowflakes)
			[61815] = true, -- Sprung! (from Spring Flowers)
		},
		["SLOWFALL"] = {
			[1706]  = true, -- Levitate
			[16593] = true, -- Noggenfogger Elixir (slow fall)
			[130]   = true, -- Slow Fall
		},
		["SHADOWMOURNE"] = {
			[73422] = true, -- Chaos Bane (Shadowmourne proc) (ret paladins want to cancel it)
		},
	}
}

------------------------------------------------------------------------

local CancelMyBuffs = LibStub("AceAddon-3.0"):NewAddon("CancelMyBuffs", "AceEvent-3.0")

function CancelMyBuffs:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("CancelMyBuffsDB", { profile = defaults }, true)

	self.buttons = { }
	self.buttonPool = { }
end

function CancelMyBuffs:OnEnable()
	for _, bindGroup in ipairs(self.db.profile) do
		if bindGroup.enable then
			local macrotext = ""
			for groupName in pairs(bindGroup.include) do
				local buffGroup = self.db.buffGroups[groupName]
				if buffGroup then
					for buff in pairs(buffGroup) do
						macrotext = macrotext .. "\n/cancelaura " .. buff
					end
				elseif groupName == "MOUNTED" then
					macrotext = macrotext .. "\n/dismount\n/run ExitVehicle()"
				elseif groupName == "WEAPONBUFFS" then
					macrotext = macrotext = "\n/dismount
				end
			end

			macrotext = macrotext:sub(3)

			if macrotext:len() < 1024 then
				local button = CreateFrame("Button", "CancelMyBuffsButton" .. (#self.buttons + 1), UIParent, "SecureActionButtonTemplate, ActionButtonTemplate")
				button:SetAttribute("type1", "macro")
				button:SetAttribute("macrotext1", macrotext)
				button:SetOverrideBinding()
				self.buttons[#self.buttons + 1] = button
				print("Successfully created binding for", name, "group.")
			else
				print("Could not create binding for", name, "group. Too many buffs selected.")
			end
		end
	end

	if #self.buttons > 0 then
		self:RegisterEvent("UNIT_AURA")
	end
end

function addon:UNIT_AURA(event, unit)
	if unit ~= "player" then return end

	for _, bindGroup in ipairs(self.db.profile) do
		if bindGroup.enable then
			local active
			for groupName in pairs(bindGroup.include) do
				local buffGroup = self.db.buffGroups[groupName]
				if buffGroup then
					for buff in pairs(buffGroup) do
						if UnitBuff(unit, buff) then
							active = true
							break
						end
					end
				end
				if active then
					break
				end
			end
			if active then
				self:Alert(bindGroup)
			end
		end
	end
end

function addon:Alert(bindGroup)
	if not bindGroup.enable then return end

	UIErrorsFrame:AddMessage(bindGroup.name .. " buff found! Press " .. bindGroup.bind .. " to cancel!", bindGroup.color[1] or 1, bindGroup.color[2] or 1, bindGroup.color[3] or 1)
end

------------------------------------------------------------------------

function CancelMyBuffs:NewBindGroup(name)
	if not name then return end
	local groupName = name:gsub("%a", string.upper, 1)

	local bindGroup = {
		name = groupName,
		type = "group", args = {
			enable = true,
			color = { 1, 1, 0 },
			flash = true,
			sound = "NONE",
			include = { },
		}
	}

	table.insert(self.db.profile, bindGroup)
	self.options.args[groupName] = self:GetOptionsForBindGroup(bindGroup)
end

function CancelMyBuffs:GetOptionsForBindGroup(bindGroup)
	local groupName = bindGroup.name
	local option = {
		name = groupName,
		type = "group", guiInline = true, args = {
			enable = {
				order = 100,
				name = L["Enable"],
				desc = L["Enable this binding group."],
				type = "toggle",
				arg = groupName,
				get = function(t)
					for _, group in ipairs(self.db.profile) do
						if group.name == t.arg then
							return group.enable
						end
					end
				end,
				set = function(t, v)
					for _, group in ipairs(self.db.profile) do
						if group.name == t.arg then
							group.enable = v
						end
					end
				end,
			},
			color = {
				order = 200,
				name = L["Color"],
				desc = L["Set the color for this binding group."],
				type = "color",
				arg = groupName,
				get = function(t)
					for _, group in ipairs(self.db.profile) do
						if group.name == t.arg then
							return group.color
						end
					end
				end,
				set = function(t, r, g, b)
					for _, group in ipairs(self.db.profile) do
						if group.name == t.arg then
							group.color[1] = r
							group.color[1] = g
							group.color[1] = b
						end
					end
				end,
			},
			flash = {
				order = 300,
				name = L["Flash"],
				desc = L["Enable screen flashing for this binding group."],
				type = "toggle",
				arg = groupName,
				get = function(t)
					for _, group in ipairs(self.db.profile) do
						if group.name == t.arg then
							return group.flash
						end
					end
				end,
				set = function(t, v)
					for _, group in ipairs(self.db.profile) do
						if group.name == t.arg then
							group.flash = v
						end
					end
				end,
			},
			sound = {
				order = 400,
				type = "toggle",
				arg = groupName,
				get = function(t)
					for _, group in ipairs(self.db.profile) do
						if group.name == t.arg then
							return group.sound
						end
					end
				end,
				set = function(t, v)
					for _, group in ipairs(self.db.profile) do
						if group.name == t.arg then
							group.sound = v
						end
					end
				end,
			},
			include = {
				order = 500,
				name = L["Include buff groups"],
				desc = L["Select which buff groups to include in this binding group."],
				type = "group", guiInline = true, args = {
				},
			},
		},
	}
	for gname in pairs(self.db.global) do
		options.args.include.args[gname] = {
			name = gname,
			desc = L["Include this buff group in this binding group."],
			type = "toggle",
			arg = groupName,
			get = function(t)
				for _, group in ipairs(self.db.profile) do
					if group.name == t.arg then
						return group.include[gname]
					end
				end
			end,
			set = function(t, v)
				for _, group in ipairs(self.db.profile) do
					if group.name == t.arg then
						group.include[gname] = v
					end
				end
			end,
		}
	end
end

------------------------------------------------------------------------

function CancelMyBuffs:SetupOptions()
	if self.options then return end

	self.options = {
		name = "CancelMyBuffs",
		desc = L["CancelMyBuffs lets you quickly cancel unwanted buffs."],
		type = "group", args = {
			new = {
				order = 1,
				name = L["Add new binding group"],
				type = "input", usage = "Type a name for the new binding group",
				set = function(_, text)
					if not text or text:len() < 1 then
						print("Invalid binding group name.")
						return
					end
					for _, bindGroup in ipairs(self.db.profile) do
						if bindGroup.name:lower() == text:lower() then
							print("Binding group name already in use.")
							return
						end
					end
					self:NewBindGroup(name)
				end
			},
		},
	}

	for _, bindGroup in ipairs(self.db.profile) do
		self.options.args[bindGroup.name] = self:GetOptionsForBindGroup(bindGroup)
	end

	local options2 = {
		name = L["Buff Groups"],
		desc = L["Use this panel to add new buffs to cancel."],
		type = "group", args = {
		},
	}
end