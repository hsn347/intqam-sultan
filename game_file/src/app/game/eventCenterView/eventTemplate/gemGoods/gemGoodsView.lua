local gemGoodsCtrl = SoraDGetCtrl("gemGoodsCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local constantRead = include("constantRead")
local gemGoodsView = class("gemGoodsView", function(target)
	return target or SoraDCreateBasePanel("gemGoodsView")
end)
local MAX_CHOOSE_COUNT = 6
function gemGoodsView:ctor()
	self.itemID = gemGoodsCtrl.itemID
	self.activityID = gemGoodsCtrl.activityID
	self.goldCount = lordInfoCtrl:getBaseInfo().gold
	self.itemCount = backpackCtrl:getItemCount(self.itemID)
	self:initWidget()
	SoraDShowLoading(self)
	gemGoodsCtrl:reqGemGoodsInit()
	self:showRefreshing(true)
	self:initSpine()
	self:refreshItemCount()
	SoraDCreatAnimation(self.__cname, self, true)
end
function gemGoodsView:initWidget()
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_bg")
	self.ccs_title:setTitle(i18n("activity_name_9001261"))
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.scroll = self.ScrollView_items
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
		SoraDToCenter(self.Node_time, nil, not SoraDFIsRA())
	end
	self.Button_refresh:addTouchEventListener(handler(self, self.OnClickRefresh))
	self.Button_buy:addTouchEventListener(handler(self, self.OnClickBuy))
	self.Button_buy:setScale9Enabled(true)
	self.Button_buy:setCapInsets(cc.rect(81, 26, 124, 28))
	self.Text_left = SoraDChangeTextToHtml(self.Text_left)
	self.Button_add:addTouchEventListener(handler(self, self.OnClickJump))
	self.Button_chouti:addTouchEventListener(handler(self, self.OnClickChouti))
	self.Text_close:setString(i18n("dazzling_text_12"))
	SoraDSetTextWidthHeight(self.Text_refresh, cc.size(180, 26))
	for i, v in ipairs(self.Node_down:getChildren()) do
		v:setContentSize(cc.size(v:getContentSize().width, display.height - 176))
	end
	for i, v in ipairs(self.Node_close:getChildren()) do
		v:setContentSize(cc.size(v:getContentSize().width, display.height - 176))
	end
	self.Image_zhuzi1:setContentSize(cc.size(self.Image_zhuzi1:getContentSize().width, display.height - 330))
	self.Image_zhuzi2:setContentSize(cc.size(self.Image_zhuzi1:getContentSize().width, display.height - 330))
	local sSize = self.scroll:getContentSize()
	local innerSize = self.scroll:getInnerContainerSize()
	local scorllH = display.height - 1136 + sSize.height
	local topH, bottomH, contentH = 60, 320, 510
	local innerH = math.max(scorllH, contentH + bottomH + topH)
	self.Node_content:setPositionY(math.max(0, innerH - contentH - topH))
	self.scroll:setContentSize(cc.size(sSize.width, scorllH))
	self.scroll:setInnerContainerSize(cc.size(sSize.width, innerH))
	local spine_npc = sp.SkeletonAnimation:create("spine/goumailibao_renwu.skel", "spine/goumailibao_renwu.atlas", 1.15)
	spine_npc:setAnimation(0, "animation1", true)
	spine_npc:setPosition(cc.p(0, 0))
	spine_npc:addTo(self.Node_npc)
	if spine_npc.setAutoCull then
		spine_npc:setAutoCull(false)
	end
	if SoraDFIsRA() then
		self.Node_npc:setScaleX(-1)
	end
	_UPVALUE2_ = self.Node_npc
	self.Node_npc[1] = self.Node_old
	self.Node_npc[2] = self.Node_new
	for i, v in ipairs(self.Node_npc) do
		local Text_single = SoraDGetChildByName(v, "Text_single")
		SoraDSetTextWidthHeight(Text_single, cc.size(100, 100))
		Text_single:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		Text_single:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	end
end
function gemGoodsView:showRefreshing(isRefresh)
	self.Node_discount:setVisible(not isRefresh)
	self.Node_buy:setVisible(not isRefresh)
	self.Node_close:setVisible(isRefresh)
	self.Text_close:setVisible(isRefresh)
	self.Node_gold:setVisible(not isRefresh)
	self.Image_116:setVisible(false)
	self.Image_116_0:setVisible(false)
end
function gemGoodsView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_EVENT_GEMGODDS_INIT", handler(self, self.sMsgInitDataBack))
	SoraDAddMessage(self, "MESSAGE_EVENT_GEMGODDS_CHOOSE", handler(self, self.sMsgChooseBack))
	SoraDAddMessage(self, "MESSAGE_EVENT_GEMGODDS_REFRESH", handler(self, self.sMsgRefreshBack))
	SoraDAddMessage(self, "MESSAGE_EVENT_GEMGODDS_BUY", handler(self, self.sMsBuyBack))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshItemCount))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function()
		if not clientEventMgr.judgeIsOpen(self.activityID) then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
