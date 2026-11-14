local itemDesRead = include("itemDesRead")
local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local exchangeDataModuleAPI = include("exchangeDataModuleAPI")
local publicRead = include("publicRead")
local newKingExchangeAwardView = class("newKingExchangeAwardView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("newKingExchangeAwardView")
	end
	return target
end)
function newKingExchangeAwardView:ctor()
	self:bindBtnClose()
	self.exchangeID = nil
	self.singleArray, _ENV, self.exchangeList, _ENV, self.exchangeCount = self.bindBtnClose, self.bindBtnClose, self.bindBtnClose, self.bindBtnClose, 0
	self.title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_exchangeAward")
	self.title:setTitle(i18n("xwjq_text_01"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_exchange")
	self.panel_single = SoraDGetChildByName(self, "Panel_single")
	SoraDAddMessage(self, "MESSAGE_ITEM_EXCHANGE_REFRESH", handler(self, self.updateView))
	self.text_now_have = SoraDGetChildByName(self, "Text_now_have")
	self.text_now_have:setString(i18n("palace_text_19"))
	self.text_num = SoraDGetChildByName(self, "Text_num")
	self.text_desc = SoraDGetChildByName(self, "Text_desc")
	self.text_desc:setString(i18n("xwjq_text_02"))
	self.img_icon = SoraDGetChildByName(self, "Image_icon")
end
function newKingExchangeAwardView:initData(exchangeID)
	self.exchangeID = exchangeID
	self.exchangeCount = backpackCtrl:getItemCount(self.exchangeID)
	self.exchangeList = exchangeDataModuleAPI:getExchangeList(self.exchangeID)
	self:initView()
end
function newKingExchangeAwardView:initView()
	local nums = table.nums(self.exchangeList)
	local singleHeight = 160
	local scrollH = math.max(self.scroll:getContentSize().height, singleHeight * nums)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	for k, v in ipairs(self.exchangeList) do
		local single = self:getSingle()
		single:setPosition(cc.p(self.scroll:getContentSize().width / 2, scrollH - singleHeight * k))
		single.setBtnFrom(v.useItem[1])
		single.setBtnTo(v.result[1])
		single.setBtnLimitText(v)
		single.exchangeID = v.exchangeID
		single:addTo(self.scroll)
		self.singleArray[k] = single
	end
	self.text_num:setString(self.exchangeCount)
	self.img_icon:loadTexture(publicRead.getIcon(self.exchangeID), ccui.TextureResType.plistType)
	if self.text_num:getAnchorPoint().x == 0 then
		self.img_icon:setPositionX(self.text_now_have:getPositionX() + self.text_now_have:getContentSize().width + self.img_icon:getContentSize().width / 2)
		self.text_num:setPositionX(self.img_icon:getPositionX() + self.img_icon:getContentSize().width / 2 + 5)
	else
		self.img_icon:setPositionX(self.text_now_have:getPositionX() - self.text_now_have:getContentSize().width - self.img_icon:getContentSize().width / 2)
		self.text_num:setPositionX(self.img_icon:getPositionX() - self.img_icon:getContentSize().width / 2 - 5)
	end
end
function newKingExchangeAwardView:updateView(target, data)
	SoraDCloseLoading(self)
	self.exchangeCount = backpackCtrl:getItemCount(self.exchangeID)
	for k, v in ipairs(self.singleArray) do
		v.setBtnFrom(self.exchangeList[k].useItem[1])
		v.setBtnTo(self.exchangeList[k].result[1])
		v.setBtnLimitText(self.exchangeList[k])
		v.exchangeID = self.exchangeList[k].exchangeID
	end
	if data.err and data.err == gErrDef.Err_None and data.result then
		SoraDPopGainItem(data.result.id, data.result.count)
	end
end
function newKingExchangeAwardView:getSingle()
	local single = self.panel_single:clone()
	local limitText = SoraDGetChildByName(single, "Text_Limit")
	limitText:setColor(cc.c3b(215, 195, 155))
	local btn_exchange = SoraDGetChildByName(single, "Button_exchange")
	btn_exchange:setTitleText(i18n("common_text_1889"))
	btn_exchange:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			SoraDPlaySound()
			if single.isLimitExchange then
				SoraDShowMsgTip(i18n("common_text_1865"))
				return
			end
			if single.isCanExchange then
				local newKingRisesCtrl = serviceFunctions.getModule("newKingRisesCtrl")
				local exchangeData = newKingRisesCtrl:getExchangeNum(single.fromInfo.index)
				local maxNum = math.min(math.floor(self.exchangeCount / single.fromInfo.count), single.leftExchangeNum)
				_ENV, _ENV, _ENV = i18n("common_text_1865")
				i18n("common_text_1865").targetID = single.toID
				i18n("common_text_1865").exchangeID = single.fromID
				i18n("common_text_1865").singCount = single.fromInfo.count
				i18n("common_text_1865").exchangeData, i18n("common_text_1865").curNum = i18n("common_text_1865")
				i18n("common_text_1865").exchangeCfg, i18n("common_text_1865").exchangeHandler = i18n("common_text_1865")
				uiManager:show("newShopSingleBuy", i18n("common_text_1865"))
			else
				_ENV = uiManager.show
				uiManager.show.item = publicRead.getName(single.fromID)
				SoraDShowMsgTip(i18n("common_text_1806", uiManager.show))
			end
		end
	end)
	local btn_from = SoraDGetChildByName(single, "Button_from")
	btn_from:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended or event == ccui.TouchEventType.canceled then
			if single.tips then
				single.tips:removeFromParent()
				single.tips = nil
			end
		elseif event == ccui.TouchEventType.began then
			SoraDPlaySound()
			if single.tips then
				single.tips:removeFromParent()
				single.tips = nil
			end
			single.tips = SoraDCreatePanel("commonItemTips")
			single.tips:initData(single.fromID)
			single.tips:setPosition(cc.p(150, 150))
			if SoraDFIsRA() then
				single.tips:setPosition(cc.p(480, 150))
			end
			single.tips:addTo(single, 99)
		end
	end)
	local btn_to = SoraDGetChildByName(single, "Button_to")
	btn_to:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended or event == ccui.TouchEventType.canceled then
			if single.tips then
				single.tips:removeFromParent()
				single.tips = nil
			end
		elseif event == ccui.TouchEventType.began then
			SoraDPlaySound()
			if single.tips then
				single.tips:removeFromParent()
				single.tips = nil
			end
			single.tips = SoraDCreatePanel("commonItemTips")
			single.tips:initData(single.toID)
			single.tips:setPosition(cc.p(10, 150))
			if SoraDFIsRA() then
				single.tips:setPosition(cc.p(620, 150))
			end
			single.tips:addTo(single, 99)
		end
	end)
	function single.setBtnFrom(info)
		single.fromID = info.id
		single.fromInfo = info
		local item_bg = SoraDGetChildByName(btn_from, "Image_item_bg")
		local item = SoraDGetChildByName(btn_from, "Image_item")
		local text_cur = SoraDGetChildByName(btn_from, "Text_cur_count")
		local text_count = SoraDGetChildByName(btn_from, "Text_count")
		local labNum = SoraDGetChildByName(btn_from, "Text_LabNum")
		local spriteNumBg = SoraDGetChildByName(btn_from, "frame_sheer_black")
		item_bg:loadTexture(publicRead.getBg(info.id), ccui.TextureResType.plistType)
		item:loadTexture(publicRead.getIcon(info.id), ccui.TextureResType.plistType)
		text_cur:setString(self.exchangeCount)
		text_count:setString("/" .. info.count)
		if self.exchangeCount < info.count then
			text_cur:setColor(cc.c3b(190, 40, 40))
		else
			text_cur:setColor(cc.c3b(255, 255, 255))
		end
		text_cur:setPositionX(10)
		text_count:setPositionX(text_cur:getPositionX() + text_cur:getContentSize().width)
		if not SoraDFIsRA() then
			text_count:setPositionX(100)
			text_cur:setPositionX(text_count:getPositionX() - text_count:getContentSize().width)
		end
		single.setBtnExchange(self.exchangeCount >= info.count)
		if labNum then
			local num = itemDesRead.getNumByID(info.id)
			if num then
				spriteNumBg:setVisible(true)
				labNum:setVisible(true)
				labNum:setString(num)
			else
				spriteNumBg:setVisible(false)
				labNum:setVisible(false)
			end
		end
	end
	function single.setBtnTo(info)
		single.toID = info.id
		single.toInfo = info
		local item_bg = SoraDGetChildByName(btn_to, "Image_item_bg")
		local item = SoraDGetChildByName(btn_to, "Image_item")
		local text_count = SoraDGetChildByName(btn_to, "Text_count")
		local labNum = SoraDGetChildByName(btn_to, "Text_LabNum")
		local spriteNumBg = SoraDGetChildByName(btn_to, "frame_sheer_black")
		item_bg:loadTexture(publicRead.getBg(info.id), ccui.TextureResType.plistType)
		item:loadTexture(publicRead.getIcon(info.id), ccui.TextureResType.plistType)
		text_count:setString(info.count)
		if labNum then
			local num = itemDesRead.getNumByID(info.id)
			if num then
				spriteNumBg:setVisible(true)
				labNum:setVisible(true)
				labNum:setString(num)
			else
				spriteNumBg:setVisible(false)
				labNum:setVisible(false)
			end
		end
	end
	function single.setBtnExchange(isCanExchange)
		single.isCanExchange = isCanExchange
		btn_exchange:setBright(isCanExchange)
		if isCanExchange then
			btn_exchange:setTitleColor(cc.c3b(255, 255, 255))
		else
			btn_exchange:setTitleColor(cc.c3b(200, 200, 200))
		end
	end
	function single.setBtnLimitText(info)
		if not info.limit then
			return
		end
		local newKingRisesCtrl = serviceFunctions.getModule("newKingRisesCtrl")
		local exchangeData = newKingRisesCtrl:getExchangeNum(info.index)
		single.isLimitExchange = tonumber(exchangeData) >= tonumber(info.limit)
		single.leftExchangeNum = info.limit - exchangeData
		if single.isLimitExchange then
			btn_exchange:setTitleColor(cc.c3b(190, 40, 40))
		end
		_ENV = cc.c3b(190, 40, 40)
		cc.c3b(190, 40, 40).cur = exchangeData
		cc.c3b(190, 40, 40).total = info.limit
		limitText:setString(i18n("common_text_4417", cc.c3b(190, 40, 40)))
		limitText:setFontSize(16)
	end
	return single
end
return newKingExchangeAwardView
