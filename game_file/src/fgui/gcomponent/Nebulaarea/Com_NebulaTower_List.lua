local baseComponent = require("fgui.base.baseComponent")
local Com_NebulaTower_List = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Nebulaarea/Com_NebulaTower_List", Com_NebulaTower_List)
local nebulaTowerLvDesRead = include("nebulaTowerLvDesRead")
function Com_NebulaTower_List:onInit()
	self.maxKingdomLv = nebulaTowerLvDesRead.getMaxLevel()
	self.fields.scroll:setVirtual()
	self.fields.scroll:setItemRenderer(handler(self, self.onItemsRender))
end
function Com_NebulaTower_List:onShow()
end
function Com_NebulaTower_List:setLevel(level)
	self.level = level
	local slv, blv = nebulaTowerLvDesRead.getLookCurLv(level)
	local datas = nebulaTowerLvDesRead.queryBuffDataDif(slv, blv)
	self.datas, nebulaTowerLvDesRead = slv, slv
	for k, v in pairs(datas) do
		v.buffType = k
		table.insert(self.datas, v)
	end
	table.sort(self.datas, function(l, r)
		return l.rank < r.rank
	end)
	self.fields.scroll:setNumItems(#self.datas * 2)
	self.fields.scroll:scrollToView(0)
end
function Com_NebulaTower_List:onItemsRender(index, obj)
	local curData = self.datas[math.floor(index / 2) + 1]
	obj:setData(curData, index % 2 == 1)
end
return Com_NebulaTower_List
