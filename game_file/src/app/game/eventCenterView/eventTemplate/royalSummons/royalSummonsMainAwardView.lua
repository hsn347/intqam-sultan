local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
local royalSummonsRead = include("royalSummonsRead")
local royalSummonsMainAwardView = class("royalSummonsMainAwardView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
function royalSummonsMainAwardView:ctor()
	SoraDGetChildByName(self, "Top_Size_Bg_King"):setFillType(1)
	self.txtActivieyTime = SoraDGetChildByName(self, "Text_activiey_time")
	local strTitle = royalSummonsCtrl:getActivitySeasonEndTitle()
	self.txtActivieyTime:setString(strTitle)
	self.txtLevel = SoraDGetChildByName(self, "Text_level")
	self.txtLevelTitle = SoraDGetChildByName(self, "Text_level_title")
	self.txtProgress = SoraDGetChildByName(self, "Text_progress")
	self.txtAwardPreview = SoraDGetChildByName(self, "Text_award_preview")
	self.txtScrollTitleLevel = SoraDGetChildByName(self, "Text_scroll_title_level")
	self.txtScrollTitleNormal = SoraDGetChildByName(self, "Text_scroll_title_normal")
	self.txtScrollTitleGod = SoraDGetChildByName(self, "Text_scroll_title_god")
	self.txtLevelTitle:setString(i18n("common_text_748"))
	self.txtAwardPreview:setString(i18n("decrypt_text_03"))
	self.txtScrollTitleLevel:setString(i18n("common_text_748"))
	self.txtScrollTitleNormal:setString(i18n("summoned_text_17"))
	self.spScrollTitleNormal = SoraDGetChildByName(self, "Sprite_scroll_title_normal")
	self.spScrollTitleGod = SoraDGetChildByName(self, "Sprite_scroll_title_god")
	_UPVALUE2_ = 100
	;(100)[1] = self.spScrollTitleNormal
	;(100)[2] = self.txtScrollTitleNormal
	royalSummonsCtrl = self.txtScrollTitleNormal
	self.txtScrollTitleNormal[1] = 5
	_G.SoraDAlignNodeArrayOnCenterX(SoraDFPosX(100, 0), 100, SoraDFIsRA(), self.txtScrollTitleNormal)
	self.nodeSingle = SoraDGetChildByName(self, "Node_single")
	self.nodeSingle:setVisible(false)
	self.nodeSingleView = SoraDGetChildByName(self, "Node_single_view")
	self.nodeSingleView = include("royalSummonsMainAwardSingle").new(self.nodeSingleView)
	self.nodeSingleView:createCacheNode()
	self.Node_lock_animate = SoraDGetChildByName(self, "Node_lock_animate")
	self.etPetCardNode = SoraDGetChildByName(self, "et_petcard_unlock_node")
	self.etPetCardNode:setVisible(false)
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
	self.btnActivite:setTitleText(i18n("summoned_text_08"))
	SoraDSetTextWidthHeight(textinfo, cc.size(120, 35))
	self:setButtonSize()
	self.btnResurgence:addTouchEventListener(handler(self, self.onClick_btnResurgence))
	self.btnExp:addTouchEventListener(handler(self, self.onClick_btnExp))
	self.btnAwardPreview:addTouchEventListener(handler(self, self.onClick_btnAwardPreview))
	self.btnReward:addTouchEventListener(handler(self, self.onClick_btnReward))
	self.btnActivite:addTouchEventListener(handler(self, self.onClick_btnActivite))
	self.nodeActivite = SoraDGetChildByName(self, "Node_activite")
	self.txtdActiviteTip = SoraDGetChildByName(self, "Text_activite_tip")
	self.centerEffect = SoraDGetChildByName(self, "Center_Effect")
	self.isGoldClass = false
	self.leftLine = SoraDGetChildByName(self, "Size_Image_line_2")
	self.leftFrame = SoraDGetChildByName(self, "Size_Image_Left")
	self.rightFrame = SoraDGetChildByName(self, "Size_Image_Right")
	self:fitView()
	self:addFire()
	self:initEffect()
end
local fitHeight = 55
function royalSummonsMainAwardView:fitView()
	local height = self:getPanelOffsetHeight()
	self.scaleEffect = 1
	print("···height", height)
	if height < 900 then
		local conterNode = SoraDGetChildByName(self, "Node_conter")
		conterNode:setPositionY(conterNode:getPositionY() + fitHeight)
		local upLine = SoraDGetChildByName(self, "Node_Single_line_3")
		upLine:setPositionY(upLine:getPositionY() + fitHeight)
		self.leftLine:setPositionY(self.leftLine:getPositionY() + fitHeight)
		self.scroll:setPositionY(self.scroll:getPositionY() + fitHeight)
		self.scroll:setContentSize(self.scroll:getContentSize().width, self.scroll:getContentSize().height + fitHeight)
		self.rightFrame:setPositionY(self.rightFrame:getPositionY() + fitHeight)
		self.rightFrame:setContentSize(self.rightFrame:getContentSize().width, self.rightFrame:getContentSize().height + fitHeight)
		self.leftFrame:setPositionY(self.leftFrame:getPositionY() + fitHeight)
		self.leftFrame:setContentSize(self.leftFrame:getContentSize().width, self.leftFrame:getContentSize().height + fitHeight)
		local rightLine = SoraDGetChildByName(self, "ySize_Image_line_Width")
		rightLine:setPositionY(rightLine:getPositionY() + fitHeight)
		rightLine:setContentSize(rightLine:getContentSize().width + fitHeight, rightLine:getContentSize().height)
		self.scaleEffect = 0.8
	end
end
function royalSummonsMainAwardView:setButtonSize()
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
function royalSummonsMainAwardView:initEffect()
	self.leftEffect = self:createShaderEffect(true)
	self.rightEffect = self:createShaderEffect(false)
	self.bgEffect = SoraDCreatAnimation("royalSummonMainAwardEffect", bgEffect, true)
	SoraDMixtureGLONEByParent(self.bgEffect)
	self.centerEffect:addChild(self.bgEffect)
	self.bgEffect:setPosition(0, 20)
	SoraDGetChildByName(self.bgEffect, "jiesuo_Node"):setVisible(false)
	self.centerIcon = sp.SkeletonAnimation:create("spine/junwangzhaojiling.skel", "spine/junwangzhaojiling.atlas", self.scaleEffect)
	self.centerIcon:setVisible(false)
	self.centerIcon:setPosition(0, self:getPanelOffsetHeight() > 900 and -75 or -65)
	self.centerEffect:addChild(self.centerIcon)
	self.centerIcon:setAnimation(0, "animation", true)
	SoraDGetChildByName(self, "G_Particle"):setVisible(false)
	self.etPetCardNode = SoraDCreatAnimationEx("royalSummonLockEffect", self.etPetCardNode, true, nil, 1, 196)
	SoraDMixtureGLONEByParent(self.etPetCardNode)
	SoraDGetChildByName(self.etPetCardNode, "jiesuo_Node"):setVisible(false)
	SoraDGetChildByName(self.etPetCardNode, "weijiesuo_Node"):setVisible(true)
end
function royalSummonsMainAwardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ROYAL_SUMMONS_AWARD", handler(self, self.init))
	SoraDAddMessage(self, "MESSAGE_SERVER_ROYAL_SUMMONS_GOLD", handler(self, self.initViewGold))
end
function royalSummonsMainAwardView:init()
	SoraDCloseLoading(self)
	self:initViewGold()
	self:initViewInfo()
	self:jumpToCurLevel()
end
function royalSummonsMainAwardView:initViewGold()
	self.isGoldClass = royalSummonsCtrl:isActiveGold()
	self:reFreshEffect()
	self:initBtnStatus()
end
function royalSummonsMainAwardView:reFreshEffect()
	self.btnResurgence:setVisible(not self.isGoldClass)
	SoraDGetChildByName(self, "G_Particle"):setVisible(self.isGoldClass)
	self.etPetCardNode:setVisible(not self.isGoldClass)
	self.centerIcon:setVisible(self.isGoldClass)
	SoraDGetChildByName(self.bgEffect, "jiesuo_Node"):setVisible(self.isGoldClass)
	self.leftEffect:setVisible(self.isGoldClass)
	self.rightEffect:setVisible(self.isGoldClass)
end
function royalSummonsMainAwardView:jumpToCurLevel()
	local lv = royalSummonsCtrl:getCurLevel()
	lv = math.min(#self.levelList, math.max(1, lv))
	self.scroll:jumpIndexToTop(lv)
	self:scrollMove()
end
function royalSummonsMainAwardView:initViewInfo()
	self.index = nil
	self:initLvInfo()
	self:initScroll()
end
function royalSummonsMainAwardView:initBtnStatus()
	if self.isGoldClass then
		self.txtScrollTitleGod:setString(i18n("summoned_text_19"))
		self.nodeActivite:setVisible(false)
		self.Node_lock_animate:setVisible(false)
		self.btnReward:setPositionX(0)
	else
		self.txtScrollTitleGod:setString(i18n("summoned_text_18"))
		self.nodeActivite:setVisible(true)
		self.Node_lock_animate:setVisible(true)
		if royalSummonsCtrl:isMaxLevel() then
			local num = royalSummonsCtrl:getAwardNum(true)
			_ENV = i18n("summoned_text_18")
			i18n("summoned_text_18").num = num
			self.txtdActiviteTip:setString(i18n("summoned_text_06", i18n("summoned_text_18")))
		else
			self.txtdActiviteTip:setString(i18n("summoned_text_05"))
		end
		SoraDSetTextWidthHeight(self.txtdActiviteTip, cc.size(630, 25))
	end
	SoraDSetTextWidthHeight(self.txtScrollTitleLevel, cc.size(180, 25))
	_UPVALUE2_ = -180
	;(-180)[1] = self.spScrollTitleGod
	;(-180)[2] = self.txtScrollTitleGod
	royalSummonsCtrl = self.txtScrollTitleGod
	self.txtScrollTitleGod[1] = 5
	_G.SoraDAlignNodeArrayOnCenterX(SoraDFPosX(-180, 0), -180, SoraDFIsRA(), self.txtScrollTitleGod)
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
function royalSummonsMainAwardView:initLvInfo()
	local lv = royalSummonsCtrl:getCurLevel()
	self.txtLevel:setString(lv)
	_UPVALUE2_ = lv
	lv[1] = self.txtLevel
	lv[2] = self.txtLevelTitle
	_ENV = self.txtLevelTitle
	self.txtLevelTitle[1] = 10
	_G.SoraDAlignNodeArrayOnCenterX(0, lv, not SoraDFIsRA(), self.txtLevelTitle)
	local cur, max = royalSummonsCtrl:getCurLevelExp()
	self.nodeProBarPreview:stopAllActions()
	self.nodeProBarPreview:setInitState(false)
	royalSummonsCtrl = false
	;(false).maxValue = max
	;(false).curValue = cur
	self.nodeProBarPreview:setProgressDate(false)
	self.nodeProBarPreview:setInitState(true)
end
function royalSummonsMainAwardView:initScroll()
	self.levelList = royalSummonsRead:getLevelList(nil, royalSummonsCtrl:getClassType())
	local view = self:getParent():getParent()
	royalSummonsRead = royalSummonsCtrl:getClassType()
	royalSummonsCtrl:getClassType().scroll = self.scroll
	royalSummonsCtrl:getClassType().view = view
	self.scroll:updateScrollView(cc.size(640, 86), self.levelList, 1, royalSummonsCtrl:getClassType())
end
local STEP = 5
function royalSummonsMainAwardView:scrollMove()
	if not self.levelList then
		return
	end
	local index = self.scroll:getTopIndex()
	local newIndex = math.ceil((index + self.addNum) / STEP) * STEP
	if newIndex >= #self.levelList then
		newIndex = #self.levelList
	end
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	self.leftLine:setContentSize(cc.size(5, self:getLineSize(newIndex) + 40))
	self.rightFrame:setContentSize(cc.size(280, self:getLineSize(newIndex)))
	self.leftFrame:setContentSize(cc.size(280, self:getLineSize(newIndex)))
	SoraDGetChildByName(self.nodeSingleView, "Size_Image_line"):setVisible(newIndex ~= #self.levelList and not (offsetY < -self.scroll:getContentSize().height))
	if 0 < index and index ~= self.index then
		self.index = index
		local view = self:getParent():getParent()
		_ENV = cc.size(280, self:getLineSize(newIndex))
		cc.size(280, self:getLineSize(newIndex)).view = view
		cc.size(280, self:getLineSize(newIndex)).isLast = true
		self.nodeSingleView:initData(self.levelList[newIndex], cc.size(280, self:getLineSize(newIndex)))
	end
end
function royalSummonsMainAwardView:getLineSize(index)
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
function royalSummonsMainAwardView:createSingle()
	local ocx = self.nodeSingle:clone()
	local single = include("royalSummonsMainAwardSingle").new(ocx)
	single:setVisible(true)
	return single
end
function royalSummonsMainAwardView:addFire()
	self.Node_fire_L = SoraDGetChildByName(self, "Node_fire_L")
	local nodeFireL = _G.SoraDGetCommonJetFireNode(true)
	nodeFireL:setPositionY(100)
	nodeFireL:addTo(self.Node_fire_L)
	self.Node_fire_R = SoraDGetChildByName(self, "Node_fire_R")
	local nodeFireR = _G.SoraDGetCommonJetFireNode(true)
	nodeFireR:setPositionY(100)
	nodeFireR:addTo(self.Node_fire_R)
end
function royalSummonsMainAwardView:onClick_btnResurgence(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgBox(i18n("summoned_text_50"), i18n("common_text_477"), nil, function(msgType)
			if msgType == MSGBOX_CALLBACK_YES then
				local royalSummonsUtil = include("royalSummonsUtil")
				royalSummonsUtil:openShop()
			end
		end)
	end
end
function royalSummonsMainAwardView:onClick_btnExp(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("royalSummonsShopExpView")
		panel:show()
	end
end
function royalSummonsMainAwardView:onClick_btnAwardPreview(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("royalSummonsAwardPreviewView")
		panel:show()
	end
end
function royalSummonsMainAwardView:onClick_btnReward(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		royalSummonsCtrl:reqActivityGetAllLevelReward()
		local panel = SoraDShowLoading(self, nil, nil, true, 3)
		panel:setPositionY(-panel:getPositionY())
	end
end
function royalSummonsMainAwardView:onClick_btnActivite(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local royalSummonsUtil = include("royalSummonsUtil")
		royalSummonsUtil:openShop()
	end
end
function royalSummonsMainAwardView:createShaderEffect(isLeft)
	local cb1Shader = require("app.game.eventCenterView.eventTemplate.royalSummons.shader.junwang")
	local cb1MeshData = require("app.game.eventCenterView.eventTemplate.royalSummons.meshData.cb1_meshData")
	local cb1Param = require("app.game.eventCenterView.eventTemplate.royalSummons.shaderCfg.cb1_shaderCfg")
	_ENV = "app.game.eventCenterView.eventTemplate.royalSummons.shaderCfg.cb1_shaderCfg"
	;("app.game.eventCenterView.eventTemplate.royalSummons.shaderCfg.cb1_shaderCfg").meshData = cb1MeshData
	_ENV, ("app.game.eventCenterView.eventTemplate.royalSummons.shaderCfg.cb1_shaderCfg").size = cc.size(1, 1), cc.size(1, 1)
	cc.size(1, 1).vertBytes = cb1Shader.vertBytes
	;("app.game.eventCenterView.eventTemplate.royalSummons.shaderCfg.cb1_shaderCfg").shader, cc.size(1, 1).fragBytes = cc.size(1, 1), cb1Shader.fragBytes
	_ENV, ("app.game.eventCenterView.eventTemplate.royalSummons.shaderCfg.cb1_shaderCfg").param = cb1Param.param, cb1Param.param
	cb1Param.param.x = 0.28
	;("app.game.eventCenterView.eventTemplate.royalSummons.shaderCfg.cb1_shaderCfg").scale, cb1Param.param.y = cb1Param.param, 0.28
	local cb1CreateData = "app.game.eventCenterView.eventTemplate.royalSummons.shaderCfg.cb1_shaderCfg"
	local cb1MeshNode = SoraDCreateMeshNode(cb1CreateData.meshData, cb1CreateData.size, cb1CreateData.shader, cb1CreateData.param)
	cb1MeshNode:setPosition(cc.p(isLeft and 60 or -60, 10))
	cb1MeshNode:setScale(cb1CreateData.scale.x, cb1CreateData.scale.y)
	cb1MeshNode:setBlendFunc(gl.ONE, gl.ONE)
	_ENV = gl.ONE
	gl.ONE.x = 0
	gl.ONE.y = isLeft and 0 or -180
	gl.ONE.z = 0
	cb1MeshNode:setRotation3D(gl.ONE)
	cb1MeshNode:addTo(self.centerEffect, 99)
	cb1MeshNode:setAutoCull(false)
	cb1MeshNode:setVisible(false)
	return cb1MeshNode
end
return royalSummonsMainAwardView
