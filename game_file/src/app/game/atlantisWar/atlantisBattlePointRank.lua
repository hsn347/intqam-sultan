local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisBattlePointRank = class("atlantisBattlePointRank", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("atlantisBattlePointRank")
end)
function atlantisBattlePointRank:ctor(target, properties)
	self.isHidePrePanel = false
	self.inOutWar = properties and properties.inOutWar
	self.curState = atlantisActivityCtrl:getActivityCurState()
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.textTitle:setString(i18n("atlantiswar_text_0127"))
	self:bindBtnClose()
	self.nodeTimer = SoraDGetChildByName(self, "Node_timer")
	self.textTimeTitle = SoraDGetChildByName(self.nodeTimer, "Text_TimeTitle")
	self.textTimeTitle:setString(i18n("atlantiswar_text_0099"))
	self.textRemainTime = SoraDGetChildByName(self.nodeTimer, "Text_remainTime")
	self.textRemainTime = SoraDCreateTimerLabel(self, self.textRemainTime)
	self.btnQuestion = SoraDGetChildByName(self.nodeTimer, "Button_Question")
	self.btnQuestion:addTouchEventListener(handler(self, self.btnQuestionClick))
	self.nodeAtlantisBattlePointKindom = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_atlantisBattlePointKindom")
	self.nodeAtlantisBattlePointPersonal = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_atlantisBattlePointPersonal")
	_UPVALUE3_, self.nodeAtlantisBattlePointTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_atlantisBattlePointTitle"), SoraDGetExtendChildFromCCSByName(self, "Top_CCS_atlantisBattlePointTitle")
	self.nodeList, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_atlantisBattlePointTitle")[1] = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_atlantisBattlePointTitle"), self.nodeAtlantisBattlePointKindom
	self.nodeList, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_atlantisBattlePointTitle")[2] = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_atlantisBattlePointTitle"), self.nodeAtlantisBattlePointPersonal
	self.nodeList, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_atlantisBattlePointTitle")[3] = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_atlantisBattlePointTitle"), self.nodeAtlantisBattlePointTitle
	if self.inOutWar then
		for i, v in ipairs(self.nodeList) do
			if v.initWithKid then
				v:initWithKid(-1)
			end
		end
		SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH_WARDATA", function()
			self:initActivityTime()
		end)
	end
	self.nodeEffectChoose = SoraDGetChildByName(self, "Node_EffectChoose")
	atlantisActivityCtrl, self.nodeCommonTabBtn = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX")
	SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX").tabNum = 3
	atlantisActivityCtrl, atlantisActivityCtrl, SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX").defaultClick = "CCS_commonTabBtnEX", self, 1
	;("CCS_commonTabBtnEX").title = i18n("common_text_479")
	;("CCS_commonTabBtnEX").handle = handler(self, self.btnTabClick)
	;("CCS_commonTabBtnEX").tag = 1
	atlantisActivityCtrl, self[1], ("CCS_commonTabBtnEX").fontSize = "CCS_commonTabBtnEX", "CCS_commonTabBtnEX", 24
	;("CCS_commonTabBtnEX").title = i18n("pyramid_btn_35")
	;("CCS_commonTabBtnEX").handle = handler(self, self.btnTabClick)
	;("CCS_commonTabBtnEX").tag = 2
	atlantisActivityCtrl, self[2], ("CCS_commonTabBtnEX").fontSize = "CCS_commonTabBtnEX", "CCS_commonTabBtnEX", 24
	;("CCS_commonTabBtnEX").title = i18n("lord_title_01")
	;("CCS_commonTabBtnEX").handle = handler(self, self.btnTabClick)
	;("CCS_commonTabBtnEX").tag = 3
	SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX").tabsetArray, self[3], ("CCS_commonTabBtnEX").fontSize = self, "CCS_commonTabBtnEX", 24
	local param = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX")
	self.nodeCommonTabBtn:setContentSize(cc.size(600, 50))
	self.nodeCommonTabBtn:setChoosePng("btn_shmc_01_highlight.png")
	self.nodeCommonTabBtn:setUnChoosePng("bg_transparent.png")
	self.nodeCommonTabBtn:hideLineAndBg()
	self.nodeCommonTabBtn:initView(param)
	self:initActivityTime()
	self:initEffect()
