local gametop = gModuleMgr.getObject("gametop")
local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
local allianceDesRead = include("allianceDesRead")
local chatRoomPlayerSearch = class("chatRoomPlayerSearch", function(target)
	if target == nil then
		return SoraDCreateBasePanel("chatRoomPlayerSearch")
	end
	return target
end)
_ENV, _UPVALUE2_ = function(target)
	if target == nil then
		return SoraDCreateBasePanel("chatRoomPlayerSearch")
	end
	return target
end, "chatRoomPlayerSearch"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("chatRoomPlayerSearch")
	end
	return target
end).name = "common_text_3155"
_ENV, (function(target)
	if target == nil then
		return SoraDCreateBasePanel("chatRoomPlayerSearch")
	end
	return target
end).eventType = nil, 1
;(nil).name = "UID"
;(nil).eventType = 2
;("chatRoomPlayerSearch")[1] = function(target)
	if target == nil then
		return SoraDCreateBasePanel("chatRoomPlayerSearch")
	end
	return target
end
local ("chatRoomPlayerSearch")[2], sortTypeList = nil, "chatRoomPlayerSearch"
function chatRoomPlayerSearch:ctor()
	self.curSortType = 1
	self.uidSwitcher = false
	self.Node_search = SoraDGetChildByName(self, "Node_search")
	self.Button_search = SoraDGetChildByName(self.Node_search, "Button_search")
	self.Button_search:setTitleText(i18n("chat_text_88"))
	self.Button_search:addTouchEventListener(handler(self, self.onClickBtnSearch))
	self.Button_clear = SoraDGetChildByName(self.Node_search, "Button_clear")
	self.Button_clear:addTouchEventListener(handler(self, self.onClickBtnClear))
	self.Button_clear:setVisible(false)
	self.tfdName = SoraDGetChildByName(self.Node_search, "TextField_name")
	self.tfdName:setTextHorizontalAlignment(SoraDFLabelR())
	self.tfdName:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.tfdName:setTextColor(cc.c4b(0, 0, 0, 255))
	_ENV = cc.c4b(0, 0, 0, 255)
	cc.c4b(0, 0, 0, 255).func = handler(self, self.editBoxTextEvent)
	self.tfdName = SoraDChangeToEditBox(self.tfdName, cc.c4b(0, 0, 0, 255))
	self.Image_border = SoraDGetChildByName(self.Node_search, "Image_border")
	self.Button_new = SoraDGetChildByName(self.Node_search, "Button_new")
	self.Button_new:addTouchEventListener(handler(self, self.onUidSearchClick))
	self.Button_new:setTitleText(i18n("common_text_3155"))
	self.Button_name = SoraDGetChildByName(self.Node_search, "Button_name")
	self.Button_name:setTitleText(i18n("common_text_3155"))
	self.Button_name:addTouchEventListener(handler(self, self.onNameClick))
	self.Button_uid = SoraDGetChildByName(self.Node_search, "Button_uid")
	self.Button_uid:setTitleText(i18n("UID"))
	self.Button_uid:addTouchEventListener(handler(self, self.onUIDClick))
	self:setUidSwitcher()
end
function chatRoomPlayerSearch:onUidSearchClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.uidSwitcher = not self.uidSwitcher
		self:setUidSwitcher()
	end
end
function chatRoomPlayerSearch:onNameClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("按名字排序")
		self.uidSwitcher = false
		self.curSortType = 1
		self:setUidSwitcher()
	end
end
function chatRoomPlayerSearch:onUIDClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("按uid排序")
		self.uidSwitcher = false
		self.curSortType = 2
		self:setUidSwitcher()
	end
end
function chatRoomPlayerSearch:setUidSwitcher()
	self.Button_new:setTitleText(i18n(sortTypeList[self.curSortType].name))
	self.Button_name:setVisible(self.uidSwitcher)
	self.Button_uid:setVisible(self.uidSwitcher)
	self.Image_border:setScaleX(0.9)
	self.Image_border:setContentSize(cc.size(140, self.uidSwitcher and 150 or 60))
end
function chatRoomPlayerSearch:onClickBtnSearch(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local kid = gametop.playertop_:getMapID()
		local name = self.tfdName:getText()
		local pid = self.tfdName:getText()
		if name == "" then
			SoraDShowMsgTip(i18n("friend_text_20"))
			return
		end
		if string.utf8len(name) < 3 then
			SoraDShowMsgTip(i18n("friend_text_12"))
			return
		end
		if self.curSortType == 1 then
			pid = nil
		else
			name = nil
		end
		local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
		gametop = i18n("friend_text_12")
		i18n("friend_text_12")[1] = kid
		lordInfoCtrl:searchLordInThisKingdomsReq(name, i18n("friend_text_12"))
	end
end
function chatRoomPlayerSearch:onClickBtnClear(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:resetInput()
	end
end
function chatRoomPlayerSearch:editBoxTextEvent(strEventName, pSender)
	local edit = pSender
	print("==chatRoomPlayerSearch:editBoxTextEvent==", strEventName, edit:getString())
	if strEventName == "began" then
	elseif strEventName == "ended" then
	elseif strEventName == "return" then
	elseif strEventName == "changed" then
		local editStr = edit:getString()
		if editStr and string.len(editStr) > 0 then
			self.Button_clear:setVisible(true)
		else
			self.Button_clear:setVisible(false)
		end
	end
end
function chatRoomPlayerSearch:resetInput(...)
	self.Button_clear:setVisible(false)
	self.tfdName:setString("")
end
return chatRoomPlayerSearch
