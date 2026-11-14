local baseComponent = require("fgui.base.baseComponent")
local Com_9001705_mainUI = fgui.extension_class(fgui.GComponent, baseComponent)
local constantRead = include("constantRead")
local activity_9001705_Ctrl = SoraDGetCtrl("activity_9001705_Ctrl")
fgui.register_extension("ui://Activity_9001705/Com_9001705_mainUI", Com_9001705_mainUI)
function Com_9001705_mainUI:onInit()
	self:fixChildrenPos()
	self.fields.Button_satrt:addClickEventListener(handler(self, self.onClickStart))
	self.fields.Button_satrt:setTitle(i18n("common_text_1139"))
	self.fields.Button_rank:setTitle(i18n("pyramid_btn_29"))
	self.fields.Button_rank:addClickEventListener(handler(self, self.onClickRank))
	self.fields.Button_task:setTitle(i18n("common_text_675"))
	self.fields.Button_task:addClickEventListener(handler(self, self.onClickTask))
	self.fields.Button_gift:setTitle(i18n("kindofwar_btn_01"))
	self.fields.Button_gift:addClickEventListener(handler(self, self.onClickGift))
	self.fields.Com_9001705_attr1:addClickEventListener(handler(self, self.onClickAttr), "power")
	self.fields.Com_9001705_attr2:addClickEventListener(handler(self, self.onClickAttr), "speed")
	self.fields.Com_9001705_attr3:addClickEventListener(handler(self, self.onClickAttr), "lucky")
	self.fields.Com_9001705_attUpbg:addClickEventListener(handler(self, self.onClickAttr), "all")
	_UPVALUE2_ = handler(self, self.onClickAttr)
	handler(self, self.onClickAttr)[1] = 859601
	handler(self, self.onClickAttr)[2] = 1
	self.itemID = constantRead.getConstValueArray("SKY_COMPETITION_DAILY_ITEM", (handler(self, self.onClickAttr)))[1]
	self.fields.Com_have:initData(self.itemID, handler(self, self.onAddClick))
end
function Com_9001705_mainUI:onShow()
	self:initData()
end
function Com_9001705_mainUI:initData()
	self.fields.Com_9001705_attr1:initData("power")
	self.fields.Com_9001705_attr2:initData("speed")
	self.fields.Com_9001705_attr3:initData("lucky")
	_ENV = nil
	;(nil).num = activity_9001705_Ctrl:getAttScore()
	self.fields.text_score:setString(i18n("snow_competition_text_03", nil))
	self.haveNum = self.fields.Com_have:updateNum()
	self.fields.Button_satrt:setCost(self.itemID, 1)
end
function Com_9001705_mainUI:updateRedDot()
	local redNum = 0
	local achieveRedDot = activity_9001705_Ctrl:getAchieveRedDot()
	self.fields.Button_task:setReddot(0 < achieveRedDot)
	redNum = redNum + achieveRedDot
	local freeRedDot = activity_9001705_Ctrl:getIsCanGetDailyFreeReward() and 1 or 0
	self.fields.Button_gift:setReddot(0 < freeRedDot)
	redNum = redNum + freeRedDot
	local itemRedDot = 1 <= self.haveNum and 1 or 0
	self.fields.Button_satrt:setReddot(0 < itemRedDot)
	redNum = redNum + itemRedDot
	local attrUpRedDot = activity_9001705_Ctrl:getAttrUpReddot()
	redNum = redNum + attrUpRedDot
	self.fields.Com_9001705_attUpbg:setReddot(0 < attrUpRedDot)
	_UPVALUE5_ = self.fields.Com_9001705_attUpbg
	self.fields.Com_9001705_attUpbg[1] = redNum
	self.fields.Com_9001705_attUpbg[2] = achieveRedDot
	self.fields.Com_9001705_attUpbg[3] = freeRedDot
	self.fields.Com_9001705_attUpbg[4] = itemRedDot
	self.fields.Com_9001705_attUpbg[5] = attrUpRedDot
	dump(self.fields.Com_9001705_attUpbg, "Com_9001705_mainUI:updateRedDot")
	return redNum
end
function Com_9001705_mainUI:setStartCallback(callback)
	self.startCallback = callback
end
function Com_9001705_mainUI:onClickStart()
	SoraDPlaySound()
	if self.haveNum <= 0 then
		self:onAddClick()
		return
	end
	if self.startCallback then
		self.startCallback()
	end
end
function Com_9001705_mainUI:onClickRank()
	SoraDPlaySound()
	uiManager:show("Activity_9001705_Rank")
end
function Com_9001705_mainUI:onClickTask()
	SoraDPlaySound()
	uiManager:show("Activity_9001705_Achievement")
end
function Com_9001705_mainUI:onClickGift()
	SoraDPlaySound()
	if activity_9001705_Ctrl:getIsCanGetDailyFreeReward() or activity_9001705_Ctrl:getIsCanBuyDailyGift() then
		_ENV = nil
		;(nil).type = "Free"
		uiManager:show("Activity_9001705_ItemGet", nil)
	else
		SoraDShowMsgTip(i18n("snow_competition_text_02"))
	end
end
function Com_9001705_mainUI:onClickAttr(sender, attr)
	SoraDPlaySound()
	uiManager:show("Activity_9001705_AttUp")
end
function Com_9001705_mainUI:onAddClick()
	_ENV = nil
	;(nil).type = "GetItem"
	uiManager:show("Activity_9001705_ItemGet", nil)
end
return Com_9001705_mainUI
