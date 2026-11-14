local sultansBackRead = include("sultansBackRead")
local sultansBackLoginTaskAwardPop = class("sultansBackLoginTaskAwardPop", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("sultansBackLoginTaskAwardPop")
end)
function sultansBackLoginTaskAwardPop:ctor()
	self.nodeCommonPopBox = SoraDGetChildByName(self, "CCS_commonPopBox_bg")
	SoraDGetChildByName(self.nodeCommonPopBox, "Text_name"):setString(i18n("common_text_1235"))
	self.textDescribe = SoraDGetChildByName(self, "Text_describe")
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("friend_back_text18"))
	self.Text_tip:setVisible(false)
	self.btnOk = SoraDGetChildByName(self, "Button_ok")
	self.btnOk:addTouchEventListener(handler(self, self.btnOkClick))
end
function sultansBackLoginTaskAwardPop:initData(index, status, isDay)
	print("index,status,isDay=====", index, status, isDay)
	local _ENV, rewarConfig = print, print
	if isDay then
		rewarConfig = sultansBackRead.getLoginRewardByDay(index)
		_ENV = nil
		;(nil).day = index
		self.textDescribe:setString(i18n("friend_return_text_03", nil))
	else
		rewarConfig = sultansBackRead.getLoginCunsumByIndex(index)
		_ENV = i18n("friend_return_text_03", nil)
		i18n("friend_return_text_03", nil).day = rewarConfig.num
		self.textDescribe:setString(i18n("friend_return_text_02", i18n("friend_return_text_03", nil)))
	end
	_UPVALUE2_ = i18n("friend_return_text_02", i18n("friend_return_text_03", nil))
	i18n("friend_return_text_02", i18n("friend_return_text_03", nil))[1] = "id"
	i18n("friend_return_text_02", i18n("friend_return_text_03", nil))[2] = "count"
	local awardList = serviceFunctions.tableFormat(rewarConfig.reward, i18n("friend_return_text_02", i18n("friend_return_text_03", nil)))
	for i, v in ipairs(awardList) do
		local itemNode = include("commonItemAward").new()
		itemNode:setScale(0.8)
		itemNode:setBaseScale(1.0)
		itemNode:setOwnView(self)
		itemNode:addTo(self.nodeAward)
		itemNode:initData(v.id, v.count)
		itemNode:setPosition(0, 0)
	end
	SoraDToCenter(self.nodeAward, 90)
	if status == gBtnTargetStatusDef.GO then
		self.Text_tip:setVisible(true)
		self.btnOk:setVisible(false)
	elseif status == gBtnTargetStatusDef.GET then
		self.btnOk:setVisible(true)
		self.btnOk:setTouchEnabled(true)
		self.btnOk:setBright(true)
		self.btnOk:setTitleText(i18n("common_text_204"))
		self.Text_tip:setVisible(false)
	elseif status == gBtnTargetStatusDef.GOT then
		self.btnOk:setVisible(true)
		self.btnOk:setTouchEnabled(false)
		self.btnOk:setBright(false)
		self.btnOk:setTitleText(i18n("common_text_1892"))
	end
end
function sultansBackLoginTaskAwardPop:btnOkClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		self:removeFromParent()
	end
end
return sultansBackLoginTaskAwardPop
