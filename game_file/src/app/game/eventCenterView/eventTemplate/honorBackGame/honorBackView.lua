local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local honorBackCtrl = SoraDGetCtrl("honorBackCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local friendsCallbackRead = include("friendsCallbackRead")
local friendPetCtrl = SoraDGetCtrl("friendPetCtrl")
local honorBackView = class("honorBackView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("honorBackView")
	end
	return target
end)
function honorBackView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.ccs_bg:setTitle(i18n("activity_name_9001114"))
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	self.img_panel = SoraDGetChildByName(self, "Bottom_Size_panel")
	self.btn_help = SoraDGetChildByName(self, "btn_help_tip")
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	_ENV, self.redPointList, _ENV, self.buttomList, _ENV, self.scroll = SoraDGetChildByName(self, "Top_ScrollView_items"), SoraDGetChildByName(self, "Top_ScrollView_items"), SoraDGetChildByName(self, "Top_ScrollView_items"), SoraDGetChildByName(self, "Top_ScrollView_items"), SoraDGetChildByName(self, "Top_ScrollView_items"), SoraDGetChildByName(self, "Top_ScrollView_items")
	_ENV = "Top_ScrollView_items"
	;("Top_ScrollView_items").btnName = "return_title_04"
	;("Top_ScrollView_items").btnSpirte = "return_page_recharge.png"
	SoraDGetChildByName(self, "Top_ScrollView_items")[gHonorBackType.HonorGift], ("Top_ScrollView_items").ccsName = "Top_ScrollView_items", "honorBackNode"
	_ENV = "Top_ScrollView_items"
	;("Top_ScrollView_items").btnName = "return_title_05"
	;("Top_ScrollView_items").btnSpirte = "return_page_login.png"
	SoraDGetChildByName(self, "Top_ScrollView_items")[gHonorBackType.LoginGift], ("Top_ScrollView_items").ccsName = "Top_ScrollView_items", "honorBackLoginNode"
	_ENV = "Top_ScrollView_items"
	;("Top_ScrollView_items").btnName = "return_title_06"
	;("Top_ScrollView_items").btnSpirte = "return_page_task.png"
	SoraDGetChildByName(self, "Top_ScrollView_items")[gHonorBackType.BackTask], ("Top_ScrollView_items").ccsName = "Top_ScrollView_items", "honorBackTaskNode"
	_ENV = "Top_ScrollView_items"
	;("Top_ScrollView_items").btnName = "return_title_09"
	;("Top_ScrollView_items").btnSpirte = "icon_return_page_task.png"
	SoraDGetChildByName(self, "Top_ScrollView_items")[gHonorBackType.AdvancedTask], ("Top_ScrollView_items").ccsName = "Top_ScrollView_items", "honorBackTaskNode"
	_ENV = "Top_ScrollView_items"
	;("Top_ScrollView_items").btnName = "return_lcks_title_010"
	;("Top_ScrollView_items").btnSpirte = "icon_return_page_pet.png"
	SoraDGetChildByName(self, "Top_ScrollView_items")[gHonorBackType.FriendPet], ("Top_ScrollView_items").ccsName = "Top_ScrollView_items", "honorBackPetNode"
	_ENV = "Top_ScrollView_items"
	;("Top_ScrollView_items").btnName = "return_title_08"
	;("Top_ScrollView_items").btnSpirte = "return_page_playerwelfare.png"
	;("Top_ScrollView_items").ccsName = "benefitGiftsNode"
	SoraDGetChildByName(self, "Top_ScrollView_items")[gHonorBackType.WelfareGift], ("Top_ScrollView_items").pos = "Top_ScrollView_items", cc.p(display.cx, self.img_panel:getContentSize().height + 6)
	_ENV = "Top_ScrollView_items"
	;("Top_ScrollView_items").btnName = "return_wzzl_title_001"
	;("Top_ScrollView_items").btnSpirte = "icon_return_page_kingift.png"
	;("Top_ScrollView_items").ccsName = "gloryGiftLayer"
	SoraDGetChildByName(self, "Top_ScrollView_items")[gHonorBackType.KingGift], ("Top_ScrollView_items").pos = "Top_ScrollView_items", cc.p(320, 480)
	_ENV = "Top_ScrollView_items"
	;("Top_ScrollView_items").btnName = "return_xbbbl_title_001"
	;("Top_ScrollView_items").btnSpirte = "icon_return_page_newBroke.png"
	self.btnConfig, SoraDGetChildByName(self, "Top_ScrollView_items")[gHonorBackType.NewVersion], ("Top_ScrollView_items").ccsName = SoraDGetChildByName(self, "Top_ScrollView_items"), "Top_ScrollView_items", "honorBackNewBrokeNode"
	self.btn_help:addTouchEventListener(handler(self, self.onClickHelp))
	self.nodeTable, _ENV, self.itemSize = cc.size(135, 160), cc.size(135, 160), cc.size(135, 160)
	self:initView()
end
function honorBackView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_BACK_UPDATE_GIFTS", function(target, data)
		if not next(honorBackCtrl:getBenefitGiftList()) then
			self:resetPage()
			self:initView()
		else
			local node = self.nodeTable[gHonorBackType.WelfareGift]
			if node then
				node:initData()
			end
			self:updateRedPoint()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_BACK_COMMIT_CODE", function(target, data)
		self:updateRedPoint()
		local node = self.nodeTable[gHonorBackType.HonorGift]
		if node then
			node:initData()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_BACK_UPDATE_TASK", function(target, data)
		self:updateRedPoint()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", function(target, data)
		self:updateRedPoint()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function(target, data)
		if not _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.FRIEND_HONORBACK) then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
