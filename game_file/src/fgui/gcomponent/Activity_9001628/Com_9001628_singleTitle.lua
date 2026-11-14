local baseComponent = require("fgui.base.baseComponent")
local Com_9001628_singleTitle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001628/Com_9001628_singleTitle", Com_9001628_singleTitle)
function Com_9001628_singleTitle:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_9001628_singleTitle:onShow()
end
function Com_9001628_singleTitle:initData(packageInfo, price)
	_ENV = nil
	;(nil).price = price
	self.fields.txtPackageTitle:setString(i18n("anniversary_text_10", nil))
	dump(packageInfo, "packageInfo")
	local m = packageInfo
	_UPVALUE2_ = i18n("anniversary_text_10", nil)
	i18n("anniversary_text_10", nil)[1] = "id"
	i18n("anniversary_text_10", nil)[2] = "count"
	local rewardList = serviceFunctions.tableFormat(m.result, i18n("anniversary_text_10", nil))
	self.rewardList = rewardList
	self.fields.List_reward:setNumItems(#self.rewardList)
end
function Com_9001628_singleTitle:onItemRenderer(index, obj)
	local data = self.rewardList[index + 1]
	obj:initData(data.id, data.count)
end
return Com_9001628_singleTitle
