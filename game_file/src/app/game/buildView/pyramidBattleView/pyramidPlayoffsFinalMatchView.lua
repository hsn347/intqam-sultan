local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local pyramidClientModule = include("pyramidClientModule")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local PyramidPlayoffsFinalMatchView = class("pyramidPlayoffsFinalMatchView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidPlayoffsFinalMatchView")
	end
	return target
end)
function PyramidPlayoffsFinalMatchView:ctor()
	self.tableSingle, pyramidClientModule, self.aidList, pyramidClientModule, self.curData, pyramidClientModule = nil, nil, nil, nil, nil, nil
	self.curMatchType = pyramidClientModule.getPostSeasonShowState()
	self.nodeBtns = SoraDGetChildByName(self, "Node_btns")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_main")
	self.imgCopy = SoraDGetChildByName(self, "Panel_copy")
	self.btnSelectTime = SoraDGetChildByName(self, "Button_selectTime")
	self.btnEnter = SoraDGetChildByName(self, "Button_enter")
	self.btnManager = SoraDGetChildByName(self, "Button_manager")
	self.btnRule = SoraDGetChildByName(self, "Button_rule")
	self.btnPrice = SoraDGetChildByName(self, "Button_price")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.labelTime = SoraDCreateTimerLabel(self, self.labelTime)
	self.spTime = SoraDGetChildByName(self, "Sprite_time")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramidSearch")
	self:createSingleClass()
	self:initData()
	self:req4WatchList()
	self.btnSelectTime:setTitleText(i18n("common_text_4002"))
	self.btnEnter:setTitleText(i18n("common_text_3318"))
	self.btnManager:setTitleText(i18n("common_text_3317"))
	self.btnPrice:setTitleText(i18n("common_text_2078"))
	self.btnSelectTime:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnManager:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnEnter:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnRule:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnPrice:addTouchEventListener(handler(self, self.btnClickCallBack))
	SoraDGetChildByName(self, "Size_Image_bg"):setFillType(1)
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_MAINSTATECHANGE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqAllianceInfoBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_ENTERBATTLEFAIL", handler(self, self.closeLoading))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDPOSTSEASON_WATCHLIST", handler(self, self.refreshBtnLook))
end
function PyramidPlayoffsFinalMatchView:req4WatchList(...)
	pyramidWarCtrl:getWatchList()
end
function PyramidPlayoffsFinalMatchView:sMsgReqAllianceInfoBack(target, data)
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "pyramidPlayoffsFinalMatchView" then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
	SoraDCloseLoading(self)
end
function PyramidPlayoffsFinalMatchView:closeLoading(target, redata)
	SoraDCloseLoading(self)
end
function PyramidPlayoffsFinalMatchView:updateBtn()
	self.btnSelectTime:setVisible(false)
	self.btnEnter:setVisible(false)
	self.btnManager:setVisible(false)
	self.labelTime:setVisible(false)
	self.btnManager:setPositionX(155)
	local _des, _ades, _ticket = pyramidClientModule.getDesFromPostSeasonState()
	local _, _, _aState = pyramidClientModule.getPostSeasonShowState()
	if allianceMgr:hasJoinAlliance() and self.aidList[allianceMgr:getOwnAid()] then
		if _aState == gPinnacleSeasonState.NOT_APPLY then
			self.btnSelectTime:setVisible(true)
		elseif _aState == gPinnacleSeasonState.APPLY_ED then
			self.btnManager:setVisible(true)
			self.btnManager:setPositionX(0)
		elseif _aState == gPinnacleSeasonState.PREPARE then
			self.btnManager:setVisible(true)
			self.btnEnter:setVisible(true)
			self.btnEnter:setTouchEnabled(false)
			self.btnEnter:setBright(false)
		elseif _aState == gPinnacleSeasonState.RUNNING then
			self.btnManager:setVisible(true)
			self.btnEnter:setVisible(true)
			self.btnEnter:setTouchEnabled(true)
			self.btnEnter:setBright(true)
		end
	end
	if _ticket then
		self.labelTime:setVisible(true)
		pyramidClientModule = nil
		;(nil).time = SoraDConvertSecondToString(_ticket)
		self.labelTime:setString(i18n(_ades, nil))
		self.spTime:setVisible(true)
		if SoraDFIsRA() then
			self.spTime:setPositionX(self.labelTime:getPositionX() + self.labelTime:getContentSize().width / 2 + self.spTime:getContentSize().width / 2)
		else
			self.spTime:setPositionX(self.labelTime:getPositionX() - self.labelTime:getContentSize().width / 2 - self.spTime:getContentSize().width / 2)
		end
		self.labelTime:setTimeLast(function(tick)
			_ENV = nil
			;(nil).time = tick
			local reText = i18n(_ades, nil)
			return reText
		end)
		self.labelTime:beginTime(_ticket)
	else
		self.spTime:setVisible(false)
	end
