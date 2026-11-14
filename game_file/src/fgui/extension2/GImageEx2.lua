local m = fgui.GImage
function m:setFillType(value)
	if value == 1 then
		self:setTile(true)
	else
		error("setFillType must be 1 (tile)")
	end
end
