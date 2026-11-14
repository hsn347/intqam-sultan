local activityCommonMergeCtrl = SoraDGetCtrl("activityCommonMergeCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_postSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001663/Com_postSingle", Com_postSingle)
function Com_postSingle:onInit()
	self.fields.Button_post:setString(i18n("bubble_party_text_18"))
	self.fields.Button_post:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
	self.fields.arrow:setRotation(SoraDFIsRA() and -90 or 90)
end
function Com_postSingle:onShow()
end
function Com_postSingle:setActivityID(activityID)
	self.activityID = activityID
end
function Com_postSingle:initData(data)
	self.data = data
	dump(self.data, "self.data==")
	self.fields.Com_item_cost:initData(self.data.post.need)
	self.fields.Com_item_get:initData(self.data.post.offer)
	self.fields.Text_name:setString(self.data.name)
end
function Com_postSingle:btnClick()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.data.post.need) < 1 then
		SoraDShowMsgTip(i18n("bubble_party_text_20"))
		return
	end
	activityCommonMergeCtrl:reqExchangeDeal(self.activityID, self.data.kid, self.data.uid, self.data.post)
end
return Com_postSingle
