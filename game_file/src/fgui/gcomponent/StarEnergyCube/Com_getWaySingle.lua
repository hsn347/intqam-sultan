local jumpDesRead = include("jumpDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_getWaySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarEnergyCube/Com_getWaySingle", Com_getWaySingle)
function Com_getWaySingle:onInit()
	self:fixChildrenPos()
	self.fields.Button_go:setTitleText(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickGo))
end
function Com_getWaySingle:initData(index, sourceId, callbackFunc)
	local itemCfg = jumpDesRead.getCfg(sourceId)
	self.sourceId = sourceId
	self.callbackFunc = callbackFunc
	if itemCfg then
		if sourceId == 14 then
			self.fields.text_des:setString(i18n("dress_text_200"))
		else
			self.fields.text_des:setString(i18n(itemCfg.des))
		end
		self.fields.img_icon:setURL(itemCfg.icon)
	end
end
function Com_getWaySingle:onClickGo()
	self.callbackFunc(self.sourceId)
end
function Com_getWaySingle:onShow()
end
return Com_getWaySingle
