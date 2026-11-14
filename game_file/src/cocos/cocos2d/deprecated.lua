function schedule(node, callback, delay)
	local delay = cc.DelayTime:create(delay)
	local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
	local action = cc.RepeatForever:create(sequence)
	node:runAction(action)
	return action
end
function performWithDelay(node, callback, delay)
	local delay = cc.DelayTime:create(delay)
	local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
	node:runAction(sequence)
	return sequence
end
if not _G.isNewEngine() then
else
	local Text = ccui.Text
	local _setTextAreaSize = Text._setTextAreaSize or Text.setTextAreaSize
	function Text:setTextAreaSize(size)
		if size.height <= 0 then
			self:setOverflow(ccui.TextOverflowType.RESIZE_HEIGHT)
			_setTextAreaSize(self, size)
		else
			self:setOverflow(ccui.TextOverflowType.SHRINK)
			_setTextAreaSize(self, size)
			self:setContentSize(size.width, size.height)
		end
	end
	local _ignoreContentAdaptWithSize = Text._ignoreContentAdaptWithSize or ccui.Widget.ignoreContentAdaptWithSize
	function Text:ignoreContentAdaptWithSize(ignore)
		_ignoreContentAdaptWithSize(self, ignore)
		if not ignore then
			self:setOverflow(ccui.TextOverflowType.SHRINK)
		end
	end
end
