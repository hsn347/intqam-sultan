local annivCountdown2022Read = include("annivCountdown2022Read")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local annivCountdown2022Ctrl = SoraDGetCtrl("annivCountdown2022Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_countdown = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AnniversaryCountdown2022/Com_countdown", Com_countdown)
_ENV = fgui.register_extension
fgui.register_extension.COUNTDOWN = 1
fgui.register_extension.WELFARE = 2
local fgui.register_extension.BAG, viewType = 3, fgui.register_extension
function Com_countdown:ctor(...)
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_2022_ACTIVITY
	self.super.ctor(self, ...)
	print("Com_countdown:ctor", self.viewName)
end
function Com_countdown:onInit()
	self.fields.Usm_in:setMaxChunkSize(80288)
	self.fields.Usm_reward:setMaxChunkSize(84736)
	self.fields.Text_tip:setString(i18n("countdown_text_01"))
	self.Load_countdown = self.fields.Com_num:getChild("Load_countdown")
	self.Load_countdown2 = self.fields.Com_num:getChild("Load_countdown2")
	self.fields.Com_box:addClickListener(handler(self, self.onClickCountdown))
	self.reward = annivCountdown2022Read.getCountDownConfig().reward
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward:setNumItems(table.nums(self.reward) / 2)
	self.fields.Text_des2:setString(i18n("goldenyears_text_06"))
end
function Com_countdown:initData()
	self.state = annivCountdown2022Ctrl:getCountDownRewardState()
	self.controllers.c1:setSelectedIndex(self.state - 1)
	self.fields.Usm_in:setVisible(self.state == 1)
	if self.state == 1 then
		self.fields.Com_num:getTransition("t1"):play()
		self.fields.Usm_in:updateEffect()
		self.fields.Usm_in:play(true)
	end
	self.fields.Usm_reward:setVisible(self.state == 2)
	self.fields.Usm_rewardOpen:setVisible(self.state == 3)
	self:refreshLeftDay()
end
function Com_countdown:onItemRenderer(index, obj)
	obj:initData(self.reward[index * 2 + 1], self.reward[index * 2 + 2])
end
local oneDay = 86400
function Com_countdown:refreshLeftDay()
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		local time = timer.timerNode.timer:getRemainTime()
		local day = SoraDConverSecondToDayAndHours(time) + 1
		local leftDay = self.leftDay
		self.leftDay = math.clamp(day, 1, 7)
		if leftDay ~= self.leftDay then
			self:initData()
		else
			self.Load_countdown:setURL(string.format("%dnDay.png", self.leftDay))
		end
	end
end
function Com_countdown:onClickCountdown(...)
	self:initData()
	if self.state == 2 then
		SoraDPlaySound()
		_ENV = nil
		;(nil).title = i18n("anniversary_2022_text_04")
		;(nil).reward = self.reward
		;(nil).state = self.state
		;(nil).callFunc = function(index)
			annivCountdown2022Ctrl:reqAnnivCountdownReward()
		end
		uiManager:show("AnnivCountdownReward2022", nil)
	end
end
function Com_countdown:initEffect()
end
function Com_countdown:onShow()
	self.soundId = SoraDPlaySound("sixYear", "sfx_countdown")
	self:initData()
end
function Com_countdown:onHide()
	if self.soundId then
		AudioEngine.stopEffect(self.soundId)
	end
	self.fields.Usm_in:setVisible(false)
	self.fields.Usm_on:setVisible(false)
	self.fields.Usm_reward:setVisible(false)
	self.fields.Usm_rewardOpen:setVisible(false)
end
function Com_countdown:onDispose(...)
end
return Com_countdown
