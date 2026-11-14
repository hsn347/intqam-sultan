local baseComponent = require("fgui.base.baseComponent")
local buildInfoSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildViewCommon/buildInfoSingle", buildInfoSingle)
function buildInfoSingle:onInit()
	self.imgIcon = self.fields.Image_icon
	self.labelDes = self.fields.Text_des
	self.labelValue = self.fields.Text_value
	self.btnHelp = self.fields.Button_help
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpCallBack))
	self.labelValue:setVisible(false)
	self.btnHelp:setVisible(false)
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function buildInfoSingle:onShow()
end
function buildInfoSingle:initData(buildInfoSingleData, bid)
	self.tableInfoSingleData = buildInfoSingleData
	self.tableInfoSingleData.bid = bid
	local valueStr
	if self.tableInfoSingleData.value then
		valueStr = tostring(self.tableInfoSingleData.value)
		self.labelDes:setWidth(285)
	else
		self.labelDes:setWidth(480)
	end
	if self.tableInfoSingleData.moreInfoType == 4 then
		local resDesRead = include("resDesRead")
		self.imgIcon:setURL(resDesRead.getIcon(self.tableInfoSingleData.title))
		self.labelDes:setString(resDesRead.getName(self.tableInfoSingleData.title))
	else
		self.labelDes:setString(self.tableInfoSingleData.title)
		self.imgIcon:setURL("icon_building_research.png")
	end
	local plusValue = self.tableInfoSingleData.plusValue
	local plusStr
	if plusValue then
		if type(plusValue) == "number" then
			if 0 <= plusValue then
				_ENV = string.formatnumberthousands(plusValue)
				string.formatnumberthousands(plusValue).color = "#70C723"
				plusStr = SoraDWrapHtmlTagByStyle("+" .. string.formatnumberthousands(plusValue), (string.formatnumberthousands(plusValue)))
			else
				_ENV = plusValue
				plusValue.color = "#FF0000"
				plusStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(plusValue), plusValue)
			end
		else
			_ENV = plusValue
			plusValue.color = "#70C723"
			plusStr = SoraDWrapHtmlTagByStyle(tostring(plusValue), plusValue)
		end
	end
	if valueStr or plusStr then
		if valueStr and plusStr then
			valueStr = valueStr .. "  " .. plusStr
		else
			valueStr = valueStr or "" .. plusStr or ""
		end
		self.labelValue:setString(valueStr)
		self.labelValue:setVisible(true)
	end
	if self.tableInfoSingleData.infoDesType == 1 then
		self.btnHelp:setVisible(true)
	end
end
function buildInfoSingle:btnHelpCallBack()
	SoraDPlaySound()
	local msg = ""
	if self.tableInfoSingleData.bid == BUILDID.HOSTPITAL then
		msg = i18n("common_text_749")
	elseif self.tableInfoSingleData.bid == BUILDID.MILITARY_TENT then
		msg = i18n("common_text_750")
	elseif self.tableInfoSingleData.bid == BUILDID.MARKET then
		msg = i18n("common_text_751")
	elseif self.tableInfoSingleData.bid == BUILDID.ELITE_PALACE then
		if self.tableInfoSingleData.key == "ElitePointLimit" then
			msg = i18n("common_text_3294")
		else
			msg = i18n("common_text_3295")
		end
	elseif self.tableInfoSingleData.key == "legendSoldiers" then
		msg = i18n("legend_of_soldiers")
	else
		msg = i18n("common_text_752")
	end
	SoraDShowHelpMsgTip(msg)
end
return buildInfoSingle
