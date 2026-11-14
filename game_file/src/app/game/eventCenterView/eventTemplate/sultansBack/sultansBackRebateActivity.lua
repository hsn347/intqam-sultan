local sultansBackRebateUtil = include("sultansBackRebateUtil")
local sultansBackRebateActivity = class("sultansBackRebateActivity", function()
	local target = SoraDCreateBasePanel("sultansBackRebateActivity")
	SoraDDeviceFitOffset(target)
	return target
end)
function sultansBackRebateActivity:onEnterPanel()
	SoraDGetCtrl("activityCenterUICtrl"):sendClearNewMsg(self.activityID)
end
function sultansBackRebateActivity:ctor(properties)
	self.payType = 1
	self.activityID = gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY
	self.topNode = SoraDGetChildByName(self, "Top_Node_title")
	self.nodeTime = SoraDGetChildByName(self.topNode, "Node_time")
	self.textTime = SoraDGetChildByName(self.nodeTime, "Text_time")
	self.textTime = SoraDCreateTimerLabel(self, self.textTime)
	self.nodeTop = SoraDGetChildByName(self, "Top_Node_Content")
	self.ccs_tabOAP = SoraDGetExtendChildFromCCSByName(self.topNode, "CCS_commonTabBtnEX_OAP")
	self.nodeCommonTabBtn = SoraDGetExtendChildFromCCSByName(self.topNode, "CCS_commonTabBtnEX")
	self.nodeCommonTabBtn:setNewStyle()
	self.nodeCommonTabBtn:setContentSize(cc.size(640, 50))
	self.ccs_tabOAP:setContentSize(cc.size(640, 56))
	self.ccs_tabOAP:setNewStyle()
end
function sultansBackRebateActivity:initData()
	self:initActivityTime()
	_ENV, _ENV = self, self.initActivityTime
	self.title = i18n("activity_name_9001297")
	self.handle = handler(self, self.btnTabClick)
	self.tag = 1
	_ENV, self.initActivityTime[1], self.fontSize = self, self, 22
	self.title = i18n("back_recharge_text22")
	self.handle = handler(self, self.btnTabClick)
	self.tag = 2
	self.tableData, self.initActivityTime[2], self.fontSize = self.initActivityTime, self, 22
	_ENV = handler(self, self.btnTabClick)
	handler(self, self.btnTabClick).tabNum = #self.tableData
	handler(self, self.btnTabClick).defaultClick = 1
	handler(self, self.btnTabClick).tabsetArray = self.tableData
	self.nodeCommonTabBtn:initView((handler(self, self.btnTabClick)))
	_ENV = handler(self, self.btnTabClick)
	_ENV, _ENV, handler(self, self.btnTabClick).tabNum = self.btnTabClick, self.tableData, 2
	self.btnTabClick.title = i18n("common_text_4617")
	self.btnTabClick.tag = 1
	_ENV, self.tableData[1], self.btnTabClick.handle = self.btnTabClick, self.btnTabClick, handler(self, self.clickOAPTab)
	_ENV = self.clickOAPTab
	self.clickOAPTab.item = include("publicRead").getName(TOKEN_ITEM)
	self.btnTabClick.title = i18n("common_text_4618", self.clickOAPTab)
	self.btnTabClick.tag = 2
	handler(self, self.btnTabClick).tabsetArray, self.tableData[2], self.btnTabClick.handle = self.tableData, self.btnTabClick, handler(self, self.clickOAPTab)
	self.ccs_tabOAP:initView((handler(self, self.btnTabClick)))
	self:updateRedPacketTip()
end
function sultansBackRebateActivity:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SULTANSBACK_RREBATE_REFRESH", handler(self, self.updateRedPacketTip))
end
function sultansBackRebateActivity:updateRedPacketTip()
	do
		local num = sultansBackRebateUtil:getRechargeRedNum()
		self.nodeCommonTabBtn:setRedPointState(2, 0 < num)
	end
end
function sultansBackRebateActivity:setParentView(parent)
	self.parentView = parent
end
function sultansBackRebateActivity:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.textTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	if self.eventTime then
		self.textTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	SoraDToCenter(self.nodeTime, 10, SoraDFIsRA())
end
function sultansBackRebateActivity:btnTabClick(showViewType)
	if self.showViewType == showViewType then
		return
	end
	self.showViewType = showViewType
	for i, v in ipairs(self.tableData) do
		local show = i == showViewType
		if show then
			if not v.panel then
				v.panel = self:createPanel(showViewType)
			end
			if v.panel then
				v.panel:setVisible(true)
			end
		elseif v.panel then
			v.panel:setVisible(false)
		end
	end
	self:updateOutAppPurchase()
end
function sultansBackRebateActivity:createPanel(showViewType)
	local panel
	if showViewType == 1 then
		panel = SoraDCreatePanelByFixName("sultansBackRebateMainView")
		panel:setPosition(0, 0)
		panel:setParentView(self.parentView)
		panel:init()
		panel:addTo(self.nodeTop, -1)
	elseif showViewType == 2 then
		panel = SoraDCreatePanelByFixName("sultansBackRebateGiftView")
		panel:setPosition(0, 0)
		panel:setParentView(self.parentView)
		panel:init(self.payType)
		panel:addTo(self.nodeTop, -2)
	end
	return panel
end
function sultansBackRebateActivity:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen() and self.showViewType == 2 then
		self.ccs_tabOAP:setVisible(true)
		if self.tableData[2] and self.tableData[2].panel then
			self.tableData[2].panel:setPositionY(-48)
			self.tableData[2].panel:resetSize(cc.size(640, self.nodeTop:getPositionY() - 48))
		end
	else
		self.ccs_tabOAP:setVisible(false)
	end
end
function sultansBackRebateActivity:clickOAPTab(tag)
	if self.showViewType == 2 then
		self.payType = tag
		if self.tableData[2] and self.tableData[2].panel then
			self.tableData[2].panel:init(self.payType)
		end
	end
end
function sultansBackRebateActivity:getPayType()
	return self.payType
end
return sultansBackRebateActivity
