local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local techScrollSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RoaringFlame/techScrollSingle", techScrollSingle)
function techScrollSingle:onInit()
	self.fields.Btn_reward:setVisible(false)
	self.fields.Button_touch:addClickListener(handler(self, self.btnDetailClick))
	self.fields.Btn_reward:addClickListener(handler(self, self.btnRewardBoxClick))
	self.fields.lab_timer:setTimeEndListener(handler(self, self.updateView))
end
function techScrollSingle:onShow()
end
function techScrollSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_TECHNOLOGY", handler(self, self.updateView))
end
function techScrollSingle:updateView()
	self:initData(self.tid)
end
function techScrollSingle:initData(tid)
	self.tid = tid
	local lv = roaringFlameWarCtrl:getTechnologyLv(self.tid)
	local cfg = roaringFlameWarRead.getTechnologyCfg(self.tid, lv)
	self.fields.Com_tech:initData(self.tid)
	self.fields.Text_name:setString(i18n(cfg.name))
	if roaringFlameWarRead.isTechnologyRewardBox(self.tid) then
		self.fields.Btn_reward:setVisible(true)
		local status = 0
		if 1 <= lv then
			status = roaringFlameWarCtrl:isTechnologyBoxClaimed(self.tid, 1) and 2 or 1
		end
		self.fields.Btn_reward:setStatus(status)
		if status == 0 then
			self.fields.Btn_reward:setPosition(cc.p(127, 4))
		else
			self.fields.Btn_reward:setPosition(cc.p(101, -37))
		end
	else
		self.fields.Btn_reward:setVisible(false)
	end
	local isStudying, beginTime = roaringFlameWarCtrl:isTechnologyStudying(self.tid)
	local leftTime = (beginTime or 0) + cfg.technology_time - serviceFunctions.systemTime()
	if isStudying and 0 < leftTime then
		self.controllers.c_time:setSelectedIndex(1)
		self.fields.lab_timer:beginTime(leftTime)
	else
		self.controllers.c_time:setSelectedIndex(0)
	end
	local ret = roaringFlameWarCtrl:checkTechPrefix(self.tid)
	self.controllers.c_lock:setSelectedIndex((ret == 1 or ret == 3) and 0 or 1)
end
function techScrollSingle:btnDetailClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).tid = self.tid
	uiManager:show("RoaringFlame_TechDetail", nil)
end
function techScrollSingle:btnRewardBoxClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).tid = self.tid
	uiManager:show("RoaringFlame_TechReward", nil)
end
return techScrollSingle
