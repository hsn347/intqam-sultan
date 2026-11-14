local activity_9001625_Read = include("activity_9001625_Read")
local activity_9001625_Ctrl = SoraDGetCtrl("activity_9001625_Ctrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001625_MainPanel = class("Activity_9001625_MainPanel", baseFguiPanel)
local constantRead = include("constantRead")
local GATHERING_ACTIVITY_FEAST_DURATION = constantRead.getConstValue("GATHERING_ACTIVITY_FEAST_DURATION", 12) * 3600
function Activity_9001625_MainPanel:ctor(...)
	Activity_9001625_MainPanel.super.ctor(self, ...)
	print("Activity_9001625_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.GATHERING_FEAST_2024
	self.feastConfig = activity_9001625_Read.getFeastConfig()
end
function Activity_9001625_MainPanel:onInit()
	print("=======Activity_9001625_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_add:addClickListener(handler(self, self.onClickBtnAdd))
	self.fields.Text_noAlliance:setString(i18n("gathering_activity_text2") .. i18n("pyramid_text_02"))
	if allianceMgr:hasJoinAlliance() then
		self.controllers.c_alliance:setSelectedIndex(0)
	else
		self.controllers.c_alliance:setSelectedIndex(1)
	end
	if not SoraDFIsRA() then
		self.fields.Text_point:fixPos()
		self.fields.Load_point:fixPos()
		self.fields.Button_add:fixPos()
		for i, __ in ipairs(self.feastConfig) do
			local Com_feast = self.fields["Com_feast" .. i]
			if Com_feast then
				Com_feast:fixPos()
			end
		end
	end
end
function Activity_9001625_MainPanel:onShow()
	print("=======Activity_9001625_MainPanel:onShow")
	SoraDShowLoading(self)
	activity_9001625_Ctrl:sendReqInitDataMsg()
end
function Activity_9001625_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("gathering_activity_text9")
	uiManager:show("RuleView", nil)
end
function Activity_9001625_MainPanel:onClickBtnAdd(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = gIDDef.PREPARING_FEAST_2024_SCORE
	uiManager:show("CommonSourceGuide", nil)
end
function Activity_9001625_MainPanel:updateFeast(...)
	self.feasts = activity_9001625_Ctrl:getAllianceFeasts()
	local placeIndex
	for k, feast in pairs(self.feasts) do
		local remainTime = activity_9001625_Ctrl:getRemainTime(feast)
		if 0 < remainTime then
			placeIndex = tonumber(k)
			break
		end
	end
	self.placeIndex = placeIndex
	for i, __ in ipairs(self.feastConfig) do
		local Com_feast = self.fields["Com_feast" .. i]
		if Com_feast then
			self:initFeastSingle(Com_feast, i)
		end
	end
	if self.placeIndex then
		self:setPlaceIndex(self.placeIndex)
	end
end
function Activity_9001625_MainPanel:initFeastSingle(obj, feastId)
	_ENV = nil
	;(nil).feastId = feastId
	;(nil).feast = self.feasts[tostring(feastId)]
	;(nil).cfg = self.feastConfig[feastId]
	;(nil).point = self.point
	;(nil).placeIndex = self.placeIndex
	obj:initData(nil)
end
function Activity_9001625_MainPanel:setPlaceIndex(index)
	if index ~= 2 then
		local Com_feast1 = self.fields["Com_feast" .. index]
		local Com_feast2 = self.fields.Com_feast2
		local posx1, posx2 = Com_feast1:getPositionX(), Com_feast2:getPositionX()
		Com_feast1:setPositionX(posx2)
		Com_feast2:setPositionX(posx1)
	end
end
function Activity_9001625_MainPanel:onMsgUpdateData(target, event)
	local subMsg = event.subMsg
	if subMsg == "updateFeast" then
		self:updateFeast()
	elseif subMsg == "init" then
		SoraDCloseLoading(self)
		self.point = activity_9001625_Ctrl:getAllianceScore()
		if allianceMgr:hasJoinAlliance() then
			_ENV = self.point
			self.point.color = "#FFDF2D"
			local pointStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(self.point), self.point)
			self.fields.Text_point:setString(i18n("gathering_activity_text2") .. pointStr)
			fguiHelper.setTextWidthHeight(self.fields.Text_point, cc.size(400, 36))
		end
		self:updateFeast()
	end
end
return Activity_9001625_MainPanel
