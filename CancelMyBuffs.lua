--[[--------------------------------------------------------------------
	CancelMyBuffs
	Cancel unwanted buffs quickly and easily.
	Written by Phanx <addons@phanx.net>
	Maintained by Akkorian <akkorian@hotmail.com>
	Copyright © 2010–2011 Phanx. Some rights reserved. See LICENSE.txt for details.
	http://www.wowinterface.com/downloads/info18447-CancelMyBuffs.html
	http://wow.curse.com/downloads/wow-addons/details/cancelmybuffs.aspx
----------------------------------------------------------------------]]

local ADDON_NAME, ns = ...

local class, race, faction, _

if not ns.L then ns.L = {} end
local L = setmetatable( ns.L, { __index = function( t, k )
	if k == nil then return "" end
	local v = tostring( k )
	t[ k ] = k
	return k
end } )

L["Divine Plea"] = GetSpellInfo(54428)
L["Divine Shield"] = GetSpellInfo(642)
L["Hellfire"] = GetSpellInfo(1949)
L["Slow Fall"] = GetSpellInfo(130)
L["Water Walking"] = GetSpellInfo(546)

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
				["Invulnerability"] = true,
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
		["Water Walking"] = {
			[8827]  = true, -- Elixir of Water Walking
			[1706]  = true, -- Levitate
			[546]   = true, -- Water Walking
		},
		["Divine Plea"] = {
			[54428] = "PALADIN", -- Divine Plea
		},
		["Divine Shield"] = {
			[642]   = "PALADIN", -- Divine Shield
		},
		["Hellfire"] = {
			[1949]  = "WARLOCK", -- Hellfire
			[85403] = "WARLOCK", -- Hellfire (Demonology spec version)
		},
		["Flask of Enhancement"] = {
			[79639] = true, -- Enhanced Agility
			[79640] = true, -- Enhanced Intellect
			[79638] = true, -- Enhanced Strength
		},
	}
}

------------------------------------------------------------------------

local buffList = { }
local buttons = { }
local bindings = { }

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

function CancelMyBuffs:OnInitialize() -- self:Debug( "OnInitialize" )
	self.db = LibStub( "AceDB-3.0" ):New( "CancelMyBuffsDB", defaults, true )

	self.buttons = buttons
	self.bindings = bindings
end

function CancelMyBuffs:OnEnable() -- self:Debug( "OnEnable" )
	_, class = UnitClass( "player" )
	_, race =UnitRace( "player" )
	faction = UnitFactionGroup( "player" )

	hooksecurefunc( TemporaryEnchantFrame, "Hide", function()
		TempEnchant1:SetID( 16 )
		TempEnchant2:SetID( 17 )
		TempEnchant3:SetID( 18 )
	end )

	local warned
	for i = 1, #self.db.profile do
		self:SetupButton( i )

		local binding = self.db.profile[ i ].binding
		if not binding then
			binding = GetBindingKey( bindings[ i ] )
			self.db.profile[ i ].binding = binding
		end
		if not binding and not warned then
			self:Print( [[No key binding set! Type "/cmb" for options.]] )
			warned = true
		else
			SetBinding( binding, bindings[ i ] )
		end
	end

	self:SetupOptions()
end

------------------------------------------------------------------------

function CancelMyBuffs:SetupButton( i )
	-- self:Debug( "SetupButton", i )

	local bindGroup = self.db.profile[ i ]
	if not bindGroup then return end

	local name, attr_type, attr_macrotext
	if ( i % 2 == 0 ) then
		name, attr_type, attr_macrotext = "CancelMyBuffsButton" .. ( i - 1 ), "type2", "macrotext2"
		bindings[ i ] = "CLICK " .. name .. ":RightButton"
	else
		name, attr_type, attr_macrotext = "CancelMyBuffsButton" .. i, "type1", "macrotext1"
		bindings[ i ] = "CLICK " .. name .. ":LeftButton"
	end

	-- self:Debug( name, attr_type, attr_macrotext )
	-- self:Debug( bindings[ i ] )

	if not _G[ name ] then
		buttons[ i ] = CreateFrame( "Button", name, nil, "SecureActionButtonTemplate" )
		buttons[ i ]:RegisterForClicks( "AnyUp" )
		-- self:Debug( "Created button" )
	end

	local macrotext = "" .. "\n/run print(\"click\")"
	if bindGroup.forms and ( class == "DRUID" or class == "PRIEST" or class == "SHAMAN" ) then
		macrotext = macrotext .. "\n/cancelform"
	end
	
	if bindGroup.mounts then
		macrotext = macrotext .. "\n/dismount"
	end
	
	if bindGroup.vehicles then
		macrotext = macrotext .. "\n/leavevehicle [@vehicle,exists]"
	end
	
	if bindGroup.weaponBuffs and ( class == "ROGUE" or class == "SHAMAN" ) then
		if not TemporaryEnchantFrame:IsShown() then
			TempEnchant1:SetID( 16 )
			TempEnchant2:SetID( 17 )
			TempEnchant3:SetID( 18 )
		end
		macrotext = macrotext .. "\n/click TempEnchant1 RightButton\n/click TempEnchant2 RightButton\n/click TempEnchant3 RightButton"
	end

	if not buffList[ i ] then
		buffList[ i ] = {}
	else
		wipe( buffList[ i ] )
	end

	for group, groupEnabled in pairs( bindGroup.buffGroups ) do
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
	macrotext = macrotext:sub( 2 )

	if macrotext:len() > 1000 then
		self:Print( "Too many buffs selected!" )
		macrotext = macrotext:sub( 1, 1024 ):match( "( .+ )\n/[^\/]+$" )
	end

	buttons[ i ]:SetAttribute( attr_type, "macro" )
	buttons[ i ]:SetAttribute( attr_macrotext, macrotext )
end