local buildLogic = include("buildLogic")
local gametop = gModuleMgr.getObject("gametop")
local activityExchangeMallCtrl = gametop.playertop_:getModule("activityExchangeMallCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local publicRead = include("publicRead")
local publicUtil = include("publicUtil")
local baseComponent = require("fgui.base.baseComponent")
local ActExchangeSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ExchangeShopNew/ActExchangeSingle", ActExchangeSingle)
fgui.register_extension("ui://Activity_9001678/Com_exchangeSingle", ActExchangeSingle)
function ActExchangeSingle:onInit()
	self:fixChildrenPos()
	if self.fields.Sprite_line then
		self.fields.Sprite_line:fix()
	end
	self.fields.arrow:fix()
	self.CheckBox_notify = self.fields.CheckBox_notify
	self.Text_leftCount = self.fields.Text_leftCount
	self.Button_exchange = self.fields.Button_exchange
	self.fields.Button_exchange:addClickListener(handler(self, self.onBtnCallBack))
	self.fields.CheckBox_notify:addClickListener(handler(self, self.onCheckBoxCallBack))
	self.fields.toItemL:setItemRenderer(handler(self, self.onToItemRender))
	self.fields.fromItemL:setItemRenderer(handler(self, self.onFromItemRender))
	self.exChangeStatus = 0
	self.fields.Text_notify:setString(i18n("exchange_btn_01"))
	self.Button_exchange:setTitle(i18n("common_text_1889"))
end
function ActExchangeSingle:initData(data, otherData)
	dump(data, "ActExchangeSingle:initData")
	local _ENV, otherData = dump, otherData or dump
	self.activityID = otherData.activityID
	self.shopItemID = data.shopItemID
	self.itemID = data.shopitem
	self.singleGet = data.shopitemnum
	self.toolID = data.exchangeitem
	self.singleCount = data.exchangenum
	self.toolID2 = data.exchangeitem2
	self.singleCount2 = data.exchangenum2
	self.storeID = data.storeID
	self.limitNum = data.limitnum
	self.ownCount = publicUtil.getCount(self.toolID)
	self.curExchangeNum = data.curExchangeNum
	_ENV, publicUtil, self.exLimit = self.toolID, data.exLimit, data.exLimit
	self.toolID.id = self.itemID
	self.toolID.count = self.singleGet
	_ENV, publicUtil, self.shopItemList, data.exLimit[1] = self.toolID, data.exLimit, data.exLimit, self.toolID
	self.toolID.id = self.toolID
	self.toolID.count = self.singleCount
	self.exchangeitemList, data.exLimit[1] = data.exLimit, self.toolID
	if self.toolID2 and self.singleCount2 then
		_ENV = self.singleCount
		self.singleCount.id = self.toolID2
		self.singleCount.count = self.singleCount2
		table.insert(self.exchangeitemList, self.singleCount)
	end
	self.fields.CheckBox_notify:setSelected(data.remindStatus == 1)
	self.fields.fromItemL:setNumItems(#self.exchangeitemList)
	self.fields.toItemL:setNumItems(#self.shopItemList)
	self.fields.Text_notify:setVisible(not otherData.hideTip)
	self.fields.CheckBox_notify:setVisible(not otherData.hideTip)
	self:setLeftCount(data.limitType, data.limitnum, self.curExchangeNum)
	self:updateExChangeStatus(data.limitType)
	self:setBtnExchangeStatus()
end
function ActExchangeSingle:updateExChangeStatus(limitType)
	self.exChangeStatus = 0
	if self.exLimit and self.exLimit[2] then
		if self.exLimit[1] == 2 and SoraDGetCastleLv() < self.exLimit[2] then
			self.exChangeStatus = 3
			return
		end
		local vipLv, isActive = SoraDGetVipLv()
		if self.exLimit[1] == 1 and (vipLv < self.exLimit[2] or vipLv == self.exLimit and not isActive) then
			self.exChangeStatus = 4
			return
		end
	end
	if limitType ~= 0 and self.curExchangeNum >= self.limitNum then
		self.exChangeStatus = 2
	else
		for _, v in ipairs(self.exchangeitemList) do
			local ownNum = publicUtil.getCount(v.id)
			if ownNum < v.count then
				self.exChangeStatus = 1
				break
			end
		end
	end
end
function ActExchangeSingle:setLeftCount(limitType, limitnum, curExchangeNum)
	if limitType == 0 or limitnum == 0 then
		self.Text_leftCount:setString("")
	else
		self.leftCount = math.max(0, limitnum - curExchangeNum)
		local countStr = string.format("%d/%d", self.leftCount, limitnum)
		if limitType == 1 then
			_ENV = nil
			;(nil).count = countStr
			self.Text_leftCount:setString(i18n("exchange_columntext_01", nil))
		elseif limitType == 3 then
			_ENV = i18n("exchange_columntext_01", nil)
			i18n("exchange_columntext_01", nil).count = countStr
			self.Text_leftCount:setString(i18n("exchange_columntext_02", i18n("exchange_columntext_01", nil)))
		else
			_ENV = i18n("exchange_columntext_02", i18n("exchange_columntext_01", nil))
			i18n("exchange_columntext_02", i18n("exchange_columntext_01", nil)).count = countStr
			self.Text_leftCount:setString(i18n("common_text_1673", i18n("exchange_columntext_02", i18n("exchange_columntext_01", nil))))
		end
	end
end
function ActExchangeSingle:setBtnExchangeStatus()
	self.Text_leftCount:setColor(cc.c3b(255, 255, 255))
	if self.exChangeStatus == 0 then
		self.Button_exchange:setGrayed(false)
		self.Button_exchange:setTitleColor(cc.c3b(255, 255, 255))
	elseif self.exChangeStatus == 1 then
		self.Button_exchange:setGrayed(false)
		self.Button_exchange:setTitleColor(cc.c3b(255, 0, 0))
	elseif self.exChangeStatus == 2 then
		self.Text_leftCount:setColor(cc.c3b(255, 0, 0))
		self.Button_exchange:setGrayed(true)
		self.Button_exchange:setTitleColor(cc.c3b(115, 115, 115))
	else
		self.Button_exchange:setGrayed(false)
		self.Button_exchange:setTitleColor(cc.c3b(255, 0, 0))
	end
end
function ActExchangeSingle:onBtnCallBack(context)
	SoraDPlaySound()
	if self.exChangeStatus == 2 then
		if self.activityID == gActivityTimeActivityID.NEBULA_SURPRISED_DROP_STORE then
			SoraDShowMsgTip(i18n("emission_nebulae_text_8"))
		else
			SoraDShowMsgTip(i18n("common_text_1865"))
		end
	elseif self.exChangeStatus == 3 then
		_ENV = i18n("common_text_1865")
		i18n("common_text_1865").lv = buildLogic.getBuildLvStr(self.exLimit[2])
		SoraDShowMsgTip(i18n("common_text_1973", i18n("common_text_1865")))
	elseif self.exChangeStatus == 4 then
		SoraDShowMsgTip(i18n("common_text_1147"))
	elseif self.exChangeStatus == 1 then
		if self.activityID == gActivityTimeActivityID.NEBULA_SURPRISED_DROP_STORE then
			SoraDShowMsgTip(i18n("emission_nebulae_text_7"))
		elseif self.activityID == gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001653 then
			SoraDShowMsgTip(i18n("Divine_beast_mark_text_79"))
		else
			SoraDShowMsgTip(i18n("common_text_2512"))
		end
	elseif #self.shopItemList == 1 and #self.exchangeitemList == 1 then
		local maxNum = math.floor(self.ownCount / self.singleCount)
		local tempItemID = self.itemID
		if self.leftCount and self.leftCount > 0 then
			maxNum = math.min(math.floor(self.ownCount / self.singleCount), self.leftCount)
		end
		_ENV, _ENV, _ENV = i18n("common_text_2512")
		i18n("common_text_2512").targetID = self.itemID
		i18n("common_text_2512").exchangeID = self.toolID
		i18n("common_text_2512").singCount = self.singleCount
		i18n("common_text_2512").curNum = maxNum
		i18n("common_text_2512").exchangeData, i18n("common_text_2512").singleGet = i18n("common_text_2512")
		self.singleCount.exchangeCfg, i18n("common_text_2512").exchangeHandler = i18n("common_text_2512")
		uiManager:show("newShopSingleBuy", self.singleCount)
	else
		_ENV = uiManager
		uiManager.shopItemList = self.shopItemList
		uiManager.exchangeItemList = self.exchangeitemList
		uiManager.leftCount = self.leftCount
		function uiManager.exchangeHandler(exchangeNum)
			activityExchangeMallCtrl:reqActivityExchange(self.shopItemID, exchangeNum)
		end
		uiManager:show("ShopSingleMoreBuy", uiManager)
	end
end
function ActExchangeSingle:onCheckBoxCallBack(context)
	if self.CheckBox_notify:isSelected() then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 1)
	elseif not self.CheckBox_notify:isSelected() then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 0)
	end
end
function ActExchangeSingle:onToItemRender(index, object)
	local itemInfo = self.shopItemList[index + 1]
	object:initData(itemInfo.id, itemInfo.count)
end
function ActExchangeSingle:onFromItemRender(index, object)
	local itemID = self.exchangeitemList[index + 1].id
	local needNum = self.exchangeitemList[index + 1].count
	dump(itemID, "ActExchangeSingle:onFromItemRender")
	local ownNum = publicUtil.getCount(itemID)
	object:initData(itemID)
	local stringColor = "#FFFFFF"
	if needNum > ownNum then
		stringColor = "#BE2828"
	else
		stringColor = "#36bf36"
	end
	object:setNum(ownNum, needNum, stringColor)
end
return ActExchangeSingle
