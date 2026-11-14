local atlantisPrivilegeCtrl = SoraDGetCtrl("atlantisPrivilegeCtrl")
local atlantisActivityRead = include("atlantisActivityRead")
local atlantisPrivilegeOrderNode = class("atlantisPrivilegeOrderNode", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	SoraDDeviceFitOffset(target)
	return target
end)
_UPVALUE7_, atlantisPrivilegeOrderNode.ctor = function(self, properties)
	self.nodeList, _ENV = nil, nil
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView")
	self.nodeOrder = SoraDGetChildByName(self.scroll, "Node_Order")
	self.nodeOrder:setPositionY(math.max(0, self.scroll:getContentSize().height - 820))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self:initData()
end, function(self, properties)
	self.nodeList, _ENV = nil, nil
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView")
	self.nodeOrder = SoraDGetChildByName(self.scroll, "Node_Order")
	self.nodeOrder:setPositionY(math.max(0, self.scroll:getContentSize().height - 820))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self:initData()
end
;(function(self, properties)
	self.nodeList, _ENV = nil, nil
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView")
	self.nodeOrder = SoraDGetChildByName(self.scroll, "Node_Order")
	self.nodeOrder:setPositionY(math.max(0, self.scroll:getContentSize().height - 820))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self:initData()
end)[1] = cc.p(-205, 560)
;(function(self, properties)
	self.nodeList, _ENV = nil, nil
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView")
	self.nodeOrder = SoraDGetChildByName(self.scroll, "Node_Order")
	self.nodeOrder:setPositionY(math.max(0, self.scroll:getContentSize().height - 820))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self:initData()
end)[2] = cc.p(0, 560)
;(function(self, properties)
	self.nodeList, _ENV = nil, nil
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView")
	self.nodeOrder = SoraDGetChildByName(self.scroll, "Node_Order")
	self.nodeOrder:setPositionY(math.max(0, self.scroll:getContentSize().height - 820))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self:initData()
end)[3] = cc.p(205, 560)
;(function(self, properties)
	self.nodeList, _ENV = nil, nil
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView")
	self.nodeOrder = SoraDGetChildByName(self.scroll, "Node_Order")
	self.nodeOrder:setPositionY(math.max(0, self.scroll:getContentSize().height - 820))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self:initData()
end)[4] = cc.p(-205, 290)
;(function(self, properties)
	self.nodeList, _ENV = nil, nil
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView")
	self.nodeOrder = SoraDGetChildByName(self.scroll, "Node_Order")
	self.nodeOrder:setPositionY(math.max(0, self.scroll:getContentSize().height - 820))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self:initData()
end)[5] = cc.p(0, 290)
;(function(self, properties)
	self.nodeList, _ENV = nil, nil
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView")
	self.nodeOrder = SoraDGetChildByName(self.scroll, "Node_Order")
	self.nodeOrder:setPositionY(math.max(0, self.scroll:getContentSize().height - 820))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self:initData()
end)[6] = cc.p(205, 290)
;(function(self, properties)
	self.nodeList, _ENV = nil, nil
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView")
	self.nodeOrder = SoraDGetChildByName(self.scroll, "Node_Order")
	self.nodeOrder:setPositionY(math.max(0, self.scroll:getContentSize().height - 820))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self:initData()
end)[7] = cc.p(-103, 20)
;(function(self, properties)
	self.nodeList, _ENV = nil, nil
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView")
	self.nodeOrder = SoraDGetChildByName(self.scroll, "Node_Order")
	self.nodeOrder:setPositionY(math.max(0, self.scroll:getContentSize().height - 820))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self:initData()
end)[8] = cc.p(103, 20)
;(function(self, properties)
	self.nodeList, _ENV = nil, nil
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView")
	self.nodeOrder = SoraDGetChildByName(self.scroll, "Node_Order")
	self.nodeOrder:setPositionY(math.max(0, self.scroll:getContentSize().height - 820))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self:initData()
end)[9] = cc.p(103, 20)
local (function(self, properties)
	self.nodeList, _ENV = nil, nil
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView")
	self.nodeOrder = SoraDGetChildByName(self.scroll, "Node_Order")
	self.nodeOrder:setPositionY(math.max(0, self.scroll:getContentSize().height - 820))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self:initData()
end)[10], posList = cc.p(103, 20)
function atlantisPrivilegeOrderNode:initData(target, data)
	for i, v in ipairs(atlantisActivityRead.getOfficerConfig()) do
		if 1 < i then
			local single = self:getSingleInit(v.type, v.name)
			self:nodeSingleRefresh(single, v.type)
			single:addTo(self.nodeOrder)
			single:setPosition(posList[i - 1])
			self.nodeList[v.type] = single
		end
	end
end
function atlantisPrivilegeOrderNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_PRIVILEGE_REFRESH", handler(self, self.msgRefreshView))
end
function atlantisPrivilegeOrderNode:getSingleInit(officialType, officialName)
	local single = self.nodeSingle:clone()
	local btnOrder = SoraDGetChildByName(single, "Button_Order")
	btnOrder:setSwallowTouches(false)
	btnOrder:addTouchEventListener(handlerEx(self, self.btnOrderClick, officialType))
	SoraDGetChildByName(single, "Text_OfficeName"):setString(i18n(officialName))
	return single
end
function atlantisPrivilegeOrderNode:nodeSingleRefresh(parent, officialType)
	local officeIcon = SoraDGetChildByName(parent, "Image_Office")
	local textUserName = SoraDGetChildByName(parent, "Text_UserName")
	print("officialType", officialType)
	local officialUserInfo = atlantisPrivilegeCtrl:getInfoByOfficialType(officialType)
	if officialUserInfo then
		officeIcon:setScale(0.8)
		SoraDGetHeadFromManager(officeIcon, officialUserInfo.iconID, officialUserInfo.avatar)
		textUserName:setString(textParser.formatPlayerName(officialUserInfo.allianceAbbr, officialUserInfo.nickName, officialUserInfo.kid))
	else
		officeIcon:setScale(1)
		officeIcon:setSpriteFrame(atlantisActivityRead.getOfficialInfoByType(officialType).img2)
		textUserName:setString(i18n("common_text_480"))
	end
end
function atlantisPrivilegeOrderNode:btnOrderClick(officialType, target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll, eventType) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local tag = target:getTag()
		local panel = SoraDCreatePanel("atlantisPrivilegeDetailPop")
		panel:init(officialType)
		panel:show()
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function atlantisPrivilegeOrderNode:msgRefreshView(target, data)
	for officialType, target in pairs(self.nodeList) do
		self:nodeSingleRefresh(target, officialType)
	end
end
return atlantisPrivilegeOrderNode
