--[[--------------------------------------------------------------------
	CancelMyBuffs
	Cancel unwanted buffs quickly and easily.
	Written by Phanx <addons@phanx.net>
	Maintained by Akkorian <akkorian@hotmail.com>
	Copyright © 2010–2011 Phanx. Some rights reserved. See LICENSE.txt for details.
	http://www.wowinterface.com/downloads/info18447-CancelMyBuffs.html
	http://wow.curse.com/downloads/wow-addons/details/cancelmybuffs.aspx
------------------------------------------------------------------------
	Localization: esMX | Español (AL) | Spanish (Latin America)
				  esES | Español (EU) | Spanish (Europe)
	Last Updated: 2011-01-25 by Akkorian
----------------------------------------------------------------------]]

if not string.match( GetLocale(), "^es" ) then return end
local _, ns = ...
local L = { }
ns.L = L

L["Cancel buffs"] = "Cancelar beneficios"
L["Group %d"] = "Grupo %d"

L["Invulnerability"] = "Invulnerabilidad"
L["Stealth"] = "Sigilo"
L["Controllers"] = "Controladores"
L["Shapeshifts"] = "Cambios de forma"
L["Quest Effects"] = "Efectos de misión"
L["Cosmetic Effects"] = "Efectos cosméticos"

L["No key binding set! Type \"/cmb\" for options."] = "Ningún tecla asignada! Tipo \"/cmb\" para las opciones."
L["Too many buffs selected!"] = "Demasiado muchos beneficios seleccionados!"

L["CancelMyBuffs lets you quickly cancel unwanted buffs."] = "CancelMyBuffs te permite rápidamente cancelar los beneficios no deseados."

L["Group Name"] = "Nombre de grupo"
L["Key Binding"] = "Teclado"
L["Dismount"] = "Desmontar"
L["Also dismount when cancelling buffs."] = "Desmontar también al cancelar los beneficios."
L["Leave vehicle"] = "Dejar vehículo"
L["Also leave vehicles when cancelling buffs."] = "Dejar el vehículo también al cancelar los beneficios."
L["Leave form"] = "Deja forma"
L["Also cancel forms when cancelling buffs."] = "Dejar la forma también al cancelar los beneficios."
L["Remove weapon buffs"] = "Cancelar beneficios de armas"
L["Also remove weapon buffs when cancelling buffs."] = "Cancelar los beneficios de armas también al cancelar los beneficios."

L["Buff Groups"] = "Grupos de beneficios"
L["Configure buff groups."] = ""
L["New buff group"] = "Nuevo grupo"
L["Add a buff"] = "Añadir un beneficio"
L["Remove buffs"] = "Eliminar beneficios"
L["Select which buffs to remove."] = "Seleccione los beneficios para eliminar.
L["Uncheck a buff to delete it from this group."] = "Desmarque un beneficio para eliminar por este grupo."