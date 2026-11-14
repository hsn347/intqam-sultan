local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicBattleDef = include("epicBattleDef")
local epicWarChapterView = class("epicWarChapterView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicWarChapterView")
	end
	return target
end)
function epicWarChapterView:ctor()
	self.isHideCurrentSceneView = true
	self.isChapterDetail = false
	self.isGateDetail = false
	self.gateData, _ENV, self.chapterData, _ENV, self.isNewGate = nil, nil, nil, nil, false
	self.isFromHero = false
	self.curChapter = 1
	self.isChallenging = false
	self.switch = false
	self:setContentSize(display.size)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_title")
	self.ccs_title:setTitle(i18n("epicbattle_title_01"))
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.containerView = SoraDCreatePanel("epicBattleChapterMapInfoView")
	self.containerViewSize = self.containerView:getContentSize()
	local viewScrollView = cc.ScrollView:create(self:getContentSize())
	viewScrollView:setContainer(self.containerView)
	viewScrollView:setMinScale(1.0)
	viewScrollView:setMaxScale(2.5)
	viewScrollView:setZoomScale(1.0)
	viewScrollView:setBounceable(false)
	local containerViewscale = viewScrollView:getZoomScale()
	viewScrollView:setContentOffset(cc.p(-(self.containerViewSize.width - display.width) / 2 * containerViewscale, -(self.containerViewSize.height - display.height) / 2 * containerViewscale), false)
	viewScrollView:setPosition(cc.p(0, 0))
	self:addChild(viewScrollView, 0)
	self.viewScrollView = viewScrollView
	self.containerView:setScroll(self.viewScrollView)
	self.viewScrollView:setDelegate()
	self.viewScrollView:registerScriptHandler(handler(self, self.scrollViewDidOffset), cc.SCROLLVIEW_SCRIPT_SCROLL)
	self.nodeAction = SoraDGetExtendChildFromCCSByName(self, "CCS_epicBattleActionNode_action")
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	self.Node_award = SoraDGetChildByName(self, "Node_award")
	self.Text_box = SoraDGetChildByName(self.Node_award, "Text_box")
	self.Text_box = SoraDCreateTimerLabel(self, self.Text_box)
	self.Button_award = SoraDGetChildByName(self.Node_award, "Button_award")
	self.Button_award:addTouchEventListener(handler(self, self.btnAwardCallBack))
	self.Node_etBox = SoraDGetChildByName(self.Button_award, "Node_etBox")
	SoraDCreatAnimation("animationEpicWarMRBX"):addTo(self.Node_etBox)
	self.Node_etBox:setVisible(false)
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.Center_Node:setVisible(false)
	self.Button_lArrow = SoraDGetChildByName(self.Center_Node, "Button_lArrow")
	self.Button_lArrow:addTouchEventListener(handler(self, self.onLArrowCallBack))
	self.Button_rArrow = SoraDGetChildByName(self.Center_Node, "Button_rArrow")
	self.Button_rArrow:addTouchEventListener(handler(self, self.onRArrowCallBack))
	self.Top_Size_Panel_touch = SoraDGetChildByName(self, "Top_Size_Panel_touch")
	self.Top_Size_Panel_touch:setTouchEnabled(true)
	self.Top_Size_Panel_touch:setSwallowTouches(false)
	self.Top_Size_Panel_touch:addTouchEventListener(handler(self, self.onPanelCallBack))
	self.Top_Size_Panel_select = SoraDGetChildByName(self, "Top_Size_Panel_select")
	self.Top_Size_Panel_select:setVisible(false)
	self.Top_Size_Panel_select:setTouchEnabled(true)
	self.Top_Size_Panel_select:setSwallowTouches(false)
	self.Top_Size_Panel_select:addTouchEventListener(handler(self, self.onPanelSelectCallBack))
	self.Bottom_Node_cloud = SoraDGetChildByName(self, "Bottom_Node_cloud")
	self.Node_jump = SoraDGetChildByName(self.Bottom_Node, "Node_jump")
	self.Node_jump:setVisible(false)
	self.Node_unFight = SoraDGetChildByName(self.Node_jump, "Node_unFight")
	self.Text_tip = SoraDGetChildByName(self.Node_unFight, "Text_tip")
	SoraDChangeTextToHtml(self.Text_tip)
	_ENV = handler(self, self.onPanelSelectCallBack)
	_ENV = 1
	;(1).color = "#FFFF00"
	;(1).i = "true"
	handler(self, self.onPanelSelectCallBack).var1 = SoraDWrapHtmlTagByStyle(tostring(1), 1)
	_ENV = 10
	;(10).color = "#FFFF00"
	;(10).i = "true"
	handler(self, self.onPanelSelectCallBack).var2 = SoraDWrapHtmlTagByStyle(tostring(10), 10)
	self.Text_tip:setString(i18n("epic_war_challenge_desc", handler(self, self.onPanelSelectCallBack)))
	self.Text_select = SoraDGetChildByName(self.Node_unFight, "Text_select")
	self.Text_select:setString(i18n("epic_war_choiceChapter_name"))
	self.Node_open = SoraDGetChildByName(self.Node_unFight, "Node_open")
	self.Node_open:setVisible(false)
	self.scrollList = SoraDGetChildByName(self.Node_unFight, "ScrollView_list")
	self.scrollList = include("commonAutoScrollList").new(self.scrollList)
	self.scrollList:setSingleCCS("epicWarChapterSelectSingle")
	self.Text_cur = SoraDGetChildByName(self.Node_unFight, "Text_cur")
	self.frame_arrow = SoraDGetChildByName(self.Node_unFight, "frame_arrow")
	self.Button_select = SoraDGetChildByName(self.Node_unFight, "Button_select")
	self.Button_select:addTouchEventListener(handler(self, self.btnSelectCallBack))
	self.Button_challenge = SoraDGetChildByName(self.Node_unFight, "Button_challenge")
	self.Button_challenge:setTitleText(i18n("common_text_1774"))
	self.Button_challenge:addTouchEventListener(handler(self, self.btnChallengeCallBack))
	self.Node_fight = SoraDGetChildByName(self.Node_jump, "Node_fight")
	self.Text_ingIndex = SoraDGetChildByName(self.Node_fight, "Text_ingIndex")
	self.Text_ing = SoraDGetChildByName(self.Node_fight, "Text_ing")
	self.Text_ing:setString(i18n("epic_war_challenging_name"))
	self.Node_horse = SoraDGetChildByName(self.Node_fight, "Node_horse")
	SoraDCreatAnimation("animationEpicWarHorse"):addTo(self.Node_horse)
	self.Node_dance = SoraDGetChildByName(self.Node_fight, "Node_dance")
	SoraDCreatAnimation("animationEpicWarDance"):addTo(self.Node_dance)
	self.Node_dj = SoraDGetChildByName(self.Node_fight, "Node_dj")
	SoraDCreatAnimation("animationEpicWarFighting"):addTo(self.Node_dj)
	self.Button_back = SoraDGetChildByName(self.Node_fight, "Button_back")
	self.Button_back:setTitleText(i18n("epic_war_backChallenge_btn"))
	self.Button_back:addTouchEventListener(handler(self, self.btnBackCallBack))
	self:addCloudAction()
	self:checkGuide()
	SoraDTestButton(self, function()
		self = nil
		;(nil).index = 4
		self:selectCallBack(nil)
	end)
