local gametop = gModuleMgr.getObject("gametop")
local trainPowerCtrl = SoraDGetCtrl("trainPowerCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local royalSummonsUtil = include("royalSummonsUtil")
_ENV = "royalSummonsUtil"
;("royalSummonsUtil").noClaim = 1
;("royalSummonsUtil").noReach = 2
local ("royalSummonsUtil").claimed, giftStatus = 3, "royalSummonsUtil"
local trainPowerView = class("trainPowerView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("trainPowerView")
end)
function trainPowerView:ctor(properties)
	self.activityID = gActivityTimeActivityID.TRAIN_POWER_ACTIVITY
	self.scroll = SoraDGetChildByName(self, "Bottom_Size_ScrollView_item")
	self.Top_Node_ani = SoraDGetChildByName(self, "Top_Node_ani")
	self.Image_title = SoraDGetChildByName(self, "Image_title")
	self.Button_quit = SoraDGetChildByName(self, "Button_quit")
	self.Button_quit:addTouchEventListener(handler(self, self.clickQuitBtn))
	self.Image_title:loadTexture(SoraDFIsRA() and "frame_9001300_font_ar.png" or "frame_9001300_font_en.png", ccui.TextureResType.plistType)
	self.Image_title:getParent():reorderChild(self.Image_title, 2)
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("trainPowerTaskItem")
	trainPowerCtrl:reqInitData()
	SoraDShowLoading(self)
	SoraDCreatAnimation(self.__cname, self, false)
	self.FileNode_tip = SoraDGetChildByName(self, "FileNode_tip")
	SoraDCreatAnimationEx("Node_Effect_trainPower_Top", self.FileNode_tip, true)
	self.FileNode_tip.action:gotoFrameAndPlay(0, true)
end
function trainPowerView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_TRAIN_POWER_INIT", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_TRAIN_POWER_NOTIFY", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_TRAIN_POWER_ERR", handler(self, self.getError))
	SoraDAddMessage(self, "MESSAGE_TRAIN_POWER_CLAIM_REWARD", handler(self, self.getAction))
end
function trainPowerView:getAction(target, data)
	local reward = data.reward
	local _ENV, itemData
	for i, v in ipairs(reward) do
		_ENV = nil
		;(nil).id = v.id
		;(nil).count = v.count
		table.insert(itemData, nil)
	end
	SoraDMailGainItems(itemData, true)
end
function trainPowerView:getError()
	print("getError")
	SoraDCloseLoading(self)
	SoraDRemoveAllAfterPanelFromManager(self)
end
function trainPowerView:initData()
	SoraDCloseLoading(self)
	self:ininScroll()
	self:judgeIsOpen()
end
function trainPowerView:ininScroll()
	local data = trainPowerCtrl:getQuestData()
	trainPowerCtrl = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(563, 128), data, 1, nil)
end
function trainPowerView:onClose()
	_ENV = nil
	;(nil).byUID = true
	local ret = SoraDConfigGet("Game:trainPowerView:first~bool", nil)
	if ret then
		local data = trainPowerCtrl:getQuestData()[1]
		dump(data, "第一次点击引导")
		if data and data.taskDes then
			print("royalSummonsUtil:skipTo")
			self:skipTo(data, data.taskDes)
		end
		_ENV = data.taskDes
		data.taskDes.byUID = true
		SoraDConfigSet("Game:trainPowerView:first~bool", false, data.taskDes)
	else
	end
end
function trainPowerView:skipTo(data, taskDes)
	local guideId = data.guideId
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local tbParam = mildGuideManager:splitGuideParam(guideId)
	if guideId then
		local lang = taskDes[1]
		if not lang or lang == "" then
			lang = "NA"
		end
		_ENV = nil
		;(nil).num = taskDes.num or ""
		;(nil).lv = taskDes.lv or ""
		tbParam.msg = i18n(lang, nil)
		tbParam.minLv = taskDes.lv
		local ret, notNeedClose = mildGuideManager:starMildByNewPlayerQuestID(tbParam.id, tbParam)
	end
end
function trainPowerView:judgeIsOpen()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function trainPowerView:clickQuitBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return trainPowerView
