local allianceScience = SoraDGetCtrl("allianceScience")
local memberMgr = SoraDGetCtrl("memberMgr")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local constantRead = include("constantRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_Prosperity = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceScienceView/Com_Prosperity", Com_Prosperity)
function Com_Prosperity:onInit()
	self.fields.Button_reward:setString(i18n("common_text_2078"))
	self.fields.Button_bonus:setString(i18n("common_text_473"))
	self.fields.Com_Box:getChild("Text_prosperity"):setString(i18n("alliance_prosperity_text_12"))
	local addValue = constantRead.getConstValue("ADD_PROSPERITY_EVERY_TIME", 10)
	_ENV = i18n("alliance_prosperity_text_12")
	i18n("alliance_prosperity_text_12").num = addValue
	self.fields.Text_tips:setString(i18n("alliance_prosperity_text_18", i18n("alliance_prosperity_text_12")))
	self.fields.Button_question:addClickListener(handler(self, self.btnHelpCallback))
	self.fields.Button_reward:addClickListener(handler(self, self.btnRewardCallback))
	self.fields.Button_bonus:addClickListener(handler(self, self.btnBonusCallback))
	self.fields.Button_donate:setString(i18n("common_text_284"))
	self.fields.Button_donate:addClickListener(handler(self, self.btnDonateCallback))
	self.fields.LoadingBar_1:setMax(100)
	self.fields.LoadingBar_2:setMax(100)
	self.fields.LoadingBar_2:fixChildrenPos()
	self.fields.LoadingBar_2:getChild("bar"):fixChildrenPos()
	self.fields.LoadingBar_1:fixChildrenPos()
	self.fields.LoadingBar_1:getChild("bar"):fixChildrenPos()
	self.fields.Com_Box:getChild("Movie"):setAllFrameName("dh_Tex_XL_lmfrd03_%03d.png", 0)
	self.fields.Com_Box:getChild("Movie2"):setAllFrameName("dh_Tex_XL_lmfrd_%03d.png", 0)
end
function Com_Prosperity:onShow()
	self:initData()
end
function Com_Prosperity:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_PROSPERITY_REFRESH", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_PROSPERITY_CHANGE", handler(self, self.refreshProsperity))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_POPULARITY_CHANGE", handler(self, self.refreshPopularity))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_POPULARITY_FULL", handler(self, self.showFullEffect))
end
function Com_Prosperity:initData(...)
	local curPoint = memberMgr:getOwnMember():getProperty("playerHonor")
	self.fields.Text_honor:setString(string.formatnumberthousands(curPoint))
	self:refreshProsperity()
	self:refreshPopularity()
	if allianceScience:getProsperityRemainCount() > 0 then
		self.fields.Button_donate:setTitleColor(display.COLOR_WHITE)
	else
		self.fields.Button_donate:setTitleColor(display.COLOR_RED)
	end
end
function Com_Prosperity:refreshProsperity(target, data)
	local prosperity = allianceScience:getProsperity()
	self.fields.Com_Box:setString(string.formatnumberthousands(prosperity))
	local rewardsCount = allianceScience:getProsperityRewardsCount()
	self.fields.Button_reward:setReddot(0 < rewardsCount, rewardsCount)
end
function Com_Prosperity:refreshPopularity(target, data)
	local percent = allianceScience:getPopularity() / 100
	print("percent", percent)
	self.fields.LoadingBar_1:setValue(percent)
	self.fields.LoadingBar_2:setValue(percent)
	allianceScience = nil
	;(nil).value = percent
	self.fields.Text_popularity:setString(i18n("alliance_prosperity_text_15", nil))
end
function Com_Prosperity:btnHelpCallback()
	SoraDPlaySound()
	_ENV = "alliance_prosperity_text_13"
	;("alliance_prosperity_text_13").align = SoraDFLabelR()
	SoraDShowHelpMsgTip(i18n("alliance_prosperity_text_13"), "alliance_prosperity_text_13")
end
function Com_Prosperity:btnRewardCallback()
	SoraDPlaySound()
	uiManager:show("AllianceProsperityRewardPop")
end
function Com_Prosperity:btnBonusCallback()
	SoraDPlaySound()
	uiManager:show("AllianceProsperityBonusPop")
end
function Com_Prosperity:btnDonateCallback()
	SoraDPlaySound()
	uiManager:show("AllianceProsperityDonate")
end
function Com_Prosperity:refreshView(target, data)
	self:initData()
end
function Com_Prosperity:showFullEffect(target, data)
	self.fields.Com_Box:getTransition("t1"):play()
end
return Com_Prosperity
