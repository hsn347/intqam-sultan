local allianceDesRead = include("allianceDesRead")
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local AllianceBuildMainSingle = class("allianceBuildMainSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBuildMainSingle")
	end
	return target
end)
function AllianceBuildMainSingle:ctor()
	self.tableSingleData, _ENV = nil, nil
	self.timer = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.curState = gAllianceBuildingStatus.NONE
	self.Sprite_build = SoraDGetChildByName(self, "Sprite_build")
	self.Node_flag = SoraDGetChildByName(self, "Node_flag")
	self.Node_flag:setVisible(false)
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.btnBuild = SoraDGetChildByName(self, "Button_build")
	self.btnBuild:setTitleText(i18n("common_text_2132"))
	self.Node_des = SoraDGetChildByName(self, "Node_des")
	self.Node_des:setVisible(false)
	self.Text_blood = SoraDGetChildByName(self, "Text_blood")
	self.btnJump = SoraDGetChildByName(self, "Button_jump")
	self.Text_jump = SoraDGetChildByName(self, "Text_jump")
	self.Node_ing = SoraDGetChildByName(self, "Node_ing")
	self.Text_ing = SoraDGetChildByName(self, "Text_ing")
	self.Text_bTime = SoraDGetChildByName(self, "Text_bTime")
	self.Text_bTime = SoraDCreateTimerLabel(self, self.Text_bTime)
	self.btnCold = SoraDGetChildByName(self, "Button_cold")
	self.Node_time = SoraDGetChildByName(self.btnCold, "Node_time")
	self.labelCold = SoraDGetChildByName(self, "Text_time")
	self.btnBuidlInfo = SoraDGetChildByName(self, "Button_buildInfo")
	local sprite = SoraDCreatAnimation("chuizigx")
	sprite:setScale(0.7)
	sprite:addTo(self, 2)
	sprite:setPosition(0, -45)
	sprite:setVisible(false)
	self.buildingSp = sprite
	self.btnJump:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnBuild:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnCold:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnBuidlInfo:addTouchEventListener(handler(self, self.btnClickCallBack))
end
function AllianceBuildMainSingle:initData(data)
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
		self.Node_ing:setVisible(true)
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
	self.buildingSp:setVisible(self.curState == gAllianceBuildingStatus.BUILDING)
	self.Text_name:setString(allianceDesRead.getBuildName(self.tableSingleData.bid))
	self.Sprite_build:setSpriteFrame(allianceDesRead.getBuildIcon(self.tableSingleData.bid))
	self.Node_flag:setVisible(self.tableSingleData.bid == gAllianceBuilding.FLAG)
	if gAllianceBuilding.FLAG == self.tableSingleData.bid then
		local flag = SoraDGetAllianceFlagByFid(allianceMgr:getAllianceInfo().flag)
		flag:addTo(self.Node_flag)
	end
	if gAllianceBuilding.ALTAR == self.tableSingleData.bid then
		self.Text_blood:setString("")
	end
end
function AllianceBuildMainSingle:setGray(isGray)
	self.Sprite_build:setColor(isGray and cc.c3b(160, 160, 160) or cc.c3b(255, 255, 255))
end
function AllianceBuildMainSingle:openTimeUp()
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
		self.labelCold:setString(SoraDConvertSecondToString(self.tableSingleData.remainCDTime))
		SoraDToCenter(self.Node_time)
		if self.tableSingleData.remainCDTime and self.tableSingleData.remainCDTime <= 0 then
			self:initData(self.tableSingleData)
		end
	end
end
function AllianceBuildMainSingle:showBuild()
	self.btnBuild:setVisible(true)
	self.btnBuild:setTitleText(i18n("common_text_042"))
end
function AllianceBuildMainSingle:showGray()
	if self.tableSingleData.remainCDTime and self.tableSingleData.remainCDTime > 0 then
		self.btnCold:setVisible(true)
		if self.timer == nil then
			self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
		end
		self:openTimeUp()
	else
		self.btnBuild:setVisible(true)
		self.btnBuild:setTitleText(i18n("common_text_798"))
	end
end
function AllianceBuildMainSingle:showNoraml()
	if gAllianceBuilding.FLAG == self.tableSingleData.bid then
		_ENV = nil
		;(nil).x = self.tableSingleData.pos.x - 1
		;(nil).y = self.tableSingleData.pos.y - 1
		self.Text_jump:setString(i18n("common_text_2155", nil))
	else
		_ENV = i18n("common_text_2155", nil)
		i18n("common_text_2155", nil).x = self.tableSingleData.pos.x
		i18n("common_text_2155", nil).y = self.tableSingleData.pos.y
		self.Text_jump:setString(i18n("common_text_2155", i18n("common_text_2155", nil)))
	end
	SoraDDrawTextUnderLine(self.Text_jump, cc.c4b(116, 217, 250, 255))
	if self.curState ~= gAllianceBuildingStatus.PERFECT then
		if self.timer == nil then
			self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
		end
		self:openTimeUp()
	else
		self:hiddleAll()
	end
	self.btnJump:setVisible(true)
end
function AllianceBuildMainSingle:hiddleAll()
	self.btnCold:setVisible(false)
	self.btnJump:setVisible(false)
	self.btnBuild:setVisible(false)
	self.Node_ing:setVisible(false)
	self.Text_bTime:endTime()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function AllianceBuildMainSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceBuildMainSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if button == self.btnJump then
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
			local memberMgr = gametop.playertop_:getModule("memberMgr")
			local ownmember = memberMgr:getOwnMember()
			local ownRank = ownmember:getProperty("rank")
			if not allianceBuildingltCtrl:canRankMemberCreate(self.tableSingleData.bid, ownRank, 1) then
				local needRank = allianceBuildingltCtrl:getRankMemberCreate(self.tableSingleData.bid, 1)
				local showIcon = allianceDesRead.getIcon(needRank, true)
				SoraDShowMsgTip(i18n("common_text_203"), showIcon, button)
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
					pos = include("allianceBuildView").getParam().buildMovePos
					if table.nums(pos) <= 0 then
						local currentScene = display.getRunningScene()
						if currentScene.name == "MainScene" then
							local currentView = currentScene:currentSceneShowView()
							if currentView.__cname == "worldMapView" then
								pos = currentView:getDisplayCenterTilePoint()
							else
								local jumpPos = allianceMgr:getLeaderPos()
								if jumpPos == nil or jumpPos.x == -1 and jumpPos.y == -1 then
									SoraDShowMsgTip(i18n("common_text_2173"), nil, button)
									return
								end
								pos = jumpPos
							end
						end
					end
				end
				_ENV = nil
				;(nil).buildClassID = self.tableSingleData.bid
				SoraDGotoWorldMapPoint(pos, false, nil, worldMapLayInstanceTypeDef.layInstanceAllianceManor, nil)
				SoraDRemoveAllPrePanelFromManager(self)
			end
		elseif button == self.btnCold then
			if self.timer and self.tableSingleData.remainCDTime then
				SoraDShowMsgTip(i18n("common_text_2999") .. SoraDConvertSecondToString(self.tableSingleData.remainCDTime))
			end
		elseif button == self.btnBuidlInfo then
			local panel = SoraDCreatePanel("allianceBuildMainInfoView")
			panel:initData(self.tableSingleData)
			panel:show()
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return AllianceBuildMainSingle
