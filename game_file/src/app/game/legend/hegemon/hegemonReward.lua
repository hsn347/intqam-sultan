local publicRead = include("publicRead")
local HegemonReward = class("hegemonReward", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("hegemonReward")
	end
	return target
end)
function HegemonReward:ctor()
	self.Panel_item_1 = SoraDGetChildByName(self, "Panel_item_1")
	self.Panel_item_2 = SoraDGetChildByName(self, "Panel_item_2")
	self.Panel_item_3 = SoraDGetChildByName(self, "Panel_item_3")
	self.Panel_1 = SoraDGetChildByName(self, "Panel_1")
	self.Text_Title = SoraDGetChildByName(self, "Text_Title")
	self.btn_more = SoraDGetChildByName(self, "btn_more")
	self.btn_confirm = SoraDGetChildByName(self, "btn_confirm")
	self.btn_more:addTouchEventListener(handler(self, self.onClickBtnMore))
	self.btn_confirm:addTouchEventListener(handler(self, self.onClickBtnConfirm))
	self.btn_more:setTitleText(i18n("common_text_486"))
	self.btn_confirm:setTitleText(i18n("common_text_204"))
	_UPVALUE3_ = self.btn_confirm.setTitleText
	self.rewardNodeArray, self.btn_confirm.setTitleText[1] = self.btn_confirm.setTitleText, self.Panel_item_1
	self.rewardNodeArray, self.btn_confirm.setTitleText[2] = self.btn_confirm.setTitleText, self.Panel_item_2
	self.rewardNodeArray, self.btn_confirm.setTitleText[3] = self.btn_confirm.setTitleText, self.Panel_item_3
	self.kingReward = include("hegemonRead").getWarRankReward(1)
end
function HegemonReward:init(data)
	self.bid = data.bid
	self.Text_Title:setString(i18n("hegemon_text_12"))
	for i, v in ipairs(self.rewardNodeArray) do
		local Image_bg = SoraDGetChildByName(v, "Image_bg")
		local Image_item = SoraDGetChildByName(v, "Image_item")
		local Text_item_name = SoraDGetChildByName(v, "Text_item_name")
		local reward = self.kingReward[i]
		local itemId = reward.id
		local itemNum = reward.count
		Image_bg:loadTexture(publicRead.getBg(itemId), ccui.TextureResType.plistType)
		Image_item:loadTexture(publicRead.getIcon(itemId), ccui.TextureResType.plistType)
		local itemName = publicRead.getName(itemId)
		_ENV = i18n("hegemon_text_12")
		i18n("hegemon_text_12").name = itemName
		i18n("hegemon_text_12").count = itemNum
		Text_item_name:setString(i18n("common_text_1460", i18n("hegemon_text_12")))
		Image_bg.itemId = itemId
		Image_bg:setTouchEnabled(true)
		Image_bg:addTouchEventListener(handler(self, self.onClick_show))
	end
end
function HegemonReward:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_LEGENDKINGREWARD_SHOW_ITEMINFO", handler(self, self.msgShowItemInfo))
end
function HegemonReward:onClick_show(sender, event)
	if event == ccui.TouchEventType.began then
		self:openItemInfo(sender.itemId, sender)
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
		self:closeItemInfo()
	elseif event == ccui.TouchEventType.ended then
		self:closeItemInfo()
	end
end
function HegemonReward:openItemInfo(id, sender)
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_LEGENDKINGREWARD_SHOW_ITEMINFO"
	;(nil).isShow = true
	;(nil).id = id
	;(nil).item = sender
	SoraDSendMessage(nil)
end
function HegemonReward:closeItemInfo()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_LEGENDKINGREWARD_SHOW_ITEMINFO"
	;(nil).isShow = false
	SoraDSendMessage(nil)
end
function HegemonReward:msgShowItemInfo(target, data)
	local isShow = data.isShow
	if isShow == true then
		self:openItemInfoMsg(data)
	else
		self:closeItemInfoMsg(data)
	end
end
function HegemonReward:openItemInfoMsg(data)
	local itemID = data.id
	local item = data.item
	if self.itemTips == nil then
		self.itemTips = SoraDCreatePanel("commonItemTips")
		self.itemTips:setPositionY(50)
		self.itemTips:addTo(self)
		self.itemTips:setLocalZOrder(10)
		self.itemTips:setVisible(false)
	end
	local worldPos = item:convertToWorldSpace(cc.p(0, 0))
	local nodePos = self:convertToNodeSpace(worldPos)
	local deltaTipX = 0
	if SoraDFIsRA() then
		deltaTipX = 0
	else
		deltaTipX = -280
	end
	if nodePos.x > 300 then
		self.itemTips:setPositionX(nodePos.x + 15 + deltaTipX)
	else
		self.itemTips:setPositionX(nodePos.x + 325 + deltaTipX)
	end
	self.itemTips:setPositionY(nodePos.y + 200)
	self.itemTips:setVisible(true)
	if gIDType.EQUIPMENT == JudgeItemType(itemID) then
		local equipDesRead = include("equipDesRead")
		local equipmentltCtrl = include("equipmentltCtrl")
		local itemName = equipDesRead.getName(itemID)
		local baseProperty, mayVal = equipmentltCtrl.getEquipmentBaseProperty(itemID, 999, 0)
		local baseString = equipDesRead.getAttrName(baseProperty, mayVal)
		local itemContent = baseString .. "\n" .. i18n("common_text_1344")
		self.itemTips:customData(itemName, itemContent)
	else
		self.itemTips:initData(itemID)
	end
end
function HegemonReward:closeItemInfoMsg(data)
	if self.itemTips then
		self.itemTips:setVisible(false)
	end
end
function HegemonReward:onClickBtnMore(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("hegemonRewardDetail")
		_ENV = nil
		;(nil).bid = self.bid
		panel:init(nil)
		panel:show()
	end
end
function HegemonReward:onClickBtnConfirm(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:closePanel()
	end
end
return HegemonReward
