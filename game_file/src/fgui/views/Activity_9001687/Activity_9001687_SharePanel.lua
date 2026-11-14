local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local Activity_9001687_SharePanel = class("Activity_9001687_SharePanel", baseFguiPanel)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
function Activity_9001687_SharePanel:ctor(...)
	self.isLRU = true
	Activity_9001687_SharePanel.super.ctor(self, ...)
	print("Activity_9001687_SharePanel:ctor", self.viewName)
end
function Activity_9001687_SharePanel:onInit()
	print("=======Activity_9001687_SharePanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_533"))
	self.fields.txt_tips:setString(i18n("Frosty_Carnival_text_04"))
	self.fields.Button_normal:setString(i18n("common_text_204"))
	self.fields.Button_normal:addClickListener(handler(self, self.btnShareBack))
	self.fields.btn_help:addClickListener(handler(self, self.onTipsClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onItemClick))
end
function Activity_9001687_SharePanel:onTipsClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Frosty_Carnival_text_05")
	uiManager:show("RuleView", nil)
end
function Activity_9001687_SharePanel:onItemRender(index, obj)
	obj:initData(self.totalData[index + 1])
end
function Activity_9001687_SharePanel:onItemClick()
	SoraDPlaySound()
	local selectIndex = self.fields.List:getSelectedIndex() + 1
	local isSelect = self.fields.List:getChildAt(selectIndex - 1):isTickSelect()
	self.confirmTag = isSelect and selectIndex or 0
	print("selectIndex,isSelect,self.confirmTag====", selectIndex, isSelect, self.confirmTag)
	self.fields.Button_normal:setEnabled(self.confirmTag ~= 0)
end
function Activity_9001687_SharePanel:endShow()
	print("=======Activity_9001687_SharePanel:endShow")
	self.totalData, _ENV, self.goodId = self.param.goodId, self.param.goodId, self.param.goodId
	self.confirmTag = 0
	self.fields.Button_normal:setEnabled(false)
	_ENV = false
	;(false).channel = gChatChannel.KINGDOM
	table.insert(self.totalData, false)
	if allianceMgr:hasJoinAlliance() then
		_ENV = false
		;(false).channel = gChatChannel.ALLIANCE
		table.insert(self.totalData, false)
	end
	self.fields.List:SelectNone()
	self.fields.List:setNumItems(#self.totalData)
	if allianceMgr:hasJoinAlliance() then
		self.fields.List:setSelectedIndex(1)
	else
		self.fields.List:setSelectedIndex(0)
	end
	self.fields.Check_tick:setSelected(false)
	self:onItemClick()
	self.fields.List:jumpToTop()
end
function Activity_9001687_SharePanel:btnShareBack()
	SoraDPlaySound()
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("common_text_4479"))
		return
	end
	local selectData = self.totalData[self.confirmTag]
	local chatChannel = gChatChannel.KINGDOM
	if selectData.channel == gChatChannel.KINGDOM then
		chatChannel = gChatChannel.KINGDOM
	elseif selectData.channel == gChatChannel.ALLIANCE then
		chatChannel = gChatChannel.ALLIANCE
	end
	local chatRedPacketMgr = gChatMgrs:getMgr("chatRedPacketMgr")
	chatRedPacketMgr:setSendRPChannel(chatChannel)
	local rpChatType = gChatChannel2RPChatType[chatChannel]
	local redEnvelopesType = gRedEnvelopesType.ICE_RED_PACKET
	local isShareKingdom = not self.fields.Check_tick:isSelected()
	_ENV = i18n("common_text_4479")
	i18n("common_text_4479").chatType = rpChatType
	i18n("common_text_4479").isShareKingdom = isShareKingdom
	backpackCtrl:reqUseItem(self.goodId, 1, i18n("common_text_4479"))
	_UPVALUE3_ = backpackCtrl
	_ENV = i18n("common_text_4479")
	i18n("common_text_4479").chatType = rpChatType
	i18n("common_text_4479").isShareKingdom = isShareKingdom
	backpackCtrl[1] = self.goodId
	backpackCtrl[2] = 1
	backpackCtrl[3] = i18n("common_text_4479")
	dump(backpackCtrl, "Activity_9001687_SharePanel:btnShareBack")
	self:close()
end
return Activity_9001687_SharePanel
