local activity_9001492_Ctrl = SoraDGetCtrl("activity_9001492_Ctrl")
local activityTimeRead = include("activityTimeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001492_MainPanel = class("Activity_9001492_MainPanel", baseFguiPanel)
function Activity_9001492_MainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001492_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.STAR_LIGHT_LAMP_ACTIVITY
end
function Activity_9001492_MainPanel:onInit()
	print("=======Activity_9001492_MainPanel:onInit")
	_UPVALUE2_ = nil
	;(nil)[1] = "ar"
	;(nil)[2] = "en"
	local imageName = SoraDGetImageNameByLang("img_startreasury_%s.png", nil)
	self.fields.Image_title:setURL(imageName)
	_ENV = self.fields.Image_title.setURL
	self.fields.Image_title.setURL[1] = i18n("bubbleActivity_text_02")
	self.fields.Image_title.setURL[2] = i18n("bubbleActivity_text_03")
	local self.fields.Image_title.setURL[3], config = i18n("bubbleActivity_text_04"), self.fields.Image_title.setURL
	local classType = activity_9001492_Ctrl:getClassType()
	self.fields.Text_des:setString(config[classType])
	self.fields.Label_time:initActivityTime(self.activityID)
	self.fields.Button_receive:addClickListener(handler(self, self.onClickBtnReceive))
	self:initRewards()
	self:updateBtnState()
	self.fields.Usm_1:setPrepareCallback(function()
		self.fields.Usm_1:getCriSprite():start()
		self.fields.Image_bg:setVisible(false)
	end)
end
function Activity_9001492_MainPanel:onShow()
	print("=======Activity_9001492_MainPanel:onShow")
end
function Activity_9001492_MainPanel:onClickBtnReceive(...)
	SoraDPlaySound()
	activity_9001492_Ctrl:reqReward()
	SoraDShowLoading(self:displayObject())
end
function Activity_9001492_MainPanel:initRewards(...)
	local classType = activity_9001492_Ctrl:getClassType()
	self.rewards = activityTimeRead.getActivityReward(self.activityID, classType)
	for i = 1, 5 do
		local Com_icon = self.fields["Com_icon" .. i]
		if Com_icon then
			self:initRewardSingle(Com_icon, self.rewards[i])
		end
	end
end
function Activity_9001492_MainPanel:initRewardSingle(Com_icon, data)
	if data then
		Com_icon:setVisible(true)
		local _fields = fguiHelper.get_fields(Com_icon)
		_fields.item:initData(data.id)
		_fields.item:hideFrameAndQuality()
		_fields.Text_num:setString(data.count)
		_fields.mv_item:setAllFrameName("dh_xxdd_kuang_%02d.png", 1)
	else
		Com_icon:setVisible(false)
	end
end
function Activity_9001492_MainPanel:updateBtnState(...)
	local Button_receive = self.fields.Button_receive
	if activity_9001492_Ctrl:getHasReceived() then
		Button_receive:setString(i18n("common_text_1892"))
		Button_receive:setEnabled(false)
	else
		Button_receive:setString(i18n("common_text_1146"))
		Button_receive:setEnabled(true)
	end
end
return Activity_9001492_MainPanel
