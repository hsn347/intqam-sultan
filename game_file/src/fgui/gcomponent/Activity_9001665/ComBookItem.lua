local baseComponent = require("fgui.base.baseComponent")
local ComBookItem = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001665/ComBookItem", ComBookItem)
function ComBookItem:onInit()
	self.fields.listStar:setItemRenderer(handler(self, self.itemRenderer_listStar))
end
function ComBookItem:onShow()
end
function ComBookItem:itemRenderer_listStar(index, obj)
end
function ComBookItem:initData(bookData)
	self.fields.title:setString(i18n(bookData.cfg.fishName))
	self.controllers.ctrlSeason:setSelectedIndex(bookData.cfg.seasonType - 1)
	self.fields.icon:setIcon(bookData.cfg.fishPic)
	self.fields.listStar:setNumItems(bookData.cfg.star)
	self:setGrayed(not bookData.unlock)
end
return ComBookItem
