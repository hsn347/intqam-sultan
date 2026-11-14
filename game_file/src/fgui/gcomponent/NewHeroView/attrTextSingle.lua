local baseComponent = require("fgui.base.baseComponent")
local attrTextSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/attrTextSingle", attrTextSingle)
fgui.register_extension("ui://NewHeroView/attrTextSingle2", attrTextSingle)
function attrTextSingle:onInit()
	self:fixChildrenPos()
end
function attrTextSingle:onShow()
end
function attrTextSingle:initData(data, index, isSpecial)
	self.controllers.c1:setSelectedIndex(index % 2)
	self.fields.Text_1:setString(string.format("%d-%d", data.heroLv[1], data.heroLv[2]))
	if isSpecial then
		if SoraDFIsRA() then
			_ENV = string.format("%d-%d", data.heroLv[1], data.heroLv[2])
			string.format("%d-%d", data.heroLv[1], data.heroLv[2]).base = data.stuntAttr / 100
			string.format("%d-%d", data.heroLv[1], data.heroLv[2]).extra = fguiHelper.getColorString("#70C723", string.format("%d%%+", data.stuntAttrAdd / 100))
			self.fields.Text_2:setString(i18n("%{extra} %{base}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2])))
			if self.fields.Text_3 then
				_ENV = i18n("%{extra} %{base}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2]))
				i18n("%{extra} %{base}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2])).base = data.awakeAttr / 100
				i18n("%{extra} %{base}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2])).extra = fguiHelper.getColorString("#70C723", string.format("%d%%+", data.awakeAttrAdd / 100))
				self.fields.Text_3:setString(i18n("%{extra} %{base}%", i18n("%{extra} %{base}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2]))))
			end
		else
			_ENV = i18n("%{extra} %{base}%", i18n("%{extra} %{base}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2])))
			i18n("%{extra} %{base}%", i18n("%{extra} %{base}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2]))).base = data.stuntAttr / 100
			i18n("%{extra} %{base}%", i18n("%{extra} %{base}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2]))).extra = fguiHelper.getColorString("#70C723", string.format("+%d%%", data.stuntAttrAdd / 100))
			self.fields.Text_2:setString(i18n("%{base}% %{extra}", i18n("%{extra} %{base}%", i18n("%{extra} %{base}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2])))))
			if self.fields.Text_3 then
				_ENV = i18n("%{base}% %{extra}", i18n("%{extra} %{base}%", i18n("%{extra} %{base}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2]))))
				i18n("%{base}% %{extra}", i18n("%{extra} %{base}%", i18n("%{extra} %{base}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2])))).base = data.awakeAttr / 100
				i18n("%{base}% %{extra}", i18n("%{extra} %{base}%", i18n("%{extra} %{base}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2])))).extra = fguiHelper.getColorString("#70C723", string.format("+%d%%", data.awakeAttrAdd / 100))
				self.fields.Text_3:setString(i18n("%{base}% %{extra}", i18n("%{base}% %{extra}", i18n("%{extra} %{base}%", i18n("%{extra} %{base}%", string.format("%d-%d", data.heroLv[1], data.heroLv[2]))))))
			end
		end
	else
		self.fields.Text_2:setString(string.format("%d%%", data.stuntAttr / 100))
		if self.fields.Text_3 then
			self.fields.Text_3:setString(string.format("%d%%", data.awakeAttr / 100))
		end
	end
end
function attrTextSingle:initDataEx(data, index)
	self.controllers.c1:setSelectedIndex(index % 2)
	self.fields.Text_1:setString(data.heroNum)
	self.fields.Text_2:setString(string.format("%d%%", data.attrPercent / 100))
end
function attrTextSingle:setTitle3(str1, str2, str3)
	self.fields.Text_1:setColor(cc.c3b(230, 180, 110))
	self.fields.Text_1:setString(str1)
	self.fields.Text_2:setColor(cc.c3b(230, 180, 110))
	self.fields.Text_2:setString(str2)
	if self.fields.Text_3 then
		self.fields.Text_3:setColor(cc.c3b(230, 180, 110))
		self.fields.Text_3:setString(str3)
	end
end
return attrTextSingle
