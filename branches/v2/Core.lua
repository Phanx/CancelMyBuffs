local _, addon = ...

local L = setmetatable({}, { __index = function(L, k)
	local v = tostring(k)
	rawset(L, k, v)
	return v
end })
addon.L = L

addon.bindingNames = {}
addon.spellNames = {}
addon.spellIcons = {}
addon.spellStrings = {}
addon.spellStringsDisabled = {}

function addon:OnLoad()
	self:Debug("OnLoad")

	local defaults = {
		global = {
			buffGroups = {}
		},
		profile = {
			bindings = {}
		}
	}

	self.db = LibStub("AceDB-3.0"):New("CancelMyBuffsDB2", defaults, true)

	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileLoad")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileLoad")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileLoad")

	self.db.RegisterCallback(self, "OnProfileShutdown", "OnProfileUnload")

	local numBuffGroups = 0
	for groupName, groupBuffs in pairs(self.db.global.buffGroups) do
		numBuffGroups = numBuffGroups + 1
	end
	if numBuffGroups == 0 then
		self.db.global.buffGroups["Invulnerability"] = {
			[46924] = 46924, -- Blade Storm [WARRIOR]
			[19263] = 19263, -- Deterrence [HUNTER]
			[642]   = 642,   -- Divine Shield [PALADIN]
			[1022]  = true,  -- Hand of Protection
			[45438] = 45438, -- Ice Block [MAGE]
		}
		self.db.global.buffGroups["Stealth"] = {
			[66]    = 66,    -- Invisibility [MAGE]
			[5215]  = 5215,  -- Prowl [DRUID]
			[58984] = 58984, -- Shadowmeld [NightElf]
			[1784]  = 1784,  -- Stealth [ROGUE]
			[1856]  = 1856,  -- Vanish [ROGUE] -- check 11327
		}
		self.db.global.buffGroups["Controllers"] = {
			[75111] = true, -- Blue Crashin' Thrashin' Racer Controller
			[30019] = true, -- Control Piece (Karazhan)
			[49352] = true, -- Crashin' Thrashin' Racer Controller
			[45440] = true, -- Steam Tonk Controller
			[65451] = true, -- Using MiniZep Controller
		}
		self.db.global.buffGroups["Shapeshift Effects"] = {
			[24732] = true, -- Bat Costume
			[22736] = true, -- Gordok Ogre Suit
			[58501] = true, -- Iron Boot Flask
			[16591] = true, -- Noggenfogger Elixir [skeleton]
			[30167] = true, -- Red Ogre Costume [Carved Ogre Idol]
			[61716] = true, -- Rabbit Costume [Blossoming Branch]
			[24723] = true, -- Skeleton Costume
			[21848] = true, -- Snowman
			[24740] = true, -- Wisp Costume
		}
		self.db.global.buffGroups["Quest Effects"] = {
			[37868] = true, -- Arcano-Scorp Control
			[77647] = true, -- Fel-Infused [killing mobs in Dustwind Cave]
			[88715] = true, -- Herbouflage [Lifegiving Seed]
			[75724] = true, -- Seeds of Discord [Ogre Disguise quest item]
		}
		self.db.global.buffGroups["Cosmetic Effects"] = {
			[60122] = true, -- Baby Spice
			[27571] = true, -- Cascade of Roses [Handful of Roses]
			[51010] = true, -- Dire Brew
			[24735] = true, -- Ghost Costume
			[44185] = true, -- Jack-o'-Lanterned! [cast by Headless Horseman]
			[44212] = true, -- Jack-o'-Lanterned! [Weighted Jack-o'-Lantern]
			[24712] = true, -- Leper Gnome Costume
			[61819] = true, -- Manabonked! [The Mischief Maker]
			[61834] = true, -- Manabonked! [cast by Minigob Manabonk]
			[69285] = true, -- Mohawked! -- check 58493
			[42365] = true, -- Murloc Costume
			[24710] = true, -- Ninja Costume
			[60106] = true, -- Old Spices
			[24709] = true, -- Pirate Costume
			[26157] = true, -- PX-238 Winter Wondervolt
			[44755] = true, -- Snowflakes [Handful of Snowflakes]
			[61815] = true, -- Sprung! [Spring Flowers]
			[61781] = true, -- Turkey Feathers
		}
		self.db.global.buffGroups["Slow Fall"] = {
			[1706]  = true, -- Levitate
			[16593] = true, -- Noggenfogger Elixir (slow fall)
			[130]   = true, -- Slow Fall
		}
		self.db.global.buffGroups["Water Walking"] = {
			[11319]  = true, -- Elixir of Water Walking
			[1706]   = true, -- Levitate
			[546]    = true, -- Water Walking
		}
		self.db.global.buffGroups["Divine Plea"] = {
			[54428] = 54428, -- Divine Plea [PALADIN]
		}
		self.db.global.buffGroups["Hellfire"] = {
			[1949]  = 1949,  -- Hellfire [WARLOCK]
			[85403] = 85403, -- Hellfire (Demonology version) [WARLOCK]
		}
		self.db.global.buffGroups["Mind Control"] = {
			[605]   = 605, -- Mind Control [PRIEST]
		}
		self.db.global.buffGroups["Flask of Enhancement"] = {
			[79639] = "DRUID HUNTER MONK ROGUE SHAMAN", -- Enhanced Agility
			[79640] = "DRUID MAGE MONK PALADIN PRIEST SHAMAN WARLOCK", -- Enhanced Intellect
			[79638] = "DEATHKNIGHT PALADIN WARRIOR", -- Enhanced Strength
		}
	end
	for groupName, groupBuffs in pairs(self.db.global.buffGroups) do
		for id in pairs(groupBuffs) do
			if type(id) == "number" then
				local name, _, icon = GetSpellInfo(id)
				local text = string.format("|T%s:0:0:0:0:32:32:2:30:2:30|t %s", icon, name)
				if name then
					self.spellNames[id] = name
					self.spellIcons[id] = icon
					self.spellStrings[id] = text
					self.spellStringsDisabled[id] = "|cff999999" .. text .. "|r"
				else
					print("Invalid spell ID", id, "in buff group", groupName)
				end
			end
		end
	end

	local _, class = UnitClass("player")

	self.class = class
	self.hasForms = class == "DRUID" or class == "PRIEST" or class == "SHAMAN" or class == "WARLOCK"
	self.hasWeaponBuffs = class == "ROGUE" or class == "SHAMAN" or class == "WARLOCK"

	hooksecurefunc(TemporaryEnchantFrame, "Hide", function()
		TempEnchant1:SetID(16)
		TempEnchant2:SetID(17)
		TempEnchant3:SetID(18)
	end)

	self:LoadOptions()
	self:OnProfileLoad()