end
function PyramidPlayoffsFinalMatchView:updateView()
	self.aidList, pyramidClientModule, self.curData, pyramidClientModule = nil, nil, nil, nil
	self.curMatchType = pyramidClientModule.getPostSeasonShowState()
	if self.curMatchType < 4 then
		self:removeFromParent()
		return
	end
	self:initView()
	for i, v in ipairs(self.tableSingle) do
		v:initData(self.curData[i])
	end
end
function PyramidPlayoffsFinalMatchView:initView()
	_ENV = nil
	;(nil)[1] = "A"
	local (nil)[2], toKey = "B", nil
	local _ENV, battleResult
	if self.curMatchType == 4 then
		self.nodeTitle:setTitle(i18n("common_text_4014"))
		battleResult = pyramidWarCtrl:getSemifinals()
	elseif self.curMatchType == 5 or self.curMatchType == 6 then
		self.nodeTitle:setTitle(i18n("common_text_4067"))
		battleResult = pyramidWarCtrl:getFinal()
	end
	for i, v in ipairs(toKey) do
		_ENV = i18n("common_text_4067")
		i18n("common_text_4067").group = v
		i18n("common_text_4067").data = battleResult[v]
		table.insert(self.curData, i18n("common_text_4067"))
		self.aidList[battleResult[v][1]] = true
		self.aidList[battleResult[v][2]] = true
	end
	self:updateBtn()
