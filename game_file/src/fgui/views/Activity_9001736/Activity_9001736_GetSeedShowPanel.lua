local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001736_GetSeedShowPanel = class("Activity_9001736_GetSeedShowPanel", baseFguiPanel)
function Activity_9001736_GetSeedShowPanel:ctor(...)
	Activity_9001736_GetSeedShowPanel.super.ctor(self, ...)
	print("Activity_9001736_GetSeedShowPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001736
	self.itemIdList = activity_9001736_Ctrl:getItemIdList()
	self.isCantCloseByReturn = true
end
function Activity_9001736_GetSeedShowPanel:onInit()
	print("=======Activity_9001736_GetSeedShowPanel:onInit")
	self.transitions.show_left:setHook("show", handler(self, self.showReward))
	self.transitions.show_right:setHook("show", handler(self, self.showReward))
	if SoraDFIsRA() then
		self.fields.Image_left:setURL("frame_9001736_gjkp.png")
		self.fields.Image_left2:setURL("frame_9001736_gjkp.png")
		self.fields.Image_right:setURL("frame_9001736_ptkp.png")
	else
		self.fields.Image_left:setURL("frame_9001736_ptkp.png")
		self.fields.Image_left2:setURL("frame_9001736_ptkp.png")
		self.fields.Image_right:setURL("frame_9001736_gjkp.png")
	end
end
function Activity_9001736_GetSeedShowPanel:onExit()
	print("=======Activity_9001736_GetSeedShowPanel:onExit")
	local proxy = uiManager:getProxy("Activity_9001736_GetSeed")
	if proxy then
		local panel = proxy:getPanel()
		panel:showInShow()
	end
end
function Activity_9001736_GetSeedShowPanel:endShow()
	print("=======Activity_9001736_GetSeedShowPanel:endShow")
	local itemId = self.param.itemId or 0
	local isSliver = itemId == self.itemIdList[1]
	self.fields.Usm_gold:setVisible(not isSliver)
	self.fields.Usm_sliver:setVisible(isSliver)
	local t_show
	if isSliver then
		if SoraDFIsRA() then
			t_show = self.transitions.show_right
		else
			t_show = self.transitions.show_left
		end
	elseif SoraDFIsRA() then
		t_show = self.transitions.show_left
	else
		t_show = self.transitions.show_right
	end
	t_show:play(function()
		self:closePanel()
		local proxy = uiManager:getProxy("Activity_9001736_GetSeedReward")
		if proxy then
			local panel = proxy:getPanel()
			panel:showBgBlack()
		end
	end)
end
function Activity_9001736_GetSeedShowPanel:showReward()
	local param = self.param
	uiManager:show("Activity_9001736_GetSeedReward", self.param)
end
return Activity_9001736_GetSeedShowPanel
