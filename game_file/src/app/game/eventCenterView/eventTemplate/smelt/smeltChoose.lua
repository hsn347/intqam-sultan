local gametop = gModuleMgr.getObject("gametop")
local contactCtrl = gametop.playertop_:getModule("contactCtrl")
local smeltCtrl = SoraDGetCtrl("smeltCtrl")
local publicRead = include("publicRead")
local smeltChoose = class("smeltChoose", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("smeltChoose")
end)
function smeltChoose:ctor(properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("Smelt_text_02"))
	self.textSetting = SoraDGetChildByName(self, "Text_setting")
	self.textSetting:setString(i18n("Smelt_text_04"))
	self.textTip = SoraDGetChildByName(self, "Text_tip")
	self.textTip:setString(i18n("Smelt_text_03"))
	self.textTip = SoraDGetChildByName(self, "Text_tip_2")
	self.textTip:setString(i18n("Smelt_text_05"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.sp = SoraDGetChildByName(self, "Sprite_bigGear")
	self.sp:setPositionY(215)
	self.tmpItem = SoraDGetChildByName(self, "Node_item")
	self.Button_buy = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldSmallBtn_gold")
	self.Button_buy:addTouchEventListener(handler(self, self.btnBuyClickCallBack))
	self.Image_choosed_equip = SoraDGetChildByName(self, "Image_choosed_equip")
	self.chooseID = smeltCtrl:getChooseID()
	self:updateChooseEquip()
	self:initData()
end
function smeltChoose:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UPDATE_SMELT_CHOOSE_EQUIP", handler(self, self.removeSelf))
end
function smeltChoose:getRealEquip(smeltEquipCfg)
	return smeltCtrl:getIsBuy() and smeltEquipCfg.upEquip or smeltEquipCfg.equip
end
function smeltChoose:initData()
	local tmpH = smeltCtrl:getGroupID() == 1 and 160 or 150
	local self.items, smeltCtrl, scale = smeltCtrl, smeltCtrl, smeltCtrl:getGroupID() == 1 and 1 or 0.97
	local equips = smeltCtrl:getCurEquips()
	self.nodeEquips = self.scroll:getInnerContainer()
	SoraDautoSortPos(self.scroll, 3, 1, cc.size(170, tmpH), not SoraDFIsRA())
	local height = math.ceil(#equips / 3) * tmpH
	local size = self.scroll:getContentSize()
	height = height < size.height and size.height or height
	self.nodeEquips:setContentSize(size.width, height)
	self.scroll:scrollToTop(0, false)
	for i, v in ipairs(equips) do
		local euqipID = self:getRealEquip(v)
		local newItem = self.tmpItem:clone()
		newItem:setScale(scale)
		local item = SoraDPopItemAward()
		item:setPosition(0, 0)
		if SoraDFIsRA() then
			newItem:setPosition(440 - 170 * ((i - 1) % 3), height + 95 - tmpH * math.ceil(i / 3))
		else
			newItem:setPosition(100 + 170 * ((i - 1) % 3), height + 95 - tmpH * math.ceil(i / 3))
		end
		item:addTo(newItem)
		item:setOwnView(self)
		item:setOwnScroll(self.scroll)
		item:initData(euqipID, smeltCtrl:getIsBuy() and v.num[2] or v.num[1])
		item:setHandle(handler(self, self.onItemClick))
		SoraDGetChildByName(item, "Button_item").isLongTouch = true
		newItem:addTo(self.nodeEquips)
		SoraDGetChildByName(newItem, "Text_name"):setString(smeltCtrl:getEquipName(euqipID))
		SoraDGetChildByName(newItem, "Image_light"):setVisible(self.nowChooseID == euqipID)
		table.insert(self.items, item)
	end
end
function smeltChoose:btnBuyClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local equips = smeltCtrl:getCurEquips()
		local equipID
		for i, v in ipairs(equips) do
			if self.nowChooseID == self:getRealEquip(v) then
				equipID = v.equip
			end
		end
		if SoraDEnoughGold(self.gold, true) then
			smeltCtrl:reqChooseEquip(equipID)
		else
			SoraDShowMsgTip(i18n("artifact_text_20"))
		end
	end
end
function smeltChoose:onItemClick(target, event, itemID)
	self.nowChooseID = itemID
	for i, v in ipairs(self.items) do
		SoraDGetChildByName(v:getParent(), "Image_light"):setVisible(self.nowChooseID == v.itemID)
	end
	local isNeedUp = self.chooseID == self.nowChooseID
	self.Button_buy:setTouchEnabled(not isNeedUp)
	self.Button_buy:setBright(not isNeedUp)
end
function smeltChoose:updateChooseEquip()
	local gold = smeltCtrl:getNowPrice()
	self.gold = gold
	if gold <= 0 then
		smeltCtrl = nil
		;(nil).text = i18n("common_text_204")
		self.Button_buy:initData(nil, 0)
	else
		smeltCtrl = nil
		;(nil).title = i18n("common_text_243")
		;(nil).gold = gold
		self.Button_buy:initData(nil, 1)
		if SoraDEnoughGold(self.gold, true) then
			self.Button_buy:setTextGoldColor(cc.c3b(255, 255, 255))
		else
			self.Button_buy:setTextGoldColor(cc.c3b(255, 1, 1))
		end
	end
	self.chooseID = smeltCtrl:getChooseID()
	self.nowChooseID = self.chooseID
	if self.chooseID == nil or self.chooseID == 0 then
		self.Image_choosed_equip:setVisible(false)
		self.Button_buy:setTouchEnabled(false)
		self.Button_buy:setBright(false)
		return
	end
	self.Image_choosed_equip:loadTexture(publicRead.getIcon(self.chooseID), ccui.TextureResType.plistType)
	SoraDGetChildByName(self, "Sprite_Icon"):setVisible(false)
	local isNeedUp = self.chooseID == self.nowChooseID
	self.Button_buy:setTouchEnabled(not isNeedUp)
	self.Button_buy:setBright(not isNeedUp)
end
function smeltChoose:gameGuide_getTarget(itemName, parameters)
	if itemName == "frist_item" then
		return SoraDGetChildByName(self.items[1], "Button_item")
	end
	return SoraDGetChildByName(self, itemName)
end
return smeltChoose
