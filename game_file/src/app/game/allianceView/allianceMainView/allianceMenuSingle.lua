local gametop = gModuleMgr.getObject("gametop")
local AllianceMenuSingle = class("allianceMenuSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceMenuSingle")
	end
	return target
end)
function AllianceMenuSingle:ctor()
	self.singleType, _ENV = nil, nil
	self.handle = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.logTimeSingle = nil
	self.logSingle = nil
	self.nodeTouch = SoraDGetChildByName(self, "Panel_touch")
	self.nodeTouch:setSwallowTouches(false)
	self.spriteIcon = SoraDGetChildByName(self, "frame_alliance_menu")
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.spriteGreen = SoraDGetChildByName(self, "Sprite_green")
	self.spriteGreen:setVisible(false)
	self.labelNum = SoraDGetChildByName(self, "Text_num")
	self.Node_active = SoraDGetChildByName(self, "Node_active")
	self.Node_active:setVisible(false)
	self.nodeNormal = SoraDGetChildByName(self, "Node_normal")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Node_time:setVisible(false)
	if self.nodeTouch then
		self.nodeTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.greenPointUpdate))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE_BYTYPE", handler(self, self.greenPointUpdateByType))
end
function AllianceMenuSingle:setActiveLevel()
	local allianceActiveCtrl = gametop.playertop_:getModule("allianceActiveCtrl")
	self.Node_active:setVisible(true)
	gametop = nil
	;(nil).lv = allianceActiveCtrl:getActiveLevel()
	self.labelDes:setString(i18n("common_text_2567", nil))
end
function AllianceMenuSingle:setCoolingStatus()
	local allianceActiveCtrl = gametop.playertop_:getModule("allianceActiveCtrl")
	local time = allianceActiveCtrl:getJoinAllianceTime()
	local isInWar = worldMapDefine.isInKingdomBattle() or worldMapDefine.isInWar()
	if time then
		self.Node_time:setVisible(true)
		self.Text_time:beginTime(time)
		SoraDToCenter(self.Node_time)
		self:setBright(false)
	else
		self:setBright(not isInWar)
	end
end
function AllianceMenuSingle:greenPointUpdateByType(target, data)
	if self.singleType == data.type then
		self:greenPointUpdate()
	end