end
function epicWarChapterView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_CHAPTER_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_UI_EPICBATTLE_CHAPTER_SELECT", handler(self, self.selectChapterView))
	SoraDAddMessage(self, "MESSAGE_UI_EPICBATTLE_GATE_SELECT", handler(self, self.selectGate))
	SoraDAddMessage(self, "MESSAGE_UI_EPICBATTLE_CLOSE_CHALLENGE", handler(self, self.closeChallengeView))
	SoraDAddMessage(self, "MESSAGE_UI_EPICBATTLE_CHAPTER_BACK", handler(self, self.backOriginMap))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_UPDATE_DAILYBOX", handler(self, self.setDailyAward))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_INIT", handler(self, self.initAll))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_UPDATE_GATEBOX", handler(self, self.updateGateBox))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_UPDATE_PATH", handler(self, self.updatePath))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_QUIT_CHAPTER", handler(self, self.exitChallenge))
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_ENTER_STAGE", handler(self, self.enterStage))
end
function epicWarChapterView:checkGuide()
	if guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR) and not SoraDIsGameGuide() then
		local beginStep = guideCtrl:getStepByGuideModule(gGuideModule.NEW_EPIC_WAR)
		if beginStep and beginStep < 74001 then
			guideCtrl = gGuideModule.NEW_EPIC_WAR
			gGuideModule.NEW_EPIC_WAR.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
			gGuideModule.NEW_EPIC_WAR.step = 73002
			SoraDSendMessage(gGuideModule.NEW_EPIC_WAR)
		end
	elseif epicWarCtrl:getCurGateID() then
		self.isChallenging = true
		self.curChapter = epicWarCtrl:getCurChapter()
		guideCtrl = nil
		;(nil).chapter = self.curChapter
		;(nil).isArrow = true
		self:selectChapterView(self, nil)
		self.containerView:showNewestChapter(self.curChapter)
		self.containerView:setDark(self.curChapter)
		self:initJumpView()
	end
end
function epicWarChapterView:isInBorder(x, y, area)
	local ret = false
	if x < area.leftX and x > area.rightX and y > area.topY and y < area.bottomY then
		ret = true
	end
	return ret
end
function epicWarChapterView:updateGateBox(target, data)
	self.containerView:updateGate(data.stageId or epicWarCtrl:getCurGateID())
end
function epicWarChapterView:updatePath(target, data)
	self.containerView:updatePath()
end
function epicWarChapterView:exitChallenge()
	if self.curChapter then
		_UPVALUE2_ = nil
		;(nil)[1] = cca.callFunc(function()
			self.isChapterDetail = false
			self.containerView:setIsChapterDetail(false)
			self.viewScrollView:setZoomScale(1.0)
		end)
		;(nil)[2] = cca.delay(0.2)
		;(nil)[3] = cca.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_UI_EPICBATTLE_CHAPTER_SELECT"
			;(nil).chapter = self.curChapter
			SoraDSendMessage(nil)
		end)
		;(nil)[4] = cca.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_UI_EPICBATTLE_CHAPTER_SELECT"
			;(nil).chapter = self.curChapter
			SoraDSendMessage(nil)
		end)
		local seq = cca.seq(nil)
		self:runAction(seq)
	end
	self.containerView:updateGate()
end
function epicWarChapterView:scrollViewDidOffset()
	self.Center_Node:setVisible(self.isChapterDetail)
	if self.isChapterDetail then
		self.viewScrollView:setMinScale(2.5)
		self.viewScrollView:setMaxScale(2.5)
		self.containerView:initGate(self.curChapter)
		local limitOffset = epicBattleDef.getChapterOffset(self.curChapter)
		local offset = self.viewScrollView:getContentOffset()
		if not self:isInBorder(offset.x, offset.y, limitOffset) then
			if offset.x > limitOffset.leftX then
				offset.x = limitOffset.leftX
			end
			if offset.x < limitOffset.rightX then
				offset.x = limitOffset.rightX
			end
			if offset.y > limitOffset.bottomY then
				offset.y = limitOffset.bottomY
			end
			if offset.y < limitOffset.topY then
				offset.y = limitOffset.topY
			end
			offset.y = math.max(offset.y, -4100 + display.height)
			self.containerView:setPosition(cc.p(offset.x, offset.y))
		end
		self.Node_jump:setVisible(self.isChapterDetail or self.isChallenging)
	else
		self.viewScrollView:setMinScale(1.0)
		self.viewScrollView:setMaxScale(2.5)
	end
end
function epicWarChapterView:initAll()
	self:initData()
	self:updateArrow()
	self:setDailyAward()
end
function epicWarChapterView:onEnterOther()
	epicWarCtrl:sendReqInitData()
