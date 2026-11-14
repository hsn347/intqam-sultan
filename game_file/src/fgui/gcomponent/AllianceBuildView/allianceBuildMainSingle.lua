local allianceDesRead = include("allianceDesRead")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local allianceBuildMainSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceBuildView/allianceBuildMainSingle", allianceBuildMainSingle)
function allianceBuildMainSingle:onInit()
	self.tableSingleData, _ENV = nil, nil
	self.timer = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.curState = gAllianceBuildingStatus.NONE
	self.Node_flag = self.fields.Node_flag
	self.Node_flag:setVisible(false)
	self.btnBuild = self.fields.Button_build
	self.btnBuild:setTitleText(i18n("common_text_2132"))
	self.Text_blood = self.fields.Text_blood
	self.Text_ing = self.fields.Text_ing
	self.Text_bTime = SoraDCreateTimerLabel(self, self.fields.Text_bTime)
	self.Text_jump = self.fields.Text_jump
	self.Text_jump:addClickListener(handler(self, self.btnClickCallBack))
	self.btnBuild:addClickListener(handler(self, self.btnClickCallBack))
	self.btnCold = self.fields.Button_cold
	self.btnCold:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Button_buildInfo:addClickListener(handler(self, self.btnClickCallBack))
end
function allianceBuildMainSingle:onShow()
end
function allianceBuildMainSingle:initData(data)
	self.tableSingleData = data
	if self.tableSingleData.update then
		self.tableSingleData:update()
	end
	self.curState = self.tableSingleData.status
	dump(self.tableSingleData, "self.tableSingleData======", 10)
	self:hiddleAll()
	_ENV = nil
	;(nil).member = string.formatnumberthousands(self.tableSingleData.currentHP)
	;(nil).total = string.formatnumberthousands(self.tableSingleData.HPMax or self.tableSingleData.HP)
	self.Text_blood:setString(i18n("common_text_2996") .. i18n("common_text_155", nil))
	self:setGray(false)
	if self.curState == gAllianceBuildingStatus.NONE then
		self:showBuild()
		self.Text_blood:setString("")
	elseif self.curState == gAllianceBuildingStatus.BUILDING then
		self:setGray(true)
		self.fields.Node_ing:setVisible(true)
		self.Text_blood:setString("")
		if self.tableSingleData.buildingData then
			local surplusPoint = self.tableSingleData.buildingData.surplusPoint
			local totalPoint = self.tableSingleData.buildingData.totalPoint
			local buildSpeed = self.tableSingleData.buildingData.buildSpeed
			if self.tableSingleData.buildingData.buildSpeed == 0 then
				self.Text_ing:setString(i18n("common_text_2139"))
				_ENV = i18n("common_text_2139")
				i18n("common_text_2139").var = string.formatnumberthousands(math.floor(totalPoint - surplusPoint))
				i18n("common_text_2139").var1 = string.formatnumberthousands(totalPoint)
				self.Text_bTime:setString(i18n("alliance_stronghold_text_019", i18n("common_text_2139")))
				self.Text_ing:setColor(cc.c3b(249, 62, 62))
				self.Text_bTime:setColor(cc.c3b(249, 62, 62))
			else
				self.Text_ing:setString(i18n("common_text_043"))
				do
					local leftTime = self.tableSingleData.buildingData.buildFinishTime - serviceFunctions.systemTime()
					self.Text_bTime:beginTime(leftTime)
					_ENV = i18n("common_text_043")
					i18n("common_text_043").var = string.formatnumberthousands(math.max(0, math.floor(totalPoint - leftTime * buildSpeed)))
					i18n("common_text_043").var1 = string.formatnumberthousands(totalPoint)
					self.Text_blood:setString(i18n("alliance_stronghold_text_019", i18n("common_text_043")))
					self.Text_bTime:setTimeUpdateListener(function(time)
						self = nil
						;(nil).var = string.formatnumberthousands(math.max(0, math.floor(totalPoint - time * buildSpeed)))
						;(nil).var1 = string.formatnumberthousands(totalPoint)
						self.Text_blood:setString(i18n("alliance_stronghold_text_019", nil))
					end)
					self.Text_ing:setColor(cc.c3b(133, 248, 83))
					self.Text_bTime:setColor(cc.c3b(133, 248, 83))
				end
			end
		end
		self:showNoraml()
	elseif self.curState == gAllianceBuildingStatus.DESTROY then
		self:showGray()
		self.Text_blood:setString("")
	else
		self:showNoraml()
	end
	self.fields.buildingSp:setVisible(self.curState == gAllianceBuildingStatus.BUILDING)
	self.fields.Text_name:setString(allianceDesRead.getBuildName(self.tableSingleData.bid))
	self.fields.Sprite_build:setURL(allianceDesRead.getBuildIcon(self.tableSingleData.bid))
	self.Node_flag:setVisible(self.tableSingleData.bid == gAllianceBuilding.FLAG)
	if gAllianceBuilding.FLAG == self.tableSingleData.bid then
		local flag = SoraDGetAllianceFlagByFid(allianceMgr:getAllianceInfo().flag)
		flag:addTo(self.Node_flag:displayObject())
	end
	if gAllianceBuilding.ALTAR == self.tableSingleData.bid then
		self.Text_blood:setString("")
	end