end
function AllianceMenuSingle:greenPointUpdate(target, data)
	if self.singleType == ALLIANCE_MAIN_MENU_TYPE.HELP and data.type == GREEN_POINT_NOTICE_TYPE.ALLIANCE_HELP then
		local allianceHelp = gametop.playertop_:getModule("allianceHelp")
		local helpCount = #allianceHelp:getHelpList().otherhelplist
		self.spriteGreen:setVisible(0 < helpCount)
		self.labelNum:setString(tostring(helpCount))
	elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.BATTLE and data.type == GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR then
		local queueCtrl = gametop.playertop_:getModule("queueCtrl")
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		local allianceCount = kingdomMapCtrl:getHallWarCount()
		self.spriteGreen:setVisible(0 < allianceCount)
		self.labelNum:setString(tostring(allianceCount))
	elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.BUILD and data.type == GREEN_POINT_NOTICE_TYPE.ALLIANCE_BUILD then
		local allianceTerritoryAPI = include("allianceTerritoryAPI")
		local buildCount = allianceTerritoryAPI:getWellDestroyBuildingNum()
		self.spriteGreen:setVisible(0 < buildCount)
		self.labelNum:setString(tostring(buildCount))
		local isHaveBuidingInConstruction = allianceTerritoryAPI:getIsHaveBuidingInConstruction()
		_ENV = allianceTerritoryAPI
		allianceTerritoryAPI.name = "building"
		local allianceTerritoryAPI.isShow, iconData = isHaveBuidingInConstruction, allianceTerritoryAPI
		self:updateStatusIcon(iconData)
	elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.STRONGPOINT then
	elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.SCIENCE then
		local rewardsCount = SoraDGetCtrl("allianceScience"):getProsperityRewardsCount()
		self.spriteGreen:setVisible(0 < rewardsCount)
	elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.STOREHOUSE then
		local allianceTreasureCtrl = gametop.playertop_:getModule("allianceTreasureCtrl")
		local mineNum = allianceTreasureCtrl:getDigRewardCount()
		local helpNum = allianceTreasureCtrl:getHelpRewardCount()
		self.spriteGreen:setVisible(0 < mineNum + helpNum)
		self.labelNum:setString(tostring(mineNum + helpNum))
	elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.ALLIANCE_TASK and data.type == GREEN_POINT_NOTICE_TYPE.ALLIANCE_TASK then
		local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
		local hasActived = playerMobilizationCtrl:isHaveActived()
		self.spriteGreen:setVisible(1 <= hasActived)
		self.labelNum:setString(tostring(hasActived))
	elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.HUNT and data.type == GREEN_POINT_NOTICE_TYPE.HUNT then
		local allianceHuntCtrl = gametop.playertop_:getModule("allianceHuntCtrl")
		local hasActived = allianceHuntCtrl:getCheckChanllengeTimes()
		self.spriteGreen:setVisible(1 <= hasActived)
		self.labelNum:setString(tostring(hasActived))
	elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.PET then
	elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.COUNTER_SYS and data.type == GREEN_POINT_NOTICE_TYPE.COUNTER_SYS then
		local allianceCounterSysCtrl = gametop.playertop_:getModule("allianceCounterSysCtrl")
		local newPoint = allianceCounterSysCtrl:getNewPoint()
		self.spriteGreen:setVisible(0 < newPoint)
		self.labelNum:setString(tostring(newPoint))
		_ENV = tostring(newPoint)
		tostring(newPoint).num = table.nums(allianceCounterSysCtrl.allianceListData)
		self.labelDes:setString(i18n("CounterSystem_text_13", tostring(newPoint)))
	elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.ACTIVE then
		self:setActiveLevel()
		self:setCoolingStatus()
		_ENV = self.labelDes.setString
		self.labelDes.setString.byUID = true
		local ret = SoraDConfigGet("Game:allianceActiveView:weakPoint~bool", self.labelDes.setString)
		if not ret then
			local isInWar = worldMapDefine.isInKingdomBattle() or worldMapDefine.isInWar()
			self.spriteGreen:setVisible(not isInWar)
			self.labelNum:setString("")
		else
			local allianceActiveCtrl = gametop.playertop_:getModule("allianceActiveCtrl")
			local receiveNum = allianceActiveCtrl:getCanReceiveTaskNum()
			self.spriteGreen:setVisible(0 < receiveNum)
			self.labelNum:setString(tostring(receiveNum))
		end
	end
