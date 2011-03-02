--[[--------------------------------------------------------------------
	CancelMyBuffs
	Cancel unwanted buffs quickly and easily.
	Written by Phanx <addons@phanx.net>
	Maintained by Akkorian <akkorian@hotmail.com>
	Copyright © 2010–2011 Phanx. Some rights reserved. See LICENSE.txt for details.
	http://www.wowinterface.com/downloads/info18447-CancelMyBuffs.html
	http://wow.curse.com/downloads/wow-addons/details/cancelmybuffs.aspx
------------------------------------------------------------------------
	Localization: Español (AL & EU) | Spanish (Latin America y Europa)
	Last Updated: 2011-01-25 by Akkorian
----------------------------------------------------------------------]]

if not string.match( GetLocale(), "^es" ) then return end
local _, ns = ...
ns.L = {

	["Cancel buffs"] = "Cancelar beneficios",
	["Group %d"] = "Grupo %d",

	["Invulnerability"] = "Invulnerabilidad",
	["Stealth"] = "Sigilo",
	["Controllers"] = "Controladores",
	["Shapeshifts"] = "Cambios de forma",
	["Quest Effects"] = "Efectos de misión",
	["Cosmetic Effects"] = "Efectos cosméticos",

	["No key binding set! Type \"/cmb\" for options."] = "Ningún tecla asignada! Tipo \"/cmb\" para las opciones.",
	["Too many buffs selected!"] = "Demasiado muchos beneficios seleccionados!",

	["CancelMyBuffs lets you quickly cancel unwanted buffs."] = "CancelMyBuffs te permite rápidamente cancelar los beneficios no deseados.",

	["Group Name"] = "Nombre de grupo",
	["Key Binding"] = "Teclado",
	["Dismount"] = "Desmontar",
	["Also dismount when cancelling buffs."] = "Desmontar también al cancelar los beneficios.",
	["Leave vehicle"] = "Dejar vehículo",
	["Also leave vehicles when cancelling buffs."] = "Dejar el vehículo también al cancelar los beneficios.",
	["Leave form"] = "Deja forma",
	["Also cancel forms when cancelling buffs."] = "Dejar la forma también al cancelar los beneficios.",
	["Remove weapon buffs"] = "Cancelar beneficios de armas",
	["Also remove weapon buffs when cancelling buffs."] = "Cancelar los beneficios de armas también al cancelar los beneficios.",

	["Buff Groups"] = "Grupos de beneficios",
	["Configure buff groups."] = "",
	["New buff group"] = "Nuevo grupo",
	["Add a buff"] = "Añadir un beneficio",
	["Remove buffs"] = "Eliminar beneficios",
	["Select which buffs to remove."] = "Seleccione los beneficios para eliminar.",
	["Uncheck a buff to delete it from this group."] = "Desmarque un beneficio para eliminar por este grupo.",

}