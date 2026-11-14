local baseComponent = require("fgui.base.baseComponent")
local Com_choice = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Com_choice", Com_choice)
function Com_choice:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.Text_choiceLuckyTime)
	self.fields.Label_reddot:initData(false)
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.Label_reddot:fixPos()
end
function Com_choice:onShow()
end
function Com_choice:setRedPoint(ret)
	self.fields.Label_reddot:initData(ret, 0)
end
function Com_choice:setTime(time, firstHeroID)
	self.Text_Time:beginTime(time)
	self.Text_Time:setTimeUpdateListener(function(leftTime)
		_ENV = nil
		;(nil).byUID = true
		local lastHeroID = SoraDConfigGet("Game:heroGiftCtrl:endHeroID~integer", nil)
		if lastHeroID ~= firstHeroID and leftTime < 86400 then
			self:setRedPoint(true)
		end
	end)
end
function Com_choice:onBtnClick()
	SoraDPlaySound("uicontrol", 50)
	local heroGiftCtrl = SoraDGetCtrl("heroGiftCtrl")
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:heroGiftCtrl:isNewGift~bool", false, nil)
	local heroID = heroGiftCtrl:getMinimumTimeGift().heroID
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:heroGiftCtrl:endHeroID~integer", heroID, nil)
	_ENV = "Game:heroGiftCtrl:endHeroID~integer"
	;("Game:heroGiftCtrl:endHeroID~integer").msg = "MESSAGE_HERO_GIFT_RECHARGE_REFRESH"
	SoraDSendMessage("Game:heroGiftCtrl:endHeroID~integer")
	uiManager:show("HeroGiftRecharge")
end
return Com_choice
