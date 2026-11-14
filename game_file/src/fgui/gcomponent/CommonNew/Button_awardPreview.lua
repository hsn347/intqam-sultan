local baseComponent = require("fgui.base.baseComponent")
local Button_awardPreview = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonNew/Button_awardPreview", Button_awardPreview)
fgui.register_extension("ui://CommonNew/Button_awardPreview2", Button_awardPreview)
function Button_awardPreview:onInit()
	if self.fields.red then
		self.fields.red:setVisible(false)
	end
	if self.fields.Label_reddot then
		self.fields.Label_reddot:setVisible(false)
	end
end
function Button_awardPreview:onShow()
end
function Button_awardPreview:setRedVisible(ret, num)
	if self.fields.red then
		self.fields.red:setVisible(ret)
	end
	if self.fields.Label_reddot then
		self.fields.Label_reddot:initData(ret, num)
	end
end
function Button_awardPreview:setString(...)
	self.fields.title:setString(...)
	self:setTextMaxHeight(60)
end
function Button_awardPreview:setTextMaxHeight(maxHeight)
	local txt = self.fields.title
	local txtSize = txt:getContentSize()
	if maxHeight < txtSize.height then
		txt:setAutoSize(fgui.AutoSizeType.SHRINK)
		txt:setSize(cc.size(txtSize.width, maxHeight))
	end
end
function Button_awardPreview:fitIconSize(newSize)
	newSize = newSize or cc.size(80, 80)
	self.fields.icon:setAutoSize(false)
	self.fields.icon:setWidth(newSize.width)
	self.fields.icon:setHeight(newSize.height)
end
return Button_awardPreview
