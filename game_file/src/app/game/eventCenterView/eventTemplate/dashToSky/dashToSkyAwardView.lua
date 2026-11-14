local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
local royalSummonsRead = include("royalSummonsRead")
local dashToSkyAwardView = class("dashToSkyAwardView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
function dashToSkyAwardView:ctor()
	self.isGoldClass = false
	print("self:getPanelOffsetHeight()", self:getPanelOffsetHeight())
	self.txtActivieyTime = SoraDGetChildByName(self, "Text_activiey_time")
	local strTitle = royalSummonsCtrl:getActivitySeasonEndTitle()
	self.txtActivieyTime:setString(strTitle)
	self.goldEffectNode = SoraDGetChildByName(self, "Center_Effect")
	self.nodeLevel = SoraDGetChildByName(self, "Node_level")
	self.txtLevel = SoraDGetChildByName(self.nodeLevel, "Text_level")
	self.txtLevelTitle = SoraDGetChildByName(self, "Text_level_title")
	self.txtProgress = SoraDGetChildByName(self, "Text_progress")
	self.txtLevelTitle:setString(i18n("common_text_748"))
	self.bgCommonBlack = SoraDGetChildByName(self, "Image_Size_Bg_common")
	self.bgCommonBlack:setFillType(1)
	self.bgCommonBlack:setPositionY(-self:getPanelOffsetHeight() + 253)
	SoraDGetChildByName(self, "Bottom_Image_ySize_1"):setPositionY(-self:getPanelOffsetHeight() + 376)
	SoraDGetChildByName(self, "Bottom_Image_Size_2"):setPositionY(-self:getPanelOffsetHeight() + 376)
	self.txtScrollTitleLevel = SoraDGetChildByName(self, "Text_scroll_title_level")
	self.txtScrollTitleNormal = SoraDGetChildByName(self, "Text_scroll_title_normal")
	self.txtScrollTitleGod = SoraDGetChildByName(self, "Text_scroll_title_god")
	self.spScrollTitleGod = SoraDGetChildByName(self, "Sprite_scroll_title_god")
	self.txtScrollTitleLevel:setString(i18n("common_text_748"))
	self.txtScrollTitleNormal:setString(i18n("common_text_049"))
	self.etPetCardNode = SoraDGetChildByName(self, "et_petcard_unlock_node")
	self.etPetCardNode:setVisible(false)
	self.nodeSingle = SoraDGetChildByName(self, "Node_single")
	self.nodeSingle:setVisible(false)
	self.nodeSingleView = SoraDGetChildByName(self, "Node_single_view")
	self.nodeSingleView = include("royalSummonsMainAwardSingle").new(self.nodeSingleView)
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_award")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setScrollMoveFun(handler(self, self.scrollMove))
	self.addNum = math.ceil(self.scroll:getContentSize().height / 100)
	self.nodeProBarPreview = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_preview")
	self.nodeProBarPreview:setActionDelay(0.5)
	self.nodeBottom = SoraDGetChildByName(self, "Bottom_Node")
	self.nodeBottom:setPositionY(-self:getPanelOffsetHeight() + 150)
	self.btnResurgence = SoraDGetChildByName(self, "Button_resurgence")
	self.btnExp = SoraDGetChildByName(self, "Button_exp")
	self.btnAwardPreview = SoraDGetChildByName(self, "Button_award_preview")
	self.btnReward = SoraDGetChildByName(self, "Button_reward")
	self.btnActivite = SoraDGetChildByName(self, "Button_activite")
	self.textOpenGold = SoraDGetChildByName(self, "Text_OpenGold")
	self.textOpenGold:setString(i18n("summoned_text_52"))
	self.btnExp:setTitleText(i18n("summoned_text_11"))
	SoraDAutoSizeButtonText(self.btnExp, cc.size(132, 46))
	self.btnResurgence:addTouchEventListener(handler(self, self.onClick_btnResurgence))
	self.btnExp:addTouchEventListener(handler(self, self.onClick_btnExp))
	self.btnAwardPreview:addTouchEventListener(handler(self, self.onClick_btnAwardPreview))
	self.btnReward:addTouchEventListener(handler(self, self.onClick_btnReward))
	self.btnActivite:addTouchEventListener(handler(self, self.onClick_btnActivite))
	self.nodeActivite = SoraDGetChildByName(self, "Node_activite")
	self.leftLine = SoraDGetChildByName(self, "Size_Image_line_C")
	self.nodeText = SoraDGetChildByName(self, "Node_text")
	self:showEffect()
end
function dashToSkyAwardView:showEffect()
	local cssFileName = "dashToSkyAwardView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, 145, true)
	self:runAction(action)
	SoraDGetChildByName(self, "Particle_5"):setAutoCull(false)
	self.cloud_1 = SoraDGetChildByName(self, "Node_Yun_1")
	self.cloud_2 = SoraDGetChildByName(self, "Node_Yun_2")
	self.cloud_3 = SoraDGetChildByName(self, "Node_Yun_3")
	self.cloud_4 = SoraDGetChildByName(self, "Node_Yun_4")
	self.nodeEffectB = SoraDGetChildByName(self, "node_effectB")
	self.cloud_5 = SoraDGetChildByName(self.nodeEffectB, "Node_6_0")
	self.cloud_6 = SoraDGetChildByName(self.nodeEffectB, "Node_6")
	local formPoX = SoraDFIsRA() and 800 or 800
	self.cloud_1:setPositionX(-formPoX)
	self.cloud_2:setPositionX(0)
	self.cloud_3:setPositionX(-formPoX)
	self.cloud_4:setPositionX(0)
	self.cloud_5:setPositionX(-345)
	self.cloud_6:setPositionX(320)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.moveTo(55.5, formPoX, -5)
	;(nil)[2] = cca.callFunc(function()
		self.cloud_1:setPositionX(-formPoX)
	end)
	;(nil)[3] = cca.callFunc(function()
		self.cloud_1:setPositionX(-formPoX)
	end)
	;(nil)[4] = cca.callFunc(function()
		self.cloud_1:setPositionX(-formPoX)
	end)
	;(nil)[5] = cca.callFunc(function()
		self.cloud_1:setPositionX(-formPoX)
	end)
	;(nil)[6] = cca.callFunc(function()
		self.cloud_1:setPositionX(-formPoX)
	end)
	self.cloud_1:runAction(cca.repeatForever(cca.seq(nil)))
	_UPVALUE2_ = cca.repeatForever(cca.seq(nil))
	cca.repeatForever(cca.seq(nil))[1] = cca.moveTo(27.75, formPoX, -5)
	cca.repeatForever(cca.seq(nil))[2] = cca.callFunc(function()
		self.cloud_2:setPositionX(-formPoX)
	end)
	cca.repeatForever(cca.seq(nil))[3] = cca.moveTo(27.75, 0, -5)
	cca.repeatForever(cca.seq(nil))[4] = cca.moveTo(27.75, 0, -5)
	cca.repeatForever(cca.seq(nil))[5] = cca.moveTo(27.75, 0, -5)
	cca.repeatForever(cca.seq(nil))[6] = cca.moveTo(27.75, 0, -5)
	self.cloud_2:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil)))))
	_UPVALUE1_ = cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))[1] = cca.moveTo(83.5, formPoX, -5)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))[2] = cca.callFunc(function()
		self.cloud_3:setPositionX(-formPoX)
	end)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))[3] = cca.callFunc(function()
		self.cloud_3:setPositionX(-formPoX)
	end)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))[4] = cca.callFunc(function()
		self.cloud_3:setPositionX(-formPoX)
	end)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))[5] = cca.callFunc(function()
		self.cloud_3:setPositionX(-formPoX)
	end)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))[6] = cca.callFunc(function()
		self.cloud_3:setPositionX(-formPoX)
	end)
	self.cloud_3:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil)))))))
	_UPVALUE2_ = cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))[1] = cca.moveTo(41.75, formPoX, -5)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))[2] = cca.callFunc(function()
		self.cloud_4:setPositionX(-formPoX)
	end)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))[3] = cca.moveTo(41.75, 0, -5)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))[4] = cca.moveTo(41.75, 0, -5)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))[5] = cca.moveTo(41.75, 0, -5)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))[6] = cca.moveTo(41.75, 0, -5)
	self.cloud_4:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil)))))))))
	_UPVALUE1_ = cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))))
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))))[1] = cca.moveTo(83.5, 665, -255)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))))[2] = cca.callFunc(function()
		self.cloud_5:setPositionX(-345)
	end)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))))[3] = cca.callFunc(function()
		self.cloud_5:setPositionX(-345)
	end)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))))[4] = cca.callFunc(function()
		self.cloud_5:setPositionX(-345)
	end)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))))[5] = cca.callFunc(function()
		self.cloud_5:setPositionX(-345)
	end)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))))[6] = cca.callFunc(function()
		self.cloud_5:setPositionX(-345)
	end)
	self.cloud_5:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil)))))))))))
	_UPVALUE2_ = cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))))))
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))))))[1] = cca.moveTo(41.75, 665, -255)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))))))[2] = cca.callFunc(function()
		self.cloud_6:setPositionX(-345)
	end)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))))))[3] = cca.moveTo(41.75, 320, -255)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))))))[4] = cca.moveTo(41.75, 320, -255)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))))))[5] = cca.moveTo(41.75, 320, -255)
	cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil))))))))))[6] = cca.moveTo(41.75, 320, -255)
	self.cloud_6:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil)))))))))))))
	self.etPetCardNode = SoraDCreatAnimationEx("royalSummonLockEffect", self.etPetCardNode, true, nil)
	SoraDMixtureGLONEByParent(self.etPetCardNode)
	SoraDGetChildByName(self.etPetCardNode, "jiesuo_Node"):setVisible(false)
	SoraDGetChildByName(self.etPetCardNode, "weijiesuo_Node"):setVisible(true)