end
function PyramidPlayoffsFinalMatchView:createSingleClass(...)
	self.singleClass = class("PyramidPlayoffsFinalMatchSingle", function(target)
		return self.imgCopy:clone()
	end)
	function self.singleClass:ctor()
		self.groupData, pyramidClientModule = nil, nil
		self.curMatchType = pyramidClientModule.getPostSeasonShowState()
		self.left, pyramidClientModule, self.labelTitle = SoraDGetChildByName(self, "Text_title"), SoraDGetChildByName(self, "Text_title"), SoraDGetChildByName(self, "Text_title")
		self.left.name = self:getChildByName("Text_AName")
		self.left.king = self:getChildByName("Text_AKing")
		self.left.power = self:getChildByName("Text_APower")
		self.left.allianceFlag = self:getChildByName("Node_flag_A")
		self.left.rank = self:getChildByName("Image_ARank")
		self.right, pyramidClientModule, self.left.btn = self.left, self.left, self:getChildByName("Button_A")
		self.right.name = self:getChildByName("Text_BName")
		self.right.king = self:getChildByName("Text_BKing")
		self.right.power = self:getChildByName("Text_BPower")
		self.right.allianceFlag = self:getChildByName("Node_flag_B")
		self.right.rank = self:getChildByName("Image_BRank")
		self.right.btn = self:getChildByName("Button_B")
		self.imgWin = self:getChildByName("Image_win")
		self.labelTime = self:getChildByName("Text_time")
		self.btnLook = self:getChildByName("Button_look")
		self.btnLook:setVisible(false)
		self.imgWin:setVisible(false)
		self.labelTime:setVisible(false)
		self.right.rank:setVisible(false)
		self.left.rank:setVisible(false)
		self.btnLook:addTouchEventListener(handler(self, self.btnLookClick))
	end
	function self.singleClass:upateLookBtn(bool, kid)
		if bool then
			self.btnLook:setVisible(true)
			self.btnLook:stopAllActions()
			_UPVALUE1_ = nil
			;(nil)[1] = cca.fadeOut(0.5)
			;(nil)[2] = cca.fadeIn(0.5)
			;(nil)[3] = cca.fadeIn(0.5)
			self.btnLook:runAction(cca.repeatForever(cca.seq(nil)))
			self.kid = kid
		else
			self.btnLook:setVisible(false)
			self.btnLook:stopAllActions()
		end
	end
	function self.singleClass:btnLookClick(button, eventType)
		if eventType == ccui.TouchEventType.ended and self.kid then
			SoraDGotoWorldMapPoint(cc.p(75, 75), false, self.kid, nil, nil, true)
			SoraDRemoveAllPanelFromManager()
		end
	end
	function self.singleClass:initData(groupData)
		self.groupData = groupData
		_ENV = nil
		;(nil).rank = self.groupData.group
		self.labelTitle:setString(i18n("common_text_4016", nil))
		self.battle, _ENV = self.labelTitle.setString, self.labelTitle.setString
		local curTime = pyramidWarCtrl:getBattleTime(self.groupData.data[1])
		if curTime <= 0 then
			curTime = pyramidWarCtrl:getBattleTime(self.groupData.data[2])
		end
		if self.groupData.data[1] > 0 then
			self.battle.left = pyramidWarCtrl:getPostSeasonAllianceInfo(self.groupData.data[1])
			if allianceMgr:getOwnAid() == self.groupData.data[1] then
				self.left.name:setColor(cc.c3b(251, 204, 112))
				self.left.king:setColor(cc.c3b(251, 204, 112))
				self.left.power:setColor(cc.c3b(251, 204, 112))
			end
			self.left.btn:addTouchEventListener(function(button, eventType)
				if eventType == ccui.TouchEventType.ended then
					SoraDPlaySound()
					local allianceQuery = gametop.playertop_:getModule("allianceQuery")
					SoraDShowLoading(SoraDSearchPanelFromManagerByName("pyramidPlayoffsFinalMatchView"))
					_ENV = SoraDSearchPanelFromManagerByName("pyramidPlayoffsFinalMatchView")
					SoraDSearchPanelFromManagerByName("pyramidPlayoffsFinalMatchView").from = "pyramidPlayoffsFinalMatchView"
					allianceQuery:reqAllianceInfo(self.battle.left.kid, self.groupData.data[1], SoraDSearchPanelFromManagerByName("pyramidPlayoffsFinalMatchView"))
				end
			end)
		end
		if 0 < self.groupData.data[2] then
			self.battle.right = pyramidWarCtrl:getPostSeasonAllianceInfo(self.groupData.data[2])
			if allianceMgr:getOwnAid() == self.groupData.data[2] then
				self.right.name:setColor(cc.c3b(251, 204, 112))
				self.right.king:setColor(cc.c3b(251, 204, 112))
				self.right.power:setColor(cc.c3b(251, 204, 112))
			end
			self.right.btn:addTouchEventListener(function(button, eventType)
				if eventType == ccui.TouchEventType.ended then
					SoraDPlaySound()
					local allianceQuery = gametop.playertop_:getModule("allianceQuery")
					SoraDShowLoading(SoraDSearchPanelFromManagerByName("pyramidPlayoffsFinalMatchView"))
					_ENV = SoraDSearchPanelFromManagerByName("pyramidPlayoffsFinalMatchView")
					SoraDSearchPanelFromManagerByName("pyramidPlayoffsFinalMatchView").from = "pyramidPlayoffsFinalMatchView"
					allianceQuery:reqAllianceInfo(self.battle.right.kid, self.groupData.data[2], SoraDSearchPanelFromManagerByName("pyramidPlayoffsFinalMatchView"))
				end
			end)
		end
		if 0 < curTime then
			self.labelTime:setVisible(true)
			self.labelTime:setString(os.date("!%Y-%m-%d %H:%M:%S", curTime))
		end
		self:initView()
	end
	function self.singleClass:getSingleInfo(...)
		return self.groupData
	end
	function self.singleClass:initView(...)
		if self.battle.left then
			_ENV = nil
			_ENV = nil
			;(nil).abbr = self.battle.left.abbr
			;(nil).name = self.battle.left.name
			;(nil).conten = i18n("common_text_186", nil)
			self.left.name:setString(i18n("common_text_925", nil))
			_ENV = i18n("common_text_925", nil)
			i18n("common_text_925", nil).name = self.battle.left.kname
			self.left.king:setString(i18n("common_text_971", i18n("common_text_925", nil)))
			_ENV = i18n("common_text_971", i18n("common_text_925", nil))
			i18n("common_text_971", i18n("common_text_925", nil)).count = string.formatnumberthousands(self.battle.left.power)
			self.left.power:setString(i18n("common_text_555", i18n("common_text_971", i18n("common_text_925", nil))))
			self.left.allianceFlag:removeAllChildren()
			allianceDesRead.getFlagWithParticle(self.battle.left.flag, self.left.allianceFlag)
		else
			for k, v in pairs(self.left) do
				v:setVisible(false)
			end
			self.left.name:setVisible(true)
			self.left.name:setPositionY(-113)
			self.left.name:setString(i18n("common_text_927"))
		end
		if self.battle.right then
			_ENV = i18n("common_text_927")
			_ENV = i18n("common_text_927")
			i18n("common_text_927").abbr = self.battle.right.abbr
			i18n("common_text_927").name = self.battle.right.name
			i18n("common_text_927").conten = i18n("common_text_186", i18n("common_text_927"))
			self.right.name:setString(i18n("common_text_925", i18n("common_text_927")))
			_ENV = i18n("common_text_925", i18n("common_text_927"))
			i18n("common_text_925", i18n("common_text_927")).name = self.battle.right.kname
			self.right.king:setString(i18n("common_text_971", i18n("common_text_925", i18n("common_text_927"))))
			_ENV = i18n("common_text_971", i18n("common_text_925", i18n("common_text_927")))
			i18n("common_text_971", i18n("common_text_925", i18n("common_text_927"))).count = string.formatnumberthousands(self.battle.right.power)
			self.right.power:setString(i18n("common_text_555", i18n("common_text_971", i18n("common_text_925", i18n("common_text_927")))))
			self.right.allianceFlag:removeAllChildren()
			allianceDesRead.getFlagWithParticle(self.battle.right.flag, self.right.allianceFlag)
		else
			for k, v in pairs(self.right) do
				v:setVisible(false)
			end
			self.right.name:setVisible(true)
			self.right.name:setPositionY(-113)
			self.right.name:setString(i18n("common_text_927"))
		end
		self:updateWin()
	end
	function self.singleClass:updateWin()
		self.imgWin:setVisible(false)
		if self.curMatchType == 4 then
			if self.groupData.data[1] > 0 and pyramidWarCtrl:getIsPromote(4, self.groupData.data[1]) then
				self.imgWin:setVisible(true)
				self.imgWin:setPositionX(80)
			elseif 0 < self.groupData.data[2] and pyramidWarCtrl:getIsPromote(4, self.groupData.data[2]) then
				self.imgWin:setVisible(true)
				self.imgWin:setPositionX(565)
			end
			if pyramidWarCtrl:getIsPromote(4, self.groupData.data[1]) or pyramidWarCtrl:getIsPromote(4, self.groupData.data[2]) then
				self.labelTime:setVisible(false)
			end
		elseif self.curMatchType == 5 then
			pyramidWarCtrl = self.curMatchType
			self.curMatchType[1] = "icon_battlefield_playoff_gold.png"
			self.curMatchType[2] = "icon_battlefield_playoff_silver.png"
			self.curMatchType[3] = "icon_battlefield_playoff_cuprum.png"
			local self.curMatchType[4], flag = "bg_transparent.png", self.curMatchType
			if flag[pyramidWarCtrl:getPostSeasonTop3Rank(self.groupData.data[1])] then
				self.left.rank:setVisible(true)
				self.left.rank:loadTexture(flag[pyramidWarCtrl:getPostSeasonTop3Rank(self.groupData.data[1])], ccui.TextureResType.plistType)
			end
			if flag[pyramidWarCtrl:getPostSeasonTop3Rank(self.groupData.data[2])] then
				self.right.rank:setVisible(true)
				self.right.rank:loadTexture(flag[pyramidWarCtrl:getPostSeasonTop3Rank(self.groupData.data[2])], ccui.TextureResType.plistType)
			end
			if 0 < pyramidWarCtrl:getPostSeasonTop3Rank(self.groupData.data[1]) or 0 < pyramidWarCtrl:getPostSeasonTop3Rank(self.groupData.data[2]) then
				self.labelTime:setVisible(false)
			end
		end
	end
	function self.singleClass.returnHeigh()
		return 310
	end
