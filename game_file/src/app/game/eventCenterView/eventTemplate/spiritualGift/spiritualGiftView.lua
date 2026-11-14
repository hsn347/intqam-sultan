local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local spiritualGiftCtrl = SoraDGetCtrl("spiritualGiftCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local spiritualGiftRead = include("spiritualGiftRead")
local publicRead = include("publicRead")
local spiritualGiftView = class("spiritualGiftView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("spiritualGiftView")
	end
	return target
end)
_ENV = "spiritualGiftView"
;("spiritualGiftView").normal = 1
PrizeType, ("spiritualGiftView").super = "spiritualGiftView", 2
singleRankH = 120
MAX_AWARD_NUM = 4
function spiritualGiftView:ctor()
	_ENV = nil
	;(nil)[1] = cc.p(110, 510)
	;(nil)[2] = cc.p(500, 520)
	;(nil)[3] = cc.p(320, 800)
	;(nil)[4] = cc.p(320, 900)
	;(nil)[5] = cc.p(320, 700)
	;(nil)[6] = cc.p(320, 700)
	;(nil)[7] = cc.p(320, 700)
	self.superItemPos, (nil)[8] = nil, cc.p(320, 700)
	self.group = activityShowCtrl:getParamByID(gActivityTimeActivityID.SPIRITUAL_GIFT).classtype
	self:initControls()
	self:fitDevice()
	self:initOutRankReward()
	self:showShaderEffect()
	self:initSpineAndEffect()
	self:initLampEffect()
end
function spiritualGiftView:initLampEffect()
	local effectLamp = SoraDCreatAnimation("Node_Effect_ljlnf01", nil, true)
	SoraDMixtureGLONEByParent(effectLamp)
	self.effectLamp = effectLamp
	effectLamp:setPosition(cc.p(132, 185))
	self.lamp:addChild(effectLamp)
end
function spiritualGiftView:showShaderEffect(...)
	if not self.meshNode1 then
		local _shader = require("app.game.eventCenterView.eventTemplate.spiritualGift.Mesh_ljlnf_002_shader")
		local _meshData = require("app.game.eventCenterView.eventTemplate.spiritualGift.Mesh_ljlnf_002_meshData")
		local _param = require("app.game.eventCenterView.eventTemplate.spiritualGift.Mesh_ljlnf_002_param")
		local params = clone(_param.param)
		_ENV = nil
		;(nil).attr = "float"
		;(nil).name = "_currentTime"
		;(nil).value = SoraDGetCurrentTime()
		table.insert(params, nil)
		_ENV = table.insert
		table.insert.meshData = _meshData
		_ENV, table.insert.size = cc.size(1, 1), cc.size(1, 1)
		cc.size(1, 1).vertBytes = _shader.vertBytes
		table.insert.shader, cc.size(1, 1).fragBytes = cc.size(1, 1), _shader.fragBytes
		table.insert.param = params
		_ENV, table.insert.pos = cc.p(315, 540), cc.p(315, 540)
		cc.p(315, 540).x = 0.15
		table.insert.scale, cc.p(315, 540).y = cc.p(315, 540), 0.15
		local createData = table.insert
		local meshNode = SoraDCreateMeshNode(createData.meshData, createData.size, createData.shader, createData.param)
		meshNode:setPosition(cc.p(createData.pos))
		_ENV = cc.p(createData.pos)
		cc.p(createData.pos).x = 0
		cc.p(createData.pos).y = 155
		cc.p(createData.pos).z = 0
		meshNode:setRotation3D(cc.p(createData.pos))
		meshNode:setScale(createData.scale.x, createData.scale.y)
		meshNode:addTo(self.imgBg)
		self.meshNode1 = meshNode
	end
	if not self.meshNode2 then
		local _shader = require("app.game.eventCenterView.eventTemplate.spiritualGift.Shader_ljlnf_Flow_002")
		local _meshData = require("app.game.eventCenterView.eventTemplate.spiritualGift.MeshData_ljlnf_Flow_002")
		local _param = require("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002")
		_ENV = "app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002"
		;("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").meshData = _meshData
		_ENV, ("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").size = cc.size(1, 1), cc.size(1, 1)
		cc.size(1, 1).vertBytes = _shader.vertBytes
		;("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").shader, cc.size(1, 1).fragBytes = cc.size(1, 1), _shader.fragBytes
		;("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").param = _param.param
		_ENV, ("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").pos = cc.p(320, 920), cc.p(320, 920)
		cc.p(320, 920).x = 0.4
		;("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").scale, cc.p(320, 920).y = cc.p(320, 920), 0.4
		local createData = "app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002"
		local meshNode = SoraDCreateMeshNode(createData.meshData, createData.size, createData.shader, createData.param)
		meshNode:setPosition(cc.p(createData.pos))
		_ENV = cc.p(createData.pos)
		cc.p(createData.pos).x = 0
		cc.p(createData.pos).y = 0
		cc.p(createData.pos).z = 0
		meshNode:setRotation3D(cc.p(createData.pos))
		meshNode:setScale(createData.scale.x, createData.scale.y)
		meshNode:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		meshNode:addTo(self.imgBg)
		self.meshNode2 = meshNode
	end
end
function spiritualGiftView:initSpineAndEffect()
	local spine = sp.SkeletonAnimation:create("spine/lanjingling.skel", "spine/lanjingling.atlas", 1)
	spine:setAnimation(0, "animation", true)
	spine:setPosition(320, 650)
	spine:addTo(self.imgBg)
end
function spiritualGiftView:playDropGoldEffect(isPlay)
	if isPlay then
		if self.effectDropGold then
			SoraDResetEffectNode(self.effectDropGold)
			self.effectDropGold.action:gotoFrameAndPlay(0, 91, false)
		else
			self.effectDropGold = SoraDCreatAnimationEx("spiritualGift_jinbi", nil, false)
			self.effectDropGold:setPosition(cc.p(320, 570))
			self.effectDropGold:addTo(self.imgBg, 1)
		end
	elseif self.effectDropGold then
		self.effectDropGold:removeFromParent()
		self.effectDropGold = nil
	end
end
function spiritualGiftView:fitDevice()
	if display.height < 960 then
		self.imgBg:setPositionY(1100)
	elseif display.height >= 960 and display.height <= 1240 then
		self.imgBg:setPositionY(1120)
	else
		self.imgBg:setPositionY(display.height - 120)
		self.imgBg:setContentSize(cc.size(display.width, display.height - 120))
	end
end
function spiritualGiftView:initOutRankReward()
	_UPVALUE2_ = spiritualGiftRead
	spiritualGiftRead[1] = "id"
	spiritualGiftRead[2] = "count"
	local rewards = serviceFunctions.tableFormat(spiritualGiftRead:getOutRankShowRewards(self.group), spiritualGiftRead)
	for k, v in ipairs(rewards) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(0.8)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self)
			if not SoraDFIsRA() then
				self.awardArray[k]:setPosition(-150 + (k - 1) * 100, -70)
			else
				self.awardArray[k]:setPosition(150 - (k - 1) * 100, -70)
			end
			self.awardArray[k]:addTo(self.topNodeRank)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.count)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
		end
	end
	for i = 1, #self.awardArray do
		self.awardArray[i]:setVisible(i <= #rewards)
	end
end
function spiritualGiftView:onGiftClick(tag, name)
	self.btnRecord:setVisible(true)
	self.btnArea:setVisible(true)
	self.txtRemainTimeTitle:setVisible(true)
	self.nodeRemain:setVisible(true)
	self.txtTime:setVisible(true)
	self.iconTime:setVisible(true)
	self.nodeBottom:setVisible(true)
	self.imgFramePool:setVisible(true)
	self.btnPreviewReward:setVisible(true)
	for i, v in ipairs(self.itemTbl) do
		v:setVisible(true)
	end
	self.topNodeRank:setVisible(false)
	self.scrollRank:setVisible(false)
	self.bottomBgRank1:setVisible(false)
	self.bottomBgRank:setVisible(false)
	self.bgBlueMan:setVisible(false)
	self.timeBg:setVisible(true)
end
function spiritualGiftView:onRankClick(tag, name)
	self.btnRecord:setVisible(false)
	self.btnArea:setVisible(false)
	self.txtRemainTimeTitle:setVisible(false)
	self.nodeRemain:setVisible(false)
	self.txtTime:setVisible(false)
	self.iconTime:setVisible(false)
	self.nodeBottom:setVisible(false)
	self.imgFramePool:setVisible(false)
	self.btnPreviewReward:setVisible(false)
	for i, v in ipairs(self.itemTbl) do
		v:setVisible(false)
	end
	self.bgBlueMan:setVisible(true)
	self.topNodeRank:setVisible(true)
	self.scrollRank:setVisible(true)
	self.bottomBgRank1:setVisible(true)
	self.bottomBgRank:setVisible(true)
	self.timeBg:setVisible(false)
	spiritualGiftCtrl:reqGiftRank()
	SoraDShowLoading(self)
end
function spiritualGiftView:initControls()
	self.nodeBottom = SoraDGetChildByName(self, "Bottom_Node")
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_event")
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")
	self.btnTurn = SoraDGetChildByName(self, "Panel_Touch")
	self.btnHelp = SoraDGetChildByName(self, "btn_help_tip")
	self.imgBlueMan = SoraDGetChildByName(self, "bg_jlnf_02_119")
	self.imgBlueMan:setVisible(false)
	self.singleItem = SoraDGetChildByName(self, "Item_Single")
	self.imgBg = SoraDGetChildByName(self, "Top_bg_jlnf_01_62")
	self.imgMagicLamp = SoraDGetChildByName(self, "bg_jlnf_03_120")
	self.frameGold = SoraDGetChildByName(self, "frame_jlnf_bg_01_225")
	self.btnPreviewReward = SoraDGetChildByName(self, "btn_previewReward")
	self.btnRecord = SoraDGetChildByName(self, "btn_record")
	self.btnAddRoll = SoraDGetChildByName(self, "btn_addGold")
	self.btnOneDraw = SoraDGetChildByName(self, "btn_one")
	self.btnTenDraw = SoraDGetChildByName(self, "btn_ten")
	self.txtInstruct = SoraDGetChildByName(self, "text_instruct")
	self.txtPreviewReward = SoraDGetChildByName(self, "text_previewReward")
	self.txtGoldTitle = SoraDGetChildByName(self, "text_goldTitle")
	self.txtRemainTimeTitle = SoraDGetChildByName(self, "text_timeTitle")
	self.txtTime = SoraDGetChildByName(self, "text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.txtTime:setTimeEndListener(function()
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	self.lamp = SoraDGetChildByName(self, "bg_jlnf_03_120")
	self.timeBg = SoraDGetChildByName(self, "Image_40")
	self.nodeRemain = SoraDGetChildByName(self, "node_remain")
	self.txtTodayRemain = SoraDGetChildByName(self, "Text_4")
	self.txtTodayRemain = SoraDChangeTextToHtml(self.txtTodayRemain)
	self.txtRewardTitle = SoraDGetChildByName(self, "text_rankReward")
	self.txtRewardTitle:setLocalZOrder(10)
	self.topNodeRank = SoraDGetChildByName(self, "Top_Node_Rank")
	self.nodeRank = SoraDGetChildByName(self, "Node_rank")
	self.scrollRank = SoraDGetChildByName(self, "Top_Size_scroll_rank")
	self.imgFramePool = SoraDGetChildByName(self, "frame_jlnf_bg_01_225")
	self.iconTime = SoraDGetChildByName(self, "icon_hourglass_133")
	self.txtCurOwnTitle = SoraDGetChildByName(self, "text_curOwnTitle")
	self.bottomBgRank1 = SoraDGetChildByName(self, "bottomBg_1")
	self.bottomBgRank = SoraDGetChildByName(self, "bottomBg")
	self.txtOneGold = SoraDGetChildByName(self, "text_oneGold")
	self.txtTenGold = SoraDGetChildByName(self, "text_tenGold")
	self.txtOneTitle = SoraDGetChildByName(self, "text_oneTitle")
	self.txtTenTitle = SoraDGetChildByName(self, "text_tenTitle")
	self.txtNextRewardTitle = SoraDGetChildByName(self, "text_nextRewardTitle")
	self.txtNextRewardTitle = SoraDChangeTextToHtml(self.txtNextRewardTitle)
	self.txtPoolGold = SoraDGetChildByName(self, "text_goldPool")
	self.txtCurOwn = SoraDGetChildByName(self, "text_curOwn")
	self.txtProgress = SoraDGetChildByName(self, "text_progress")
	self.iconGold1 = SoraDGetChildByName(self, "icon_main_gold_228")
	if SoraDFIsRA() then
		self.iconGold1:setPositionX(190)
		self.txtPoolGold:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
	end
	self.Panel_exp_cut = SoraDGetChildByName(self, "Panel_exp_cut")
	self.bgBlueMan = SoraDGetChildByName(self, "Top_bg_jlnf_05_144")
	self.iconTicket1 = SoraDGetChildByName(self, "icon_main_gold_228_0_0")
	self.iconTicket2 = SoraDGetChildByName(self.btnOneDraw, "icon_main_gold_228_0")
	self.iconTicket3 = SoraDGetChildByName(self.btnTenDraw, "icon_main_gold_228_0_0")
	self.loadingbar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.btnArea = SoraDGetChildByName(self, "Button_area")
	self.imgMyHead = SoraDGetChildByName(self, "Image_head")
	self.txtMyName = SoraDGetChildByName(self, "Text_myName")
	self.txtMyRank = SoraDGetChildByName(self, "Text_myRank")
	self.txtMyPower = SoraDGetChildByName(self, "Text_myLordName")
	self.imgMyRanking = SoraDGetChildByName(self, "Sprite_myHead")
	self.txtMyScore = SoraDGetChildByName(self, "text_myScore")
	self.btnMoreReward = SoraDGetChildByName(self, "btn_moreReward")
	local node = SoraDCreateCSBNode("endlessTrialsRank")
	local button = node and SoraDGetChildByName(node, "btn_moreReward")
	if button then
		self.btnMoreReward:setVisible(false)
		button:removeFromParent()
		button:addTo(self.btnMoreReward:getParent())
		button:setPosition(self.btnMoreReward:getPositionX() + 9 - SoraDFSign(6), self.btnMoreReward:getPositionY() + 5)
		button:setTitleText(i18n("Endless_trial_text_13"))
		SoraDAutoSizeButtonText(button)
		self.btnMoreReward = button
	end
	self.txtRankDes = SoraDGetChildByName(self, "Text_des")
	self.txtRankName = SoraDGetChildByName(self, "Text_rank_name")
	self.txtRankRank = SoraDGetChildByName(self, "Text_rank")
	self.txtRecord = SoraDGetChildByName(self, "text_record")
	self.txtArea = SoraDGetChildByName(self, "text_area")
	self.txtRankRank:setString(i18n("common_text_2193"))
	self.txtRankName:setString(i18n("common_text_264"))
	self.txtRankDes:setString(i18n("common_text_1764"))
	self.txtRecord:setString(i18n("godGift_btn_01"))
	self.txtArea:setString(i18n("godGift_title_03"))
	self.awardArray, _ENV, self.itemTbl, _ENV = self.txtArea.setString, self.txtArea.setString, self.txtArea.setString, self.txtArea.setString
	self.iconTicket1:setSpriteFrame("1049.png")
	self.iconTicket2:setSpriteFrame("1049.png")
	self.iconTicket3:setSpriteFrame("1049.png")
	self.iconTicket1:setScale(0.3)
	self.iconTicket2:setScale(0.3)
	self.iconTicket3:setScale(0.3)
	self.imgMagicLamp:setLocalZOrder(10)
	self.frameGold:setLocalZOrder(10)
	self.btnPreviewReward:setLocalZOrder(10)
	self.singleItem:setVisible(false)
	_ENV = false
	_ENV, _ENV, (false).tabNum = i18n("godGift_title_03")
	i18n("godGift_title_03").title = i18n("godGift_title_01")
	_ENV, i18n("godGift_title_03")[1], i18n("godGift_title_03").handle = i18n("godGift_title_03")
	i18n("godGift_title_03").title = i18n("godGift_title_02")
	;(false).tabsetArray, i18n("godGift_title_03")[2], i18n("godGift_title_03").handle = i18n("godGift_title_03")
	self.ccs_tab:initView(false)
	self.btnHelp:addTouchEventListener(handler(self, self.onClick_btn_help_tip))
	self.btnTurn:addTouchEventListener(handler(self, self.btnClickTurn))
	self.btnAddRoll:addTouchEventListener(handler(self, self.btnAddRollClick))
	self.btnOneDraw:addTouchEventListener(handler(self, self.btnOneDrawClick))
	self.btnTenDraw:addTouchEventListener(handler(self, self.btnTenDrawClick))
	self.btnArea:addTouchEventListener(handler(self, self.btnAreaClick))
	self.btnRecord:addTouchEventListener(handler(self, self.btnRecordClick))
	self.btnMoreReward:addTouchEventListener(handler(self, self.btnMoreRewardClick))
	self.btnPreviewReward:addTouchEventListener(handler(self, self.btnPreviewRewardClick))
	self.ccs_title:setTitle(i18n("godGift_text_01"))
	self.txtInstruct:setString(i18n("godGift_text_08"))
	self.txtPreviewReward:setString(i18n("decrypt_text_03"))
	self.txtPreviewReward:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.txtPreviewReward:setTextHorizontalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	if SoraDGetDefaultLanguage() == "ru" or SoraDGetDefaultLanguage() == "tr" or SoraDGetDefaultLanguage() == "es" or SoraDGetDefaultLanguage() == "it" or SoraDGetDefaultLanguage() == "pt" or SoraDGetDefaultLanguage() == "vi" or SoraDGetDefaultLanguage() == "de" or SoraDGetDefaultLanguage() == "fr" or SoraDGetDefaultLanguage() == "ro" then
		self.txtInstruct:setFontSize(18)
		self.txtTenTitle:setFontSize(16)
		self.txtOneTitle:setFontSize(16)
	end
	SoraDSetTextWidthHeight(self.txtNextRewardTitle, cc.size(600, 60))
	SoraDSetTextWidthHeight(self.txtPreviewReward, cc.size(120, 30))
	self.txtGoldTitle:setString(i18n("godGift_title_05"))
	self.txtRemainTimeTitle:setString(i18n("rides_text_09"))
	self.txtCurOwnTitle:setString(i18n("palace_text_19"))
	_ENV = i18n("palace_text_19")
	i18n("palace_text_19").num = 1
	self.txtOneTitle:setString(i18n("godGift_btn_02", i18n("palace_text_19")))
	_ENV = i18n("godGift_btn_02", i18n("palace_text_19"))
	i18n("godGift_btn_02", i18n("palace_text_19")).num = 10
	self.txtTenTitle:setString(i18n("godGift_btn_02", i18n("godGift_btn_02", i18n("palace_text_19"))))
	self.txtRewardTitle:setString(i18n("godGift_text_21"))
	self.activityID = gActivityTimeActivityID.SPIRITUAL_GIFT
	self.changeNum = 0
	local spiritualTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if spiritualTime then
		self.txtTime:beginTime(spiritualTime.timerNode.timer:getRemainTime())
	end
	local effectExp = SoraDCreatAnimation("Node_Effect_ljlnf02", nil, true)
	SoraDMixtureGLONEByParent(effectExp)
	effectExp:addTo(self.Panel_exp_cut)
	self.effectExp = effectExp
	self.expCutSize = self.Panel_exp_cut:getContentSize()
	effectExp:setPosition(self.expCutSize.width / 2, 482)
	self.expPoint = SoraDGetChildByName(effectExp, "G_dh_Tex_lcks_006")
	spiritualGiftCtrl:reqInitSpiritualInfo()
	SoraDShowLoading(self)
end
function spiritualGiftView:initData()
	local pretype = self.poolPrizeType
	self.isPlayingSuperEffect = false
	self.poolPrizeType = spiritualGiftCtrl:getPoolPrizeType()
	if pretype and pretype ~= self.poolPrizeType and self.poolPrizeType == PrizeType.super then
		self.isPlayingSuperEffect = true
	end
	self.totalPrizeNum = spiritualGiftRead:getPrizePoolRewardsNumByType(self.group, self.poolPrizeType)
	self.stepSize = 120 / self.totalPrizeNum
	if self.poolPrizeType == PrizeType.super then
		self.stepSize = 80 / self.totalPrizeNum
	end
	local poolGold = spiritualGiftCtrl:getPoolGold()
	self.txtPoolGold:setString(string.formatnumberthousands(poolGold))
	self.txtPoolGold:setPositionX(90)
	local ticketCount = spiritualGiftCtrl:getGiftRollNum()
	self.txtCurOwn:setString(string.formatnumberthousands(ticketCount))
	if SoraDFIsRA() then
		self.btnAddRoll:setPositionX(self.txtCurOwn:getPositionX() - self.txtCurOwn:getContentSize().width - 30)
	else
		self.btnAddRoll:setPositionX(self.txtCurOwn:getPositionX() + self.txtCurOwn:getContentSize().width + 30)
	end
	if self.poolPrizeType == PrizeType.normal then
		local rewardList = spiritualGiftRead:getNormalPrizePreview(self.group)
		local comStr = ""
		for i, v in ipairs(rewardList) do
			if i ~= #rewardList then
				comStr = comStr .. publicRead.getName(v) .. "，"
			else
				comStr = comStr .. publicRead.getName(v)
			end
		end
		spiritualGiftCtrl = string.formatnumberthousands(ticketCount)
		spiritualGiftCtrl, spiritualGiftCtrl, string.formatnumberthousands(ticketCount).item = publicRead.getName(v), comStr, comStr
		comStr.item, publicRead.getName(v).color = publicRead.getName(v), "#FFFF00"
		self.txtNextRewardTitle:setString(i18n_html("godGift_text_09", string.formatnumberthousands(ticketCount)))
	elseif self.poolPrizeType == PrizeType.super then
		local remainTime = spiritualGiftCtrl:getRemainTopPrizeNum()
		spiritualGiftCtrl = i18n_html("godGift_text_09", string.formatnumberthousands(ticketCount))
		i18n_html("godGift_text_09", string.formatnumberthousands(ticketCount)).num = remainTime
		self.txtNextRewardTitle:setString(i18n("godGift_text_10", i18n_html("godGift_text_09", string.formatnumberthousands(ticketCount))))
	end
	local playerScore = spiritualGiftCtrl:getPlayerScore()
	local poolUpperLimit = spiritualGiftRead:getPoolUpperLimit(self.group, playerScore)
	self.txtProgress:setString(string.formatnumberthousands(playerScore) .. "/" .. string.formatnumberthousands(poolUpperLimit))
	self.loadingbar:setPercent(playerScore / poolUpperLimit * 100)
	local width = self.expCutSize.width * self.loadingbar:getPercent() / 100
	self.expPoint:setPositionX(width - self.expCutSize.width / 2)
	local offset = 0
	if SoraDFIsRA() then
		offset = 3
	end
	self.Panel_exp_cut:setContentSize(cc.size(width - offset, self.expCutSize.height))
	if ticketCount <= 0 then
		self.txtOneGold:setColor(cc.c3b(255, 0, 0))
		self.txtTenGold:setColor(cc.c3b(255, 0, 0))
	elseif 0 < ticketCount and ticketCount < 10 then
		self.txtOneGold:setColor(cc.c3b(255, 255, 0))
		self.txtTenGold:setColor(cc.c3b(255, 0, 0))
	elseif 10 <= ticketCount then
		self.txtOneGold:setColor(cc.c3b(255, 255, 0))
		self.txtTenGold:setColor(cc.c3b(255, 255, 0))
	end
	spiritualGiftCtrl = cc.c3b(255, 255, 0)
	cc.c3b(255, 255, 0).member = self:getDailyRemainDrawCount()
	spiritualGiftCtrl, spiritualGiftCtrl, cc.c3b(255, 255, 0).total = spiritualGiftRead, spiritualGiftRead:getDailyBuyLimit(self.group), spiritualGiftRead:getDailyBuyLimit(self.group)
	spiritualGiftCtrl, spiritualGiftRead:getDailyBuyLimit(self.group).member, spiritualGiftRead.color = spiritualGiftRead, spiritualGiftRead, "#00FF00"
	spiritualGiftRead:getDailyBuyLimit(self.group).__default, spiritualGiftRead.color = spiritualGiftRead, "#D7C39B"
	local numStr = i18n_html("common_text_155", cc.c3b(255, 255, 0))
	spiritualGiftCtrl = spiritualGiftRead:getDailyBuyLimit(self.group)
	spiritualGiftCtrl, spiritualGiftCtrl, spiritualGiftRead:getDailyBuyLimit(self.group).num = self.group, spiritualGiftRead, numStr
	spiritualGiftRead.__default, self.group.color = self.group, "#D7C39B"
	local str = i18n_html("godGift_text_25", spiritualGiftRead:getDailyBuyLimit(self.group), spiritualGiftRead)
	self.txtTodayRemain:setString(str)
end
function spiritualGiftView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SPIRITUAL_INIT_BACK", function(target, data)
		SoraDCloseLoading(self)
		if spiritualGiftCtrl:getAlreadyDrawNum() <= 0 then
			print("skdfjsdfkslkdf")
			_ENV = nil
			;(nil).byUID = true
			SoraDConfigSet("Game:spiritualGiftView:timeNotice~bool", false, nil)
		end
		self.oneTimeCostTicket = spiritualGiftRead:getOneTimeTicketCost(self.group)
		self.txtOneGold:setString(1)
		self.txtTenGold:setString(10)
		self:initData()
		self:initRewards()
	end)
	SoraDAddMessage(self, "MESSAGE_SPIRITUAL_BUY_ROLL_BACK", function(target, data)
		SoraDCloseLoading(self)
		if self.changeNum > 0 then
			spiritualGiftCtrl:reqDrawLottery(self.changeNum)
		end
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_SPIRITUAL_DRAW_BACK", function(target, data)
		SoraDCloseLoading(self)
		self:initData()
		self.changeNum = 0
		self.drawPanel = SoraDSearchPanelFromManagerByName("spiritualGiftPopRewardView")
		if self.drawPanel then
			self.drawPanel:initData(data.drawData)
			return
		end
		self.drawPanel = SoraDCreatePanel("spiritualGiftPopRewardView")
		self.drawPanel:initData(data.drawData)
		self.drawPanel:show()
	end)
	SoraDAddMessage(self, "MESSAGE_SPIRITUAL_RANK_BACK", function(target, data)
		SoraDCloseLoading(self)
		self.allRankList = spiritualGiftCtrl:getAllRankData()
		self:initRankScroll()
		self:initMyData()
	end)
	SoraDAddMessage(self, "MESSAGE_SPIRITUAL_CROSS_DAY", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SPIRITUAL_BIG_PRIZE_POOL_REFRESH", function(target, data)
		self:playDropGoldEffect(true)
		self:initRewards()
	end)
end
function spiritualGiftView:initRankScroll()
	self.scrollRank:removeAllChildren()
	local scrollH = math.max(self.scrollRank:getContentSize().height, singleRankH * #self.allRankList)
	self.scrollRank:setInnerContainerSize(cc.size(640, scrollH))
	for i, v in ipairs(self.allRankList) do
		local cellRank = self.nodeRank:clone()
		cellRank:setPosition(cc.p(320, scrollH - (i - 1) * singleRankH + 5))
		cellRank:addTo(self.scrollRank)
		local txtScore = SoraDGetChildByName(cellRank, "Text_num")
		txtScore:setString(string.formatnumberthousands(v.score))
		local imgHead = SoraDGetChildByName(cellRank, "Image_head")
		imgHead:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				if not SoraDIsNodeVisibleOnScroll(ref, self.scrollRank) then
					print("node is not on view")
					return
				end
				_ENV = "node is not on view"
				;("node is not on view").msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
				;("node is not on view").playerID = v.uid
				;("node is not on view").kid = v.kid
				SoraDSendMessage("node is not on view")
			end
		end)
		SoraDGetHeadFromManager(imgHead, v.imageId, v.avatar)
		local txtRanking = SoraDGetChildByName(cellRank, "Text_index")
		local txtComName = SoraDGetChildByName(cellRank, "Text_name")
		local name = v.nickName
		if v.allianceAbbr then
			_ENV = string.formatnumberthousands(v.score)
			string.formatnumberthousands(v.score).abbr = _q(v.allianceAbbr)
			string.formatnumberthousands(v.score).name = v.nickName
			name = i18n("common_text_186", string.formatnumberthousands(v.score))
		end
		txtComName:setString(name .. " " .. "#" .. v.kid)
		local spIndex = SoraDGetChildByName(cellRank, "Sprite_index")
		local imgBarBg = SoraDGetChildByName(cellRank, "Image_barBg")
		local uid = lordInfoCtrl:getLordInfo().base.uid
		if i <= RANK_TOP_SPECIAL then
			txtRanking:setVisible(false)
			spIndex:setSpriteFrame("icon_ranking_" .. i .. ".png")
			imgBarBg:loadTexture("frame_alliance_pank_0" .. i .. ".png", ccui.TextureResType.plistType)
		else
			spIndex:setVisible(false)
			txtRanking:setString(i)
			imgBarBg:loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
		end
		if tonumber(v.uid) == uid then
			imgBarBg:loadTexture("frame_alliance_pank_05.png", ccui.TextureResType.plistType)
		end
	end
end
function spiritualGiftView:initMyData()
	local myRankInfo = spiritualGiftCtrl:getSelfRankData()
	SoraDGetHeadFromManager(self.imgMyHead, myRankInfo.imageId, myRankInfo.avatar)
	local name = myRankInfo.nickName
	if myRankInfo.allianceAbbr then
		spiritualGiftCtrl = myRankInfo.avatar
		myRankInfo.avatar.abbr = _q(myRankInfo.allianceAbbr)
		myRankInfo.avatar.name = myRankInfo.nickName
		name = i18n("common_text_186", myRankInfo.avatar)
	end
	self.txtMyName:setString(name)
	if myRankInfo.rank == 0 then
		self.imgMyRanking:setVisible(false)
		self.txtMyRank:setVisible(true)
		self.txtMyRank:setString(i18n("common_text_827"))
	elseif myRankInfo.rank <= RANK_TOP_SPECIAL then
		self.imgMyRanking:setSpriteFrame("icon_ranking_" .. myRankInfo.rank .. ".png")
		self.imgMyRanking:setVisible(true)
		self.txtMyRank:setVisible(false)
	else
		self.imgMyRanking:setVisible(false)
		self.txtMyRank:setVisible(true)
		self.txtMyRank:setString(myRankInfo.rank)
	end
	self.txtMyName:setPositionY(50)
	self.txtMyPower:setVisible(false)
	self.txtMyScore:setString(myRankInfo.score)
end
function spiritualGiftView:initRewards()
	local jumpStep = 0
	for i, v in ipairs(self.itemTbl) do
		v:setVisible(false)
	end
	self.itemTbl, _ENV = ipairs(self.itemTbl)
	if self.poolPrizeType == PrizeType.super then
		jumpStep = 12
	end
	self:initItemsRefreshEffect(self.imgBg, self.isPlayingSuperEffect)
	for i = 1, self.totalPrizeNum do
		local single = self.itemTbl[i]
		if not single then
			if self.poolPrizeType == PrizeType.normal then
				single = SoraDCreatAnimationEx("heroSecretItemEffect", nil, false)
				single:setPosition(-4, 250)
			elseif self.poolPrizeType == PrizeType.super then
				single = SoraDCreatAnimationEx("around_eight", nil, false)
				single:setPosition(320, 600)
			end
			single:addTo(self.imgBg, 1)
			self.itemTbl[i] = single
		end
		self:initSingle(i + jumpStep)
	end
end
function spiritualGiftView:initItemsEffect(parent, isPlay)
	if isPlay then
		if parent.effectItem then
			SoraDResetEffectNode(parent.effectItem)
			parent.effectItem.action:gotoFrameAndPlay(0, 106, true)
		else
			parent.effectItem = SoraDCreatAnimationEx("spiritualGiftdaoju", nil, true)
			parent.effectItem:setScale(1.1)
			parent.effectItem:setPosition(cc.p(50, 50))
			SoraDMixtureGLONEByParent(parent.effectItem)
			local effectItem = parent.effectItem
			effectItem:addTo(parent:getParent(), 99)
			effectItem:setPosition(parent:getPositionX(), parent:getPositionY())
		end
	elseif parent.effectItem then
		parent.effectItem:removeFromParent()
		parent.effectItem = nil
	end
end
function spiritualGiftView:initItemsRefreshEffect(parent, isPlay)
	if isPlay then
		if self.effectRefresh then
			SoraDResetEffectNode(self.effectRefresh)
			self.effectRefresh.action:gotoFrameAndPlay(0, 30, false)
		else
			self.effectRefresh = SoraDCreatAnimationEx("spiritualGiftshuaxin", nil, false)
			self.effectRefresh:setScale(0.9)
			self.effectRefresh:setPosition(cc.p(320, 670))
			SoraDMixtureGLONEByParent(self.effectRefresh)
			self.effectRefresh:addTo(parent, 99)
		end
	elseif self.effectRefresh then
		self.effectRefresh:removeFromParent()
		self.effectRefresh = nil
	end
end
function spiritualGiftView:initItemsRefreshFireworkEffect(parent, isPlay)
	if isPlay then
		if parent.effectFire then
			SoraDResetEffectNode(parent.effectFire)
			parent.effectFire.action:gotoFrameAndPlay(0, 70, false)
		else
			parent.effectFire = SoraDCreatAnimationEx("spiritualGiftFirework", nil, false)
			parent.effectFire:setScale(1.1)
			parent.effectFire:setPosition(cc.p(50, 50))
			SoraDMixtureGLONEByParent(parent.effectFire)
			local effectFire = parent.effectFire
			effectFire:addTo(parent:getParent(), 99)
			effectFire:setPosition(parent:getPositionX(), parent:getPositionY())
		end
	elseif parent.effectFire then
		parent.effectFire:removeFromParent()
		parent.effectFire = nil
	end
end
function spiritualGiftView:initSingle(index)
	if spiritualGiftRead:getPrizePoolRewardByIndex(self.group, index, self.poolPrizeType) then
		local itemId = spiritualGiftRead:getPrizePoolRewardByIndex(self.group, index, self.poolPrizeType)[1].id
		local itemCount = spiritualGiftRead:getPrizePoolRewardByIndex(self.group, index, self.poolPrizeType)[1].count
		local single = self.itemTbl[index]
		local jumpStep = 0
		if self.poolPrizeType == PrizeType.super then
			jumpStep = 12
			single = self.itemTbl[index - jumpStep]
		end
		local icon = SoraDGetChildByName(single, "Image_icon")
		icon:setTag(itemId)
		icon:setSwallowTouches(false)
		icon:addTouchEventListener(handler(self, self.btnSingleItemClick))
		icon:loadTexture(publicRead.getIcon(itemId), ccui.TextureResType.plistType)
		local sheer = SoraDGetChildByName(single, "frame_sheer_black")
		if sheer then
			sheer:setVisible(false)
		end
		local Button_Item = SoraDGetChildByName(single, "Button_Item")
		if Button_Item then
			Button_Item:setVisible(false)
		end
		self:initItemsEffect(icon, self.poolPrizeType == PrizeType.super)
		self:initItemsRefreshFireworkEffect(icon, self.isPlayingSuperEffect)
		local txtSingle = SoraDGetChildByName(single, "text_num")
		txtSingle:setVisible(true)
		txtSingle:setString(itemCount)
		single.nowFrame = (index - jumpStep) * self.stepSize
		if self.poolPrizeType == PrizeType.normal then
			if single.nowFrame == 120 or single.nowFrame == 10 then
				single:setPosition(-4, 190)
			elseif single.nowFrame == 20 or single.nowFrame == 30 then
				single:setPosition(-4, 220)
			elseif single.nowFrame == 70 or single.nowFrame == 80 or single.nowFrame == 60 then
				single:setPosition(-4, 240)
			elseif single.nowFrame == 90 or single.nowFrame == 100 or single.nowFrame == 50 then
				single:setPosition(-4, 230)
			elseif single.nowFrame == 40 or single.nowFrame == 110 then
				single:setPosition(-4, 220)
			end
		elseif self.poolPrizeType == PrizeType.super then
		end
		single.action:gotoFrameAndPause(single.nowFrame)
	end
end
function spiritualGiftView:btnSingleItemClick(button, eventType)
	if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		self:stopActionByTag(1989)
		SoraDCloseCommonTips()
	elseif eventType == ccui.TouchEventType.began then
		_UPVALUE1_ = self
		self[1] = cca.delay(0.4)
		self[2] = cca.callFunc(function()
			SoraDShowCommonTips(button, button:getTag())
		end)
		self[3] = cca.callFunc(function()
			SoraDShowCommonTips(button, button:getTag())
		end)
		local seqLong = cca.seq(self)
		seqLong:setTag(1989)
		self:runAction(seqLong)
	end
end
function spiritualGiftView:btnClickTurn(button, eventType)
	if eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local turnLeft = touchBeganPoint.x > touchmovePoint.x
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > 30 and not self.isMove then
			self.isMove = true
			self:goToTurn(turnLeft)
		end
	end
end
function spiritualGiftView:goToTurn(direct)
	for i, v in ipairs(self.itemTbl) do
		local endFrame = 120
		local finalFrame = 280
		if self.poolPrizeType == PrizeType.super then
			endFrame = 80
			finalFrame = 200
		end
		local frame = direct and finalFrame - v.nowFrame or v.nowFrame
		if frame == endFrame then
			frame = 0
		end
		v.action:gotoFrameAndPlay(frame, self.stepSize + frame, false)
		local index = v.nowFrame / self.stepSize
		index = direct and index - 1 or index + 1
		index = (index - 1) % self.totalPrizeNum + 1
		v.nowFrame = direct and v.nowFrame - self.stepSize or v.nowFrame + self.stepSize
		v.nowFrame = (v.nowFrame - 1) % endFrame + 1
		if self.poolPrizeType == PrizeType.normal then
			if v.nowFrame == 120 or v.nowFrame == 10 then
				v:setPosition(-4, 190)
			elseif v.nowFrame == 20 or v.nowFrame == 30 then
				v:setPosition(-4, 220)
			elseif v.nowFrame == 70 or v.nowFrame == 80 or v.nowFrame == 60 then
				v:setPosition(-4, 240)
			elseif v.nowFrame == 90 or v.nowFrame == 100 or v.nowFrame == 50 then
				v:setPosition(-4, 230)
			elseif v.nowFrame == 40 or v.nowFrame == 110 then
				v:setPosition(-4, 220)
			end
		end
	end
	_UPVALUE1_ = ipairs(self.itemTbl)
	ipairs(self.itemTbl)[1] = cca.delay(0.15)
	ipairs(self.itemTbl)[2] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	ipairs(self.itemTbl)[3] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	ipairs(self.itemTbl)[4] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	ipairs(self.itemTbl)[5] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	ipairs(self.itemTbl)[6] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	ipairs(self.itemTbl)[7] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	ipairs(self.itemTbl)[8] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	ipairs(self.itemTbl)[9] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	ipairs(self.itemTbl)[10] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	ipairs(self.itemTbl)[11] = cca.callFunc(function()
		for i, v in ipairs(self.itemTbl) do
			v.action:gotoFrameAndPause(v.nowFrame)
		end
		self.isMove = false
	end)
	local seq = cca.seq(ipairs(self.itemTbl))
	self:runAction(seq)
end
function spiritualGiftView:btnAddRollClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local ownGold = lordInfoCtrl:getBaseInfo().gold
		local countLimit = math.min(999, math.max(1, math.floor(ownGold / self.oneTimeCostTicket)))
		self:quickBuy(countLimit)
	end
end
function spiritualGiftView:quickBuy(num)
	self.changeNum = 0
	_ENV, _ENV, _ENV = nil, nil, nil
	;(nil).targetID = gIDDef.GIFT_ROLL
	;(nil).exchangeID = gIDDef.GOLD
	;(nil).singCount = self.oneTimeCostTicket
	;(nil).exchangeData, (nil).curNum = nil, num
	;(nil).exchangeCfg, (nil).exchangeHandler = nil, handler(self, self.sureBuy)
	uiManager:show("newShopSingleBuy", nil)
end
function spiritualGiftView:drawNow(type, other)
	if type == MSGBOX_CALLBACK_YES then
		local isCheck = other.isCheck or false
		self.changeNum = 1
		self:sureBuy(1)
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:spiritualGiftView:timeNotice~bool", isCheck, nil)
	end
end
function spiritualGiftView:drawTenNow(type, other)
	if type == MSGBOX_CALLBACK_YES then
		local isCheck = other.isCheck or false
		self.changeNum = self.curTotalCount
		self:sureBuy(self.curNeedNum)
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:spiritualGiftView:timeNotice~bool", isCheck, nil)
	end
end
function spiritualGiftView:btnOneDrawClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local ticketCount = spiritualGiftCtrl:getGiftRollNum()
		if self:getDailyRemainDrawCount() <= 0 then
			SoraDShowMsgTip(i18n("godGift_text_16"))
			return
		end
		if ticketCount < 1 then
			_ENV = i18n("godGift_text_16")
			i18n("godGift_text_16").byUID = true
			local isTodayNotice = SoraDConfigGet("Game:spiritualGiftView:timeNotice~bool", i18n("godGift_text_16"))
			print("sdlkjfsldkfjslds1", isTodayNotice)
			if not isTodayNotice then
				_ENV = i18n("godGift_text_16")
				i18n("godGift_text_16").price = self.oneTimeCostTicket
				i18n("godGift_text_16").num = 1
				SoraDShowBuyBox(i18n("godGift_text_12", i18n("godGift_text_16")), self.oneTimeCostTicket, i18n("common_text_054"), handler(self, self.drawNow), nil, nil, nil, nil, nil, i18n("godGift_text_27"), false, nil, "spiritualGiftView")
			else
				self.changeNum = 1
				self:sureBuy(1)
			end
			return
		end
		spiritualGiftCtrl:reqDrawLottery(1)
		SoraDShowLoading(self)
	end
end
function spiritualGiftView:btnTenDrawClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local totalCount = 10
		local ticketCount = spiritualGiftCtrl:getGiftRollNum()
		local todayRemainCount = self:getDailyRemainDrawCount()
		local needNum = 0
		if todayRemainCount <= 0 then
			SoraDShowMsgTip(i18n("godGift_text_16"))
			return
		end
		if totalCount > todayRemainCount then
			totalCount = todayRemainCount
		end
		if ticketCount < 10 then
			if ticketCount >= totalCount then
				needNum = totalCount
			end
			needNum = totalCount - ticketCount
			self.curTotalCount = totalCount
			self.curNeedNum = needNum
			if 0 < needNum then
				_ENV = i18n("godGift_text_16")
				i18n("godGift_text_16").byUID = true
				local isTodayNotice = SoraDConfigGet("Game:spiritualGiftView:timeNotice~bool", i18n("godGift_text_16"))
				print("sdlkjfsldkfjslds10", isTodayNotice)
				if not isTodayNotice then
					_ENV = i18n("godGift_text_16")
					i18n("godGift_text_16").price = self.oneTimeCostTicket * needNum
					i18n("godGift_text_16").num = needNum
					SoraDShowBuyBox(i18n("godGift_text_12", i18n("godGift_text_16")), self.oneTimeCostTicket * needNum, i18n("common_text_054"), handler(self, self.drawTenNow), nil, nil, nil, nil, nil, i18n("godGift_text_27"), nil, nil, "spiritualGiftView")
				else
					self.changeNum = totalCount
					self:sureBuy(needNum)
				end
			else
				spiritualGiftCtrl:reqDrawLottery(totalCount)
				SoraDShowLoading(self)
			end
			return
		end
		spiritualGiftCtrl:reqDrawLottery(totalCount)
		SoraDShowLoading(self)
	end
end
function spiritualGiftView:getDailyRemainDrawCount()
	local alreadyDrawCount = spiritualGiftCtrl:getAlreadyDrawNum()
	local remainDrawCount = spiritualGiftRead:getDailyBuyLimit(self.group) - alreadyDrawCount
	return remainDrawCount
end
function spiritualGiftView:sureBuy(num)
	print("选择了数量:", num)
	local totalDiceCost = self.oneTimeCostTicket * num
	local ownGold = lordInfoCtrl:getBaseInfo().gold
	if totalDiceCost <= ownGold then
		spiritualGiftCtrl:reqBuyGiftRoll(num)
		SoraDShowLoading(self)
	else
		SoraDShowMsgBox(i18n("auction_text_16"), i18n("common_text_054"), nil, handler(self, self.gotoStore))
	end
end
function spiritualGiftView:gotoStore(type)
	if type == MSGBOX_CALLBACK_YES then
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
end
function spiritualGiftView:onClick_btn_help_tip(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local var1 = spiritualGiftRead:getEarnScore(self.group)
		local var2 = spiritualGiftRead:getInitGold(self.group)
		local var3 = spiritualGiftRead:getTaxCost(self.group)
		local var5 = spiritualGiftRead:getRankTop3Limit(self.group)
		local var6 = spiritualGiftRead:getDailyBuyLimit(self.group)
		local var7 = spiritualGiftRead:getTopPriceLimit(self.group)
		_ENV = nil
		;(nil).var1 = var1
		;(nil).var2 = var2
		;(nil).var3 = var3
		;(nil).var4 = var2
		;(nil).var5 = var5
		;(nil).var6 = var6
		;(nil).var7 = var7
		_ENV = "godGift_text_02"
		;("godGift_text_02").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("godGift_text_02", nil), "godGift_text_02")
	end
end
function spiritualGiftView:btnAreaClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("spiritualGiftAreaView")
		panel:show()
	end
end
function spiritualGiftView:btnMoreRewardClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local _ENV, data = SoraDPlaySound, SoraDPlaySound
		local rankData = spiritualGiftRead:getRankShowAllRewards(self.group)
		for k, v in ipairs(rankData) do
			_UPVALUE2_, _ENV = nil, nil
			;(nil).rank, (nil)[1] = nil, v.rank[1]
			;(nil).rank, (nil)[2] = nil, v.rank[2]
			data[k], (nil).reward = nil, v.reward
		end
		local var = spiritualGiftRead:getRankTop3Limit(self.group)
		local panel = SoraDCreatePanel("commonRankAwardView")
		_ENV = nil
		panel:initData(data, nil)
		_ENV = v.reward
		v.reward.var = string.formatnumberthousands(var)
		panel:setDownTip(i18n("godGift_text_24", v.reward))
		panel:show()
	end
end
function spiritualGiftView:btnPreviewRewardClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("spiritualGiftPreviewRewardView")
		panel:show()
	end
end
function spiritualGiftView:btnRecordClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("spiritualGiftRecordView")
		panel:show()
	end
end
function spiritualGiftView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return spiritualGiftView
