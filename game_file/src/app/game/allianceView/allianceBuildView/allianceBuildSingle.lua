local allianceDesRead = include("allianceDesRead")
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local AllianceBuildSingle = class("allianceBuildSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBuildSingle")
	end
	return target
end)
function AllianceBuildSingle:ctor()
	self.tableSingleData, _ENV = nil, nil
	self.scroll = nil
	self.singleIsMoved = false
	self.Sprite_build = SoraDGetChildByName(self, "Sprite_build")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	SoraDGetChildByName(self, "Button_buildInfo"):setVisible(false)
	self.Node_des = SoraDGetChildByName(self, "Node_des")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.btnInfo = SoraDGetChildByName(self, "Button_info")
	self.btnBuild = SoraDGetChildByName(self, "Button_build")
	self.btnBuild:setTitleText(i18n("common_text_2132"))
	self.Node_ing = SoraDGetChildByName(self, "Node_ing")
	self.Text_ing = SoraDGetChildByName(self, "Text_ing")
	self.Text_ing:setString(i18n("common_text_043"))
	self.Text_bTime = SoraDGetChildByName(self, "Text_bTime")
	self.Text_bTime = SoraDCreateTimerLabel(self, self.Text_bTime)
	self.btnJump = SoraDGetChildByName(self, "Button_jump")
	self.labelJump = SoraDGetChildByName(self, "Text_jump")
	self.labelCollect = SoraDGetChildByName(self, "Text_blood")
	self.btnCold = SoraDGetChildByName(self, "Button_cold")
	self.btnCold:setVisible(false)
	local sprite = SoraDCreatAnimation("chuizigx")
	sprite:setScale(0.7)
	sprite:addTo(self, 2)
	sprite:setPosition(0, -45)
	sprite:setVisible(false)
	self.buildingSp = sprite
	self.btnJump:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnBuild:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnInfo:addTouchEventListener(handler(self, self.btnClickCallBack))
end
function AllianceBuildSingle:hiddleAll()
	self.labelCollect:setVisible(false)
	self.btnJump:setVisible(false)
	self.btnBuild:setVisible(false)
	self.Node_des:setVisible(false)
	self.btnInfo:setVisible(false)
	self.Node_ing:setVisible(false)
end
function AllianceBuildSingle:setGray(isGray, isTrue)
	if isTrue then
		if isGray then
			SoraDCreateGraySprite(self.Sprite_build)
		else
			SoraDNormalSprite(self.Sprite_build)
		end
	else
		self.Sprite_build:setColor(isGray and cc.c3b(160, 160, 160) or cc.c3b(255, 255, 255))
	end
end
function AllianceBuildSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceBuildSingle:initData(buildData)
	self.tableSingleData = buildData
	self:hiddleAll()
	self:showPublic()
	self:showState()
end
function AllianceBuildSingle:showPublic()
	self.Sprite_build:setSpriteFrame(allianceDesRead.getBuildIcon(self.tableSingleData:getBID()))
	self.Text_name:setString(allianceDesRead.getBuildName(self.tableSingleData:getBID()))
end
function AllianceBuildSingle:showState()
	local state = self.tableSingleData:getBuildingStatus()
	self:setGray(false)
	if state == gAllianceBuildingStatus.LOCK then
		self:showLock()
	elseif state == gAllianceBuildingStatus.UNSET then
		self:showUnBuild()
	elseif state == gAllianceBuildingStatus.FREE then
		self:showCanBuild()
	elseif state == gAllianceBuildingStatus.BUILD then
		self.Node_ing:setVisible(true)
		self:showBuilding()
	elseif state == gAllianceBuildingStatus.BUILDING then
		self.Node_ing:setVisible(true)
		self:showBuilding()
	elseif state == gAllianceBuildingStatus.COMPLETE then
		self:showCollect()
	end
	self.buildingSp:setVisible(state == gAllianceBuildingStatus.BUILD or state == gAllianceBuildingStatus.BUILDING)
end
function AllianceBuildSingle:showLock()
	self:setGray(true)
	self.Node_des:setVisible(true)
	self.btnInfo:setVisible(true)
	self.labelDes:setString(i18n("common_text_699"))
	self.labelDes:setColor(cc.c3b(255, 255, 255))
end
function AllianceBuildSingle:showUnBuild()
	self:setGray(true, true)
	self.Node_des:setVisible(true)
	self.btnInfo:setVisible(true)
	self.labelDes:setString(i18n("common_text_2150"))
	self.labelDes:setColor(cc.c3b(255, 255, 255))
end
function AllianceBuildSingle:showCanBuild()
	self.Node_des:setVisible(false)
	self.btnBuild:setVisible(true)
	self.labelDes:setString(i18n("common_text_2131"))
	self.labelDes:setColor(cc.c3b(255, 255, 255))
