local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
local callFriendsBackTaskSingle = class("callFriendsBackTaskSingle", function(target)
	return SoraDCreateBasePanel("callFriendsBackTaskSingle")
end)
function callFriendsBackTaskSingle:ctor()
	self.desBgColor = "#D7C39B"
	self.scheduBgColor = "#D7C39B"
	self.scheduValeColor = "#6CDE00"
	self.itemArray, _ENV, self.desColor = nil, nil, "#FFBF00"
	self.Button_go = SoraDGetChildByName(self, "Button_go")
	self.Text_schedule = SoraDGetChildByName(self, "Text_schedule")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Node_Finish = SoraDGetChildByName(self, "Node_Finish")
	self.Text_Finish = SoraDGetChildByName(self, "Text_Finish")
	self.Node_Finish:setVisible(false)
	self.Text_des = _G.SoraDChangeTextToHtml(self.Text_des)
	self.Text_schedule = _G.SoraDChangeTextToHtml(self.Text_schedule)
	self.Button_go:addTouchEventListener(handler(self, self.btnGetRewardsClick))
end
function callFriendsBackTaskSingle:initData(data, otherData)
	self.data = data
	self.scroll = otherData.scroll
	self.view = otherData.view
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local awardList = serviceFunctions.tableFormat(self.data.Reward, nil)
	local callFriendData = sultansBackCtrl:getCallFriendData()
	for i, v in ipairs(awardList) do
		if not self.itemArray[i] then
			local itemAward = SoraDCreatePanel("commonItemAward")
			itemAward:setScale(0.7)
			itemAward:setBaseScale(1.0)
			itemAward:addTo(self, 9)
			itemAward:setOwnView(self.view)
			itemAward:setOwnScroll(self.scroll)
			self.itemArray[i] = itemAward
		else
			self.itemArray[i]:setVisible(true)
		end
		if SoraDFIsRA() then
			self.itemArray[i]:setPosition(580 - (i - 1) * 80, 60)
		else
			self.itemArray[i]:setPosition(60 + (i - 1) * 80, 60)
		end
		self.itemArray[i]:initData(v.id, v.count)
	end
	if #self.itemArray > #awardList then
		for i = #awardList + 1, #self.itemArray do
			self.itemArray[i]:setVisible(false)
		end
	end
	local lang = self.data.name[1]
	local targetNum = self.data.name.num
	local curCount = callFriendData.friendsNum or 0
	if not lang or lang == "" then
		lang = "NA"
	end
	_ENV = self.itemArray[i]
	_ENV, _ENV, self.itemArray[i].num = v.id, targetNum or "", targetNum or ""
	v.id.color = self.desColor
	_ENV, (targetNum or "").num, v.id.i = v.id, v.id, "true"
	;(targetNum or "").__default, v.id.color = v.id, self.desBgColor
	local str_des = _G.i18n_html(lang, self.itemArray[i], targetNum or "")
	if self.data.Type == 2 then
		curCount = callFriendData.rechargeSum
		local tempPrice = paymentManager.judgePrice(301, 9.9)
		_ENV = v.id
		v.id.num = targetNum or ""
		_ENV, _ENV, v.id.price = 9, targetNum or "", tempPrice
		;(9).color = self.desColor
		_ENV, (targetNum or "").num, (9).i = 9, 9, "true"
		;(targetNum or "").__default, (9).color = 9, self.desBgColor
		str_des = _G.i18n_html(lang, v.id, targetNum or "")
	end
	local isGetReward = callFriendData.rewardFlag[tostring(self.data.taskID)] or false
	self.Text_des:setString(str_des)
	self:setScheduleText(curCount, targetNum, isGetReward, self.Text_schedule)
	self:setBtnStatus(curCount, targetNum, isGetReward, self.Button_go)
	self.Button_go:setTag(self.data.taskID)
end
function callFriendsBackTaskSingle:setBtnStatus(curCount, totalCount, isGetReward, targetBtn)
	targetBtn:setVisible(totalCount <= curCount)
	targetBtn:setTitleText(curCount < totalCount and i18n("common_text_477") or not (not (totalCount <= curCount) or isGetReward) and i18n("common_text_1146") or isGetReward and i18n("common_text_1892"))
	targetBtn:setTitleColor(isGetReward and cc.c3b(120, 120, 120) or cc.c3b(255, 255, 255))
	targetBtn:loadTextureNormal(isGetReward and "btn_gray_small.png" or curCount < totalCount and "btn_yellow_small_01.png" or "btn_green_small_01.png", ccui.TextureResType.plistType)
	if isGetReward then
		targetBtn:setTouchEnabled(false)
	end
end
function callFriendsBackTaskSingle:setScheduleText(curCount, totalCount, isGetReward, targetTxt)
	local count = curCount
	local total = totalCount
	count = math.min(count, total)
	if isGetReward then
		scheduTotalColor = self.scheduBgColor
		scheduCountColor = self.scheduBgColor
	elseif curCount < totalCount then
		scheduTotalColor = self.scheduBgColor
		scheduCountColor = self.scheduColor
	elseif totalCount <= curCount then
		scheduTotalColor = self.scheduValeColor
		scheduCountColor = self.scheduValeColor
	end
	_ENV = count
	count.color = scheduCountColor
	local countStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(count), count)
	_ENV = "/%s"
	;("/%s").color = scheduTotalColor
	local totalStr = SoraDWrapHtmlTagByStyle(string.format("/%s", string.formatnumberthousands(total)), "/%s")
	local value = string.format("%s%s", countStr, totalStr)
	value = _pq(value)
	_ENV = string.formatnumberthousands(total)
	_ENV, _ENV, string.formatnumberthousands(total).value = string.formatnumberthousands(total)
	string.formatnumberthousands(total).__default, string.formatnumberthousands(total).color = string.formatnumberthousands(total)
	targetTxt:setString(_G.i18n_html("complete_text_05", string.formatnumberthousands(total)))
end
function callFriendsBackTaskSingle:btnGetRewardsClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		sultansBackCtrl:reqCallFriendsReward(button:getTag())
		SoraDShowLoading(self.view)
	end
end
return callFriendsBackTaskSingle
