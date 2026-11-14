local baseComponent = require("fgui.base.baseComponent")
local Com_List9 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_List9", Com_List9)
function Com_List9:onInit()
	self.rewardList, _ENV = nil, nil
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_List9:onShow()
end
function Com_List9:onItemRenderer(index, obj)
	obj:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
function Com_List9:initData(data, index)
	if #data.rank > 1 then
		_ENV = nil
		_ENV = nil
		;(nil).min = data.rank[1]
		;(nil).max = data.rank[2]
		;(nil).title = i18n("common_text_1770", nil)
		self.fields.title:setString(i18n("common_text_1915", nil))
	elseif index == data.rank[1] then
		_ENV = i18n("common_text_1915", nil)
		i18n("common_text_1915", nil).lv = data.rank[1]
		i18n("common_text_1915", nil).name = ""
		self.fields.title:setString(i18n("common_text_1763", i18n("common_text_1915", nil)))
	else
		_ENV = i18n("common_text_1763", i18n("common_text_1915", nil))
		i18n("common_text_1763", i18n("common_text_1915", nil)).lv = tostring(data.rank[1] - 1) .. "+"
		i18n("common_text_1763", i18n("common_text_1915", nil)).name = ""
		self.fields.title:setString(i18n("common_text_1763", i18n("common_text_1763", i18n("common_text_1915", nil))))
	end
	self.rewardList = data.rewards
	self.fields.List:setNumItems(#self.rewardList)
end
return Com_List9