end
function epicWarChapterView:initData(target, data)
	self.containerView:setChaptersInfo()
	self.newChapter = epicWarCtrl:getNewestChapter()
	if guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR) then
		self.newChapter = 1
		self.curChapter = 1
	end
	if epicWarCtrl:getCurChapter() then
		self.newChapter = epicWarCtrl:getCurChapter()
	end
	self.containerView:showNewestChapter(self.newChapter)
	self:moveToChapter(self.newChapter)
	if data and data.chapter then
		self:showChapterAward(data.chapter)
		self.curChapter = data.chapter
	end
	self:showChapterAward(self.newChapter)
	self.curChapter = self.newChapter
	self:initJumpView()
end
function epicWarChapterView:addCloudAction()
	local bottomYunShader = require("app.game.epicBattle.shader.baiyun")
	local bottomYunMeshData = require("app.game.epicBattle.meshData.baiyun_down_meshData")
	_ENV, _UPVALUE9_ = nil, "app.game.epicBattle.meshData.baiyun_down_meshData"
	;(nil).attr = "texture"
	;(nil).name = "_noise"
	;(nil).value = "3DTexture/uiCloud/yun.png"
	_UPVALUE4_, (nil).hasMipmap = nil, false
	_ENV, (nil).texParam, (nil)[1] = nil, nil, gl.LINEAR
	_ENV, (nil).texParam, (nil)[2] = nil, nil, gl.LINEAR
	_ENV, (nil).texParam, (nil)[3] = nil, nil, gl.REPEAT
	_ENV, (nil).texParam, (nil)[4] = nil, nil, gl.REPEAT
	;(nil).attr = "texture"
	;(nil).name = "_baiyun"
	;(nil).value = "3DTexture/uiCloud/yun.png"
	_UPVALUE4_, (nil).hasMipmap = gl.LINEAR, false
	_ENV, (nil).texParam, gl.LINEAR[1] = gl.LINEAR, gl.LINEAR, gl.LINEAR
	_ENV, (nil).texParam, gl.LINEAR[2] = gl.LINEAR, gl.LINEAR, gl.LINEAR
	_ENV, (nil).texParam, gl.LINEAR[3] = gl.LINEAR, gl.LINEAR, gl.REPEAT
	_ENV, (nil).texParam, gl.LINEAR[4] = gl.LINEAR, gl.LINEAR, gl.REPEAT
	gl.LINEAR.attr = "vec4"
	_ENV, gl.LINEAR.name = gl.LINEAR, "_noise_ST"
	gl.LINEAR.x = -1.0
	gl.LINEAR.y = 1.0
	gl.LINEAR.z = 0.0
	_ENV, gl.LINEAR.value, gl.LINEAR.w = gl.LINEAR, gl.LINEAR, 0.0
	gl.LINEAR.attr = "vec4"
	_ENV, gl.LINEAR.name = gl.LINEAR, "_baiyun_ST"
	gl.LINEAR.x = 1.0
	gl.LINEAR.y = 1.0
	gl.LINEAR.z = 0.0
	_ENV, gl.LINEAR.value, gl.LINEAR.w = gl.LINEAR, gl.LINEAR, 0.0
	gl.LINEAR.attr = "float"
	gl.LINEAR.name = "blinn"
	_ENV, gl.LINEAR.value = gl.REPEAT, 0.0
	gl.REPEAT.attr = "float"
	gl.REPEAT.name = "_value"
	_ENV, gl.REPEAT.value = gl.REPEAT, -0.09
	gl.REPEAT.attr = "float"
	gl.REPEAT.name = "_ld"
	_ENV, gl.REPEAT.value = nil, 1.0
	;(nil).attr = "timeuv"
	_ENV, (nil).name = nil, "time_uv0"
	;(nil).kU = -0.016
	_ENV, (nil).value, (nil).kV = nil, nil, 0.0
	;(nil).attr = "timeuv"
	_ENV, (nil).name = nil, "time_uv1"
	;(nil).kU = 0.004
	;(nil).value, (nil).kV = nil, 0.0
	_ENV, ("app.game.epicBattle.meshData.baiyun_down_meshData")[1] = nil, nil
	_ENV, ("app.game.epicBattle.meshData.baiyun_down_meshData")[2] = nil, nil
	_ENV, ("app.game.epicBattle.meshData.baiyun_down_meshData")[3] = nil, gl.LINEAR
	_ENV, ("app.game.epicBattle.meshData.baiyun_down_meshData")[4] = nil, gl.LINEAR
	_ENV, ("app.game.epicBattle.meshData.baiyun_down_meshData")[5] = nil, gl.LINEAR
	_ENV, ("app.game.epicBattle.meshData.baiyun_down_meshData")[6] = nil, gl.REPEAT
	_ENV, ("app.game.epicBattle.meshData.baiyun_down_meshData")[7] = nil, gl.REPEAT
	_ENV, ("app.game.epicBattle.meshData.baiyun_down_meshData")[8] = nil, nil
	local _ENV, ("app.game.epicBattle.meshData.baiyun_down_meshData")[9], bottomParam = nil, nil, "app.game.epicBattle.meshData.baiyun_down_meshData"
	;(nil).meshData = bottomYunMeshData
	_ENV, (nil).size = cc.size(1, 1), cc.size(1, 1)
	cc.size(1, 1).vertBytes = bottomYunShader.vertBytes
	;(nil).shader, cc.size(1, 1).fragBytes = cc.size(1, 1), bottomYunShader.fragBytes
	;(nil).param = bottomParam
	_ENV, (nil).pos = cc.p(320, 50), cc.p(320, 50)
	cc.p(320, 50).x = 1.6
	;(nil).scale, cc.p(320, 50).y = cc.p(320, 50), 4.5
	local bottomYunData
	local bottomYun = SoraDCreateMeshNode(bottomYunData.meshData, bottomYunData.size, bottomYunData.shader, bottomYunData.param)
	_ENV = bottomYunData.shader
	bottomYunData.shader.x = 0
	bottomYunData.shader.y = 0
	bottomYunData.shader.z = 0
	bottomYun:setRotation3D(bottomYunData.shader)
	bottomYun:setPosition(cc.p(bottomYunData.pos))
	bottomYun:setScale(bottomYunData.scale.x, bottomYunData.scale.y)
	bottomYun:addTo(self.Bottom_Node_cloud)
	bottomYun:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	local topYunShader = require("app.game.epicBattle.shader.baiyun")
	local topYunMeshData = require("app.game.epicBattle.meshData.baiyun_up_meshData")
	_ENV, _UPVALUE9_ = gl.ONE_MINUS_SRC_ALPHA, "app.game.epicBattle.meshData.baiyun_up_meshData"
	gl.ONE_MINUS_SRC_ALPHA.attr = "texture"
	gl.ONE_MINUS_SRC_ALPHA.name = "_noise"
	gl.ONE_MINUS_SRC_ALPHA.value = "3DTexture/uiCloud/yun.png"
	_UPVALUE4_, gl.ONE_MINUS_SRC_ALPHA.hasMipmap = cc.p(bottomYunData.pos)
	_ENV, gl.ONE_MINUS_SRC_ALPHA.texParam, cc.p(bottomYunData.pos)[1] = cc.p(bottomYunData.pos)
	_ENV, gl.ONE_MINUS_SRC_ALPHA.texParam, cc.p(bottomYunData.pos)[2] = cc.p(bottomYunData.pos)
	_ENV, gl.ONE_MINUS_SRC_ALPHA.texParam, cc.p(bottomYunData.pos)[3] = cc.p(bottomYunData.pos)
	_ENV, gl.ONE_MINUS_SRC_ALPHA.texParam, cc.p(bottomYunData.pos)[4] = cc.p(bottomYunData.pos)
	cc.p(bottomYunData.pos).attr = "texture"
	cc.p(bottomYunData.pos).name = "_baiyun"
	cc.p(bottomYunData.pos).value = "3DTexture/uiCloud/yun.png"
	_UPVALUE4_, cc.p(bottomYunData.pos).hasMipmap = gl.LINEAR, false
	_ENV, cc.p(bottomYunData.pos).texParam, gl.LINEAR[1] = gl.LINEAR, gl.LINEAR, gl.LINEAR
	_ENV, cc.p(bottomYunData.pos).texParam, gl.LINEAR[2] = gl.LINEAR, gl.LINEAR, gl.LINEAR
	_ENV, cc.p(bottomYunData.pos).texParam, gl.LINEAR[3] = gl.LINEAR, gl.LINEAR, gl.REPEAT
	_ENV, cc.p(bottomYunData.pos).texParam, gl.LINEAR[4] = gl.LINEAR, gl.LINEAR, gl.REPEAT
	gl.LINEAR.attr = "vec4"
	_ENV, gl.LINEAR.name = gl.LINEAR, "_noise_ST"
	gl.LINEAR.x = -1.0
	gl.LINEAR.y = 1.0
	gl.LINEAR.z = 0.0
	_ENV, gl.LINEAR.value, gl.LINEAR.w = gl.LINEAR, gl.LINEAR, 0.0
	gl.LINEAR.attr = "vec4"
	_ENV, gl.LINEAR.name = gl.LINEAR, "_baiyun_ST"
	gl.LINEAR.x = 1.0
	gl.LINEAR.y = 1.0
	gl.LINEAR.z = -3.05
	_ENV, gl.LINEAR.value, gl.LINEAR.w = gl.LINEAR, gl.LINEAR, 0.0
	gl.LINEAR.attr = "float"
	gl.LINEAR.name = "blinn"
	_ENV, gl.LINEAR.value = gl.REPEAT, 1.0
	gl.REPEAT.attr = "float"
	gl.REPEAT.name = "_value"
	_ENV, gl.REPEAT.value = gl.REPEAT, 0.05
	gl.REPEAT.attr = "float"
	gl.REPEAT.name = "_ld"
	_ENV, gl.REPEAT.value = cc.p(bottomYunData.pos)
	cc.p(bottomYunData.pos).attr = "timeuv"
	_ENV, cc.p(bottomYunData.pos).name = cc.p(bottomYunData.pos)
	cc.p(bottomYunData.pos).kU = -0.012
	_ENV, cc.p(bottomYunData.pos).value, cc.p(bottomYunData.pos).kV = cc.p(bottomYunData.pos)
	cc.p(bottomYunData.pos).attr = "timeuv"
	_ENV, cc.p(bottomYunData.pos).name = cc.p(bottomYunData.pos)
	cc.p(bottomYunData.pos).kU = 0.004
	cc.p(bottomYunData.pos).value, cc.p(bottomYunData.pos).kV = cc.p(bottomYunData.pos)
	_ENV, ("app.game.epicBattle.meshData.baiyun_up_meshData")[1] = gl.ONE_MINUS_SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA
	_ENV, ("app.game.epicBattle.meshData.baiyun_up_meshData")[2] = gl.ONE_MINUS_SRC_ALPHA, cc.p(bottomYunData.pos)
	_ENV, ("app.game.epicBattle.meshData.baiyun_up_meshData")[3] = gl.ONE_MINUS_SRC_ALPHA, gl.LINEAR
	_ENV, ("app.game.epicBattle.meshData.baiyun_up_meshData")[4] = gl.ONE_MINUS_SRC_ALPHA, gl.LINEAR
	_ENV, ("app.game.epicBattle.meshData.baiyun_up_meshData")[5] = gl.ONE_MINUS_SRC_ALPHA, gl.LINEAR
	_ENV, ("app.game.epicBattle.meshData.baiyun_up_meshData")[6] = gl.ONE_MINUS_SRC_ALPHA, gl.REPEAT
	_ENV, ("app.game.epicBattle.meshData.baiyun_up_meshData")[7] = gl.ONE_MINUS_SRC_ALPHA, gl.REPEAT
	_ENV, ("app.game.epicBattle.meshData.baiyun_up_meshData")[8] = gl.ONE_MINUS_SRC_ALPHA, cc.p(bottomYunData.pos)
	local _ENV, ("app.game.epicBattle.meshData.baiyun_up_meshData")[9], topParam = gl.ONE_MINUS_SRC_ALPHA, cc.p(bottomYunData.pos)
	gl.ONE_MINUS_SRC_ALPHA.meshData = topYunMeshData
	_ENV, gl.ONE_MINUS_SRC_ALPHA.size = cc.size(1, 1), cc.size(1, 1)
	cc.size(1, 1).vertBytes = topYunShader.vertBytes
	gl.ONE_MINUS_SRC_ALPHA.shader, cc.size(1, 1).fragBytes = cc.size(1, 1), topYunShader.fragBytes
	gl.ONE_MINUS_SRC_ALPHA.param = topParam
	_ENV, gl.ONE_MINUS_SRC_ALPHA.pos = cc.p(320, self:getContentSize().height - 150), cc.p(320, self:getContentSize().height - 150)
	cc.p(320, self:getContentSize().height - 150).x = 1.6
	gl.ONE_MINUS_SRC_ALPHA.scale, cc.p(320, self:getContentSize().height - 150).y = cc.p(320, self:getContentSize().height - 150), 4.8
	local topYunData = gl.ONE_MINUS_SRC_ALPHA
	local topYun = SoraDCreateMeshNode(topYunData.meshData, topYunData.size, topYunData.shader, topYunData.param)
	_ENV = topYunData.shader
	topYunData.shader.x = 0
	topYunData.shader.y = 0
	topYunData.shader.z = 0
	topYun:setRotation3D(topYunData.shader)
	topYun:setPosition(cc.p(topYunData.pos))
	topYun:setScale(topYunData.scale.x, topYunData.scale.y)
	topYun:addTo(self.Bottom_Node_cloud)
	topYun:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	local centerYunShader = require("app.game.epicBattle.shader.baiyun")
	local centerYunMeshData = require("app.game.epicBattle.meshData.baiyun_center_meshData")
	_ENV, _UPVALUE9_ = gl.ONE_MINUS_SRC_ALPHA, "app.game.epicBattle.meshData.baiyun_center_meshData"
	gl.ONE_MINUS_SRC_ALPHA.attr = "texture"
	gl.ONE_MINUS_SRC_ALPHA.name = "_noise"
	gl.ONE_MINUS_SRC_ALPHA.value = "3DTexture/uiCloud/yun.png"
	_UPVALUE4_, gl.ONE_MINUS_SRC_ALPHA.hasMipmap = cc.p(topYunData.pos)
	_ENV, gl.ONE_MINUS_SRC_ALPHA.texParam, cc.p(topYunData.pos)[1] = cc.p(topYunData.pos)
	_ENV, gl.ONE_MINUS_SRC_ALPHA.texParam, cc.p(topYunData.pos)[2] = cc.p(topYunData.pos)
	_ENV, gl.ONE_MINUS_SRC_ALPHA.texParam, cc.p(topYunData.pos)[3] = cc.p(topYunData.pos)
	_ENV, gl.ONE_MINUS_SRC_ALPHA.texParam, cc.p(topYunData.pos)[4] = cc.p(topYunData.pos)
	cc.p(topYunData.pos).attr = "texture"
	cc.p(topYunData.pos).name = "_baiyun"
	cc.p(topYunData.pos).value = "3DTexture/uiCloud/yun.png"
	_UPVALUE4_, cc.p(topYunData.pos).hasMipmap = gl.LINEAR, false
	_ENV, cc.p(topYunData.pos).texParam, gl.LINEAR[1] = gl.LINEAR, gl.LINEAR, gl.LINEAR
	_ENV, cc.p(topYunData.pos).texParam, gl.LINEAR[2] = gl.LINEAR, gl.LINEAR, gl.LINEAR
	_ENV, cc.p(topYunData.pos).texParam, gl.LINEAR[3] = gl.LINEAR, gl.LINEAR, gl.REPEAT
	_ENV, cc.p(topYunData.pos).texParam, gl.LINEAR[4] = gl.LINEAR, gl.LINEAR, gl.REPEAT
	gl.LINEAR.attr = "vec4"
	_ENV, gl.LINEAR.name = gl.LINEAR, "_noise_ST"
	gl.LINEAR.x = -1.0
	gl.LINEAR.y = 0.94
	gl.LINEAR.z = -0.25
	_ENV, gl.LINEAR.value, gl.LINEAR.w = gl.LINEAR, gl.LINEAR, 0.0
	gl.LINEAR.attr = "vec4"
	_ENV, gl.LINEAR.name = gl.LINEAR, "_baiyun_ST"
	gl.LINEAR.x = 1.36
	gl.LINEAR.y = 3.21
	gl.LINEAR.z = 0.0
	_ENV, gl.LINEAR.value, gl.LINEAR.w = gl.LINEAR, gl.LINEAR, -0.04
	gl.LINEAR.attr = "float"
	gl.LINEAR.name = "blinn"
	_ENV, gl.LINEAR.value = gl.REPEAT, 0.0
	gl.REPEAT.attr = "float"
	gl.REPEAT.name = "_value"
	_ENV, gl.REPEAT.value = gl.REPEAT, -0.45
	gl.REPEAT.attr = "float"
	gl.REPEAT.name = "_ld"
	_ENV, gl.REPEAT.value = cc.p(topYunData.pos)
	cc.p(topYunData.pos).attr = "timeuv"
	_ENV, cc.p(topYunData.pos).name = cc.p(topYunData.pos)
	cc.p(topYunData.pos).kU = -0.016
	_ENV, cc.p(topYunData.pos).value, cc.p(topYunData.pos).kV = cc.p(topYunData.pos)
	cc.p(topYunData.pos).attr = "timeuv"
	_ENV, cc.p(topYunData.pos).name = cc.p(topYunData.pos)
	cc.p(topYunData.pos).kU = 0.004
	cc.p(topYunData.pos).value, cc.p(topYunData.pos).kV = cc.p(topYunData.pos)
	_ENV, ("app.game.epicBattle.meshData.baiyun_center_meshData")[1] = gl.ONE_MINUS_SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA
	_ENV, ("app.game.epicBattle.meshData.baiyun_center_meshData")[2] = gl.ONE_MINUS_SRC_ALPHA, cc.p(topYunData.pos)
	_ENV, ("app.game.epicBattle.meshData.baiyun_center_meshData")[3] = gl.ONE_MINUS_SRC_ALPHA, gl.LINEAR
	_ENV, ("app.game.epicBattle.meshData.baiyun_center_meshData")[4] = gl.ONE_MINUS_SRC_ALPHA, gl.LINEAR
	_ENV, ("app.game.epicBattle.meshData.baiyun_center_meshData")[5] = gl.ONE_MINUS_SRC_ALPHA, gl.LINEAR
	_ENV, ("app.game.epicBattle.meshData.baiyun_center_meshData")[6] = gl.ONE_MINUS_SRC_ALPHA, gl.REPEAT
	_ENV, ("app.game.epicBattle.meshData.baiyun_center_meshData")[7] = gl.ONE_MINUS_SRC_ALPHA, gl.REPEAT
	_ENV, ("app.game.epicBattle.meshData.baiyun_center_meshData")[8] = gl.ONE_MINUS_SRC_ALPHA, cc.p(topYunData.pos)
	local _ENV, ("app.game.epicBattle.meshData.baiyun_center_meshData")[9], centerParam = gl.ONE_MINUS_SRC_ALPHA, cc.p(topYunData.pos)
	gl.ONE_MINUS_SRC_ALPHA.meshData = centerYunMeshData
	_ENV, gl.ONE_MINUS_SRC_ALPHA.size = cc.size(1, 1), cc.size(1, 1)
	cc.size(1, 1).vertBytes = centerYunShader.vertBytes
	gl.ONE_MINUS_SRC_ALPHA.shader, cc.size(1, 1).fragBytes = cc.size(1, 1), centerYunShader.fragBytes
	gl.ONE_MINUS_SRC_ALPHA.param = centerParam
	_ENV, gl.ONE_MINUS_SRC_ALPHA.pos = cc.p(320, self:getContentSize().height / 2), cc.p(320, self:getContentSize().height / 2)
	cc.p(320, self:getContentSize().height / 2).x = 1.6
	gl.ONE_MINUS_SRC_ALPHA.scale, cc.p(320, self:getContentSize().height / 2).y = cc.p(320, self:getContentSize().height / 2), 2.8
	local centerYunData = gl.ONE_MINUS_SRC_ALPHA
	local centerYun = SoraDCreateMeshNode(centerYunData.meshData, centerYunData.size, centerYunData.shader, centerYunData.param)
	_ENV = centerYunData.shader
	centerYunData.shader.x = 0
	centerYunData.shader.y = 0
	centerYunData.shader.z = 0
	centerYun:setRotation3D(centerYunData.shader)
	centerYun:setPosition(cc.p(centerYunData.pos))
	centerYun:setScale(centerYunData.scale.x, centerYunData.scale.y)
	centerYun:addTo(self.Bottom_Node_cloud)
	centerYun:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
