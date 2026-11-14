local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTimeRead = include("activityTimeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SixYearActivityPanel = class("SixYearActivityPanel", baseFguiPanel)
function SixYearActivityPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SixYearActivityPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.SIX_YEAR_ACTIVITY
end
function SixYearActivityPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "AnniversaryCountdown"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function SixYearActivityPanel:onInit()
	print("=======SixYearActivityPanel:onInit")
	local activityName = activityTimeRead.getActivityNameByID(self.activityID)
	self.fields.Com_title:initData(i18n(activityName), handler(self, self.onClickClose))
	self.comFields = fguiHelper.get_fields(self.fields.Com_SixYear)
	local param = activityShowCtrl:getParamByID(self.activityID)
	local showConfig = param.showConfig
	local _ENV, data = self.activityID, self.activityID
	for i, v in ipairs(showConfig) do
		local activityID = tostring(v.activityID)
		if not data[activityID] then
			_ENV = data[activityID]
		end
		data[activityID] = data[activityID]
		table.insert(data[activityID], v)
	end
	_ENV = (for generator)
	ipairs(showConfig)[1] = "ui_artifact"
	ipairs(showConfig)[2] = "ui_colossus"
	ipairs(showConfig)[3] = "ui_Magicherbs"
	ipairs(showConfig)[4] = "ui_qiandao"
	local activityTimeRead, _ENV, ipairs(showConfig)[5], soundList = ipairs(showConfig)
	activityShowCtrl, ipairs(showConfig)[1], ipairs(showConfig)[1] = ipairs(showConfig)
	activityTimeRead, ipairs(showConfig)[2], ipairs(showConfig)[1] = ipairs(showConfig)
	activityTimeRead, ipairs(showConfig)[2], ipairs(showConfig)[2] = ipairs(showConfig)
	activityTimeRead, ipairs(showConfig)[3], ipairs(showConfig)[1] = ipairs(showConfig)
	activityTimeRead, ipairs(showConfig)[4], ipairs(showConfig)[1] = ipairs(showConfig)
	ipairs(showConfig)[5], ipairs(showConfig)[1] = ipairs(showConfig)
	local config = ipairs(showConfig)
	for i, eidList in ipairs(config) do
		self:initSingle(i, eidList, data, soundList[i])
	end
	self.comFields.Usm_bottom:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	activityShowCtrl = table.insert
	table.insert[1] = "ar"
	table.insert[2] = "en"
	self.comFields.Load_title:setURL(SoraDGetImageNameByLang("font_ryyz_%s.png", table.insert))
end
function SixYearActivityPanel:initSingle(index, eidList, data, soundKey)
	local Com_SixYear = self.comFields["Com_SixYear" .. index]
	local Com_light = self.comFields["Com_light" .. index]
	local widgetFields = fguiHelper.get_fields(Com_SixYear)
	local timeStr = ""
	local eid = eidList[#eidList]
	if not data[tostring(eid)] then
		local _ENV, timeConfig = data[tostring(eid)], data[tostring(eid)]
	end
	for _, time in ipairs(timeConfig) do
		if timeStr ~= "" then
			timeStr = timeStr .. "\n"
		end
		timeStr = timeStr .. string.format("%s-%s", os.date("%Y.%m.%d", time.beginTime), os.date("%Y.%m.%d", time.endTime))
	end
	if timeStr == "" then
		Com_SixYear:setVisible(false)
		Com_light:setVisible(false)
		return
	else
		widgetFields.Text_time:setString(timeStr)
	end
	local jumpCallBack = function()
		SoraDPlaySound("sixYear", soundKey)
		local eid = eidList[#eidList]
		if not activityTimeRead.getActivityEnemyShowByID(eid) and worldMapDefine.inInCrossWar() then
			SoraDShowMsgTip(i18n("common_text_3302"))
			return
		end
		local showLight = self.proxy:checkActivityIsShow(eid)
		if showLight then
			self:close()
		end
		clientEventMgr.singleClickEvent(eid)
	end
	Com_SixYear:addClickListener(jumpCallBack)
	Com_light:addClickListener(jumpCallBack)
	local Text_name = widgetFields.Text_name
	local nameStr = ""
	for _, activityID in ipairs(eidList) do
		if nameStr ~= "" then
			nameStr = nameStr .. "\n"
		end
		nameStr = nameStr .. i18n(activityTimeRead.getActivityNameByID(activityID))
	end
	Text_name:setString(nameStr)
	if 1 < #eidList then
		Text_name:setSize(Text_name:getSize().width, #eidList * 34)
	end
	widgetFields.Movie_light:setAllFrameName("dh_Tex_XL_znzr01_%03d.png")
	local c_light = Com_SixYear:getController("c_light")
	local eid = eidList[#eidList]
	local showLight = false
	if not activityTimeRead.getActivityEnemyShowByID(eid) and worldMapDefine.inInCrossWar() then
		showLight = false
	else
		showLight = self.proxy:checkActivityIsShow(eid)
	end
	if showLight then
		c_light:setSelectedIndex(1)
		Com_light:setVisible(true)
	else
		c_light:setSelectedIndex(0)
		Com_light:setVisible(false)
	end
end
function SixYearActivityPanel:onShow()
	print("=======SixYearActivityPanel:onShow")
	SoraDPlayMusic("sixYear", "music_anniversary")
end
function SixYearActivityPanel:onHide()
	SoraDResetBackGroundMusic()
end
return SixYearActivityPanel
