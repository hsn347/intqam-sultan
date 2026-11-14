local gametop = gModuleMgr.getObject("gametop")
local newKingFundCtrl = gametop.playertop_:getModule("newKingFundCtrl")
local newKingFundRead = include("newKingFundRead")
local newKingFundView = class("newKingFundView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("newKingFundView")
	end
	return target
end)
function newKingFundView:closePanel(...)
	SoraDRemoveAllAfterPanelFromManager(self, true)
	include("basePanel").closePanel(self)
end
function newKingFundView:ctor()
	self.itemList, _UPVALUE0_ = nil, nil
	self:initWidget()
	self:addMessage()
	self:initData()
end
function newKingFundView:addMessage(...)
	SoraDAddMessage(self, "MESSAGE_NEWKINGFUND_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		self:initData()
		self:showRewards()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeEventClose))
end
_ENV, newKingFundView.initWidget = function(self, ...)
	self.Top_Image_cut = SoraDGetChildByName(self, "Top_Image_cut")
	SoraChangeSpriteImage(self.Top_Image_cut, "bg_activity_king_road.png")
	self.Top_Image_cut:setScale(display.height / self.Top_Image_cut:getContentSize().height)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("new_lord_fund_text_01"))
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_gold")
	newKingFundCtrl = "CCS_commonGoldTop_gold"
	;("CCS_commonGoldTop_gold")[1] = "Text_time"
	self.labReturnTime = SoraDGetChildByFullPath(self.Top_Node, "CCS_commonGoldTop_gold")
	self.labReturnTime = SoraDCreateTimerLabel(self, self.labReturnTime)
	self.labReturnTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).Time = ticket
		return i18n("new_lord_fund_text_02", nil)
	end)
	self.labReturnTime:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(nil)
	end)
	_ENV = i18n("new_lord_fund_text_01")
	i18n("new_lord_fund_text_01").Time = "1d 00:00:00"
	self.labReturnTime:setString(i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	newKingFundCtrl = i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))
	i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(self.Top_Node, i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	self.Button_help:setPositionX(self.labReturnTime:getPositionX() + self.labReturnTime:getContentSize().width / 2 + 30)
	self.Button_help:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		_ENV = "new_lord_fund_text_15"
		;("new_lord_fund_text_15").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("new_lord_fund_text_15"), "new_lord_fund_text_15")
	end)
	self.Center_Node_disk = SoraDGetChildByName(self, "Center_Node_disk")
	newKingFundCtrl = "Center_Node_disk"
	;("Center_Node_disk")[1] = "Node_day_4"
	self.Node_day_4 = SoraDGetChildByFullPath(self.Center_Node_disk, "Center_Node_disk")
	self.Node_day_4:setVisible(false)
	newKingFundCtrl = false
	;(false)[1] = "frame_disk"
	self.frame_disk = SoraDGetChildByFullPath(self.Center_Node_disk, false)
	self.frame_disk:setLocalZOrder(10)
	newKingFundCtrl = 10
	;(10)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.frame_disk, 10)
	self.Text_1:setString(i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_1"
	self.Node_gold_1 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_2"
	self.labGold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_1"
	self.Sprite_gold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_2"
	self.Node_gold_2 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_4"
	self.labGold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_2"
	self.Sprite_gold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Text_6"
	self.labInvestAdd = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Button_rule"
	self.Button_rule = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	self.Button_rule:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "ScrollView_1"
	self.scroll = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Node_info"
	self.Node_info = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.Node_info, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	self.Text_1:setString(i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show"
	self.Node_show = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show_2"
	self.Node_show_2 = SoraDGetChildByFullPath(self.Node_show, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Text_4"
	self.Text_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_11"))
	self.Text_4:setString(i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_5"
	self.labGold_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_7"
	SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_04")):setString(i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "Node_invest"
	self.Node_invest = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "button_invest"
	self.button_invest = SoraDGetChildByFullPath(self.Node_invest, i18n("new_lord_fund_text_14"))
	self.button_invest:addTouchEventListener(handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_gold"
	self.labInvestGold = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_des"
	self.labInvest = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	self.labInvest = SoraDCreateTimerLabel(self, self.labInvest)
	self.labInvest:setTimeEndListener(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Text_gold"
	self.Text_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Sprite_gold"
	self.Sprite_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	self:addDoubleFireEffect()
	if display.height < 1000 then
		self.Center_Node_disk:setScale(display.height / 1136 * 0.9)
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - 15)
		self.Bottom_Node:setPositionY(self.Bottom_Node:getPositionY() - 38)
		newKingFundCtrl = self.Bottom_Node:getPositionY() - 38
		;(self.Bottom_Node:getPositionY() - 38)[1] = "Text_7"
		SoraDGetChildByFullPath(self.Node_info, self.Bottom_Node:getPositionY() - 38):setVisible(false)
	else
		local offsety = (display.height - 1136) / 2
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - offsety)
	end
end, function(self, ...)
	self.Top_Image_cut = SoraDGetChildByName(self, "Top_Image_cut")
	SoraChangeSpriteImage(self.Top_Image_cut, "bg_activity_king_road.png")
	self.Top_Image_cut:setScale(display.height / self.Top_Image_cut:getContentSize().height)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("new_lord_fund_text_01"))
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_gold")
	newKingFundCtrl = "CCS_commonGoldTop_gold"
	;("CCS_commonGoldTop_gold")[1] = "Text_time"
	self.labReturnTime = SoraDGetChildByFullPath(self.Top_Node, "CCS_commonGoldTop_gold")
	self.labReturnTime = SoraDCreateTimerLabel(self, self.labReturnTime)
	self.labReturnTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).Time = ticket
		return i18n("new_lord_fund_text_02", nil)
	end)
	self.labReturnTime:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(nil)
	end)
	_ENV = i18n("new_lord_fund_text_01")
	i18n("new_lord_fund_text_01").Time = "1d 00:00:00"
	self.labReturnTime:setString(i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	newKingFundCtrl = i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))
	i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(self.Top_Node, i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	self.Button_help:setPositionX(self.labReturnTime:getPositionX() + self.labReturnTime:getContentSize().width / 2 + 30)
	self.Button_help:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		_ENV = "new_lord_fund_text_15"
		;("new_lord_fund_text_15").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("new_lord_fund_text_15"), "new_lord_fund_text_15")
	end)
	self.Center_Node_disk = SoraDGetChildByName(self, "Center_Node_disk")
	newKingFundCtrl = "Center_Node_disk"
	;("Center_Node_disk")[1] = "Node_day_4"
	self.Node_day_4 = SoraDGetChildByFullPath(self.Center_Node_disk, "Center_Node_disk")
	self.Node_day_4:setVisible(false)
	newKingFundCtrl = false
	;(false)[1] = "frame_disk"
	self.frame_disk = SoraDGetChildByFullPath(self.Center_Node_disk, false)
	self.frame_disk:setLocalZOrder(10)
	newKingFundCtrl = 10
	;(10)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.frame_disk, 10)
	self.Text_1:setString(i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_1"
	self.Node_gold_1 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_2"
	self.labGold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_1"
	self.Sprite_gold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_2"
	self.Node_gold_2 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_4"
	self.labGold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_2"
	self.Sprite_gold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Text_6"
	self.labInvestAdd = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Button_rule"
	self.Button_rule = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	self.Button_rule:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "ScrollView_1"
	self.scroll = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Node_info"
	self.Node_info = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.Node_info, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	self.Text_1:setString(i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show"
	self.Node_show = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show_2"
	self.Node_show_2 = SoraDGetChildByFullPath(self.Node_show, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Text_4"
	self.Text_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_11"))
	self.Text_4:setString(i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_5"
	self.labGold_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_7"
	SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_04")):setString(i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "Node_invest"
	self.Node_invest = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "button_invest"
	self.button_invest = SoraDGetChildByFullPath(self.Node_invest, i18n("new_lord_fund_text_14"))
	self.button_invest:addTouchEventListener(handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_gold"
	self.labInvestGold = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_des"
	self.labInvest = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	self.labInvest = SoraDCreateTimerLabel(self, self.labInvest)
	self.labInvest:setTimeEndListener(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Text_gold"
	self.Text_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Sprite_gold"
	self.Sprite_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	self:addDoubleFireEffect()
	if display.height < 1000 then
		self.Center_Node_disk:setScale(display.height / 1136 * 0.9)
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - 15)
		self.Bottom_Node:setPositionY(self.Bottom_Node:getPositionY() - 38)
		newKingFundCtrl = self.Bottom_Node:getPositionY() - 38
		;(self.Bottom_Node:getPositionY() - 38)[1] = "Text_7"
		SoraDGetChildByFullPath(self.Node_info, self.Bottom_Node:getPositionY() - 38):setVisible(false)
	else
		local offsety = (display.height - 1136) / 2
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - offsety)
	end
end
;(function(self, ...)
	self.Top_Image_cut = SoraDGetChildByName(self, "Top_Image_cut")
	SoraChangeSpriteImage(self.Top_Image_cut, "bg_activity_king_road.png")
	self.Top_Image_cut:setScale(display.height / self.Top_Image_cut:getContentSize().height)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("new_lord_fund_text_01"))
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_gold")
	newKingFundCtrl = "CCS_commonGoldTop_gold"
	;("CCS_commonGoldTop_gold")[1] = "Text_time"
	self.labReturnTime = SoraDGetChildByFullPath(self.Top_Node, "CCS_commonGoldTop_gold")
	self.labReturnTime = SoraDCreateTimerLabel(self, self.labReturnTime)
	self.labReturnTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).Time = ticket
		return i18n("new_lord_fund_text_02", nil)
	end)
	self.labReturnTime:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(nil)
	end)
	_ENV = i18n("new_lord_fund_text_01")
	i18n("new_lord_fund_text_01").Time = "1d 00:00:00"
	self.labReturnTime:setString(i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	newKingFundCtrl = i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))
	i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(self.Top_Node, i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	self.Button_help:setPositionX(self.labReturnTime:getPositionX() + self.labReturnTime:getContentSize().width / 2 + 30)
	self.Button_help:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		_ENV = "new_lord_fund_text_15"
		;("new_lord_fund_text_15").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("new_lord_fund_text_15"), "new_lord_fund_text_15")
	end)
	self.Center_Node_disk = SoraDGetChildByName(self, "Center_Node_disk")
	newKingFundCtrl = "Center_Node_disk"
	;("Center_Node_disk")[1] = "Node_day_4"
	self.Node_day_4 = SoraDGetChildByFullPath(self.Center_Node_disk, "Center_Node_disk")
	self.Node_day_4:setVisible(false)
	newKingFundCtrl = false
	;(false)[1] = "frame_disk"
	self.frame_disk = SoraDGetChildByFullPath(self.Center_Node_disk, false)
	self.frame_disk:setLocalZOrder(10)
	newKingFundCtrl = 10
	;(10)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.frame_disk, 10)
	self.Text_1:setString(i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_1"
	self.Node_gold_1 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_2"
	self.labGold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_1"
	self.Sprite_gold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_2"
	self.Node_gold_2 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_4"
	self.labGold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_2"
	self.Sprite_gold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Text_6"
	self.labInvestAdd = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Button_rule"
	self.Button_rule = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	self.Button_rule:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "ScrollView_1"
	self.scroll = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Node_info"
	self.Node_info = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.Node_info, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	self.Text_1:setString(i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show"
	self.Node_show = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show_2"
	self.Node_show_2 = SoraDGetChildByFullPath(self.Node_show, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Text_4"
	self.Text_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_11"))
	self.Text_4:setString(i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_5"
	self.labGold_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_7"
	SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_04")):setString(i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "Node_invest"
	self.Node_invest = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "button_invest"
	self.button_invest = SoraDGetChildByFullPath(self.Node_invest, i18n("new_lord_fund_text_14"))
	self.button_invest:addTouchEventListener(handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_gold"
	self.labInvestGold = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_des"
	self.labInvest = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	self.labInvest = SoraDCreateTimerLabel(self, self.labInvest)
	self.labInvest:setTimeEndListener(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Text_gold"
	self.Text_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Sprite_gold"
	self.Sprite_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	self:addDoubleFireEffect()
	if display.height < 1000 then
		self.Center_Node_disk:setScale(display.height / 1136 * 0.9)
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - 15)
		self.Bottom_Node:setPositionY(self.Bottom_Node:getPositionY() - 38)
		newKingFundCtrl = self.Bottom_Node:getPositionY() - 38
		;(self.Bottom_Node:getPositionY() - 38)[1] = "Text_7"
		SoraDGetChildByFullPath(self.Node_info, self.Bottom_Node:getPositionY() - 38):setVisible(false)
	else
		local offsety = (display.height - 1136) / 2
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - offsety)
	end
end)[1] = cc.p(0, 5)
;(function(self, ...)
	self.Top_Image_cut = SoraDGetChildByName(self, "Top_Image_cut")
	SoraChangeSpriteImage(self.Top_Image_cut, "bg_activity_king_road.png")
	self.Top_Image_cut:setScale(display.height / self.Top_Image_cut:getContentSize().height)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("new_lord_fund_text_01"))
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_gold")
	newKingFundCtrl = "CCS_commonGoldTop_gold"
	;("CCS_commonGoldTop_gold")[1] = "Text_time"
	self.labReturnTime = SoraDGetChildByFullPath(self.Top_Node, "CCS_commonGoldTop_gold")
	self.labReturnTime = SoraDCreateTimerLabel(self, self.labReturnTime)
	self.labReturnTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).Time = ticket
		return i18n("new_lord_fund_text_02", nil)
	end)
	self.labReturnTime:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(nil)
	end)
	_ENV = i18n("new_lord_fund_text_01")
	i18n("new_lord_fund_text_01").Time = "1d 00:00:00"
	self.labReturnTime:setString(i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	newKingFundCtrl = i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))
	i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(self.Top_Node, i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	self.Button_help:setPositionX(self.labReturnTime:getPositionX() + self.labReturnTime:getContentSize().width / 2 + 30)
	self.Button_help:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		_ENV = "new_lord_fund_text_15"
		;("new_lord_fund_text_15").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("new_lord_fund_text_15"), "new_lord_fund_text_15")
	end)
	self.Center_Node_disk = SoraDGetChildByName(self, "Center_Node_disk")
	newKingFundCtrl = "Center_Node_disk"
	;("Center_Node_disk")[1] = "Node_day_4"
	self.Node_day_4 = SoraDGetChildByFullPath(self.Center_Node_disk, "Center_Node_disk")
	self.Node_day_4:setVisible(false)
	newKingFundCtrl = false
	;(false)[1] = "frame_disk"
	self.frame_disk = SoraDGetChildByFullPath(self.Center_Node_disk, false)
	self.frame_disk:setLocalZOrder(10)
	newKingFundCtrl = 10
	;(10)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.frame_disk, 10)
	self.Text_1:setString(i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_1"
	self.Node_gold_1 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_2"
	self.labGold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_1"
	self.Sprite_gold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_2"
	self.Node_gold_2 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_4"
	self.labGold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_2"
	self.Sprite_gold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Text_6"
	self.labInvestAdd = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Button_rule"
	self.Button_rule = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	self.Button_rule:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "ScrollView_1"
	self.scroll = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Node_info"
	self.Node_info = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.Node_info, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	self.Text_1:setString(i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show"
	self.Node_show = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show_2"
	self.Node_show_2 = SoraDGetChildByFullPath(self.Node_show, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Text_4"
	self.Text_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_11"))
	self.Text_4:setString(i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_5"
	self.labGold_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_7"
	SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_04")):setString(i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "Node_invest"
	self.Node_invest = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "button_invest"
	self.button_invest = SoraDGetChildByFullPath(self.Node_invest, i18n("new_lord_fund_text_14"))
	self.button_invest:addTouchEventListener(handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_gold"
	self.labInvestGold = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_des"
	self.labInvest = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	self.labInvest = SoraDCreateTimerLabel(self, self.labInvest)
	self.labInvest:setTimeEndListener(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Text_gold"
	self.Text_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Sprite_gold"
	self.Sprite_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	self:addDoubleFireEffect()
	if display.height < 1000 then
		self.Center_Node_disk:setScale(display.height / 1136 * 0.9)
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - 15)
		self.Bottom_Node:setPositionY(self.Bottom_Node:getPositionY() - 38)
		newKingFundCtrl = self.Bottom_Node:getPositionY() - 38
		;(self.Bottom_Node:getPositionY() - 38)[1] = "Text_7"
		SoraDGetChildByFullPath(self.Node_info, self.Bottom_Node:getPositionY() - 38):setVisible(false)
	else
		local offsety = (display.height - 1136) / 2
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - offsety)
	end
end)[2] = cc.p(0, 0)
;(function(self, ...)
	self.Top_Image_cut = SoraDGetChildByName(self, "Top_Image_cut")
	SoraChangeSpriteImage(self.Top_Image_cut, "bg_activity_king_road.png")
	self.Top_Image_cut:setScale(display.height / self.Top_Image_cut:getContentSize().height)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("new_lord_fund_text_01"))
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_gold")
	newKingFundCtrl = "CCS_commonGoldTop_gold"
	;("CCS_commonGoldTop_gold")[1] = "Text_time"
	self.labReturnTime = SoraDGetChildByFullPath(self.Top_Node, "CCS_commonGoldTop_gold")
	self.labReturnTime = SoraDCreateTimerLabel(self, self.labReturnTime)
	self.labReturnTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).Time = ticket
		return i18n("new_lord_fund_text_02", nil)
	end)
	self.labReturnTime:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(nil)
	end)
	_ENV = i18n("new_lord_fund_text_01")
	i18n("new_lord_fund_text_01").Time = "1d 00:00:00"
	self.labReturnTime:setString(i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	newKingFundCtrl = i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))
	i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(self.Top_Node, i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	self.Button_help:setPositionX(self.labReturnTime:getPositionX() + self.labReturnTime:getContentSize().width / 2 + 30)
	self.Button_help:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		_ENV = "new_lord_fund_text_15"
		;("new_lord_fund_text_15").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("new_lord_fund_text_15"), "new_lord_fund_text_15")
	end)
	self.Center_Node_disk = SoraDGetChildByName(self, "Center_Node_disk")
	newKingFundCtrl = "Center_Node_disk"
	;("Center_Node_disk")[1] = "Node_day_4"
	self.Node_day_4 = SoraDGetChildByFullPath(self.Center_Node_disk, "Center_Node_disk")
	self.Node_day_4:setVisible(false)
	newKingFundCtrl = false
	;(false)[1] = "frame_disk"
	self.frame_disk = SoraDGetChildByFullPath(self.Center_Node_disk, false)
	self.frame_disk:setLocalZOrder(10)
	newKingFundCtrl = 10
	;(10)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.frame_disk, 10)
	self.Text_1:setString(i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_1"
	self.Node_gold_1 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_2"
	self.labGold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_1"
	self.Sprite_gold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_2"
	self.Node_gold_2 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_4"
	self.labGold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_2"
	self.Sprite_gold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Text_6"
	self.labInvestAdd = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Button_rule"
	self.Button_rule = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	self.Button_rule:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "ScrollView_1"
	self.scroll = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Node_info"
	self.Node_info = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.Node_info, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	self.Text_1:setString(i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show"
	self.Node_show = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show_2"
	self.Node_show_2 = SoraDGetChildByFullPath(self.Node_show, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Text_4"
	self.Text_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_11"))
	self.Text_4:setString(i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_5"
	self.labGold_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_7"
	SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_04")):setString(i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "Node_invest"
	self.Node_invest = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "button_invest"
	self.button_invest = SoraDGetChildByFullPath(self.Node_invest, i18n("new_lord_fund_text_14"))
	self.button_invest:addTouchEventListener(handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_gold"
	self.labInvestGold = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_des"
	self.labInvest = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	self.labInvest = SoraDCreateTimerLabel(self, self.labInvest)
	self.labInvest:setTimeEndListener(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Text_gold"
	self.Text_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Sprite_gold"
	self.Sprite_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	self:addDoubleFireEffect()
	if display.height < 1000 then
		self.Center_Node_disk:setScale(display.height / 1136 * 0.9)
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - 15)
		self.Bottom_Node:setPositionY(self.Bottom_Node:getPositionY() - 38)
		newKingFundCtrl = self.Bottom_Node:getPositionY() - 38
		;(self.Bottom_Node:getPositionY() - 38)[1] = "Text_7"
		SoraDGetChildByFullPath(self.Node_info, self.Bottom_Node:getPositionY() - 38):setVisible(false)
	else
		local offsety = (display.height - 1136) / 2
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - offsety)
	end
end)[3] = cc.p(0, 15)
;(function(self, ...)
	self.Top_Image_cut = SoraDGetChildByName(self, "Top_Image_cut")
	SoraChangeSpriteImage(self.Top_Image_cut, "bg_activity_king_road.png")
	self.Top_Image_cut:setScale(display.height / self.Top_Image_cut:getContentSize().height)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("new_lord_fund_text_01"))
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_gold")
	newKingFundCtrl = "CCS_commonGoldTop_gold"
	;("CCS_commonGoldTop_gold")[1] = "Text_time"
	self.labReturnTime = SoraDGetChildByFullPath(self.Top_Node, "CCS_commonGoldTop_gold")
	self.labReturnTime = SoraDCreateTimerLabel(self, self.labReturnTime)
	self.labReturnTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).Time = ticket
		return i18n("new_lord_fund_text_02", nil)
	end)
	self.labReturnTime:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(nil)
	end)
	_ENV = i18n("new_lord_fund_text_01")
	i18n("new_lord_fund_text_01").Time = "1d 00:00:00"
	self.labReturnTime:setString(i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	newKingFundCtrl = i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))
	i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(self.Top_Node, i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	self.Button_help:setPositionX(self.labReturnTime:getPositionX() + self.labReturnTime:getContentSize().width / 2 + 30)
	self.Button_help:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		_ENV = "new_lord_fund_text_15"
		;("new_lord_fund_text_15").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("new_lord_fund_text_15"), "new_lord_fund_text_15")
	end)
	self.Center_Node_disk = SoraDGetChildByName(self, "Center_Node_disk")
	newKingFundCtrl = "Center_Node_disk"
	;("Center_Node_disk")[1] = "Node_day_4"
	self.Node_day_4 = SoraDGetChildByFullPath(self.Center_Node_disk, "Center_Node_disk")
	self.Node_day_4:setVisible(false)
	newKingFundCtrl = false
	;(false)[1] = "frame_disk"
	self.frame_disk = SoraDGetChildByFullPath(self.Center_Node_disk, false)
	self.frame_disk:setLocalZOrder(10)
	newKingFundCtrl = 10
	;(10)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.frame_disk, 10)
	self.Text_1:setString(i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_1"
	self.Node_gold_1 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_2"
	self.labGold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_1"
	self.Sprite_gold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_2"
	self.Node_gold_2 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_4"
	self.labGold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_2"
	self.Sprite_gold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Text_6"
	self.labInvestAdd = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Button_rule"
	self.Button_rule = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	self.Button_rule:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "ScrollView_1"
	self.scroll = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Node_info"
	self.Node_info = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.Node_info, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	self.Text_1:setString(i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show"
	self.Node_show = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show_2"
	self.Node_show_2 = SoraDGetChildByFullPath(self.Node_show, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Text_4"
	self.Text_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_11"))
	self.Text_4:setString(i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_5"
	self.labGold_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_7"
	SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_04")):setString(i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "Node_invest"
	self.Node_invest = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "button_invest"
	self.button_invest = SoraDGetChildByFullPath(self.Node_invest, i18n("new_lord_fund_text_14"))
	self.button_invest:addTouchEventListener(handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_gold"
	self.labInvestGold = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_des"
	self.labInvest = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	self.labInvest = SoraDCreateTimerLabel(self, self.labInvest)
	self.labInvest:setTimeEndListener(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Text_gold"
	self.Text_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Sprite_gold"
	self.Sprite_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	self:addDoubleFireEffect()
	if display.height < 1000 then
		self.Center_Node_disk:setScale(display.height / 1136 * 0.9)
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - 15)
		self.Bottom_Node:setPositionY(self.Bottom_Node:getPositionY() - 38)
		newKingFundCtrl = self.Bottom_Node:getPositionY() - 38
		;(self.Bottom_Node:getPositionY() - 38)[1] = "Text_7"
		SoraDGetChildByFullPath(self.Node_info, self.Bottom_Node:getPositionY() - 38):setVisible(false)
	else
		local offsety = (display.height - 1136) / 2
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - offsety)
	end
end)[4] = cc.p(0, 5)
;(function(self, ...)
	self.Top_Image_cut = SoraDGetChildByName(self, "Top_Image_cut")
	SoraChangeSpriteImage(self.Top_Image_cut, "bg_activity_king_road.png")
	self.Top_Image_cut:setScale(display.height / self.Top_Image_cut:getContentSize().height)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("new_lord_fund_text_01"))
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_gold")
	newKingFundCtrl = "CCS_commonGoldTop_gold"
	;("CCS_commonGoldTop_gold")[1] = "Text_time"
	self.labReturnTime = SoraDGetChildByFullPath(self.Top_Node, "CCS_commonGoldTop_gold")
	self.labReturnTime = SoraDCreateTimerLabel(self, self.labReturnTime)
	self.labReturnTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).Time = ticket
		return i18n("new_lord_fund_text_02", nil)
	end)
	self.labReturnTime:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(nil)
	end)
	_ENV = i18n("new_lord_fund_text_01")
	i18n("new_lord_fund_text_01").Time = "1d 00:00:00"
	self.labReturnTime:setString(i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	newKingFundCtrl = i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))
	i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(self.Top_Node, i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	self.Button_help:setPositionX(self.labReturnTime:getPositionX() + self.labReturnTime:getContentSize().width / 2 + 30)
	self.Button_help:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		_ENV = "new_lord_fund_text_15"
		;("new_lord_fund_text_15").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("new_lord_fund_text_15"), "new_lord_fund_text_15")
	end)
	self.Center_Node_disk = SoraDGetChildByName(self, "Center_Node_disk")
	newKingFundCtrl = "Center_Node_disk"
	;("Center_Node_disk")[1] = "Node_day_4"
	self.Node_day_4 = SoraDGetChildByFullPath(self.Center_Node_disk, "Center_Node_disk")
	self.Node_day_4:setVisible(false)
	newKingFundCtrl = false
	;(false)[1] = "frame_disk"
	self.frame_disk = SoraDGetChildByFullPath(self.Center_Node_disk, false)
	self.frame_disk:setLocalZOrder(10)
	newKingFundCtrl = 10
	;(10)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.frame_disk, 10)
	self.Text_1:setString(i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_1"
	self.Node_gold_1 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_2"
	self.labGold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_1"
	self.Sprite_gold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_2"
	self.Node_gold_2 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_4"
	self.labGold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_2"
	self.Sprite_gold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Text_6"
	self.labInvestAdd = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Button_rule"
	self.Button_rule = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	self.Button_rule:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "ScrollView_1"
	self.scroll = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Node_info"
	self.Node_info = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.Node_info, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	self.Text_1:setString(i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show"
	self.Node_show = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show_2"
	self.Node_show_2 = SoraDGetChildByFullPath(self.Node_show, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Text_4"
	self.Text_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_11"))
	self.Text_4:setString(i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_5"
	self.labGold_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_7"
	SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_04")):setString(i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "Node_invest"
	self.Node_invest = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "button_invest"
	self.button_invest = SoraDGetChildByFullPath(self.Node_invest, i18n("new_lord_fund_text_14"))
	self.button_invest:addTouchEventListener(handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_gold"
	self.labInvestGold = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_des"
	self.labInvest = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	self.labInvest = SoraDCreateTimerLabel(self, self.labInvest)
	self.labInvest:setTimeEndListener(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Text_gold"
	self.Text_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Sprite_gold"
	self.Sprite_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	self:addDoubleFireEffect()
	if display.height < 1000 then
		self.Center_Node_disk:setScale(display.height / 1136 * 0.9)
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - 15)
		self.Bottom_Node:setPositionY(self.Bottom_Node:getPositionY() - 38)
		newKingFundCtrl = self.Bottom_Node:getPositionY() - 38
		;(self.Bottom_Node:getPositionY() - 38)[1] = "Text_7"
		SoraDGetChildByFullPath(self.Node_info, self.Bottom_Node:getPositionY() - 38):setVisible(false)
	else
		local offsety = (display.height - 1136) / 2
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - offsety)
	end
end)[5] = cc.p(0, 15)
;(function(self, ...)
	self.Top_Image_cut = SoraDGetChildByName(self, "Top_Image_cut")
	SoraChangeSpriteImage(self.Top_Image_cut, "bg_activity_king_road.png")
	self.Top_Image_cut:setScale(display.height / self.Top_Image_cut:getContentSize().height)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("new_lord_fund_text_01"))
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_gold")
	newKingFundCtrl = "CCS_commonGoldTop_gold"
	;("CCS_commonGoldTop_gold")[1] = "Text_time"
	self.labReturnTime = SoraDGetChildByFullPath(self.Top_Node, "CCS_commonGoldTop_gold")
	self.labReturnTime = SoraDCreateTimerLabel(self, self.labReturnTime)
	self.labReturnTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).Time = ticket
		return i18n("new_lord_fund_text_02", nil)
	end)
	self.labReturnTime:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(nil)
	end)
	_ENV = i18n("new_lord_fund_text_01")
	i18n("new_lord_fund_text_01").Time = "1d 00:00:00"
	self.labReturnTime:setString(i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	newKingFundCtrl = i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))
	i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(self.Top_Node, i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	self.Button_help:setPositionX(self.labReturnTime:getPositionX() + self.labReturnTime:getContentSize().width / 2 + 30)
	self.Button_help:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		_ENV = "new_lord_fund_text_15"
		;("new_lord_fund_text_15").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("new_lord_fund_text_15"), "new_lord_fund_text_15")
	end)
	self.Center_Node_disk = SoraDGetChildByName(self, "Center_Node_disk")
	newKingFundCtrl = "Center_Node_disk"
	;("Center_Node_disk")[1] = "Node_day_4"
	self.Node_day_4 = SoraDGetChildByFullPath(self.Center_Node_disk, "Center_Node_disk")
	self.Node_day_4:setVisible(false)
	newKingFundCtrl = false
	;(false)[1] = "frame_disk"
	self.frame_disk = SoraDGetChildByFullPath(self.Center_Node_disk, false)
	self.frame_disk:setLocalZOrder(10)
	newKingFundCtrl = 10
	;(10)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.frame_disk, 10)
	self.Text_1:setString(i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_1"
	self.Node_gold_1 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_2"
	self.labGold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_1"
	self.Sprite_gold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_2"
	self.Node_gold_2 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_4"
	self.labGold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_2"
	self.Sprite_gold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Text_6"
	self.labInvestAdd = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Button_rule"
	self.Button_rule = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	self.Button_rule:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "ScrollView_1"
	self.scroll = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Node_info"
	self.Node_info = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.Node_info, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	self.Text_1:setString(i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show"
	self.Node_show = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show_2"
	self.Node_show_2 = SoraDGetChildByFullPath(self.Node_show, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Text_4"
	self.Text_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_11"))
	self.Text_4:setString(i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_5"
	self.labGold_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_7"
	SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_04")):setString(i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "Node_invest"
	self.Node_invest = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "button_invest"
	self.button_invest = SoraDGetChildByFullPath(self.Node_invest, i18n("new_lord_fund_text_14"))
	self.button_invest:addTouchEventListener(handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_gold"
	self.labInvestGold = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_des"
	self.labInvest = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	self.labInvest = SoraDCreateTimerLabel(self, self.labInvest)
	self.labInvest:setTimeEndListener(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Text_gold"
	self.Text_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Sprite_gold"
	self.Sprite_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	self:addDoubleFireEffect()
	if display.height < 1000 then
		self.Center_Node_disk:setScale(display.height / 1136 * 0.9)
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - 15)
		self.Bottom_Node:setPositionY(self.Bottom_Node:getPositionY() - 38)
		newKingFundCtrl = self.Bottom_Node:getPositionY() - 38
		;(self.Bottom_Node:getPositionY() - 38)[1] = "Text_7"
		SoraDGetChildByFullPath(self.Node_info, self.Bottom_Node:getPositionY() - 38):setVisible(false)
	else
		local offsety = (display.height - 1136) / 2
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - offsety)
	end
end)[6] = cc.p(0, 0)
newKingFundView.singleitem_offset, (function(self, ...)
	self.Top_Image_cut = SoraDGetChildByName(self, "Top_Image_cut")
	SoraChangeSpriteImage(self.Top_Image_cut, "bg_activity_king_road.png")
	self.Top_Image_cut:setScale(display.height / self.Top_Image_cut:getContentSize().height)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("new_lord_fund_text_01"))
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_gold")
	newKingFundCtrl = "CCS_commonGoldTop_gold"
	;("CCS_commonGoldTop_gold")[1] = "Text_time"
	self.labReturnTime = SoraDGetChildByFullPath(self.Top_Node, "CCS_commonGoldTop_gold")
	self.labReturnTime = SoraDCreateTimerLabel(self, self.labReturnTime)
	self.labReturnTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).Time = ticket
		return i18n("new_lord_fund_text_02", nil)
	end)
	self.labReturnTime:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(nil)
	end)
	_ENV = i18n("new_lord_fund_text_01")
	i18n("new_lord_fund_text_01").Time = "1d 00:00:00"
	self.labReturnTime:setString(i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	newKingFundCtrl = i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))
	i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(self.Top_Node, i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	self.Button_help:setPositionX(self.labReturnTime:getPositionX() + self.labReturnTime:getContentSize().width / 2 + 30)
	self.Button_help:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		_ENV = "new_lord_fund_text_15"
		;("new_lord_fund_text_15").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("new_lord_fund_text_15"), "new_lord_fund_text_15")
	end)
	self.Center_Node_disk = SoraDGetChildByName(self, "Center_Node_disk")
	newKingFundCtrl = "Center_Node_disk"
	;("Center_Node_disk")[1] = "Node_day_4"
	self.Node_day_4 = SoraDGetChildByFullPath(self.Center_Node_disk, "Center_Node_disk")
	self.Node_day_4:setVisible(false)
	newKingFundCtrl = false
	;(false)[1] = "frame_disk"
	self.frame_disk = SoraDGetChildByFullPath(self.Center_Node_disk, false)
	self.frame_disk:setLocalZOrder(10)
	newKingFundCtrl = 10
	;(10)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.frame_disk, 10)
	self.Text_1:setString(i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_1"
	self.Node_gold_1 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_2"
	self.labGold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_1"
	self.Sprite_gold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_2"
	self.Node_gold_2 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_4"
	self.labGold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_2"
	self.Sprite_gold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Text_6"
	self.labInvestAdd = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Button_rule"
	self.Button_rule = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	self.Button_rule:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "ScrollView_1"
	self.scroll = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Node_info"
	self.Node_info = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.Node_info, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	self.Text_1:setString(i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show"
	self.Node_show = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show_2"
	self.Node_show_2 = SoraDGetChildByFullPath(self.Node_show, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Text_4"
	self.Text_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_11"))
	self.Text_4:setString(i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_5"
	self.labGold_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_7"
	SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_04")):setString(i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "Node_invest"
	self.Node_invest = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "button_invest"
	self.button_invest = SoraDGetChildByFullPath(self.Node_invest, i18n("new_lord_fund_text_14"))
	self.button_invest:addTouchEventListener(handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_gold"
	self.labInvestGold = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_des"
	self.labInvest = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	self.labInvest = SoraDCreateTimerLabel(self, self.labInvest)
	self.labInvest:setTimeEndListener(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Text_gold"
	self.Text_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Sprite_gold"
	self.Sprite_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	self:addDoubleFireEffect()
	if display.height < 1000 then
		self.Center_Node_disk:setScale(display.height / 1136 * 0.9)
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - 15)
		self.Bottom_Node:setPositionY(self.Bottom_Node:getPositionY() - 38)
		newKingFundCtrl = self.Bottom_Node:getPositionY() - 38
		;(self.Bottom_Node:getPositionY() - 38)[1] = "Text_7"
		SoraDGetChildByFullPath(self.Node_info, self.Bottom_Node:getPositionY() - 38):setVisible(false)
	else
		local offsety = (display.height - 1136) / 2
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - offsety)
	end
end)[7] = function(self, ...)
	self.Top_Image_cut = SoraDGetChildByName(self, "Top_Image_cut")
	SoraChangeSpriteImage(self.Top_Image_cut, "bg_activity_king_road.png")
	self.Top_Image_cut:setScale(display.height / self.Top_Image_cut:getContentSize().height)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("new_lord_fund_text_01"))
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_gold")
	newKingFundCtrl = "CCS_commonGoldTop_gold"
	;("CCS_commonGoldTop_gold")[1] = "Text_time"
	self.labReturnTime = SoraDGetChildByFullPath(self.Top_Node, "CCS_commonGoldTop_gold")
	self.labReturnTime = SoraDCreateTimerLabel(self, self.labReturnTime)
	self.labReturnTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).Time = ticket
		return i18n("new_lord_fund_text_02", nil)
	end)
	self.labReturnTime:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(nil)
	end)
	_ENV = i18n("new_lord_fund_text_01")
	i18n("new_lord_fund_text_01").Time = "1d 00:00:00"
	self.labReturnTime:setString(i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	newKingFundCtrl = i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))
	i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01"))[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(self.Top_Node, i18n("new_lord_fund_text_02", i18n("new_lord_fund_text_01")))
	self.Button_help:setPositionX(self.labReturnTime:getPositionX() + self.labReturnTime:getContentSize().width / 2 + 30)
	self.Button_help:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		_ENV = "new_lord_fund_text_15"
		;("new_lord_fund_text_15").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("new_lord_fund_text_15"), "new_lord_fund_text_15")
	end)
	self.Center_Node_disk = SoraDGetChildByName(self, "Center_Node_disk")
	newKingFundCtrl = "Center_Node_disk"
	;("Center_Node_disk")[1] = "Node_day_4"
	self.Node_day_4 = SoraDGetChildByFullPath(self.Center_Node_disk, "Center_Node_disk")
	self.Node_day_4:setVisible(false)
	newKingFundCtrl = false
	;(false)[1] = "frame_disk"
	self.frame_disk = SoraDGetChildByFullPath(self.Center_Node_disk, false)
	self.frame_disk:setLocalZOrder(10)
	newKingFundCtrl = 10
	;(10)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.frame_disk, 10)
	self.Text_1:setString(i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_1"
	self.Node_gold_1 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_2"
	self.labGold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_1"
	self.Sprite_gold_1 = SoraDGetChildByFullPath(self.Node_gold_1, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Node_gold_2"
	self.Node_gold_2 = SoraDGetChildByFullPath(self.frame_disk, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Text_4"
	self.labGold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	newKingFundCtrl = i18n("new_lord_fund_text_03")
	i18n("new_lord_fund_text_03")[1] = "Sprite_gold_2"
	self.Sprite_gold_2 = SoraDGetChildByFullPath(self.Node_gold_2, i18n("new_lord_fund_text_03"))
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Text_6"
	self.labInvestAdd = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	_UPVALUE2_ = "Bottom_Node"
	;("Bottom_Node")[1] = "Panel_bottom_black"
	;("Bottom_Node")[2] = "Button_rule"
	self.Button_rule = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	self.Button_rule:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "ScrollView_1"
	self.scroll = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Node_info"
	self.Node_info = SoraDGetChildByFullPath(self.Bottom_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	function newKingFundCtrl(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.Node_info, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		SoraDCreatePanel("newKingFundRulePopView"):show()
	end)
	self.Text_1:setString(i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show"
	self.Node_show = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Node_show_2"
	self.Node_show_2 = SoraDGetChildByFullPath(self.Node_show, i18n("new_lord_fund_text_11"))
	newKingFundCtrl = i18n("new_lord_fund_text_11")
	i18n("new_lord_fund_text_11")[1] = "Text_4"
	self.Text_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_11"))
	self.Text_4:setString(i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_5"
	self.labGold_4 = SoraDGetChildByFullPath(self.Node_show_2, i18n("new_lord_fund_text_04"))
	newKingFundCtrl = i18n("new_lord_fund_text_04")
	i18n("new_lord_fund_text_04")[1] = "Text_7"
	SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_04")):setString(i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "Node_invest"
	self.Node_invest = SoraDGetChildByFullPath(self.Node_info, i18n("new_lord_fund_text_14"))
	newKingFundCtrl = i18n("new_lord_fund_text_14")
	i18n("new_lord_fund_text_14")[1] = "button_invest"
	self.button_invest = SoraDGetChildByFullPath(self.Node_invest, i18n("new_lord_fund_text_14"))
	self.button_invest:addTouchEventListener(handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_gold"
	self.labInvestGold = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	newKingFundCtrl = handler(self, self.btnInvestCallback)
	handler(self, self.btnInvestCallback)[1] = "Text_des"
	self.labInvest = SoraDGetChildByFullPath(self.Node_invest, handler(self, self.btnInvestCallback))
	self.labInvest = SoraDCreateTimerLabel(self, self.labInvest)
	self.labInvest:setTimeEndListener(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Text_gold"
	self.Text_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	function newKingFundCtrl()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end
	;(function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)[1] = "Sprite_gold"
	self.Sprite_gold = SoraDGetChildByFullPath(self.Node_invest, function()
		if newKingFundCtrl:getReturnLeftTime() > 0 then
			self:initData()
		end
	end)
	self:addDoubleFireEffect()
	if display.height < 1000 then
		self.Center_Node_disk:setScale(display.height / 1136 * 0.9)
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - 15)
		self.Bottom_Node:setPositionY(self.Bottom_Node:getPositionY() - 38)
		newKingFundCtrl = self.Bottom_Node:getPositionY() - 38
		;(self.Bottom_Node:getPositionY() - 38)[1] = "Text_7"
		SoraDGetChildByFullPath(self.Node_info, self.Bottom_Node:getPositionY() - 38):setVisible(false)
	else
		local offsety = (display.height - 1136) / 2
		self.Center_Node_disk:setPositionY(self.Center_Node_disk:getPositionY() - offsety)
	end
end, cc.p(0, 5)
function newKingFundView:createSingleItem(day)
	local node = self.Node_day_4:clone()
	newKingFundView = nil
	;(nil)[1] = "frame_bg"
	node.frame_bg = SoraDGetChildByFullPath(node, nil)
	newKingFundView = nil
	;(nil)[1] = "Node_day"
	node.Node_day = SoraDGetChildByFullPath(node, nil)
	newKingFundCtrl = nil
	;(nil)[1] = "Node_day"
	;(nil)[2] = "Text_1"
	node.Text_1 = SoraDGetChildByFullPath(node, nil)
	node.Text_1:setVisible(false)
	local numChar = cc.Label:createWithCharMap("fonts/font_svip.png", 25, 36, 48)
	numChar:addTo(node.Text_1:getParent())
	numChar:setPosition(node.Text_1:getPosition())
	numChar:setString(day)
	newKingFundCtrl = day
	day[1] = "Node_day"
	day[2] = "Text_2"
	node.Text_2 = SoraDGetChildByFullPath(node, day)
	local angle = (day - 4) * 360 / 7
	node.frame_bg:setRotation(angle)
	angle = angle * 3.1415927 / 2
	local offset = newKingFundView.singleitem_offset[day] or cc.p(0, 0)
	local posx = node.Node_day:getPositionX() + 198 * math.sin(angle) + offset.x
	local posy = node.Node_day:getPositionY() + 198 * (1 - math.cos(angle)) + offset.y
	node.Node_day:setPosition(cc.p(posx, posy))
	node.Text_2:removeFromParent()
	node.Text_2:addTo(self.Center_Node_disk)
	node.Text_2:setLocalZOrder(11)
	local posx = node.Text_2:getPositionX() + node.Node_day:getPositionX() + node:getPositionX()
	local posy = node.Text_2:getPositionY() + node.Node_day:getPositionY() + node:getPositionY()
	node.Text_2:setPosition(cc.p(posx, posy))
	node.day = day
	function node.initData(_curDay)
		local day = node.day
		if newKingFundCtrl:checkHasInvest(day) then
			node.frame_bg:setSpriteFrame("frame_zwjj5.png")
			node.Text_2:setString(string.format([[
DAY
(%s)]], i18n("new_lord_fund_text_05")))
			node.Text_2:setColor(cc.c3b(0, 190, 30))
		elseif _curDay > day then
			node.frame_bg:setSpriteFrame("frame_zwjj3.png")
			node.Text_2:setString(string.format([[
DAY
(%s)]], i18n("new_lord_fund_text_06")))
			node.Text_2:setColor(cc.c3b(190, 40, 40))
		elseif day == _curDay then
			node.frame_bg:setSpriteFrame("frame_zwjj4.png")
			node.Text_2:setString(string.format([[
DAY
(%s)]], i18n("new_lord_fund_text_07")))
			node.Text_2:setColor(cc.c3b(255, 210, 70))
		elseif _curDay < day then
			node.frame_bg:setSpriteFrame("frame_zwjj2.png")
			node.Text_2:setString(string.format([[
DAY
(%s)]], i18n("new_lord_fund_text_08")))
			node.Text_2:setColor(cc.c3b(175, 175, 175))
		end
	end
	return node
end
function newKingFundView:initData(...)
	self.fundData = newKingFundCtrl:getFundData()
	self.curDay = serviceFunctions.differDays(self.fundData.regTime) + 1
	self.investGold = newKingFundRead.getInvestGold(self.curDay)
	self.labGold_1:setString(string.formatnumberthousands(self.fundData.total))
	self.labGold_2:setString(string.formatnumberthousands(math.floor(self.fundData.totalReturn * self.fundData.rate / 1000)))
	local showGold = newKingFundRead.getInvestReturn(self.curDay)
	self.labGold_4:setString(string.formatnumberthousands(showGold))
	for i = 1, 7 do
		local singleItem = self.itemList[i]
		if not singleItem then
			singleItem = self:createSingleItem(i)
			singleItem:addTo(self.Node_day_4:getParent())
			singleItem:setVisible(true)
			self.itemList[i] = singleItem
		end
		singleItem.initData(self.curDay)
	end
	self.labInvestGold:setString(string.formatnumberthousands(self.investGold))
	local rTime = newKingFundCtrl:getReturnLeftTime()
	newKingFundCtrl = string.formatnumberthousands(self.investGold)
	string.formatnumberthousands(self.investGold).Time = SoraDConvertSecondToString(rTime)
	self.labReturnTime:setString(i18n("new_lord_fund_text_02", string.formatnumberthousands(self.investGold)))
	self.labReturnTime:beginTime(rTime)
	local iTime = newKingFundCtrl:getInvestLeftTime()
	self.labInvest:beginTime(iTime)
	self:initScroll()
	SoraDToCenter(self.Node_gold_1, 5)
	SoraDToCenter(self.Node_gold_2, 5)
	SoraDToCenter(self.Node_show_2, 0)
	if newKingFundCtrl:checkHasInvest(self.curDay) then
		self.labInvest:setString(i18n("new_lord_fund_text_05"))
		self.labInvest:setTimeLast(function(ticket)
			return i18n("new_lord_fund_text_05")
		end)
	else
		self.labInvest:setString(string.format("%s(%s)", i18n("new_lord_fund_text_13"), SoraDConvertSecondToString(iTime)))
		self.labInvest:setTimeLast(function(ticket)
			return string.format("%s(%s)", i18n("new_lord_fund_text_13"), ticket)
		end)
	end
	newKingFundCtrl = string.format("%s(%s)", i18n("new_lord_fund_text_13"), SoraDConvertSecondToString(iTime))
	string.format("%s(%s)", i18n("new_lord_fund_text_13"), SoraDConvertSecondToString(iTime)).Day = #self.fundData.joinDays
	newKingFundCtrl = string.format("%s(%s)", i18n("new_lord_fund_text_13"), SoraDConvertSecondToString(iTime))
	string.format("%s(%s)", i18n("new_lord_fund_text_13"), SoraDConvertSecondToString(iTime)).Percent = self.fundData.rate / 10 .. "%"
	self.labInvestAdd:setString(i18n("new_lord_fund_text_09", string.format("%s(%s)", i18n("new_lord_fund_text_13"), SoraDConvertSecondToString(iTime))) .. "  " .. i18n("new_lord_fund_text_10", string.format("%s(%s)", i18n("new_lord_fund_text_13"), SoraDConvertSecondToString(iTime))))
	self.Button_rule:setPositionX(self.labInvestAdd:getPositionX() + self.labInvestAdd:getContentSize().width / 2 + self.Button_rule:getContentSize().width * self.Button_rule:getScaleX() / 2 + 10)
	if self.labInvestAdd:getContentSize().width > 400 then
		newKingFundCtrl = self.Button_rule:getScaleX()
		self.Button_rule:getScaleX().Day = #self.fundData.joinDays
		newKingFundCtrl = string.format("%s(%s)", i18n("new_lord_fund_text_13"), SoraDConvertSecondToString(iTime))
		string.format("%s(%s)", i18n("new_lord_fund_text_13"), SoraDConvertSecondToString(iTime)).Percent = self.fundData.rate / 10 .. "%"
		self.labInvestAdd:setString(i18n("new_lord_fund_text_09", (self.Button_rule:getScaleX())) .. "  \n" .. i18n("new_lord_fund_text_10", string.format("%s(%s)", i18n("new_lord_fund_text_13"), SoraDConvertSecondToString(iTime))))
		self.labInvestAdd:setScale(0.9)
		self.Button_rule:setPositionX(540)
	end
end
function newKingFundView:initScroll(...)
	self.scroll:removeAllChildren()
	local rewards = newKingFundRead.getInvestRewards(self.curDay)
	local rCount = #rewards / 2
	local itemW = 110
	local sSize = self.scroll:getContentSize()
	local scrollW = math.max(sSize.width, itemW * rCount)
	self.scroll:setInnerContainerSize(cc.size(scrollW, sSize.height))
	self.scroll:setBounceEnabled(5 < rCount)
	for i = 1, rCount do
		local singleItem = include("itemSingleView").new()
		singleItem:setPosition(cc.p(itemW * (i - 1), sSize.height))
		singleItem:addTo(self.scroll)
		singleItem:setScale(0.67)
		newKingFundRead, newKingFundRead = cc.p(itemW * (i - 1), sSize.height)
		cc.p(itemW * (i - 1), sSize.height).id = rewards[2 * i - 1]
		;(0.67).itemData, cc.p(itemW * (i - 1), sSize.height).count = cc.p(itemW * (i - 1), sSize.height)
		singleItem:initData(0.67)
		singleItem:setButtonTag(rewards[2 * i - 1])
		singleItem:setItemClickCallback(handler(self, self.showDetail))
	end
end
function newKingFundView:showDetail(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		button:stopAllActions()
		if self.tips then
			self.tips:removeFromParent()
			self.tips = nil
		end
	elseif type == ccui.TouchEventType.began then
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.2)
		;(nil)[2] = cca.callFunc(function()
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(button:getTag())
			local dt = 140
			if not SoraDFIsRA() then
				dt = -140
			end
			self.tips:setPosition(cc.p(320 + dt, 480))
			self.tips:addTo(self, 99)
		end)
		;(nil)[3] = cca.callFunc(function()
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(button:getTag())
			local dt = 140
			if not SoraDFIsRA() then
				dt = -140
			end
			self.tips:setPosition(cc.p(320 + dt, 480))
			self.tips:addTo(self, 99)
		end)
		button:runAction(cca.seq(nil))
	end
end
function newKingFundView:addDoubleFireEffect()
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_flame1_display.plist"
	;(nil).x = 33
	_ENV, (nil).pos, (nil).y = nil, nil, 48
	;(nil).x = 1.5
	_ENV, (nil)[1], (nil).scale, (nil).y = nil, nil, nil, 1.5
	_ENV, (nil).plist = nil, "et_flame2_display.plist"
	;(nil).x = 33
	_ENV, (nil).pos, (nil).y = nil, nil, 78
	;(nil).x = 2.5
	_ENV, (nil)[2], (nil).scale, (nil).y = nil, nil, nil, 2.5
	_ENV, (nil).plist = nil, "et_flame3_display.plist"
	;(nil).x = 33
	;(nil)[3], (nil).pos, (nil).y = nil, nil, 48
	local param
	local parNode1 = SoraDCreateEffectNode(param)
	parNode1:addTo(SoraDGetChildByName(self, "frame_lace_base_1"), -2)
	local parNode2 = SoraDCreateEffectNode(param)
	parNode2:addTo(SoraDGetChildByName(self, "frame_lace_base_2"), -2)
end
function newKingFundView:checkInvestCond(...)
	if newKingFundCtrl:getReturnLeftTime() <= 0 then
		SoraDShowMsgTip(i18n("common_text_1859"))
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
	if newKingFundCtrl:checkHasInvest(self.curDay) then
		SoraDShowMsgTip(i18n("new_lord_fund_notice_01"))
		return
	end
	if not SoraDEnoughGold(self.investGold) then
		return
	end
	if self.clickCurDay and self.clickCurDay ~= self.curDay then
		SoraDShowMsgTip(i18n("notice_0026"))
		return
	end
	return true
end
function newKingFundView:btnInvestCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.clickCurDay = self.curDay
		if not self:checkInvestCond() then
			return
		end
		_ENV = nil
		;(nil).Gold = self.investGold
		SoraDShowMsgBox(i18n("new_lord_fund_notice_02", nil), i18n("common_text_204"), nil, function(type)
			if type ~= MSGBOX_CALLBACK_YES then
				return
			end
			if not self:checkInvestCond() then
				return
			end
			newKingFundCtrl:sendReqInvest()
		end)
	end
end
function newKingFundView:judgeEventClose(target, redata)
	if not newKingFundCtrl:isShowFundPage() then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function newKingFundView:showRewards(...)
	SoraDCloseLoading()
	local reward = newKingFundRead.getInvestRewards(self.curDay)
	local _ENV, itemData = self.curDay, self.curDay
	local itemCount = math.floor(#reward / 2)
	for i = 1, itemCount do
		_ENV = nil
		;(nil).id = reward[i * 2 - 1]
		;(nil).count = reward[i * 2]
		table.insert(itemData, nil)
	end
	SoraDMailGainItems(itemData, true)
end
return newKingFundView
