local nodePhb = class("nodePhb", function(target)
	if target == nil then
		return SoraDCreateBasePanel("nodePhb")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
local hegemonRead = include("hegemonRead")
local RANKING_DISPLAY_NUM = _G.RANKING_DISPLAY_NUM
function nodePhb:ctor()
	self.frame_rank = SoraDGetChildByName(self, "frame_rank")
	self.imgBarBg = SoraDGetChildByName(self, "frame_rank_bg")
	self.Node_head = SoraDGetChildByName(self, "Node_head")
	self.spriteIndex = SoraDGetChildByName(self, "Sprite_Rank")
	self.icon_head = SoraDGetChildByName(self, "icon_head")
	self.labelIndex = SoraDGetChildByName(self, "text_my_rank")
	self.Node_info1 = SoraDGetChildByName(self, "Node_info1")
	self.labelTip = SoraDGetChildByName(self, "Text_tips")
	self.labelName1 = SoraDGetChildByName(self, "Text_name_1")
	self.labelNum1 = SoraDGetChildByName(self, "Text_time_1")
	self.labelDate1 = SoraDGetChildByName(self, "Text_date_1")
	SoraDSetTextWidthHeight(self.labelName1, cc.size(250, 80))
	self.Node_info2 = SoraDGetChildByName(self, "Node_info2")
	self.labelName2 = SoraDGetChildByName(self, "Text_name_2")
	self.tableSingleData, _ENV, self.labelNum2 = SoraDGetChildByName(self, "Text_time_2"), SoraDGetChildByName(self, "Text_time_2"), SoraDGetChildByName(self, "Text_time_2")
	self.handle = nil
	self.scroll = nil
	self.singleIsMoved = false
	if self.frame_rank then
		self.frame_rank:setSwallowTouches(false)
		self.frame_rank:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function nodePhb:initData(data, nodeType, buildID, mapid)
	self.buildID = buildID
	self.mapid = mapid
	self.isHegemon = not hegemonRead.isLegendLordBuilding(self.buildID)
	if nodeType == 1 then
		self.Node_info1:setVisible(true)
		self.Node_info2:setVisible(false)
		local posX = self.Node_head:getPositionX()
		if SoraDFIsRA() then
			self.Node_head:setPositionX(posX + 80)
		else
			self.Node_head:setPositionX(posX - 80)
		end
		self:initLegendData(data)
	elseif nodeType == 2 then
		self.Node_info1:setVisible(false)
		self.Node_info2:setVisible(true)
		self:initKingRank(data)
	elseif nodeType == 3 then
		self.Node_info1:setVisible(false)
		self.Node_info2:setVisible(true)
		self:initKingAlliance(data)
	else
		self.Node_info1:setVisible(false)
		self.Node_info2:setVisible(false)
	end
end
function nodePhb:btnClickCallBack(button, type)
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
			self.handle(self.tableSingleData)
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
function nodePhb:setScroll(scroll)
	self.scroll = scroll
end
function nodePhb:setHandle(handle)
	self.handle = handle
end
function nodePhb:initLegendData(data)
	self.tableSingleData = data
	if self.tableSingleData.playerName then
		self.labelTip:setVisible(false)
		local name = self:getLabelName()
		self.labelName1:setVisible(true)
		if self.isHegemon then
			local buildName = hegemonRead.getName(self.buildID)
			hegemonRead = nil
			;(nil).build = buildName
			;(nil).name = name
			self.labelName1:setString(i18n("hegemon_title_04", nil))
		elseif worldMapDefine.isKingStarMapId(self.mapid) then
			hegemonRead = i18n("hegemon_title_04", nil)
			i18n("hegemon_title_04", nil).name = name
			self.labelName1:setString(i18n("kingstarbattle_text_79", i18n("hegemon_title_04", nil)))
		else
			hegemonRead = i18n("kingstarbattle_text_79", i18n("hegemon_title_04", nil))
			i18n("kingstarbattle_text_79", i18n("hegemon_title_04", nil)).name = name
			self.labelName1:setString(i18n("legendaryking_text_07", i18n("kingstarbattle_text_79", i18n("hegemon_title_04", nil))))
		end
		self:setLabelColor(self.labelName1)
		local strTime = SoraDConvertSecondToString(self.tableSingleData.occupySecs)
		self.labelNum1:setString(strTime)
		self.Node_head:setVisible(true)
		self:setDataInfo()
	else
		self.Node_head:setVisible(false)
		self.labelDate1:setVisible(false)
		self.labelName1:setVisible(false)
		self.labelTip:setVisible(true)
		if self.isHegemon then
			self.labelTip:setString(i18n("hegemon_text_35"))
		elseif worldMapDefine.isKingStarMapId(self.mapid) then
			self.labelTip:setString(i18n("kingstarbattle_text_53"))
		else
			self.labelTip:setString(i18n("legendaryking_text_21"))
		end
		if worldMapDefine.isKingStarMapId(self.mapid) then
			self.imgBarBg:setSpriteFrame("frame_alliance_pank_04.png")
		else
			self.imgBarBg:setVisible(false)
		end
	end
	if self.tableSingleData.assumeTime then
		local strDate = SoraDConvertTimeToYear(self.tableSingleData.assumeTime, true)
		self.labelDate1:setVisible(true)
		self.labelDate1:setString(strDate)
	end
end
function nodePhb:initKingAlliance(data)
	self.tableSingleData = data
	if self.tableSingleData.playerName then
		self.labelTip:setVisible(false)
		local name = self:getLabelName()
		self.labelName2:setString(name)
		self.Node_head:setVisible(true)
		self:setDataInfo()
	else
		self.Node_head:setVisible(false)
		self.labelName2:setVisible(false)
	end
	self.labelIndex:setVisible(self.tableSingleData.rank > RANK_TOP_SPECIAL)
	self.spriteIndex:setVisible(self.tableSingleData.rank <= RANK_TOP_SPECIAL)
	self.labelIndex:setString(tostring(self.tableSingleData.rank))
	if self.tableSingleData.rank <= RANK_TOP_SPECIAL then
		self.spriteIndex:setSpriteFrame("icon_ranking_" .. self.tableSingleData.rank .. ".png")
	end
	if self.tableSingleData.killFc then
		self.labelNum2:setVisible(true)
		self.labelNum2:setString(string.formatnumberthousands(self.tableSingleData.killFc))
	end
end
function nodePhb:initKingRank(data)
	self.tableSingleData = data
	local name = self:getLabelName()
	self.labelName2:setString(name)
	self:setLabelColor(self.labelName2)
	local strTime = SoraDConvertSecondToString(self.tableSingleData.occupySecs)
	self.labelNum2:setString(strTime)
	self.labelIndex:setVisible(self.tableSingleData.rank > RANK_TOP_SPECIAL)
	self.spriteIndex:setVisible(self.tableSingleData.rank <= RANK_TOP_SPECIAL)
	self.labelIndex:setString(tostring(self.tableSingleData.rank))
	if self.tableSingleData.rank <= RANK_TOP_SPECIAL then
		self.spriteIndex:setSpriteFrame("icon_ranking_" .. self.tableSingleData.rank .. ".png")
	end
	self:setDataInfo()
end
function nodePhb:setDataInfo()
	SoraDGetHeadFromManager(self.icon_head, self.tableSingleData.headid, self.tableSingleData.avatar)
	self.imgBarBg:setVisible(true)
	local selfID = lordInfoCtrl:getLordInfo().base.uid
	if selfID == self.tableSingleData.uid then
		self.imgBarBg:setSpriteFrame("frame_alliance_pank_05.png")
	elseif self.tableSingleData.rank <= RANK_TOP_SPECIAL then
		self.imgBarBg:setSpriteFrame("frame_alliance_pank_0" .. self.tableSingleData.rank .. ".png")
	else
		self.imgBarBg:setSpriteFrame("frame_alliance_pank_04.png")
	end
end
function nodePhb:setLabelColor(label)
	local selfLeagueID = 0
	if worldMapDefine.isKingStarMapId(self.mapid) then
		selfLeagueID = kingStarTeamCtrl:getTeamID() or 0
	else
		selfLeagueID = legendTeamCtrl:getTeamID() or 0
	end
	local nameColor
	if self.tableSingleData.leagueID and 0 < self.tableSingleData.leagueID and self.tableSingleData.leagueID == selfLeagueID then
		nameColor = worldMapDefine.getLeagueManorLineColor(true)
	else
		nameColor = cc.c3b(200, 170, 150)
	end
	label:setColor(nameColor)
end
function nodePhb:getLabelName()
	local name = self.tableSingleData.playerName or i18n("common_text_480")
	if self.tableSingleData.leagueAbbrName then
		_ENV = nil
		;(nil).abbr = self.tableSingleData.leagueAbbrName
		;(nil).name = self.tableSingleData.playerName
		name = i18n("common_text_186", nil)
	end
	if self.tableSingleData.sourceKid then
		name = name .. "#" .. tostring(self.tableSingleData.sourceKid)
	end
	return name
end
return nodePhb
