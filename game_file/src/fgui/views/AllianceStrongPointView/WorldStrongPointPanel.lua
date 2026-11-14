local gametop = gModuleMgr.getObject("gametop")
local allianceQuery = gametop.playertop_:getModule("allianceQuery")
local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldStrongPointPanel = class("WorldStrongPointPanel", baseFguiPanel)
function WorldStrongPointPanel:ctor(...)
	WorldStrongPointPanel.super.ctor(self, ...)
	print("WorldStrongPointPanel:ctor", self.viewName)
end
function WorldStrongPointPanel:onInit()
	print("=======WorldStrongPointPanel:onInit")
	self.fields.Com_title:initData("", handler(self, self.onClickClose), handler(self, self.btnHelpClick))
	self.Text_status = self.fields.Node_status:getChild("Text_status")
	self.icon_status = self.fields.Node_status:getChild("icon_status")
	self.Text_time = self.fields.Node_time
	self.Node_first = self.fields.Button_first
	self.Button_first = self.fields.Button_first
	self.Button_first:setString(i18n("alliance_stronghold_text_046"))
	self.Button_first:addClickListener(handler(self, self.btnFirstClick))
	self.Text_noAlliance = self.fields.Text_noAlliance
	self.Text_noAlliance:setString(i18n("alliance_stronghold_text_039"))
	self.Node_allianceInfo = self.fields.Node_allianceInfo
	self.Text_occAlli = self.fields.Text_occAlli
	self.Text_occAlli:setString(i18n("alliance_stronghold_text_043"))
	self.Node_alliance = self.fields.Node_alliance
	self.Text_alliName = self.fields.Text_alliName
	self.Button_aflag = self.fields.Button_aflag
	self.Button_aflag:addClickListener(handler(self, self.btnFlagClick))
	self.Node_occInfo = self.fields.Node_occInfo
	self.Node_army = self.fields.Node_army
	self.Text_attr = self.fields.Text_attr
	self.Text_attr:setString(i18n("alliance_stronghold_text_045"))
	self.fields.List_attr:setItemRenderer(handler(self, self.onItemRenderer))
	if not SoraDFIsRA() then
		self.fields.Button_first:fixPos()
		self.Text_status:fixPos()
		self.icon_status:fixPos()
		self.fields.Text_alliAbbr:fixPos()
		self.fields.Node_allianceFlag:fixPos()
		self.fields.Sprite_count:fixPos()
	end
end
function WorldStrongPointPanel:onShow()
	print("=======WorldStrongPointPanel:onShow")
	_ENV = "=======WorldStrongPointPanel:onShow"
	;("=======WorldStrongPointPanel:onShow").isHideMainUI = true
	SoraDHideCurrentSceneViewAndMainUI("=======WorldStrongPointPanel:onShow")
	_ENV = "=======WorldStrongPointPanel:onShow"
	;("=======WorldStrongPointPanel:onShow").msg = "MESSAGE_SERVER_WORLD_MAP_DISTANCE_VISIBLE"
	;("=======WorldStrongPointPanel:onShow").ret = true
	SoraDSendMessage("=======WorldStrongPointPanel:onShow")