end
function AllianceBuildSingle:showBuilding()
	dump(self.tableSingleData, "self.tableSingleData====")
	self:setGray(true)
	self.labelCollect:setVisible(true)
	self.btnJump:setVisible(true)
	self.Node_des:setVisible(true)
	local curValue, totalValue = self.tableSingleData:getBuildValueInfo()
	_ENV = nil
	_ENV = nil
	;(nil).member = string.formatnumberthousands(curValue)
	;(nil).total = string.formatnumberthousands(totalValue)
	;(nil).point = i18n("common_text_155", nil)
	self.labelDes:setString(i18n("common_text_2140", nil))
	self.labelDes:setColor(cc.c3b(190, 175, 135))
	_ENV = cc.c3b(190, 175, 135)
	cc.c3b(190, 175, 135).x = self.tableSingleData:getPos().x
	cc.c3b(190, 175, 135).y = self.tableSingleData:getPos().y
	self.labelJump:setString(i18n("common_text_2155", cc.c3b(190, 175, 135)))
	SoraDDrawTextUnderLine(self.labelJump, cc.c4b(116, 217, 250, 255))
	if self.tableSingleData.property.mapData.buildSpeed > 0 then
		self.Text_ing:setString(i18n("common_text_043"))
		self.Text_bTime:beginTime(math.ceil(self.tableSingleData.property.mapData.finishTime) - serviceFunctions.systemTime())
		self.Text_ing:setColor(cc.c3b(133, 248, 83))
	else
		self.Text_ing:setString(i18n("common_text_2139"))
		self.Text_ing:setColor(cc.c3b(249, 62, 62))
	end
end
function AllianceBuildSingle:showCollect()
	local collectData = kingdomMapCtrl:getSuperResCollInfo(self.tableSingleData:getIID(), self.tableSingleData:getPos().x, self.tableSingleData:getPos().y)
	local buildTime = self.tableSingleData:getRemainLifeTime()
	self.labelCollect:setVisible(true)
	self.btnJump:setVisible(true)
	self.Node_ing:setVisible(true)
	if self.tableSingleData.property.mapData.buildSpeed > 0 then
		self.Text_ing:setString(i18n("rides_text_09"))
		self.Text_bTime:beginTime(buildTime)
	end
	self.labelDes:setVisible(false)
	kingdomMapCtrl = i18n("rides_text_09")
	i18n("rides_text_09").x = self.tableSingleData:getPos().x
	i18n("rides_text_09").y = self.tableSingleData:getPos().y
	self.labelJump:setString(i18n("common_text_2155", i18n("rides_text_09")))
	SoraDDrawTextUnderLine(self.labelJump, cc.c4b(116, 217, 250, 255))
	if collectData.num == 0 then
		self.labelCollect:setString(i18n("common_text_2224"))
	else
		self.labelCollect:setString(i18n("common_text_830"))
	end
end
function AllianceBuildSingle:btnClickCallBack(button, type)
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
			SoraDGotoWorldMapPoint(self.tableSingleData:getPos(), true)
			SoraDRemoveAllPrePanelFromManager(self)
		elseif button == self.btnBuild then
			local havePoint = allianceMgr:getAllianceProperty("bonus")
			local memberMgr = gametop.playertop_:getModule("memberMgr")
			local ownmember = memberMgr:getOwnMember()
			local ownRank = ownmember:getProperty("rank")
			if ownRank < gAllianceRank.R4 then
				SoraDShowMsgTip(i18n("common_text_203"), "#icon_alliance_R4.png", button)
			elseif havePoint < self.tableSingleData:getNeedBonus() then
				SoraDShowMsgBox(i18n("common_text_273"), i18n("common_text_1684"), nil, function(type)
					if type == MSGBOX_CALLBACK_YES then
						SoraDCreatePanel("allianceScienceView"):show()
					end
				end)
			elseif tonumber(self.tableSingleData:getBID()) == 3725 then
				SoraDShowMsgBox(i18n("alliance_build_text_02"), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
					if eventType == MSGBOX_CALLBACK_YES then
						self:gotoWorldMapPos()
						SoraDRemoveAllPrePanelFromManager(self)
					end
				end)
			else
				self:gotoWorldMapPos()
				SoraDRemoveAllPrePanelFromManager(self)
			end
		elseif button == self.btnInfo then
			local state = self.tableSingleData:getBuildingStatus()
			if state == gAllianceBuildingStatus.LOCK then
				local panel = SoraDCreatePanel("allianceBuildConditionView")
				panel:initData(self.tableSingleData)
				panel:show()
			elseif state == gAllianceBuildingStatus.UNSET then
				SoraDShowMsgTip(i18n("common_text_2181"), nil, button)
			end
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
function AllianceBuildSingle:gotoWorldMapPos()
	local pos = include("allianceBuildView").getParam().buildMovePos
	local jumpPos = allianceMgr:getLeaderPos()
	if jumpPos == nil or jumpPos.x == -1 and jumpPos.y == -1 then
		SoraDShowMsgTip(i18n("common_text_2173"), nil, button)
		return
	end
	jumpPos = table.nums(pos) > 0 and pos or jumpPos
	_ENV = nil
	;(nil).allianceResourceBid = self.tableSingleData:getBID()
	;(nil).allianceResourceIiD = self.tableSingleData:getIID()
	SoraDGotoWorldMapPoint(jumpPos, false, nil, worldMapLayInstanceTypeDef.layInstanceAllianceResource, nil)
end
return AllianceBuildSingle