end
function PyramidPlayoffsFinalMatchView:refreshBtnLook(target, redata)
	local judgeIsOpen = function(obj, info)
		local infoData = obj:getSingleInfo()
		if info.aInfo1.aid == infoData.data[1] or info.aInfo1.aid == infoData.data[2] then
			local nowTime = serviceFunctions.systemTime()
			if nowTime - info.endtime <= 0 and 0 <= nowTime - info.starttime and info.status == gPostSeasonWatchState.OPEN then
				local kid = info.kid or 1
				obj:upateLookBtn(true, kid)
			else
				local kid = info.kid or 1
				obj:upateLookBtn(false, kid)
			end
		end
	end
	local contorlInfo = redata.redata
	for _, v in pairs(self.tableSingle) do
		for _, val in pairs(contorlInfo) do
			judgeIsOpen(v, val)
		end
	end
end
function PyramidPlayoffsFinalMatchView:initData()
	self:initView()
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, self.singleClass.returnHeigh() * 2 + 130 + 8 + 20)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	sH = sH - 8
	for i = 1, 2 do
		local single = self.singleClass.new()
		single:setPosition(sSize.width / 2 + 3.5, sH)
		single:addTo(self.scroll)
		single:initData(self.curData[i])
		sH = sH - single.returnHeigh()
		table.insert(self.tableSingle, single)
		if self.btnSelectTime:isVisible() or self.btnEnter:isVisible() or self.btnManager:isVisible() then
			for k, v in pairs(self.curData[i].data) do
				if allianceMgr:getOwnAid() == v then
					self.nodeBtns:setPosition(sSize.width / 2, sH)
					sH = sH - 140
					break
				end
			end
		end
	end
