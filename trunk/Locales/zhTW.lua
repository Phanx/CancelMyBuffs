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
	["Add a buff to this buff group.\nEnter the numeric ID of any spell, or the exact name of a spell in your spellbook."] = "增加一個buff到buff分組。\n輸入任何法術的數字ID，或者法術書里的正確法術名稱。",
	["Add buff"] = "增加buff",
	["Add, remove, and configure bindings for removing buffs. These settings are stored on a per-profile basis."] = "添加、移除和設定綁定取消的buff，這些設定檔基於每個角色保存。",
	["Add, remove, and configure buffs and buff groups. These settings are stored on a global basis."] = "添加、移除和設定buff和buff分組，這些設定檔基於全局保存。",
	["Always"] = "總是",
	["Are you sure you want to delete %s from the the %s buff group?"] = "你確定想要從 %s 分組刪除 %s ？",
	["Are you sure you want to delete the %s binding?"] = "你確定想要刪除%s 綁定？",
	["Are you sure you want to delete the %s buff group?"] = "你確定想要刪除%s buff分組？",
	["Binding names cannot be blank. You must enter at least one non-whitespace character to create a new binding."] = "綁定名稱不能為空。必須輸入至少一個非空格字符以創建一個新的綁定。",
	["Bindings"] = "綁定",
	["Bindings cannot be changed in combat."] = "戰鬥中不能改變綁定。",
	["Buff Groups"] = "Buff分組",
	-- Buffs = "",
	["Cancel shapeshift forms"] = "取消變形形態",
	["Cancel shapeshift forms when activating this binding."] = "當激活這個綁定時取消變形形態",
	["Choose when this buff should be included in the group."] = "當這個buff在分組時會被選擇取消",
	["Classes"] = "職業",
	["Create a new binding with the specified name."] = "以特定名稱創建新的綁定",
	["Create a new buff group with the specified name."] = "以特定名稱創建一個新的buff分組",
	["Default configuration loaded. Type \"/cmb\" to bind a key or change settings."] = "默認配置已加載。輸入\"/cmb\"以綁定快捷鍵或者改變設定。",
	["Delete buff"] = "刪除buff",
	["Delete group"] = "刪除分組",
	["Delete this buff group."] = "刪除這個分組",
	["Dismount"] = "解散坐騎",
	["Dismount when activating this binding."] = "激活此綁定時解散坐騎。",
	["Enable buff"] = "啟用buff",
	["Enable reporting"] = "啟用報告",
	["Exit the vehicle you are controlling when activating this binding."] = "當激活這個綁定時離開你控制的載具。",
	["Leave vehicle"] = "離開載具",
	["Name"] = "名稱",
	["Never"] = "從不",
	["New binding"] = "新的綁定",
	["New buff group"] = "新的buff分組",
	["Only for some classes"] = "僅某些職業",
	["Only when the spell is known"] = "僅已知的法術",
	["Press a key to assign it to this binding."] = "按下熱鍵以確定這個綁定",
	["Quickly remove unwanted buffs using key bindings."] = "使用綁定的快捷鍵快速移除不想要的buff。",
	["Remove Binding"] = "移除綁定",
	["Remove Buffs"] = "移除buff",
	["Remove this binding. This action cannot be undone."] = "移除這個綁定，這個動作不能被撤銷。",
	["Remove this buff from the group."] = "從這個分組移除這個buff。",
	["Remove weapon buffs"] = "移除武器buff",
	["Remove weapon buffs, such as rogue poisons or shaman enchants, when activating this binding."] = "當激活這個綁定時移除武器buff，例如盜賊的毒藥或者發滿的增強法術。",
	["%s does not appear to be a valid spell ID or spell name."] = "%s 看起來似乎不是一個有效的法術ID或者法術名字。",
	["Select the classes for which to enable this buff."] = "選擇職業以啟用這個buff。",
	["Select which buffs to cancel with this binding."] = "為這個綁定選擇取消的buff。",
	["Show a message in the chat frame when buffs are cancelled with this binding."] = "當這個綁定把buff取消時，聊天欄顯示信息提示。",
	["That name is already used by another binding."] = "已有其他綁定使用此名稱。",
	["The name to use for this binding."] = "這個名稱用於此綁定。",
	["The %s binding includes too many buffs! Some buffs may not be removed. Try selecting fewer buff groups, removing some unused buffs from your buff groups, or creating a second binding."] = "%s 綁定包含太多buff！某些buff不能被移除。嘗試選擇較少的buff分組，從你的buff分組移除某些沒用的buff，或者創建第二個綁定。",
}
