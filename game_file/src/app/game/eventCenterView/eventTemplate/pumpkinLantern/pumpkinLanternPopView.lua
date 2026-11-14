local pumpkinLanternRead = include("pumpkinLanternRead")
local eventQuestRead = include("eventQuestRead")
local pumpkinLanternPopView = class("pumpkinLanternPopView", function(target)
	return target or SoraDCreateTouchPanel("pumpkinLanternPopView")
end)
function pumpkinLanternPopView:ctor()
	self.awardArray, _ENV = nil, nil
	self.boxBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.boxBg:setTitleName(i18n("decrypt_text_02"))
	self.btnGo = SoraDGetChildByName(self, "Button_get")
	self.btnGo:addTouchEventListener(handler(self, self.btnClickGo))
	self.btnGo:setTitleText(i18n("common_text_477"))
	self.textTitle = SoraDGetChildByName(self, "Text_Name")
	self.textTitle:setString(i18n("kits_title_01"))
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.nodeInfo = SoraDGetChildByName(self, "Node_info")
	self.node_progressBar = SoraDGetExtendChildFromCCSByName(self.nodeInfo, "CCS_commonProgressBar_bar")
	self.node_targetIcon = SoraDGetExtendChildFromCCSByName(self.nodeInfo, "CCS_questTargetIcon_icon")
	self.textTaskName = SoraDGetChildByName(self.nodeInfo, "Text_target")
	SoraDChangeTextToHtml(self.textTaskName)
end
function pumpkinLanternPopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.upData))
end
function pumpkinLanternPopView:initData(data, parent)
	dump(data, "data", 10)
	self.taskID = data.taskID
	self.view = parent
	self.guideId = data.guideId
	self.award = data.award
	self.strDes = data.taskDes
	_ENV = nil
	_ENV, _ENV, (nil).num = nil, self.strDes.num or "", self.strDes.num or ""
	;(nil).color = "#ffff00"
	;(self.strDes.num or "").num, (nil).i = nil, "true"
	self.textTaskName:setString(i18n_html(self.strDes[1], nil, self.strDes.num or ""))
	_ENV = i18n_html(self.strDes[1], nil, self.strDes.num or "")
	i18n_html(self.strDes[1], nil, self.strDes.num or "").maxValue = data.total
	i18n_html(self.strDes[1], nil, self.strDes.num or "").curValue = data.count
	self.node_progressBar:setProgressDate(i18n_html(self.strDes[1], nil, self.strDes.num or ""))
	self:initAwardData()
end
function pumpkinLanternPopView:upData(target, data)
	if data and data.activityID ~= gActivityTimeActivityID.PUMPKIN_ACTIVITY then
		return
	end
	local dataInfo = self.view:getTaskInfoyTaskID(self.taskID)
	_ENV = nil
	;(nil).maxValue = dataInfo.total
	;(nil).curValue = dataInfo.count
	self.node_progressBar:setProgressDate(nil)
	if dataInfo.total <= dataInfo.count then
		self:close(self, ccui.TouchEventType.ended)
	end
end
function pumpkinLanternPopView:initAwardData()
	for k, v in ipairs(self.award) do
		self.awardArray[k] = include("commonItemAward").new()
		self.awardArray[k]:setScale(0.8)
		self.awardArray[k]:setBaseScale(1.0)
		self.awardArray[k]:setOwnView(self)
		self.awardArray[k]:setPosition(0, 0)
		self.awardArray[k]:addTo(self.nodeAward)
		self.awardArray[k]:initData(v.id, v.count)
	end
	SoraDToCenter(self.nodeAward, 100, SoraDFIsRA())
end
function pumpkinLanternPopView:btnClickGo(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.guideId then
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			local tbParam = mildGuideManager:splitGuideParam(self.guideId)
			if tbParam.id == gNewPLayerTaskType.POP_TIP then
				_ENV = nil
				;(nil).num = self.strDes.num or ""
				SoraDShowMsgTip(i18n(self.strDes[1], nil))
			end
			local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(self.guideId)
			if not notNeedClose then
				SoraDRemoveAllPanelFromManager()
			end
		end
	end
end
return pumpkinLanternPopView