end
function gemGoodsView:sMsgInitDataBack(target, data)
	SoraDCloseLoading(self)
	self:showRefreshing(false)
	self.data = gemGoodsCtrl:getGemGoodsData()
	self.Node_line:setVisible(false)
	for i = 1, 3 do
		local line = self.Node_line:clone()
		line:addTo(self.Node_content)
		line:setVisible(true)
		line:setPosition(0, 35 + 165 * (i - 1))
	end
	self.Node_single:setVisible(false)
	self.itemList, _ENV = self.Node_single.setVisible, self.Node_single.setVisible
	local index = 1
	for i = 1, 9 do
		local single = self.Node_single:clone()
		single:addTo(self.Node_content)
		single:setVisible(true)
		local col = (index - 1) % 3 + 1
		local row = math.ceil(index / 3)
		single:setPosition(177 * SoraDFSign(2 - col), 437 - 165 * (row - 1))
		index = index + 1
		local Node_award = SoraDGetChildByName(single, "Node_award")
		local item = SoraDCreatePanel("commonItemAward")
		item:addTo(Node_award)
		item:setOwnView(self)
		item:setOwnScroll(self.scroll)
		item:setPosition(0, 0)
		item:setHandle(handler(self, self.singleClickBack))
		item:showNewCoolSquare()
		item:hideCoolSquare()
		single.item = item
		single.Button_item = item.Button_item
		single.Node_price = SoraDGetChildByName(single, "Node_price")
		single.Text_price = SoraDGetChildByName(single, "Text_price")
		single.Panel_noSelect = SoraDGetChildByName(single, "Panel_noSelect")
		table.insert(self.itemList, single)
	end
	self:refreshItems()
	self:refreshChoose()
	self:showFirstInAction()
end
function gemGoodsView:showFirstInAction(...)
	SoraDShowLoading(self)
	self:showRefreshing(true)
	self:initSpine()
	self.spine_cl:setVisible(true)
	self:showRefreshAction()
end
function gemGoodsView:initSpine(...)
	if not self.spine_cl then
		local spine_npc = sp.SkeletonAnimation:create("spine/chuanglianqiehuan.skel", "spine/chuanglianqiehuan.atlas", 1.0)
		spine_npc:setPosition(cc.p(320, -display.height + 180))
		spine_npc:addTo(self.Node_close)
		spine_npc:setScaleY(math.max(1.0, display.height / 1066))
		self.spine_cl = spine_npc
	end
end
function gemGoodsView:sMsgChooseBack(target, data)
	SoraDCloseLoading(self)
	self.data = gemGoodsCtrl:getGemGoodsData()
	self:refreshChoose()
end
function gemGoodsView:sMsgRefreshBack(target, data)
	self.data = gemGoodsCtrl:getGemGoodsData()
	self:refreshItemCount()
	self:refreshItems()
	self:refreshChoose()
	self.scroll:jumpToTop()
	self:showRefreshAction()
end
function gemGoodsView:sMsBuyBack(target, data)
	SoraDCloseLoading(self)
	self:showRefreshing(false)
	self.data = gemGoodsCtrl:getGemGoodsData()
	self:refreshChoose()
	local panel = SoraDCreatePanel("amazingFortuneResultPopView")
	panel:show()
	panel:initGemGoodsData(data.reward)
	panel:setExitHandle(handler(self, self.panelExitHandle))
end
function gemGoodsView:panelExitHandle(...)
	SoraDShowLoading(self)
	self:showRefreshing(true)
	self:initSpine()
	self.spine_cl:setVisible(true)
	self.spine_cl:setAnimation(0, "animation01", false)
	_UPVALUE1_ = "animation01"
	;("animation01")[1] = cca.delay(0.8)
	;("animation01")[2] = cca.callFunc(function()
		self:refreshItems()
		self.scroll:jumpToTop()
		self:showRefreshAction()
	end)
	;("animation01")[3] = cca.callFunc(function()
		self:refreshItems()
		self.scroll:jumpToTop()
		self:showRefreshAction()
	end)
	self.spine_cl:runAction(cca.seq("animation01"))
