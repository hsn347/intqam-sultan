local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
local royalSummonsRead = include("royalSummonsRead")
local dashToSkyShopExpView = class("dashToSkyShopExpView", function(target)
	if target == nil then
		target = SoraDCreateTouchPanel("dashToSkyShopExpView")
	end
	return target
end)
function dashToSkyShopExpView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("summoned_text_56"))
	self.single = SoraDGetChildByName(self, "panel_single")
	self.single:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "ScrollView_award")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.panelCutP = SoraDGetChildByName(self, "Panel_1")
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
	local loop = true
	local cssFileName = "dashToSkyShopExpView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, 145, loop)
	self:runAction(action)
	self.btnResurgence:addTouchEventListener(handler(self, self.onClick_btnResurgence))
	self:initEffect()
	self:initData()
end
function dashToSkyShopExpView:initEffect()
	SoraDGetChildByName(self, "Particle_3"):stopSystem()
	self.etPetCardNode = SoraDCreatAnimationEx("royalSummonLockEffect", self.etPetCardNode, true, nil)
	SoraDMixtureGLONEByParent(self.etPetCardNode)
	SoraDGetChildByName(self.etPetCardNode, "jiesuo_Node"):setVisible(false)
	SoraDGetChildByName(self.etPetCardNode, "weijiesuo_Node"):setVisible(true)
end
function dashToSkyShopExpView:onClick_btnResurgence(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:addAnimation()
	end
end
function dashToSkyShopExpView:reFreshEffect()
	self.btnResurgence:setVisible(not self.isGoldClass)
	SoraDGetChildByName(self, "Center_Effect"):setVisible(self.isGoldClass)
	self.etPetCardNode:setVisible(not self.isGoldClass)
	SoraDGetChildByName(self, "ft_2"):setColor(self.isGoldClass and cc.c3b(250, 250, 250) or cc.c3b(120, 120, 120))
	SoraDGetChildByName(self, "Node_EffectGold"):setVisible(self.isGoldClass)
end
function dashToSkyShopExpView:initData(data)
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
	self.scroll:updateScrollView(cc.size(600, 110), self.itemList, 1, table.insert)
	self.isGoldClass = royalSummonsCtrl:isActiveGold()
	self:reFreshEffect()
	self.btnResurgence:setBright(self.isGoldClass)
	self.Node_lock_animate:setVisible(not self.isGoldClass)
	self:initLvInfo()
end
function dashToSkyShopExpView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ROYAL_SUMMONS_AWARD", handler(self, self.sMsgBuySuccess))
end
function dashToSkyShopExpView:createSingle()
	local ocx = self.single:clone()
	local single = include("royalSummonsShopExpSingle").new(ocx)
	single:setVisible(true)
	single:setScroll(self.scroll)
	single:setParentView(self)
	single:setView(self)
	return ocx
end
function dashToSkyShopExpView:showLoading()
	SoraDShowLoading(self, nil, nil, true)
end
function dashToSkyShopExpView:closeLoading()
	SoraDCloseLoading(self)
end
function dashToSkyShopExpView:sMsgBuySuccess(target, data)
	self:initData()
	self:closeLoading()
end
function dashToSkyShopExpView:setLvInfo()
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
	self.panelCutP:setContentSize(cc.size(342 * cur / max, 22))
	self.lv = lv
	self.cur = cur
	self.max = max
end
function dashToSkyShopExpView:initLvInfo()
	if not self.lv then
		self:setLvInfo()
	else
		self:addAnimation()
	end
end
function dashToSkyShopExpView:addFire()
end
function dashToSkyShopExpView:addAnimation()
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
		self.panelCutP:setContentSize(cc.size(342 * cur / max, 22))
		self = cc.size(342 * cur / max, 22)
		cc.size(342 * cur / max, 22).maxValue = max
		cc.size(342 * cur / max, 22).curValue = cur
		self.nodeProBarPreview:setProgressDate(cc.size(342 * cur / max, 22))
	end))
	local seqProgress = cca.seq(actionArray)
	self.nodeProBarPreview:stopAllActions()
	self.nodeProBarPreview:runAction(seqProgress)
	self.lv = lv
	self.cur = cur
	self.max = max
end
function dashToSkyShopExpView:showExpFullOnce(lv)
	print(lv, "lv")
	self.txtLevel:setString(lv)
	_UPVALUE2_ = self.txtLevel
	self.txtLevel[1] = cca.fadeTo(0, 0)
	self.txtLevel[2] = cca.fadeTo(0.25, 1.0)
	self.txtLevel[3] = cca.fadeTo(0.7, 0)
	self.txtLevel[4] = cca.fadeTo(0.7, 0)
	self.txtLevel[5] = cca.fadeTo(0.7, 0)
	local seq = cca.seq(self.txtLevel)
	self.progress_fg:stopAllActions()
	self.progress_fg:runAction(seq)
	SoraDGetChildByName(self, "Particle_3"):resetSystem()
end
return dashToSkyShopExpView
