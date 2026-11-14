local publicRead = include("publicRead")
local bloodyHeroesCtrl = SoraDGetCtrl("bloodyHeroesCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local groomHorsesAndTroops = include("groomHorsesAndTroops")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local bloodyHeroesView = class("bloodyHeroesView", groomHorsesAndTroops)
function bloodyHeroesView:ctor()
	self:initControls()
	self:initTaskScroll()
end
function bloodyHeroesView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.initTaskScroll))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_RESET_TASK", handler(self, self.initTaskScroll))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.initTaskScroll))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function bloodyHeroesView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_target")
	self.Top_Size_ScrollView = include("commonAutoScrollList").new(self.Top_Size_ScrollView)
	self.Top_Size_ScrollView:setSingleCCS("bloodyHeroesItem")
	self.ccs_title:setTitle(i18n("activity_name_9001355"))
	self.btnHelpTip:addTouchEventListener(handler(self, self.buttonHelpCallBack))
	self.btnHelpTip:setVisible(false)
	self.Image_event:loadTexture("bg_activity_9001355.png", ccui.TextureResType.plistType)
	self.Image_event:setPositionY(self.Image_event:getPositionY() + 30)
	self.activityID = gActivityTimeActivityID.IRON_BLOOD_ACTIVITY
	self.Text_reset:setString(i18n("task_text_02"))
	self.Image_14:setVisible(false)
	self.Image_13:setVisible(false)
end
function bloodyHeroesView:buttonHelpCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "tip_text_03"
		;("tip_text_03").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("tip_text_03"), "tip_text_03")
	end
end
function bloodyHeroesView:initTaskScroll()
	SoraDCloseLoading(self)
	print("skdflksjdf", bloodyHeroesCtrl:isResetEveryday())
	local serverData = activityTaskComponentCtrl:getQuestData(self.activityID)
	self.taskList = eventQuestRead.getSortList(self.activityID, serverData)
	dump(self.taskList, "fjkdsfjdkfjdkfjk")
	_ENV = bloodyHeroesCtrl:isResetEveryday()
	bloodyHeroesCtrl:isResetEveryday().scroll = self.Top_Size_ScrollView
	bloodyHeroesCtrl:isResetEveryday().view = self
	bloodyHeroesCtrl:isResetEveryday().activityID = self.activityID
	bloodyHeroesCtrl:isResetEveryday().mainView = self
	self.Top_Size_ScrollView:updateScrollView(cc.size(640, 154), self.taskList, 1, bloodyHeroesCtrl:isResetEveryday())
	if next(self.taskList) then
		self.Text_reset:setVisible(self.taskList[1].type == 1)
	end
end
function bloodyHeroesView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return bloodyHeroesView
