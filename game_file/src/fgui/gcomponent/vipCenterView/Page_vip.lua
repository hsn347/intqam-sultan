local vipLocalData = include("vipLocalData")
local baseComponent = require("fgui.base.baseComponent")
local Page_vip = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://vipCenterView/Page_vip", Page_vip)
function Page_vip:onInit()
	self.vipInfo, _ENV = nil, nil
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
end
function Page_vip:onShow()
end
function Page_vip:onListRenderer(index, obj)
	obj:initData(self.vipInfo[index + 1])
end
function Page_vip:initPageData(lv, maxLv)
	local vipLevel, isActive = SoraDGetVipLv()
	local toLv = lv <= vipLevel and lv or math.min(maxLv, lv)
	local curLv = lv > vipLevel and vipLevel or lv
	self.vipInfo = vipLocalData.queryVipBuffDataDifNew(curLv, toLv)
	dump(self.vipInfo, "self.vipInfo====", 20)
	self.fields.List:setNumItems(#self.vipInfo)
end
return Page_vip
