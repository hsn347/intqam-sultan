local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
local royalSummonsRead = include("royalSummonsRead")
local royalSummonsShopExpView = class("royalSummonsShopExpView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("royalSummonsShopExpView")
	end
	return target
end)
function royalSummonsShopExpView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("summoned_text_12"))
	self.single = SoraDGetChildByName(self, "panel_single")
	self.single:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "ScrollView_award")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.progress_fg = SoraDGetChildByName(self, "LoadingBar_progress_fg")
	self.centerEffect = SoraDGetChildByName(self, "Center_Effect")
	self.btnResurgence = SoraDGetChildByName(self, "Button_resurgence")
	self.Node_lock_animate = SoraDGetChildByName(self, "Node_lock_animate")
	self.etPetCardNode = SoraDGetChildByName(self.Node_lock_animate, "et_petcard_unlock_node")
	self.etPetCardNode:setVisible(false)
	self.txtLevel = SoraDGetChildByName(self, "Text_level")
	self.txtLevelTitle = SoraDGetChildByName(self, "Text_level_title")
	self.txtLevelTitle:setString(i18n("common_text_748"))
	self.nodePro = SoraDGetChildByName(self, "node_probar_head")
	self.nodeProBarPreview = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_preview")
	self.nodeProBarPreview:setActionDelay(0.5)
	self.nodeProBarPreview:setHandle(function(data)
		local curPro = 100 * data.actionValue / data.maxValue
		local posx = SoraDFPosX(175 - curPro * 350 / 100, 0)
		self.nodePro:setPositionX(posx)
	end)
	self.btnResurgence:addTouchEventListener(handler(self, self.onClick_btnResurgence))
	_UPVALUE1_ = self.btnResurgence
	self.btnResurgence[1] = cca.fadeTo(0, 1.0)
	self.btnResurgence[2] = cca.fadeTo(1.05, 0.5)
	self.btnResurgence[3] = cca.fadeTo(1.05, 0.5)
	self.btnResurgence[4] = cca.fadeTo(1.05, 0.5)
	local seq = cca.seq(self.btnResurgence)
	self.spBar = SoraDGetChildByName(self, "Sprite_bar")
	self.spBar:runAction(cc.RepeatForever:create(seq))
	self:initEffect()
	self:initData()
	self:addFire()
end
function royalSummonsShopExpView:initEffect()
	self.leftEffect = self:createShaderEffect(true)
	self.rightEffect = self:createShaderEffect(false)
	self.bgEffect = SoraDCreatAnimation("royalSummonMainAwardEffect", bgEffect, true)
	SoraDMixtureGLONEByParent(self.bgEffect)
	self.centerEffect:addChild(self.bgEffect)
	self.bgEffect:setPosition(0, -70)
	SoraDGetChildByName(self.bgEffect, "jiesuo_Node"):setVisible(false)
	self.centerIcon = sp.SkeletonAnimation:create("spine/junwangzhaojiling.skel", "spine/junwangzhaojiling.atlas", 0.95)
	self.centerIcon:setVisible(true)
	self.centerIcon:setPosition(0, -155)
	self.centerEffect:addChild(self.centerIcon)
	self.centerIcon:setAnimation(0, "animation", true)
	SoraDGetChildByName(self, "G_Particle"):setVisible(false)
	self.etPetCardNode = SoraDCreatAnimationEx("royalSummonLockEffect", self.etPetCardNode, true, nil, 1, 196)
	SoraDMixtureGLONEByParent(self.etPetCardNode)
	SoraDGetChildByName(self.etPetCardNode, "jiesuo_Node"):setVisible(false)
	SoraDGetChildByName(self.etPetCardNode, "weijiesuo_Node"):setVisible(true)