end
function dashToSkyAwardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ROYAL_SUMMONS_AWARD", handler(self, self.init))
	SoraDAddMessage(self, "MESSAGE_SERVER_ROYAL_SUMMONS_GOLD", handler(self, self.initViewGold))
end
function dashToSkyAwardView:init()
	SoraDCloseLoading(self)
	self:initViewGold()
	self:initViewInfo()
	self:jumpToCurLevel()
end
function dashToSkyAwardView:initViewGold()
	self.isGoldClass = royalSummonsCtrl:isActiveGold()
	self:reFreshEffect()
	self:initBtnStatus()
end
function dashToSkyAwardView:reFreshEffect()
	self.btnResurgence:setVisible(not self.isGoldClass)
	self.goldEffectNode:setVisible(self.isGoldClass)
	self.etPetCardNode:setVisible(not self.isGoldClass)
	SoraDGetChildByName(self, "ft_2"):setColor(self.isGoldClass and cc.c3b(255, 255, 255) or cc.c3b(120, 120, 120))
	SoraDGetChildByName(self, "Node_EffectGold"):setVisible(self.isGoldClass)
end
function dashToSkyAwardView:jumpToCurLevel()
	local lv = royalSummonsCtrl:getCurLevel()
	lv = math.min(#self.levelList, math.max(1, lv))
	self.scroll:jumpIndexToTop(lv)
	self:scrollMove()
end
function dashToSkyAwardView:initViewInfo()
	self.index = nil
	self:initLvInfo()
	self:initScroll()
end
function dashToSkyAwardView:initBtnStatus()
	local str
	if self.isGoldClass then
		_ENV, _ENV = nil, nil
		;(nil).__default, (nil).color = nil, "#FFFF00"
		str = i18n_html("summoned_text_53", nil)
		self.nodeActivite:setVisible(false)
		self.btnReward:setPositionX(0)
	else
		_ENV, _ENV = nil, 0
		;(0).__default, (nil).color = nil, "#ffffff"
		str = i18n_html("summoned_text_55", 0)
		self.nodeActivite:setVisible(true)
	end
	self.txtScrollTitleGod:setString(str)
	SoraDSetTextWidthHeight(self.txtScrollTitleGod, cc.size(188, 40))
	_UPVALUE2_ = -187.5
	;(-187.5)[1] = self.spScrollTitleGod
	;(-187.5)[2] = self.txtScrollTitleGod
	royalSummonsCtrl = self.txtScrollTitleGod
	self.txtScrollTitleGod[1] = 5
	_G.SoraDAlignNodeArrayOnCenterX(SoraDFPosX(-187.5, 0), -187.5, SoraDFIsRA(), self.txtScrollTitleGod)
	self.btnResurgence:setTouchEnabled(not self.isGoldClass)
	self.btnResurgence:setBright(self.isGoldClass)
	local num = royalSummonsCtrl:getAwardNum()
	local enable = 0 < num
	if 1 < num then
		self.btnReward:setTitleText(i18n("summoned_btn_01"))
	else
		self.btnReward:setTitleText(i18n("common_text_1146"))
	end
	self.btnReward:setTouchEnabled(enable)
	self.btnReward:setBright(enable)
end
function dashToSkyAwardView:initLvInfo()
	self.txtLevel:setString(royalSummonsCtrl:getCurLevel())
	SoraDToCenter(self.nodeLevel, 10, not SoraDFIsRA())
	print("self.txtLevel", self.txtLevel:getPositionX())
	local cur, max = royalSummonsCtrl:getCurLevelExp()
	self.nodeProBarPreview:stopAllActions()
	self.nodeProBarPreview:setInitState(false)
	royalSummonsCtrl = false
	;(false).maxValue = max
	;(false).curValue = cur
	self.nodeProBarPreview:setProgressDate(false)
	self.nodeProBarPreview:setInitState(true)
end
function dashToSkyAwardView:initScroll()
	self.levelList = royalSummonsRead:getLevelList(nil, royalSummonsCtrl:getClassType())
	local view = self:getParent():getParent()
	royalSummonsRead = royalSummonsCtrl:getClassType()
	royalSummonsCtrl:getClassType().scroll = self.scroll
	royalSummonsCtrl:getClassType().view = view
	self.scroll:updateScrollView(cc.size(640, 100), self.levelList, 1, royalSummonsCtrl:getClassType())
end
function dashToSkyAwardView:reverseTable(tab)
	local _ENV, tmp
	local tabClone = clone(tab)
	for i = 1, #tabClone do
		tmp[i] = table.remove(tabClone)
	end
	return tmp
end
local STEP = 5
function dashToSkyAwardView:scrollMove()
	if not self.levelList then
		return
	end
	local index = self.scroll:getTopIndex()
	local newIndex = math.ceil((index + self.addNum) / STEP) * STEP
	print("index : ", index, self.addNum, newIndex)
	if newIndex >= #self.levelList then
		newIndex = #self.levelList
	end
	local scrollInner = self.scroll:getInnerContainer()
	local scrollHeight = scrollInner:getContentSize().height
	local offsetY = -scrollInner:getPositionY()
	self.leftLine:setContentSize(cc.size(5, self:getLineSize(newIndex) + 40))
	print("self:getLineSize(newIndex)", self.scroll:getInnerContainerSize().height, newIndex, offsetY, self.scroll:getContentSize().height, self.scroll:getScrolledPercentVertical())
	local offset = 100 - (scrollInner:getContentSize().height - offsetY - self.scroll:getContentSize().height)
	offset = 0 < offset and offset or 0
	if 0 < newIndex and newIndex ~= self.index then
		self.index = newIndex
		local view = self:getParent():getParent()
		_ENV = self.scroll:getContentSize().height
		self.scroll:getContentSize().height.view = view
		self.scroll:getContentSize().height.isLast = newIndex == #self.levelList
		self.nodeSingleView:initData(self.levelList[newIndex], self.scroll:getContentSize().height)
	end
	print(self.scroll:getScrolledPercentVertical())
end
function dashToSkyAwardView:getLineSize(index)
	local scrollWidth = self.scroll:getContentSize().height
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	if index ~= #self.levelList or 100 < offsetY then
		return scrollWidth
	end
	if scrollWidth - (103 - offsetY) < 0 then
		return 0
	end
	return scrollWidth - (103 - offsetY)
end
function dashToSkyAwardView:createSingle()
	local ocx = self.nodeSingle:clone()
	local single = include("royalSummonsMainAwardSingle").new(ocx)
	single:setVisible(true)
	return single
end
function dashToSkyAwardView:onClick_btnResurgence(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgBox(i18n("summoned_text_70"), i18n("common_text_477"), nil, function(msgType)
			if msgType == MSGBOX_CALLBACK_YES then
				local royalSummonsUtil = include("royalSummonsUtil")
				royalSummonsUtil:openShop()
			end
		end)
	end
end
function dashToSkyAwardView:onClick_btnExp(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("dashToSkyShopExpView")
		panel:show()
	end
end
function dashToSkyAwardView:onClick_btnAwardPreview(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("royalSummonsAwardPreviewView")
		panel:show()
	end
end
function dashToSkyAwardView:onClick_btnReward(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		royalSummonsCtrl:reqActivityGetAllLevelReward()
		local panel = SoraDShowLoading(self, nil, nil, true, 3)
		panel:setPositionY(-panel:getPositionY())
	end
end
function dashToSkyAwardView:onClick_btnActivite(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local royalSummonsUtil = include("royalSummonsUtil")
		royalSummonsUtil:openShop()
	end
end
function dashToSkyAwardView:btnHelpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_1173"
		;("common_text_1173")[1] = i18n("summoned_text_68")
		;("common_text_1173")[2] = i18n("summoned_text_68")
		SoraDShowFixWindow(i18n("common_text_1173"), "common_text_1173")
	end
end
function dashToSkyAwardView:setButtonSize()
	local textAwardPreview = SoraDGetChildByName(self.btnAwardPreview, "Text_Info")
	textAwardPreview:setString(i18n("summoned_text_07"))
	local textExp = SoraDGetChildByName(self.btnExp, "Text_Info")
	textExp:setString(i18n("summoned_text_11"))
	local awardSize = textAwardPreview:getContentSize()
	local expSize = textExp:getContentSize()
	local scale = math.min(35 / awardSize.height, 120 / awardSize.width, 35 / expSize.height, 120 / expSize.width)
	textAwardPreview:setScale(1 < scale and 1 or scale)
	textExp:setScale(1 < scale and 1 or scale)
end
return dashToSkyAwardView
