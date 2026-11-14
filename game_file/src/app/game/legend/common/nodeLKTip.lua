local nodeLKTip = class("nodeLKTip", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateTouchPanel("nodeLKTip")
		end
		if type(target) == "string" then
			return SoraDCreateTouchPanel(target)
		end
		return target
	end
end)
function nodeLKTip:ctor()
	self:createUI()
	self.nodeBgBox_node = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeBgBox_node")
	self.Center_Node_Des = SoraDGetChildByName(self, "Center_Node_Des")
	self.Text_Desc = SoraDGetChildByName(self, "Text_Desc")
	self.Button_Confirm = SoraDGetChildByName(self, "Button_Confirm")
	self.Button_Confirm:addTouchEventListener(handler(self, self.onClick_Button_Confirm))
	self.Button_Confirm:setTitleText(i18n("common_text_204"))
end
function nodeLKTip:createUI()
end
function nodeLKTip:init(data)
	if data.title then
		self.nodeBgBox_node:setTitle(data.title or "")
		self.Text_Desc:setString(data.content or "")
	end
end
function nodeLKTip:onMessageListener()
end
function nodeLKTip:onClick_Button_Confirm(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:closePanel()
	end
end
return nodeLKTip
