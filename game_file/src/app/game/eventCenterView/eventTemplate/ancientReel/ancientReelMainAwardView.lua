local gametop = gModuleMgr.getObject("gametop")
local ancientReelCtrl = gametop.playertop_:getModule("ancientReelCtrl")
local ancientReelRead = include("ancientReelRead")
local ancientReelMainAwardView = class("ancientReelMainAwardView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
function ancientReelMainAwardView:ctor()
	SoraDGetChildByName(self, "Size_Bg_King"):setFillType(1)
	self.txtActivieyTime = SoraDGetChildByName(self, "Text_activiey_time")
	local strTitle = ancientReelCtrl:getActivitySeasonEndTitle()
	self.txtActivieyTime:setString(strTitle)
	self.txtLevel = SoraDGetChildByName(self, "Text_level")
	self.txtLevelTitle = SoraDGetChildByName(self, "Text_level_title")
	self.txtProgress = SoraDGetChildByName(self, "Text_progress")
	self.nodeSingle = SoraDGetChildByName(self, "Node_single")
	self.nodeSingle:setVisible(false)
	self.Node_lock_animate = SoraDGetChildByName(self, "Node_lock_animate")
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_award")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.nodeProBarPreview = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_preview")
	self.nodeProBarPreview:setActionDelay(0.5)
	self.nodeBottom = SoraDGetChildByName(self, "Bottom_Node")
	self.nodeBottom:setPositionY(-self:getPanelOffsetHeight() + 150)
	self.btnExp = SoraDGetChildByName(self, "Button_exp")
	self.btnExp:setTitleText(i18n("Ancient_reel_text_04"))
	self.btnReward = SoraDGetChildByName(self, "Button_reward")
	self.btnActivite = SoraDGetChildByName(self, "Button_GoShop")
	self.txtActivite = SoraDGetChildByName(self, "Text_Button_GoShop")
	self.txtActivite:setString(i18n("common_text_740"))
	self.txtLevelTitle:setString(i18n("common_text_748"))
	self.btnAwardPreviewGold = SoraDGetChildByName(self, "Button_item_gold")
	self.btnAwardPreviewNormal = SoraDGetChildByName(self, "Button_item_normal")
	self.btnAwardPreviewGold:addTouchEventListener(handler(self, self.onClick_btnAwardPreviewGold))
	self.btnAwardPreviewNormal:addTouchEventListener(handler(self, self.onClick_btnAwardPreviewNormal))
	self.btnExp:addTouchEventListener(handler(self, self.onClick_btnExp))
	self.btnReward:addTouchEventListener(handler(self, self.onClick_btnReward))
	self.btnActivite:addTouchEventListener(handler(self, self.onClick_btnActivite))
	self.isGoldClass = false
	self:fitView()
	_G.SoraDAutoSizeButtonTextByContent(self.btnExp)
	_G.SoraDCreatAnimationEx(self.__cname, self, true)
end
function ancientReelMainAwardView:fixViewSize(name, fitHeight)
	local img = SoraDGetChildByName(self, name)
	img:setContentSize(img:getContentSize().width, img:getContentSize().height + fitHeight)
end
local HEIGHT = 14.444444444444445
function ancientReelMainAwardView:fitView()
	local img = SoraDGetChildByName(self, "Size_Tile_bg_4")
	local height = img:getContentSize().height
	dump(height, "height", 10)
	local fitHeight = math.ceil(height / HEIGHT) * HEIGHT - height
	dump(fitHeight, "fitHeight", 10)
	local bottomBg = SoraDGetChildByName(self, "Bottom_node_bg")
	bottomBg:setPositionY(bottomBg:getPositionY() - fitHeight)
	img:setContentSize(img:getContentSize().width, img:getContentSize().height + fitHeight)
	self:fixViewSize("Size_bg_1", fitHeight)
	self:fixViewSize("Size_Tile_bg_2", fitHeight)
	self:fixViewSize("Size_Tile_bg_3", fitHeight)
end
function ancientReelMainAwardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ANCIENT_REEL_AWARD", handler(self, self.init))
	SoraDAddMessage(self, "MESSAGE_SERVER_ANCIENT_REEL_GOLD", handler(self, self.initViewGold))
end
function ancientReelMainAwardView:init()
	SoraDCloseLoading(self)
	self:initViewGold()
	self:initViewInfo()
	self:jumpToCurLevel()