end
function epicWarChapterView:selectChapterView(target, data)
	self.selectChapter = data.chapter
	self.curChapter = self.selectChapter
	print("self.selectChapter,self.curChapter===", self.selectChapter, self.curChapter)
	local isArrow = data.isArrow
	epicBattleDef = self.selectChapter
	self.selectChapter[1] = cca.callFunc(function()
		self.isChapterDetail = true
		self.Node_jump:setVisible(self.isChapterDetail or self.isChallenging)
		self.viewScrollView:setZoomScale(2.5)
		self.containerView:initPath()
	end)
	self.selectChapter[2] = cca.callFunc(function()
		self:moveToChapter(self.selectChapter, 0.2)
		self.containerView:showChapterInfo(false)
		self:showChapterAward(self.selectChapter)
		self.containerView:showGateInfo(true)
		if isArrow then
			local cPos = epicBattleDef.getChapterCenterOffset(self.curChapter)
			self.containerView:setPosition(cPos)
		end
		self.isChallenging = epicWarCtrl:getCurGateID() and true or false
		self:initJumpView()
	end)
	self.selectChapter[3] = cca.callFunc(function()
		self:moveToChapter(self.selectChapter, 0.2)
		self.containerView:showChapterInfo(false)
		self:showChapterAward(self.selectChapter)
		self.containerView:showGateInfo(true)
		if isArrow then
			local cPos = epicBattleDef.getChapterCenterOffset(self.curChapter)
			self.containerView:setPosition(cPos)
		end
		self.isChallenging = epicWarCtrl:getCurGateID() and true or false
		self:initJumpView()
	end)
	local seq = cca.seq(self.selectChapter)
	self:runAction(seq)
	self:updateArrow()
