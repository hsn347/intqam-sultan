local baseComponent = require("fgui.base.baseComponent")
local Com_NebulaTech_List1 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Nebulaarea/Com_NebulaTech_List1", Com_NebulaTech_List1)
function Com_NebulaTech_List1:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function Com_NebulaTech_List1:onShow()
end
function Com_NebulaTech_List1:setData(showData, isLock, isLast)
	if not showData then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.text_unlock:setString(i18n("nebula_war_text_0162"))
		return
	end
	self.controllers.c1:setSelectedIndex(1)
	self:setLv(showData.lv.lv)
	for i = 1, 4 do
		self.fields["tech_" .. i]:initData(showData.technologyID[i], isLock)
	end
end
function Com_NebulaTech_List1:setLv(lv)
	self.fields.text_lv:setString(lv)
end
return Com_NebulaTech_List1
