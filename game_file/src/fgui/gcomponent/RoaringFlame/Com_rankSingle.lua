local baseComponent = require("fgui.base.baseComponent")
local Com_rankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_rankSingle", Com_rankSingle)
function Com_rankSingle:onInit()
	self.reward, _ENV = nil, nil
	self.fields.Com_rankBase:getChild("bg_rank"):setVisible(false)
	self.fields.Com_rankBase:setTextRankSize(cc.size(80, 80))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:fixPos()
end
function Com_rankSingle:onShow()
end
function Com_rankSingle:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_rankSingle:initData(data, param)
	_ENV = nil
	;(nil).rank = data.rank
	self.fields.Com_rankBase:initRankBaseData(nil)
	local isPersonHonor = param and param.isPersonHonor
	if isPersonHonor then
		local rank = data.rank
		local rankStr = i18n("item_name_1701") .. "\n" .. string.format("%d-%d", rank[1], rank[2])
		self.fields.Com_rankBase:setRank(rankStr)
	end
	self.reward = data.reward
	self.fields.List:setNumItems(#self.reward)
	self.fields.List:setScrollEnable(#self.reward > 6)
end
return Com_rankSingle
