local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_TP_itemNum = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001746/Com_TP_itemNum", Com_TP_itemNum)
function Com_TP_itemNum:onInit()
	self:fixChildrenPos()
	self.fields.btn_add:addClickListener(handler(self, self.onClick_btn_add))
	self.itemID = 0
	self.clickCallback = nil
end
function Com_TP_itemNum:onShow()
end
function Com_TP_itemNum:initData(itemID, itemCount, clickCallback)
	self.itemID = tonumber(itemID) or 0
	self.clickCallback = clickCallback
	self.fields.title:setString(string.formatnumberthousands(tonumber(itemCount) or 0))
	self.fields.icon:setURL(publicRead.getIcon(self.itemID) or "")
	self.fields.btn_add:setVisible(self.clickCallback ~= nil)
	self.fields.btn_add:setEnabled(self.clickCallback ~= nil)
end
function Com_TP_itemNum:onClick_btn_add()
	SoraDPlaySound()
	if self.clickCallback then
		self.clickCallback(self.itemID)
	end
end
return Com_TP_itemNum
