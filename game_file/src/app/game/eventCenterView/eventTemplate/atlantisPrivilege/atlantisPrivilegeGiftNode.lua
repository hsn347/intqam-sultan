local atlantisPrivilegeCtrl = SoraDGetCtrl("atlantisPrivilegeCtrl")
local atlantisActivityRead = include("atlantisActivityRead")
local atlantisPrivilegeGiftNode = class("atlantisPrivilegeGiftNode", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	SoraDDeviceFitOffset(target)
	return target
end)
function atlantisPrivilegeGiftNode:ctor(properties)
	self.nodeList, _ENV = nil, nil
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView")
	self.btnLog = SoraDGetChildByName(self, "Button_Log")
	self.btnLog:setTitleText(i18n("common_text_836"))
	self.btnLog:addTouchEventListener(handler(self, self.btnLogClick))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self:updateScrollView()
end
function atlantisPrivilegeGiftNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_PRIVILEGE_REFRESH", handler(self, self.refreshScroll))
end
function atlantisPrivilegeGiftNode:refreshScroll()
	for i, info in ipairs(atlantisActivityRead.getOfficerAward()) do
		if self.nodeList[i] then
			self:nodeSingleRefresh(self.nodeList[i], info)
		end
	end
end
function atlantisPrivilegeGiftNode:updateScrollView()
	local totalHeight = 0
	for i, info in ipairs(atlantisActivityRead.getOfficerAward()) do
		local single = self.nodeSingle:clone()
		single:addTo(self.scroll)
		single.height = self:nodeSingleRefresh(single, info)
		totalHeight = totalHeight + single.height
		table.insert(self.nodeList, single)
	end
	local newHeight = math.max(totalHeight, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(640, newHeight))
	local itemPosY = newHeight
	for i, single in ipairs(self.nodeList) do
		single:setPosition(0, itemPosY)
		itemPosY = itemPosY - single.height
	end
end
function atlantisPrivilegeGiftNode:createScrollSingle()
	return self.nodeSingle:clone()
end
function atlantisPrivilegeGiftNode:nodeSingleRefresh(parent, data)
	local height = 60
	local nodeReward = SoraDGetChildByName(parent, "Node_Reward")
	local btnGift = SoraDGetChildByName(parent, "Button_Gift")
	btnGift:setTitleText(i18n("common_text_1441"))
	btnGift:addTouchEventListener(handlerEx(self, self.btnGiftClick, data.treasureID))
	local isShowBtn = atlantisPrivilegeCtrl:isKing()
	btnGift:setVisible(isShowBtn)
	local textGiftName = SoraDGetChildByName(parent, "Text_GiftName")
	textGiftName:setString(i18n(data.name))
	local textNum = SoraDGetChildByName(parent, "Text_Num")
	textNum = SoraDChangeTextToHtml(textNum)
	local sendNum = atlantisPrivilegeCtrl:getGiftSendNum(data.treasureID)
	local leftNum = data.count - sendNum
	_ENV = i18n(data.name)
	i18n(data.name).send = leftNum
	_ENV, _ENV, i18n(data.name).total = i18n(data.name)
	_ENV, data.count.send, i18n(data.name).color = i18n(data.name)
	data.count.__default, i18n(data.name).color = i18n(data.name)
	textNum:setString(i18n_html("common_text_1289", i18n(data.name)))
	if leftNum <= 0 then
		btnGift:setBright(false)
		btnGift:setTouchEnabled(false)
	end
	local Sprite_red = SoraDGetChildByName(btnGift, "Sprite_red")
	if not Sprite_red then
		Sprite_red = display.newSprite("#frame_mail_round_02.png")
		Sprite_red:addTo(btnGift)
		Sprite_red:setPosition(cc.p(200, 54))
		Sprite_red:setScale(0.8)
		Sprite_red:setName("Sprite_red")
	end
	Sprite_red:setVisible(0 < leftNum)
	_UPVALUE2_ = 0 < leftNum
	;(0 < leftNum)[1] = "id"
	;(0 < leftNum)[2] = "count"
	local rewardList = serviceFunctions.tableFormat(data.rewards, 0 < leftNum)
	local rewardHeight = math.ceil(#rewardList / 4) * 150
	nodeReward:setPositionY(-rewardHeight / 2 - height)
	height = height + rewardHeight
	if isShowBtn then
		height = height + 72
		btnGift:setPositionY(-height + 36)
	end
	if 0 < nodeReward:getChildrenCount() then
		return height
	end
	for i, v in ipairs(rewardList) do
		local item = include("commonItemAward").new()
		item:setScale(1.2)
		item:setBaseScale(1.0)
		item:initData(v.id, v.count)
		item:setOwnScroll(self.scroll)
		item:addTo(nodeReward)
	end
	SoraDautoSortPos(nodeReward, 4, 2, cc.size(140, 150), SoraDFIsRA())
	return height
end
function atlantisPrivilegeGiftNode:btnLogClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		local panel = SoraDCreatePanel("atlantisPrivilegeLogView")
		panel:show()
	end
end
function atlantisPrivilegeGiftNode:btnGiftClick(treasureID, target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		local panel = SoraDCreatePanel("worldMapKingdomCityAppointSelect")
		panel:setAtlantisGift(treasureID, atlantisPrivilegeCtrl:getLimitUser(treasureID), atlantisPrivilegeCtrl:getKindomList())
		panel:show()
	end
end
return atlantisPrivilegeGiftNode
