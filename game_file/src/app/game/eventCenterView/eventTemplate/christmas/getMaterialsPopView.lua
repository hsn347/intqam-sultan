local gametop = gModuleMgr.getObject("gametop")
local itemDesRead = include("itemDesRead")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local christmasTreeCtrl = gametop.playertop_:getModule("christmasTreeCtrl")
local getMaterialsPopView = class("getMaterialsPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("getMaterialsPopView")
	end
	return target
end)
local NODESINGLE_HEIGHT = 110
function _ENV(target)
	if target == nil then
		return SoraDCreateTouchPanel("getMaterialsPopView")
	end
	return target
end
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("getMaterialsPopView")
	end
	return target
end)[851101] = 2
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("getMaterialsPopView")
	end
	return target
end)[851201] = 5
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("getMaterialsPopView")
	end
	return target
end)[851301] = 15
local (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("getMaterialsPopView")
	end
	return target
end)[851401], decomposeNum = 30, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("getMaterialsPopView")
	end
	return target
end
function getMaterialsPopView:ctor()
	self:initControls()
	self:initFourDecorations()
end
function getMaterialsPopView:initControls()
	self.panelCut = SoraDGetChildByName(self, "Panel_cut")
	self.txtTitle = SoraDGetChildByName(self, "Text_name")
	self.nodeSingle = SoraDGetChildByName(self, "node_single")
	self.btnDecompose = SoraDGetChildByName(self, "btn_decompose")
	self.txtWarning = SoraDGetChildByName(self, "text_warning")
	self.spriteMaterials = SoraDGetChildByName(self, "sprite_Materials")
	self.spriteMaterials1 = SoraDGetChildByName(self, "Sprite_8")
	self.btnDecompose:addTouchEventListener(handler(self, self.deComposeClickCallBack))
	local treeData = christmasTreeCtrl:getChristmasTreeData()
	self.panelCut:setPositionY(display.height / 2)
	self.txtTitle:setString(i18n("christmas_tree_text_06") .. treeData.material)
	self.txtWarning:setString(i18n("christmas_tree_text_12"))
	self.spriteMaterials:setSpriteFrame("icon_christmas_tree_01.png")
	self.spriteMaterials:setScale(1.2)
	self.spriteMaterials1:setSpriteFrame("icon_christmas_tree_01.png")
	self.spriteMaterials:setScale(1.2)
end
function getMaterialsPopView:initFourDecorations()
	for i = 1, 4 do
		local single = self.nodeSingle:clone()
		single:setName("item_single_" .. i)
		single:addTo(self.panelCut)
		single:setPosition(cc.p(285, 520 - NODESINGLE_HEIGHT * (i - 1)))
		local beginTreeIndex = 851001
		local itemID = beginTreeIndex + i * 100
		local cell = SoraDCreatePanel("eventGeocentricCell")
		single.cell = cell
		cell:initData(itemID, backpackCtrl:getItemCount(itemID))
		cell:addTo(single)
		cell:setPosition(cc.p(-230, -15))
		cell:setClickDelegate(handler(self, self.singleCellClick))
		cell:sendParentToButton(self)
		cell:setScale(0.8)
		local btnDecompose = SoraDGetChildByName(single, "btn_decompose")
		btnDecompose:setTitleText(i18n("christmas_tree_btn_02"))
		btnDecompose:setTag(itemID)
		local txtTreeName = SoraDGetChildByName(single, "text_treeName")
		txtTreeName:setString(itemDesRead.getName(itemID))
		local txtDecompose = SoraDGetChildByName(single, "text_materials")
		txtDecompose:setString(i18n("christmas_tree_text_11") .. " " .. decomposeNum[itemID])
	end
end
function getMaterialsPopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_DECORATION_DEPOSE_REFRESH", handler(self, self.initData))
end
function getMaterialsPopView:deComposeClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CHRISTMAS_TREE_PRODUCTION) then
			if backpackCtrl:getItemCount(button:getTag()) > 0 then
				local maxExchangeNum = backpackCtrl:getItemCount(button:getTag())
				if maxExchangeNum <= 1 then
					christmasTreeCtrl:sendcycleDecorationsMsg(button:getTag(), 1)
				else
					backpackCtrl, _ENV, _ENV = button:getTag()
					button:getTag().targetID = 851100
					button:getTag().exchangeID = button:getTag()
					button:getTag().singCount = 1
					button:getTag().curNum = maxExchangeNum
					button:getTag().huntCount = decomposeNum[button:getTag()]
					button:getTag().exchangeData, button:getTag()[1] = button:getTag()
					;(1).exchangeCfg, button:getTag().exchangeHandler = button:getTag()
					uiManager:show("newShopSingleBuy", 1)
				end
			else
				SoraDShowMsgTip(i18n("christmas_tree_tips_01"))
			end
		else
			SoraDShowMsgTip(i18n("common_text_1859"))
		end
	end
end
function getMaterialsPopView:initData()
	local treeData = christmasTreeCtrl:getChristmasTreeData()
	self.txtTitle:setString(i18n("christmas_tree_text_06") .. " " .. treeData.material)
	for i = 1, 4 do
		local item = self.panelCut:getChildByName("item_single_" .. i)
		if item then
			local cell = item.cell
			local itemID = cell:getItemID()
			cell:initData(itemID, backpackCtrl:getItemCount(itemID))
		end
	end
end
function getMaterialsPopView:singleCellClick(pItem)
end
function getMaterialsPopView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CHRISTMAS_TREE_PRODUCTION) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return getMaterialsPopView
