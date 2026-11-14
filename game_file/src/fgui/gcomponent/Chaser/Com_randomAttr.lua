local baseComponent = require("fgui.base.baseComponent")
local artifactRuneRead = include("artifactRuneRead")
local Com_randomAttr = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Chaser/Com_randomAttr", Com_randomAttr)
function Com_randomAttr:onInit()
	self.showProperty, _ENV = nil, nil
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_randomAttr:onShow()
end
function Com_randomAttr:onItemRenderer(index, obj)
	local isNew = false
	if self.data.extraProperty and self.data.tempExtraProperty and self.data.extraProperty[index + 1][1] ~= self.data.tempExtraProperty[index + 1][1] then
		isNew = true
	end
	obj:initData(self.showProperty[index + 1], index + 1, isNew, self.isReview, self.lockList, self.data.rid)
end
function Com_randomAttr:initData(title, data, isReview, lockList, rid)
