local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local siegeCombatCtrl = gametop.playertop_:getModule("siegeCombatCtrl")
local EliminateGameNext = class("eliminateGameNext", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eliminateGameNext")
	end
	return target
end)
function EliminateGameNext:ctor()
	self.baseclose = self.close
	function self.close()
		print("overrided ")
	end
	local centerNode = SoraDGetChildByName(self, "Center_Node")
	local totalStep = SoraDGetChildByName(self, "totalStep")
	local totalDouble = SoraDGetChildByName(self, "totalDouble")
	local title = SoraDGetChildByName(self, "title")
	local layer = centerNode:getParent()
	totalStep:setString(i18n("common_text_2539") .. ":" .. siegeCombatCtrl:getTotalUseStep())
	totalDouble:setString(i18n("common_text_2540") .. ":" .. siegeCombatCtrl:getTotalUseDouble())
	title:setString(i18n("common_text_290"))
	self:addTouchEventListener(handler(self, self.onClose))
	self:setBackGround(204.0)
	self.isHidePrePanel = false
	self.panelRewards = SoraDGetChildByName(self, "panel_rewards")
	SoraDAddMessage(self, "MESSAGE_UI_ELIMINATEGAME_SHOW_ITEMINFO", handler(self, self.openItemInfo))
	SoraDAddMessage(self, "MESSAGE_UI_ELIMINATEGAME_CLOSE_ITEMINFO", handler(self, self.closeItemInfo))
end
function EliminateGameNext:sortItem(data)
	_ENV = nil
	;(nil)["frame_item_base_01.png"] = 1
	;(nil)["frame_item_base_02.png"] = 2
	;(nil)["frame_item_base_03.png"] = 3
	;(nil)["frame_item_base_04.png"] = 4
	;(nil)["frame_item_base_05.png"] = 5
	local (nil)["frame_item_base_06.png"], values = 6, nil
	table.sort(data, function(a, b)
		return values[publicRead.getBg(a.id)] > values[publicRead.getBg(b.id)]
	end)
end
function EliminateGameNext:initData(data, cb)
	self.panelRewards:removeAllChildren()
	local panelWidth = self.panelRewards:getContentSize().width
	local panelHeight = self.panelRewards:getContentSize().height
	self.panelRewards:setLayoutType(ccui.LayoutType.VERTICAL)
	self.cb = cb
	self:sortItem(data)
	local items = data
	for i = 1, #items do
		items[i].itemid = items[i].id
		items[i].itemnum = items[i].count
	end
	local itemsNum = #items
	local row = math.floor(itemsNum / 4)
	local fmodRow = math.fmod(itemsNum, 4)
	if fmodRow ~= 0 then
		row = row + 1
	end
	local unitWidth = 100
	local unitHeight = 100
	local boxWidth = 4 * unitWidth
	local boxHeight = unitHeight
	local iIndex = 0
	for i = 1, row do
		local vLayout = ccui.VBox:create()
		vLayout:setContentSize(cc.size(boxWidth, boxHeight))
		local numPerRow = 1
		if itemsNum >= i * 4 then
			numPerRow = 4
		else
			numPerRow = fmodRow
		end
		local hLayout = ccui.HBox:create()
		hLayout:setContentSize(cc.size(numPerRow * unitWidth, unitHeight))
		for j = 1, numPerRow do
			local reawrdData = items[iIndex + 1]
			local itemBoxNode = self:getRewardItem(reawrdData)
			hLayout:addChild(itemBoxNode)
			local lp1 = ccui.LayoutParameter:create()
			itemBoxNode:setLayoutParameter(lp1)
			itemBoxNode:setPosition(cc.p((j - 1) * 100 + 10, 0))
			hLayout:setSwallowTouches(false)
			iIndex = iIndex + 1
			itemBoxNode:setName("rewardItem_" .. iIndex)
		end
		local lp1 = ccui.LinearLayoutParameter:create()
		hLayout:setLayoutParameter(lp1)
		lp1:setGravity(ccui.LinearGravity.centerHorizontal)
		_ENV = ccui.LinearGravity.centerHorizontal
		ccui.LinearGravity.centerHorizontal.left = 0
		ccui.LinearGravity.centerHorizontal.top = 0
		ccui.LinearGravity.centerHorizontal.right = 0
		ccui.LinearGravity.centerHorizontal.bottom = 0
		lp1:setMargin(ccui.LinearGravity.centerHorizontal)
		vLayout:addChild(hLayout)
		vLayout:setSwallowTouches(false)
		local lp2 = ccui.LinearLayoutParameter:create()
		vLayout:setLayoutParameter(lp2)
		lp2:setGravity(ccui.LinearGravity.centerHorizontal)
		_ENV = ccui.LinearGravity.centerHorizontal
		ccui.LinearGravity.centerHorizontal.left = 0
		ccui.LinearGravity.centerHorizontal.top = 0
		ccui.LinearGravity.centerHorizontal.right = 0
		ccui.LinearGravity.centerHorizontal.bottom = 0
		lp2:setMargin(ccui.LinearGravity.centerHorizontal)
		self.panelRewards:addChild(vLayout)
		if iIndex == itemsNum then
			break
		end
	end
end
function EliminateGameNext:getRewardItem(reawrdData)
	local eliminateGameRewardItem = include("eliminateGameRewardItem")
	local itemNode = eliminateGameRewardItem.new()
	itemNode:initWithData(reawrdData)
	itemNode:setScale(90 / itemNode:getItemWidth())
	itemNode:setCascadeOpacityEnabled(true)
	return itemNode
end
function EliminateGameNext:onClose(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.cb then
			self.cb()
		end
		self:baseclose(sender, type)
	end
end
function EliminateGameNext:openItemInfo(target, data)
	local itemID = data.id
	local item = data.item
	if self.itemTips == nil then
		self.itemTips = SoraDCreatePanel("commonItemTips")
		self.itemTips:setPositionY(50)
		self.itemTips:addTo(self)
		self.itemTips:setLocalZOrder(10)
		self.itemTips:setVisible(false)
	end
	local worldPos = item:convertToWorldSpace(cc.p(0, 0))
	local nodePos = self:convertToNodeSpace(worldPos)
	local deltaTipX = 0
	if SoraDFIsRA() then
		deltaTipX = 0
	else
		deltaTipX = -280
	end
	if nodePos.x > 300 then
		self.itemTips:setPositionX(nodePos.x + 15 + deltaTipX)
	else
		self.itemTips:setPositionX(nodePos.x + 325 + deltaTipX)
	end
	self.itemTips:setPositionY(nodePos.y + 200)
	self.itemTips:setVisible(true)
	self.itemTips:initData(itemID)
end
function EliminateGameNext:closeItemInfo(target, data)
	if self.itemTips then
		self.itemTips:setVisible(false)
	end
end
return EliminateGameNext
