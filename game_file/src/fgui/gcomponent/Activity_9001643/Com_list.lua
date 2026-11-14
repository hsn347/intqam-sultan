local activity_9001643_Ctrl = SoraDGetCtrl("activity_9001643_Ctrl")
local activity_9001643_Read = include("activity_9001643_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001643/Com_list", Com_list)
function Com_list:onInit()
	self.reward, _ENV = nil, nil
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.touch:addClickListener(handler(self, self.btnClick))
	self.fields.Text_status = SoraDCreateTimerLabel(self, self.fields.Text_status)
	self:fixChildrenPos()
	self.fields.sheer:fix()
end
function Com_list:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_list:onShow()
end
function Com_list:initData(data)
	self.data = data
	self.fields.Lab_title:setString(i18n(data.chapter_name))
	self.fields.icon:setSpriteFrame(data.showbg)
	activity_9001643_Read = data.showbg
	data.showbg[1] = "id"
	data.showbg[2] = "count"
	self.reward = serviceFunctions.tableFormat(data.reward, data.showbg)
	self.fields.List_reward:setNumItems(#self.reward)
	local num, isAllDone = activity_9001643_Ctrl:getChapterReward(self.data.chapter)
	for _, taskID in ipairs(self.data.task_id) do
		local status = activity_9001643_Ctrl:getTaskStatus(taskID)
		if activity_9001643_Ctrl:isTaskUnlock(self.data.chapter, taskID) and status == activity_9001643_Read.TASK_STATUS_ENUM.NONE then
			num = num + 1
		end
	end
	self.fields.Label_reddot:initData(0 < num, num)
	if isAllDone then
		self.fields.Text_status:endTime()
		self.fields.Text_status:setString(i18n("eidal_celebration_text33"))
		self.fields.Text_status:setColor(cc.c3b(0, 255, 42))
	else
		local isUnLock = activity_9001643_Ctrl:isChapterUnlock(self.data.chapter)
		self.fields.Text_status:setColor(cc.c3b(255, 243, 176))
		if isUnLock then
			local doneNum, isAllComplete = activity_9001643_Ctrl:getChapterDoneTask(self.data.chapter)
			self.fields.Text_status:endTime()
			_ENV = cc.c3b(255, 243, 176)
			cc.c3b(255, 243, 176).num = doneNum
			cc.c3b(255, 243, 176).limit = #self.data.task_id
			self.fields.Text_status:setString(i18n("eidal_celebration_text32", cc.c3b(255, 243, 176)))
		else
			self.fields.Text_status:setTimeLast(function(time)
				_ENV = nil
				;(nil).time = time
				return i18n("Gather_text_02", nil)
			end)
			self.fields.Text_status:setTimeEndListener(function()
				self = nil
				;(nil).num = 0
				;(nil).limit = #self.data.task_id
				self.fields.Text_status:setString(i18n("eidal_celebration_text32", nil))
			end)
			local leftTime = activity_9001643_Ctrl:getChapterUnlockTime(self.data.chapter)
			if 0 < leftTime then
				self.fields.Text_status:beginTime(leftTime)
			else
				_ENV = i18n("eidal_celebration_text32", cc.c3b(255, 243, 176))
				i18n("eidal_celebration_text32", cc.c3b(255, 243, 176)).num = 0
				i18n("eidal_celebration_text32", cc.c3b(255, 243, 176)).limit = #self.data.task_id
				self.fields.Text_status:setString(i18n("eidal_celebration_text32", i18n("eidal_celebration_text32", cc.c3b(255, 243, 176))))
			end
		end
	end
end
function Com_list:btnClick()
	SoraDPlaySound()
	local isUnLock = activity_9001643_Ctrl:isChapterUnlock(self.data.chapter)
	local leftTime = activity_9001643_Ctrl:getChapterUnlockTime(self.data.chapter)
	if not isUnLock and 0 < leftTime then
		SoraDShowMsgTip(i18n("eidal_celebration_text40"))
		return
	end
	local preChapter = self.data.chapter - 1
	if 0 < preChapter then
		local doneNum, isAllComplete = activity_9001643_Ctrl:getChapterDoneTask(preChapter)
		if not isAllComplete then
			SoraDShowMsgTip(i18n("eidal_celebration_text41"))
			return
		end
	end
	_ENV = i18n("eidal_celebration_text41")
	i18n("eidal_celebration_text41").cfg = self.data
	uiManager:show("Activity_9001643_Chapter", i18n("eidal_celebration_text41"))
end
return Com_list
