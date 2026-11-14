local m = fgui.GComboBox
local setValues_old = tolua.getcfunction(m, "setValues")
function m:setValues(values)
	local _ENV, newValues
	for k, v in ipairs(values) do
		table.insert(newValues, tostring(v))
	end
	setValues_old(self, newValues)
end
function m:setTitle(title)
	self:GetTextField():setText(title)
end