end
function epicWarChapterView:backSelectMap()
	_UPVALUE1_ = nil
	;(nil)[1] = cca.callFunc(function()
		self.isChapterDetail = false
		self.Node_jump:setVisible(self.isChapterDetail or self.isChallenging)
		self.containerView:setIsChapterDetail(false)
		self.viewScrollView:setZoomScale(1.0)
	end)
	;(nil)[2] = cca.callFunc(function()
		self:moveToChapter(self.selectChapter, 0.2)
		self.containerView:showChapterInfo(true)
		self.containerView:showGateInfo(false)
		self.containerView:showNewestChapter(self.curChapter)
		self:initJumpView()
	end)
	;(nil)[3] = cca.callFunc(function()
		self:moveToChapter(self.selectChapter, 0.2)
		self.containerView:showChapterInfo(true)
		self.containerView:showGateInfo(false)
		self.containerView:showNewestChapter(self.curChapter)
		self:initJumpView()
	end)
	local seq = cca.seq(nil)
	self:runAction(seq)
end
function epicWarChapterView:backOriginMap()
	self.isChapterDetail = false
	self.Node_jump:setVisible(self.isChapterDetail or self.isChallenging)
	self.containerView:setIsChapterDetail(false)
	self.viewScrollView:setZoomScale(1.0)
	self:moveToChapter(self.selectChapter, 0)
	self.containerView:showChapterInfo(true)
	self.containerView:showGateInfo(false)
	self:initJumpView()