end
function royalSummonsShopExpView:onClick_btnResurgence(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:addAnimation()
	end
end
function royalSummonsShopExpView:reFreshEffect()
	self.btnResurgence:setVisible(not self.isGoldClass)
	SoraDGetChildByName(self, "G_Particle"):setVisible(self.isGoldClass)
	self.etPetCardNode:setVisible(not self.isGoldClass)
	self.centerIcon:setVisible(self.isGoldClass)
	SoraDGetChildByName(self.bgEffect, "jiesuo_Node"):setVisible(self.isGoldClass)
	self.leftEffect:setVisible(self.isGoldClass)
	self.rightEffect:setVisible(self.isGoldClass)
end
function royalSummonsShopExpView:initData(data)
	self.itemList, _ENV = nil, nil
	print("刷新scroll-----")
	local exchangeList = royalSummonsRead:getExpShopList(royalSummonsCtrl:getClassType())
	for _, v in ipairs(exchangeList) do
		_ENV = royalSummonsCtrl:getClassType()
		royalSummonsCtrl:getClassType().itemdata = v
		table.insert(self.itemList, royalSummonsCtrl:getClassType())
	end
	_ENV = table.insert
	table.insert.scroll = self.scroll
	self.scroll:updateScrollView(cc.size(640, 126), self.itemList, 1, table.insert)
	self.isGoldClass = royalSummonsCtrl:isActiveGold()
	self:reFreshEffect()
	self.btnResurgence:setBright(self.isGoldClass)
	self.Node_lock_animate:setVisible(not self.isGoldClass)
	self:initLvInfo()
end
function royalSummonsShopExpView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ROYAL_SUMMONS_AWARD", handler(self, self.sMsgBuySuccess))
end
function royalSummonsShopExpView:createSingle()
	local ocx = self.single:clone()
	local single = include("royalSummonsShopExpSingle").new(ocx)
	single:setVisible(true)
	single:setScroll(self.scroll)
	single:setParentView(self)
	single:setView(self)
	return ocx
end
function royalSummonsShopExpView:showLoading()
	SoraDShowLoading(self, nil, nil, true)
end
function royalSummonsShopExpView:closeLoading()
	SoraDCloseLoading(self)
end
function royalSummonsShopExpView:sMsgBuySuccess(target, data)
	self:initData()
	self:closeLoading()
end
function royalSummonsShopExpView:setLvInfo()
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
	self.lv = lv
	self.cur = cur
	self.max = max
end
function royalSummonsShopExpView:initLvInfo()
	if not self.lv then
		self:setLvInfo()
	else
		self:addAnimation()
	end
end
function royalSummonsShopExpView:addFire()
	self.Node_fire_L = SoraDGetChildByName(self, "Node_fire_L")
	local nodeFireL = _G.SoraDGetCommonJetFireNode(true)
	nodeFireL:setPositionY(100)
	nodeFireL:addTo(self.Node_fire_L)
	self.Node_fire_R = SoraDGetChildByName(self, "Node_fire_R")
	local nodeFireR = _G.SoraDGetCommonJetFireNode(true)
	nodeFireR:setPositionY(100)
	nodeFireR:addTo(self.Node_fire_R)
end
function royalSummonsShopExpView:addAnimation()
	local royalSummonsCtrl, actionArray
	local lv = royalSummonsCtrl:getCurLevel()
	local cur, max = royalSummonsCtrl:getCurLevelExp()
	table.insert(actionArray, cca.callFunc(function(...)
		self = nil
		;(nil).maxValue = max
		;(nil).curValue = self.cur
		self.nodeProBarPreview:setProgressDate(nil)
	end))
	if lv > self.lv then
		for i = 1, lv - self.lv do
			do
				table.insert(actionArray, cca.callFunc(function(...)
					self = nil
					;(nil).maxValue = max
					;(nil).curValue = max
					self.nodeProBarPreview:setProgressDate(nil)
				end))
				table.insert(actionArray, cca.delay(0.5))
				local curlv = self.lv + i
				table.insert(actionArray, cca.callFunc(function(...)
					self:showExpFullOnce(curlv)
					self.nodeProBarPreview:setInitState(false)
					self = false
					;(false).maxValue = max
					;(false).curValue = 0
					self.nodeProBarPreview:setProgressDate(false)
				end))
			end
		end
	end
	table.insert(actionArray, cca.callFunc(function(...)
		self = nil
		;(nil).maxValue = max
		;(nil).curValue = cur
		self.nodeProBarPreview:setProgressDate(nil)
	end))
	local seqProgress = cca.seq(actionArray)
	self.nodeProBarPreview:stopAllActions()
	self.nodeProBarPreview:runAction(seqProgress)
	self.lv = lv
	self.cur = cur
	self.max = max
end
function royalSummonsShopExpView:showExpFullOnce(lv)
	print(lv, "lv")
	self.txtLevel:setString(lv)
	_UPVALUE2_ = self.txtLevel
	self.txtLevel[1] = cca.fadeTo(0, 0)
	self.txtLevel[2] = cca.fadeTo(0.11666666666666667, 1.0)
	self.txtLevel[3] = cca.fadeTo(0.5, 0)
	self.txtLevel[4] = cca.fadeTo(0.5, 0)
	self.txtLevel[5] = cca.fadeTo(0.5, 0)
	local seq = cca.seq(self.txtLevel)
	self.progress_fg:stopAllActions()
	self.progress_fg:runAction(seq)
end
function royalSummonsShopExpView:createShaderEffect(isLeft)
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
	cb1MeshNode:setPosition(cc.p(isLeft and 60 or -60, -75))
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
return royalSummonsShopExpView
