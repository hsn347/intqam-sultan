local activity_9001737_Ctrl = SoraDGetCtrl("activity_9001737_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_rankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001737/Com_rankSingle", Com_rankSingle)
function Com_rankSingle:onInit()
	self:fixChildrenPos()
end
function Com_rankSingle:onShow()
end
function Com_rankSingle:initData(data, isOwnRank)
	_ENV = nil
	;(nil).rank = data.rank or data.rankInfo.rank
	;(nil).isOwnRank = isOwnRank
	self.fields.Com_rankBase:initRankBaseData(nil)
	self.fields.icon:setURL(data.campIcon)
	self.fields.Text_name:setString(i18n(data.campName))
	self.fields.Text_score:setString(string.formatnumberthousands(data.rankInfo.point))
end
return Com_rankSingle
