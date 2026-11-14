local baseComponent = require("fgui.base.baseComponent")
local Com_armySingle_9001573 = fgui.extension_class(fgui.GComponent, baseComponent)
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
fgui.register_extension("ui://Activity_9001573/Com_armySingle_9001573", Com_armySingle_9001573)
function Com_armySingle_9001573:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(true)
	end
	self.fields.Com_touch:addEventListener(fgui.UIEventType.Click, handler(self, self.onPanelClick))
	self.fields.btn_lord:addClickEventListener(handler(self, self.onClickLord))
end
function Com_armySingle_9001573:onShow()
end
function Com_armySingle_9001573:initData(data, index, isOpen)
	self.index = index
	self.data = data
	dump(data.armyList, "Com_armySingle_9001573:initData")
	self.isSelfTeam = self.data.uid == lordInfoCtrl:getLordInfo().base.uid
	self.fields.Text_name:setString(textParser.formatPlayerName(data.abbr, data.nickName))
	local amryCount = 0
	if not data.armyList then
		_ENV = data.armyList
	end
	for i, v in ipairs(data.armyList) do
		amryCount = amryCount + v.num
	end
	_ENV = textParser.formatPlayerName(data.abbr, data.nickName)
	textParser.formatPlayerName(data.abbr, data.nickName).count = string.formatnumberthousands(amryCount)
	self.fields.Text_armyCount:setString(i18n("common_text_556", textParser.formatPlayerName(data.abbr, data.nickName)))
	self.fields.Com_head:setHeadSprite(data.imageId, data.avatar)
	self:setState(isOpen)
end
function Com_armySingle_9001573:setClickCallback(callback)
	self.clickCallback = callback
end
function Com_armySingle_9001573:onPanelClick()
	SoraDPlaySound()
	if self.clickCallback then
		self.clickCallback(self.index, self.data.uid)
	end
end
function Com_armySingle_9001573:setReqBackHandler(callback)
	self.callbackEvent = callback
end
function Com_armySingle_9001573:setState(state)
	if not state then
		self:removeArmy()
		self.fields.Image_arrow:setRotation(SoraDFPosX(90, 0))
	else
		self:initArmy()
		self.fields.Image_arrow:setRotation(0)
	end
end
function Com_armySingle_9001573:initArmy()
	dump(self.data, "Com_armySingle_9001573:initArmy")
	self.fields.Panel_member:setVisible(true)
	self.fields.Panel_member:initMemberData(self.data)
	self.fields.Panel_member:setBottomHeight(100)
	self.fields.btn_lord:setVisible(true)
	if self.isSelfTeam then
		self.fields.btn_lord:setTitle(i18n("common_text_017"))
	else
		self.fields.btn_lord:setTitle(i18n("common_text_501"))
	end
	self:setSize(636, 130 + self.fields.Panel_member:getSize().height)
end
function Com_armySingle_9001573:removeArmy()
	self.tableArmy, _UPVALUE0_ = nil, nil
	self.fields.btn_lord:setVisible(false)
	self.fields.Panel_member:setVisible(false)
	self:setSize(636, 130)
end
function Com_armySingle_9001573:onClickLord()
	SoraDPlaySound()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	if self.isSelfTeam then
		if self.callbackEvent then
			self.callbackEvent()
		end
	else
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		;(nil).playerID = self.data.uid
		SoraDSendMessage(nil)
	end
end
return Com_armySingle_9001573
