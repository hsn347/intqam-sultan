local baseComponent = require("fgui.base.baseComponent")
local Com_weekCampSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_weekCampSingle", Com_weekCampSingle)
function Com_weekCampSingle:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
end
function Com_weekCampSingle:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_weekCampSingle:onShow()
end
function Com_weekCampSingle:initData(data, param)
	_ENV = nil
	;(nil).num1 = data.rank[1]
	;(nil).num2 = data.rank[2]
	self.fields.Text_point:setString(i18n("%{num1}-%{num2}", nil))
	self.reward = data.reward
	self.fields.List:setNumItems(#self.reward)
	self.fields.List:setScrollEnable(#self.reward > 5)
	local isPersonHonor = param and param.isPersonHonor or false
	if isPersonHonor then
		self.fields.Text_score:setString(i18n("item_name_1701"))
	else
		self.fields.Text_score:setString(i18n("flames_dunes_text39"))
	end
end
return Com_weekCampSingle
