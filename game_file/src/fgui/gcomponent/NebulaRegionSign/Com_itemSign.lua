local baseComponent = require("fgui.base.baseComponent")
local Com_itemSign = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NebulaRegionSign/Com_itemSign", Com_itemSign)
fgui.register_extension("ui://StarEnergyCube/Com_itemStar", Com_itemSign)
function Com_itemSign:onInit()
	self.fields.Ani_advance:setAllFrameName("dh_xingyunqy1_%02d.png", 1)
end
function Com_itemSign:initData(id, num)
	self.fields.Ani_advance:setVisible(false)
	self.fields.Ani_advance:setPlaying(false)
	self.fields.Com_item:initData(id, num)
end
function Com_itemSign:setAdvance(flag)
	local setFlag = flag == nil and true or flag
	self.fields.Ani_advance:setVisible(setFlag)
	self.fields.Ani_advance:setPlaying(setFlag)
end
function Com_itemSign:onShow()
end
return Com_itemSign
