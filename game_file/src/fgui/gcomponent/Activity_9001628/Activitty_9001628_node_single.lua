local baseComponent = require("fgui.base.baseComponent")
local Activitty_9001628_node_single = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001628_Ctrl = SoraDGetCtrl("activity_9001628_Ctrl")
fgui.register_extension("ui://Activity_9001628/Activitty_9001628_node_single", Activitty_9001628_node_single)
function Activitty_9001628_node_single:onInit()
	self.txtTask = SoraDGetChildByName(self, "Text_7")
	self.loadingBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.btnGet = SoraDGetChildByName(self, "Button_15")
	self.cellSprite = SoraDGetChildByName(self, "Image_16")
	self.cellSpriteBg = SoraDGetChildByName(self, "Image_15")
	self.list_reward = SoraDGetChildByName(self, "list_reward")
	self.list_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.btnGet:addClickEventListener(handler(self, self.onGetClick))
	self.txtTask:fixPos()
	self.loadingBar:fixPos()
	self.btnGet:fixPos()
	self.cellSprite:fixPos()
	self.cellSpriteBg:fixPos()
	self.loadingBar:fixChildrenPos()
end
function Activitty_9001628_node_single:onShow()
end
function Activitty_9001628_node_single:initData(data)
	self.data = data
	local comStr = ""
	local progressStr = ""
	local taskImage = ""
	local taskImageBg = ""
	local curCount = 0
	if data.type == gNTHAchiTaskType.castDiceTotalCount then
		comStr = i18n("anniversary_dice_text_09") .. "：" .. data.require
		curCount = activity_9001628_Ctrl:getTotalThrowTimes()
		taskImage = "icon_znxb_task_03.png"
		taskImageBg = "frame_znxb_cellbg_blue.png"
	elseif data.type == gNTHAchiTaskType.stepBeforeTotalCount then
		comStr = i18n("anniversary_dice_text_10") .. "：" .. data.require
		curCount = activity_9001628_Ctrl:getTotalStepCount()
		taskImage = "icon_znxb_task_01.png"
		taskImageBg = "frame_znxb_cellbg_green.png"
	elseif data.type == gNTHAchiTaskType.roundTotalCount then
		comStr = i18n("anniversary_dice_text_11") .. "：" .. data.require
		curCount = activity_9001628_Ctrl:getTotalRoundCount()
		taskImage = "icon_znxb_task_02.png"
		taskImageBg = "frame_znxb_cellbg_purple.png"
	end
	progressStr = curCount .. "/" .. data.require
	self.txtTask:setString(comStr)
	self.loadingBar:setMax(data.require)
	self.loadingBar:setValue(curCount)
	self.cellSprite:setURL(taskImage)
	self.cellSpriteBg:setURL(taskImageBg)
	dump(data.uniqueID, "data.uniqueID")
	local isClaimed = activity_9001628_Ctrl:isRewardClaimed(data.type, data.uniqueID)
	self.btnGet:setTitleText(curCount >= data.require and isClaimed and i18n("common_text_1892") or i18n("common_text_677"))
	self.btnGet:setTouchEnabled(curCount >= data.require and not isClaimed)
	self.btnGet:setBright(curCount >= data.require and not isClaimed)
	_UPVALUE2_ = curCount >= data.require and not isClaimed
	;(curCount >= data.require and not isClaimed)[1] = "id"
	;(curCount >= data.require and not isClaimed)[2] = "count"
	self.rewardList = serviceFunctions.tableFormat(data.reward, curCount >= data.require and not isClaimed)
	self.list_reward:setNumItems(#self.rewardList)
end
function Activitty_9001628_node_single:setClickHandler(callback)
	self.clickCallback = callback
end
function Activitty_9001628_node_single:onGetClick()
	if self.clickCallback and self.data then
		self.clickCallback(self.data.uniqueID, self.data.type)
	end
end
function Activitty_9001628_node_single:onItemRenderer(index, obj)
	local data = self.rewardList[index + 1]
	obj:initData(data.id, data.count)
end
return Activitty_9001628_node_single
