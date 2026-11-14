local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HomePopupPanel = class("HomePopupPanel", baseFguiPanel)
function HomePopupPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HomePopupPanel:ctor", self.viewName)
end
function HomePopupPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HomePopupPanel:onInit()
	print("=======HomePopupPanel:onInit")
	self.activityList = self.proxy:getActivityList()
	self.itemMax = #self.activityList
	local dailyRemindManager = include("dailyRemindManager")
	local key = dailyRemindManager.REMIND_TYPE.homePopupPanel
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:MainCityView:popActivity~table", nil) then
		local _ENV, popList = SoraDConfigGet("Game:MainCityView:popActivity~table", nil), SoraDConfigGet("Game:MainCityView:popActivity~table", nil)
	end
	if dailyRemindManager.checkNeedRemind(key) then
		dailyRemindManager.addRemindToManager(key)
		self.curSelect = 1
	else
		for k, v in ipairs(self.activityList) do
			if not popList[tostring(v)] then
				self.curSelect = k
				break
			end
		end
		self.curSelect = self.curSelect or 1
	end
	print("弹活动========", self.curSelect, self.activityList[self.curSelect])
	if table.nums(popList) < 3 then
		popList[tostring(self.activityList[self.curSelect])] = serviceFunctions.systemTime()
		_ENV = self.activityList[self.curSelect]
		self.activityList[self.curSelect].byUID = true
		SoraDConfigSet("Game:MainCityView:popActivity~table", popList, self.activityList[self.curSelect])
	end
	self.fields.List_point:setNumItems(self.itemMax)
	self.fields.Button_left:addClickListener(handler(self, self.onClickLeft))
	self.fields.Button_right:addClickListener(handler(self, self.onClickRight))
end
function HomePopupPanel:onShow()
	print("=======HomePopupPanel:onShow")
	self:refreshCurSelect()
end
function HomePopupPanel:onClickLeft(EventContext)
	SoraDPlaySound()
	SoraDShowLoading()
	self.curSelect = self.curSelect - 1
	if self.curSelect < 1 then
		self.curSelect = self.itemMax
	end
	self.transitions.over:play(function()
		self:refreshCurSelect()
	end)
end
function HomePopupPanel:onClickRight(EventContext)
	SoraDPlaySound()
	SoraDShowLoading()
	self.curSelect = self.curSelect + 1
	if self.curSelect > self.itemMax then
		self.curSelect = 1
	end
	self.transitions.over:play(function()
		self:refreshCurSelect()
	end)
end
function HomePopupPanel:refreshCurSelect(...)
	SoraDCloseLoading()
	self.transitions.begin:play()
	local selectedIndex = self:getRealSelectedIndex(self.curSelect)
	self.fields.List_point:setSelectedIndex(selectedIndex)
	self:refreshComPage()
end
function HomePopupPanel:refreshComPage()
	local obj = self.fields.Com_page
	if not obj.isInit then
		obj.isInit = true
		obj.fields = fguiHelper.get_fields(obj)
		obj.fields.Com_icon:getChild("Load_mask"):setTexture("SinglePicture/mask_HomePopup.png")
		obj.fields.Label_time = SoraDCreateTimerLabel(self, obj.fields.Label_time:getChild("title"))
		local Button_go = obj.fields.Com_buttonGo:getChild("Button_normal")
		Button_go:setString(i18n("common_text_477"))
		Button_go:addClickListener(handler(self, self.onClickGo))
		obj.bgIcon = obj.fields.Com_icon:getChild("icon")
		obj.bgPosy = obj.bgIcon:getY()
	end
	local activityID = self.activityList[self.curSelect]
	local classtype = activityShowCtrl:getParamClassType(activityID)
	local data = self.proxy:getConfigData(activityID, classtype)
	obj.bgIcon:setScale(data.bgscale)
	obj.bgIcon:setURL(data.background)
	if data.offsety and data.offsety > 0 then
		obj.bgIcon:setY(obj.bgPosy + data.offsety)
	else
		obj.bgIcon:setY(obj.bgPosy)
	end
	local artscale = SoraDFIsRA() and data.artscale_ar or data.artscale_en
	obj.fields.Load_title:setScale(artscale)
	local artWord = SoraDFIsRA() and data.artWord_ar or data.artWord_en
	obj.fields.Load_title:setURL(artWord)
	local timer = clientEventMgr.getEventTimer(activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		obj.fields.Label_time:beginTime(leftTime)
	end
end
function HomePopupPanel:onClickGo(EventContext)
	SoraDPlaySound()
	local activityID = self.activityList[self.curSelect]
	self:closePanel()
	clientEventMgr.singleClickEvent(activityID)
end
function HomePopupPanel:getRealSelectedIndex(curSelect)
	if SoraDFIsRA() then
		return self.itemMax - curSelect
	else
		return curSelect - 1
	end
end
function HomePopupPanel:refreshActivityList(...)
	self.activityList = self.proxy:getActivityList()
	self.itemMax = #self.activityList
	if self.itemMax == 0 then
		self:close()
		return
	end
	self.fields.List_point:setNumItems(self.itemMax)
	self.curSelect = math.min(self.curSelect, self.itemMax)
	local selectedIndex = self:getRealSelectedIndex(self.curSelect)
	self.fields.List_point:setSelectedIndex(selectedIndex)
	self:refreshComPage()
end
return HomePopupPanel
