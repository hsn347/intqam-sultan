local baseComponent = require("fgui.base.baseComponent")
local magicLampSkillLotteryCtrl = SoraDGetCtrl("magicLampSkillLotteryCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local Com_MLMP_Lamp = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MagicLampMaigcPower/Com_MLMP_Lamp", Com_MLMP_Lamp)
local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
function Com_MLMP_Lamp:onInit()
	self.orginY = self:getPositionY()
	self:addClickEventListener(handler(self, self.onClicked))
end
function Com_MLMP_Lamp:onShow()
end
function Com_MLMP_Lamp:initData(cfg, index)
	self.cfg = cfg
	if self.cfg == nil then
		self:setVisible(false)
		return
	end
	self.isCurPoolUnlock = true
	local poolLastTime
	local taskBeginTime = 0
	if self.cfg.activeTime >= 1 then
		local duration = serviceFunctions.systemTime() - self.cfg.activeTime
		self.isCurPoolUnlock = magicLampSkillLotteryCtrl:getIsPoolOpen(self.cfg.magicPoolID)
		if self.isCurPoolUnlock then
			poolLastTime = activityShowCtrl:getEndTimeSecond(gActivityTimeActivityID.MAGIC_DRAW_ACTIVITY) - serviceFunctions.systemTime()
		end
	end
	self.controllers.c2:setSelectedIndex(poolLastTime ~= nil and 2 or self.isCurPoolUnlock and 0 or 1)
	self:setVisible(true)
	self.index = index
	self.fields.title:setString(i18n(cfg.magicPoolType))
	self.fields.timelabel:setTimeEndListener(nil)
	self.fields.timelabel:endTime()
	self.fields.icon:setURL(cfg.magicPoolView)
	if poolLastTime then
		self.fields.timelabel:beginTime(poolLastTime)
		self.fields.timelabel:setTimeEndListener(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_MAGICLAMP_SKILL_LOTTERY_POOL_UPDATE"
			SoraDSendMessage(nil)
		end)
	end
	self:setAniShow(true)
end
function Com_MLMP_Lamp:setRatio(ratio)
	self.ratio = ratio
	ratio = ratio < 0.7 and 0.7 or ratio
	self.fields.icon:setScaleX(-ratio)
	self.fields.icon:setScaleY(ratio)
	self.fields.icon:setAlpha((ratio - 0.75) / 0.3 * 0.3 + 0.7)
	self.fields.ani_bg:setScale(ratio * 1.5)
	self.fields.ani_f:setScale(ratio * 1.5)
	self.fields.ani_bg:setAlpha((ratio - 0.75) / 0.3 * 0.5 + 0.5)
	self.fields.ani_f:setAlpha((ratio - 0.75) / 0.25 * 0.7 + 0.3)
	self:setPositionY(-140 + math.sqrt(math.abs(19600 - (1 - ratio) / 0.25 * 140 * (1 - ratio) / 0.25 * 140)))
end
function Com_MLMP_Lamp:getRatio()
	return self.ratio
end
function Com_MLMP_Lamp:setClickHandler(callback)
	self.callback = callback
end
function Com_MLMP_Lamp:onClicked()
	if self.callback and self.cfg ~= nil then
		SoraDPlaySound()
		self.callback(self.index)
	end
end
function Com_MLMP_Lamp:isEmptyCom()
	return self.cfg == nil
end
function Com_MLMP_Lamp:setAniShow(isShow)
	self.fields.ani_bg:setVisible(true)
	self.fields.ani_bg:setAllFrameName("dh_slcq_normal_%02d.png", 1)
	self.fields.ani_bg:setPlaySettings(0, -1, -1)
	self.fields.ani_f:setVisible(true)
	self.fields.ani_f:setAllFrameName("dh_slcq_add_%02d.png", 1)
	self.fields.ani_f:setPlaySettings(0, -1, -1)
end
return Com_MLMP_Lamp
