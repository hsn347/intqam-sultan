local gametop = gModuleMgr.getObject("gametop")
local allianceQuery = gametop.playertop_:getModule("allianceQuery")
local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local worldStrongPointView = class("worldStrongPointView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldStrongPointView")
	end
	return target
end)
function worldStrongPointView:ctor()
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.Node_st = SoraDGetChildByName(self, "Node_st")
	self.Text_status = SoraDGetChildByName(self, "Text_status")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.icon_status = SoraDGetChildByName(self, "icon_status")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Node_first = SoraDGetChildByName(self, "Node_first")
	self.Text_first = SoraDGetChildByName(self, "Text_first")
	self.Text_first:setString(i18n("alliance_stronghold_text_046"))
	self.Button_first = SoraDGetChildByName(self, "Button_first")
	self.Button_first:addTouchEventListener(handler(self, self.btnFirstClick))
	self.Text_noAlliance = SoraDGetChildByName(self, "Text_noAlliance")
	self.Text_noAlliance:setString(i18n("alliance_stronghold_text_039"))
	self.Text_noAlliance:setVisible(false)
	self.Node_allianceInfo = SoraDGetChildByName(self, "Node_allianceInfo")
	self.Node_allianceInfo:setVisible(false)
	self.Text_occAlli = SoraDGetChildByName(self, "Text_occAlli")
	self.Text_occAlli:setString(i18n("alliance_stronghold_text_043"))
	self.Node_alliance = SoraDGetChildByName(self, "Node_alliance")
	self.Text_alliName = SoraDGetChildByName(self, "Text_alliName")
	self.Button_aflag = SoraDGetChildByName(self, "Button_aflag")
	self.Button_aflag:addTouchEventListener(handler(self, self.btnFlagClick))
	self.Node_occInfo = SoraDGetChildByName(self, "Node_occInfo")
	self.Node_occInfo:setVisible(false)
	self.Node_army = SoraDGetChildByName(self, "Node_army")
	self.Node_attr = SoraDGetChildByName(self, "Node_attr")
	self.Text_attr = SoraDGetChildByName(self, "Text_attr")
	self.Text_attr:setString(i18n("alliance_stronghold_text_045"))
	self.Node_attrSingle = SoraDGetChildByName(self, "Node_attrSingle")
	self:suitView()
end
function worldStrongPointView:onEnterPanel()
	_ENV = nil
	;(nil).isHideMainUI = true
	SoraDHideCurrentSceneViewAndMainUI(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_WORLD_MAP_DISTANCE_VISIBLE"
	;(nil).ret = true
	SoraDSendMessage(nil)
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", function(...)
		self:removeFromParent()
	end)