end
function gemGoodsView:refreshItems(...)
	for k, v in pairs(self.itemList) do
		v:setVisible(false)
	end
	local showList = table.values(self.data.curShowList)
	table.sort(showList)
	for i, v in ipairs(showList) do
		local config = gemGoodsCtrl:getGoodsDetail(v)
		local single = self.itemList[i]
		if config and single then
			single:setVisible(true)
			single.item:initData(config.content[1], config.content[2])
			single.Button_item:setTag(v)
			single.Text_price:setString(config.tokenprice)
			SoraDToCenter(single.Node_price, 5)
		end
	end
end
function gemGoodsView:refreshChoose(...)
	local needGay = table.nums(self.data.curChoose) >= MAX_CHOOSE_COUNT
	for k, v in pairs(self.itemList) do
		if table.keyof(self.data.curChoose, v.Button_item:getTag()) then
			v.item:showNewCoolSquare()
		else
			v.item:hideCoolSquare()
			v.Panel_noSelect:setVisible(needGay)
		end
	end
	if self.goldCount >= self.data.refreshCost then
		self.Text_refresh:setColor(cc.c3b(255, 255, 0))
	else
		self.Text_refresh:setColor(cc.c3b(255, 0, 0))
	end
	if self.data.refreshCost <= 0 then
		self.Text_refresh:setString(i18n("circus_text_23"))
	else
		self.Text_refresh:setString(self.data.refreshCost)
	end
	local max_count = constantRead.getConstValue("GEM_GOODS_MAX_BUY_COUNT", 10)
	local left_count = max_count - self.data.buyCount
	if left_count <= 0 then
		self.Button_buy:setBright(false)
		_ENV = i18n("circus_text_23")
		_ENV, _ENV, i18n("circus_text_23").num = i18n("circus_text_23")
		i18n("circus_text_23").num, i18n("circus_text_23").color = i18n("circus_text_23")
		self.Text_left:setString(i18n_html("dazzling_text_13", i18n("circus_text_23")))
		self.Node_Effect_lrhl01_004:setVisible(false)
	else
		_ENV = i18n_html("dazzling_text_13", i18n("circus_text_23"))
		_ENV, _ENV, i18n_html("dazzling_text_13", i18n("circus_text_23")).num = i18n_html("dazzling_text_13", i18n("circus_text_23"))
		i18n_html("dazzling_text_13", i18n("circus_text_23")).color = "#00FF00"
		i18n_html("dazzling_text_13", i18n("circus_text_23")).num, i18n_html("dazzling_text_13", i18n("circus_text_23")).size = i18n_html("dazzling_text_13", i18n("circus_text_23"))
		self.Text_left:setString(i18n_html("dazzling_text_13", i18n_html("dazzling_text_13", i18n("circus_text_23"))))
		self.Node_Effect_lrhl01_004:setVisible(true)
	end
	local velue = self.data.buyCost - self.data.buyOriCost
	self.Text_discount_value:setString(string.formatnumberthousands(velue))
	local percent = gemGoodsCtrl:getDiscount(table.nums(self.data.curChoose)) * 0.1
	self.Text_off:setString("%OFF")
	self.Node_new:setVisible(true)
	self.Node_old:setVisible(true)
	if not self.nowPercent then
		self.nowPercent = percent
		local Text_single = SoraDGetChildByName(self.Node_old, "Text_single")
		Text_single:setString(self.nowPercent)
	end
	if self.nowPercent ~= percent then
		local Text_single = SoraDGetChildByName(self.Node_new, "Text_single")
		Text_single:setString(percent)
		local Text_single = SoraDGetChildByName(self.Node_old, "Text_single")
		Text_single:setString(self.nowPercent)
		self.nowPercent = percent
		self.Node_new:stopAllActions()
		self.Node_old:stopAllActions()
		self.Node_new:setPositionY(102)
		self.Node_old:setPositionY(33)
		gemGoodsCtrl = table.nums(self.data.curChoose)
		table.nums(self.data.curChoose)[1] = cca.delay(0.05)
		table.nums(self.data.curChoose)[2] = cca.moveBy(0.13333333333333333, 0, -13)
		table.nums(self.data.curChoose)[3] = cca.moveBy(0.11666666666666667, 0, -58)
		table.nums(self.data.curChoose)[4] = cca.moveBy(0.2, 0, 2)
		table.nums(self.data.curChoose)[5] = cca.moveBy(0.2, 0, 2)
		table.nums(self.data.curChoose)[6] = cca.moveBy(0.2, 0, 2)
		table.nums(self.data.curChoose)[7] = cca.moveBy(0.2, 0, 2)
		self.Node_new:runAction(cca.seq(table.nums(self.data.curChoose)))
		MAX_CHOOSE_COUNT = cca.seq(table.nums(self.data.curChoose))
		cca.seq(table.nums(self.data.curChoose))[1] = cca.moveBy(0.13333333333333333, 0, -13)
		cca.seq(table.nums(self.data.curChoose))[2] = cca.moveBy(0.11666666666666667, 0, -56)
		cca.seq(table.nums(self.data.curChoose))[3] = cca.moveBy(0.11666666666666667, 0, -56)
		cca.seq(table.nums(self.data.curChoose))[4] = cca.moveBy(0.11666666666666667, 0, -56)
		cca.seq(table.nums(self.data.curChoose))[5] = cca.moveBy(0.11666666666666667, 0, -56)
		cca.seq(table.nums(self.data.curChoose))[6] = cca.moveBy(0.11666666666666667, 0, -56)
		cca.seq(table.nums(self.data.curChoose))[7] = cca.moveBy(0.11666666666666667, 0, -56)
		self.Node_old:runAction(cca.seq(cca.seq(table.nums(self.data.curChoose))))
	end
	self.Text_nowPrice:setString(string.formatnumberthousands(self.data.buyCost))
	self.Text_oldPrice:setString(string.formatnumberthousands(self.data.buyOriCost))
	local interval = self.data.buyOriCost == 0 and 10 or 0
	SoraDToCenter(self.Node_buyPrice, interval)
