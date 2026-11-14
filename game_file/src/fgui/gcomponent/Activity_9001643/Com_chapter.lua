local activity_9001643_Ctrl = SoraDGetCtrl("activity_9001643_Ctrl")
local activity_9001643_Read = include("activity_9001643_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_chapter = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001643/Com_chapter", Com_chapter)
function Com_chapter:onInit()
	self.reward, _ENV = nil, nil
	self.tag = 1
	self.fields.Text_tip:setString(i18n("eidal_celebration_text36"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_claim:setString(i18n("common_text_1146"))
	self.fields.Btn_claim:addClickListener(handler(self, self.btnClaimClick))
	self.fields.Text_progress = SoraDCreateTimerLabel(self, self.fields.Text_progress)
end
function Com_chapter:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_chapter:onShow()
end
function Com_chapter:onTabClick(tag)
	self.tag = tag
	local isTaskUnlock = activity_9001643_Ctrl:isTaskUnlock(self.cfg.chapter, self.taskList[self.tag])
	if not isTaskUnlock then
		SoraDShowMsgTip(i18n("eidal_celebration_text42"))
	end
	self.fields.Com_task:initData(self.taskList[self.tag], self.tag, self.cfg.chapter)
end
function Com_chapter:initData(cfg)
	self.taskList, _ENV, self.cfg = nil, nil, cfg
	_ENV = nil
	;(nil).num = self.cfg.chapter
	;(nil).chapter = i18n(self.cfg.chapter_name)
	self.fields.Text_chapterName:setString(i18n("eidal_celebration_text1", nil))
	activity_9001643_Read = i18n("eidal_celebration_text1", nil)
	i18n("eidal_celebration_text1", nil)[1] = "id"
	i18n("eidal_celebration_text1", nil)[2] = "count"
	self.reward = serviceFunctions.tableFormat(self.cfg.reward, i18n("eidal_celebration_text1", nil))
	self.fields.List_reward:setNumItems(#self.reward)
	local _ENV, tabsetArray = self.fields.List_reward.setNumItems, self.fields.List_reward.setNumItems
	local tag_accpet, tag_go, tag_reward
	for k, v in ipairs(self.cfg.task_id) do
		table.insert(self.taskList, v)
		_ENV = v
		_ENV = i18n("eidal_celebration_text1", nil)
		i18n("eidal_celebration_text1", nil).num = k
		v.title = i18n("eidal_celebration_text3", i18n("eidal_celebration_text1", nil))
		v.tag = k
		table.insert(tabsetArray, v)
		local status = activity_9001643_Ctrl:getTaskStatus(v)
		local isTaskUnlock = activity_9001643_Ctrl:isTaskUnlock(self.cfg.chapter, v)
		local isReward = isTaskUnlock and status == activity_9001643_Read.TASK_STATUS_ENUM.COMPLETE
		local isGo = isTaskUnlock and status == activity_9001643_Read.TASK_STATUS_ENUM.NONE
		local isAccpet = isTaskUnlock and status == activity_9001643_Read.TASK_STATUS_ENUM.ACCPET
		if not tag_accpet and isAccpet then
			tag_accpet = k
		end
		if not tag_go and isGo then
			tag_go = k
		end
		if not tag_reward and isReward then
			tag_reward = k
		end
	end
	self.tag = tag_reward or tag_accpet or tag_go or 1
	_ENV = ipairs(self.cfg.task_id)
	ipairs(self.cfg.task_id).defaultClick = self.tag
	ipairs(self.cfg.task_id).tabsetArray = tabsetArray
	ipairs(self.cfg.task_id).callback = handler(self, self.onTabClick)
	self.fields.Com_tab:initView(ipairs(self.cfg.task_id))
	for k, v in ipairs(self.cfg.task_id) do
		local status = activity_9001643_Ctrl:getTaskStatus(v)
		local isTaskUnlock = activity_9001643_Ctrl:isTaskUnlock(self.cfg.chapter, v)
		local isReward = isTaskUnlock and status == activity_9001643_Read.TASK_STATUS_ENUM.COMPLETE
		local isGo = isTaskUnlock and status == activity_9001643_Read.TASK_STATUS_ENUM.NONE
		self.fields.Com_tab:setBtnRedDot(k, isReward or isGo or false)
	end
	self.isUnlock = activity_9001643_Ctrl:isChapterUnlock(self.cfg.chapter)
	if self.isUnlock then
		local doneNum, isAllComplete = activity_9001643_Ctrl:getChapterDoneTask(self.cfg.chapter)
		self.fields.Text_progress:endTime()
		if doneNum >= #self.cfg.task_id then
			self.fields.Text_progress:setString(i18n("eidal_celebration_text33"))
		else
			_ENV = i18n("eidal_celebration_text33")
			i18n("eidal_celebration_text33").num = doneNum
			i18n("eidal_celebration_text33").limit = #self.cfg.task_id
			self.fields.Text_progress:setString(i18n("eidal_celebration_text7", i18n("eidal_celebration_text33")))
		end
		self.isClaimed = activity_9001643_Ctrl:isChapterRewardClaimed(self.cfg.chapter)
		self.fields.Btn_claim:setString(i18n("common_text_1146"))
		self.fields.Btn_claim:setBright(isAllComplete and not self.isClaimed)
	else
		self.fields.Text_progress:setTimeLast(function(time)
			_ENV = nil
			;(nil).time = time
			return i18n("Gather_text_02", nil)
		end)
		self.fields.Text_progress:setTimeEndListener(function()
			self = nil
			;(nil).num = 0
			;(nil).limit = #self.cfg.task_id
			self.fields.Text_status:setString(i18n("eidal_celebration_text7", nil))
		end)
		local leftTime = activity_9001643_Ctrl:getChapterUnlockTime(self.cfg.chapter)
		if 0 < leftTime then
			self.fields.Text_progress:beginTime(leftTime)
		else
			_ENV = i18n("common_text_1146")
			i18n("common_text_1146").num = 0
			i18n("common_text_1146").limit = #self.cfg.task_id
			self.fields.Text_progress:setString(i18n("eidal_celebration_text7", i18n("common_text_1146")))
		end
		self.fields.Btn_claim:setString(i18n("common_text_2274"))
		self.fields.Btn_claim:setBright(false)
	end
end
function Com_chapter:btnClaimClick()
	SoraDPlaySound()
	if not self.isUnlock then
		SoraDShowMsgTip(i18n("eidal_celebration_text37"))
		return
	end
	if self.isClaimed then
		SoraDShowMsgTip(i18n("common_text_1892"))
		return
	end
	local doneNum, isAllComplete = activity_9001643_Ctrl:getChapterDoneTask(self.cfg.chapter)
	if not isAllComplete then
		SoraDShowMsgTip(i18n("eidal_celebration_text38"))
	else
		activity_9001643_Ctrl:reqClaimChapterReward(self.cfg.chapter)
	end
end
return Com_chapter