end
function AllianceMenuSingle:initData(type)
	self.singleType = type
	if self.singleType == ALLIANCE_MAIN_MENU_TYPE.LOG then
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local alliacnePoint = allianceMgr:getAlliance()
		self.nodeNormal:setVisible(false)
		if not self.logSingle then
			self.logSingle = SoraDCreatePanel("allianceLogSingle")
			self.logSingle:addTo(self.nodeTouch)
		end
		_ENV, _ENV, _ENV = nil, nil, self.nodeTouch
		;(nil).data, (nil).content = nil, alliacnePoint:getProperty("notice")
		self.nodeTouch.log, (nil).tp = nil, gALogType.NOTICE
		self.logSingle:initData(self.nodeTouch)
		if not self.logTimeSingle then
			self.logTimeSingle = SoraDCreatePanel("allianceLogTimeSingle")
			self.logTimeSingle:addTo(self.nodeTouch)
		end
		_ENV = self.nodeTouch
		self.nodeTouch.time = os.date("%Y-%m-%d %H:%M", serviceFunctions.systemTime())
		self.logTimeSingle:initData(self.nodeTouch)
		local panelH = math.min(self.logSingle:getSingleH() + self.logTimeSingle:getSingleH(), 100)
		self.nodeTouch:setContentSize(cc.size(640, panelH))
		self.logTimeSingle:setPosition(cc.p(320, panelH))
		self.logSingle:setPosition(cc.p(320, panelH - self.logTimeSingle:getSingleH()))
	else
		local frameName = ""
		self.Node_active:setVisible(false)
		self.labelDes:setVisible(false)
		if self.singleType == ALLIANCE_MAIN_MENU_TYPE.BATTLE then
			self.labelTitle:setString(i18n("common_text_047"))
			_ENV = i18n("common_text_047")
			i18n("common_text_047").type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR
			self:greenPointUpdate(nil, i18n("common_text_047"))
			frameName = "btn_alliance_war.png"
		elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.SCIENCE then
			self.labelTitle:setString(i18n("common_text_191"))
			frameName = "btn_alliance_donate.png"
			self:greenPointUpdate()
		elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.STORE then
			self.labelTitle:setString(i18n("common_text_192"))
			frameName = "btn_alliance_shop.png"
		elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.HELP then
			self.labelTitle:setString(i18n("common_text_193"))
			_ENV = i18n("common_text_193")
			i18n("common_text_193").type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_HELP
			self:greenPointUpdate(nil, i18n("common_text_193"))
			frameName = "btn_alliance_help.png"
		elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.MESSAGE then
			self.labelTitle:setString(i18n("common_text_181"))
			frameName = "btn_alliance_message.png"
		elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.BUILD then
			self.labelTitle:setString(i18n("alliance_stronghold_text_001"))
			_ENV = i18n("alliance_stronghold_text_001")
			i18n("alliance_stronghold_text_001").type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_BUILD
			self:greenPointUpdate(nil, i18n("alliance_stronghold_text_001"))
			frameName = "btn_alliance_build.png"
		elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.STRONGPOINT then
			self.labelTitle:setString(i18n("alliance_stronghold_text_100"))
			frameName = "btn_alliance_lianemgn.png"
		elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.STOREHOUSE then
			self.labelTitle:setString(i18n("allitreas_title_01"))
			_ENV = i18n("allitreas_title_01")
			i18n("allitreas_title_01").type = GREEN_POINT_NOTICE_TYPE.STOREHOUSE
			self:greenPointUpdate(nil, i18n("allitreas_title_01"))
			frameName = "btn_alliance_box.png"
		elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.ALLIANCE_TASK then
			self.labelTitle:setString(i18n("mail_text_417"))
			_ENV = i18n("mail_text_417")
			i18n("mail_text_417").type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_TASK
			self:greenPointUpdate(nil, i18n("mail_text_417"))
			frameName = "btn_alliance_mobilization.png"
		elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.HUNT then
			self.labelTitle:setString(i18n("alliance_hunt_btn_02"))
			_ENV = i18n("alliance_hunt_btn_02")
			i18n("alliance_hunt_btn_02").type = GREEN_POINT_NOTICE_TYPE.HUNT
			self:greenPointUpdate(nil, i18n("alliance_hunt_btn_02"))
			frameName = "btn_alliance_hunt.png"
		elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.PET then
			self.labelTitle:setString(i18n("alliance_beast_text_31"))
			_ENV = i18n("alliance_beast_text_31")
			i18n("alliance_beast_text_31").type = GREEN_POINT_NOTICE_TYPE.PET
			self:greenPointUpdate(nil, i18n("alliance_beast_text_31"))
			frameName = "btn_alliance_altar.png"
		elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.COUNTER_SYS then
			self.labelTitle:setString(i18n("CounterSystem_btn_05"))
			self.labelDes:setVisible(true)
			_ENV = i18n("CounterSystem_btn_05")
			i18n("CounterSystem_btn_05").type = GREEN_POINT_NOTICE_TYPE.COUNTER_SYS
			self:greenPointUpdate(nil, i18n("CounterSystem_btn_05"))
			frameName = "frame_fjxt_lmzy.png"
		elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.ALLIANCE_WAREHOUSE then
			self.labelTitle:setString(i18n("common_text_3012"))
			self.labelDes:setVisible(true)
			_ENV = i18n("common_text_3012")
			i18n("common_text_3012").type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAREHOUSE
			self:greenPointUpdate(nil, i18n("common_text_3012"))
			frameName = "alliancebutton_warehouse.png"
		elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.ACTIVE then
			self.labelDes:setVisible(true)
			self.Node_active:setVisible(true)
			self.labelTitle:setString(i18n("alliance_text_21"))
			_ENV = i18n("alliance_text_21")
			i18n("alliance_text_21").type = GREEN_POINT_NOTICE_TYPE.ACTIVE
			self:greenPointUpdate(nil, i18n("alliance_text_21"))
			frameName = "frame_alliance_active.png"
		end
		self.spriteIcon:setSpriteFrame(frameName)
	end
