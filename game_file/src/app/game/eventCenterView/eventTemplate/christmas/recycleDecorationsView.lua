local gametop = gModuleMgr.getObject("gametop")
local christmasTreeCtrl = gametop.playertop_:getModule("christmasTreeCtrl")
local recycleDecorationsView = class("recycleDecorationsView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("recycleDecorationsView")
	end
	return target
end)
_ENV = "recycleDecorationsView"
;("recycleDecorationsView")[1] = 851501
;("recycleDecorationsView")[2] = 851601
;("recycleDecorationsView")[3] = 851701
local _ENV, ("recycleDecorationsView")[4], treeId = function(target)
	if target == nil then
		return SoraDCreateBasePanel("recycleDecorationsView")
	end
	return target
end, 851801, "recycleDecorationsView"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("recycleDecorationsView")
	end
	return target
end)[1] = "8515.png"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("recycleDecorationsView")
	end
	return target
end)[2] = "8516.png"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("recycleDecorationsView")
	end
	return target
end)[3] = "8517.png"
local (function(target)
	if target == nil then
		return SoraDCreateBasePanel("recycleDecorationsView")
	end
	return target
end)[4], treeName = "8518.png", function(target)
	if target == nil then
		return SoraDCreateBasePanel("recycleDecorationsView")
	end
	return target
end
function recycleDecorationsView:ctor()
	self:initControls()
	self:initFourTrees()
	self:initData()
end
function recycleDecorationsView:initControls()
	self.bg = SoraDGetChildByName(self, "Image_bg")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_eventCenter")
	self.btnQuest = SoraDGetChildByName(self, "btn_quest")
	self.btnGet = SoraDGetChildByName(self, "btn_get")
	self.btnSynthesis = SoraDGetChildByName(self, "btn_synthesis")
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.txtClean = SoraDGetChildByName(self, "text_clean")
	self.txtLucky = SoraDGetChildByName(self, "text_lucky")
	self.txtMabe = SoraDGetChildByName(self, "text_maybe")
	self.txtCost = SoraDGetChildByName(self, "text_cost")
	self.txtMaterials1 = SoraDGetChildByName(self, "text_materialsNum")
	self.spriteMaterials = SoraDGetChildByName(self, "sprite_materials")
	self.spriteMaterials1 = SoraDGetChildByName(self, "sprite_materials_1")
	self.txtSynthesis = SoraDGetChildByName(self, "text_synthesis")
	self.panel = SoraDGetChildByName(self, "Panel_4")
	self.spriteBg = SoraDGetChildByName(self, "BG_zzsds_05_1")
	self.txtHei = SoraDGetChildByName(self, "text_heiheihei")
	self.bg:setFillType(1)
	self.nodeTitle:setTitle(i18n("christmas_tree_text_02"))
	self.btnQuest:addTouchEventListener(handler(self, self.questClickCallBack))
	self.btnGet:addTouchEventListener(handler(self, self.getClickCallBack))
	self.btnSynthesis:addTouchEventListener(handler(self, self.synthesisClickCallBack))
	self.txtClean:setString(i18n("christmas_tree_text_08"))
	self.txtLucky:setString(i18n("christmas_tree_text_09"))
	self.txtMabe:setString(i18n("christmas_tree_text_10"))
	SoraDSetTextWidthHeight(self.txtMabe, cc.size(600, 60))
	self.txtHei:setString(i18n("christmas_tree_text_21"))
	self.btnGet:setTitleText(i18n("christmas_tree_text_02"))
	SoraDAutoSizeButtonText(self.btnGet)
	self.txtSynthesis:setString(i18n("common_text_1352"))
	self.spriteMaterials:setSpriteFrame("icon_christmas_tree_01.png")
	self.spriteMaterials:setScale(1.2)
	self.spriteMaterials1:setSpriteFrame("icon_christmas_tree_01.png")
	self.spriteMaterials1:setScale(1.2)
	local effectRecycle = SoraDCreatAnimation("recycleDecoration")
	effectRecycle:setPosition(cc.p(320, -570))
	self.topNode:addChild(effectRecycle, 1)
	self.nodeTitle:setLocalZOrder(2)
	if display.height <= 960 then
		self.spriteBg:setPositionY(150)
		effectRecycle:setPosition(cc.p(320, -420))
	end
end
function recycleDecorationsView:initFourTrees()
	for i = 1, 4 do
		self.btnTree = ccui.Button:create(treeName[i], treeName[i], treeName[i], ccui.TextureResType.plistType)
		self.btnTree:setPosition(cc.p(150 * (i - 1) + 85, 160))
		self.btnTree:setScale(0.7)
		self.btnTree:setTag(treeId[i])
		self.btnTree:addTouchEventListener(handler(self, self.singleCellClick))
		self.btnTree:addTo(self.panel)
	end
end
function recycleDecorationsView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_DECORATION_DEPOSE_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_TREE_COMPOUND_REFRESH", function(target, data)
		self:initData()
		local panel = SoraDCreatePanel("compoundSuccessfulView")
		panel:initData(data.rewardInfo.id)
		panel:begin2Action()
		panel:show()
	end)
end
function recycleDecorationsView:singleCellClick(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		if self.pFloor then
			self.pFloor:removeFromParent()
			self.pFloor = nil
		end
	elseif type == ccui.TouchEventType.began and not self.pFloor then
		local pos = self.panel:convertToNodeSpace(button:getTouchBeganPosition())
		self:openItem(pos, button:getTag())
	end
end
function recycleDecorationsView:openItem(pos, tag)
	self.pFloor = SoraDCreatePanel("commonItemTips")
	self.pFloor:initData(tag)
	if SoraDFIsRA() then
		if pos.x < 280 then
			self.pFloor:setPosition(pos.x + 280, pos.y + 40)
		else
			self.pFloor:setPosition(pos.x, pos.y + 40)
		end
	elseif pos.x > 360 then
		self.pFloor:setPosition(pos.x - 280, pos.y + 40)
	else
		self.pFloor:setPosition(pos.x, pos.y + 40)
	end
	self.pFloor:addTo(self.panel, 100)
end
function recycleDecorationsView:questClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.RECYCLE_CHRISTMAS_TREE)
	end
end
function recycleDecorationsView:getClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("getMaterialsPopView"):show()
	end
end
function recycleDecorationsView:synthesisClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local treeData = christmasTreeCtrl:getChristmasTreeData()
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CHRISTMAS_TREE_PRODUCTION) then
			if treeData.material >= 100 then
				christmasTreeCtrl:sendCompoundTreeMsg()
			else
				SoraDShowMsgTip(i18n("christmas_tree_tips_02"))
				SoraDCreatePanel("getMaterialsPopView"):show()
			end
		else
			SoraDShowMsgTip(i18n("common_text_1859"))
		end
	end
end
function recycleDecorationsView:initData()
	local treeData = christmasTreeCtrl:getChristmasTreeData()
	self.txtMaterials1:setString(i18n("christmas_tree_text_06") .. treeData.material)
	local costStr = string.format("%d/100", treeData.material)
	self.txtCost:setString(costStr)
end
function recycleDecorationsView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CHRISTMAS_TREE_PRODUCTION) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return recycleDecorationsView
