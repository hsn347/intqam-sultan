local heroTrialCommon = include("heroTrialCommon")
local baseComponent = require("fgui.base.baseComponent")
local Com_trialLog = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://heroTrial/Com_trialLog", Com_trialLog)
function Com_trialLog:onInit()
	self.fields.Btn_look:addClickListener(handler(self, self.btnLookClick))
	self:fixChildrenPos()
end
function Com_trialLog:onShow()
end
function Com_trialLog:initData(data)
	self.data = data
	local timeStr = os.date("[%Y-%m-%d %H:%M:%S]", data.time)
	if heroTrialCommon.isSameDay(data.time, os.time()) then
		timeStr = os.date("[%H:%M:%S]", data.time)
	end
	_UPVALUE6_ = os.date("[%H:%M:%S]", data.time)
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[1] = i18n("common_text_1713"), i18n("common_text_1713")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[2] = i18n("common_text_1713"), i18n("common_text_1714")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[3] = i18n("common_text_1713"), "common_text_1716"
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[4] = i18n("common_text_1713"), "common_text_1716"
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[5] = i18n("common_text_1713"), i18n("common_text_1717")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[6] = i18n("common_text_1713"), i18n("common_text_1718")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[7] = i18n("common_text_1713"), i18n("common_text_1719")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[8] = i18n("common_text_1713"), i18n("common_text_1719")
	heroTrialCommon, os.date("[%H:%M:%S]", data.time)[9] = i18n("common_text_1713"), i18n("common_text_1719")
	local heroTrialCommon, os.date("[%H:%M:%S]", data.time)[10], strList = i18n("common_text_1713"), i18n("common_text_1719")
	i18n("common_text_1713")[1] = i18n("common_text_152")
	i18n("common_text_1713")[2] = i18n("mail_text_14")
	i18n("common_text_1713")[3] = i18n("mail_text_14")
	i18n("common_text_1713")[4] = i18n("mail_text_14")
	i18n("common_text_1713")[5] = i18n("mail_text_14")
	i18n("common_text_1713")[6] = i18n("mail_text_14")
	i18n("common_text_1713")[7] = i18n("mail_text_14")
	i18n("common_text_1713")[8] = i18n("mail_text_14")
	local i18n("common_text_1713")[9], strResult = i18n("mail_text_14")
	local contentStr = strList[data.logType]
	local lookStr = i18n("common_text_1720")
	if data.logType == gTrialLogType.ATTACK_STAGE_SUCCESS or data.logType == gTrialLogType.ATTACK_STAGE_FAILED then
		_ENV = i18n("mail_text_14")
		i18n("mail_text_14").level = heroTrialCommon.convertLevelToNum(data.logData.stageID)
		contentStr = i18n(contentStr, i18n("mail_text_14"))
		_ENV = contentStr
		contentStr.color = cc.c3b(212, 206, 180)
		local str = SoraDWrapHtmlTagByStyle(timeStr .. contentStr, contentStr)
		local resultStr, resultColor
		if data.logType == gTrialLogType.ATTACK_STAGE_SUCCESS then
			resultStr = strResult[1]
			resultColor = cc.c3b(0, 255, 72)
		else
			resultStr = strResult[2]
			resultColor = cc.c3b(255, 0, 0)
		end
		_ENV = 0
		;(0).color = resultColor
		str = str .. SoraDWrapHtmlTagByStyle(resultStr, 0)
		self.fields.title:setString(str)
	else
		_ENV = contentStr
		contentStr.color = cc.c3b(212, 206, 180)
		local str = SoraDWrapHtmlTagByStyle(timeStr .. contentStr, contentStr)
		self.fields.title:setString(str)
	end
	local isShowLook = self.data.logData and self.data.logData.report and true or false
	self.fields.Btn_look:setVisible(isShowLook)
	self.fields.n2:setVisible(isShowLook)
end
function Com_trialLog:btnLookClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).logData = self.data.logData
	uiManager:show("heroTrialReport", nil)
end
return Com_trialLog
