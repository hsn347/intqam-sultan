local gametop = gModuleMgr.getObject("gametop")
local GridScrollView = include("GridScrollView")
local devilValleyCtrl = gametop.playertop_:getModule("devilValleyCtrl")
local publicRead = include("publicRead")
local newTrialStoreView = class("newTrialStoreView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("newTrialStoreView")
	end
	return target
end)
function newTrialStoreView:ctor()
	self:initWidget()
	self:initData()
	SoraDAddMessage(self, "MESSAGE_NEWTRIAL_STORE_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		if data.reward and next(data.reward) then
			local _ENV, itemData = next(data.reward), next(data.reward)
			itemData[data.reward.id] = data.reward.count
			SoraDMailGainItems(itemData)
		end
		self:initData()
	end)
end
function newTrialStoreView:initWidget()
	self.panel_single = SoraDGetChildByName(self, "panel_single")
	self.scroll = SoraDGetChildByName(self, "Top_Size_scroll_win_rewards")
	self.scroll = GridScrollView.new(self.scroll)
	_ENV = "Top_Size_scroll_win_rewards"
	;("Top_Size_scroll_win_rewards").col = 1
	;("Top_Size_scroll_win_rewards").top = 5
	;("Top_Size_scroll_win_rewards").left = 0
	self.scroll:init("Top_Size_scroll_win_rewards", 0, handler(self, self.createCell), handler(self, self.updateCell))
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_oab")
	self.ccs_title:setTitle(i18n("devilvalley_text_32"))
	self.ccs_title:setTitleSize(cc.size(340, 40))
	_UPVALUE2_ = cc.size(340, 40)
	cc.size(340, 40)[1] = "Node_coin"
	cc.size(340, 40)[2] = "Button_coin"
	self.Button_coin = SoraDGetChildByFullPath(self.ccs_title, cc.size(340, 40))
	self.Button_coin:addTouchEventListener(handler(self, self.btnCoinCallback))
	_UPVALUE2_ = handler(self, self.btnCoinCallback)
	handler(self, self.btnCoinCallback)[1] = "Node_coin"
	handler(self, self.btnCoinCallback)[2] = "Text_coin_num"
	self.Text_coin_num = SoraDGetChildByFullPath(self.ccs_title, handler(self, self.btnCoinCallback))
	GridScrollView = handler(self, self.btnCoinCallback)
	handler(self, self.btnCoinCallback)[1] = "Text_title"
	self.Text_title = SoraDGetChildByFullPath(self.Top_Node, handler(self, self.btnCoinCallback))
	self.Text_title:setString(i18n("devilvalley_text_41"))
	GridScrollView = i18n("devilvalley_text_41")
	i18n("devilvalley_text_41")[1] = "Image_top"
	self.Image_top = SoraDGetChildByFullPath(self.Top_Node, i18n("devilvalley_text_41"))
	GridScrollView = i18n("devilvalley_text_41")
	i18n("devilvalley_text_41")[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(self.ccs_title, i18n("devilvalley_text_41"))
	self.Button_help:addTouchEventListener(handler(self, self.btnClickCallback))
	SoraChangeSpriteImage(self.Image_top, "bg_recharge_gold.png")
	self.Button_help:setVisible(IsArClient)
end
function newTrialStoreView:initData()
	self.point = devilValleyCtrl:getPoint()
	self.shopInfo = devilValleyCtrl:getShopInfo()
	self.Text_coin_num:setString(self.point)
	self:initScroll()
end
function newTrialStoreView:btnCoinCallback(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
end
function newTrialStoreView:btnClickCallback(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if button == self.Button_help then
		if IsArClient then
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.NEW_TRIAL)
		else
			userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.NEW_TRIAL_EN)
		end
	end
end
function newTrialStoreView:initScroll()
	self.scroll:updateNum(#self.shopInfo)
end
function newTrialStoreView:createCell()
	local cell = self:createItemSingle()
	return cell
end
function newTrialStoreView:updateCell(panel, i)
	local data = self.shopInfo[i]
	panel.initData(data)
end
function newTrialStoreView:createItemSingle()
	local item = self.panel_single:clone()
	publicRead = nil
	;(nil)[1] = "text_limit"
	item.text_limit = SoraDGetChildByFullPath(item, nil)
	publicRead = nil
	;(nil)[1] = "text_des"
	item.text_des = SoraDGetChildByFullPath(item, nil)
	publicRead = nil
	;(nil)[1] = "btn_buy"
	item.btn_buy = SoraDGetChildByFullPath(item, nil)
	item.btn_buy:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		if not button:isBright() then
			local cur = item.data.limitNum - item.data.exchangeCount
			if cur <= 0 then
				SoraDShowMsgTip(i18n("devilvalley_text_54"))
			elseif self.point < item.data.costCount then
				SoraDShowMsgTip(i18n("devilvalley_text_55"))
			end
		else
			self:showBuyView(item)
		end
	end)
	function publicRead(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		if not button:isBright() then
			local cur = item.data.limitNum - item.data.exchangeCount
			if cur <= 0 then
				SoraDShowMsgTip(i18n("devilvalley_text_54"))
			elseif self.point < item.data.costCount then
				SoraDShowMsgTip(i18n("devilvalley_text_55"))
			end
		else
			self:showBuyView(item)
		end
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		if not button:isBright() then
			local cur = item.data.limitNum - item.data.exchangeCount
			if cur <= 0 then
				SoraDShowMsgTip(i18n("devilvalley_text_54"))
			elseif self.point < item.data.costCount then
				SoraDShowMsgTip(i18n("devilvalley_text_55"))
			end
		else
			self:showBuyView(item)
		end
	end)[1] = "text_gold"
	item.text_gold = SoraDGetChildByFullPath(item.btn_buy, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		if not button:isBright() then
			local cur = item.data.limitNum - item.data.exchangeCount
			if cur <= 0 then
				SoraDShowMsgTip(i18n("devilvalley_text_54"))
			elseif self.point < item.data.costCount then
				SoraDShowMsgTip(i18n("devilvalley_text_55"))
			end
		else
			self:showBuyView(item)
		end
	end)
	local cell = SoraDCreatePanel("eventGeocentricCell")
	item.cell = cell
	cell:addTo(item)
	cell:setPositionY(103)
	cell:setPositionX(SoraDFIsRA() and 615 or 25)
	cell:sendParentToButton(self)
	cell:setScale(0.8)
	function item.initData(data)
		item.data = data
		local cur = data.limitNum - data.exchangeCount
		if cur <= 0 then
			cur = 0
		end
		item = nil
		;(nil).cur = cur
		;(nil).total = data.limitNum
		item.text_limit:setString(i18n("common_text_4417", nil))
		item.text_des:setString(publicRead.getName(data.id))
		item.text_gold:setString(data.costCount)
		if self.point < data.costCount then
			item.text_gold:setColor(cc.c3b(255, 0, 0))
			item.btn_buy:setBright(false)
		elseif cur <= 0 then
			item.text_gold:setColor(cc.c3b(255, 255, 0))
			item.btn_buy:setBright(false)
		else
			item.text_gold:setColor(cc.c3b(255, 255, 0))
			item.btn_buy:setBright(true)
		end
		item.cell:initData(data.id, data.count)
	end
	return item
end
function newTrialStoreView:showBuyView(item)
	local itemdata = item.data
	local needNum = itemdata.costCount
	local total = itemdata.limitNum
	local cur = itemdata.exchangeCount
	local maxCount = total - cur
	local canBuyCount = math.floor(devilValleyCtrl:getPoint() / needNum)
	maxCount = math.min(maxCount, canBuyCount)
	_ENV, _ENV, _ENV = nil, nil, nil
	;(nil).targetID = itemdata.id
	;(nil).exchangeID = gIDType.DEVIL_VALLEY_POINT
	;(nil).singCount = needNum
	;(nil).exchangeData, (nil).curNum = nil, maxCount
	;(nil).exchangeCfg, (nil).exchangeHandler = nil, function(num)
		print("选择了数量:", num)
		devilValleyCtrl:sendReqExchange(item.data.id, num)
		SoraDShowLoading(self)
	end
	uiManager:show("newShopSingleBuy", nil)
end
return newTrialStoreView
