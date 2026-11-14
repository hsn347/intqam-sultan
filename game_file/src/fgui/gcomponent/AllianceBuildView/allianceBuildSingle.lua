local allianceDesRead = include("allianceDesRead")
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local baseComponent = require("fgui.base.baseComponent")
local allianceBuildSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceBuildView/allianceBuildSingle", allianceBuildSingle)
function allianceBuildSingle:onInit()
	self.tableSingleData, _ENV = nil, nil
	self.scroll = nil
	self.singleIsMoved = false
	self.Sprite_build = self.fields.Sprite_build
	self.Node_des = self.fields.Node_des
	self.labelDes = self.fields.Text_des
	self.btnInfo = self.fields.Button_info
	self.btnBuild = self.fields.Button_build
	self.btnBuild:setTitleText(i18n("common_text_2132"))
	self.Node_ing = self.fields.Node_ing
	self.Text_ing = self.fields.Text_ing
	self.Text_ing:setString(i18n("common_text_043"))
	self.Text_bTime = SoraDCreateTimerLabel(self, self.fields.Text_bTime)
	self.btnJump = self.fields.Text_jump
	self.labelJump = self.fields.Text_jump
	self.labelCollect = self.fields.Text_blood
	self.btnJump:addClickListener(handler(self, self.btnClickCallBack))
	self.btnBuild:addClickListener(handler(self, self.btnClickCallBack))
	self.btnInfo:addClickListener(handler(self, self.btnClickCallBack))
end
function allianceBuildSingle:onShow()
end
function allianceBuildSingle:hiddleAll()
	self.labelCollect:setVisible(false)
	self.btnJump:setVisible(false)
	self.btnBuild:setVisible(false)
	self.Node_des:setVisible(false)
	self.btnInfo:setVisible(false)
	self.Node_ing:setVisible(false)
end
function allianceBuildSingle:setGray(isGray, isTrue)
	if isTrue then
		if isGray then
			self.Sprite_build:setGrayed(true)
		else
			self.Sprite_build:setGrayed(false)
		end
	else
		self.Sprite_build:setColor(isGray and cc.c3b(160, 160, 160) or cc.c3b(255, 255, 255))
	end
end
function allianceBuildSingle:setScroll(scroll)
	self.scroll = scroll
end
function allianceBuildSingle:initData(buildData)
	self.tableSingleData = buildData
	self:hiddleAll()
	self:showPublic()
	self:showState()
end
function allianceBuildSingle:showPublic()
	self.fields.Sprite_build:setURL(allianceDesRead.getBuildIcon(self.tableSingleData:getBID()))
	self.fields.Text_name:setString(allianceDesRead.getBuildName(self.tableSingleData:getBID()))
end
function allianceBuildSingle:showState()
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
	self.fields.buildingSp:setVisible(state == gAllianceBuildingStatus.BUILD or state == gAllianceBuildingStatus.BUILDING)
end
function allianceBuildSingle:showLock()
	self:setGray(true)
	self.Node_des:setVisible(true)
	self.btnInfo:setVisible(true)
	self.labelDes:setString(i18n("common_text_699"))
	self.labelDes:setColor(cc.c3b(255, 255, 255))
end
function allianceBuildSingle:showUnBuild()
	self:setGray(true, true)
	self.Node_des:setVisible(true)
	self.btnInfo:setVisible(true)
	self.labelDes:setString(i18n("common_text_2150"))
	self.labelDes:setColor(cc.c3b(255, 255, 255))
end
function allianceBuildSingle:showCanBuild()
	self.Node_des:setVisible(false)
	self.btnBuild:setVisible(true)
	self.labelDes:setString(i18n("common_text_2131"))
	self.labelDes:setColor(cc.c3b(255, 255, 255))
end
function allianceBuildSingle:showBuilding()
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
	local posStr = i18n("common_text_2155", cc.c3b(190, 175, 135))
	_ENV = cc.c3b(190, 175, 135)
	cc.c3b(190, 175, 135).u = true
	self.labelJump:setString(SoraDWrapHtmlTagByStyle(posStr, cc.c3b(190, 175, 135)))
	if self.tableSingleData.property.mapData.buildSpeed > 0 then
		self.Text_ing:setString(i18n("common_text_043"))
		self.Text_bTime:beginTime(math.ceil(self.tableSingleData.property.mapData.finishTime) - serviceFunctions.systemTime())
		self.Text_ing:setColor(cc.c3b(133, 248, 83))
	else
		self.Text_ing:setString(i18n("common_text_2139"))
		self.Text_ing:setColor(cc.c3b(249, 62, 62))
	end
end
function allianceBuildSingle:showCollect()
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
	kingdomMapCtrl = false
	;(false).x = self.tableSingleData:getPos().x
	;(false).y = self.tableSingleData:getPos().y
	local posStr = i18n("common_text_2155", false)
	kingdomMapCtrl = i18n("rides_text_09")
	i18n("rides_text_09").u = true
	self.labelJump:setString(SoraDWrapHtmlTagByStyle(posStr, i18n("rides_text_09")))
	if collectData.num == 0 then
		self.labelCollect:setString(i18n("common_text_2224"))
	else
		self.labelCollect:setString(i18n("common_text_830"))
	end
end
function allianceBuildSingle:btnClickCallBack(EventContext)
	SoraDPlaySound()
	local button = EventContext:getSender()
	if button == self.btnJump then
		SoraDGotoWorldMapPoint(self.tableSingleData:getPos(), true)
		SoraDRemoveAllPrePanelFromManager(self)
	elseif button == self.btnBuild then
		local havePoint = allianceMgr:getAllianceProperty("bonus")
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local ownmember = memberMgr:getOwnMember()
		local ownRank = ownmember:getProperty("rank")
		if ownRank < gAllianceRank.R4 then
			SoraDShowMsgTip(i18n("common_text_203"), "#icon_alliance_R4.png")
		elseif havePoint < self.tableSingleData:getNeedBonus() then
			SoraDShowMsgBox(i18n("common_text_273"), i18n("common_text_1684"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					if GLOBAL_GAME_ALLIANCE_MODE then
						uiManager:show("AllianceScience")
					else
						SoraDCreatePanel("allianceScienceView"):show()
					end
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
			_ENV = SoraDRemoveAllPrePanelFromManager
			SoraDRemoveAllPrePanelFromManager.buildSingle = self.tableSingleData
			uiManager:show("AllianceBuildCondition", SoraDRemoveAllPrePanelFromManager)
		elseif state == gAllianceBuildingStatus.UNSET then
			SoraDShowMsgTip(i18n("common_text_2181"))
		end
	end
end
function allianceBuildSingle:gotoWorldMapPos()
	local _ENV, pos
	local proxy = uiManager:getProxy("AllianceBuildView")
	if proxy then
		pos = proxy:getParam().buildMovePos
	end
	local jumpPos = allianceMgr:getLeaderPos()
	if jumpPos == nil or jumpPos.x == -1 and jumpPos.y == -1 then
		SoraDShowMsgTip(i18n("common_text_2173"))
		return
	end
	jumpPos = table.nums(pos) > 0 and pos or jumpPos
	_ENV = i18n("common_text_2173")
	i18n("common_text_2173").allianceResourceBid = self.tableSingleData:getBID()
	i18n("common_text_2173").allianceResourceIiD = self.tableSingleData:getIID()
	SoraDGotoWorldMapPoint(jumpPos, false, nil, worldMapLayInstanceTypeDef.layInstanceAllianceResource, i18n("common_text_2173"))
end
return allianceBuildSingle
