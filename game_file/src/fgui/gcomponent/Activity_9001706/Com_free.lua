local activity_9001706_Ctrl = SoraDGetCtrl("activity_9001706_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_free = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001706/Com_free", Com_free)
function Com_free:onInit()
	self.fields.Text_got:setString(i18n("common_text_1892"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
end
function Com_free:onItemRenderer(index, obj)
	obj:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
	obj:setStatus(self.isClaimed and 3 or 2)
end
function Com_free:onShow()
end
function Com_free:initData(cfg)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.rewardList = serviceFunctions.tableFormat(cfg.freeReward, nil)
	local status = 0
	local doStage = activity_9001706_Ctrl:getDoStage()
	local month = activity_9001706_Ctrl:getCurMonth()
	self.isClaimed = false
	if doStage == 1 then
		self.fields.title:setString(i18n("common_text_1696"))
		self.isClaimed = activity_9001706_Ctrl:isClaimedSerFreeReward(month)
		status = self.isClaimed and 1 or 0
	else
		self.fields.title:setString(i18n("Sultan_present_text_15"))
	end
	self.controllers.c1:setSelectedIndex(status)
	self.fields.List:setNumItems(#self.rewardList)
end
return Com_free
