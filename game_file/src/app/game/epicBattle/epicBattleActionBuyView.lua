local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicBattleActionBuyView = class("epicBattleActionBuyView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicBattleActionBuyView")
	end
	return target
end)
function epicBattleActionBuyView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("epicbattle_title_02"))
	self.Node_cur = SoraDGetChildByName(self, "Node_cur")
	self.Text_cur = SoraDGetChildByName(self.Node_cur, "Text_cur")
	self.Node_next = SoraDGetChildByName(self, "Node_next")
	self.Text_next = SoraDGetChildByName(self.Node_next, "Text_next")
	self.Node_all = SoraDGetChildByName(self, "Node_all")
	self.Text_all = SoraDGetChildByName(self.Node_all, "Text_all")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_buy = SoraDGetChildByName(self, "Text_buy")
	self.Text_buyNum = SoraDGetChildByName(self, "Text_buyNum")
	self.Button_buy = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_buy")
	_ENV = "CCS_commonGoldNormalBtn_buy"
	;("CCS_commonGoldNormalBtn_buy").title = i18n("common_text_282")
	self.Button_buy:initData("CCS_commonGoldNormalBtn_buy", 1)
	self.Button_buy:addTouchEventListener(handler(self, self.onBtnClickBack))
	self:initData()
end
function epicBattleActionBuyView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_ACTION_UPDATE", handler(self, self.initData))
end
function epicBattleActionBuyView:updateNextTime()
	local curAction = epicWarCtrl:getCurExploreCount()
	local maxAction = epicWarCtrl:getMaxExploreCount()
	if curAction >= maxAction then
		self:removeNextTimer()
	else
		epicWarCtrl = nil
		;(nil).num = curAction
		;(nil).maxnum = maxAction
		self.Text_cur:setString(i18n("epicbattle_text_26", nil))
		local nextTime = epicWarCtrl:getNextExploreRecoverTime()
		epicWarCtrl = i18n("epicbattle_text_26", nil)
		i18n("epicbattle_text_26", nil).time = SoraDConvertSecondToString(nextTime)
		self.Text_next:setString(i18n("epicbattle_text_21", i18n("epicbattle_text_26", nil)))
	end
end
function epicBattleActionBuyView:removeNextTimer()
	if self.nextTimer then
		_ENV = nil
		;(nil).time = "MAX"
		self.Text_next:setString(i18n("epicbattle_text_21", nil))
		SoraDManagerRemoveTimer(self, self.nextTimer)
		self.nextTimer = nil
	end
end
function epicBattleActionBuyView:updateAllTime()
	local curAction = epicWarCtrl:getCurExploreCount()
	local maxAction = epicWarCtrl:getMaxExploreCount()
	if curAction >= maxAction then
		self:removeAllTimer()
	else
		local allTime = epicWarCtrl:getAllExploreRecoverTime()
		epicWarCtrl = nil
		;(nil).time = SoraDConvertSecondToString(allTime)
		self.Text_all:setString(i18n("epicbattle_text_22", nil))
	end
end
function epicBattleActionBuyView:removeAllTimer()
	if self.allTimer then
		_ENV = nil
		;(nil).time = "MAX"
		self.Text_all:setString(i18n("epicbattle_text_22", nil))
		SoraDManagerRemoveTimer(self, self.allTimer)
		self.allTimer = nil
	end
end
function epicBattleActionBuyView:initData(target, data)
	SoraDCloseLoading(self)
	_ENV = nil
	;(nil).var1 = epicWarltCtrl.getExplorePointOnceBuy()
	self.Text_tip:setString(i18n("epic_war_buyPoint_desc", nil))
	local curAction = epicWarCtrl:getCurExploreCount()
	local maxAction = epicWarCtrl:getMaxExploreCount()
	_ENV = i18n("epic_war_buyPoint_desc", nil)
	i18n("epic_war_buyPoint_desc", nil).num = curAction
	i18n("epic_war_buyPoint_desc", nil).maxnum = maxAction
	self.Text_cur:setString(i18n("epicbattle_text_26", i18n("epic_war_buyPoint_desc", nil)))
	local nextTime = epicWarCtrl:getNextExploreRecoverTime()
	self:removeNextTimer()
	if 0 < nextTime and not self.nextTimer then
		self.nextTimer = SoradCreateTimer(self, handler(self, self.updateNextTime))
		self:updateNextTime()
	elseif nextTime <= 0 then
		_ENV = handler(self, self.updateNextTime)
		handler(self, self.updateNextTime).time = "MAX"
		self.Text_next:setString(i18n("epicbattle_text_21", handler(self, self.updateNextTime)))
	end
	local allTime = epicWarCtrl:getAllExploreRecoverTime()
	self:removeAllTimer()
	if 0 < allTime and not self.allTimer then
		self.allTimer = SoradCreateTimer(self, handler(self, self.updateAllTime))
		self:updateAllTime()
	elseif allTime <= 0 then
		_ENV = handler(self, self.updateAllTime)
		handler(self, self.updateAllTime).time = "MAX"
		self.Text_all:setString(i18n("epicbattle_text_22", handler(self, self.updateAllTime)))
	end
	local curBuy = epicWarCtrl:getDailyBoughtTimes()
	local limitBuy = epicWarCtrl:getDailyMaxBuyTimes()
	_ENV = i18n("epicbattle_text_22", handler(self, self.updateAllTime))
	i18n("epicbattle_text_22", handler(self, self.updateAllTime)).num = curBuy
	i18n("epicbattle_text_22", handler(self, self.updateAllTime)).maxnum = limitBuy
	self.Text_buy:setString(i18n("epicbattle_text_23", i18n("epicbattle_text_22", handler(self, self.updateAllTime))))
	self.needGold = epicWarltCtrl.getBuyActionGold(curBuy + 1)
	self.Button_buy:setGoldText(self.needGold)
	self.Button_buy:setTextGoldColor(SoraDEnoughGold(self.needGold, true) and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40))
	self.Button_buy:setVisible(curBuy < limitBuy)
end
function epicBattleActionBuyView:onBtnClickBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if SoraDEnoughGold(self.needGold) then
			epicWarCtrl:sendReqBuyExplorePoint()
			SoraDShowLoading(self)
		end
	end
end
return epicBattleActionBuyView
