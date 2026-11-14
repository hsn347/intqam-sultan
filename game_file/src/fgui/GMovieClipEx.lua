local m = fgui.GMovieClip
function m:setHighpSprite()
	SoraDHighpSprite(self:displayObject())
end
function m:setAllFrameNameOnce(strName, startValue, isLoop)
	print("==m:setAllFrameNameOnce==", self._frameName, strName, startValue, isLoop)
	self:setVisible(true)
	if isLoop ~= nil then
		if isLoop == true then
			self:setPlaySettings(0, -1, -1, -1)
		else
			self:setPlaySettings(0, -1, 1, -1, function()
				self:setVisible(false)
				if type(isLoop) == "function" then
					isLoop()
				end
			end)
		end
	end
	if self._frameName == strName then
		return
	end
	self._frameName = strName
	self:setAllFrameName(strName, startValue)
end
function m:setFrames(strName, isLoop, startValue)
	if isLoop == nil then
		isLoop = true
	end
	self:setAllFrameNameOnce(strName, startValue or 1, isLoop)
end
