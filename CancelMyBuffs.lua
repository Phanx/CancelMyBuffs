--[[--------------------------------------------------------------------
	CancelMyBuffs
	Cancel unwanted buffs quickly and easily.
	by Phanx < addons@phanx.net >
	Copyright © 2010 Phanx. Some rights reserved. See LICENSE.txt for details.
	http://www.wowinterface.com/downloads/info18447-CancelMyBuffs.html
	http://wow.curse.com/downloads/wow-addons/details/cancelmybuffs.aspx
----------------------------------------------------------------------]]

local ADDON_NAME, ns = ...

local _, class, _, race, _, faction = UnitClass( "player" ), UnitRace( "player" ), UnitFactionGroup( "player" )

if not ns.L then ns.L = {} end
local L = setmetatable( ns.L, { __index = function( t, k )
	if k == nil then return "" end
	local v = tostring( k )
	t[ k ] = k
	return k
end } )

_G["BINDING_HEADER_CANCELMYBUFFS"] = ADDON_NAME
_G["BINDING_NAME_CLICK CancelMyBuffsButton:LeftButton"] = L["Cancel buffs"]

------------------------------------------------------------------------

local defaults = {
	profile = {
		[1] = {
			name = string.format( L["Group %d"], 1 ),
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
			[75111] = true, -- Blue Crashin' Thrashin' Racer Controller
			[30019] = true, -- Control Piece (Karazhan)
			[49352] = true, -- Crashin' Thrashin' Racer Controller
			[45440] = true, -- Steam Tonk Controller
			[65451] = true, -- Using MiniZep Controller
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
		["Flask of Enhancement"] = {
			[79639] = true, -- Enhanced Agility
			[79640] = true, -- Enhanced Intellect
			[79638] = true, -- Enhanced Strength
		},
		["Shapeshifts"] = {
			[24732] = true, -- Bat Costume
			[6406]  = "Alliance", -- Furbolg Form (from Dartol's Rod of Transformation)
			[22736] = true, -- Gordok Ogre Suit
			[88715] = true, -- Herbouflage (from Lifegiving Seed quest item)
			[58501] = true, -- Iron Boot Flask
			[16591] = true, -- Noggenfogger Elixir (skeleton)
			[30167] = true, -- Red Ogre Costume (from Carved Ogre Idol)
			[61716] = true, -- Rabbit Costume (from Blossoming Branch)
			[24723] = true, -- Skeleton Costume
			[21848] = true, -- Snowman
			[24740] = true, -- Wisp Costume
		},
		["Quest Effects"] = {
			[37868] = true, -- Arcano-Scorp Control
			[77647] = true, -- Fel-Infused (from killing mobs in Dustwind Cave)
			[75724] = true, -- Seeds of Discord (from Ogre Disguise quest item)
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
			[26157] = true, -- PX-238 Winter Wondervolt
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

local buffList = { }

local CANCELMYBUFFS_BINDING = "CLICK CancelMyBuffsButton:LeftButton"

local CancelMyBuffs = LibStub( "AceAddon-3.0" ):NewAddon( "CancelMyBuffs" )

function CancelMyBuffs:Print( text, ... )
	if not text then return end
	if text:find( "%%" ) then
		text = text:format( tostringall( ... ) )
	else
		text = string.join( " ", text, tostringall ( ... ) )
	end
	print( "|cff33ff99CancelMyBuffs:|r", text )
end

local DEBUG = true
function CancelMyBuffs:Debug( text, ... )
	if not DEBUG then return end
	if not text then return end
	if text:find( "%%" ) then
		text = text:format( tostringall( ... ) )
	else
		text = string.join( " ", text, tostringall ( ... ) )
	end
	print( "|cffff6666CancelMyBuffs:|r", text )
end

function CancelMyBuffs:OnInitialize() -- self:Debug("OnInitialize")
	self.db = LibStub( "AceDB-3.0" ):New( "CancelMyBuffsDB", defaults, true )

	self.button = CreateFrame( "Button", "CancelMyBuffsButton", nil, "SecureActionButtonTemplate" )
	self.button:RegisterForClicks( "AnyUp" )
end

function CancelMyBuffs:OnEnable() -- self:Debug("OnEnable")
	hooksecurefunc(TemporaryEnchantFrame, "Hide", function()
		TempEnchant1:SetID( 16 )
		TempEnchant2:SetID( 17 )
		TempEnchant3:SetID( 18 )
	end)

	self:SetupButton()

	self:SetupOptions()

	local key = self.db.profile[ 1 ].binding
	if not key then
		key = GetBindingKey( CANCELMYBUFFS_BINDING )
		self.db.profile[ 1 ].binding = key
	end
	if not key then
		self:Print( [[No key binding set! Type "/cmb" for options.]] )
	else
		SetBinding( key, CANCELMYBUFFS_BINDING )
	end
end

------------------------------------------------------------------------

function CancelMyBuffs:SetupButton() -- self:Debug("SetupButton")
	local _, class = UnitClass( "player" )

	local macrotext = ""
	if self.db.profile[ 1 ].forms and ( class == "DRUID" or class == "PRIEST" or class == "SHAMAN" ) then
		macrotext = macrotext .. "\n/cancelform"
	end
	if self.db.profile[ 1 ].mounts then
		macrotext = macrotext .. "\n/dismount"
	end
	if self.db.profile[ 1 ].vehicles then
		macrotext = macrotext .. "\n/run if UnitHasVehicleUI(\"player\")then VehicleExit()end"
	end
	if self.db.profile[ 1 ].weaponBuffs and ( class == "ROGUE" or class == "SHAMAN" ) then
		if not TemporaryEnchantFrame:IsShown() then
			TempEnchant1:SetID( 16 )
			TempEnchant2:SetID( 17 )
			TempEnchant3:SetID( 18 )
		end
		macrotext = macrotext .. "\n/click TempEnchant1 RightButton\n/click TempEnchant2 RightButton\n/click TempEnchant3 RightButton"
	end

	wipe( buffList )
	for group, groupEnabled in pairs( self.db.profile[ 1 ].buffGroups ) do
		if type( groupEnabled ) == "string" then
			groupEnabled = ( groupEnabled == class ) or ( groupEnabled == race ) or ( groupEnabled == faction )
		end
		if groupEnabled then
			local buffs = self.db.global[ group ]
			if buffs then
				for id, buffEnabled in pairs( buffs ) do
					if type( buffEnabled ) == "string" then
						buffEnabled = ( buffEnabled == class ) or ( buffEnabled == race ) or ( buffEnabled == faction )
					end
					if buffEnabled then
						local name, _, icon = GetSpellInfo( id )
						if name and not buffList[ name ] then
							buffList[ name ] = icon
							macrotext = macrotext .. "\n/cancelaura " .. name
						end
					end
				end
			end
		end
	end
	macrotext = macrotext:sub( 2 ) -- .. "\n/run print(\"click\")"

	if macrotext:len() > 1000 then
		self:Print( "Too many buffs selected!" )
		macrotext = macrotext:sub( 1, 1024 ):match( "( .+ )\n/[^\/]+$" )
	end

	self.button:SetAttribute( "type1", "macro" )
	self.button:SetAttribute( "macrotext1", macrotext )
end