local gametop = gModuleMgr.getObject("gametop")
local commonScoreBoxView = class("commonScoreBoxView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("dailyAwardBoxDetail")
	end
	return target
end)
function commonScoreBoxView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_2658"))
	self.btn_ok = SoraDGetChildByName(self, "btn_ok")
	self.scroll_items = SoraDGetChildByName(self, "scroll_items")
	self.item_single = SoraDGetChildByName(self, "Node_single")
	self.btn_ok:addTouchEventListener(handler(self, self.OnBtnClick))
	self.tableItems, _ENV = self.btn_ok.addTouchEventListener, self.btn_ok.addTouchEventListener
	self.btn_ok:setTitleText(i18n("common_text_2139"))
end
function commonScoreBoxView:onMessageListener()
	print("onMessageListener")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_CLOSE_SCORETIPS", handler(self, self.sMsgReceiveNormal))
end
function commonScoreBoxView:initWithData(data)
	self.data = data
	local index = self.data.index
	dump(data)
	if data.receiveState == 2 then
		self.btn_ok:setTitleText(i18n("common_text_2139"))
		self.btn_ok:getVirtualRenderer():setState(1)
		self.btn_ok:setTouchEnabled(false)
	elseif data.receiveState == 3 then
		self.btn_ok:setTitleText(i18n("common_text_1892"))
		self.btn_ok:setTouchEnabled(false)
		self.btn_ok:getVirtualRenderer():setState(1)
	else
		self.btn_ok:setTitleText(i18n("common_text_854"))
		self.btn_ok:setTouchEnabled(true)
		self.btn_ok:setPressedActionEnabled(true)
	end
	local rewards = data.rewards
	local sSize = self.scroll_items:getContentSize()
	local sH = math.max(sSize.height, #rewards * 90)
	self.scroll_items:setInnerContainerSize(cc.size(sSize.width, sH))
	table.insert(self.tableItems, self.item_single)
	local once
	for i, _ in ipairs(rewards) do
		if 1 < i then
			local single = self.item_single:clone()
			single:addTo(self.scroll_items)
			table.insert(self.tableItems, single)
			if once == nil then
				for i, v in ipairs(single:getChildren()) do
					print(i, v:getName())
				end
				once = 1
			end
		end
	end
	for i, v in ipairs(self.tableItems) do
		local item = SoraDGetExtendChildFromCCSByName(v, "CCS_commonItemAward_item")
		item:setBaseScale(1)
		item:setOwnView(self)
		item:setOwnScroll(self.scroll_items)
		item:initData(rewards[i].itemid)
		local itemOrResRead
		SoraDGetChildByName(v, "img_bg_item"):setVisible(i % 2 == 0)
		if SoraDJudgeResOrItem(rewards[i].itemid) then
			itemOrResRead = include("itemDesRead")
		else
			itemOrResRead = include("resDesRead")
		end
		local item_name = SoraDGetChildByName(v, "text_name")
		if item_name then
			item_name:setString(itemOrResRead.getName(rewards[i].itemid))
		end
		if item_name:getContentSize().height > 230 then
			SoraDGetAutoHeightLabel(item_name, 230)
		end
		local item_num = SoraDGetChildByName(v, "text_num")
		if item_num then
			item_num:setString("X" .. string.formatnumberthousands(rewards[i].count))
		end
		v:setPositionY(sH - i * 90)
	end
end
function commonScoreBoxView:OnBtnClick(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local showLoading = false
		if self.data.eventHanler then
			showLoading = self.data.eventHanler(self)
		end
		if showLoading then
			local loading = SoraDShowLoading(self.btn_ok, self.btn_ok:getContentSize())
			if loading.loadingImg then
				loading.loadingImg:setScale(40 / loading.loadingImg:getContentSize().height)
			end
			loading:setPosition(cc.p(self.btn_ok:getContentSize().width / 2, self.btn_ok:getContentSize().height / 2))
		end
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	end
end
function commonScoreBoxView:sMsgReceiveNormal(target, data)
	SoraDCloseLoading(self.btn_ok)
	self:close(nil, ccui.TouchEventType.ended)
end
function commonScoreBoxView:createTips(params)
	local text = ccui.Text:create(params.tips or "", "", 18)
	text:setColor(params.color or display.COLOR_RED)
	text:addTo(self.scaleActTarget, 1)
	text:setPosition(cc.p(0, self.btn_ok:getPositionY() + 55))
	SoraDSetTextWidthHeight(text, cc.size(500, 38))
	text:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	text:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
end
return commonScoreBoxView
