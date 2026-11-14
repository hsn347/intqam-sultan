local activity_9001700_Read = include("activity_9001700_Read")
local activity_9001700_Ctrl = SoraDGetCtrl("activity_9001700_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001700_MainPanel = class("Activity_9001700_MainPanel", baseFguiPanel)
function Activity_9001700_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001700_MainPanel.super.ctor(self, ...)
	print("Activity_9001700_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001700
end
function Activity_9001700_MainPanel:onInit()
	print("=======Activity_9001700_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_task:setString(i18n("eid_fireworks_003"))
	self.fields.Button_task:addClickListener(handler(self, self.onClickBtnTask))
	self.fields.Button_bag:setString(i18n("eid_fireworks_004"))
	self.fields.Button_bag:addClickListener(handler(self, self.onClickBtnBag))
	self.fields.Button_letOff:setString(i18n("eid_fireworks_030"))
	self.fields.Button_letOff:addClickListener(handler(self, self.onClickBtnLetOff))
	self.fields.List_mate:setItemRenderer(handler(self, self.onItemRenderer))
	_UPVALUE2_ = self.fields.List_mate.setItemRenderer
	self.Com_fireworkCardList, self.fields.List_mate.setItemRenderer[1] = self.fields.List_mate.setItemRenderer, self.fields.Com_fireworkCard1
	self.Com_fireworkCardList, self.fields.List_mate.setItemRenderer[2] = self.fields.List_mate.setItemRenderer, self.fields.Com_fireworkCard2
	for fireType, widget in ipairs(self.Com_fireworkCardList) do
		widget:initData(fireType)
	end
	self.fields.Text_tip:setString(i18n("eid_fireworks_009"))
end
function Activity_9001700_MainPanel:endShow()
	print("=======Activity_9001700_MainPanel:endShow")
	self.materialIDList = activity_9001700_Read.getMaterialIDList()
	self:updateMaterial()
	self:updateItemCount()
	self:updateBtnTask()
	self:updateBtnBag()
	self:updateBtnMake()
	self:updateBtnLetOff()
end
function Activity_9001700_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("eid_fireworks_002")
	uiManager:show("RuleView", nil)
end
function Activity_9001700_MainPanel:onClickBtnTask()
	SoraDPlaySound()
	uiManager:show("Activity_9001700_Task")
end
function Activity_9001700_MainPanel:onClickBtnBag()
	SoraDPlaySound()
	uiManager:show("Activity_9001700_Bag")
end
function Activity_9001700_MainPanel:onClickBtnLetOff()
	SoraDPlaySound()
	activity_9001700_Ctrl:onClickBtnLetOff()
end
function Activity_9001700_MainPanel:onItemRenderer(index, obj)
	local materialID = self.materialIDList[index + 1]
	obj:initData(materialID, handler(self, self.addMaterialCallback))
	local resCount = activity_9001700_Ctrl:getResCount(materialID)
	obj:updateNum(resCount)
end
function Activity_9001700_MainPanel:addMaterialCallback(...)
	uiManager:show("Activity_9001700_Task")
end
function Activity_9001700_MainPanel:updateMaterial(...)
	self.fields.List_mate:setNumItems(#self.materialIDList)
end
function Activity_9001700_MainPanel:updateItemCount(...)
	for fireType, widget in ipairs(self.Com_fireworkCardList) do
		widget:updateItemCount()
	end
end
function Activity_9001700_MainPanel:updateBtnTask(...)
	local ret, num = activity_9001700_Ctrl:getTaskRedNum(...)
	self.fields.Button_task:setReddot(ret, num)
end
function Activity_9001700_MainPanel:updateBtnBag(...)
	local ret = activity_9001700_Ctrl:getBtnBagRedNum(...)
	self.fields.Button_bag:setReddot(ret)
end
function Activity_9001700_MainPanel:updateBtnMake(...)
	for fireType, widget in ipairs(self.Com_fireworkCardList) do
		widget:updateBtnMake()
	end
end
function Activity_9001700_MainPanel:updateBtnLetOff(...)
	local isRed = activity_9001700_Ctrl:getLetOffRedNum2() or false
	self.fields.Button_letOff:setVisible(isRed)
	if isRed then
		self.fields.Button_letOff:setReddot(true)
	end
end
function Activity_9001700_MainPanel:onMsgUpdateData(target, event)
	local subMsg = event.subMsg
	if subMsg == "material" then
		self:updateMaterial()
		self:updateBtnMake()
	elseif subMsg == "itemCount" then
		self:updateItemCount()
		self:updateBtnMake()
	elseif subMsg == "readTime" then
		self:updateBtnBag()
	elseif subMsg == "refreshData" then
		self:updateBtnBag()
	elseif subMsg == "questReward" then
		self:updateBtnTask()
	elseif subMsg == "make" then
		self:updateBtnLetOff()
	end
end
return Activity_9001700_MainPanel
