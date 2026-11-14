local baseComponent = require("fgui.base.baseComponent")
local page_condition = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/page_condition", page_condition)
function page_condition:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function page_condition:onItemRenderer(index, obj)
	obj:initData(self.buffList[index + 1])
end
function page_condition:onShow()
end
function page_condition:initPageData(data, myCfg)
	self.data = data
	self.buffList, _ENV, self.myCfg = nil, nil, myCfg
	local isNew = false
	if self.data.skillAddition and self.data.skillAddition > 0 then
		if not self.myCfg.skillAddition or self.myCfg.skillAddition <= 0 and self.data.level > self.myCfg.level then
			isNew = true
		end
		_ENV = nil
		_ENV = nil
		;(nil).num = self.data.skillAddition / 10
		;(nil).des = i18n("hero_palace_text_11", nil)
		;(nil).isNew = isNew
		table.insert(self.buffList, nil)
	end
	if self.data.awakeAddition and 0 < self.data.awakeAddition then
		if not self.myCfg.awakeAddition or 0 >= self.myCfg.awakeAddition and self.data.level > self.myCfg.level then
			isNew = true
		end
		_ENV = nil
		_ENV = nil
		;(nil).num = self.data.awakeAddition / 10
		;(nil).des = i18n("hero_palace_text_12", nil)
		;(nil).isNew = isNew
		table.insert(self.buffList, nil)
	end
	if self.data.stuntAddition and 0 < self.data.stuntAddition then
		if not self.myCfg.stuntAddition or 0 >= self.myCfg.stuntAddition and self.data.level > self.myCfg.level then
			isNew = true
		end
		_ENV = nil
		_ENV = nil
		;(nil).num = self.data.stuntAddition / 10
		;(nil).des = i18n("hero_palace_text_13", nil)
		;(nil).isNew = isNew
		table.insert(self.buffList, nil)
	end
	if self.data.masteryAddition and 0 < self.data.masteryAddition then
		if not self.myCfg.masteryAddition or 0 >= self.myCfg.masteryAddition and self.data.level > self.myCfg.level then
			isNew = true
		end
		_ENV = nil
		_ENV = nil
		;(nil).num = self.data.masteryAddition / 10
		;(nil).des = i18n("hero_palace_text_14", nil)
		;(nil).isNew = isNew
		table.insert(self.buffList, nil)
	end
	self.fields.List:setNumItems(#self.buffList)
end
return page_condition