end
function WorldStrongPointPanel:onHide()
	_ENV = nil
	;(nil).isHideMainUI = false
	SoraDHideCurrentSceneViewAndMainUI(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_WORLD_MAP_DISTANCE_VISIBLE"
	SoraDSendMessage(nil)
end
function WorldStrongPointPanel:updateData(target, data)
	if data and data.instance and data.instance.tilePoint and self.mapInstance and self.mapInstance.tilePoint and data.instance.tilePoint.x == self.mapInstance.tilePoint.x and data.instance.tilePoint.y == self.mapInstance.tilePoint.y then
		self:initData(data.instance, self.armyData, self.kid)
	end
end
function WorldStrongPointPanel:initData(mapInstance, armyData, kid)
	self.mapInstance = mapInstance
	self.objId = mapInstance:getBuildClassID()
	self.status = mapInstance.warStatus
	self.armyData = armyData
	self.kid = kid
	_ENV = mapInstance
	mapInstance.x = mapInstance.tilePoint.x + 2
	mapInstance.y = mapInstance.tilePoint.y + 2
	SoraDGotoWorldMapPoint(mapInstance, false, self.kid)
	local buildInfo = allianceStrongholdMineRead.getGateClientCfg(self.objId)
	_ENV = nil
	;(nil).lv = allianceStrongholdMineRead.getGateLv(self.objId)
	;(nil).name = i18n(buildInfo.name)
	self.fields.Com_title:setTitle(i18n("LV.%{lv} %{name}", nil))
	_ENV = self.fields.Com_title.setTitle
	_ENV = i18n("LV.%{lv} %{name}", nil)
	i18n("LV.%{lv} %{name}", nil).str = i18n("alliance_stronghold_text_038")
	self.fields.Com_title.setTitle[gKingdomWarStatusType.close], i18n("LV.%{lv} %{name}", nil).color = i18n("LV.%{lv} %{name}", nil)
	_ENV = i18n("LV.%{lv} %{name}", nil)
	i18n("LV.%{lv} %{name}", nil).str = i18n("atlantiswar_text_0070")
	self.fields.Com_title.setTitle[gKingdomWarStatusType.inWar], i18n("LV.%{lv} %{name}", nil).color = i18n("LV.%{lv} %{name}", nil)
	_ENV = i18n("LV.%{lv} %{name}", nil)
	i18n("LV.%{lv} %{name}", nil).str = i18n("common_text_690")
	self.fields.Com_title.setTitle[gKingdomWarStatusType.rule], i18n("LV.%{lv} %{name}", nil).color = i18n("LV.%{lv} %{name}", nil)
	local statusCfg = self.fields.Com_title.setTitle
	self.Text_status:setString(statusCfg[self.status].str)
	self.Text_status:setColor(statusCfg[self.status].color)
	fguiHelper.setTextWidthHeight(self.Text_status, cc.size(220, 50))
	self.Text_time:endTime()
	if self.status == gKingdomWarStatusType.close then
		self.controllers.c1:setSelectedIndex(0)
		self.icon_status:setVisible(false)
		self.Text_time:setVisible(false)
		self.Node_first:setVisible(true)
	elseif self.status == gKingdomWarStatusType.inWar then
		self.icon_status:setVisible(true)
		self.icon_status:setURL("icon_alliancewar_attacker.png")
		self.Text_time:beginTime(mapInstance.warStatusEndTime - serviceFunctions.systemTime())
		self.Text_time:setVisible(true)
		if mapInstance.occupy and 0 < mapInstance.occupy.aid then
			self.controllers.c1:setSelectedIndex(2)
			self:setOccInfo(mapInstance.occupy)
		else
			self.controllers.c1:setSelectedIndex(0)
		end
		self.Node_first:setVisible(mapInstance.npc and true or false)
	elseif self.status == gKingdomWarStatusType.rule then
		self.icon_status:setVisible(true)
		self.icon_status:setURL("icon_ldjd_baohu.png")
		self.Text_time:beginTime(mapInstance.warStatusEndTime - serviceFunctions.systemTime())
		self.Text_time:setVisible(true)
		if mapInstance.occupy and 0 < mapInstance.occupy.aid then
			self.controllers.c1:setSelectedIndex(1)
			if self.flagNode then
				self.flagNode:removeFromParent()
			end
			local flagNode = SoraDGetAllianceFlagByFid(mapInstance.occupy.flag)
			flagNode:addTo(self.Node_alliance)
			self.flagNode = flagNode
			self.Button_aflag:setTag(mapInstance.occupy.aid)
			_ENV = cc.size(220, 50)
			cc.size(220, 50).abbr = mapInstance.occupy.abbr
			cc.size(220, 50).name = mapInstance.occupy.aName
			self.Text_alliName:setString(i18n("common_text_186", cc.size(220, 50)))
		else
			self.controllers.c1:setSelectedIndex(0)
		end
		self.Node_first:setVisible(mapInstance.npc and true or false)
	end
	self:setAttr()
end
function WorldStrongPointPanel:setOccInfo(data)
	local ccs_head = self.fields.Com_head
	local Text_name = self.fields.Text_name
	local Node_allianceFlag = self.fields.Node_allianceFlag
	Node_allianceFlag:addClickListener(handler(self, self.btnFlagClick))
	local Text_alliAbbr = self.fields.Text_alliAbbr
	local Text_occTime = SoraDCreateTimerLabel(self, self.fields.Text_occTime)
	local Text_armyNum = self.fields.Text_armyNum
	ccs_head:setPlayerID(data.uid)
	ccs_head:setHeadSprite(data.iconID, data.avatar)
	_ENV = handler(self, self.btnFlagClick)
	handler(self, self.btnFlagClick).abbr = data.abbr
	handler(self, self.btnFlagClick).name = data.name
	Text_name:setString(i18n("common_text_186", handler(self, self.btnFlagClick)))
	local flag = allianceDesRead.getFlagIcon(data.flag)
	Node_allianceFlag:setURL(flag)
	Node_allianceFlag:setTag(data.aid)
	Text_alliAbbr:setString(data.aName)
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
		self.Node_army:setVisible(0 < curArmyCount)
	else
		self.Node_army:setVisible(false)
	end
end
function WorldStrongPointPanel:setAttr()
	local bType = allianceStrongholdMineRead.getGateBuffType(self.objId)
	self.buffList = allianceStrongholdMineRead.getBuffByType(bType)
	self.fields.List_attr:setNumItems(#self.buffList)
end
function WorldStrongPointPanel:btnFlagClick(EventContext)
	SoraDPlaySound()
	local button = EventContext:getSender()
	_ENV = nil
	_ENV, (nil).aid = button:getTag(), button:getTag()
	button:getTag().from = "WorldStrongPointPanel"
	allianceQuery:reqAllianceByID(nil, (button:getTag()))
end
function WorldStrongPointPanel:btnFirstClick()
	SoraDPlaySound()
	print("打开首占奖励")
	local award = allianceStrongholdMineRead.getFirstRewards(self.objId)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local rewards = serviceFunctions.tableFormat(award, nil)
	_ENV = "count"
	;("count").rewards = rewards
	uiManager:show("WorldStrongPointFirstAward", "count")
end
function WorldStrongPointPanel:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "WorldStrongPointPanel" then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
function WorldStrongPointPanel:btnHelpClick()
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
function WorldStrongPointPanel:onItemRenderer(index, obj)
	local k = index + 1
	local v = self.buffList[k]
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	_fields.Image_pbg:setVisible(k % 2 == 1)
	_fields.Text_attrName:setString(v.des)
	_fields.Text_attrVal:setString(v.val)
end
return WorldStrongPointPanel
