local gametop = gModuleMgr.getObject("gametop")
local secretBagCtrl = gametop.playertop_:getModule("secretBagCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local secretBagPriceReview = class("secretBagPriceReview", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("secretBagPriceReview")
	end
	return target
end)
function secretBagPriceReview:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.centerNode = self.scaleActTarget
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("hero_title_02"))
	self.txtTip = SoraDGetChildByName(self, "Text_tip")
	self.txtTip:setString(i18n("kits_text_07"))
	self.nodePaste = SoraDGetChildByName(self, "Node_items_paste")
	self.nodeItem = SoraDGetChildByName(self, "Node_item")
end
function secretBagPriceReview:initData()
	local curLv = secretBagCtrl:getsecretBagData().curRewardLv
	local group = activityShowCtrl:getParamByID(gActivityTimeActivityID.KITS_ACTIVITY).classtype or 1
	self.bagData = secretBagCtrl.localClass.getBagInfo(curLv, group)
	self:initView()
end
function secretBagPriceReview:initView(...)
	_UPVALUE3_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	;(nil)[3] = "weight"
	local award = serviceFunctions.tableFormat(self.bagData.weight, nil)
	self:initViewWithItems(award)
end
function secretBagPriceReview:initViewWithItems(award)
	if not self.firstListItems then
		local publicRead = include("publicRead")
		local fillItem = function(ocx, tbl)
			local itemBg = ocx:getChildByName("Image_itemBg")
			local itemIcon = ocx:getChildByName("Image_item")
			local itemCount = ocx:getChildByName("Text_itemNum")
			itemBg:loadTexture(publicRead.getBg(tbl.id), ccui.TextureResType.plistType)
			itemIcon:loadTexture(publicRead.getIcon(tbl.id), ccui.TextureResType.plistType)
			itemCount:setString("x" .. tbl.count)
			itemBg:setTouchEnabled(true)
			itemBg:setTag(tbl.id)
			itemBg:addTouchEventListener(handler(self, self.itemClick))
		end
		local row = 4
		local perDis = 120
		local sPosX = -row * perDis / 2
		local numRow = math.ceil(#award / row)
		local addedH = 0
		if 3 <= numRow then
			addedH = (numRow - 2) * perDis
			self.ccs_bg:setSize(cc.size(self.ccs_bg:getSize().width, self.ccs_bg:getSize().height + addedH))
			self.txtTip:setPositionY(self.txtTip:getPositionY() + addedH)
		end
		for i, v in ipairs(award) do
			local item = self.nodeItem:clone()
			item:setScale(0.9)
			item:addTo(self.nodePaste)
			local _x = sPosX + (i - 1) % row * perDis + perDis / 2
			local _y = -(math.ceil(i / row) - 1) * perDis + addedH
			item:setPosition(_x, _y)
			fillItem(item, v)
		end
		self.centerNode:setPositionY(self.centerNode:getPositionY() - addedH / 2)
		self.firstListItems = true
	end
end
function secretBagPriceReview:itemClick(button, event)
	if event == ccui.TouchEventType.ended or event == ccui.TouchEventType.canceled then
		if self.pFloor then
			self.pFloor:removeFromParent()
			self.pFloor = nil
		end
	elseif event == ccui.TouchEventType.began and not self.pFloor then
		local pos = self:convertToNodeSpace(button:getTouchBeganPosition())
		self:openItem(button, pos)
	end
end
function secretBagPriceReview:openItem(item, pos)
	SoraDPlaySound()
	self.pFloor = SoraDCreatePanel("commonItemTips")
	self.pFloor:initData(item:getTag())
	if SoraDFIsRA() then
		if pos.x < 280 then
			self.pFloor:setPosition(pos.x + 280, pos.y)
		else
			self.pFloor:setPosition(pos.x, pos.y)
		end
	elseif pos.x > 360 then
		self.pFloor:setPosition(pos.x - 280, pos.y)
	else
		self.pFloor:setPosition(pos.x, pos.y)
	end
	self.pFloor:addTo(self, 100)
end
function secretBagPriceReview:initWithItem(data)
	self.data = data
	self.itemID = data.itemID
	if data.tip then
		self.txtTip:setString(data.tip)
		SoraDGetAutoHeightLabel(self.txtTip, 500)
	end
	if data.title then
		self.ccs_bg:setTitleName(data.title)
	end
	print("self.itemID = ", self.itemID)
	_ENV = nil
	;(nil).forceShow = true
	local items = backpackltCtrl:getRandomGiftShowItems(self.itemID, nil)
	dump(items, "items", 10)
	self:initViewWithItems(items)
end
return secretBagPriceReview
