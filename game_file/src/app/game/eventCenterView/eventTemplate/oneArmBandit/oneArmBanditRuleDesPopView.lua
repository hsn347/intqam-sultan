local slotMachineRewardRead = include("slotMachineRewardRead")
local oneArmBanditRuleDesPopView = class("oneArmBanditRuleDesPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("oneArmBanditRuleDesPopView")
	end
	return target
end)
function oneArmBanditRuleDesPopView:ctor()
	self.isAddToPopManager = true
	self.itemList, _UPVALUE0_, self.showType = nil, nil, 1
	self:bandWidget()
	self:initData()
	self:initScroll()
end
function oneArmBanditRuleDesPopView:bandWidget()
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_oab")
	self.ccs_bg:setTitleName(i18n("common_text_1173"))
	_UPVALUE1_ = i18n("common_text_1173")
	i18n("common_text_1173")[1] = "Node_info"
	self.Node_info = SoraDGetChildByFullPath(self.Center_Node, i18n("common_text_1173"))
	_UPVALUE2_ = i18n("common_text_1173")
	i18n("common_text_1173")[1] = "Panel_cut"
	i18n("common_text_1173")[2] = "Sprite_bg"
	self.Sprite_bg = SoraDGetChildByFullPath(self.Node_info, i18n("common_text_1173"))
	self.Sprite_bg:setSpriteFrame("bg_activity_Geocentric_adventure.png")
	_UPVALUE2_ = "bg_activity_Geocentric_adventure.png"
	;("bg_activity_Geocentric_adventure.png")[1] = "Panel_cut"
	;("bg_activity_Geocentric_adventure.png")[2] = "ScrollView_des"
	self.scroll_des = SoraDGetChildByFullPath(self.Node_info, "bg_activity_Geocentric_adventure.png")
	_UPVALUE1_ = "bg_activity_Geocentric_adventure.png"
	;("bg_activity_Geocentric_adventure.png")[1] = "Text_des"
	self.Text_des = SoraDGetChildByFullPath(self.scroll_des, "bg_activity_Geocentric_adventure.png")
	self.Text_des:setString(i18n("slot_machine_text_08"))
	local sSize = self.scroll_des:getContentSize()
	local height = SoraDGetAutoHeightLabel(self.Text_des, sSize.width)
	local maxH = 161
	if height <= maxH then
		self.scroll_des:setTouchEnabled(false)
		self.Text_des:setPositionY(self.Text_des:getPositionY() - (maxH - height) / 2)
	else
		self.scroll_des:setInnerContainerSize(cc.size(sSize.width, height + 20))
		self.Text_des:setPositionY(self.Text_des:getPositionY() + (height - maxH))
	end
	_UPVALUE1_ = self.Text_des:getPositionY() + (height - maxH)
	;(self.Text_des:getPositionY() + (height - maxH))[1] = "Text_btn_l"
	self.Text_btn_l = SoraDGetChildByFullPath(self.Node_info, self.Text_des:getPositionY() + (height - maxH))
	self.Text_btn_l:setString(i18n("slot_machine_text_09"))
	_UPVALUE1_ = i18n("slot_machine_text_09")
	i18n("slot_machine_text_09")[1] = "Image_btn_l_1"
	self.Image_btn_l_1 = SoraDGetChildByFullPath(self.Node_info, i18n("slot_machine_text_09"))
	_UPVALUE1_ = i18n("slot_machine_text_09")
	i18n("slot_machine_text_09")[1] = "Image_btn_l_2"
	self.Image_btn_l_2 = SoraDGetChildByFullPath(self.Node_info, i18n("slot_machine_text_09"))
	self.Image_btn_l_1:setFillType(1)
	self.Image_btn_l_2:setFillType(1)
	_UPVALUE1_ = 1
	;(1)[1] = "Image_6"
	self.Image_6 = SoraDGetChildByFullPath(self.Node_info, 1)
	self.Image_6:setTouchEnabled(true)
	self.Image_6:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		if self.showType == 1 then
			return
		end
		SoraDPlaySound()
		self.showType = 1
		self:refreshBtnState()
		self:refreshScroll()
	end)
	function _UPVALUE1_(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		if self.showType == 1 then
			return
		end
		SoraDPlaySound()
		self.showType = 1
		self:refreshBtnState()
		self:refreshScroll()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		if self.showType == 1 then
			return
		end
		SoraDPlaySound()
		self.showType = 1
		self:refreshBtnState()
		self:refreshScroll()
	end)[1] = "Text_btn_r"
	self.Text_btn_r = SoraDGetChildByFullPath(self.Node_info, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		if self.showType == 1 then
			return
		end
		SoraDPlaySound()
		self.showType = 1
		self:refreshBtnState()
		self:refreshScroll()
	end)
	self.Text_btn_r:setString(i18n("slot_machine_text_10"))
	_UPVALUE1_ = i18n("slot_machine_text_10")
	i18n("slot_machine_text_10")[1] = "Image_btn_r_1"
	self.Image_btn_r_1 = SoraDGetChildByFullPath(self.Node_info, i18n("slot_machine_text_10"))
	_UPVALUE1_ = i18n("slot_machine_text_10")
	i18n("slot_machine_text_10")[1] = "Image_btn_r_2"
	self.Image_btn_r_2 = SoraDGetChildByFullPath(self.Node_info, i18n("slot_machine_text_10"))
	self.Image_btn_r_1:setFillType(1)
	self.Image_btn_r_2:setFillType(1)
	_UPVALUE1_ = 1
	;(1)[1] = "Image_7"
	self.Image_7 = SoraDGetChildByFullPath(self.Node_info, 1)
	self.Image_7:setTouchEnabled(true)
	self.Image_7:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		if self.showType == 2 then
			return
		end
		SoraDPlaySound()
		self.showType = 2
		self:refreshBtnState()
		self:refreshScroll()
	end)
	function _UPVALUE1_(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		if self.showType == 2 then
			return
		end
		SoraDPlaySound()
		self.showType = 2
		self:refreshBtnState()
		self:refreshScroll()
	end
	;(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		if self.showType == 2 then
			return
		end
		SoraDPlaySound()
		self.showType = 2
		self:refreshBtnState()
		self:refreshScroll()
	end)[1] = "scroll_rewards"
	self.scroll = SoraDGetChildByFullPath(self.Center_Node, function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		if self.showType == 2 then
			return
		end
		SoraDPlaySound()
		self.showType = 2
		self:refreshBtnState()
		self:refreshScroll()
	end)
	self.pannel_item = SoraDGetChildByName(self, "pannel_item")
	local offsetY = display.height - 960
	if 0 < offsetY then
		self.Center_Node:setPositionY(self.Center_Node:getPositionY() + offsetY / 2)
		self.ccs_bg:setSize(cc.size(self.ccs_bg:getSize().width, self.ccs_bg:getSize().height + offsetY))
		self.ccs_bg:setPositionY(self.ccs_bg:getPositionY() - offsetY)
		self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, self.scroll:getContentSize().height + offsetY))
	end
