local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonBuyBoxPanel = class("CommonBuyBoxPanel", baseFguiPanel)
function CommonBuyBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CommonBuyBoxPanel:ctor", self.viewName)
	self.callBackHandle = nil
	self.isNeedJudge = true
end
function CommonBuyBoxPanel:onInit()
	print("=======CommonBuyBoxPanel:onInit")
	self.fields.CheckBox:addClickListener(handler(self, self.btnCheckClickCallBack))
	self.fields.Button_yes:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Button_no:setString(i18n("common_text_185"))
	self.fields.Button_no:addClickListener(handler(self, self.onClickClose))
	self.fields.Button_buy:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Button_tool:addClickListener(handler(self, self.btnToolCallBack))
	self.view:fixChildrenPos()
end
function CommonBuyBoxPanel:onShow()
	print("=======CommonBuyBoxPanel:onShow")
	local param = self.param
	self:setHandle(param.handle)
	self:initData(param)
	local canBuy = param.canBuy
	if canBuy ~= nil then
		self:setBtnBuy(canBuy)
	end
	local handleTool = param.handleTool
	if handleTool then
		self:setUseToolStyle(handleTool, param.tool)
	end
	self:updatePanelSize()
end
function CommonBuyBoxPanel:setBtnBuy(isCanBuy)
	self.fields.Button_buy:setEnabled(isCanBuy)
end
function CommonBuyBoxPanel:setUseToolStyle(handler, btnLang)
	self.fields.Button_no:setVisible(false)
	self.fields.Button_tool:setVisible(true)
	self.fields.Button_tool:setString(btnLang or i18n("common_text_3527"))
	self.fields.Com_time:setPositionX(self.fields.Button_tool:getPositionX())
	self.useToolHandler = handler
end
function CommonBuyBoxPanel:btnToolCallBack(button, event)
	SoraDPlaySound()
	if self.useToolHandler then
		self.useToolHandler(MSGBOX_CALLBACK_YES)
		self:closePanel()
	end
end
function CommonBuyBoxPanel:initData(showData)
	self.tableShowData = showData
	local msgStr = self.tableShowData.msg
	local msgParams = self.tableShowData.msgParams
	if msgParams then
		local _ENV, styles
		for key, __ in pairs(msgParams) do
			_ENV = nil
			styles[key], (nil).color = nil, "#70C723"
		end
		msgStr = i18n_html(self.tableShowData.msgKey, msgParams, styles)
	end
	self.fields.Text_msg:setString(msgStr)
	self.fields.Button_buy:setCostTitle(string.formatnumberthousands(self.tableShowData.gold))
	self:updateGold()
	if self.tableShowData.title then
		self.fields.Button_buy:setString(self.tableShowData.title)
	else
		self.fields.Button_buy:setString(i18n("common_text_054"))
	end
	if self.tableShowData.costTime then
		self.fields.Com_time:setVisible(true)
		self.fields.Com_time:setString(SoraDConvertSecondToString(self.tableShowData.costTime))
	end
	local parameter = self.tableShowData.parameter
	if parameter then
		if parameter.isNeedJudge ~= nil then
			self.isNeedJudge = parameter.isNeedJudge
		end
		local itemID = parameter.itemID
		if itemID and self.fields.Button_buy:initData(itemID, self.tableShowData.gold) then
			self.isNeedJudge = false
		end
		if parameter.icon then
			self.fields.Button_buy:setCostIcon(parameter.icon)
		end
		if parameter.width then
		end
		if parameter.isEnough then
			self.fields.Button_buy:setGoldColor(cc.c3b(255, 255, 0))
		end
	end
	if self.tableShowData.checkTip then
		self.fields.text_check_tip:setString(self.tableShowData.checkTip)
		self.fields.text_check_tip:setVisible(true)
		self.fields.CheckBox:setVisible(true)
		self.isCheck = self.tableShowData.isCheck
		if self.tableShowData.isCheck then
			self.fields.CheckBox:setSelected(true)
		else
			self.fields.CheckBox:setSelected(false)
		end
		self.isCheck = self.fields.CheckBox:isSelected()
		if self.tableShowData.isInmediaGold then
			IS_SELECT_LOGIN_NOTICE = self.isCheck
		end
		if self.isCheck then
			IS_BLOCK_USERS_CHAT = false
		else
			IS_BLOCK_USERS_CHAT = true
		end
	end
	if self.tableShowData.htmlParam then
		_ENV = cc.c3b(255, 255, 0)
		cc.c3b(255, 255, 0).var1 = self.tableShowData.htmlParam.curItemNum
		cc.c3b(255, 255, 0).var2 = self.tableShowData.htmlParam.curItemName
		cc.c3b(255, 255, 0).var3 = self.tableShowData.htmlParam.exchangeNum
		_ENV, _ENV, cc.c3b(255, 255, 0).var4 = cc.c3b(255, 255, 0)
		_ENV, self.tableShowData.htmlParam.toItemName.var1, cc.c3b(255, 255, 0).color = cc.c3b(255, 255, 0)
		_ENV, self.tableShowData.htmlParam.toItemName.var3, cc.c3b(255, 255, 0).color = cc.c3b(255, 255, 0)
		self.tableShowData.htmlParam.toItemName.__default, cc.c3b(255, 255, 0).color = cc.c3b(255, 255, 0)
		self.fields.Text_msg:setString(i18n_html("equipment_tips_02", cc.c3b(255, 255, 0)))
	end