end
function gemGoodsView:refreshItemCount(...)
	self.goldCount = lordInfoCtrl:getBaseInfo().gold
	self.itemCount = backpackCtrl:getItemCount(self.itemID)
	self.Text_count:setString(string.formatnumberthousands(self.itemCount))
end
function gemGoodsView:btnHelpClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_3657"
		;("common_text_3657")[1] = i18n("dazzling_text_01")
		;("common_text_3657")[2] = i18n("dazzling_text_01")
		_ENV = i18n("dazzling_text_01")
		i18n("dazzling_text_01").hideBtn = true
		i18n("dazzling_text_01").autoHeight = true
		SoraDShowFixWindow(i18n("common_text_3657"), "common_text_3657", nil, i18n("dazzling_text_01"))
	end
end
function gemGoodsView:OnClickRefresh(target, eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if self.goldCount < self.data.refreshCost then
		SoraDShowMsgBox(i18n("common_text_423"), i18n("common_text_4347"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				if GLOBAL_GAME_RECHARGE_MODE then
					uiManager:show("rechargeView")
				else
					SoraDCreatePanel("rechargeView"):show()
				end
			end
		end)
		return
	end
	_ENV = i18n("common_text_4347")
	i18n("common_text_4347").byUID = true
	if SoraDConfigGet("Game:gemGoodsView:refreshTip~bool", (i18n("common_text_4347"))) then
		if self.data.refreshCost > 0 then
			_ENV = i18n("common_text_4347")
			i18n("common_text_4347").num = self.data.refreshCost
			if i18n("nationalDay_text_06", (i18n("common_text_4347"))) then
				goto lbl_48
			end
		end
		local lang = i18n("nationalDay_text_05")
		::lbl_48::
		local panel = SoraDCreatePanel("gemGoodsPopView")
		panel:initData(lang, false, function()
			if tolua.isnull(self) then
				return
			end
			SoraDShowLoading(self)
			self:showRefreshing(true)
			self:initSpine()
			self.spine_cl:setVisible(true)
			self.spine_cl:setAnimation(0, "animation01", false)
			self = "animation01"
			;("animation01")[1] = cca.delay(0.8)
			;("animation01")[2] = cca.callFunc(function()
				gemGoodsCtrl:reqGemGoodsRefresh()
			end)
			;("animation01")[3] = cca.callFunc(function()
				gemGoodsCtrl:reqGemGoodsRefresh()
			end)
			self.spine_cl:runAction(cca.seq("animation01"))
		end)
		panel:show()
	else
		SoraDShowLoading(self)
		self:showRefreshing(true)
		self:initSpine()
		self.spine_cl:setVisible(true)
		self.spine_cl:setAnimation(0, "animation01", false)
		gemGoodsCtrl = "animation01"
		;("animation01")[1] = cca.delay(0.8)
		;("animation01")[2] = cca.callFunc(function()
			gemGoodsCtrl:reqGemGoodsRefresh()
		end)
		;("animation01")[3] = cca.callFunc(function()
			gemGoodsCtrl:reqGemGoodsRefresh()
		end)
		self.spine_cl:runAction(cca.seq("animation01"))
	end
end
function gemGoodsView:showRefreshAction(...)
	self.scroll:setVisible(true)
	self.spine_cl:setAnimation(0, "animation02", false)
	_UPVALUE1_ = "animation02"
	;("animation02")[1] = cca.delay(0.5)
	;("animation02")[2] = cca.callFunc(function()
		SoraDCloseLoading(self)
		self:showRefreshing(false)
		self.spine_cl:setVisible(false)
	end)
	;("animation02")[3] = cca.callFunc(function()
		SoraDCloseLoading(self)
		self:showRefreshing(false)
		self.spine_cl:setVisible(false)
	end)
	;("animation02")[4] = cca.callFunc(function()
		SoraDCloseLoading(self)
		self:showRefreshing(false)
		self.spine_cl:setVisible(false)
	end)
	;("animation02")[5] = cca.callFunc(function()
		SoraDCloseLoading(self)
		self:showRefreshing(false)
		self.spine_cl:setVisible(false)
	end)
	;("animation02")[6] = cca.callFunc(function()
		SoraDCloseLoading(self)
		self:showRefreshing(false)
		self.spine_cl:setVisible(false)
	end)
	;("animation02")[7] = cca.callFunc(function()
		SoraDCloseLoading(self)
		self:showRefreshing(false)
		self.spine_cl:setVisible(false)
	end)
	;("animation02")[8] = cca.callFunc(function()
		SoraDCloseLoading(self)
		self:showRefreshing(false)
		self.spine_cl:setVisible(false)
	end)
	self.spine_cl:runAction(cca.seq("animation02"))
	for k, v in pairs(self.itemList) do
		local effect = SoraDCreatAnimation("gemGoodsRefreshEffect", nil, false)
		effect:setPosition(-2, 2)
		effect:addTo(v)
		_UPVALUE1_ = 2
		;(2)[1] = cca.delay(1.3333333333333333)
		;(2)[2] = cca.removeSelf()
		effect:runAction(cca.seq(2))
	end
end
function gemGoodsView:OnClickBuy(target, eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if not target:isBright() then
		SoraDShowMsgTip(i18n("dazzling_text_06"))
	elseif not next(self.data.curChoose) then
		SoraDShowMsgTip(i18n("dazzling_text_02"))
	elseif self.itemCount < self.data.buyCost then
		SoraDShowMsgBox(i18n("dazzling_text_04"), i18n("common_text_4347"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				self:OnClickJump(nil, ccui.TouchEventType.ended, true)
			end
		end)
	else
		_ENV = i18n("common_text_4347")
		i18n("common_text_4347").byUID = true
		if SoraDConfigGet("Game:gemGoodsView:buyTip~bool", (i18n("common_text_4347"))) then
			local panel = SoraDCreatePanel("gemGoodsPopView")
			_ENV = i18n("dazzling_text_02")
			i18n("dazzling_text_02").num = string.formatnumberthousands(self.data.buyCost)
			panel:initData(i18n("nationalDay_text_04", i18n("dazzling_text_02")), true, function()
				SoraDShowLoading(self)
				gemGoodsCtrl:reqGemGoodsBuy()
			end)
			panel:show()
		else
			SoraDShowLoading(self)
			gemGoodsCtrl:reqGemGoodsBuy()
		end
	end
end
function gemGoodsView:singleClickBack(button, event)
	local index = button:getTag()
	local position = self:checkIsSelect(index)
	if position then
		SoraDShowLoading(self)
		gemGoodsCtrl:reqGemGoodsChoose(position)
	else
		position = self:getSelectPosition()
		if position then
			SoraDShowLoading(self)
			gemGoodsCtrl:reqGemGoodsChoose(position, index)
		else
			SoraDShowMsgTip(i18n("dazzling_text_10"))
		end
	end
end
function gemGoodsView:OnClickJump(target, eventType, noSound)
	if eventType == ccui.TouchEventType.ended then
		if not noSound then
			SoraDPlaySound()
		end
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).menuEnum = 12
			uiManager:show("rechargeView", nil)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNodeByType(12, gRechargeActiveModelType.LINGLANG_GIFT)
			panel:show()
		end
	end
end
function gemGoodsView:OnClickChouti(target, eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if not self.sprite_open then
		local sprite = display.newSprite("#icon_llhl_chouti_open.png")
		sprite:addTo(self.Image_chouti)
		local cSize = self.Image_chouti:getContentSize()
		sprite:setPosition(cc.p(cSize.width / 2, cSize.height / 2))
		self.sprite_open = sprite
	end
	self.sprite_open:setOpacity(0)
	_UPVALUE2_ = sprite
	sprite[1] = cca.fadeTo(0.03333333333333333, 0.07)
	sprite[2] = cca.fadeTo(0.18333333333333332, 0.93)
	sprite[3] = cca.fadeTo(0.03333333333333333, 1.0)
	sprite[4] = cca.fadeTo(0.03333333333333333, 1.0)
	sprite[5] = cca.fadeTo(0.03333333333333333, 1.0)
	sprite[6] = cca.fadeTo(0.03333333333333333, 1.0)
	sprite[7] = cca.fadeTo(0.03333333333333333, 1.0)
	self.sprite_open:runAction(cca.seq(sprite))
	local pos = cc.p(475, 124)
	local pos = SoraDFIsRA() and cc.p(475, 124) or cc.p(165, 124)
	self.Node_Effect_lrhl01_002:runAction(cca.moveTo(0.25, pos.x, pos.y))
	local panel = SoraDCreatePanel("gemGoodsRewardPopView")
	_ENV = cca.moveTo(0.25, pos.x, pos.y)
	cca.moveTo(0.25, pos.x, pos.y).rewards = gemGoodsCtrl:getRewardInfo()
	_ENV = cca.moveTo(0.25, pos.x, pos.y)
	cca.moveTo(0.25, pos.x, pos.y).item = i18n("common_text_020")
	cca.moveTo(0.25, pos.x, pos.y).des = i18n("dazzling_text_07", cca.moveTo(0.25, pos.x, pos.y))
	cca.moveTo(0.25, pos.x, pos.y).title = i18n("dazzling_text_11")
	panel:initData(cca.moveTo(0.25, pos.x, pos.y))
	panel:show()
	local pos = SoraDFIsRA() and cc.p(484, 160) or cc.p(156, 160)
	panel:showEnterAction(pos)
	panel:setExitHandle(handler(self, self.panelRewardExitHandle))
end
function gemGoodsView:panelRewardExitHandle(...)
	self.sprite_open:stopAllActions()
	self.sprite_open:setOpacity(255)
	_UPVALUE2_ = nil
	;(nil)[1] = cca.fadeTo(0.03333333333333333, 0.93)
	;(nil)[2] = cca.fadeTo(0.18333333333333332, 0.07)
	;(nil)[3] = cca.fadeTo(0.03333333333333333, 0)
	;(nil)[4] = cca.fadeTo(0.03333333333333333, 0)
	;(nil)[5] = cca.fadeTo(0.03333333333333333, 0)
	self.sprite_open:runAction(cca.seq(nil))
	self.Node_Effect_lrhl01_002:stopAllActions()
	local pos = SoraDFIsRA() and cc.p(484, 130) or cc.p(156, 130)
	self.Node_Effect_lrhl01_002:runAction(cca.moveTo(0.25, pos.x, pos.y))
end
function gemGoodsView:checkIsSelect(index)
	for k, v in pairs(self.data.curChoose) do
		if v == index then
			return tonumber(k)
		end
	end
end
function gemGoodsView:getSelectPosition(...)
	for i = 1, MAX_CHOOSE_COUNT do
		if not self.data.curChoose[tostring(i)] then
			return i
		end
	end
end
function gemGoodsView:buyPopCallBack(type)
	if type == MSGBOX_CALLBACK_YES then
		SoraDShowLoading(self)
		gemGoodsCtrl:reqGemGoodsBuy()
	end
end
return gemGoodsView
