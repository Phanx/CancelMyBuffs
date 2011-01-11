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

local L = ns.L

local CancelMyBuffs = LibStub( "AceAddon-3.0" ):GetAddon( "CancelMyBuffs" )

------------------------------------------------------------------------

function CancelMyBuffs:GetOptionsForBindingGroup( i )
	local groupID = i
	local opt = {
		name = self.db.profile[ groupID ].name or string.format( L["Group %d"], groupID ),
		type = "group",
		get = function( t )
			return self.db.profile[ groupID ][ t[ #t ] ]
		end,
		set = function( t, v )
			self.db.profile[ groupID ][ t[ #t ] ] = v
			self:SetupButton()
		end,
		args = {
			name = {
				name = L["Group Name"],
				order = 5,
				width = "full",
				type = "input",
				set = function( t, name )
					if name and name:trim():len() > 0 then
						self.db.profile[ groupID ].name = name:trim()
					else
						self.db.profile[ groupID ].name = nil
					end
					self.bindOptions.args[ tostring( groupID ) ].name = self.db.profile[ groupID ].name or string.format( L["Group %d"], groupID )
				end
			},
			keybinding = {
				name = L["Key Binding"],
				order = 10, width = "full",
				type = "keybinding",
				get = function()
					return GetBindingKey( self.bindings[ groupID ] )
				end,
				set = function( _, v )
					-- clear any previous bindings
					local prev1, prev2 = GetBindingKey( self.bindings[ groupID ] )
					if prev1 == v then return end
					if prev1 then SetBinding( prev1 ) end
					if prev2 then SetBinding( prev2 ) end

					if v and v:len() == 0 then
						v = nil
					end

					if v then
						-- warn if overwriting an existing binding
						local curr = GetBindingAction( v )
						if curr and curr:len() > 0 then print( KEY_UNBOUND_ERROR:format( curr ) ) end

						-- set new binding
						SetBinding( v, self.bindings[ groupID ] )

						-- restore second binding if there was one
						if prev2 then SetBinding( prev2, self.bindings[ groupID ] ) end
					end

					-- save
					self.db.profile[ groupID ].binding = v
					SaveBindings( GetCurrentBindingSet() )
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
				get = function( t ) return
					self.db.profile[ groupID ].buffGroups[ t[ #t ] ]
				end,
				set = function( t, v )
					self.db.profile[ groupID ].buffGroups[ t[ #t ] ] = v
					self:SetupButton()
				end,
				args = {
				},
			},
		}
	}

	local t1, t2 = { }, { }
	for groupName, groupBuffs in pairs( self.db.global ) do
		opt.args.buffGroups.args[ groupName ] = {
			name = L[ groupName ],
			desc = function()
				wipe( t1 )
				wipe( t2 )
				for id, enabled in pairs( groupBuffs ) do
					if type( enabled ) == "string" then
						enabled = ( enabled == class ) or ( enabled == race ) or ( enabled == faction )
					end
					if enabled then
						local name, _, icon = GetSpellInfo( id )
						if name and not t1[name] then
							t1[name] = icon
							table.insert( t2, name )
						end
					end
				end
				if #t2 > 0 then
					table.sort( t2 )
					for i, v in ipairs( t2 ) do
						t2[i] = "|T" .. t1[v] .. ":0:0:0:0:32:32:2:30:2:30|t " .. v
					end
					return table.concat( t2, "\n" )
				end
			end,
			width = "double",
			type = "toggle",
			disabled = function()
				wipe( t1 )
				wipe( t2 )
				for id, enabled in pairs( groupBuffs ) do
					local count = 0
					if type( enabled ) == "string" then
						enabled = ( enabled == class ) or ( enabled == race ) or ( enabled == faction )
					end
					if enabled then
						count = count + 1
					end
				end
				return count == 0
			end,
		}
	end

	return opt
end

------------------------------------------------------------------------

function CancelMyBuffs:GetOptionForBuff( id, name, icon, group )
	if not name or not icon then
		local _
		name, _, icon = GetSpellInfo( id )
	end
	local opt = {
		name = string.format( "|T%s:0:0:0:0:32:32:2:30:2:30|t %s", icon, name ),
		width = "double",
		type = "toggle",
		arg = string.format( "%d;%s;%s", id, name, group ),
		get = function() return true end,
		set = function( t )
			local id, name, group = string.split( ";", t.arg )
			self.buffOptions.args[ group ].args[ name ] = nil
			self.db.global[ name ][ id ] = false
			self:SetupButton()
		end,
	}
	return opt
end

------------------------------------------------------------------------

function CancelMyBuffs:GetOptionsForBuffGroup( k, v )
	local groupname, grouptable = k, v
	local opt = {
		name = groupname,
		type = "group",
		args = {
			spacer1 = {
				name = " ",
				type = "description",
				order = 2,
			},
			help = {
				name = L["Uncheck a buff to delete it from this group."],
				type = "description",
				order = 3,
			},
		}
	}

	opt.args.add = {
		name = L["Add a buff"],
		order = 1,
		width = "double",
		type = "input",
		set = function( t, v )
			v = v:trim()
			self:Print( "Attempting to add buff", tostring( v ) )
			local id = tonumber( v )
			local buffname, _, bufficon
			if id then
				buffname, _, bufficon = GetSpellInfo( id )
				self:Print( "Found by id:", tostring( id ), tostring( buffname ) )
			else
				local search = v:lower()
				for i = 1, 100000 do
					buffname, _, bufficon = GetSpellInfo( i )
					if buffname and buffname:lower() == search then
						id = i
						break
					end
				end
				self:Print( "Found by name:", tostring( id ), tostring( buffname ) )
			end
			if buffname then
				self.db.global[ groupname ][ id ] = true
				opt.args[ buffname ] = {
					name = string.format( "|T%s:0|t %s", bufficon, buffname ),
					width = "double",
					type = "toggle",
					arg = string.format( "%d;%s;%s", id, buffname, groupname ),
					get = function() return true end,
					set = function( t )
						local buffid, buffname, groupname = string.split( ";", t.arg )
						self.buffOptions.args[ groupname ].args[ buffname ] = self:GetOptionForBuff( buffid, nil, nil, groupname )
						self.db.global[ groupname ][ buffid ] = true
						self:SetupButton()
					end,
				}
				self:SetupButton()
			end
		end,
	}

	local t1 = {}
	for id, enabled in pairs( grouptable ) do
		if enabled then
			local buffname, _, bufficon = GetSpellInfo( id )
			if buffname then
				t1 [ #t1 + 1 ] = buffname
				opt.args[ buffname ] = self:GetOptionForBuff( id, buffname, bufficon, groupname )
			end
		end
	end
	table.sort( t1 )
	for i = 1, #t1 do
		opt.args[ t1[ i ] ].order = 3 + i
	end

	return opt
end

------------------------------------------------------------------------

function CancelMyBuffs:SetupOptions()
	if self.bindOptions then return end

	self.bindOptions = {
		name = "CancelMyBuffs",
		desc = L["CancelMyBuffs lets you quickly cancel unwanted buffs."],
		type = "group",
		childGroups = "tab",
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
		},
	}

	for i in ipairs( self.db.profile ) do
		self.bindOptions.args[ tostring( i ) ] = self:GetOptionsForBindingGroup( i )
	end

	self.buffOptions = {
		name = L["Buff Groups"],
		desc = L["Configure buff groups."],
		type = "group",
		childGroups = "tree",
		args = {
			new = {
				name = L["New buff group"],
				order = 1,
				width = "double",
				type = "input",
				set = function( k, v )
				end,
			},
		},
	}

	for k, v in pairs( self.db.global ) do
		if type( v ) == "table" then
			self.buffOptions.args[ k ] = self:GetOptionsForBuffGroup( k, v )
		end
	end

	local reg = LibStub( "AceConfigRegistry-3.0" )
	local dlg = LibStub( "AceConfigDialog-3.0" )

	reg:RegisterOptionsTable( "CancelMyBuffs-BindGroups", self.bindOptions )
	self.bindPanel = dlg:AddToBlizOptions( "CancelMyBuffs-BindGroups", "CancelMyBuffs" )
--[[
	reg:RegisterOptionsTable( "CancelMyBuffs-BuffGroups", self.buffOptions )
	self.buffPanel = dlg:AddToBlizOptions( "CancelMyBuffs-BuffGroups", L["Buff Groups"], "CancelMyBuffs" )
--]]
	self.aboutPanel = LibStub( "LibAboutPanel" ).new( "CancelMyBuffs", "CancelMyBuffs" )

	SLASH_CANCELMYBUFFS1 = "/cmb"
	SlashCmdList.CANCELMYBUFFS = function()
		InterfaceOptionsFrame_OpenToCategory( self.aboutPanel )
		InterfaceOptionsFrame_OpenToCategory( self.bindPanel )
	end
end