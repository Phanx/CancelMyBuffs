--[[--------------------------------------------------------------------
	CancelMyBuffs
	Quickly and easily remove unwanted buffs using keybindings.
	Copyright (c) 2010-2012 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info18447-CancelMyBuffs.html
	http://www.curse.com/addons/wow/cancelmybuffs
------------------------------------------------------------------------
	Localization for zhCN / Simplified Chinese / 简体中文
	Last updated 2012-08-01 by okaydud @ CurseForge
----------------------------------------------------------------------]]

if GetLocale() ~= "zhCN" then return end

local _, addon = ...
addon.L = {
	["Add a buff to this buff group.\nEnter the numeric ID of any spell, or the exact name of a spell in your spellbook."] = "增加一个buff到buff分组。\n输入任何法术的数字ID，或者法术书里的正确法术名称。",
	["Add buff"] = "增加buff",
	["Add, remove, and configure bindings for removing buffs. These settings are stored on a per-profile basis."] = "添加、移除和配置绑定取消的buff，这些配置基于每个角色保存。",
	["Add, remove, and configure buffs and buff groups. These settings are stored on a global basis."] = "添加、移除和配置buff和buff分组，这些配置基于全局保存。",
	["Always"] = "总是",
	["Are you sure you want to delete %s from the the %s buff group?"] = "你确定想要从%s 分组删除%s ？",
	["Are you sure you want to delete the %s binding?"] = "你确定想要删除 %s 绑定？",
	["Are you sure you want to delete the %s buff group?"] = "你确定想要删除%s buff分组？",
	["Binding names cannot be blank. You must enter at least one non-whitespace character to create a new binding."] = "绑定名称不能为空。必须输入至少一个非空格字符以创建一个新的绑定。",
	["Bindings"] = "绑定",
	["Bindings cannot be changed in combat."] = "战斗中不能改变绑定。",
	["Buff Groups"] = "Buff分组",
	-- Buffs = "",
	["Cancel shapeshift forms"] = "取消变形形态",
	["Cancel shapeshift forms when activating this binding."] = "当激活这个绑定时取消变形形态",
	["Choose when this buff should be included in the group."] = "当这个buff在分组时会被选择取消",
	["Classes"] = "职业",
	["Create a new binding with the specified name."] = "以特定名称创建新的绑定",
	["Create a new buff group with the specified name."] = "以特定名称创建一个新的buff分组",
	["Default configuration loaded. Type \"/cmb\" to bind a key or change settings."] = "默认配置已加载。输入\"/cmb\"以绑定热键或者改变设置。",
	["Delete buff"] = "删除buff",
	["Delete group"] = "删除分组",
	["Delete this buff group."] = "删除这个buff分组",
	["Dismount"] = "解散坐骑",
	["Dismount when activating this binding."] = "激活此绑定时解散坐骑。",
	["Enable buff"] = "启用buff",
	["Enable reporting"] = "启用报告",
	["Exit the vehicle you are controlling when activating this binding."] = "当激活这个绑定时离开你控制的载具。",
	["Leave vehicle"] = "离开载具",
	["Name"] = "名称",
	["Never"] = "从不",
	["New binding"] = "新的绑定",
	["New buff group"] = "新的buff分组",
	["Only for some classes"] = "仅某些职业",
	["Only when the spell is known"] = "仅已知的法术",
	["Press a key to assign it to this binding."] = "按下热键以确认这个绑定",
	["Quickly remove unwanted buffs using key bindings."] = "使用绑定的快捷键快速移除不想要的buff。",
	["Remove Binding"] = "移除绑定",
	["Remove Buffs"] = "移除buff",
	["Remove this binding. This action cannot be undone."] = "移除这个绑定，这个动作不能被撤销。",
	["Remove this buff from the group."] = "从这个分组移除这个buff。",
	["Remove weapon buffs"] = "移除武器buff",
	["Remove weapon buffs, such as rogue poisons or shaman enchants, when activating this binding."] = "当激活这个绑定时移除武器buff，例如盗贼的毒药或者萨满的增强法术。",
	["%s does not appear to be a valid spell ID or spell name."] = "%s 看来似乎不是一个有效的法术ID或者法术名字。",
	["Select the classes for which to enable this buff."] = "选择职业以启用这个buff",
	["Select which buffs to cancel with this binding."] = "为这个绑定选择取消的buff。",
	["Show a message in the chat frame when buffs are cancelled with this binding."] = "当这个绑定把buff取消时，聊天栏显示信息提示。",
	["That name is already used by another binding."] = "已有其他绑定使用此名称。",
	["The name to use for this binding."] = "这个名称用于此绑定。",
	["The %s binding includes too many buffs! Some buffs may not be removed. Try selecting fewer buff groups, removing some unused buffs from your buff groups, or creating a second binding."] = "%s 绑定包含太多buff！某些buff不能被移除。尝试选择较少buff分组，从你的buff分组移除某些没用的buff，或者创建第二个绑定。",
}