end
function worldStrongPointView:onExitPanel()
	_ENV = nil
	;(nil).isHideMainUI = false
	SoraDHideCurrentSceneViewAndMainUI(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_WORLD_MAP_DISTANCE_VISIBLE"
	SoraDSendMessage(nil)
end
function worldStrongPointView:suitView()
	local Bottom_Size_Image_t = SoraDGetChildByName(self, "Bottom_Size_Image_t")
	Bottom_Size_Image_t:setContentSize(cc.size(640, math.max(615, display.height - 521)))
end
function worldStrongPointView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_WORLDMAPHOLD_UPDATE", handler(self, self.updateData))
end
function worldStrongPointView:updateData(target, data)
	if data and data.instance and data.instance.tilePoint and self.mapInstance and self.mapInstance.tilePoint and data.instance.tilePoint.x == self.mapInstance.tilePoint.x and data.instance.tilePoint.y == self.mapInstance.tilePoint.y then
		self:initData(data.instance, self.armyData, self.kid)
	end
end
function worldStrongPointView:initData(mapInstance, armyData, kid)
	self.mapInstance = mapInstance
	self.objId = mapInstance:getBuildClassID()
	self.status = mapInstance.warStatus
	self.armyData = armyData
	self.kid = kid
	if display.height >= 1300 then
		_ENV = mapInstance
		mapInstance.x = mapInstance.tilePoint.x + 3
		mapInstance.y = mapInstance.tilePoint.y + 3
		SoraDGotoWorldMapPoint(mapInstance, false, self.kid)
	else
		_ENV = mapInstance
		mapInstance.x = mapInstance.tilePoint.x + 2
		mapInstance.y = mapInstance.tilePoint.y + 2
		SoraDGotoWorldMapPoint(mapInstance, false, self.kid)
	end
	local buildInfo = allianceStrongholdMineRead.getGateClientCfg(self.objId)
	_ENV = nil
	;(nil).lv = allianceStrongholdMineRead.getGateLv(self.objId)
	;(nil).name = i18n(buildInfo.name)
	self.ccs_title:setTitle(i18n("LV.%{lv} %{name}", nil))
	_ENV = self.ccs_title.setTitle
	_ENV = i18n("LV.%{lv} %{name}", nil)
	i18n("LV.%{lv} %{name}", nil).str = i18n("alliance_stronghold_text_038")
	self.ccs_title.setTitle[gKingdomWarStatusType.close], i18n("LV.%{lv} %{name}", nil).color = i18n("LV.%{lv} %{name}", nil)
	_ENV = i18n("LV.%{lv} %{name}", nil)
	i18n("LV.%{lv} %{name}", nil).str = i18n("atlantiswar_text_0070")
	self.ccs_title.setTitle[gKingdomWarStatusType.inWar], i18n("LV.%{lv} %{name}", nil).color = i18n("LV.%{lv} %{name}", nil)
	_ENV = i18n("LV.%{lv} %{name}", nil)
	i18n("LV.%{lv} %{name}", nil).str = i18n("common_text_690")
	self.ccs_title.setTitle[gKingdomWarStatusType.rule], i18n("LV.%{lv} %{name}", nil).color = i18n("LV.%{lv} %{name}", nil)
	local statusCfg = self.ccs_title.setTitle
	self.Text_status:setString(statusCfg[self.status].str)
	self.Text_status:setColor(statusCfg[self.status].color)
	self.Text_time:endTime()
	if self.status == gKingdomWarStatusType.close then
		self.icon_status:setVisible(false)
		self.Node_time:setVisible(false)
		self.Text_noAlliance:setVisible(true)
		self.Node_first:setVisible(true)
	elseif self.status == gKingdomWarStatusType.inWar then
		self.icon_status:setVisible(true)
		self.icon_status:setSpriteFrame("icon_alliancewar_attacker.png")
		self.icon_status:setScale(0.7)
		self.Text_time:beginTime(mapInstance.warStatusEndTime - serviceFunctions.systemTime())
		self.Node_time:setVisible(true)
		SoraDToCenter(self.Node_time)
		self.Text_noAlliance:setVisible(false)
		if mapInstance.occupy and mapInstance.occupy.aid > 0 then
			self.Text_noAlliance:setVisible(false)
			self.Node_allianceInfo:setVisible(false)
			self.Node_occInfo:setVisible(true)
			self:setOccInfo(mapInstance.occupy)
		else
			self.Text_noAlliance:setVisible(true)
			self.Node_allianceInfo:setVisible(false)
			self.Node_occInfo:setVisible(false)
		end
		self.Node_first:setVisible(mapInstance.npc and true or false)
	elseif self.status == gKingdomWarStatusType.rule then
		self.icon_status:setVisible(true)
		self.icon_status:setSpriteFrame("icon_ldjd_baohu.png")
		self.icon_status:setScale(1)
		self.Text_time:beginTime(mapInstance.warStatusEndTime - serviceFunctions.systemTime())
		self.Node_time:setVisible(true)
		SoraDToCenter(self.Node_time)
		self.Text_noAlliance:setVisible(false)
		if mapInstance.occupy and mapInstance.occupy.aid > 0 then
			self.Text_noAlliance:setVisible(false)
			self.Node_allianceInfo:setVisible(true)
			self.Node_occInfo:setVisible(false)
			local flag = SoraDGetAllianceFlagByFid(mapInstance.occupy.flag)
			flag:addTo(self.Node_alliance)
			self.Button_aflag:setTag(mapInstance.occupy.aid)
			_ENV = 220
			;(220).abbr = mapInstance.occupy.abbr
			;(220).name = mapInstance.occupy.aName
			self.Text_alliName:setString(i18n("common_text_186", 220))
		else
			self.Text_noAlliance:setVisible(true)
			self.Node_allianceInfo:setVisible(false)
			self.Node_occInfo:setVisible(false)
		end
		self.Node_first:setVisible(mapInstance.npc and true or false)
	end
	SoraDToCenter(self.Node_st)
	self:setAttr()
end
function worldStrongPointView:setOccInfo(data)
	local ccs_head = SoraDGetExtendChildFromCCSByName(self.Node_occInfo, "CCS_commonHead_head")
	local Text_name = SoraDGetChildByName(self.Node_occInfo, "Text_name")
	local Node_alliInfo = SoraDGetChildByName(self.Node_occInfo, "Node_alliInfo")
	local Node_allianceFlag = SoraDGetChildByName(self.Node_occInfo, "Node_allianceFlag")
	local Button_flag = SoraDGetChildByName(self.Node_occInfo, "Button_flag")
	Button_flag:addTouchEventListener(handler(self, self.btnFlagClick))
	local Text_alliAbbr = SoraDGetChildByName(self.Node_occInfo, "Text_alliAbbr")
	local Text_occTime = SoraDGetChildByName(self.Node_occInfo, "Text_occTime")
	Text_occTime = SoraDCreateTimerLabel(self, Text_occTime)
	local Node_count = SoraDGetChildByName(self.Node_occInfo, "Node_count")
	local Text_armyNum = SoraDGetChildByName(self.Node_occInfo, "Text_armyNum")
	ccs_head:setPlayerID(data.uid)
	ccs_head:setHeadSprite(data.iconID, data.avatar)
	ccs_head:setScale(1.0)
	_ENV = handler(self, self.btnFlagClick)
	handler(self, self.btnFlagClick).abbr = data.abbr
	handler(self, self.btnFlagClick).name = data.name
	Text_name:setString(i18n("common_text_186", handler(self, self.btnFlagClick)))
	local flag = SoraDGetAllianceFlagByFid(data.flag)
	flag:addTo(Node_allianceFlag)
	Button_flag:setTag(data.aid)
	Text_alliAbbr:setString(data.aName)
	SoraDToCenter(Node_alliInfo, 30)
	Text_occTime:setTimeLast(function(time)
		_ENV = nil
		;(nil).var = time
		return i18n("alliance_stronghold_text_044", nil)
	end)
	Text_occTime:endTime()
	Text_occTime:beginTime(serviceFunctions.systemTime() - data.beginOccupyTime, true)
	if data.aid == allianceMgr:getOwnAid() then
		local curArmyCount = 0
		if self.armyData and next(self.armyData) then
			for k, v in ipairs(self.armyData) do
				for ki, vi in pairs(v.armyList) do
					curArmyCount = curArmyCount + vi.num
				end
			end
		end
		_ENV = i18n("common_text_186", handler(self, self.btnFlagClick))
		i18n("common_text_186", handler(self, self.btnFlagClick)).member = string.formatnumberthousands(curArmyCount)
		i18n("common_text_186", handler(self, self.btnFlagClick)).total = string.formatnumberthousands(data.maxNum)
		Text_armyNum:setString(i18n("common_text_155", i18n("common_text_186", handler(self, self.btnFlagClick))))
		SoraDToCenter(Node_count)
		self.Node_army:setVisible(0 < curArmyCount)
	else
		self.Node_army:setVisible(false)
	end
end
function worldStrongPointView:setAttr()
	local bType = allianceStrongholdMineRead.getGateBuffType(self.objId)
	local buffList = allianceStrongholdMineRead.getBuffByType(bType)
	for k, v in ipairs(buffList) do
		local nodeSingle
		if k == 1 then
			nodeSingle = self.Node_attrSingle
		else
			nodeSingle = self.Node_attrSingle:clone()
			nodeSingle:addTo(self.Node_attr)
		end
		nodeSingle:setPosition(0, -55 - 42 * (k - 1))
		SoraDGetChildByName(nodeSingle, "Image_pbg"):setVisible(k % 2 == 1)
		SoraDGetChildByName(nodeSingle, "Text_attrName"):setString(v.des)
		SoraDGetChildByName(nodeSingle, "Text_attrVal"):setString(v.val)
	end
end
function worldStrongPointView:btnFlagClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		_ENV, (nil).aid = button:getTag(), button:getTag()
		button:getTag().from = "worldStrongPointView"
		allianceQuery:reqAllianceByID(nil, (button:getTag()))
	end
end
function worldStrongPointView:btnFirstClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("打开首占奖励")
		local panel = SoraDCreatePanel("worldStrongPointFirstAwardView")
		local award = allianceStrongholdMineRead.getFirstRewards(self.objId)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		local rewards = serviceFunctions.tableFormat(award, nil)
		panel:initData(rewards)
		panel:show()
	end
end
function worldStrongPointView:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "worldStrongPointView" then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
function worldStrongPointView:btnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local lv = allianceStrongholdMineRead.getGateLv(self.objId)
		_ENV = self.objId
		self.objId[1] = i18n("alliance_stronghold_text_079")
		self.objId[2] = i18n("alliance_stronghold_text_078")
		self.objId[3] = i18n("alliance_stronghold_text_077")
		local self.objId[4], contentCfg = i18n("alliance_stronghold_text_076"), self.objId
		_ENV = nil
		;(nil).title = i18n("common_text_001")
		;(nil).align = SoraDFLabelR()
		SoraDShowHelpMsgTip(contentCfg[lv], nil)
	end
end
return worldStrongPointView