end
function atlantisBattlePointRank:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH", function(target, content)
		if content.key == "reqStateDataRsp" then
			local newState = atlantisActivityCtrl:getActivityCurState()
			if newState == ATLANTIS_WAR_STATE.PREPARE and self.curState ~= newState then
				self:closePanel()
				return
			end
			self.curState = newState
		end
	end)
end
function atlantisBattlePointRank:initEffect()
	local chooseEffect = cc.criSprite.createCriSprite("zhandoujifen11.usm", false, true, nil)
	chooseEffect:setBlendFunc(gl.ONE, gl.ONE)
	chooseEffect:addTo(self.nodeEffectChoose)
	chooseEffect:setPosition(0, 0)
	local bgEffectTop = cc.criSprite.createCriSprite("zhandoujifen22.usm", false, true, nil)
	bgEffectTop:setBlendFunc(gl.ONE, gl.ONE)
	bgEffectTop:addTo(self)
	bgEffectTop:setAnchorPoint(cc.p(0.5, 1))
	bgEffectTop:setLocalZOrder(999)
	bgEffectTop:setPosition(320, display.height)
	local bgEffectBottom = cc.criSprite.createCriSprite("zhandoujifen33.usm", false, true, nil)
	bgEffectBottom:setBlendFunc(gl.ONE, gl.ONE)
	bgEffectBottom:addTo(self)
	bgEffectBottom:setAnchorPoint(cc.p(0.5, 0))
	bgEffectBottom:setLocalZOrder(999)
	bgEffectBottom:setPosition(320, 0)
end
function atlantisBattlePointRank:btnQuestionClick(target, eventType)
	print("btnQuestionClick", eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.rankType == 3 then
			local panel = SoraDCreatePanel("atlantisTitleRuleView")
			panel:initData(self.nodeList[3]:getCurTitleType())
			panel:show()
		elseif self.rankType == 2 then
			local panel = SoraDCreatePanel("atlantisPointHelpView")
			_ENV = self.nodeList[3]:getCurTitleType()
			self.nodeList[3]:getCurTitleType().detailStr = i18n("atlantiswar_text_0131")
			self.nodeList[3]:getCurTitleType().title = i18n("atlantiswar_text_0246")
			self.nodeList[3]:getCurTitleType().rankType = self.rankType
			panel:initData(self.nodeList[3]:getCurTitleType())
			panel:show()
		elseif self.rankType == 1 then
			local atlantisWarUtil = include("atlantisWarUtil")
			local detailStr = i18n("atlantiswar_text_0128")
			if atlantisWarUtil.isNewMap() then
				detailStr = i18n("atlantiswar_text_0128_KOH")
			end
			local panel = SoraDCreatePanel("atlantisPointHelpView")
			_ENV = "atlantiswar_text_0246"
			;("atlantiswar_text_0246").detailStr = detailStr
			;("atlantiswar_text_0246").title = i18n("atlantiswar_text_0247")
			;("atlantiswar_text_0246").rankType = self.rankType
			panel:initData("atlantiswar_text_0246")
			panel:show()
		end
	end
end
function atlantisBattlePointRank:initActivityTime()
	self.textRemainTime:setString(i18n("Anchor_text_21"))
	local warData = atlantisWarCtrl:getWarData()
	if warData.warEndTime then
		local curtime = serviceFunctions.systemTime()
		local lefttime = warData.warEndTime - curtime
		if 0 < lefttime then
			self.textRemainTime:beginTime(lefttime)
		end
	end
	SoraDToCenter(self.nodeTimer, 10, not SoraDFIsRA())
end
function atlantisBattlePointRank:btnTabClick(tag)
	self.rankType = tag
	self.nodeList[1]:setVisible(tag == 1)
	self.nodeList[2]:setVisible(tag == 2)
	self.nodeList[3]:setVisible(tag == 3)
	if tag == 1 then
		self.nodeEffectChoose:setPositionX(SoraDFPosX(200, 0))
		self.nodeList[1]:requestMore()
	elseif tag == 2 then
		self.nodeEffectChoose:setPositionX(0)
		self.nodeList[2]:requestMore(true)
	elseif tag == 3 then
		self.nodeEffectChoose:setPositionX(SoraDFPosX(-200, 0))
		self.nodeList[3]:requestMore(true)
	end
end
return atlantisBattlePointRank
