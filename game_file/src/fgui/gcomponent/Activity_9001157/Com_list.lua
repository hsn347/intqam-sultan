local outStandingsRead = include("outStandingsRead")
local outStandingsCtrl = SoraDGetCtrl("outStandingsCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001157/Com_list", Com_list)
function Com_list:onInit()
	self:fixChildrenPos()
end
function Com_list:onShow()
end
function Com_list:initData(data, classType, basicTag)
	local curPower = outStandingsCtrl:getPowerByType(classType)
	local ValueList = outStandingsRead.getBasicScoreByType(classType, outStandingsCtrl:getBasicType())
	local progress = math.min(100, SoraDPreciseDecimal(curPower / ValueList[#ValueList], 4) * 100)
	print("percent======", progress, classType, basicTag)
	self.fields.Text_power:setString(i18n(data.key))
	self.fields.Text_power:setColor(data.color)
	self.fields.icon:setURL(data.png)
	outStandingsCtrl = i18n(data.key)
	outStandingsCtrl, outStandingsCtrl, i18n(data.key).num = curPower, string.formatnumberthousands(curPower), string.formatnumberthousands(curPower)
	outStandingsCtrl, string.formatnumberthousands(curPower).num, curPower.color = curPower, curPower, "#FFC864"
	string.formatnumberthousands(curPower).__default, curPower.color = curPower, "#AA9682"
	self.fields.Label_title:setString(i18n_html(data.text, i18n(data.key)))
	outStandingsCtrl = "%"
	;("%").color = "#ffffff"
	self.fields.Text_progress:setString(i18n("common_text_3780") .. SoraDWrapHtmlTagByStyle(progress .. "%", "%"))
	self.fields.Com_Stage:initData(ValueList, classType, basicTag)
	self.fields.Com_Stage:setBarValue(curPower)
	return #ValueList
end
return Com_list