end
function PyramidPlayoffsFinalMatchView:btnClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button == self.btnSelectTime then
			SoraDCreatePanel("pyramidPlayoffsSignUp"):show()
		elseif button == self.btnRule then
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.PYRAMID_BATTLE)
		elseif button == self.btnPrice then
			if pyramidWarCtrl.curSeasonType == gSeasonType.PINNACLE_SEASON then
				SoraDCreatePanel("alliancePBLPrizeView"):show()
			else
				SoraDCreatePanel("pyramidPlayoffsPriceView"):show()
			end
		elseif button == self.btnEnter then
			local enterWarCondition = function(...)
				local gametop = gModuleMgr.getObject("gametop")
				local armyCtrl = gametop.playertop_:getModule("armyCtrl")
				if armyCtrl:getTotalWoundedArmyCount() > 0 then
					SoraDShowMsgBox(i18n("common_text_3261"), i18n("common_text_402"), nil, function(eventType)
						if eventType == MSGBOX_CALLBACK_YES then
							local worldMapWarDef = include("worldMapWarDef")
							worldMapWarDef.openHospitalView()
						end
					end)
					return false
				end
				local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
				if kingdomMapCtrl.kingdomMapCell:hasWoundedQueueArmy() then
					SoraDShowMsgTip(i18n("common_text_3498"))
					return false
				end
				if kingdomMapCtrl:isHasMassQueue() then
					SoraDShowMsgTip(i18n("common_text_3262"))
					return false
				end
				return true
			end
			local enterBattle = function()
				if enterWarCondition() then
					SoraDShowLoading(self)
					pyramidWarCtrl:pyramidwarEnterReq()
				end
			end
			pyramidClientModule.popSelectMenu(enterBattle)
		elseif button == self.btnManager then
			SoraDCreatePanel("pyramidBattleManager"):show()
		end
	end
end
function PyramidPlayoffsFinalMatchView:addEffectFlow(...)
	if not self.effectFlow then
		self.scroll:setVisible(false)
		local _shader = require("app.game.buildView.pyramidBattleView.shader_sz_shader")
		local _meshData = require("app.game.buildView.pyramidBattleView.shader_sz_meshData")
		local _param = require("app.game.buildView.pyramidBattleView.shader_sz_shaderCfg")
		_ENV = "app.game.buildView.pyramidBattleView.shader_sz_shaderCfg"
		;("app.game.buildView.pyramidBattleView.shader_sz_shaderCfg").meshData = _meshData
		_ENV, ("app.game.buildView.pyramidBattleView.shader_sz_shaderCfg").size = cc.size(0, 0), cc.size(0, 0)
		cc.size(0, 0).vertBytes = _shader.vertBytes
		;("app.game.buildView.pyramidBattleView.shader_sz_shaderCfg").shader, cc.size(0, 0).fragBytes = cc.size(0, 0), _shader.fragBytes
		;("app.game.buildView.pyramidBattleView.shader_sz_shaderCfg").param = _param.param
		_ENV, ("app.game.buildView.pyramidBattleView.shader_sz_shaderCfg").pos = cc.p(320, 480), cc.p(320, 480)
		cc.p(320, 480).x = 0.14
		;("app.game.buildView.pyramidBattleView.shader_sz_shaderCfg").scale, cc.p(320, 480).y = cc.p(320, 480), 0.14
		local createData = "app.game.buildView.pyramidBattleView.shader_sz_shaderCfg"
		local meshNode = SoraDCreateMeshNode(createData.meshData, createData.size, createData.shader, createData.param)
		meshNode:setPosition(cc.p(createData.pos))
		meshNode:setScale(createData.scale.x, createData.scale.y)
		meshNode:setBlendFunc(gl.ONE, gl.ONE)
		meshNode:addTo(self, 999)
		self.effectFlow = meshNode
	end
end
return PyramidPlayoffsFinalMatchView
