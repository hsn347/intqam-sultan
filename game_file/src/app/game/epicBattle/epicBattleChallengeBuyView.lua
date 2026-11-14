local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicBattleChallengeBuyView = class("epicBattleChallengeBuyView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicBattleChallengeBuyView")
	end
	return target
end)
function epicBattleChallengeBuyView:ctor()
	self.data, _ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node")
	self.needGold = 0
	self.needBuy = 1
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.Text_sure = SoraDGetChildByName(self, "Text_sure")
	self.Text_sure:setString(i18n("epicbattle_text_32"))
	self.btnBuy = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldSmallBtn_buy")
	_ENV = "CCS_commonGoldSmallBtn_buy"
	;("CCS_commonGoldSmallBtn_buy").title = i18n("common_text_282")
	self.btnBuy:initData("CCS_commonGoldSmallBtn_buy", 1)
	self.btnBuy:addTouchEventListener(handler(self, self.btnBuyClickCallBack))
	self.btnBuy:setVisible(false)
	self.Text_bought = SoraDGetChildByName(self, "Text_bought")
	self.Node_normal = SoraDGetChildByName(self, "Node_normal")
	self.Node_toCollege = SoraDGetChildByName(self, "Node_toCollege")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Button_go = SoraDGetChildByName(self, "Button_go")
	self.Button_go:setTitleText(i18n("common_text_477"))
	self.Button_go:addTouchEventListener(handler(self, self.btnGoClickCallBack))
	self.buySlider = SoraDGetExtendChildFromCCSByName(self, "CCS_commonSlider_num")
end
function epicBattleChallengeBuyView:initData(data)
	self.data = data
	self.ccs_bg:setTitleName(self.data.name)
	self:updateView()
end
function epicBattleChallengeBuyView:updateView()
	local boughtCount = epicWarCtrl:getStageBoughtChallangeCount(self.data.stage)
	local limitCount = epicWarltCtrl.getMaxChallengeBuyCount()
	if 0 < limitCount - boughtCount then
		self.btnBuy:setVisible(true)
		self.btnBuy:setTouchEnabled(boughtCount < limitCount)
		self.btnBuy:setBright(boughtCount < limitCount)
		self.needGold = epicWarltCtrl.getBuyChallengeGold(boughtCount, 1)
		self.btnBuy:setGoldText(self.needGold)
		epicWarCtrl = nil
		;(nil).buyed = boughtCount
		;(nil).maxbuy = limitCount
		self.Text_bought:setString(i18n("epicbattle_text_33", nil))
		epicWarCtrl = i18n("epicbattle_text_33", nil)
		i18n("epicbattle_text_33", nil).maxValue = limitCount - boughtCount
		i18n("epicbattle_text_33", nil).minValue = 1
		i18n("epicbattle_text_33", nil).curValue = 1
		self.buySlider:initData(i18n("epicbattle_text_33", nil))
		self:payGoldChange(1)
		self.buySlider:setSliderCallBack(handler(self, self.payGoldChange))
		self.Node_normal:setVisible(true)
		self.Node_toCollege:setVisible(false)
	else
		self.Node_normal:setVisible(false)
		self.Node_toCollege:setVisible(true)
		if boughtCount >= EPIC_MAX_BUY_COUNT then
			self.Text_tip:setString(i18n("tips_moppingUpTimes_limit"))
			self.Text_tip:setPositionY(0)
			self.Button_go:setVisible(false)
		else
			self.Text_tip:setString(i18n("epicbattle_text_40"))
			self.Text_tip:setPositionY(40)
			self.Button_go:setVisible(true)
		end
	end
end
function epicBattleChallengeBuyView:payGoldChange(needBuy)
	local boughtCount = epicWarCtrl:getStageBoughtChallangeCount(self.data.stage)
	self.needGold = epicWarltCtrl.getBuyChallengeGold(boughtCount, needBuy)
	self.needBuy = needBuy
	self.btnBuy:setGoldText(self.needGold)
	self.btnBuy:setTextGoldColor(SoraDEnoughGold(self.needGold, true) and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40))
end
function epicBattleChallengeBuyView:btnBuyClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if SoraDEnoughGold(self.needGold) then
			_ENV = nil
			;(nil).item = ""
			SoraDShowMsgBox(i18n("common_text_662", nil), i18n("common_text_204"), nil, function(event)
				if event == MSGBOX_CALLBACK_YES then
					epicWarCtrl:sendReqBuyChallengeCount(self.data.stage, self.needBuy)
					self:removeFromParent()
				end
			end)
		end
	end
end
function epicBattleChallengeBuyView:btnGoClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllPanelFromManager()
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
		SoraDSendMessage(nil)
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.RESEARCH_TECHNOLOGY, nil)
	end
end
return epicBattleChallengeBuyView
