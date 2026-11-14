local extremelySkillfulRead = include("extremelySkillfulRead")
local ExtremelySkillfulCtrl = SoraDGetCtrl("ExtremelySkillfulCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Buff_Preview = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ExtremelySkillful/Com_Buff_Preview", Com_Buff_Preview)
function Com_Buff_Preview:onInit()
	self:fixChildrenPos()
end
_UPVALUE3_, Com_Buff_Preview.onShow = function(self)
end, function(self)
end
;(function(self)
end)[1] = "MarvelousWorkmanship_09"
;(function(self)
end)[2] = "MarvelousWorkmanship_10"
local (function(self)
end)[3], tips = "MarvelousWorkmanship_11", function(self)
end
function Com_Buff_Preview:updateBuffDes()
	local type = ExtremelySkillfulCtrl:getBuffIndex()
	if 0 < type then
		if ExtremelySkillfulCtrl:isMaxLvByType(type) then
			self:setVisible(false)
			return
		else
			self:setVisible(true)
		end
		self.fields.title:setString(i18n(tips[type]))
	else
		self.fields.title:setString(i18n("MarvelousWorkmanship_08"))
	end
	self.controllers.c1:setSelectedIndex(1)
end
return Com_Buff_Preview
