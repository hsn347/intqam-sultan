local activityDropRead = include("activityDropRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001702_drop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001702/Com_9001702_drop", Com_9001702_drop)
function Com_9001702_drop:onInit()
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001702_DROP
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_9001702_drop:onShow()
end
function Com_9001702_drop:initData(dropType, dropCount)
	self.dropType = dropType
	local cfg = activityDropRead.getDropTypeConfig(dropType)
	self.fields.icon:setURL(cfg.icon)
	self.fields.Text_name:setString(cfg.des)
	local dropMax = activityDropRead.getMaxDrop(self.activityID, cfg.dropType)
	activityDropRead = nil
	;(nil).count = dropCount
	;(nil).total = dropMax
	local countStr = i18n("Nebula_Celebration_text18", nil)
	self.fields.Text_count:setString(countStr)
end
function Com_9001702_drop:onClickBtnGo()
	SoraDPlaySound()
	activityDropRead.clickBtnGo(self.dropType)
end
return Com_9001702_drop