end
function honorBackView:resetPage()
	for k, v in pairs(self.buttomList) do
		v:removeFromParent()
	end
	self.redPointList, _ENV, self.buttomList, _ENV = pairs(self.buttomList)
end
function honorBackView:initView()
	local showTab = self:getShowTab()
	self.showTab = showTab
	local singleW = self.itemSize.width * #showTab
	local scrollH = math.max(self.scroll:getContentSize().width, singleW)
	self.scroll:setInnerContainerSize(cc.size(scrollH, self.scroll:getContentSize().height))
	if SoraDFIsRA() then
		self.scroll:jumpToRight()
	end
	for i, key in ipairs(showTab) do
		local nodeItem = self.Node_item:clone()
		nodeItem:addTo(self.scroll)
		local posX = (i - 0.5) * self.itemSize.width
		if SoraDFIsRA() then
			posX = scrollH - posX
		end
		nodeItem:setPosition(posX, self.itemSize.height / 2 + 9)
		self.buttomList[key] = nodeItem
		self.redPointList[key] = SoraDGetChildByName(nodeItem, "Sprite_redPoint")
		self.redPointList[key]:setVisible(false)
		SoraDGetChildByName(nodeItem, "Text_item"):setString(i18n(self.btnConfig[key].btnName))
		if self.btnConfig[key].btnSpirte then
			local Sprite_item = SoraDGetChildByName(nodeItem, "Sprite_item")
			Sprite_item:setSpriteFrame(self.btnConfig[key].btnSpirte)
		end
		nodeItem.Sprite_down = SoraDGetChildByName(nodeItem, "Sprite_down")
		local Button_item = SoraDGetChildByName(nodeItem, "Button_item")
		Button_item:addTouchEventListener(handler(self, self.onClickCallback))
		Button_item:setTag(key)
		Button_item:setSwallowTouches(false)
		nodeItem.Button_item = Button_item
	end
	self:updateRedPoint(SoraDConfigGet("Game:honorBackView:redPointStatus~bool"))
	self:switchMode(showTab[1])
end
function honorBackView:getShowTab(...)
	_UPVALUE4_ = nil
	;(nil)[1] = gHonorBackType.FriendPet
	;(nil)[2] = gHonorBackType.KingGift
	;(nil)[3] = gHonorBackType.BackTask
	local (nil)[4], showTab = gHonorBackType.AdvancedTask, nil
	if next(honorBackCtrl:getBenefitGiftList()) then
		table.insert(showTab, gHonorBackType.WelfareGift)
	end
	table.insert(showTab, gHonorBackType.LoginGift)
	if _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.FRIEND_CALLBACK) then
		if honorBackCtrl:isReceiveReturnGift() then
			table.insert(showTab, gHonorBackType.HonorGift)
		else
			table.insert(showTab, gHonorBackType.HonorGift, 1)
		end
	end
	local redPointTab = self:getRedPointTab()
	local _ENV, tempTable = self, self
	for i, v in ipairs(showTab) do
		if redPointTab[v] then
			table.insert(tempTable, v)
		end
	end
	for i, v in ipairs(showTab) do
		if not redPointTab[v] then
			table.insert(tempTable, v)
		end
	end
	return tempTable