end
function allianceBuildMainSingle:setGray(isGray)
	self.fields.Sprite_build:setColor(isGray and cc.c3b(160, 160, 160) or cc.c3b(255, 255, 255))
end
function allianceBuildMainSingle:openTimeUp()
	if self.tableSingleData.update then
		self.tableSingleData:update()
	end
	if self.curState ~= self.tableSingleData.status then
		self:initData(self.tableSingleData)
	elseif self.curState == gAllianceBuildingStatus.BURNING then
		_ENV = nil
		;(nil).member = string.formatnumberthousands(self.tableSingleData.currentHP)
		;(nil).total = string.formatnumberthousands(self.tableSingleData.HPMax or self.tableSingleData.HP)
		self.Text_blood:setString(i18n("common_text_2996") .. i18n("common_text_155", nil))
	elseif self.curState == gAllianceBuildingStatus.RECOVERING then
		_ENV = nil
		;(nil).member = string.formatnumberthousands(self.tableSingleData.currentHP)
		;(nil).total = string.formatnumberthousands(self.tableSingleData.HPMax or self.tableSingleData.HP)
		self.Text_blood:setString(i18n("common_text_2996") .. i18n("common_text_155", nil))
	elseif self.curState == gAllianceBuildingStatus.DESTROY then
		self.fields.Label_timer:setString(SoraDConvertSecondToString(self.tableSingleData.remainCDTime))
		if self.tableSingleData.remainCDTime and self.tableSingleData.remainCDTime <= 0 then
			self:initData(self.tableSingleData)
		end
	end
end
function allianceBuildMainSingle:showBuild()
	self.btnBuild:setVisible(true)
	self.btnBuild:setTitleText(i18n("common_text_042"))
end
function allianceBuildMainSingle:showGray()
	if self.tableSingleData.remainCDTime and self.tableSingleData.remainCDTime > 0 then
		self.fields.Node_cold:setVisible(true)
		if self.timer == nil then
			self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
		end
		self:openTimeUp()
	else
		self.btnBuild:setVisible(true)
		self.btnBuild:setTitleText(i18n("common_text_798"))
	end
end
function allianceBuildMainSingle:showNoraml()
	local posStr
	if gAllianceBuilding.FLAG == self.tableSingleData.bid then
		_ENV = nil
		;(nil).x = self.tableSingleData.pos.x - 1
		;(nil).y = self.tableSingleData.pos.y - 1
		posStr = i18n("common_text_2155", nil)
	else
		_ENV = nil
		;(nil).x = self.tableSingleData.pos.x
		;(nil).y = self.tableSingleData.pos.y
		posStr = i18n("common_text_2155", nil)
	end
	_ENV = nil
	;(nil).u = true
	self.Text_jump:setString(SoraDWrapHtmlTagByStyle(posStr, nil))
	if self.curState ~= gAllianceBuildingStatus.PERFECT then
		if self.timer == nil then
			self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
		end
		self:openTimeUp()
	else
		self:hiddleAll()
	end
	self.Text_jump:setVisible(true)
