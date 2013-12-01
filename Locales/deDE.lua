--[[--------------------------------------------------------------------
	CancelMyBuffs
	Quickly and easily remove unwanted buffs using keybindings.
	Copyright (c) 2010-2013 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info18447-CancelMyBuffs.html
	http://www.curse.com/addons/wow/cancelmybuffs
------------------------------------------------------------------------
	German localization
	Last updated 2013-11-30 by Phanx
----------------------------------------------------------------------]]

if GetLocale() ~= "deDE" then return end

local _, addon = ...
addon.L = {
	["Add a buff to this buff group.\nEnter the numeric ID of any spell, or the exact name of a spell in your spellbook."] = "Einen Stärkungszauber zu dieser Gruppe hinzufügen.\nDie numerische ID irgendeines Zaubers oder den genauen Namen eines Zaubers in dem Zauberbuch eingeben.",
	["Add buff"] = "Stärkungszauber hinzufügen",
	["Add, remove, and configure bindings for removing buffs. These settings are stored on a per-profile basis."] = "Tastenbelegungen hinzüfugen, entfernen und konfigurieren, um Stärkungszauber zu abbrechen. Diese Einstellungen werden für jedes Profil gespeichert.",
	["Add, remove, and configure buffs and buff groups. These settings are stored on a global basis."] = "Stärkungszaubergruppe hinzüfugen, entfernen und konfigurieren. Diese Einstellungen werden global gespeichert.",
	["Always"] = "Immer",
	["Are you sure you want to delete %s from the %s buff group?"] = "Sind Sie sich sicher, dass Sie %q aus der Gruppe %q entfernen möchten?",
	["Are you sure you want to delete the %s binding?"] = "Sind Sie sich sicher, dass Sie die Tastenbelegung %q entfernen möchten?",
	["Are you sure you want to delete the %s buff group?"] = "Sind Sie sich sicher, dass Sie die Stärkungszaubergruppe %q entfernen möchten?",
	["Binding names cannot be blank. You must enter at least one non-whitespace character to create a new binding."] = "Tastenbelegungsnamen können nicht leer sein. Man muss mindestens einen Buchstaben oder Zahl eingeben.",
	["Bindings"] = "Tastenbelegungen",
	["Bindings cannot be changed in combat."] = "Tastenbelegungen können in Kampf nicht geändert werden.",
	["Buff Groups"] = "Zaubergruppen",
	["Buffs"] = "Stärkungszauber",
	["Cancel shapeshift forms"] = "Gestalten abbrechen",
	["Cancel shapeshift forms when activating this binding."] = "Gestalten abbrechen, die Taste gedrückt wird, die ist zu dieser Gruppe zugewiesen.",
	["Choose when this buff should be included in the group."] = "Wählen Sie aus, wenn dieser Stärkungszauber werden in die Gruppe einschließen.",
	["Classes"] = "Klassen",
	["Create a new binding with the specified name."] = "Eine neue Tastenbelegung mit dem angegebenen Namen erstellen.",
	["Create a new buff group with the specified name."] = "Eine neue Stärkungszaubergruppe mit dem angegebenen Namen erstellen.",
	["Default configuration loaded. Type \"/cmb\" to bind a key or change settings."] = "Die Standardeinstellungen wurden geladen. \"/cmb\" eingeben, um eine Taste zuweisen oder die Einstellungen ändern.",
	["Delete buff"] = "Entfernen",
	["Delete group"] = "Gruppe entfernen",
	["Delete this buff group."] = "Diese Stärkungszaubergruppe entfernen.",
	["Dismount"] = "Absitzen",
	["Dismount when activating this binding."] = "Absitzen, wenn die Taste gedrückt wird, die ist zu dieser Gruppe zugewiesen.",
	["Enable buff"] = "Stärkungszauber aktivieren",
	["Enable reporting"] = "Benachrichtigungen aktivieren",
	["Exit the vehicle you are controlling when activating this binding."] = "Das Fahrzeug verlassen, wenn die Taste gedrückt wird, die ist zu dieser Gruppe zugewiesen.",
	["Leave vehicle"] = "Fahrzeug verlassen",
	["Name"] = "Name",
	["Never"] = "Nie",
	["New binding"] = "Neue Tastenbelegung",
	["New buff group"] = "Neue Zaubergruppe",
	["Only for some classes"] = "Nur für einige Klassen",
	["Only when the spell is known"] = "Nur wenn man den Spruch kennt",
	["Press a key to assign it to this binding."] = "Taste drücken, um mit dieser Tastenbelegung zu belegen.",
	["Quickly remove unwanted buffs using key bindings."] = "Unerwünschte Stärkungszauber mit Tastenbelegungen abbrechen.",
	["Remove Binding"] = "Entfernen",
	["Remove Buffs"] = "Standard",
	["Remove this binding. This action cannot be undone."] = "Diese Tastenbelegung entfernen. Diese Aktion kann nicht rückgängig gemacht werden.",
	["Remove this buff from the group."] = "Diesen Stärkungszauber entfernen",
	["Remove weapon buffs"] = "Waffenverzauberungen abbrechen",
	["Remove weapon buffs, such as rogue poisons or shaman enchants, when activating this binding."] = "Waffenverzauberungen abbrechen, wenn die Taste gedrückt wird, die ist zu dieser Gruppe zugewiesen.",
	["%s does not appear to be a valid spell ID or spell name."] = "%q scheint keine gültiger Zauber-ID oder Zaubername zu sein.",
	["Select the classes for which to enable this buff."] = "Die Klassen auswählen, für die diese Stärkungszauber zu aktivieren.",
	["Select which buffs to cancel with this binding."] = "Die Stärkungszauber auswählen, um mit diese Tastenbelegung abbrechen.",
	["Show a message in the chat frame when buffs are cancelled with this binding."] = "Eine Meldung in dem Chatfenster anzeigen, wenn Stärkungszauber mit dieser Tastenbelegung abgebrochen werden.",
	["That name is already used by another binding."] = "Eine andere Gruppe nutzt bereits diesen Namen.",
	["The name to use for this binding."] = "Der Name für diese Tastenbelegung zu verwenden.",
	["The %s binding includes too many buffs! Some buffs may not be removed. Try selecting fewer buff groups, removing some unused buffs from your buff groups, or creating a second binding."] = "Die Tastenbelegung %q enthält zu viele Zaubersprüche! Einige Stärkungszauber vielleicht nicht abgebrochen werden. Wählen Sie weniger Zauber aus, entfernen Sie einige Stärkungszauber aus Ihrer Stärkungszaubergruppe, oder erstellen Sie eine neue Tastenbelegung.",
}