end
function honorBackView:getRedPointTab(...)
	_ENV = nil
	;(nil)[gHonorBackType.FriendPet] = friendPetCtrl:showPetNeedRedP()
	;(nil)[gHonorBackType.KingGift] = honorBackCtrl:showGloryTaskNeedRedP()
	;(nil)[gHonorBackType.BackTask] = honorBackCtrl:showCommonTaskNeedRedP(gHonorBackType.BackTask)
	;(nil)[gHonorBackType.AdvancedTask] = honorBackCtrl:showCommonTaskNeedRedP(gHonorBackType.AdvancedTask)
	;(nil)[gHonorBackType.LoginGift] = honorBackCtrl:showLoginTaskNeedRedP()
	;(nil)[gHonorBackType.WelfareGift] = SoraDConfigGet("Game:honorBackView:redPointStatus~bool")
	local (nil)[gHonorBackType.HonorGift], redPointTab = not honorBackCtrl:isReceiveReturnGift(), nil
	return redPointTab
end
function honorBackView:updateRedPoint(isOpenFirst)
	local redPointTab = self:getRedPointTab()
	if isOpenFirst then
		SoraDConfigSet("Game:honorBackView:redPointStatus~bool", false)
	end
	for k, v in pairs(redPointTab) do
		if self.redPointList[k] then
			self.redPointList[k]:setVisible(v)
		end
	end
end
function honorBackView:switchMode(honorType, btnType)
	if honorType == gHonorBackType.WelfareGift then
		self.redPointList[honorType]:setVisible(false)
	end
	for k, v in pairs(self.buttomList) do
		if k == honorType then
			v.Button_item:setTouchEnabled(false)
			v.Sprite_down:setVisible(true)
		else
			v.Button_item:setTouchEnabled(true)
			v.Button_item:setSwallowTouches(false)
			v.Sprite_down:setVisible(false)
		end
	end
	for k, v in pairs(self.nodeTable) do
		v:setVisible(false)
	end
	if self.btnConfig[honorType].ccsName then
		local node = self.nodeTable[honorType]
		if not node then
			node = SoraDCreatePanel(self.btnConfig[honorType].ccsName)
			node:addTo(self.img_panel)
			node:setPosition(self.btnConfig[honorType].pos or cc.p(0, 0))
			if node.setSize then
				node:setSize(self.img_panel:getContentSize())
			end
			if node.setOwnView then
				node:setOwnView(self)
			end
			self.nodeTable[honorType] = node
		end
		node:setVisible(true)
		node:initData(honorType, btnType)
		if honorType == gHonorBackType.HonorGift then
			if node.text_input then
				node.text_input:setPlaceHolder(i18n("reurn_text_10"))
			end
		else
			local node = self.nodeTable[gHonorBackType.HonorGift]
			if node and node.text_input then
				node.text_input:setPlaceHolder("")
			end
		end
	end
end
function honorBackView:onClickCallback(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local honorType = button:getTag()
		self:switchMode(honorType)
	end
end
function honorBackView:onClickHelp(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		userSDKManager.showSingleFAQ(IsArClient and gSDKDef.FAQSingleType.FRIEND_CALLBACK or gSDKDef.FAQSingleType.FRIEND_CALLBACK_ROS)
	end
end
function honorBackView:jumpToModel(honorType, btnType)
	self:switchMode(honorType, btnType)
	for i, v in ipairs(self.showTab) do
		if v == honorType then
			self:jumpToIndex(i)
			return
		end
	end
end
function honorBackView:jumpToIndex(index)
	local inner = self.scroll:getInnerContainer()
	local innerW = inner:getContentSize().width
	local scrollW = self.scroll:getContentSize().width
	if not SoraDFIsRA() then
		index = #self.showTab - (index - 0.5)
	else
		index = index - 0.5
	end
	local posX = scrollW / 2 - innerW + self.itemSize.width * index
	inner:setPositionX(math.max(scrollW - innerW, (math.min(0, posX))))
end
return honorBackView