end
function allianceBuildMainSingle:hiddleAll()
	self.fields.Node_cold:setVisible(false)
	self.Text_jump:setVisible(false)
	self.btnBuild:setVisible(false)
	self.fields.Node_ing:setVisible(false)
	self.Text_bTime:endTime()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function allianceBuildMainSingle:setScroll(scroll)
	self.scroll = scroll
end
function allianceBuildMainSingle:btnClickCallBack(EventContext)
	SoraDPlaySound()
	local button = EventContext:getSender()
	if button == self.Text_jump then
		if gAllianceBuilding.FLAG == self.tableSingleData.bid then
			SoraDGotoWorldMapPoint(cc.p(self.tableSingleData.pos.x - 1, self.tableSingleData.pos.y - 1), true)
		else
			SoraDGotoWorldMapPoint(self.tableSingleData.pos, true)
		end
		SoraDRemoveAllPrePanelFromManager(self)
	elseif button == self.btnBuild then
		local isHasPriPalace = false
		if allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.PRIMARY_PALACE) then
			isHasPriPalace = true
		end
		if gAllianceBuilding.ALTAR == self.tableSingleData.bid and not allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.PALACE) and not isHasPriPalace then
			SoraDShowMsgTip(i18n("common_text_3065"))
			return
		end
		if gAllianceBuilding.PRIMARY_PALACE == self.tableSingleData.bid and not allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.PALACE) then
			SoraDShowMsgTip(i18n("alliance_stronghold_text_025"))
			return
		end
		if gAllianceBuilding.FLAG == self.tableSingleData.bid and not allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.PALACE) and not isHasPriPalace then
			SoraDShowMsgTip(i18n("common_text_3065"))
			return
		end
		local memberMgr = SoraDGetCtrl("memberMgr")
		local ownmember = memberMgr:getOwnMember()
		local ownRank = ownmember:getProperty("rank")
		if not allianceBuildingltCtrl:canRankMemberCreate(self.tableSingleData.bid, ownRank, 1) then
			local needRank = allianceBuildingltCtrl:getRankMemberCreate(self.tableSingleData.bid, 1)
			local showIcon = allianceDesRead.getIcon(needRank, true)
			SoraDShowMsgTip(i18n("common_text_203"), showIcon)
		else
			local pos
			if gAllianceBuilding.ALTAR == self.tableSingleData.bid then
				local jumpPos = allianceMgr:getLeaderPos()
				if jumpPos == nil or jumpPos.x == -1 and jumpPos.y == -1 then
					pos = nil
				else
					pos = jumpPos
				end
			else
				local proxy = uiManager:getProxy("AllianceBuildView")
				if proxy then
					pos = proxy:getParam().buildMovePos
				end
				if table.nums(pos) <= 0 then
					local currentScene = display.getRunningScene()
					if currentScene.name == "MainScene" then
						local currentView = currentScene:currentSceneShowView()
						if currentView.__cname == "worldMapView" then
							pos = currentView:getDisplayCenterTilePoint()
						else
							local jumpPos = allianceMgr:getLeaderPos()
							if jumpPos == nil or jumpPos.x == -1 and jumpPos.y == -1 then
								SoraDShowMsgTip(i18n("common_text_2173"))
								return
							end
							pos = jumpPos
						end
					end
				end
			end
			_ENV = i18n("common_text_2173")
			i18n("common_text_2173").buildClassID = self.tableSingleData.bid
			SoraDGotoWorldMapPoint(pos, false, nil, worldMapLayInstanceTypeDef.layInstanceAllianceManor, i18n("common_text_2173"))
			SoraDRemoveAllPrePanelFromManager(self)
		end
	elseif button == self.btnCold then
		if self.timer and self.tableSingleData.remainCDTime then
			SoraDShowMsgTip(i18n("common_text_2999") .. SoraDConvertSecondToString(self.tableSingleData.remainCDTime))
		end
	elseif button == self.fields.Button_buildInfo then
		_ENV = self.tableSingleData.remainCDTime
		self.tableSingleData.remainCDTime.data = self.tableSingleData
		uiManager:show("AllianceBuildMainInfo", self.tableSingleData.remainCDTime)
	end
end
return allianceBuildMainSingle
