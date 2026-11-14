local jumpDesRead = include("jumpDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://JerseyActivity/Com_list", Com_list)
function Com_list:onInit()
	self:fixChildrenPos()
	self.fields.Button_jump:setTitleText(i18n("common_text_477"))
	self.fields.Button_jump:addClickListener(handler(self, self.onClickGo))
end
function Com_list:onShow()
end
function Com_list:initData(sourceId)
	local itemCfg = jumpDesRead.getCfg(sourceId)
	self.sourceId = sourceId
	if itemCfg then
		if sourceId == 14 then
			self.fields.Text_item:setString(i18n("dress_text_200"))
		else
			self.fields.Text_item:setString(i18n(itemCfg.des))
		end
	end
end
function Com_list:onClickGo()
	SoraDPlaySound()
	SoraDJumpBySourceId(self.sourceId, self.otherData)
end
return Com_list
