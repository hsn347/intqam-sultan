local gametop = gModuleMgr.getObject("gametop")
local contactCtrl = gametop.playertop_:getModule("contactCtrl")
local activity_9001615_Ctrl = SoraDGetCtrl("activity_9001615_Ctrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001615_ChoosePanel = class("Activity_9001615_ChoosePanel", baseFguiPanel)
function Activity_9001615_ChoosePanel:ctor(...)
	Activity_9001615_ChoosePanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001615_ChoosePanel:ctor", self.viewName)
end
function Activity_9001615_ChoosePanel:onInit()
	print("=======Activity_9001615_ChoosePanel:onInit")
	self.nodeCommonPopBox = SoraDGetChildByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitle(i18n("Smelt_text_02"))
	self.textSetting = SoraDGetChildByName(self, "Text_setting")
	self.textSetting:setString(i18n("Smelt_text_04"))
	self.textTip = SoraDGetChildByName(self, "Text_tip")
	self.textTip:setString(i18n("Smelt_text_03"))
	self.textTip = SoraDGetChildByName(self, "Text_tip_2")
	self.textTip:setString(i18n("Smelt_text_05"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.tmpItem = SoraDGetChildByName(self, "Node_item")
	self.Button_buy = SoraDGetChildByName(self, "CCS_commonGoldSmallBtn_gold")
	self.Button_buy:addTouchEventListener(handler(self, self.btnBuyClickCallBack))
	self.button_free = SoraDGetChildByName(self, "button_free")
	self.button_free:addTouchEventListener(handler(self, self.btnBuyClickCallBack))
	self.Image_choosed_equip = SoraDGetChildByName(self, "Image_choosed_equip")
	self.chooseID = activity_9001615_Ctrl:getChooseID()
	self.scroll:setVirtual()
	self.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self:updateChooseEquip()
	self:initData()
end
function Activity_9001615_ChoosePanel:onShow()
	print("=======Activity_9001615_ChoosePanel:onShow")
end
function Activity_9001615_ChoosePanel:getRealEquip(smeltEquipCfg)
	return activity_9001615_Ctrl:getIsBuy() and smeltEquipCfg.upEquip or smeltEquipCfg.equip
end
function Activity_9001615_ChoosePanel:initData()
	local equips = activity_9001615_Ctrl:getCurEquips()
	_UPVALUE2_ = nil
	;(nil)[1] = equips
	;(nil)[2] = #equips
	dump(nil, "Activity_9001615_ChoosePanel:initData")
	self.equips = equips
	self.scroll:setNumItems(#equips)
end
function Activity_9001615_ChoosePanel:onItemRenderer(index, obj)
	print("Activity_9001615_ChoosePanel:onItemRenderer", index)
	local v = self.equips[index + 1]
	local euqipID = self:getRealEquip(v)
	local newItem = SoraDGetChildByName(obj, "item")
	newItem:initData(euqipID, activity_9001615_Ctrl:getIsBuy() and v.num[2] or v.num[1])
	newItem:setClickCallback(handler(self, self.onItemClick))
	SoraDGetChildByName(obj, "Text_name"):setString(activity_9001615_Ctrl:getEquipName(euqipID))
	_UPVALUE2_ = SoraDGetChildByName(obj, "Text_name")
	SoraDGetChildByName(obj, "Text_name")[1] = self.nowChooseID
	SoraDGetChildByName(obj, "Text_name")[2] = euqipID
	dump(SoraDGetChildByName(obj, "Text_name"), "self.nowChooseID == euqipID")
	SoraDGetChildByName(obj, "Image_light"):setVisible(self.nowChooseID == euqipID)
end
function Activity_9001615_ChoosePanel:btnBuyClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local equips = activity_9001615_Ctrl:getCurEquips()
		local equipID
		for i, v in ipairs(equips) do
			if self.nowChooseID == self:getRealEquip(v) then
				equipID = v.equip
			end
		end
		if SoraDEnoughGold(self.gold, true) then
			activity_9001615_Ctrl:reqChooseEquip(equipID)
		else
			SoraDShowMsgTip(i18n("artifact_text_20"))
		end
	end
end
function Activity_9001615_ChoosePanel:onItemClick(target)
	self.nowChooseID = target.id
	self.scroll:setNumItems(#self.equips)
	local isNeedUp = self.chooseID == self.nowChooseID
	self.Button_buy:setTouchEnabled(not isNeedUp)
	self.Button_buy:setBright(not isNeedUp)
	self.button_free:setTouchEnabled(not isNeedUp)
	self.button_free:setBright(not isNeedUp)
end
function Activity_9001615_ChoosePanel:updateChooseEquip()
	local gold = activity_9001615_Ctrl:getNowPrice()
	self.gold = gold
	if gold <= 0 then
		self.button_free:setVisible(true)
		self.button_free:setTitle(i18n("common_text_204"))
		self.Button_buy:setCostNum(0)
		self.Button_buy:setVisible(false)
	else
		self.Button_buy:setTitle(i18n("common_text_243"))
		self.Button_buy:setCostNum(gold)
		self.button_free:setVisible(false)
		self.Button_buy:setVisible(true)
	end
	self.chooseID = activity_9001615_Ctrl:getChooseID()
	self.nowChooseID = self.chooseID
	if self.chooseID == nil or self.chooseID == 0 then
		self.Image_choosed_equip:setVisible(false)
		self.Button_buy:setTouchEnabled(false)
		self.Button_buy:setBright(false)
		self.button_free:setTouchEnabled(false)
		self.button_free:setBright(false)
		return
	end
	self.Image_choosed_equip:setURL(publicRead.getIcon(self.chooseID))
	SoraDGetChildByName(self, "Sprite_Icon"):setVisible(false)
	local isNeedUp = self.chooseID == self.nowChooseID
	self.Button_buy:setTouchEnabled(not isNeedUp)
	self.Button_buy:setBright(not isNeedUp)
	self.button_free:setTouchEnabled(not isNeedUp)
	self.button_free:setBright(not isNeedUp)
end
function Activity_9001615_ChoosePanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "frist_item" then
		return SoraDGetChildByName(self.items[1], "Button_item")
	end
	return SoraDGetChildByName(self, itemName)
end
return Activity_9001615_ChoosePanel
