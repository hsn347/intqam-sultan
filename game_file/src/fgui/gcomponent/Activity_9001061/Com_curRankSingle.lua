local baseComponent = require("fgui.base.baseComponent")
local Com_curRankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001061/Com_curRankSingle", Com_curRankSingle)
function Com_curRankSingle:onInit()
	self:fixChildrenPos()
end
function Com_curRankSingle:onShow()
end
function Com_curRankSingle:initData(data)
	_ENV = nil
	;(nil).rank = data.rank
	self.fields.Com_rankBase:initRankBaseData(nil)
	self.fields.Text_name:setString(textParser.formatPlayerName(data.abbr, data.name))
	self.fields.Text_score:setString(string.formatnumberthousands(data.score))
end
return Com_curRankSingle
