--[[--------------------------------------------------------------------
	CancelMyBuffs
	Quickly and easily remove unwanted buffs using keybindings.
	Copyright (c) 2010-2014 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info18447-CancelMyBuffs.html
	http://www.curse.com/addons/wow/cancelmybuffs
------------------------------------------------------------------------
	Russian localization
	Last updated 2014-08-19 by Yafis
----------------------------------------------------------------------]]

if GetLocale() ~= "ruRU" then return end

local _, addon = ...
addon.L = {
	-- ["Add a buff to this buff group.\nEnter the numeric ID of any spell, or the exact name of a spell in your spellbook."] = "",
	["Add buff"] = "Добавить бафф",
	["Add, remove, and configure bindings for removing buffs. These settings are stored on a per-profile basis."] = "Добовление, удаление и настройка снятия баффов. Эти настройки хранятся в каждом профиле.",
	["Add, remove, and configure buffs and buff groups. These settings are stored on a global basis."] = "Добовление, удаление и настройка группы бафов. Эти настройки хранятся для глобального профиля",
	["Always"] = "Всегда",
	["Are you sure you want to delete %s from the %s buff group?"] = "Вы уверенны что хотите удалить %s из группы бафов %s",
	["Are you sure you want to delete the %s binding?"] = "Вы уверенны что хотите удалить %s",
	["Are you sure you want to delete the %s buff group?"] = "Вы уверенны что хотите удалить группу бафов %s",
	-- ["Binding names cannot be blank. You must enter at least one non-whitespace character to create a new binding."] = "",
	["Bindings"] = "Привязки",
	["Bindings cannot be changed in combat."] = "Привязка не может быть изменена в бою.",
	["Buff Groups"] = "Группа бафов",
	["Buffs"] = "Бафф",
	["Cancel shapeshift forms"] = "Отменить превращение форм",
	["Cancel shapeshift forms when activating this binding."] = "Отменить превращение форм, при активации привязки.",
	["Choose when this buff should be included in the group."] = "Выберите когда этот бафф должен быть добавлен в группу",
	["Classes"] = "Классы",
	["Create a new binding with the specified name."] = "Создать новую привязку с указанным именем.",
	["Create a new buff group with the specified name."] = "Создать новую группу бафов с указанным именем.",
	["Default configuration loaded. Type \"/cmb\" to bind a key or change settings."] = "Конфигурация по умолчанию загружена. Введите команду \"/cmb\" для изменение настроек.",
	["Delete buff"] = "Удалить бафф.",
	["Delete group"] = "Удалить группу.",
	["Delete this buff group."] = "Удалить эту группу бафов.",
	["Dismount"] = "Слезть",
	["Dismount when activating this binding."] = "Слезть при активации этой привязки",
	["Enable buff"] = "Включить бафф",
	["Enable reporting"] = "Включить отчеты",
	-- ["Exit the vehicle you are controlling when activating this binding."] = "",
	["Leave vehicle"] = "Покинуть транспорт",
	["Name"] = "Имя",
	["Never"] = "Никогда",
	["New binding"] = "Новая привязка",
	["New buff group"] = "Новая группа бафов",
	["Only for some classes"] = "Только для некоторых классов",
	["Only when the spell is known"] = "Только когда заклинание известно",
	["Press a key to assign it to this binding."] = "Выберите клавишу чтоб назначить привязку",
	["Quickly remove unwanted buffs using key bindings."] = "Быстрое удаление ненужных баффов с помощью сочетания клавиш.",
	["Remove Binding"] = "Убрать привязку",
	["Remove Buffs"] = "Убрать бафф",
	["Remove this binding. This action cannot be undone."] = "Удаление этой привязки. Действие нельзя отменить.",
	["Remove this buff from the group."] = "Удалить этот бафф из группы. ",
	["Remove weapon buffs"] = "Убрать бафф на оружие",
	["Remove weapon buffs, such as rogue poisons or shaman enchants, when activating this binding."] = "Убрать бафф на оружие такие как Яды Разбойников и Заклинание Шамана при активации привязки",
	["%s does not appear to be a valid spell ID or spell name."] = "%s не верный ID заклинания или название",
	["Select the classes for which to enable this buff."] = "Выберите класс для которых нужно включить бафф",
	["Select which buffs to cancel with this binding."] = "Выберите какие баффы отменить на эту привязку.",
	-- ["Show a message in the chat frame when buffs are cancelled with this binding."] = "",
	["That name is already used by another binding."] = "Это имя уже используется другой привязкой.",
	["The name to use for this binding."] = "Использовать это имя для этой привязки",
	-- ["The %s binding includes too many buffs! Some buffs may not be removed. Try selecting fewer buff groups, removing some unused buffs from your buff groups, or creating a second binding."] = "",
}
