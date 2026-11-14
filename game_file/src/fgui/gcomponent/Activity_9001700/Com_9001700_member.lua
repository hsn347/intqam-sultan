local activity_9001700_Ctrl = SoraDGetCtrl("activity_9001700_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001700_member = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001700/Com_9001700_member", Com_9001700_member)
function Com_9001700_member:onInit()
	self.fields.Button_send:setString(i18n("common_text_3644"))
	self.fields.Button_send:addClickListener(handler(self, self.onClickBtnSend))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_9001700_member:onShow()
end
function Com_9001700_member:onClickBtnSend()
	SoraDPlaySound()
	local dailyRemindManager = include("dailyRemindManager")
	local rType = dailyRemindManager.REMIND_TYPE.activity_9001770_2
	if dailyRemindManager.checkNeedRemind(rType) then
		_ENV = nil
		;(nil).idx = self.idx
		;(nil).data = self.data
		;(nil).parentPanel = self.parentPanel
		uiManager:show("Activity_9001700_Sure", nil)
	else
		activity_9001700_Ctrl:reqGive(self.idx, self.data.uid)
		if self.parentPanel then
			SoraDShowLoading(self.parentPanel)
		end
	end
end
function Com_9001700_member:initData(idx, data)
	self.idx = idx
	self.data = data
	self.fields.Com_head:setHeadSprite(data.iconID, data.avatar)
	local kid = data.kid or data.partition or data.sourceKid
	local nameStr = textParser.formatPlayerName(nil, data.nickName, kid)
	self.fields.Text_name:setString(nameStr)
end
function Com_9001700_member:setParentPanel(parentPanel)
	self.parentPanel = parentPanel
end
return Com_9001700_member
