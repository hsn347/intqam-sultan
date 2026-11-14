local activityTimeRead = include("activityTimeRead")
local cheatCtrl = SoraDGetCtrl("cheatCtrl")
local baseComponent = require("fgui.base.baseComponent")
local QuickActivity = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://test/QuickActivity", QuickActivity)
function QuickActivity:onInit()
	self.fields.Button_open:setString("开启活动")
	self.fields.Button_close:setString("关闭活动")
	self.fields.Button_stage:setString("下一阶段")
	self.fields.Button_item:setString("活动物品")
	self.fields.Button_recharge:setString("充值")
	self.fields.Button_open:addClickListener(handler(self, self.onClickOpen))
	self.fields.Button_close:addClickListener(handler(self, self.onClickClose))
	self.fields.Button_stage:addClickListener(handler(self, self.onClickStage))
	self.fields.Button_item:addClickListener(handler(self, self.onClickItem))
	self.fields.Button_recharge:addClickListener(handler(self, self.onClickRecharge))
end
function QuickActivity:req(command, param)
	print("发送指令", command, param)
	_ENV = param
	param.command = command
	param.param = param
	cheatCtrl:reqCheat(nil, param)
end
function QuickActivity:onClickOpen()
	local command = self.data.activityType == 2 and "szfzhd" or "sztyhd"
	local extra = self.data.activityExtra or ",1,1"
	if string.len(extra) > 0 and string.sub(extra, 0, 1) ~= "," then
		extra = "," .. extra
	end
	local param = self.data.activityID .. extra
	self:req(command, param)
end
function QuickActivity:onClickClose()
	if self.data.activityType == 2 then
		self:req("gbfzhd", self.data.activityID)
	else
		self:req("jshd", self.data.activityID .. ",1")
	end
end
function QuickActivity:onClickStage()
	local command = self.data.activityType == 2 and "xyfzhdjd" or "xyhdjd"
	self:req(command, self.data.activityID)
end
function QuickActivity:onClickItem()
	local str = self.fields.Input_num:getText()
	local num = tonumber(str)
	num = num or 1
	local _ENV, data = str, str
	_ENV = nil
	;(nil).id = self.data.activityItemID
	;(nil).count = num
	table.insert(data, nil)
	cheatCtrl:reqAddGameItem(data)
	self:setActivityItemNum(num)
end
function QuickActivity:onClickRecharge()
	self:req("czbd", self.data.rechargeID)
	uiManager:close("test")
end
function QuickActivity:getActivitySaveData()
