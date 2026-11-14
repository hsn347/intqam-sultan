local gametop = gModuleMgr.getObject("gametop")
local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
local baseComponent = require("fgui.base.baseComponent")
local intetiorGoldMySingle = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Intetior/intetiorGoldMySingle", intetiorGoldMySingle)
function intetiorGoldMySingle:onInit()
	self.fields.Text_gold_title:setString(i18n("parliament_text_20"))
end
function intetiorGoldMySingle:onShow()
	self:updateResourceInfo()
end
function intetiorGoldMySingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_GOLD_BAR_CHANGE", handler(self, self.updateResourceInfo))
end
function intetiorGoldMySingle:updateResourceInfo()
	local resCount = intetiorCtrl:getMyGold()
	self:setString(string.formatnumberthousands(resCount))
end
return intetiorGoldMySingle