end
function epicWarChapterView:openChallengeView()
	local panel = SoraDCreatePanel("epicWarGateView")
	panel:initData(self.gateData)
	panel:show()
end
function epicWarChapterView:guideEndShow()
end
function epicWarChapterView:closeChallengeView(target, data)
	local noAct = data and data.noAct or false
	if self.isGateDetail then
		if noAct then
			self.Node_jump:setVisible(true)
			self.isGateDetail = false
			self.isNewGate = false
		else
			self.isGateDetail = false
			self.isNewGate = false
			self.Node_jump:setVisible(true)
		end
	end
end
function epicWarChapterView:selectGate(target, data)
	self.isNewGate = data.isNewGate or false
	self.gateData = data.gateData
	self:openChallengeView()
	self.containerView:setGateArrayEffect(self.gateData)
end
function epicWarChapterView:skipToGate(stageID)
	self.isFromHero = true
	epicWarltCtrl = nil
	;(nil)[1] = cca.delay(0.5)
	;(nil)[2] = cca.callFunc(function()
		self.curChapter = epicWarltCtrl:getChapterID(stageID)
		self = stageID
		stageID.index = self.curChapter
		self:selectCallBack(stageID)
		self = self
		self.msg = "MESSAGE_UI_EPICBATTLE_GATE_SELECT"
		self.gateData = epicWarCtrl:getStageEntityInfo(stageID)
		self.isNewGate = true
		SoraDSendMessage(self)
	end)
	;(nil)[3] = cca.callFunc(function()
		self.curChapter = epicWarltCtrl:getChapterID(stageID)
		self = stageID
		stageID.index = self.curChapter
		self:selectCallBack(stageID)
		self = self
		self.msg = "MESSAGE_UI_EPICBATTLE_GATE_SELECT"
		self.gateData = epicWarCtrl:getStageEntityInfo(stageID)
		self.isNewGate = true
		SoraDSendMessage(self)
	end)
	self:runAction(cca.seq(nil))
