local gametop = gModuleMgr.getObject("gametop")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local rechargeFirstAwardDetail = class("rechargeFirstAwardDetail", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeFirstAwardDetail")
	end
	return target
end)
function rechargeFirstAwardDetail:ctor()
	self:setBackGround(229.5)
	self.node_first_accout = SoraDGetChildByName(self, "Node_First_Accout")
	self.text_title_accout = SoraDGetChildByName(self, "text_title_accout")
	_ENV = nil
	;(nil).count = RECHARGE_ACCOUNT_FIRST_GOLD
	self.text_title_accout:setString(i18n("common_text_3767", nil))
	SoraDSetTextWidthHeight(self.text_title_accout, cc.size(500, 65))
	self.scroll_items_accout = SoraDGetChildByName(self, "scroll_items_accout")
	self.node_first = SoraDGetChildByName(self, "Node_First")
	self.text_title = SoraDGetChildByName(self, "text_title")
	_ENV = cc.size(500, 65)
	cc.size(500, 65).count = RECHARGE_DAY_FIRST_GOLD
	self.text_title:setString(i18n("common_text_3768", cc.size(500, 65)))
	SoraDSetTextWidthHeight(self.text_title, cc.size(500, 65))
	self.scroll_items = SoraDGetChildByName(self, "scroll_items")
	self.item_single = SoraDGetChildByName(self, "img_bg_item")
	self.item_single:setVisible(false)
	self:initView()
end
function rechargeFirstAwardDetail:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_DAYFIRST", handler(self, self.sMsgReceiveNormal))
end
function rechargeFirstAwardDetail:sMsgReceiveNormal(target, data)
	local isRechargeAccout = rechargeActivityCtrl:getIsAccountFirstRecharge()
	local isRecharge = rechargeActivityCtrl:getIsDayFirstRecharge()
	if not isRecharge then
		self:close(nil, ccui.TouchEventType.ended)
		return
	end
	self:initView()
end
function rechargeFirstAwardDetail:initView()
	self.node_first_accout:setVisible(false)
	local height = 500
	local center_panel = SoraDGetChildByName(self, "Center_Panel")
	local size = center_panel:getContentSize()
	size.height = height
	center_panel:setContentSize(size)
	local line_top = SoraDGetChildByName(self, "frame_line_top")
	line_top:setPositionY(height)
	self.text_title:setPositionY(height - 35)
	self.scroll_items:setPositionY(height - 75)
	local sSize = self.scroll_items:getContentSize()
	sSize.height = height - 75
	self.scroll_items:setContentSize(sSize)
	self:setFirstAwardData()
end
function rechargeFirstAwardDetail:setAccoutFirstAwardData()
	local rechargeltCtrl = include("rechargeltCtrl")
	local rewards = rechargeltCtrl:getRechargeFirstReward()
	_UPVALUE2_ = nil
	;(nil)[1] = "itemid"
	;(nil)[2] = "count"
	local rewardData = serviceFunctions.tableFormat(rewards[1].award, nil)
	self:setScrollView(self.scroll_items_accout, rewardData)
end
function rechargeFirstAwardDetail:setFirstAwardData()
	local rechargeltCtrl = include("rechargeltCtrl")
	local rewards = rechargeltCtrl:getRechargeDayFirstReward()
	_UPVALUE2_ = nil
	;(nil)[1] = "itemid"
	;(nil)[2] = "count"
	local rewardData = serviceFunctions.tableFormat(rewards[1].award, nil)
	self:setScrollView(self.scroll_items, rewardData)
end
function rechargeFirstAwardDetail:setScrollView(scroll, rewards)
	local sSize = scroll:getContentSize()
	local sH = math.max(sSize.height, #rewards * 70)
	scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	local _ENV, tableItems = scroll.setInnerContainerSize, scroll.setInnerContainerSize
	for i, _ in ipairs(rewards) do
		local single = self.item_single:clone()
		single:addTo(scroll)
		table.insert(tableItems, single)
	end
	for i, v in ipairs(tableItems) do
		local itemOrResRead = include("publicRead")
		local strIcon
		v:setVisible(true)
		local item = SoraDGetExtendChildFromCCSByName(v, "CCS_commonItemAward")
		item:setScale(0.6)
		item:setBaseScale(1.0)
		item:setOwnView(self)
		item:initData(rewards[i].itemid)
		local item_name = SoraDGetChildByName(v, "text_name")
		if item_name then
			item_name:setString(itemOrResRead.getName(rewards[i].itemid))
		end
		if item_name:getContentSize().width > 300 then
			SoraDGetAutoHeightLabel(item_name, 300)
		end
		local item_num = SoraDGetChildByName(v, "text_num")
		if item_num then
			item_num:setString("X" .. string.formatnumberthousands(rewards[i].count))
		end
		v:setPosition(cc.p(0, sH - i * 70 + 10))
	end
end
return rechargeFirstAwardDetail
