local activityDropRead = include("activityDropRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_taskSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001678/Com_taskSingle", Com_taskSingle)
function Com_taskSingle:onInit()
	self:fixChildrenPos()
end
function Com_taskSingle:onShow()
end
function Com_taskSingle:initData(data, itemGetCount)
	self.fields.Text_name:setString(data.name)
	self.fields.Text_des:setString(data.des)
	local dropCount = itemGetCount[tostring(data.dropType)] or 0
	local dropMax = activityDropRead.getMaxDrop(gActivityTimeActivityID.FROSTY_MARKET_DROP, data.dropType)
	_ENV = nil
	;(nil).num1 = dropCount
	;(nil).num2 = dropMax
	self.fields.Text_count:setString(i18n("emission_nebulae_text_5", nil))
end
return Com_taskSingle
