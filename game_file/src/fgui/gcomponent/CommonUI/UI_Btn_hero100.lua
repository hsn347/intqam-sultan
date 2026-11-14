local baseComponent = require("fgui.base.baseComponent")
local UI_Btn_hero100 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Btn_hero100", UI_Btn_hero100)
fgui.register_extension("ui://CommonUI/UI_Btn_hero90", UI_Btn_hero100)
function UI_Btn_hero100:onInit()
end
function UI_Btn_hero100:onShow()
end
function UI_Btn_hero100:initData(heroID, dressID)
	self.fields.Com_hero:initData(heroID, dressID)
end
function UI_Btn_hero100:initDataWithInfo(heroInfo, dressID)
	self.fields.Com_hero:initDataWithInfo(heroInfo, dressID)
end
function UI_Btn_hero100:initMax(heroID)
	self.fields.Com_hero:initMax(heroID)
end
function UI_Btn_hero100:setShowHeroDetail(show)
	print("UI_Btn_hero100:setShowHeroDetail", show)
	self.fields.Com_hero:setShowHeroDetail(show)
	self.fields.select:setVisible(not show)
end
return UI_Btn_hero100