end
function epicWarChapterView:setDailyAward()
	local stageID = epicWarCtrl:getMaxPassedGateID()
	self.Node_award:setVisible(stageID ~= nil)
	local ret, time = epicWarCtrl:isDailyRewardReceived()
	self.Node_etBox:setVisible(false)
	if ret then
		self.Text_box:beginTime(time)
		self.Text_box:setTimeEndListener(function()
			self:setDailyAward()
		end)
		self.Button_award:loadTextures("icon_epicWar_dailybox2.png", "icon_epicWar_dailybox2.png", "icon_epicWar_dailybox2.png", ccui.TextureResType.plistType)
		self.Button_award:stopAllActions()
		self.Button_award:setRotation(0)
	else
		self.Text_box:setString(i18n("back_first_charge_text07"))
		self.Button_award:loadTextures("icon_epicWar_dailybox1.png", "icon_epicWar_dailybox1.png", "icon_epicWar_dailybox1.png", ccui.TextureResType.plistType)
		self.Button_award:stopAllActions()
		self.Button_award:setRotation(0)
		_UPVALUE8_ = self.Button_award
		self.Button_award[1] = cca.rotateTo(0.2, -10)
		self.Button_award[2] = cca.rotateTo(0.2, 0)
		self.Button_award[3] = cca.rotateTo(0.2, 10)
		self.Button_award[4] = cca.rotateTo(0.2, 0)
		self.Button_award[5] = cca.rotateTo(0.1, -5)
		self.Button_award[6] = cca.rotateTo(0.1, 0)
		self.Button_award[7] = cca.rotateTo(0.1, 5)
		self.Button_award[8] = cca.rotateTo(0.1, 0)
		self.Button_award[9] = cca.delay(2)
		self.Button_award[10] = cca.delay(2)
		local seq = cca.seq(self.Button_award)
		self.Button_award:runAction(cc.RepeatForever:create(seq))
		self.Node_etBox:setVisible(true)
	end
end
function epicWarChapterView:showChapterAward(chapter)
	self.chapterData = epicWarCtrl:getCurChapterInfo(chapter)
end
function epicWarChapterView:moveToChapter(chapter, duration)
	local targetChapter = self.containerView:getChapterImg(chapter)
	if targetChapter then
		local posX = targetChapter:getPositionX() + self.containerViewSize.width / 2
		local posY = targetChapter:getPositionY() + self.containerViewSize.height / 2
		local selfPos = cc.p(posX, posY)
		local zoomScale = self.viewScrollView:getZoomScale()
		local newOffsetPoint = cc.p(display.cx - selfPos.x * zoomScale, display.cy - selfPos.y * zoomScale)
		if newOffsetPoint.x < display.width - self.containerViewSize.width * zoomScale then
			newOffsetPoint.x = display.width - self.containerViewSize.width * zoomScale
		elseif newOffsetPoint.x > 0 then
			newOffsetPoint.x = 0
		end
		if newOffsetPoint.y < display.height - self.containerViewSize.height * zoomScale then
			newOffsetPoint.y = display.height - self.containerViewSize.height * zoomScale
		elseif newOffsetPoint.y > 0 then
			newOffsetPoint.y = 0
		end
		if duration and 0 < duration then
			self.viewScrollView:setContentOffsetInDuration(newOffsetPoint, duration or 0)
		else
			self.containerView:setPosition(newOffsetPoint)
		end
	end
end
function epicWarChapterView:openLevelView(stageID, isPass)
	local chapter = epicWarltCtrl:getChapterID(stageID)
	local newChapter, isChange = epicWarCtrl:getNewestChapter()
	if isPass then
		self:backOriginMap()
	else
		self.selectChapter = newChapter == chapter + 1 and newChapter or chapter
		self.curChapter = self.selectChapter
		self.isChapterDetail = true
		self.Node_jump:setVisible(self.isChapterDetail or self.isChallenging)
		self.viewScrollView:setZoomScale(2.5)
		self.containerView:initPath()
		self:moveToChapter(self.selectChapter, 0)
		self.containerView:showChapterInfo(false)
		self:showChapterAward(self.selectChapter)
		self.containerView:initGate(self.curChapter)
		self.containerView:showGateInfo(true)
		epicWarltCtrl = 0
		;(0).chapter = self.curChapter
		self:selectChapterView(self, 0)
		self.containerView:showNewestChapter(self.curChapter)
		self.containerView:setDark(self.curChapter)
		self:initJumpView()
	end
end
function epicWarChapterView:btnAwardCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("epicWarChapterAward")
		panel:show()
	end