end
function CommonBuyBoxPanel:updateGold(...)
	if self.tableShowData and self.tableShowData.parameter and not self.tableShowData.parameter.isNeedJudge then
		return
	end
	if self.tableShowData and not self.tableShowData.gold then
		self.fields.Button_buy:setVisible(false)
		self.fields.Button_yes:setVisible(true)
		self.fields.Button_yes:setString(i18n("common_text_204"))
		self.isNeedJudge = false
		return
	end
	if SoraDGetGold() < self.tableShowData.gold then
		self.fields.Button_buy:setGoldColor(display.COLOR_RED)
	else
		self.fields.Button_buy:setGoldColor(cc.c3b(255, 255, 0))
	end
end
function CommonBuyBoxPanel:setHandle(handle)
	self.callBackHandle = handle
end
function CommonBuyBoxPanel:btnClickCallBack()
	SoraDPlaySound()
	if self.isNeedJudge then
		if SoraDEnoughGold(self.tableShowData.gold) then
			_ENV = nil
			;(nil).isCheck = self.isCheck
			self:exitView(MSGBOX_CALLBACK_YES, nil)
		else
			_ENV = nil
			;(nil).isCheck = self.isCheck
			self:exitView(MSGBOX_CALLBACK_CANCEL, nil)
		end
	else
		_ENV = nil
		;(nil).isCheck = self.isCheck
		self:exitView(MSGBOX_CALLBACK_YES, nil)
	end
	self:closePanel()
end
function CommonBuyBoxPanel:btnCheckClickCallBack()
	self.isCheck = self.fields.CheckBox:isSelected()
	if self.tableShowData.isInmediaGold then
		IS_SELECT_LOGIN_NOTICE = self.isCheck
	end
	if self.tableShowData.panelName == "equipBaptizeView" or self.tableShowData.panelName == "equipSetsMaterialsView2" then
		IS_LEVEL_4_WASH_FACE_USED_CONFIRM = self.isCheck
	elseif self.tableShowData.panelName == "equipBaptizeView2" then
		IS_TEN_WASH_FACE_USED_CONFIRM = self.isCheck
	elseif self.tableShowData.panelName == "equipSetsMaterialsView" then
		IS_COMPOUND_ORANGE_MATERIALS = self.isCheck
	elseif self.tableShowData.panelName == "chatMsgMgr" then
		if self.isCheck then
			IS_BLOCK_USERS_CHAT = false
		else
			IS_BLOCK_USERS_CHAT = true
		end
	elseif self.tableShowData.panelName == "spiritualGiftView" then
	end
end
function CommonBuyBoxPanel:onHide(...)
	self:exitView(MSGBOX_CALLBACK_CANCEL)
end
function CommonBuyBoxPanel:exitView(exitType, other)
	if self.callBackHandle then
		print("lkdjflksdjflksdjf", self.isCheck)
		self.callBackHandle(exitType, other)
	end
end
function CommonBuyBoxPanel:updatePanelSize(...)
	local msgH = self.fields.Text_msg:getContentSize().height
	if msgH < 110 then
		self.fields.Text_msg:setAutoSize(fgui.AutoSizeType.SHRINK)
		self.fields.Text_msg:setSize(cc.size(550, 110))
	end
	if not self.tableShowData.costTime then
		local bgH = self.fields.Panel_bg:getContentSize().height
		self.fields.Panel_bg:setHeight(bgH - 15)
	end
	if not self.tableShowData.checkTip then
		local bgH = self.fields.Panel_bg:getContentSize().height
		self.fields.Panel_bg:setHeight(bgH - 40)
	end
end
return CommonBuyBoxPanel
