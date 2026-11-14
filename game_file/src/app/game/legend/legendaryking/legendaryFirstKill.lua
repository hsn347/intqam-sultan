local gametop = gModuleMgr.getObject("gametop")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local hegemonRead = include("hegemonRead")
local legendaryFirstKill = class("legendaryFirstKill", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("legendaryFirstKill")
	end
	if type(target) == "string" then
		return SoraDCreateTouchPanel(target)
	end
	return target
end)
function legendaryFirstKill:ctor()
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_box_tip = SoraDGetChildByName(self, "Text_box_tip")
	self.Text_box_desc = SoraDGetChildByName(self, "Text_box_desc")
	self.Text_box_name = SoraDGetChildByName(self, "Text_box_name")
	self.Image_Bg_Box = SoraDGetChildByName(self, "Image_Bg_Box")
	self.icon_box = SoraDGetChildByName(self, "icon_box")
	self.Button_Box = SoraDGetChildByName(self, "Button_Box")
	self.Button_RankView = SoraDGetChildByName(self, "Button_RankView")
	self.Button_RankView:addTouchEventListener(handler(self, self.onClick_Button_RankView))
	self.Button_Box:addTouchEventListener(handler(self, self.onClick_Button_Box))
	local text_title = SoraDGetChildByName(self, "Text_title")
	text_title:setString(i18n("common_text_159"))
	self.Text_box_name:setString(i18n("common_text_4241"))
	self.Button_RankView:setTitleFontSize(20)
	self.Button_RankView:setTitleText(i18n("common_text_4232"))
	self.maxOccupyTime = legendLordWarCtrl:getLegendOccupyMaxTime()
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeLast(function(str, tick)
		local curtick = self.maxOccupyTime - tick
		if curtick < 0 then
			curtick = 0
		end
		local strTime = SoraDConvertSecondToString(curtick)
		self = nil
		;(nil).time = strTime
		return i18n("common_text_4248", nil)
	end)
	self.Text_time:setTimeEndListener(function()
		self.Text_time:setVisible(false)
	end)
	self.buildID = 0
	self.maxOccupyTime = 21600
	self.occupier = nil
end
function legendaryFirstKill:init(buildID, mapInstance)
	self.buildID = buildID or 0
	if not mapInstance.occupier then
		legendLordWarCtrl = mapInstance.occupier
	end
	self.occupier = mapInstance.occupier
	self.maxOccupyTime = legendLordWarCtrl:getLegendOccupyMaxTime(self.buildID)
	if not hegemonRead.isLegendLordBuilding(self.buildID) then
		self.Text_box_desc:setString(i18n("hegemon_text_26"))
	elseif worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) then
		self.Text_box_desc:setString(i18n("kingstarbattle_text_65"))
	else
		self.Text_box_desc:setString(i18n("common_text_4249"))
	end
	self:updateInfo()
end
function legendaryFirstKill:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_OCCUPIER_CHANGE", handler(self, self.updateData))
end
function legendaryFirstKill:updateData(target, data)
	if data and data.buildID == self.buildID and data.occupier then
		self.occupier = data.occupier
		self:updateInfo()
	end
end
function legendaryFirstKill:updateInfo()
	local occupier = self.occupier
	local textName = occupier.playerName
	if textName then
		if occupier.leagueID and occupier.leagueID > 0 and occupier.leagueAbbrName then
			_ENV = nil
			;(nil).abbr = occupier.leagueAbbrName
			;(nil).name = occupier.playerName
			textName = i18n("common_text_186", nil)
		end
		if 0 < occupier.sourceKid then
			textName = textName .. "#" .. occupier.sourceKid
		end
		_ENV = nil
		;(nil).name = textName
		self.Text_name:setString(i18n("common_text_4247", nil))
	else
		textName = i18n("common_text_480")
		_ENV = i18n("common_text_4247", nil)
		i18n("common_text_4247", nil).name = textName
		self.Text_name:setString(i18n("common_text_4247", i18n("common_text_4247", nil)))
	end
	if occupier.currOccupyBeginTime and occupier.histOccupyTotalSecs then
		local occupyTime = legendLordWarCtrl:getLegendOccupyTime(occupier.currOccupyBeginTime)
		occupyTime = occupyTime + occupier.histOccupyTotalSecs
		self.Text_time:setVisible(true)
		local remainTime = self.maxOccupyTime - occupyTime
		self.Text_time:beginTime(remainTime)
	else
		self.Text_time:setVisible(false)
		self.Text_time:endTime()
	end
end
function legendaryFirstKill:onClick_Button_RankView(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("legendaryKingRank")
		panel:init(self.buildID, worldMapDefine.currentMapKindomID)
		panel:show()
		self:removeFromParent()
	end
end
function legendaryFirstKill:onClick_Button_Box(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) then
			local panel = SoraDCreatePanelByFixName("kingStarFirstKillReward")
			panel:initData(self.buildID)
			panel:show()
		else
			local panel = SoraDCreatePanel("legendaryFirstKillReward")
			panel:initData(self.buildID)
			panel:show()
		end
		self:removeFromParent()
	end
end
return legendaryFirstKill