end
function AllianceMenuSingle:updateLogData(data, isLast)
	if self.singleType == ALLIANCE_MAIN_MENU_TYPE.LOG then
		self.logSingle:initData(data, isLast)
		self.logTimeSingle:initData(data)
		local panelH = math.min(self.logSingle:getSingleH() + self.logTimeSingle:getSingleH(), 100)
		self.nodeTouch:setContentSize(cc.size(640, panelH))
		self.logTimeSingle:setPosition(cc.p(320, panelH))
		self.logSingle:setPosition(cc.p(320, panelH - self.logTimeSingle:getSingleH()))
	end
end
function AllianceMenuSingle:updateStatusIcon(iconData)
	local sprite = self:getChildByName(iconData.name)
	if not sprite and iconData.isShow then
		sprite = SoraDCreatAnimation("chuizigx")
		sprite:setScale(0.6)
		sprite:addTo(self, 2)
		sprite:setPosition(SoraDFIsRA() and 102 or -102, -80)
		sprite:setName(iconData.name)
	elseif sprite then
		sprite:setVisible(iconData.isShow)
	end
end
function AllianceMenuSingle:setBright(ret)
	local Image_1 = SoraDGetChildByName(self, "Image_1")
	Image_1:setColor(ret and cc.c3b(255, 255, 255) or cc.c3b(120, 120, 120))
	self.spriteIcon:setColor(ret and cc.c3b(255, 255, 255) or cc.c3b(120, 120, 120))
	self.labelTitle:setColor(ret and cc.c3b(255, 200, 100) or cc.c3b(100, 80, 40))
	self.labelDes:setColor(ret and cc.c3b(255, 200, 100) or cc.c3b(100, 80, 40))
	if not ret then
		self:setTouchEventCallBack(function()
			if SoraDGetCtrl("conquestWarCtrl"):isHelper() then
				SoraDShowMsgTip(i18n("common_text_3302"))
				return
			end
			if self.singleType == ALLIANCE_MAIN_MENU_TYPE.PET then
				if worldMapDefine.inInCrossWar() then
					SoraDShowMsgTip(i18n("common_text_3302"))
				else
					SoraDShowMsgTip(i18n("common_text_4459"))
				end
			elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.ACTIVE then
				local allianceActiveCtrl = gametop.playertop_:getModule("allianceActiveCtrl")
				local time = allianceActiveCtrl:getJoinAllianceTime()
				if worldMapDefine.inInCrossWar() then
					SoraDShowMsgTip(i18n("common_text_3302"))
				elseif time and 0 < time then
					_ENV = i18n("common_text_3302")
					i18n("common_text_3302").num = ALLIANCE_ACTIVE_JOINALLIANCE_TIME
					SoraDShowMsgTip(i18n("alliance_text_43", i18n("common_text_3302")))
				else
					SoraDShowMsgTip(i18n("common_text_699"))
				end
			elseif self.singleType == ALLIANCE_MAIN_MENU_TYPE.HUNT then
				if worldMapDefine.inInCrossWar() then
					SoraDShowMsgTip(i18n("common_text_3302"))
				else
					SoraDShowMsgTip(i18n("common_text_699"))
				end
			else
				SoraDShowMsgTip(i18n("common_text_699"))
			end
		end)
	end
end
function AllianceMenuSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceMenuSingle:getSingleW()
	return self.nodeTouch:getContentSize().width
end
function AllianceMenuSingle:getSingleH()
	return self.nodeTouch:getContentSize().height
end
function AllianceMenuSingle:setTouchEventCallBack(handle)
	self.handle = handle
end
function AllianceMenuSingle:btnClickCallBack(button, type)
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
		if self.handle then
			self.handle(self.singleType)
			if self.singleType == ALLIANCE_MAIN_MENU_TYPE.ACTIVE then
				_ENV = self.scroll
				self.scroll.byUID = true
				if not SoraDConfigGet("Game:allianceActiveView:weakPoint~bool", self.scroll) then
					_ENV = nil
					;(nil).byUID = true
					SoraDConfigSet("Game:allianceActiveView:weakPoint~bool", true, nil)
					_ENV = nil
					;(nil).type = GREEN_POINT_NOTICE_TYPE.ACTIVE
					self:greenPointUpdate(nil, nil)
				end
			end
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > 5 then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return AllianceMenuSingle
