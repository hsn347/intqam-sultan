local baseComponent = require("fgui.base.baseComponent")
local List_rank = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingdomBattle/List_rank", List_rank)
function List_rank:onInit()
	self:fixChildrenPos()
end
function List_rank:onShow()
end
function List_rank:initData(data)
	for i = 1, 3 do
		if data["data" .. i] then
			self.fields["rank_" .. i]:setVisible(true)
			self.fields["rank_" .. i]:initData(data["data" .. i])
		else
			self.fields["rank_" .. i]:setVisible(false)
		end
	end
end
return List_rank
