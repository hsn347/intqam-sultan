local worldKingdomLvDesRead = include("worldKingdomLvDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Page_lv = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ServerLevel/Page_lv", Page_lv)
function Page_lv:onInit()
	self.vipInfo, _ENV = nil, nil
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
end
function Page_lv:onShow()
end
function Page_lv:onListRenderer(index, obj)
	obj:initData(self.scrollFactoryData[index + 1])
end
function Page_lv:initPageData(slv, blv)
	print(slv, blv, "slv,blv")
	self.scrollFactoryData = self:getListData(slv, blv)
	dump(self.scrollFactoryData, "self.scrollFactoryData")
	self.fields.List:setNumItems(#self.scrollFactoryData)
end
function Page_lv:getListData(slv, blv)
	local worldKingdomLvDesRead, scrollFactoryData
	local infos = worldKingdomLvDesRead.queryBuffDataDif(slv, blv)
	local keys = table.keys(infos)
	table.sort(keys, function(l, r)
		return infos[l].rank < infos[r].rank
	end)
	for i, val in ipairs(keys) do
		local v = infos[val]
		local propLeftData = clone(v)
		propLeftData.isBig = false
		table.insert(scrollFactoryData, propLeftData)
		local propRightData = clone(v)
		propRightData.isBig = true
		table.insert(scrollFactoryData, propRightData)
	end
	return scrollFactoryData
end
return Page_lv
