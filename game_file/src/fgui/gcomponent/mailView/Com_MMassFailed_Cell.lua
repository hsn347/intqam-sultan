local baseComponent = require("fgui.base.baseComponent")
local Com_MMassFailed_Cell = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://mailView/Com_MMassFailed_Cell", Com_MMassFailed_Cell)
function Com_MMassFailed_Cell:onInit()
end
function Com_MMassFailed_Cell:onShow()
end
function Com_MMassFailed_Cell:initData(data, speedRecord)
	local armyCount = 0
	if not data.army then
		_ENV = data.army
	end
	for _, v in ipairs(data.army) do
		armyCount = armyCount + v.num
	end
	_ENV = nil
	;(nil).cur = string.formatnumberthousands(armyCount)
	self.fields.text_army:setString(i18n("common_text_297", nil))
	self.fields.text_name:setString(data.name)
	_ENV = i18n("common_text_297", nil)
	i18n("common_text_297", nil).num = speedRecord[data.uid] or 0
	self.fields.text_speed:setString(i18n("common_text_4901", i18n("common_text_297", nil)))
	self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
end
return Com_MMassFailed_Cell
