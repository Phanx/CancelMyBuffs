--[[--------------------------------------------------------------------
	CancelMyBuffs
	Quickly and easily remove unwanted buffs using keybindings.
	Copyright (c) 2010-2014 Phanx <addons@phanx.net>. All rights reserved.
	http://www.wowinterface.com/downloads/info18447-CancelMyBuffs.html
	http://www.curse.com/addons/wow/cancelmybuffs
	https://github.com/Phanx/CancelMyBuffs
------------------------------------------------------------------------
	Spanish localization
	Last updated 2012-09-07 by Phanx
----------------------------------------------------------------------]]

if not strmatch(GetLocale(), "^es") then return end

local _, addon = ...
addon.L = {
	["Add a buff to this buff group.\nEnter the numeric ID of any spell, or the exact name of a spell in your spellbook."] = "Añadir un beneficio a este grupo.\nEscribe el ID numerico de un hechizo, o el nombre de un hechizo que está en tu libro.",
	["Add buff"] = "Añade beneficio",
	["Add, remove, and configure bindings for removing buffs. These settings are stored on a per-profile basis."] = "Añadir, remover y configurar las asignaciones de teclas para cancelar los beneficios.",
	["Add, remove, and configure buffs and buff groups. These settings are stored on a global basis."] = "Añadir, remover y configurar los beneficios y los grupos de beneficios.",
	["Always"] = "Siempre",
	["Are you sure you want to delete %s from the %s buff group?"] = "¿Seguro que quieres eliminar %s del grupo de beneficios %s?",
	["Are you sure you want to delete the %s binding?"] = "¿Seguro que quieres eliminar la asignación %s?",
	["Are you sure you want to delete the %s buff group?"] = "¿Seguro que quieres eliminar el grupo de beneficios %s?",
	["Binding names cannot be blank. You must enter at least one non-whitespace character to create a new binding."] = "Los nombres de asignaciones no pueden estar vacíos. Debes escribir al menos una letra o un número para crear una nueva asignación.",
	["Bindings"] = "Asignaciones",
	["Bindings cannot be changed in combat."] = "No es posible cambiar las asignaciones de teclas en combate.",
	["Buff Groups"] = "Grupos de beneficios",
	["Buffs"] = "Beneficios",
	["Cancel shapeshift forms"] = "Cancelar formas",
	["Cancel shapeshift forms when activating this binding."] = "Cancelar los cambios de forma cuando se activa este asignación.",
	["Choose when this buff should be included in the group."] = "Cambiar cuando este beneficio se incluye in la asignación.",
	["Classes"] = "Clases",
	["Create a new binding with the specified name."] = "Crear una nueva asignación con el nombre especificado.",
	["Create a new buff group with the specified name."] = "Crear un nuevo grupo de beneficios con el nombre especificado.",
	["Default configuration loaded. Type \"/cmb\" to bind a key or change settings."] = "Configuración predeterminada cargada. Escribe \"/cmb\" para asignar una tecla o cambiar cambiar la configuración.",
	["Delete buff"] = "Elimine beneficio",
	["Delete group"] = "Elimine grupo",
	["Delete this buff group."] = "Eliminar este grupo de beneficios.",
	["Dismount"] = "Desmonta",
	["Dismount when activating this binding."] = "Desmontar cuando se activa este asignación.",
	["Enable buff"] = "Active",
	["Enable reporting"] = "Informe",
	["Exit the vehicle you are controlling when activating this binding."] = "Salir del vehículo cuando se activa esta asignación.",
	["Leave vehicle"] = "Deja vehículo",
	["Name"] = "Nombre",
	["Never"] = "Jamás",
	["New binding"] = "Nueva asignación",
	["New buff group"] = "Nuevo grupo",
	["Only for some classes"] = "Sólo en algunas clases",
	["Only when the spell is known"] = "Sólo cuando se conoce el hechizo",
	["Press a key to assign it to this binding."] = "Presione una tecla para asignarlo.",
	["Quickly remove unwanted buffs using key bindings."] = "Rápidamente cancelar los beneficios no deseados mediante las asignaciones de teclas.",
	["Remove Binding"] = "Elimine asignación",
	["Remove Buffs"] = "Elimine beneficios",
	["Remove this binding. This action cannot be undone."] = "Eliminar esta asignación. Esta acción no se puede deshacer.",
	["Remove this buff from the group."] = "Eliminar este beneficio del grupo.",
	["Remove weapon buffs"] = "Elimine encantamientos",
	["Remove weapon buffs, such as rogue poisons or shaman enchants, when activating this binding."] = "Eliminar los encantamientos temporales de armas, como los venenos de pícaros o los hechizos de imbuir de chamanes, cuando se activa este asignación.",
	["%s does not appear to be a valid spell ID or spell name."] = "%s no es una valida SpellID o nombre de hechizo.",
	["Select the classes for which to enable this buff."] = "Seleccionar los clases para activar este beneficio.",
	["Select which buffs to cancel with this binding."] = "Seleccionar los beneficios para cancelar por este asignación.",
	["Show a message in the chat frame when buffs are cancelled with this binding."] = "Mostrar una mensaje en el macro de chat cuando se cancela algunos beneficios por este asignación.",
	["That name is already used by another binding."] = "Ese nombre ya está en uso por otro asignación.",
	["The name to use for this binding."] = "Escribir un nombre para este asignación.",
	["The %s binding includes too many buffs! Some buffs may not be removed. Try selecting fewer buff groups, removing some unused buffs from your buff groups, or creating a second binding."] = "¡La asignación %s incluye demasiados beneficios! Es posible que no se puede cancelar algunos beneficios. Seleccione menos grupos, elimine algunos beneficios no utilizados de los grupos, o crea otra asignación.",
}
