local gametop = gModuleMgr.getObject("gametop")
local desertTreasureCtrl = gametop.playertop_:getModule("desertTreasureCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_cumuReward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DesertSecretTreasure/Com_cumuReward", Com_cumuReward)
function Com_cumuReward:onInit()
	self.fields.btn_box:addClickListener(handler(self, self.onClickExtraReward))
end
function Com_cumuReward:initData(index, data)
	self.data = data
	self.fields.Text_day:setString(tostring(data.lotteryTime))
	local times = desertTreasureCtrl:curTimesTries()
	local stageReward = desertTreasureCtrl:getExtraReward()
	self:boxEffectInvisible()
	if stageReward[tostring(index)] then
		self.type = 3
		self:setState(3)
	elseif times >= data.lotteryTime then
		self.type = 2
		self:setState(2)
		self:boxShowEffect()
	else
		self.type = 1
		self:setState(1)
	end
end
function Com_cumuReward:setState(index)
	self.controllers.state:setSelectedIndex(index - 1)
end
function Com_cumuReward:boxEffectInvisible()
	self.fields.round:stopAllActions()
end
function Com_cumuReward:boxShowEffect()
	local spXw = self.fields.round
	spXw:stopAllActions()
	spXw:setRotation(0)
	spXw:setVisible(true)
	_ENV = nil
	;(nil)[1] = ffa.rotateBy(2.25, 360)
	;(nil)[2] = ffa.rotateBy(2.25, 360)
	;(nil)[3] = ffa.rotateBy(2.25, 360)
	spXw:runAction(ffa.repeatForever(ffa.seq(nil)))
end
function Com_cumuReward:onClickExtraReward()
	SoraDPlaySound()
	if self.type == 2 then
		desertTreasureCtrl:sendGetStageMsg(self.data.Index)
	else
		local _ENV, btnTitle = "common_text_1892", self.type == 1 and i18n("common_text_204") or i18n("common_text_1892")
		;("common_text_1892").data = self.data.extraReward
		local ("common_text_1892").controller, param = self.type == 3 and 1 or 0, "common_text_1892"
		uiManager:show("CommonPopBox2", param):setOwnerKey(self)
	end
end
function Com_cumuReward:onShow()
end
return Com_cumuReward
