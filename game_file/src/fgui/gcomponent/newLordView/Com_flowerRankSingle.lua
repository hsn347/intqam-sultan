local baseComponent = require("fgui.base.baseComponent")
local Com_flowerRankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_flowerRankSingle", Com_flowerRankSingle)
function Com_flowerRankSingle:onInit()
	self.fields.Text_name:setString(i18n("common_text_2314"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
end
function Com_flowerRankSingle:onItemRenderer(index, obj)
	obj:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
function Com_flowerRankSingle:onShow()
end
function Com_flowerRankSingle:initData(rank, rewardscfg)
	self.controllers.c1:setSelectedIndex(rank - 1)
	_UPVALUE2_ = rank - 1
	;(rank - 1)[1] = "id"
	;(rank - 1)[2] = "count"
	self.rewardList = serviceFunctions.tableFormat(rewardscfg[rank].reward, rank - 1)
	self.fields.List_reward:setNumItems(#self.rewardList)
end
return Com_flowerRankSingle
