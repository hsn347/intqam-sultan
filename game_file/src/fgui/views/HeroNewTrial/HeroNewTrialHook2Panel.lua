local heroNewTrialRead = include("heroNewTrialRead")
local heroNewTrialCtrl = SoraDGetCtrl("heroNewTrialCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroNewTrialHook2Panel = class("HeroNewTrialHook2Panel", baseFguiPanel)
function HeroNewTrialHook2Panel:ctor(...)
	HeroNewTrialHook2Panel.super.ctor(self, ...)
	print("HeroNewTrialHook2Panel:ctor", self.viewName)
	self.afkTimeMax = heroNewTrialCtrl:getAfkTimeMax()
end
function HeroNewTrialHook2Panel:onInit()
	print("=======HeroNewTrialHook2Panel:onInit")
	self.fields.Panel_bg:setString(i18n("hero_experience_04"))
	self.fields.Text_reward:setString(i18n("hero_experience_08"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_noReward:setString(i18n("hero_experience_10"))
	self.fields.Text_des:setString(i18n("hero_experience_09"))
	self.fields.Button_get:setString(i18n("common_text_1146"))
	self.fields.Button_get:addClickListener(handler(self, self.onClickBtnGet))
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Text_time:setTimeLast(function(timeStr)
		_ENV = nil
		;(nil).color = "#FFD43E"
		return i18n("hero_experience_07") .. "\n" .. SoraDWrapHtmlTagByStyle(timeStr, nil)
	end)
	self.fields.Text_time:setTimeUpdateListener(function(timeNumber)
		if timeNumber >= self.afkTimeMax then
			self.fields.Text_time:endTime()
			self.fields.Text_time:updateLabel(self.afkTimeMax)
		end
	end)
end
function HeroNewTrialHook2Panel:onShow()
	print("=======HeroNewTrialHook2Panel:onShow")
	self.heroID = self.param and self.param.heroID
	heroNewTrialCtrl:reqAfkInit(self.heroID)
	SoraDShowLoading(self)
end
function HeroNewTrialHook2Panel:onItemRenderer(index, obj)
	local item = self.rewardList[index + 1]
	obj:initData(item.id, item.count)
end
function HeroNewTrialHook2Panel:onClickBtnGet(...)
	SoraDPlaySound()
	if #self.rewardList <= 0 then
		SoraDShowMsgTip(i18n("hero_experience_11"))
		return
	end
	heroNewTrialCtrl:reqAfkCliam(self.heroID)
	SoraDShowLoading(self)
end
function HeroNewTrialHook2Panel:onMsgUpdateView(target, event)
	local subMsg = event.subMsg
	if subMsg == "afkInit" then
		SoraDCloseLoading(self)
		local afkTime = heroNewTrialCtrl:getAfkTime(self.heroID)
		self.fields.Text_time:beginTime(afkTime - 1, true)
		if not event.rewardMap then
			local _ENV, rewardMap = event.rewardMap, event.rewardMap
		end
		local _ENV, ret = self.fields.Text_time, self.fields.Text_time
		for k, v in pairs(rewardMap) do
			_ENV = nil
			;(nil).id = tonumber(k)
			;(nil).count = v
			table.insert(ret, nil)
		end
		self.rewardList = ret
		self.fields.List:setNumItems(#self.rewardList)
		self.fields.Text_noReward:setVisible(#self.rewardList == 0)
	elseif subMsg == "afkCliam" then
		SoraDCloseLoading(self)
		self.fields.Text_time:beginTime(-1, true)
		self.rewardList, _ENV = self.fields.Text_time.beginTime, self.fields.Text_time.beginTime
		self.fields.List:setNumItems(0)
		self.fields.Text_noReward:setVisible(true)
	end
end
return HeroNewTrialHook2Panel