end
function oneArmBanditRuleDesPopView:initData()
	self:refreshBtnState()
end
function oneArmBanditRuleDesPopView:refreshBtnState(...)
	local visible = self.showType == 1
	self.Image_btn_l_1:setVisible(not visible)
	self.Image_btn_l_2:setVisible(visible)
	self.Image_btn_r_1:setVisible(visible)
	self.Image_btn_r_2:setVisible(not visible)
	if visible then
		self.Text_btn_l:setColor(cc.c3b(255, 200, 135))
		self.Text_btn_r:setColor(cc.c3b(140, 130, 120))
	else
		self.Text_btn_l:setColor(cc.c3b(140, 130, 120))
		self.Text_btn_r:setColor(cc.c3b(255, 200, 135))
	end
end
function oneArmBanditRuleDesPopView:initScroll()
	self.scroll:removeAllChildren()
	local recordnum = 16
	local sSize = self.scroll:getContentSize()
	local itemSize = cc.size(540, 65)
	local posx = (sSize.width - itemSize.width) / 2
	local scrollH = math.max(sSize.height, recordnum * itemSize.height)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, scrollH))
	for i = 1, recordnum do
		local item = self:createRecordItem()
		item:addTo(self.scroll)
		item:setPosition(posx, scrollH - i * itemSize.height)
		_ENV = item
		item.index = i
		item.sType = self.showType
		item.initData(item)
		table.insert(self.itemList, item)
	end
end
function oneArmBanditRuleDesPopView:createRecordItem()
	local item = self.pannel_item:clone()
	slotMachineRewardRead = nil
	;(nil)[1] = "img_item_bg"
	item.imgBg = SoraDGetChildByFullPath(item, nil)
	slotMachineRewardRead = nil
	;(nil)[1] = "text_gold_num"
	item.labGold = SoraDGetChildByFullPath(item, nil)
	slotMachineRewardRead = nil
	;(nil)[1] = "Node_cell"
	item.Node_cell = SoraDGetChildByFullPath(item, nil)
	slotMachineRewardRead = nil
	;(nil)[1] = "Sprite_gold"
	item.Sprite_gold = SoraDGetChildByFullPath(item, nil)
	item.index = 0
	item.sType = 1
	function item.initData(data)
		item.sType = data.sType
		item.index = data.index
		if item.index % 2 == 1 then
			item.imgBg:setVisible(false)
		end
		local rewardData = slotMachineRewardRead.getRewardData(item.sType, item.index)
		if not rewardData then
			return
		end
		local id = rewardData.ID
		local key = math.floor(id % 100 / 10)
		local value = id % 10
		local img
		if key == 0 then
			value = 5
		end
		for i = 1, value do
			local cell
			if i == 1 then
				cell = item.Node_cell
			else
				cell = item.Node_cell:clone()
				cell:addTo(item)
			end
			cell:setPosition(cc.p(9 + 60 * i, 34))
			_ENV = cc.p(9 + 60 * i, 34)
			cc.p(9 + 60 * i, 34)[1] = "item_bg"
			cc.p(9 + 60 * i, 34)[2] = "item_icon"
			local item_icon = SoraDGetChildByFullPath(cell, cc.p(9 + 60 * i, 34))
			local img
			if key == 0 then
				img = slotMachineRewardRead.getSlotShowImg(i)
			else
				img = slotMachineRewardRead.getSlotShowImg(key)
			end
			item_icon:loadTexture(img, ccui.TextureResType.plistType)
		end
		item.setShowType(item.sType)
	end
	function item.setShowType(sType)
		item.sType = sType
		local rewardData = slotMachineRewardRead.getRewardData(item.sType, item.index)
		if not rewardData then
			return
		end
		local rtype = rewardData.Type
		local reward = rewardData.Reward
		if rtype == 1 then
			item.labGold:setString(reward[1] / 10 .. "%")
		elseif rtype == 2 then
			item.labGold:setString(string.formatnumberthousands(reward[1]))
		else
			item.labGold:setString(reward[2])
			item.Sprite_gold:setSpriteFrame("icon_slotmachine_luckycoin.png")
		end
	end
	return item
end
function oneArmBanditRuleDesPopView:refreshScroll()
	self.scroll:scrollToTop(0.5, true)
	for i, v in ipairs(self.itemList) do
		v.setShowType(self.showType)
	end
end
return oneArmBanditRuleDesPopView
