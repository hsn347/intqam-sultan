local mailCtrl = SoraDGetCtrl("mailCtrl")
local chatroomCtrl = SoraDGetCtrl("chatroomCtrl")
local contactCtrl = SoraDGetCtrl("contactCtrl")
local worldMapDefine = include("worldMapDefine")
local chatCtrl = SoraDGetCtrl("chatCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local worldMapWarDef = include("worldMapWarDef")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local mailSharePopViewPanel = class("mailSharePopViewPanel", baseFguiPanel)
function mailSharePopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("mailSharePopViewPanel:ctor", self.viewName)
end
function mailSharePopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function mailSharePopViewPanel:onInit()
	print("=======mailSharePopViewPanel:onInit")
	self.totalData, _ENV, self.gold = constantRead.getConstValue("SHARE_MAIL_CONSUME"), constantRead.getConstValue("SHARE_MAIL_CONSUME"), constantRead.getConstValue("SHARE_MAIL_CONSUME")
	self.confirmTag = 0
	self.fields.Panel_bg:setString(i18n("common_text_533"))
	self.fields.Lab_title:setString(i18n("share_text_01"))
	self.fields.Button_share:setString(i18n("common_text_533"))
	self.fields.Button_share:addClickListener(handler(self, self.btnShareClick))
	self.fields.Button_free:setString(i18n("common_text_533"))
	self.fields.Button_free:addClickListener(handler(self, self.btnShareClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.List:addClickListener(handler(self, self.onItemClick))
end
function mailSharePopViewPanel:onItemRender(index, target)
	target:initData(self.totalData[index + 1], self.kingdomID)
end
function mailSharePopViewPanel:onItemClick()
	SoraDPlaySound()
	local selectIndex = self.fields.List:getSelectedIndex() + 1
	local isSelect = self.fields.List:getChildAt(selectIndex - 1):isTickSelect()
	self.confirmTag = isSelect and selectIndex or 0
	self:updateChooseChannel(self.confirmTag)
	self:updateBtn()
end
function mailSharePopViewPanel:onShow()
	print("=======mailSharePopViewPanel:onShow")
	self.mailID = self.param.mailID
	self.kingdomID = self.param.kingdomID
	self.channelList = self.param.channelList
	self:initData()
	self:updateBtn()
end
function mailSharePopViewPanel:initData()
	if self.kingdomID and self.channelList then
		local _ENV, totalData = self.channelList, self.channelList
		for i, v in ipairs(self.channelList) do
			_ENV = nil
			;(nil).channel = v
			table.insert(totalData, nil)
		end
		self.totalData = totalData
	else
		self:sortData()
	end
	self:initScroll()
end
function mailSharePopViewPanel:sortData()
	local _ENV, dataKindom
	dataKindom.channel = gChatChannel.KINGDOM
	table.insert(self.totalData, dataKindom)
	if allianceMgr:hasJoinAlliance() then
		local _ENV, dataAlliance = allianceMgr:hasJoinAlliance(), allianceMgr:hasJoinAlliance()
		dataAlliance.channel = gChatChannel.ALLIANCE
		table.insert(self.totalData, dataAlliance)
	end
	local coverList = gChatMgrs:getMgr("chatCoverMgr"):getChatCoverList(1, 5)
	if coverList and next(coverList) then
		for _, v in ipairs(coverList) do
			table.insert(self.totalData, v)
		end
	end
end
function mailSharePopViewPanel:initScroll()
	self.fields.List:setNumItems(#self.totalData)
	if allianceMgr:hasJoinAlliance() then
		self:updateChooseChannel(2)
	else
		self:updateChooseChannel(1)
	end
end
function mailSharePopViewPanel:updateChooseChannel(index)
	self.confirmTag = index
	for i = 1, self.fields.List:getNumItems() do
		local single = self.fields.List:getChildAt(i - 1)
		single:setSelected(index == i)
	end
	if self.confirmTag ~= 0 then
		self.channel = self.totalData[self.confirmTag].channel or self.totalData[self.confirmTag].chatChannel
	end
	self:updateBtn()
end
function mailSharePopViewPanel:updateBtn()
	if self.channel == gChatChannel.KINGDOM then
		self.fields.Button_share:setVisible(true)
		self.fields.Button_free:setVisible(false)
		self.fields.Button_share:setCost(gIDDef.GOLD, self.gold)
		self.fields.Button_share:setEnabled(self.confirmTag ~= 0)
	else
		self.fields.Button_share:setVisible(false)
		self.fields.Button_free:setVisible(true)
		self.fields.Button_free:setEnabled(self.confirmTag ~= 0)
	end
end
function mailSharePopViewPanel:onMsgShareBack(target, data)
	if data.success then
		self:close()
	end
end
function mailSharePopViewPanel:btnShareClick()
	SoraDPlaySound()
	if self.channel == nil then
		return
	end
	local isCanChat = chatCtrl:canChat()
	if not isCanChat then
		SoraDShowMsgTip(i18n("commom_text_4306"))
		return
	end
	local kingdomSettingAPI = include("kingdomSettingAPI")
	local canChat, lv = kingdomSettingAPI:canChatInWorld()
	if not canChat and self.channel == gChatChannel.KINGDOM then
		_ENV = i18n("commom_text_4306")
		i18n("commom_text_4306").lv = lv
		SoraDShowMsgTip(i18n("common_text_3669", i18n("commom_text_4306")))
		return
	end
	local canChatInAlliance, lvAlliance = kingdomSettingAPI:canChatInAlliance()
	if not canChatInAlliance and self.channel == gChatChannel.ALLIANCE then
		_ENV = i18n("common_text_3669", i18n("commom_text_4306"))
		i18n("common_text_3669", i18n("commom_text_4306")).lv = lvAlliance
		SoraDShowMsgTip(i18n("common_text_3667", i18n("common_text_3669", i18n("commom_text_4306"))))
		return
	end
	if self.channel == gChatChannel.ALLIANCE and not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("notice_0066"))
		return
	end
	if self.channel == gChatChannel.KINGDOM and not SoraDEnoughGold(self.gold) then
		return
	end
	local isNotInCD = mailCtrl:checkShareMail(self.mailID, self.channel)
	if isNotInCD then
		local crid, receiver
		if self.channel == gChatChannel.MAIL then
			receiver = self.totalData[self.confirmTag].target
		elseif self.channel == gChatChannel.CHATROOM then
			crid = self.totalData[self.confirmTag].target
		end
		mailCtrl:shareMail(self.mailID, self.channel, receiver, crid)
	end
end
return mailSharePopViewPanel
