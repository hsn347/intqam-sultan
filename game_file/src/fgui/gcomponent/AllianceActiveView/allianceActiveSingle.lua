local MAX_AWARD_NUM = 4
local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local allianceActiveltCtrl = include("allianceActiveltCtrl")
local allianceActiveCtrl = SoraDGetCtrl("allianceActiveCtrl")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
_ENV = "mildGuideManager"
;("mildGuideManager")[1] = "frame_alliance_huoyue_lv.png"
;("mildGuideManager")[2] = "frame_alliance_huoyue_lan.png"
;("mildGuideManager")[3] = "frame_alliance_huoyue_zi.png"
local ("mildGuideManager")[4], titlePng = "frame_alliance_huoyue_cheng.png", "mildGuideManager"
local baseComponent = require("fgui.base.baseComponent")
local allianceActiveSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceActiveView/allianceActiveSingle", allianceActiveSingle)
function allianceActiveSingle:onInit()
	self.awardArray, _ENV = nil, nil
	self.fields.Button_publish:setString(i18n("alliance_btn_01"))
	self.fields.Button_publish:addClickListener(handler(self, self.onPublishClick))
	self.fields.Button_accept:setString(i18n("alliance_btn_02"))
	self.fields.Button_accept:addClickListener(handler(self, self.onAcceptClick))
	self.fields.Button_accept:setVisible(false)
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onGoClick))
	self.fields.Button_go:setVisible(false)
	self.fields.Button_receive:setString(i18n("common_text_1146"))
	self.fields.Button_receive:addClickListener(handler(self, self.onReceiveClick))
	self.fields.Button_receive:setVisible(false)
	self.fields.Button_refresh:setString(i18n("common_text_911"))
	self.fields.Button_refresh:addClickListener(handler(self, self.onRefreshClick))
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
	self.fields.Image_title:fix()
end
function allianceActiveSingle:onShow()
end
function allianceActiveSingle:onItemRenderer(index, obj)
	obj:initData(self.awardArray[index + 1].id, self.awardArray[index + 1].count)
end
function allianceActiveSingle:initData(data, isPublish)
	self.data = data
	self.isPublish = isPublish or false
	self.fields.Button_publish:setVisible(self.isPublish)
	self.fields.Button_refresh:setVisible(self.isPublish)
	self.fields.Button_go:setVisible(not self.isPublish)
	self.fields.Button_accept:setVisible(not self.isPublish)
	self.fields.Button_receive:setVisible(not self.isPublish)
	self.fields.Text_status:setVisible(not self.isPublish)
	if not self.isPublish then
		self.fields.Button_accept:setVisible(self.data.status == 1)
		self.fields.Button_receive:setVisible(self.data.status == 3)
		self.fields.Button_go:setVisible(self.data.status == 2)
		self.fields.Text_status:setVisible(self.data.status == 0)
		self.fields.Text_status:setString(i18n("common_text_2601"))
		local isDoing = allianceActiveCtrl:isHaveDoingTask()
		self.fields.Button_accept:setEnabled(not isDoing)
		self.fields.Text_acceptNum:setVisible(self.data.status == 2 or self.data.status == 1)
		if self.data.status == 2 then
			local curCount = allianceActiveCtrl:getCurTaskProgress(self.data.index)
			_ENV = i18n("common_text_2601")
			i18n("common_text_2601").count = string.formatnumberthousands(curCount)
			i18n("common_text_2601").total = string.formatnumberthousands(self.data.aim)
			self.fields.Text_acceptNum:setString(i18n("common_text_3683", i18n("common_text_2601")))
		elseif self.data.status == 1 then
			_ENV = i18n("common_text_3683", i18n("common_text_2601"))
			i18n("common_text_3683", i18n("common_text_2601")).num = allianceActiveCtrl:getTaskAcceptCount(self.data.index)
			i18n("common_text_3683", i18n("common_text_2601")).max = self.data.task.acceptLimit
			self.fields.Text_acceptNum:setString(i18n("alliance_text_33", i18n("common_text_3683", i18n("common_text_2601"))))
		end
	else
		self.fields.Text_acceptNum:setVisible(true)
		_ENV = i18n("alliance_text_33", i18n("common_text_3683", i18n("common_text_2601")))
		i18n("alliance_text_33", i18n("common_text_3683", i18n("common_text_2601"))).num = self.data.task.acceptLimit
		self.fields.Text_acceptNum:setString(i18n("alliance_text_28", i18n("alliance_text_33", i18n("common_text_3683", i18n("common_text_2601")))))
	end
	self.fields.Image_title:setSpriteFrame(titlePng[self.data.task.quality])
	self.fields.Text_title:setString(i18n(self.data.des))
	self.needGold = allianceActiveltCtrl.getActiveGold(allianceActiveCtrl:getRefreshCount() + 1)
	self.fields.Button_refresh:setCostTitle(self.needGold)
	local isPublishNumLimited = allianceActiveCtrl:getCurPublishNum() < ALLIANCE_ACTIVE_MAX_PUBLISH_NUM
	self.fields.Button_publish:setEnabled(isPublishNumLimited)
	self.fields.Button_refresh:setEnabled(isPublishNumLimited)
	self:setReward()
end
function allianceActiveSingle:setReward()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.awardArray = serviceFunctions.tableFormat(self.data.task.reward, nil)
	self.fields.List_item:setNumItems(math.min(#self.awardArray, MAX_AWARD_NUM))
end
function allianceActiveSingle:onPublishClick()
	SoraDPlaySound()
	if allianceActiveCtrl:getCurPublishNum() >= ALLIANCE_ACTIVE_MAX_PUBLISH_NUM then
		SoraDShowMsgTip(i18n("alliance_text_29"))
	else
		allianceActiveCtrl:publishTask(self.data.index)
	end
end
function allianceActiveSingle:onAcceptClick()
	SoraDPlaySound()
	if allianceActiveCtrl:getMyTodayAcceptNum() >= ALLIANCE_ACTIVE_PERSON_DAILY_MAX_ACCEPT_NUM then
		SoraDShowMsgTip(i18n("alliance_text_35"))
	elseif allianceActiveCtrl:getTaskAcceptCount(self.data.index) >= self.data.task.acceptLimit then
		SoraDShowMsgTip(i18n("alliance_text_34"))
	else
		local isAccepted = allianceActiveCtrl:isAcceptedTask(self.data.index, gametop.playertop_:getPlayerID())
		if isAccepted then
			SoraDShowMsgTip(i18n("alliance_text_51"))
		else
			allianceActiveCtrl:acceptTask(self.data.index)
		end
	end
end
function allianceActiveSingle:onGoClick()
	SoraDPlaySound()
	local ret = mildGuideManager:starMildByNewPlayerStringParam(self.data.guideId)
	if ret ~= false then
		SoraDRemoveAllPanelFromManager()
	end
end
function allianceActiveSingle:onReceiveClick()
	SoraDPlaySound()
	allianceActiveCtrl:receiveReward(self.data.index)
end
function allianceActiveSingle:onRefreshClick()
	SoraDPlaySound()
	if SoraDEnoughGold(self.needGold) then
		allianceActiveCtrl:refreshTask(self.data.index)
	end
end
return allianceActiveSingle
