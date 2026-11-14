local activity_9001658_Read = include("activity_9001658_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001658_GuidePanel = class("Activity_9001658_GuidePanel", baseFguiPanel)
function Activity_9001658_GuidePanel:ctor(...)
	Activity_9001658_GuidePanel.super.ctor(self, ...)
	print("Activity_9001658_GuidePanel:ctor", self.viewName)
	self.debug = true
	self.moveTime = 0.3
end
function Activity_9001658_GuidePanel:onInit()
	print("=======Activity_9001658_GuidePanel:onInit")
	self.fields.Com_dialog:addClickListener(handler(self, self.onClickBtnNext))
	local _fields = fguiHelper.get_fields(self.fields.Com_dialog)
	if SoraDFIsRA() then
		_fields.arrow_en:setVisible(false)
	else
		_fields.arrow:setVisible(false)
	end
	if not self.param then
		_ENV = self.param
	end
	self.param = self.param
	local storyID = self.param.storyID or 1
	local activityID = self.param.activityID
	if activityID then
		storyID = activity_9001658_Read.getActivityIDStage(activityID) or 1
	end
	local order = self.param.order or 1
	local _ENV, ret = activityID, activityID
	local _ENV, bustMap = handler(self, self.onClickBtnNext)
	local config = activity_9001658_Read.getStoryConfig(storyID)
	for i, cfg in ipairs(config) do
		local camp = cfg.camp
		if cfg.order == order and camp ~= 0 then
			table.insert(ret, cfg)
			if not bustMap[camp] then
				_ENV = bustMap[camp]
			end
			bustMap[camp] = bustMap[camp]
			local bustName = activity_9001658_Read.getCharacterBust(cfg.characterID)
			bustMap[camp][bustName] = true
		end
	end
	self.dialogList = ret
	self.dialogIndex = 1
	for camp, map in pairs(bustMap) do
		local bustList = table.keys(map)
		bustMap[camp] = bustList
	end
	self.bustMap = bustMap
	_UPVALUE2_ = pairs(bustMap)
	pairs(bustMap)[1] = 1
	pairs(bustMap)[2] = 2
	for __, camp in ipairs(pairs(bustMap)) do
		if not bustMap[camp] then
			local _ENV, bustList = bustMap[camp], bustMap[camp]
		end
		local count = #bustList
		local Com_bust = self.fields["Com_bust" .. camp]
		local _fields = fguiHelper.get_fields(Com_bust)
		for i = 1, 5 do
			local bust = _fields["bust" .. i]
			bust:setVisible(false)
		end
		if count == 2 then
			for index, bustName in ipairs(bustList) do
				local bust = _fields["bust" .. index + 3]
				bust:setURL(bustName)
				bust:setVisible(true)
			end
		else
			for index, bustName in ipairs(bustList) do
				local bust = _fields["bust" .. index]
				bust:setURL(bustName)
				bust:setVisible(true)
			end
		end
	end
	self:showDialog()
end
function Activity_9001658_GuidePanel:onShow()
	print("=======Activity_9001658_GuidePanel:onShow")
end
function Activity_9001658_GuidePanel:showDialog(...)
	local cfg = self.dialogList[self.dialogIndex]
	local camp = cfg.camp
	local _fields = fguiHelper.get_fields(self.fields.Com_dialog)
	_fields.text_dialog:setString(i18n(cfg.text))
	local name = activity_9001658_Read.getCharacterName(cfg.characterID)
	_fields.name:setString(name)
	local bustName = activity_9001658_Read.getCharacterBust(cfg.characterID)
	local bustList = self.bustMap[camp]
	local count = #bustList
	local index = table.indexof(bustList, bustName)
	local Com_bust = self.fields["Com_bust" .. camp]
	local _fields2 = fguiHelper.get_fields(Com_bust)
	for i = 1, 3 do
		local bust
		if count == 2 then
			bust = _fields2["bust" .. i + 3]
		else
			bust = _fields2["bust" .. i]
		end
		if bust then
			local isShow = index == i
			bust:setGrayed(not isShow)
			bust:setSortingOrder(isShow and 1 or 0)
		end
	end
	local oldCamp = self.camp
	if self.camp ~= camp then
		self.camp = camp
		local Com_bust_new, Com_bust_old, posX
		if self.camp == 1 then
			Com_bust_new = self.fields.Com_bust1
			Com_bust_old = self.fields.Com_bust2
			posX = 280
		elseif self.camp == 2 then
			Com_bust_new = self.fields.Com_bust2
			Com_bust_old = self.fields.Com_bust1
			posX = 360
		end
		if oldCamp then
			Com_bust_old:setPositionX(320)
			Com_bust_old:setAlpha(1)
			activity_9001658_Read = bust
			bust[1] = ffa.fadeOut(self.moveTime)
			bust[2] = ffa.moveTo(self.moveTime, 640 - posX, Com_bust_old:getPositionY())
			bust[3] = ffa.moveTo(self.moveTime, 640 - posX, Com_bust_old:getPositionY())
			bust[4] = ffa.moveTo(self.moveTime, 640 - posX, Com_bust_old:getPositionY())
			bust[5] = ffa.moveTo(self.moveTime, 640 - posX, Com_bust_old:getPositionY())
			bust[6] = ffa.moveTo(self.moveTime, 640 - posX, Com_bust_old:getPositionY())
			Com_bust_old:runAction(ffa.spawn(bust))
		else
			Com_bust_old:setVisible(false)
		end
		Com_bust_new:setVisible(true)
		Com_bust_new:setPositionX(posX)
		Com_bust_new:setAlpha(0)
		activity_9001658_Read = ffa.spawn(bust)
		ffa.spawn(bust)[1] = ffa.fadeIn(self.moveTime)
		ffa.spawn(bust)[2] = ffa.moveTo(self.moveTime, 320, Com_bust_new:getPositionY())
		ffa.spawn(bust)[3] = ffa.moveTo(self.moveTime, 320, Com_bust_new:getPositionY())
		ffa.spawn(bust)[4] = ffa.moveTo(self.moveTime, 320, Com_bust_new:getPositionY())
		ffa.spawn(bust)[5] = ffa.moveTo(self.moveTime, 320, Com_bust_new:getPositionY())
		ffa.spawn(bust)[6] = ffa.moveTo(self.moveTime, 320, Com_bust_new:getPositionY())
		Com_bust_new:runAction(ffa.spawn(ffa.spawn(bust)))
	end
end
function Activity_9001658_GuidePanel:onClickBtnNext(...)
	SoraDPlaySound()
	self.dialogIndex = self.dialogIndex + 1
	if self.dialogIndex > #self.dialogList then
		local Com_bust, posX
		if self.camp == 1 then
			Com_bust = self.fields.Com_bust1
			posX = 280
		elseif self.camp == 2 then
			Com_bust = self.fields.Com_bust2
			posX = 360
		end
		Com_bust:setPositionX(320)
		Com_bust:setAlpha(1)
		_UPVALUE1_ = nil
		_UPVALUE1_ = nil
		;(nil)[1] = ffa.fadeOut(self.moveTime)
		;(nil)[2] = ffa.moveTo(self.moveTime, posX, Com_bust:getPositionY())
		;(nil)[3] = ffa.moveTo(self.moveTime, posX, Com_bust:getPositionY())
		;(nil)[4] = ffa.moveTo(self.moveTime, posX, Com_bust:getPositionY())
		;(nil)[5] = ffa.moveTo(self.moveTime, posX, Com_bust:getPositionY())
		;(nil)[6] = ffa.moveTo(self.moveTime, posX, Com_bust:getPositionY())
		;(nil)[1] = ffa.spawn(nil)
		;(nil)[2] = ffa.callFunc(function(...)
			self:closePanel()
		end)
		;(nil)[3] = ffa.callFunc(function(...)
			self:closePanel()
		end)
		;(nil)[4] = ffa.callFunc(function(...)
			self:closePanel()
		end)
		;(nil)[5] = ffa.callFunc(function(...)
			self:closePanel()
		end)
		;(nil)[6] = ffa.callFunc(function(...)
			self:closePanel()
		end)
		;(nil)[7] = ffa.callFunc(function(...)
			self:closePanel()
		end)
		;(nil)[8] = ffa.callFunc(function(...)
			self:closePanel()
		end)
		Com_bust:runAction(ffa.seq(nil))
	else
		self:showDialog()
	end
end
function Activity_9001658_GuidePanel:onClickBg(...)
	self:onClickBtnNext()
end
return Activity_9001658_GuidePanel
