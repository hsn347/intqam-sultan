local activity_9001702_Ctrl = SoraDGetCtrl("activity_9001702_Ctrl")
local activity_9001702_Read = include("activity_9001702_Read")
local dailyRemindManager = include("dailyRemindManager")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_sendSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001702/Com_sendSingle", Com_sendSingle)
function Com_sendSingle:onInit()
	self.giftItemID = activity_9001702_Read.getGiftItemID()
	self.remindType = dailyRemindManager.REMIND_TYPE.activity_9001702_2
	self.fields.Button_send:addClickEventListener(handler(self, self.onClickSend))
	self:updateBtnSend()
	activity_9001702_Read = handler(self, self.onClickSend)
	handler(self, self.onClickSend).num = 5
	self.fields.Button_send2:setString(i18n("Eidal_celebration_text_12", handler(self, self.onClickSend)))
	self.fields.Button_send2:addClickEventListener(handler(self, self.onClickSend2))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.arrow_send2:fix()
	end
end
function Com_sendSingle:onShow()
end
function Com_sendSingle:onClickSend()
	SoraDPlaySound()
	if activity_9001702_Ctrl:checkItemCount(self.giftItemID, 1) then
		local isCheck = false
		if dailyRemindManager.checkNeedRemind(self.remindType) then
			isCheck = true
		end
		activity_9001702_Ctrl:reqSend(self.uid, 1, isCheck)
		SoraDShowLoading()
	end
end
function Com_sendSingle:onClickSend2()
	SoraDPlaySound()
	if activity_9001702_Ctrl:checkItemCount(self.giftItemID, 5) then
		local isCheck = false
		if dailyRemindManager.checkNeedRemind(self.remindType) then
			isCheck = true
		end
		activity_9001702_Ctrl:reqSend(self.uid, 5, isCheck)
		SoraDShowLoading()
	end
end
function Com_sendSingle:updateBtnSend()
	if self.isBySend then
		self.fields.Button_send:setString(i18n("commom_text_4303"))
	else
		_ENV = i18n("commom_text_4303")
		i18n("commom_text_4303").num = 1
		self.fields.Button_send:setString(i18n("Eidal_celebration_text_12", i18n("commom_text_4303")))
	end
	local itemCount = backpackCtrl:getItemCount(self.giftItemID)
	if itemCount < 1 then
		self.fields.Button_send:setTitleColor(cc.c3b(255, 0, 0))
	else
		self.fields.Button_send:setTitleColor(cc.c3b(255, 255, 255))
	end
	if itemCount < 5 then
		self.fields.Button_send2:setTitleColor(cc.c3b(255, 0, 0))
	else
		self.fields.Button_send2:setTitleColor(cc.c3b(255, 255, 255))
	end
end
function Com_sendSingle:initData(data, isBySend)
	self.uid = data.uid
	self.isBySend = isBySend
	self.fields.Com_head:setHeadSprite(data.iconID or data.headid, data.avatar or "")
	self.fields.Text_player:setString(data.nickName or data.playerName)
	local allianceName = data.allianceName or i18n("pyramid_text_02")
	_ENV = data.avatar or ""
	;(data.avatar or "").conten = allianceName
	local allianceStr = i18n("common_text_925", data.avatar or "")
	self.fields.Text_alliance:setString(allianceStr)
	self:updateBtnSend()
end
function Com_sendSingle:setLastSendUid(uid)
	self.lastSendUid = uid
	if self.uid == self.lastSendUid then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
return Com_sendSingle
