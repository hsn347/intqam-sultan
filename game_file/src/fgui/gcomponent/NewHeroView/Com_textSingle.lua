local baseComponent = require("fgui.base.baseComponent")
local Com_textSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_textSingle", Com_textSingle)
function Com_textSingle:onInit()
	self:fixChildrenPos()
end
function Com_textSingle:onShow()
end
function Com_textSingle:initData(data, index)
	self.fields.bg:setVisible(index % 2 == 0)
	self.fields.Text_lv:setString(string.format("%d-%d", data.heroLv[1], data.heroLv[2]))
	if SoraDFIsRA() then
		_ENV = string.format("%d-%d", data.heroLv[1], data.heroLv[2])
		string.format("%d-%d", data.heroLv[1], data.heroLv[2]).attr = data.stuntAttr / 100
		string.format("%d-%d", data.heroLv[1], data.heroLv[2]).add = fguiHelper.getColorString("#70C723", string.format("%d%%+ ", math.floor(data.stuntAttrAdd / 100)))
		self.fields.Text_jj:setString(i18n("%{add} %{attr}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2])))
		_ENV = i18n("%{add} %{attr}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2]))
		i18n("%{add} %{attr}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2])).attr = data.awakeAttr / 100
		i18n("%{add} %{attr}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2])).add = fguiHelper.getColorString("#70C723", string.format("%d%%+ ", math.floor(data.awakeAttrAdd / 100)))
		self.fields.Text_zj:setString(i18n("%{add} %{attr}%", i18n("%{add} %{attr}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2]))))
	else
		_ENV = i18n("%{add} %{attr}%", i18n("%{add} %{attr}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2])))
		i18n("%{add} %{attr}%", i18n("%{add} %{attr}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2]))).attr = data.stuntAttr / 100
		i18n("%{add} %{attr}%", i18n("%{add} %{attr}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2]))).add = fguiHelper.getColorString("#70C723", string.format("+ %d%%", math.floor(data.stuntAttrAdd / 100)))
		self.fields.Text_jj:setString(i18n("%{attr}% %{add}", i18n("%{add} %{attr}%", i18n("%{add} %{attr}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2])))))
		_ENV = i18n("%{attr}% %{add}", i18n("%{add} %{attr}%", i18n("%{add} %{attr}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2]))))
		i18n("%{attr}% %{add}", i18n("%{add} %{attr}%", i18n("%{add} %{attr}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2])))).attr = data.awakeAttr / 100
		i18n("%{attr}% %{add}", i18n("%{add} %{attr}%", i18n("%{add} %{attr}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2])))).add = fguiHelper.getColorString("#70C723", string.format("+ %d%%", math.floor(data.awakeAttrAdd / 100)))
		self.fields.Text_zj:setString(i18n("%{attr}% %{add}", i18n("%{attr}% %{add}", i18n("%{add} %{attr}%", i18n("%{add} %{attr}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2]))))))
	end
end
return Com_textSingle
