local publicUtil = include("publicUtil")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemNum = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://WishMeteor/Com_itemNum", Com_itemNum)
function Com_itemNum:onInit()
	self:fixChildrenPos()
	self.fields.btnAdd:addClickListener(handler(self, self.onClickAdd))
end
function Com_itemNum:updateItemCount()
	self.fields.textNum:setString(string.formatnumberthousands(publicUtil.getCount(self.itemID)))
end
function Com_itemNum:initData(itemID, handler)
	self.itemID = itemID
	self.addBtnHandler = handler
	self:updateItemCount()
	self.fields.n60:setURL(include("publicRead").getIcon(self.itemID))
end
function Com_itemNum:onClickAdd()
	SoraDPlaySound()
	if self.addBtnHandler then
		self.addBtnHandler(self.itemID)
		return
	end
	local sources = include("itemDesRead").getOutput(self.itemID)
	_ENV = nil
	;(nil).sources = sources
	uiManager:show("CommonSourceGuide", nil)
end
return Com_itemNum
