local gametop = gModuleMgr.getObject("gametop")
local ladderGiftCtrl = gametop.playertop_:getModule("ladderGiftCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local LevelUpInfoList = require("app." .. LocalTblPath .. ".config_server.grownup_found_config")
local eventValueRebateView = class("eventValueRebateView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventValueRebateView_new")
	end
	return target
end)
function eventValueRebateView:ctor()
	self.packageList = ladderGiftCtrl:getGrowUpLadderGiftList()
	self.packageID = self.packageList[1].ID
	self.packagePrice = self.packageList[1].price
	self.packagePrice = paymentManager.judgePrice(self.packageID, self.packagePrice)
	self.itemList, ladderGiftCtrl, self.infoList = self:getLevelUpInfoList(), self:getLevelUpInfoList(), self:getLevelUpInfoList()
	self:initControls()
	self:initData()
end
function eventValueRebateView:initControls()
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView")
	self.Panel_total = SoraDGetChildByName(self, "Panel_total")
	self.Text_tips = SoraDGetChildByName(self, "Text_tips")
	self.Text_total = SoraDGetChildByName(self, "Text_total")
	self.Button_buy = SoraDGetChildByName(self, "Button_buy")
	self.Text_nowPrice = SoraDGetChildByName(self, "Text_nowPrice")
	self.Node_gold = SoraDGetChildByName(self, "Node_gold")
	self.Panel_single = SoraDGetChildByName(self, "Panel_single")
	self.ccs_title:setTitle(i18n("activity_name_26"))
	self.Button_buy:addTouchEventListener(handler(self, self.btnBuyClick))
	self:initTotalGold()
	self.Text_tips:setString(i18n("Gather_text_16"))
	self.Text_total:setString(i18n("Gather_text_15"))
	local textWidth = self.Text_total:getContentSize().width
	if 100 < textWidth then
		textWidth = 100
		SoraDSetTextWidthHeight(self.Text_total, cc.size(textWidth, 40))
	end
	self.Node_gold:setPositionX(self.Text_total:getPositionX() + SoraDFSign(textWidth + 100))
	self:initScroll()
	SoraDCreatAnimation("eventValueRebateView_new", self._ccsView, true)
end
function eventValueRebateView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_VALUE_REBATE_BUY_REFRESH", function(...)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_VALUE_REBATE_RECEIVE_REFRESH", function(...)
		self.infoList = self:getLevelUpInfoList()
		self:refreshScroll()
		self:judgeClose()
	end)
end
function eventValueRebateView:initData()
	self.hasBuy = ladderGiftCtrl:getGrowUpBuyRecord(self.packageID)
	if self.hasBuy then
		self.Text_nowPrice:setString(i18n("common_text_3833"))
		self.Button_buy:setTouchEnabled(false)
	else
		self.Text_nowPrice:setString(self.packagePrice)
		self.Button_buy:setBright(true)
	end
	self:refreshScroll()
	ladderGiftCtrl, _ENV = true, self
	;(true).rechargeID = self.packageID
	self[1] = true
	SoraDCreateRechargeGiftNode(self, SoraDGetChildByName(self, "Panel_cut"), cc.p(SoraDFPosX(60), 70))
