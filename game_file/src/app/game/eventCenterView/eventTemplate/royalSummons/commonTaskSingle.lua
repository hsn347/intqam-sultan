local MAX_AWARD_NUM = 7
local commonTaskSingle = class("commonTaskSingle", function(target)
	return target
end)
local gBtnTargetStatusDef = _G.gBtnTargetStatusDef
function commonTaskSingle:ctor()
	self.desColor = "#ffff00"
	self.desBgColor = "#d7c39b"
	self.scheduBgColor = "#d7c39b"
	self.scheduColor = "#be2828"
	self.awardArray, gBtnTargetStatusDef, self.data, gBtnTargetStatusDef, self.scheduValeColor = nil, nil, nil, nil, "#d7c39b"
	self.awardOffsetY = 70
	self.itemWidth = 640
	self.rewardOffsetX = 60
	self.taskStatus = gBtnTargetStatusDef.GO
	self.Button_go = SoraDGetChildByName(self, "Button_go")
	SoraDAutoSizeButtonText(self.Button_go, cc.size(120, 50))
	self.Button_go:setSwallowTouches(false)
	self.Button_go:setTitleText(i18n("common_text_477"))
	self.Button_go:addTouchEventListener(handler(self, self.btnOperateClick))
	self.Text_des = _G.SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_des"))
	self.Text_schedule = _G.SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_schedule"))
	self.itemScale = 1.0
	self.itemSepX = 90
end
function commonTaskSingle:setItemScale(itemScale)
	self.itemScale = itemScale
end
function commonTaskSingle:setItemSepX(itemSepX)
	self.itemSepX = itemSepX
end
function commonTaskSingle:setAwardOffsetY(offsetY)
	self.awardOffsetY = offsetY
end
function commonTaskSingle:setItemWidth(width)
	self.itemWidth = width
end
function commonTaskSingle:setRewardOffsetX(rewardOffsetX)
	self.rewardOffsetX = rewardOffsetX
end
function commonTaskSingle:initData_imp(data, otherData)
	self.data = data
	if otherData then
		self.view = otherData.view
		self.ownScroll = otherData.scroll
		self.scroll = otherData.scroll
		self.activityID = otherData.activityID
	end
	local lang = self.data.taskDes[1]
	if not lang or lang == "" then
		dump(self.data, "commonTaskSingle:initData_imp")
		lang = "NA"
	end
	print("commonTaskSingle", self.desBgColor)
	local targetNum = self.data.taskDes.num
	_ENV = nil
	;(nil).num = targetNum or ""
	_ENV, _ENV, (nil).lv = nil, self.data.taskDes.lv or "", self.data.taskDes.lv or ""
	;(nil).color = self.desColor
	_ENV, (self.data.taskDes.lv or "").num, (nil).i = nil, nil, "true"
	;(self.data.taskDes.lv or "").__default, (nil).color = nil, self.desBgColor
	local str_des = _G.i18n_html(lang, nil, self.data.taskDes.lv or "")
	self.Text_des:setString(str_des)
	self.taskStatus = self.data.taskStatus
	self:setScheduleText()
	self:setBtnStatus()
	self:setAward()
end
function commonTaskSingle:setScheduleText()
	local count = self.data.count
	local total = self.data.total
	count = math.min(count, total)
	local scheduTotalColor = self.scheduBgColor
	local scheduCountColor = self.scheduColor
	if self.taskStatus == gBtnTargetStatusDef.GOT then
		scheduTotalColor = self.scheduBgColor
		scheduCountColor = self.scheduBgColor
	elseif self.taskStatus == gBtnTargetStatusDef.GO then
		scheduTotalColor = self.scheduBgColor
		scheduCountColor = self.scheduColor
	elseif self.taskStatus == gBtnTargetStatusDef.GET then
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
	self.Text_schedule:setString(_G.i18n_html("complete_text_05", string.formatnumberthousands(total)))
end
function commonTaskSingle:setBtnStatus()
	self.Button_go:setBright(self.taskStatus ~= gBtnTargetStatusDef.GOT)
	self.Button_go:setTouchEnabled(self.taskStatus ~= gBtnTargetStatusDef.GOT)
	self.Button_go:setTitleText(self.taskStatus == gBtnTargetStatusDef.GO and i18n("common_text_477") or self.taskStatus == gBtnTargetStatusDef.GET and i18n("common_text_1146") or self.taskStatus == gBtnTargetStatusDef.GOT and i18n("common_text_1892"))
	self.Button_go:setTitleColor(self.taskStatus == gBtnTargetStatusDef.GOT and cc.c3b(120, 120, 120) or cc.c3b(255, 255, 255))
	self.Button_go:loadTextureNormal(self.taskStatus == gBtnTargetStatusDef.GOT and "btn_gray_small.png" or self.taskStatus == gBtnTargetStatusDef.GO and "btn_yellow_small_01.png" or "btn_green_small_01.png", ccui.TextureResType.plistType)
end
function commonTaskSingle:setAward()
	for i = 1, MAX_AWARD_NUM do
		if self.awardArray[i] then
			self.awardArray[i]:setVisible(false)
		end
	end
	for k, v in ipairs(self.data.award) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(0.8 * self.itemScale)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self.view)
			self.awardArray[k]:setOwnScroll(self.ownScroll)
			self.awardArray[k]:setScroll(self.ownScroll)
			self.awardArray[k]:setPosition(SoraDFPosX(self.itemWidth - (self.rewardOffsetX + (k - 1) * self.itemSepX), self.itemWidth), self.awardOffsetY)
			self.awardArray[k]:addTo(self, 1)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.count)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
		end
	end
end
function commonTaskSingle:btnOperateClick(button, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound(nil, nil, true)
		if self.taskStatus == gBtnTargetStatusDef.GET then
			self:doAction()
		elseif self.taskStatus == gBtnTargetStatusDef.GO then
			self:skipTo(self.data.taskDes)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return commonTaskSingle
