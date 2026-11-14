local publicUtil = include("publicUtil")
local publicRead = include("publicRead")
local armyChangeRead = include("armyChangeRead")
local gemExchangeCtrl = SoraDGetCtrl("gemExchangeCtrl")
local baseComponent = require("fgui.base.baseComponent")
local gemExchangeSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TroopsChange/gemExchangeSingle", gemExchangeSingle)
function gemExchangeSingle:onInit()
	self:fixChildrenPos()
	self.chooseItemIndex = nil
	self.exChangeStatus = 0
	self.fields.Button_exchange:addClickListener(handler(self, self.onBtnCallBack))
	self.fields.CheckBox_notify:addClickListener(handler(self, self.onCheckBoxCallBack))
	self.fields.Text_notify:setString(i18n("exchange_btn_01"))
	self.fields.Button_exchange:setTitleText(i18n("common_text_1889"))
	self.fields.btn_Change:addClickListener(handler(self, self.onClickChange))
	self.fields.btn_add:addClickListener(handler(self, self.onClickChange))
	self.fields.Button_from2:setClickCallback(handler(self, self.onClickChange))
end
function gemExchangeSingle:initData(index)
	self.index = index
	self.infoData = armyChangeRead.getStoneExchangeInfo(index)
	self.stoneID = self.infoData.stoneID
	self.chooseItemIndex = gemExchangeCtrl:getChooseIndex(index)
	print(self.stoneID, "stoneID", index)
	self.curExchangeNum = gemExchangeCtrl:getExchangeNum(self.index)
	local isNotify = gemExchangeCtrl:getRemindStatus(self.index) == 1
	self.fields.CheckBox_notify:setSelected(isNotify)
	self:setFixedItem()
	self.fields.Button_to:initData(self.stoneID, self.infoData.num)
	self.fields.textName:setString(publicRead.getName(self.stoneID))
	self:setLeftCount(self.infoData.rate, self.curExchangeNum)
	self:setVariableItem()
	self:setBtnExchangeStatus()
	local isRed = gemExchangeCtrl:getRedNumByIndex(index)
	self:setReddot(isRed == 1, 0)
end
function gemExchangeSingle:updateExChangeStatus()
	self.exChangeStatus = 0
	if self.curExchangeNum >= self.infoData.rate then
		self.exChangeStatus = 2
	elseif not self.chooseItemIndex then
		self.exChangeStatus = 3
	else
		local id = self.infoData.cost2[self.chooseItemIndex].id
		local needNum = self.infoData.cost2[self.chooseItemIndex].count
		local ownNum = publicUtil.getCount(id)
		if needNum > ownNum then
			self.exChangeStatus = 1
		end
		id = self.infoData.cost1[1].id
		needNum = self.infoData.cost1[1].count
		ownNum = publicUtil.getCount(id)
		if needNum > ownNum then
			self.exChangeStatus = 1
		end
	end
end
function gemExchangeSingle:setLeftCount(limitnum, curExchangeNum)
	if limitnum == 0 then
		self.fields.Text_leftCount:setString("")
	else
		self.leftCount = math.max(0, limitnum - curExchangeNum)
		local countStr = string.format("%d/%d", self.leftCount, limitnum)
		_ENV = nil
		_ENV, _ENV, (nil).count = nil, nil, countStr
		;(nil).count, (nil).color = nil, 0 >= self.leftCount and "#FF0000" or "#FFFFFF"
		self.fields.Text_leftCount:setString(i18n_html("common_text_1673", nil, nil))
	end
