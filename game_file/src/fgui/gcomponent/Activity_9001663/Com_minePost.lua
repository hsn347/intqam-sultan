local activityCommonMergeCtrl = SoraDGetCtrl("activityCommonMergeCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_minePost = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001663/Com_minePost", Com_minePost)
function Com_minePost:onInit()
	self.chooseMap, _ENV, self.isCancel = nil, nil, false
	self.fields.Button_post:setString(i18n("alliance_btn_01"))
	self.fields.Button_post:addClickListener(handler(self, self.btnPostClick))
	self.fields.Button_post:setBright(false)
	self:fixChildrenPos()
	self.fields.arrow:setRotation(SoraDFIsRA() and -90 or 90)
end
function Com_minePost:onShow()
end
function Com_minePost:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001663_UI_CHOOSE", handler(self, self.initView))
end
function Com_minePost:setActivityID(activityID)
	self.activityID = activityID
	self.fields.Com_cost:setActivityID(self.activityID)
	self.fields.Com_need:setActivityID(self.activityID)
end
function Com_minePost:initData()
	self.costID = nil
	self.chooseMap, activityCommonMergeCtrl, self.needID = nil, nil, nil
	self.post = activityCommonMergeCtrl:getPost(self.activityID)
	self.fields.Com_cost:initData(self.post.offer, 1, self.chooseMap)
	self.fields.Com_need:initData(self.post.need, 2, self.chooseMap)
	self.isCancel = self.post.offer and self.post.need and true or false
	self.fields.Button_post:setString(self.isCancel and i18n("common_text_185") or i18n("alliance_btn_01"))
	self.fields.Button_post:setBright(self.isCancel)
	self.fields.Com_cost:setForbid(self.isCancel)
	self.fields.Com_need:setForbid(self.isCancel)
end
function Com_minePost:initView(target, data)
	self.chooseMap[data.enum] = data.id
	if data.enum == 1 then
		self.costID = data.id
		self.fields.Com_cost:initData(data.id, 1, self.chooseMap)
	elseif data.enum == 2 then
		self.needID = data.id
		self.fields.Com_need:initData(data.id, 2, self.chooseMap)
	end
	self.fields.Button_post:setBright(self.costID and self.needID and true or false)
end
function Com_minePost:btnPostClick()
	SoraDPlaySound()
	if self.isCancel then
		activityCommonMergeCtrl:reqExchangeCancel(self.activityID)
	elseif self.costID and self.needID then
		_ENV = self.needID
		self.needID.offer = self.costID
		self.needID.need = self.needID
		local self.needID.t, post = serviceFunctions.systemTime(), self.needID
		_ENV = nil
		;(nil).activityID = self.activityID
		;(nil).post = post
		uiManager:show("Activity_9001663_share", nil)
	else
		SoraDShowMsgTip(i18n("bubble_party_text_07"))
	end
end
return Com_minePost
