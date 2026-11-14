local publicRead = include("publicRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_useSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Chaser/Com_useSingle", Com_useSingle)
fgui.register_extension("ui://Chaser/Com_useSingle2", Com_useSingle)
function Com_useSingle:onInit()
	self.fields.btn_use:setString(i18n("common_text_314"))
	self.fields.btn_use:addClickListener(handler(self, self.onClickUse))
	self:fixChildrenPos()
end
function Com_useSingle:onShow()
end
function Com_useSingle:initData(data, parent)
	self.data = data
	self.parent = parent
	self.fields.btn_use:setEnabled(self.data.count > 0)
	self.fields.com_item:initData(self.data.id, self.data.count)
	self.fields.text_name:setString(publicRead.getName(self.data.id))
	self.fields.text_des:setString(publicRead.getDes(self.data.id))
	if backpackltCtrl:getResultType(self.data.id) == gItemEffectDef.MERGE_FRAGMENG then
		self.fields.btn_use:setString(i18n("common_text_1352"))
	else
		self.fields.btn_use:setString(i18n("common_text_314"))
	end
end
function Com_useSingle:onClickUse()
	SoraDPlaySound()
	include("itemLogic").useItemsLine(self.data.id, self.data.count)
	if self.parent then
		self.parent:close()
	end
end
return Com_useSingle