end
function eventValueRebateView:initScroll()
	local sSize = self.scroll:getContentSize()
	self.itemH = self.Panel_single:getContentSize().height
	local scrollH = math.max(sSize.height, self.itemH * math.ceil(#self.infoList))
	self.scroll:setInnerContainerSize(cc.size(sSize.width, scrollH))
	for i, v in ipairs(self.infoList) do
		local item = self:createItem()
		item:addTo(self.scroll)
		item:setPosition(0, scrollH - i * self.itemH)
		table.insert(self.itemList, item)
	end
end
function eventValueRebateView:refreshScroll()
	for i, item in ipairs(self.itemList) do
		self:refreshSingle(item, i)
	end
end
function eventValueRebateView:createItem(...)
	local item = self.Panel_single:clone()
	item.Button_receive = SoraDGetChildByName(item, "Button_receive")
	item.Button_receive:addTouchEventListener(handler(self, self.btnReceiveClick))
	SoraDAutoSizeButtonTextByContent(item.Button_receive)
	item.Text_condition = SoraDChangeTextToHtml(SoraDGetChildByName(item, "Text_condition"))
	item.Text_gold = SoraDGetChildByName(item, "BitmapFontLabel_8")
	item.Image_box = SoraDGetChildByName(item, "Image_box")
	local boxEffect = SoraDCreatAnimation("czflBox")
	boxEffect:addTo(item)
	local x, y = item.Image_box:getPosition()
	boxEffect:setPosition(x, y)
	boxEffect:setVisible(false)
	item.boxEffect = boxEffect
	return item
end
function eventValueRebateView:btnReceiveClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button.isReach then
			ladderGiftCtrl:receiveGrowUpReward(self.packageID, button.needCastleLv)
		else
			SoraDShowMsgTip(i18n("remains_text_20"))
		end
	end
end
function eventValueRebateView:refreshSingle(item, index)
	local data = self.infoList[index]
	local needCastleLv = data.castleLevel
	local curCastleLv = math.min(SoraDGetCastleLv(), CASTLE_MAXLV_NOWAR)
	local isReach = needCastleLv <= curCastleLv
	item.Button_receive.isReach = isReach
	item.Button_receive.needCastleLv = needCastleLv
	local hasReceive = data.hasReceive
	local goldNum = data.reward[2] or 0
	item.Text_gold:setString(string.formatnumberthousands(goldNum))
	item.Button_receive:setTag(index)
	if not self.hasBuy then
		item.Button_receive:setTouchEnabled(false)
		item.Button_receive:setTitleText(i18n("common_text_1146"))
	else
		item.Button_receive:setTouchEnabled(true)
		if isReach then
			if not hasReceive then
				item.Button_receive:setTitleText(i18n("common_text_1146"))
			else
				item.Button_receive:setTitleText(i18n("common_text_1892"))
				item.Button_receive:setTouchEnabled(false)
			end
			item.Button_receive:setTitleColor(display.COLOR_WHITE)
		else
			item.Button_receive:setTitleText(i18n("common_text_2274"))
			item.Button_receive:setTitleColor(display.COLOR_RED)
		end
	end
	local str
	local textColor = cc.c3b(215, 195, 155)
	if isReach then
		item.Text_condition:setColor(textColor)
		_ENV = textColor
		textColor.num = curCastleLv
		textColor.num1 = needCastleLv
		str = i18n("Gather_text_17", textColor)
	else
		item.Text_condition:setColor(display.COLOR_WHITE)
		_ENV = display.COLOR_WHITE
		display.COLOR_WHITE.num = curCastleLv
		_ENV, _ENV, display.COLOR_WHITE.num1 = i18n("common_text_2274")
		_ENV, i18n("common_text_2274").num, i18n("common_text_2274").color = i18n("common_text_2274")
		i18n("common_text_2274").__default, i18n("common_text_2274").color = i18n("common_text_2274")
		str = i18n_html("Gather_text_17", display.COLOR_WHITE, i18n("common_text_2274"))
	end
	item.Text_condition:setString(str)
	if self.hasBuy and isReach then
		if hasReceive then
			item.Image_box:loadTexture("icon_coinbox_clear.png", ccui.TextureResType.plistType)
			item.boxEffect:setVisible(false)
		else
			item.Image_box:loadTexture("icon_coinbox_open.png", ccui.TextureResType.plistType)
			item.boxEffect:setVisible(true)
		end
		item.Image_box:setPositionY(self.itemH / 2)
	else
		item.Image_box:loadTexture("icon_coinbox_close.png", ccui.TextureResType.plistType)
		item.Image_box:setPositionY(self.itemH / 2 + 10)
		item.boxEffect:setVisible(false)
	end
end
function eventValueRebateView:getLevelUpInfoList()
	local _ENV, tbl
	for i, v in ipairs(LevelUpInfoList) do
		if v.type == 2 then
			local _ENV, temp = v.type, v.type
			for k, w in pairs(v) do
				temp[k] = w
			end
			if ladderGiftCtrl:getGrowUpReceive(self.packageID, v.castleLevel) then
				temp.hasReceive = true
			else
				temp.hasReceive = false
			end
			table.insert(tbl, temp)
		end
	end
	table.sort(tbl, function(a, b)
		if a.hasReceive ~= b.hasReceive then
			return b.hasReceive
		else
			return a.castleLevel < b.castleLevel
		end
	end)
	dump(tbl, "==tbl==")
	return tbl
end
function eventValueRebateView:btnBuyClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		paymentManager.normalGiftBuyClassify(self.packageID)
	end
end
function eventValueRebateView:judgeClose()
	if not ladderGiftCtrl:getGrowUpHasEnter() then
		self:removeFromParent()
	end
end
function eventValueRebateView:initTotalGold(...)
	local total_gold = 0
	if not self.infoList then
		_ENV = self.infoList
	end
	for k, v in pairs(self.infoList) do
		if v.reward and v.reward[1] == 1001 then
			total_gold = total_gold + v.reward[2]
		end
	end
	local getNumIcon = function(num)
		if num == "," then
			num = 11
		end
		num = tonumber(num)
		if num == 0 then
			num = 10
		end
		return string.format("#frame_hzlh_num_%.2d.png", num)
	end
	local _ENV, table_name = pairs(self.infoList)
	total_gold = string.formatnumberthousands(total_gold)
	local count = #tostring(total_gold)
	for i = 1, count do
		table_name[i] = string.sub(tostring(total_gold), i, i)
	end
	for i, v in ipairs(table_name) do
		local sprite = display.newSprite(getNumIcon(v))
		sprite:setPosition(cc.p(SoraDFIsRA() and (i - 1) * 28 or (i - count) * 28, 0))
		sprite:setScale(0.7)
		sprite:addTo(self.Node_gold)
	end
end
return eventValueRebateView
