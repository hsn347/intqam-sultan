local activity_9001702_Read = include("activity_9001702_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001702_ResultPanel = class("Activity_9001702_ResultPanel", baseFguiPanel)
function Activity_9001702_ResultPanel:ctor(...)
	self.isLRU = true
	Activity_9001702_ResultPanel.super.ctor(self, ...)
	print("Activity_9001702_ResultPanel:ctor", self.viewName)
end
function Activity_9001702_ResultPanel:getPackageList()
	_UPVALUE1_ = nil
	;(nil)[1] = "CommonBoxSingle"
	return nil
end
function Activity_9001702_ResultPanel:onInit()
	print("=======Activity_9001702_ResultPanel:onInit")
end
function Activity_9001702_ResultPanel:endShow()
	print("=======Activity_9001702_ResultPanel:endShow")
	for i = 1, 5 do
		self:updateComResult(i)
	end
	if not self.param.result then
		local _ENV, resultList = self.param.result, self.param.result
	end
	if #resultList == 1 then
		self:updateComResult(3, resultList[1])
	elseif 0 < #resultList then
		for i = 1, 5 do
			_UPVALUE1_ = nil
			;(nil)[1] = ffa.delay(0.16666666666666666 * (i - 1))
			;(nil)[2] = ffa.callFunc(function()
				self:updateComResult(i, resultList[i])
			end)
			;(nil)[3] = ffa.callFunc(function()
				self:updateComResult(i, resultList[i])
			end)
			self:runAction(ffa.seq(nil))
		end
	end
end
function Activity_9001702_ResultPanel:updateComResult(index, result)
	local Com_result = self.fields["Com_result" .. index]
	if not Com_result then
		return
	end
	if not result then
		Com_result:setVisible(false)
		return
	end
	Com_result:setVisible(true)
	local t0 = Com_result:getTransition("t0")
	t0:play()
	local _fields = fguiHelper.get_fields(Com_result)
	local level = tonumber(result.level) or 3
	local c1 = Com_result:getController("c1")
	c1:setSelectedIndex(level - 1)
	local levelStr = activity_9001702_Read.getLevelStr(level)
	local drawNumber = result.drawNumber
	if drawNumber then
		levelStr = levelStr .. "\n" .. drawNumber
	end
	_fields.title:setString(levelStr)
	if not result.rewards then
		local _ENV, rewards = result.rewards, result.rewards
	end
	_fields.List:setItemRenderer(function(_index, _obj)
		local item = rewards[_index + 1]
		_obj:initData(item.id, item.count)
	end)
	_fields.List:setNumItems(#rewards)
	_fields.ani_baodian:setFrames("G_9001702_baodian_%02d.png", false)
	if level == 1 then
		_fields.ani_glow:setFrames("G_9001702_glow_%02d.png", true)
		_fields.ani_saoguang:setFrames("G_9001702_saoguang_%02d.png", false)
	end
end
return Activity_9001702_ResultPanel
