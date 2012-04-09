local _, addon = ...
local L = addon.L

do
	local name_get = function(info)
		return info.arg
	end

	local name_set = function(info, name)
		self:RenameBuffGroup(info.arg, name)
	end

	local delete_confirm = function(info)
		return string.format(L["Are you sure you want to delete the %s buff group?"], info.arg)
	end

	local delete_func = function(info)
		addon:DeleteBuffGroup(info.arg)
	end

	local new_get = function(info)
		return ""
	end

	local new_validate = function(info, buff)
		local id = tonumber(buff)
		if id then
			return addon:AddBuffToGroup(info.arg, id)
		else
			return addon:AddBuffToGroup(info.arg, buff)
		end
	end

	local new_set = function(info, buff)
		-- Don't need to do anything here, because it's all done in new_validate.
	end

	function addon:GetBuffGroupOptions(group)
		local groupName = group

		local options = {
			name = groupName,
			type = "group",
			args = {
				name = {
					order = 1,
					width = "full",
					name = L["Name"],
					type = "input",
					get = name_get,
					set = name_set,
					arg = groupName,
				},
				new = {
					order = 2,
					width = "double",
					name = L["Add buff"],
					desc = L["Add a buff to this buff group.\nEnter the numeric ID of any spell, or the exact name of a spell in your spellbook."],
					type = "input",
					get = new_get,
					validate = new_validate,
					set = new_set,
					arg = groupName,
				},
				delete = {
					order = 4,
					name = L["Delete group"],
					desc = L["Delete this buff group."],
					type = "execute",
					confirm = delete_confirm,
					func = delete_func,
					arg = groupName,
				},
				buffs = {
					name = L["Buffs"],
					type = "group", dialogInline = true,
					args = {},
				},
			}
		}

		local groupDB = self.db.global.buffGroups[groupName]
		for buffID in pairs(groupDB) do
			options.args.buffs.args[tostring(buffID)] = self:GetBuffOptions(groupName, buffID)
		end

		return options
	end
end

do
	local enable_get = function(info)
		local groupName = info.arg
		local buffID = tonumber(info[#info-1])
		local enabled = addon.db.global.buffGroups[groupName][buffID]

		if type(enabled) == "number" then
			return "SPELL"
		elseif type(enabled) == "string" then
			return "CLASS"
		else
			return enabled and "ALWAYS" or "NEVER"
		end
	end

	local enable_set = function(info, value)
		local groupName = info.arg
		local buffID = tonumber(info[#info-1])
		local enabled = addon.db.global.buffGroups[groupName][buffID]

		if value == "CLASS" then
			value = addon.class
		elseif value == "SPELL" then
			value = buffID
		elseif value == "ALWAYS" then
			value = true
		else
			value = false
		end

		if type(enabled) == type(value) then
			return
		end

		addon.db.global.buffGroups[groupName][buffID] = value
		addon:UpdateAllBindings()
	end

	local classFilter_values = FillLocalizedClassList({}, false)

	local classFilter_hidden = function(info)
		return type(addon.db.global.buffGroups[info.arg][tonumber(info[#info-1])]) ~= "string"
	end

	local classFilter_get = function(info, class)
		local enabled = addon.db.global.buffGroups[info.arg][tonumber(info[#info-1])]
		return type(enabled) == "string" and enabled:match(class)
	end

	local classFilter_set = function(info, class, value)
		local groupName = info.arg
		local buffID = tonumber(info[#info-1])
		local enabled = addon.db.global.buffGroups[groupName][buffID]
		if type(enabled) ~= "string" then return end

		if not value then
			addon.db.global.buffGroups[groupName][buffID] = enabled:gsub(class, ""):trim()
		elseif enabled:find(class) then
			addon.db.global.buffGroups[groupName][buffID] = enabled .. " " .. class
		end
	end

	local delete_confirm = function(info)
		local groupName = info.arg
		local spellID = tonumber(info[#info-1])
		local spellName = addon.spellNames[spellID] or info[#info-1]
		return string.format(L["Are you sure you want to delete %s from the the %s buff group?"], spellName, groupName)
	end

	local delete_func = function(info)
		addon:RemoveBuffFromGroup(info.arg, info[#info-1])
	end

	function addon:GetBuffOptions(group, buff)
		if not buff then
			return
		end

		local groupName, buffID = group, buff

		local options = {
			icon = self.spellIcons[buffID],
			name = self.spellNames[buffID] or tostring(buffID),
			type = "group", dialogInline = true,
			args = {
				enable = {
					order = 1,
					width = "double",
					name = L["Enable buff"],
					desc = L["Choose when this buff should be included in the group."],
					type = "select",
					values = {
						["ALWAYS"]  = L["Always"],
						["NEVER"]   = L["Never"],
						["CLASS"]   = L["Only for some classes"],
						["SPELL"]   = L["Only when the spell is known"],
					},
					get = enable_get,
					set = enable_set,
					arg = groupName,
				},
				delete = {
					order = 3,
					name = L["Delete buff"],
					desc = L["Remove this buff from the group."],
					type = "execute",
					confirm = delete_confirm,
					func = delete_func,
					arg = groupName,
				},
				classFilter = {
					name = L["Classes"],
					desc = L["Select the classes for which to enable this buff."],
					type = "multiselect",
					values = classFilter_values,
					hidden = classFilter_hidden,
					get = classFilter_get,
					set = classFilter_set,
					arg = groupName,
				},
			}
		}

		return options
	end
end

function addon:AddOptionsForBuff(groupName, buffID)
	options.args.buffs.args[tostring(buffID)] = self:GetBuffOptions(groupName, buffID)
	return true
end