end
function gemExchangeSingle:setVariableItem()
	self.controllers.c1:setSelectedIndex(self.chooseItemIndex and 1 or 0)
	if not self.chooseItemIndex then
		self.fields.btn_Change:setString(i18n("shopping_text_10"))
		return
	end
	self.fields.btn_Change:setString(i18n("exitic_pavillion_text_0071"))
	local id = self.infoData.cost2[self.chooseItemIndex].id
	local needNum = self.infoData.cost2[self.chooseItemIndex].count
	local ownNum = publicUtil.getCount(id)
	local stringColor = "#FFFFFF"
	if needNum > ownNum then
		stringColor = "#BE2828"
	else
		stringColor = "#36bf36"
	end
	self.fields.Button_from2:initData(id)
	self.fields.Button_from2:setNum(ownNum, needNum, stringColor)
end
function gemExchangeSingle:setFixedItem()
	local id = self.infoData.cost1[1].id
	local needNum = self.infoData.cost1[1].count
	local ownNum = publicUtil.getCount(id)
	self.fields.Button_from1:initData(id)
	local stringColor = "#FFFFFF"
	if needNum > ownNum then
		stringColor = "#BE2828"
	else
		stringColor = "#36bf36"
	end
	self.fields.Button_from1:setNum(ownNum, needNum, stringColor)
end
function gemExchangeSingle:setBtnExchangeStatus()
	self:updateExChangeStatus()
	print("self.exChangeStatus", self.exChangeStatus)
	if self.exChangeStatus == 0 then
		self.fields.Button_exchange:setGrayed(false)
	elseif self.exChangeStatus == 1 then
		self.fields.Button_exchange:setGrayed(false)
	elseif self.exChangeStatus == 2 then
		self.fields.Button_exchange:setGrayed(true)
	elseif self.exChangeStatus == 3 then
		self.fields.Button_exchange:setGrayed(true)
	end
end
function gemExchangeSingle:onBtnCallBack(context)
	SoraDPlaySound()
	if self.exChangeStatus == 1 then
		SoraDShowMsgTip(i18n("notice_0120"))
	elseif self.exChangeStatus == 2 then
		SoraDShowMsgTip(i18n("common_text_1865"))
	elseif self.exChangeStatus == 3 then
		SoraDShowMsgTip(i18n("armyExchange_text_024"))
	elseif self.chooseItemIndex then
		local itemStr = string.format("%sx%d,%sx%d", publicRead.getName(self.infoData.cost2[self.chooseItemIndex].id), self.infoData.cost2[self.chooseItemIndex].count, publicRead.getName(self.infoData.cost1[1].id), self.infoData.cost1[1].count)
		_ENV = self.infoData.cost2[self.chooseItemIndex].count
		self.infoData.cost2[self.chooseItemIndex].count.item = itemStr
		self.infoData.cost2[self.chooseItemIndex].count.name2 = publicRead.getName(self.stoneID)
		self.infoData.cost2[self.chooseItemIndex].count.num2 = self.infoData.num
		local strTip = i18n("armyExchange_text_027", self.infoData.cost2[self.chooseItemIndex].count)
		SoraDShowMsgBox(strTip, i18n("common_text_204"), nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				SoraDPlaySound()
				SoraDShowLoading()
				gemExchangeCtrl:reqGemExchangeBuy(self.infoData.cost2[self.chooseItemIndex].id, self.index)
			end
		end)
	end
end
function gemExchangeSingle:setChooseIndex(index)
	self.chooseItemIndex = index
	gemExchangeCtrl:setChooseIndex(self.index, index)
	self:setVariableItem()
	self:setBtnExchangeStatus()
end
function gemExchangeSingle:onClickChange()
	SoraDPlaySound()
	_ENV = nil
	;(nil).index = self.index
	;(nil).handler = handler(self, self.setChooseIndex)
	uiManager:show("chosseGemItem", nil)
end
function gemExchangeSingle:onCheckBoxCallBack(context)
	if self.fields.CheckBox_notify:isSelected() then
		SoraDPlaySound()
		gemExchangeCtrl:reqGemExchangeRemind(self.index, 1)
	elseif not self.fields.CheckBox_notify:isSelected() then
		SoraDPlaySound()
		gemExchangeCtrl:reqGemExchangeRemind(self.index, 0)
	end
end
return gemExchangeSingle