end
function ancientReelMainAwardView:initViewGold()
	self.isGoldClass = ancientReelCtrl:isActiveGold()
	self:reFreshEffect()
	self:initBtnStatus()
end
function ancientReelMainAwardView:reFreshEffect()
end
function ancientReelMainAwardView:jumpToCurLevel()
	local lv = ancientReelCtrl:getCurLevel()
	lv = math.min(#self.levelList, math.max(1, lv))
	self.scroll:jumpIndexToTop(lv)
end
function ancientReelMainAwardView:initViewInfo()
	self.index = nil
	self:initLvInfo()
	self:initScroll()
end
function ancientReelMainAwardView:initBtnStatus()
	if self.isGoldClass then
		self.Node_lock_animate:setVisible(false)
		self.btnReward:setPositionX(0)
	else
		self.Node_lock_animate:setVisible(true)
	end
	local num = ancientReelCtrl:getAwardNum()
	local enable = 0 < num
	if 1 < num then
		self.btnReward:setTitleText(i18n("summoned_btn_01"))
	else
		self.btnReward:setTitleText(i18n("common_text_1146"))
	end
	self.btnReward:setTouchEnabled(enable)
	self.btnReward:setBright(enable)
end
function ancientReelMainAwardView:initLvInfo()
	local lv = ancientReelCtrl:getCurLevel()
	self.txtLevel:setString(lv)
	_UPVALUE2_ = lv
	lv[1] = self.txtLevel
	lv[2] = self.txtLevelTitle
	_ENV = self.txtLevelTitle
	self.txtLevelTitle[1] = 10
	_G.SoraDAlignNodeArrayOnBeginX(0, lv, not SoraDFIsRA(), self.txtLevelTitle)
	local cur, max = ancientReelCtrl:getCurLevelExp()
	self.nodeProBarPreview:stopAllActions()
	self.nodeProBarPreview:setInitState(false)
	ancientReelCtrl = false
	;(false).maxValue = max
	;(false).curValue = cur
	self.nodeProBarPreview:setProgressDate(false)
	self.nodeProBarPreview:setInitState(true)
end
function ancientReelMainAwardView:initScroll()
	self.levelList = ancientReelRead:getLevelList()
	local view = self:getParent():getParent()
	ancientReelRead = nil
	;(nil).scroll = self.scroll
	;(nil).view = view
	self.scroll:updateScrollView(cc.size(640, 110), self.levelList, 1, nil)
end
function ancientReelMainAwardView:getLineSize(index)
	local scrollWidth = self.scroll:getContentSize().height
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	if index ~= #self.levelList or 75 < offsetY then
		return scrollWidth
	end
	if scrollWidth - (85 - offsetY) < 0 then
		return 0
	end
	return scrollWidth - (85 - offsetY)
end
function ancientReelMainAwardView:createSingle()
	local ocx = self.nodeSingle:clone()
	local single = include("ancientReelMainAwardSingle").new(ocx)
	single:setVisible(true)
	return single
end
function ancientReelMainAwardView:onClick_btnResurgence(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgBox(i18n("summoned_text_50"), i18n("common_text_477"), nil, function(msgType)
			if msgType == MSGBOX_CALLBACK_YES then
				local ancientReelUtil = include("ancientReelUtil")
				ancientReelUtil:openShop()
			end
		end)
	end
end
function ancientReelMainAwardView:onClick_btnExp(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("ancientReelShopExpView")
		panel:show()
	end
end
function ancientReelMainAwardView:onClick_btnAwardPreviewNormal(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("ancientReelAwardPreviewView")
		panel:show()
		panel:initData(false)
	end
end
function ancientReelMainAwardView:onClick_btnAwardPreviewGold(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("ancientReelAwardPreviewView")
		panel:show()
		panel:initData(true)
	end
end
function ancientReelMainAwardView:onClick_btnReward(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		ancientReelCtrl:reqActivityGetAllLevelReward()
		local panel = SoraDShowLoading(self, nil, nil, true, 3)
		panel:setPositionY(-panel:getPositionY())
	end
end
function ancientReelMainAwardView:onClick_btnActivite(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local ancientReelUtil = include("ancientReelUtil")
		ancientReelUtil:openShop()
	end
end
return ancientReelMainAwardView
