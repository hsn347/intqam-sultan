local heroBiographyRead = include("heroBiographyRead")
local heroBiographyCtrl = SoraDGetCtrl("heroBiographyCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroCollectedBiographiesPanel = class("HeroCollectedBiographiesPanel", baseFguiPanel)
function HeroCollectedBiographiesPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroCollectedBiographiesPanel:ctor", self.viewName)
end
function HeroCollectedBiographiesPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroCollectedBiographiesPanel:onInit()
	print("=======HeroCollectedBiographiesPanel:onInit")
	self.isRunning = false
	self.groupIndexArray = heroBiographyRead.getStoryIndexList()
	self.index = 1
	self.skillSingleTb, _ENV, self.realIndex = heroBiographyRead.getStoryIndexList(), heroBiographyRead.getStoryIndexList(), 1
	self.totalIndex = heroBiographyRead.getStoryNum()
	self.fields.Com_title:initData(i18n("Biography_text_11"), handler(self, self.onClickClose))
	self.fields.Button_story:setString(i18n("Biography_text_12"))
	self.fields.Button_story:addClickListener(handler(self, self.onStoryClick))
	self.fields.Button_advance:setString(i18n("Biography_text_13"))
	self.fields.Button_advance:addClickListener(handler(self, self.onAdvanceClick))
	self.fields.Button_lArrow:addClickListener(handler(self, self.onLeftClick))
	self.fields.Button_rArrow:addClickListener(handler(self, self.onRightClick))
	self.fields.Com_Lock:addClickListener(handler(self, self.onUnlockClick))
	self.fields.Button_move:setSwallowTouches(false)
	self.fields.Button_move:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onInClick))
	self.fields.Button_move:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onOutClick))
	self.fields.List_pagePoint:setNeedAutoFix(false)
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillItemRender))
	self.Node_shader = display.newNode()
	self.fields.Node_Shader:displayObject():addChild(self.Node_shader)
	self.fields.Com_lockActive:setVisible(false)
	for i = 1, 11 do
		self.fields[string.format("Particle_%d", i)]:setAutoCull(false)
	end
	SoraDTestButton(self, function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_HERO_STORY_UPDATE"
		;(nil).isUnlock = true
		SoraDSendMessage(nil)
	end)
