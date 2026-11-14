local chatFunctions = include("chatFunctions")
local chatTextNode = include("chatTextNode")
local chatTextBtnNode = class("chatTextBtnNode", chatTextNode)
_ENV = "chatTextBtnNode"
;("chatTextBtnNode").width = 340
;("chatTextBtnNode").height = 50
;("chatTextBtnNode").buttonW = 154
local ("chatTextBtnNode").buttonH, _defaultParam = 44, "chatTextBtnNode"
function chatTextBtnNode:ctor()
	chatTextBtnNode.super.ctor(self)
	self.btnList, chatTextBtnNode = chatTextBtnNode.super.ctor, chatTextBtnNode.super.ctor
	local Node_btns = display.newNode()
	Node_btns:addTo(self, 1)
	Node_btns:setName("Node_btns")
	Node_btns:setPosition(cc.p(_defaultParam.width / 2, 0))
	self.Node_btns = Node_btns
end
function chatTextBtnNode:init(data)
	chatTextBtnNode.super.init(self, data)
end
function chatTextBtnNode:createButtonSingle(params)
	local btnImage = params.btnImage or "btn_alliance_green.png"
	local button = ccui.Button:create(btnImage, "", "", ccui.TextureResType.plistType)
	button:addTo(self.Node_btns, 1)
	button:setScale9Enabled(true)
	local btnSize = cc.size(_defaultParam.buttonW, _defaultParam.buttonH)
	button:setContentSize(btnSize)
	button:setButtonType(ccui.ButtonType.TRISTATE)
	if params.btnEnable ~= nil then
		button:setEnabled(params.btnEnable)
	end
	if params.pos then
		button:setPosition(params.pos)
	end
	if params.iconImage then
		local sprite = display.newSprite("#" .. params.iconImage)
		sprite:addTo(button)
		sprite:setPosition(32, btnSize.height / 2)
	end
	if params.name then
		local Text_name = ccui.Text:create(params.name, "", 22)
		Text_name:addTo(button)
		local iconW = params.iconImage and 40 or 0
		SoraDSetTextWidthHeight(Text_name, cc.size(btnSize.width - iconW - 20, btnSize.height))
		Text_name:setColor(cc.c3b(255, 251, 213))
		Text_name:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		Text_name:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		Text_name:setPosition(iconW + (btnSize.width - iconW) / 2, btnSize.height / 2)
	end
	local clickHander = params.clickHander
	button:addTouchEventListener(function(button, eventType)
		if eventType ~= ccui.TouchEventType.ended then
			return
		end
		if clickHander then
			clickHander()
		end
	end)
	table.insert(self.btnList, button)
end
function chatTextBtnNode:reset(...)
	chatTextBtnNode.super.reset(self, ...)
	for i, v in ipairs(self.btnList) do
		v:removeFromParent()
	end
	self.btnList, chatTextBtnNode = ipairs(self.btnList)
end
function chatTextBtnNode:initContent(data)
	chatTextBtnNode.super.initContent(self, data)
	local dataType = data.dataType
	if dataType == gChatDataType.dataType_honor_back_activity then
		local playerId = data.playerId
		if playerId == chatFunctions:getSelfId() then
			return
		end
		chatTextBtnNode = nil
		;(nil).name = i18n("Honor_return_chat_text4")
		;(nil).pos = cc.p(-82, 0)
		;(nil).btnImage = "btn_alliance_green.png"
		;(nil).iconImage = "frame_ltts_liaotian.png"
		;(nil).clickHander = function()
			local playerId = self.data.playerId
			local nickName = self.data.nickName
			local allianceAbbr = self.data.alliance
			self = nil
			;(nil).targetType = gMailType.CHAT
			;(nil).target = playerId
			;(nil).nickName = nickName
			local (nil).allianceAbbr, data = allianceAbbr, nil
			SoraDCreateChatView(data)
		end
		self:createButtonSingle(nil)
		chatTextBtnNode = nil
		;(nil).name = i18n("nebulaemperor_text_33")
		;(nil).pos = cc.p(82, 0)
		;(nil).btnImage = "btn_BXanniu_yellow.png"
		;(nil).iconImage = "frame_ltts_tianjia.png"
		;(nil).clickHander = function()
			local condParser = include("condParser")
			_ENV = nil
			;(nil).condtype = gCondType.alliancePermission
			;(nil).condvalue = gAPermission.RECRUIT
			if not condParser.verify(nil) then
				SoraDShowMsgTip(i18n("common_text_203"))
				return
			end
			local allianceMgr = SoraDGetCtrl("allianceMgr")
			if self.data.playerId then
				allianceMgr:reqInviteJoin(self.data.playerId)
			end
		end
		self:createButtonSingle(nil)
	elseif dataType == gChatDataType.dataType_korean_chess_room_invite then
		local playerId = data.playerId
		if playerId == chatFunctions:getSelfId() then
			return
		end
		dump(self.data, "==korean_chess_room_invite data==")
		local activity_9001676_Read = include("activity_9001676_Read")
		local btnName = i18n("krone_text_29")
		local stateTime = self.data.customData.values.stateTime
		local isEnable = true
		if activity_9001676_Read.getIsRoomTimeOut(stateTime) then
			btnName = i18n("krone_text_28")
			isEnable = false
		end
		chatTextBtnNode = nil
		;(nil).name = btnName
		;(nil).pos = cc.p(10, 0)
		;(nil).btnImage = "btn_alliance_green.png"
		;(nil).btnEnable = isEnable
		;(nil).clickHander = function()
			local activity_9001676_Ctrl = SoraDGetCtrl("activity_9001676_Ctrl")
			activity_9001676_Ctrl:reqKoreanChessRoomEnter(self.data.customData.values)
		end
		self:createButtonSingle(nil)
	end
	if 0 < #self.btnList then
		data.btnSize = cc.size(_defaultParam.width, _defaultParam.height)
	else
		data.btnSize = nil
	end
end
function chatTextBtnNode:alignContent(...)
	chatTextBtnNode.super.alignContent(self, ...)
	self.Node_btns:setPositionY(self.bubble:getContentY() - _defaultParam.height / 2 - 15)
end
function chatTextBtnNode.measureSize(data, target)
	local retSize = chatTextNode.measureSize(data, target)
	local dataType = data.dataType
	if dataType == gChatDataType.dataType_honor_back_activity then
		if data.playerId ~= chatFunctions:getSelfId() then
			return cc.size(_defaultParam.width, retSize.height + _defaultParam.height)
		end
	elseif dataType == gChatDataType.dataType_korean_chess_room_invite and data.playerId ~= chatFunctions:getSelfId() then
		return cc.size(_defaultParam.width, retSize.height + _defaultParam.height)
	end
	return retSize
end
return chatTextBtnNode
