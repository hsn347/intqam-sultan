function display.getNodePixel(node, x, y, worldPos)
	if type(worldPos) ~= "boolean" then
		worldPos = true
	end
	return ExtraUtils:getNodePixel(node, x, y, worldPos)
end