end
function HeroCollectedBiographiesPanel:onShow()
	print("=======HeroCollectedBiographiesPanel:onShow")
	self.fields.List_pagePoint:setNumItems(self.totalIndex)
	if self.proxy.param and self.proxy.param.index then
		self.index = math.min(#self.groupIndexArray, self.proxy.param.index)
		self.realIndex = self.groupIndexArray[self.index]
		self:updateView()
	else
		self:initData()
	end
end
function HeroCollectedBiographiesPanel:initData()
	self.isAllOpen = heroBiographyCtrl:isAllHeroStoryOpen()
	if self.isAllOpen then
		heroBiographyCtrl = nil
		;(nil).byUID = true
		self.index = SoraDConfigGet("Game:heroStory:viewIndex~integer", nil) or 1
	else
		local unlockNum = heroBiographyCtrl:getUnlockHeroStoryNum()
		local lockIndex = 1
		if 0 < unlockNum then
			lockIndex = heroBiographyCtrl:getUnlockHeroStoryIndex()
		end
		self.index = lockIndex
	end
	self.index = math.min(#self.groupIndexArray, self.index)
	self.realIndex = self.groupIndexArray[self.index]
	self:updateView()
end
function HeroCollectedBiographiesPanel:updateView(target, data)
	self:updateHeroStyle()
	self.fields.Icon_Name:setSpriteFrame(heroBiographyRead.getStoryName(self.realIndex))
	self.fields.List_pagePoint:setSelectedIndex(self.index - 1)
	self:updateDirBtn()
	self:updateUnlockBtn()
	self:updateSkillShow()
	self.transitions.t0:play(1, 0, 0, -1)
end
function HeroCollectedBiographiesPanel:updateDirBtn()
	self.fields.Button_lArrow:setVisible(self.index > 1)
	self.fields.Button_rArrow:setVisible(self.index < self.totalIndex)
end
function HeroCollectedBiographiesPanel:updateHeroStyle()
	self.fields.HeroStoryStyle:initData(self.realIndex, self)
end
function HeroCollectedBiographiesPanel:updateUnlockBtn()
	self.retStatus = heroBiographyCtrl:getHeroStoryStatus(self.realIndex)
	self.fields.Com_Lock:setVisible(self.retStatus ~= gHeroStoryUnLockType.ACTIVED)
	self.fields.Com_Lock:getController("c1"):setSelectedIndex(self.retStatus == gHeroStoryUnLockType.LOCK and 0 or 1)
	if self.retStatus == gHeroStoryUnLockType.UNLOCK then
		self.fields.Com_Lock:getTransition("t0"):play(-1, 0, 0, -1)
	end
	self.fields.Button_advance:setVisible(IsArClient and self.retStatus == gHeroStoryUnLockType.ACTIVED and not heroBiographyCtrl:isHeroStoryAdvanced(self.realIndex))
end
function HeroCollectedBiographiesPanel:updateSkillShow()
	self.fields.Text_box:setString(self.retStatus == gHeroStoryUnLockType.ACTIVED and i18n("common_title_03") or i18n("Biography_text_14"))
	self.retArray, self.mergeArray = heroBiographyRead.getStorySkillShowArray(self.realIndex)
	self.fields.List_skill:setNumItems(#self.mergeArray)
end
function HeroCollectedBiographiesPanel:runUnlockEffect()
	self.isRunning = true
	_UPVALUE4_ = nil
	;(nil)[1] = ffa.callFunc(function()
		self.fields.Com_Lock:setVisible(false)
	end)
	;(nil)[2] = ffa.delay(0.25)
	;(nil)[3] = ffa.callFunc(function()
		self:unlockAction()
		self.fields.Particle_1:setVisible(true)
		self.fields.Particle_1:resetSystem()
	end)
	;(nil)[4] = ffa.delay(1.5)
	;(nil)[5] = ffa.callFunc(function()
		self:updateUnlockBtn()
		self:updateHeroStyle()
		self.isRunning = false
	end)
	;(nil)[6] = ffa.callFunc(function()
		self:updateUnlockBtn()
		self:updateHeroStyle()
		self.isRunning = false
	end)
	self:runAction(ffa.seq(nil))
end
function HeroCollectedBiographiesPanel:unlockAction()
	local viewSize = self:getContentSize()
	if self.unlockRenderTexture == nil then
		self.unlockRenderTexture = cc.RenderTexture:create(self:getWidth(), self:getHeight(), cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, 35056)
		self.unlockRenderTexture:addTo(self.Node_shader)
		self.unlockRenderTexture:setPosition(cc.p(self:getWidth() / 2, self:getHeight() / 2))
		self.unlockRenderTexture:setVisible(false)
		self.unlockRenderTexture:beginWithClear(0, 0, 0, 0, 1, 0)
		self.controllers.c1:setSelectedIndex(1)
		self:displayObject():visit()
		self.controllers.c1:setSelectedIndex(0)
		self.unlockRenderTexture:endToLua()
	end
	local shenqi15Shader = require("app.game.smithyView.artifactView.shader.shenqi16_shader")
	local _ENV, shenqi15MeshParam = "app.game.smithyView.artifactView.shader.shenqi16_shader", "app.game.smithyView.artifactView.shader.shenqi16_shader"
	local shenqi15MeshData = require("app.game.smithyView.artifactView.meshData.shenqi15_meshData")
	for i, v in ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi16_shaderCfg").param) do
		table.insert(shenqi15MeshParam, v)
	end
	_ENV = ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi16_shaderCfg").param)
	ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi16_shaderCfg").param).attr = "#texture"
	ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi16_shaderCfg").param).name = "_GrabTexture"
	ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi16_shaderCfg").param).value = self.unlockRenderTexture:getSprite():getTexture()
	ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi16_shaderCfg").param).hasMipmap = false
	table.insert(shenqi15MeshParam, ipairs(require("app.game.smithyView.artifactView.shaderCfg.shenqi16_shaderCfg").param))
	_ENV = table.insert
	table.insert.size = cc.size(1, 1)
	_ENV, table.insert.meshData = cc.size(1, 1), shenqi15MeshData
	cc.size(1, 1).vertBytes = shenqi15Shader.vertBytes
	table.insert.shader, cc.size(1, 1).fragBytes = cc.size(1, 1), shenqi15Shader.fragBytes
	table.insert.param = shenqi15MeshParam
	_ENV, table.insert.pos = cc.p(viewSize.width / 2, viewSize.height / 2 + 100), cc.p(viewSize.width / 2, viewSize.height / 2 + 100)
	cc.p(viewSize.width / 2, viewSize.height / 2 + 100).x = 1
	table.insert.scale, cc.p(viewSize.width / 2, viewSize.height / 2 + 100).y = cc.p(viewSize.width / 2, viewSize.height / 2 + 100), 1
	local shenqi15Data = table.insert
	self.shenqi15Bg = SoraDCreateMeshNode(shenqi15Data.meshData, shenqi15Data.size, shenqi15Data.shader, shenqi15Data.param)
	self.shenqi15Bg:setPosition(cc.p(shenqi15Data.pos))
	self.shenqi15Bg:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.shenqi15Bg:addTo(self.Node_shader)
	self:createShaderAction(1.5, 0, 5, "_Control", self.shenqi15Bg, function(...)
		if self.shenqi15Bg then
			self.shenqi15Bg:removeFromParent()
			self.shenqi15Bg = nil
			self.unlockRenderTexture:removeFromParent()
			self.unlockRenderTexture = nil
		end
	end)
end
function HeroCollectedBiographiesPanel:createShaderAction(sdt, starV, endV, key, shaderNode, handle)
	local step = (endV - starV) / sdt
	local sign = endV < starV and -1 or 1
	local shaderTimerCallBack = function(dt)
		if 0 < sign and starV < endV or sign < 0 and starV > endV or sign == 0 and 0 < sdt then
			if shaderNode and not tolua.isnull(shaderNode) then
				shaderNode:getGLProgramState():setUniformFloat(key, starV)
			end
		elseif shaderNode and not tolua.isnull(shaderNode) then
			shaderNode:getGLProgramState():setUniformFloat(key, endV)
			SoraDManagerRemoveTimer(self, shaderNode.shaderTimer)
			if handle then
				handle(shaderNode, key)
			end
		end
	end
	if shaderNode and not tolua.isnull(shaderNode) then
		shaderNode.shaderTimer = SoradCreateTimer(self, shaderTimerCallBack, true)
		shaderTimerCallBack(0)
	end
end
function HeroCollectedBiographiesPanel:onSkillItemRender(index, target)
	target:setText(i18n(self.mergeArray[index + 1].des))
	target:fixChildrenPos()
end
function HeroCollectedBiographiesPanel:onStoryClick()
	SoraDPlaySound()
	print("点击列传故事")
	_ENV = nil
	;(nil).type = 0
	;(nil).index = self.realIndex
	uiManager:show("HeroTask", nil)
end
function HeroCollectedBiographiesPanel:onAdvanceClick()
	SoraDPlaySound()
	print("点击精进")
	_ENV = nil
	;(nil).index = self.realIndex
	uiManager:show("HeroCollectedBiographiesPop", nil)
end
function HeroCollectedBiographiesPanel:onLeftClick()
	SoraDPlaySound()
	if self.isRunning then
		return
	end
	print("左切换")
	self.index = math.max(self.index - 1, 1)
	self.index = math.min(#self.groupIndexArray, self.index)
	if self.groupIndexArray[self.index] ~= self.realIndex then
		self.realIndex = self.groupIndexArray[self.index]
		self:updateView()
	end
end
function HeroCollectedBiographiesPanel:onRightClick()
	SoraDPlaySound()
	if self.isRunning then
		return
	end
	print("右切换")
	self.index = math.min(self.index + 1, #self.groupIndexArray)
	self.index = math.min(#self.groupIndexArray, self.index)
	if self.groupIndexArray[self.index] ~= self.realIndex then
		self.realIndex = self.groupIndexArray[self.index]
		self:updateView()
	end
end
function HeroCollectedBiographiesPanel:onUnlockClick()
	SoraDPlaySound()
	if self.retStatus == gHeroStoryUnLockType.UNLOCK then
		SoraDShowLoading(self)
		heroBiographyCtrl:reqUnlock(self.realIndex)
	elseif self.retStatus == gHeroStoryUnLockType.LOCK then
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local noneList = heroBiographyCtrl:getNoneHeros(self.realIndex)
		local _ENV, nameStr = heroBiographyCtrl, heroBiographyCtrl
		for k, v in ipairs(noneList) do
			table.insert(nameStr, i18n(heroltCtrl.getHeroName(v)))
		end
		_ENV = nil
		;(nil).heros = table.concat(nameStr, ",")
		SoraDShowMsgTip(i18n("Biography_text_20", nil))
	end
end
function HeroCollectedBiographiesPanel:onInClick(context)
	self.posBegin = context:getInput():getPosition()
end
function HeroCollectedBiographiesPanel:onOutClick(context)
	self.posEnd = context:getInput():getPosition()
	if self.posBegin and self.posEnd then
		if self.posEnd.x - self.posBegin.x >= 30 then
			self:onLeftClick()
		elseif self.posEnd.x - self.posBegin.x <= -30 then
			self:onRightClick()
		end
		self.posBegin = nil
		self.posEnd = nil
	end
end
function HeroCollectedBiographiesPanel:onHide()
	if self.isAllOpen then
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:heroStory:viewIndex~integer", self.index, nil)
	end
end
return HeroCollectedBiographiesPanel
