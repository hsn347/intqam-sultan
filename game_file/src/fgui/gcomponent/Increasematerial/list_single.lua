local jumpDesRead = include("jumpDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local list_single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Increasematerial/list_single", list_single)
function list_single:onInit()
	self:fixChildrenPos()
	self.fields.btn:addClickListener(handler(self, self.onBtnCallBack))
end
function list_single:onShow()
end
function list_single:initData(sourceId)
	self.sourceId = sourceId
	print(sourceId, "sourceId")
	self.info = jumpDesRead.getCfg(sourceId)
	if self.info.name and self.info.name ~= "" then
		self.fields.text_title:setString(i18n(self.info.name))
	end
	self.fields.text_des:setString(i18n(self.info.des))
	if self.info.guide.use_item then
		self.fields.btn:setTitleText(i18n("common_text_314"))
		self.controllers.c1:setSelectedIndex(0)
		self.fields.com_Item:initData(self.info.guide.use_item)
		local itemNum = backpackCtrl:getItemCount(self.info.guide.use_item)
		self.fields.btn:setBright(0 < itemNum)
	else
		self.fields.btn:setTitleText(i18n("common_text_477"))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.icon:setURL(self.info.icon)
	end
	self.controllers.c2:setSelectedIndex(self.info.hasJump == 1 and 0 or 1)
end
function list_single:onBtnCallBack()
	if self.info.guide.use_item and backpackCtrl:getItemCount(self.info.guide.use_item) <= 0 then
		SoraDShowMsgTip(i18n("Glory_text_61"))
	else
		SoraDJumpBySourceId(self.sourceId)
	end
end
return list_single