end
function epicWarChapterView:updateArrow()
	self.Center_Node:setVisible(self.isChapterDetail)
	self.Button_lArrow:setVisible(self.curChapter > 1)
	local chapter, isChange = epicWarCtrl:getNewestChapter()
	self.Button_rArrow:setVisible(chapter > self.curChapter)
end
function epicWarChapterView:onLArrowCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local chapter = math.max(1, self.curChapter - 1)
		_ENV = nil
		;(nil).chapter = chapter
		;(nil).isArrow = true
		self:selectChapterView(self, nil)
		self.containerView:showNewestChapter(chapter)
		self.containerView:setDark(chapter)
		self:updateArrow()
	end
end
function epicWarChapterView:onRArrowCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local newChapter, isChange = epicWarCtrl:getNewestChapter()
		local chapter = math.min(newChapter, self.curChapter + 1)
		_ENV = nil
		;(nil).chapter = chapter
		;(nil).isArrow = true
		self:selectChapterView(self, nil)
		self.containerView:showNewestChapter(chapter)
		self.containerView:setDark(chapter)
		self:updateArrow()
	end
end
function epicWarChapterView:btnSelectCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.switch = not self.switch
		self:updateSwitch()
		self.Top_Size_Panel_select:setVisible(self.switch)
	end
end
function epicWarChapterView:initJumpView()
	if epicWarCtrl:getCurGateID() then
		self.Node_unFight:setVisible(false)
		self.Node_fight:setVisible(true)
		self.Top_Size_Panel_select:setVisible(false)
		self.Text_ingIndex:setString(string.format("%d-%d", epicWarCtrl:getCurChapter(), epicWarCtrl:getCurGateIndex()))
	else
		self.Node_unFight:setVisible(true)
		self.Node_fight:setVisible(false)
		self:updateChapterShow()
	end
end
function epicWarChapterView:updateSwitch()
	self.Node_open:setVisible(self.switch)
	self.frame_arrow:setFlippedY(self.switch)
end
function epicWarChapterView:updateChapterShow()
	_ENV = nil
	;(nil).num = self.curChapter
	self.Text_cur:setString(i18n("common_text_3162", nil))
	local chapters = epicWarCtrl:getChallengeChapter()
	_ENV = i18n("common_text_3162", nil)
	i18n("common_text_3162", nil).scroll = self.scrollList
	i18n("common_text_3162", nil).curChapter = self.curChapter
	i18n("common_text_3162", nil).handle = handler(self, self.selectCallBack)
	self.scrollList:updateScrollView(cc.size(234, 28), chapters, 1, i18n("common_text_3162", nil))
end
function epicWarChapterView:selectCallBack(data)
	self.curChapter = data.index
	_ENV = nil
	;(nil).num = self.curChapter
	self.Text_cur:setString(i18n("common_text_3162", nil))
	self.switch = false
	self:updateSwitch()
	_ENV = i18n("common_text_3162", nil)
	i18n("common_text_3162", nil).chapter = self.curChapter
	i18n("common_text_3162", nil).isArrow = true
	self:selectChapterView(self, i18n("common_text_3162", nil))
	self.containerView:showNewestChapter(self.curChapter)
	self.containerView:setDark(self.curChapter)
	self:updateArrow()
end
function epicWarChapterView:btnChallengeCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR) then
			if not SoraDSearchPanelFromManagerByName("epicWarDispatchView") then
				local panel = SoraDCreatePanel("epicWarDispatchView")
				panel:initData(self.curChapter, self.chapterData)
				panel:show()
			end
		else
			_ENV = self.curChapter
			self.curChapter.var1 = self.curChapter
			SoraDShowMsgBox(i18n("epic_war_challengeSure_desc", self.curChapter), i18n("common_text_204"), i18n("common_text_185"), function(event)
				if event == MSGBOX_CALLBACK_YES and not SoraDSearchPanelFromManagerByName("epicWarDispatchView") then
					local panel = SoraDCreatePanel("epicWarDispatchView")
					panel:initData(self.curChapter, self.chapterData)
					panel:show()
				end
			end)
		end
	end
end
function epicWarChapterView:btnBackCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("epicWarMapView")
		panel:show()
	end
end
function epicWarChapterView:enterStage(target, data)
	SoraDCloseLoading(self)
	local panel = SoraDCreatePanel("epicWarMapView")
	panel:show()
end
function epicWarChapterView:onPanelSelectCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		self.switch = false
		self:updateSwitch()
		self.Top_Size_Panel_select:setVisible(false)
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function epicWarChapterView:onPanelCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.1)
		;(nil)[2] = cca.callFunc(function()
			if self.isGateDetail and not self.isNewGate then
				SoraDPlaySound()
				self = nil
				;(nil).msg = "MESSAGE_UI_EPICBATTLE_CLOSE_CHALLENGE"
				SoraDSendMessage(nil)
			end
			self.isNewGate = false
		end)
		;(nil)[3] = cca.callFunc(function()
			if self.isGateDetail and not self.isNewGate then
				SoraDPlaySound()
				self = nil
				;(nil).msg = "MESSAGE_UI_EPICBATTLE_CLOSE_CHALLENGE"
				SoraDSendMessage(nil)
			end
			self.isNewGate = false
		end)
		local seq = cca.seq(nil)
		self.Top_Size_Panel_touch:runAction(seq)
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function epicWarChapterView:closePanel(...)
	local superClosePanel = include("basePanel").closePanel
	if self.isFromHero then
		superClosePanel(self)
		return
	end
	if self.isGateDetail then
		self:closeChallengeView()
	elseif self.isChapterDetail then
		self.viewScrollView:setMinScale(1.0)
		self.viewScrollView:setMaxScale(2.5)
		self.containerView:setDark()
		self:backSelectMap()
	else
		superClosePanel(self)
	end
end
function epicWarChapterView:btnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("帮助FAQ===")
		if IsArClient then
			userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.EPIC_WAR)
		else
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.EPIC_WAR)
		end
	end
end
function epicWarChapterView:gameGuide_getTarget(itemName, parameters)
	if itemName == "firstChapter" then
		return self.containerView:getChapterImg(1)
	elseif itemName == "Button_challenge" then
		return self.Button_challenge
	else
		return SoraDGetChildByName(self.containerView, itemName)
	end
end
return epicWarChapterView