end

function addon:OnProfileLoad()
	self:Debug("OnProfileLoad")

	local numBindings = 0
	for binding in pairs(self.db.profile.bindings) do
		numBindings = numBindings + 1
	end
	if numBindings == 0 then
		self.db.profile.bindings[L["Cancel Buffs"]] = {
		--	key         -- string  - key to activate this binding
			buffGroups = {}, -- table   - list of buff groups to cancel
		--	forms       -- boolean - whether to cancel shapeshift forms
		--	mounts      -- boolean - whether to dismount
		--	vehicles    -- boolean - whether to exit the vehicle
		--  weaponBuffs -- boolean - whether to remove weapon buffs
		}
		self:Print(L["Default configuration loaded. Type \"/cmb\" to bind a key or change settings."])
	end

	for bindingName in pairs(self.db.profile.bindings) do
		self:LoadBinding(bindingName)
	end
	for groupName in pairs(self.db.global.buffGroups) do
		self:LoadBuffGroup(groupName)
	end
end

function addon:OnProfileUnload()
	self:Debug("OnProfileUnload")
	for bindingName in pairs(self.db.profile.bindings) do
		self:UnloadBinding(bindingName)
	end
	for groupName in pairs(self.db.global.buffGroups) do
		self:UnloadBuffGroup(groupName)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	f:UnregisterAllEvents()
	f:SetScript("OnEvent", nil)
	addon.eventFrame = f
	return addon:OnLoad()
end)

function addon:FindAndReplaceInTable(tbl, key, old, new)
	for k, v in pairs(tbl) do
		if k == key then
			tbl[k] = new
		elseif type(v) == "table" then
			tbl[k] = self:FindAndReplaceInTable(v, key, old, new)
		end
	end
	return tbl
end

addon.debug = false
function addon:Debug(str, ...)
	if not str or not self.debug then return end
	if type(str) == "string" and str:match("%%[dsx%d%.]") then
		print("|cffff9999CMB2:|r", str:format(...))
	else
		print("|cffff9999CMB2:|r", str, ...)
	end
end

function addon:Print(str, ...)
	local noPrefix
	if type(str) == "boolean" and str then
		str = select(1, ...)
		noPrefix = true
	end
	if type(str) == "string" and str:match("%%[dsx%d%.]") then
		if noPrefix then
			print("|cffffcc00CancelMyBuffs:|r", str:format(select(2, ...)))
		else
			print("|cffffcc00CancelMyBuffs:|r", str:format(...))
		end
	elseif noPrefix then
		print("|cffffcc00CancelMyBuffs:|r", str, select(2, ...))
	else
		print("|cffffcc00CancelMyBuffs:|r", str, ...)
	end
end

_G.CMB2 = addon