local itemDesRead = include("itemDesRead")
local collectSalaryCtrl = SoraDGetCtrl("collectSalaryCtrl")
local treasureMapRequireHelp = class("treasureMapRequireHelp", function(target)
	return target or SoraDCreateTouchPanel("treasureMapRequireHelp")
end)
local MAX_REQUST = 10
function treasureMapRequireHelp:ctor()
	self.boxBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.boxBg:setTitleName(i18n("treasuremap_text_11"))
	self.textItemInfo = SoraDGetChildByName(self, "Text_Info")
	self.textItemInfo = SoraDChangeTextToHtml(self.textItemInfo)
	self.textAlGet = SoraDGetChildByName(self, "Text_AlreadyGet")
	self.btnGetReard = SoraDGetChildByName(self, "Button_Sure")
	self.btnGetReard:setTitleText(i18n("common_text_204"))
	self.btnGetReard:addTouchEventListener(handler(self, self.btnClickRequestHelp))
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
end
function treasureMapRequireHelp:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_COLLECT_RANK_MESSAGE", handler(self, self.updateNum))
end
function treasureMapRequireHelp:updateNum(target, data)
	if data.subMsg == "notify" then
		self:setTextStatus()
	end
end
function treasureMapRequireHelp:initData(mapInfo, fragmentID)
	self.fragmentID = fragmentID
	_ENV = nil
	;(nil).name1 = i18n(mapInfo.name)
	_ENV, _ENV, (nil).name2 = fragmentID, itemDesRead.getName(fragmentID), itemDesRead.getName(fragmentID)
	_ENV, itemDesRead.getName(fragmentID).name1, fragmentID.color = fragmentID, fragmentID, itemDesRead.getColor(mapInfo.treasureMapID)
	_ENV, itemDesRead.getName(fragmentID).name2, fragmentID.color = fragmentID, fragmentID, itemDesRead.getColor(fragmentID)
	itemDesRead.getName(fragmentID)._default, fragmentID.color = fragmentID, "#ffffff"
	local str = i18n_html("treasuremap_text_01", nil, (itemDesRead.getName(fragmentID)))
	self.textItemInfo:setString(str)
	self:setTextStatus()
end
function treasureMapRequireHelp:setTextStatus()
	local receiveNum = collectSalaryCtrl:getAlreadyRequestNums()
	if receiveNum >= MAX_REQUST then
		self.btnGetReard:setBright(false)
		self.btnGetReard:setTouchEnabled(false)
		self.textAlGet:setColor(cc.c3b(206, 0, 0))
	else
		self.btnGetReard:setBright(true)
		self.btnGetReard:setTouchEnabled(true)
		self.textAlGet:setColor(cc.c3b(215, 195, 155))
	end
	collectSalaryCtrl = cc.c3b(215, 195, 155)
	cc.c3b(215, 195, 155).num1 = receiveNum
	cc.c3b(215, 195, 155).num2 = 10
	self.textAlGet:setString(i18n("treasuremap_text_12", cc.c3b(215, 195, 155)))
end
_ENV, treasureMapRequireHelp.btnClickRequestHelp = function(self, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).fragmentID = self.fragmentID
		collectSalaryCtrl:reqGetRequestData(nil)
		self:close(self, type)
	end
end, function(self, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).fragmentID = self.fragmentID
		collectSalaryCtrl:reqGetRequestData(nil)
		self:close(self, type)
	end
end
;(function(self, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).fragmentID = self.fragmentID
		collectSalaryCtrl:reqGetRequestData(nil)
		self:close(self, type)
	end
end).chatSysMsgType = chatSysMsgType
;(function(self, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).fragmentID = self.fragmentID
		collectSalaryCtrl:reqGetRequestData(nil)
		self:close(self, type)
	end
end).textType = gChatTextType.text_custom
_ENV, (function(self, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).fragmentID = self.fragmentID
		collectSalaryCtrl:reqGetRequestData(nil)
		self:close(self, type)
	end
end).text = gChatTextType.text_custom, ""
gChatTextType.text_custom.reqUid = uid
gChatTextType.text_custom.fragmentID = fragmentID
gChatTextType.text_custom.indexID = indexID
;(function(self, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).fragmentID = self.fragmentID
		collectSalaryCtrl:reqGetRequestData(nil)
		self:close(self, type)
	end
end).values, gChatTextType.text_custom.mapID = gChatTextType.text_custom, mapID
local function content(self, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).fragmentID = self.fragmentID
		collectSalaryCtrl:reqGetRequestData(nil)
		self:close(self, type)
	end
end
return treasureMapRequireHelp
