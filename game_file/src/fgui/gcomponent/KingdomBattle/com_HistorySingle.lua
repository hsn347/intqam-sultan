local baseComponent = require("fgui.base.baseComponent")
local com_HistorySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingdomBattle/com_HistorySingle", com_HistorySingle)
function com_HistorySingle:onInit()
	self:fixChildrenPos()
	self.fields.n14:fix()
end
function com_HistorySingle:onShow()
end
function com_HistorySingle:initdata(info)
	self:setContentSize(cc.size(640, 118))
	if info.isNebulaBefore and IsArClient then
		self.fields.Text_Tips:setString(i18n("parliament_text_150"))
		self:setContentSize(cc.size(640, 163))
	end
	self.fields.Text_dateTime:setString(os.date("%x", info.time))
	self.fields.Text_lName:setString(info.sk.kname)
	_ENV = os.date("%x", info.time)
	os.date("%x", info.time).num = string.formatnumberthousands(math.ceil(info.sk.score))
	self.fields.Text_lPoint:setString(i18n("common_text_2556", os.date("%x", info.time)))
	self.fields.Text_rName:setString(info.tk.kname)
	_ENV = i18n("common_text_2556", os.date("%x", info.time))
	i18n("common_text_2556", os.date("%x", info.time)).num = string.formatnumberthousands(math.ceil(info.tk.score))
	self.fields.Text_rPoint:setString(i18n("common_text_2556", i18n("common_text_2556", os.date("%x", info.time))))
	local win = info.sk.result < info.tk.result
	self.controllers.c1:setSelectedIndex(win and 0 or 1)
end
return com_HistorySingle
