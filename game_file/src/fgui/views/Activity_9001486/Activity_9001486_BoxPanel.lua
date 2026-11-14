local activity_9001486_Ctrl = SoraDGetCtrl("activity_9001486_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001486_BoxPanel = class("Activity_9001486_BoxPanel", baseFguiPanel)
function Activity_9001486_BoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001486_BoxPanel:ctor", self.viewName)
end
function Activity_9001486_BoxPanel:onInit()
	print("=======Activity_9001486_BoxPanel:onInit")
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.Button_receive:setString(i18n("common_text_1146"))
	self.fields.Button_receive:addClickListener(handler(self, self.onClickBtnReceive))
end
function Activity_9001486_BoxPanel:onShow()
	print("=======Activity_9001486_BoxPanel:onShow")
	local data = self.param.data
	self.activityID = self.param.activityID
	local cfg = data.cfg
	self.boxIndex = cfg.Index
	if data.type == 1 then
		self.fields.Panel_bg:setString(i18n("dictatorship_04"))
		_ENV = i18n("dictatorship_04")
		i18n("dictatorship_04").num1 = cfg.days
		i18n("dictatorship_04").num2 = "$" .. cfg.amount
		self.fields.Text_des:setString(i18n("dictatorship_03", i18n("dictatorship_04")))
	elseif data.type == 2 then
		self.fields.Panel_bg:setString(i18n("dictatorship_05"))
		_ENV = i18n("dictatorship_05")
		i18n("dictatorship_05").num1 = "$" .. data.total
		i18n("dictatorship_05").num2 = "$" .. cfg.amount
		self.fields.Text_des:setString(i18n("dictatorship_06", i18n("dictatorship_05")))
	end
	_UPVALUE2_ = i18n("dictatorship_06", i18n("dictatorship_05"))
	i18n("dictatorship_06", i18n("dictatorship_05"))[1] = "id"
	i18n("dictatorship_06", i18n("dictatorship_05"))[2] = "count"
	self.rewards = serviceFunctions.tableFormat(cfg.reward, i18n("dictatorship_06", i18n("dictatorship_05")))
	self.fields.List_reward:setNumItems(#self.rewards)
	self:updateBoxState()
end
function Activity_9001486_BoxPanel:onRewardItemRenderer(index, obj)
	local data = self.rewards[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001486_BoxPanel:onClickBtnReceive(...)
	SoraDPlaySound()
	activity_9001486_Ctrl:reqClaim(self.activityID, self.boxIndex)
	SoraDShowLoading(self:displayObject())
end
function Activity_9001486_BoxPanel:updateBoxState()
	local data = self.param.data
	local cfg = data.cfg
	if data.isReceived then
		self.fields.Button_receive:setVisible(false)
		self.fields.Text_progress:setVisible(true)
		self.fields.Text_progress:setColor(cc.c3b(255, 255, 255))
		self.fields.Text_progress:setString(i18n("common_text_1892"))
		return
	end
	if data.canReceive then
		self.fields.Button_receive:setVisible(true)
		self.fields.Text_progress:setVisible(false)
	else
		self.fields.Button_receive:setVisible(false)
		self.fields.Text_progress:setVisible(true)
		self.fields.Text_progress:setColor(cc.c3b(255, 0, 0))
		if data.type == 1 then
			_ENV = cc.c3b(255, 0, 0)
			cc.c3b(255, 0, 0).member = data.achieveDay
			cc.c3b(255, 0, 0).total = cfg.days
			self.fields.Text_progress:setString(i18n("common_text_155", cc.c3b(255, 0, 0)))
		elseif data.type == 2 then
			_ENV = i18n("common_text_155", cc.c3b(255, 0, 0))
			i18n("common_text_155", cc.c3b(255, 0, 0)).member = data.total
			i18n("common_text_155", cc.c3b(255, 0, 0)).total = cfg.amount
			self.fields.Text_progress:setString(i18n("common_text_155", i18n("common_text_155", cc.c3b(255, 0, 0))))
		end
	end
end
return Activity_9001486_BoxPanel
